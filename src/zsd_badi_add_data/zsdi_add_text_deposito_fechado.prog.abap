*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_TEXT_DEPOSITO_FECHADO
*&---------------------------------------------------------------------*
    CONSTANTS: BEGIN OF lc_param_df,
                 modulo    TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1    TYPE ztca_param_par-chave1 VALUE 'DEPÓSITO FECHADO',
                 excecao   TYPE ztca_param_par-chave2 VALUE 'EXCEÇÕES',
                 local_ret TYPE ztca_param_par-chave2 VALUE 'LOCAL RETIRADA',
               END OF lc_param_df.

    DATA: ls_address     TYPE sadr,
          ls_branch_data TYPE j_1bbranch,
          lv_cgc_number  TYPE j_1bwfield-cgc_number,
          lv_linha       TYPE char950.

    DATA: lt_out_lines1 TYPE TABLE OF j_1bmessag,
          lt_werks_e    TYPE wrma_werks_ran_tab,
          lt_werks_lr   TYPE wrma_werks_ran_tab.

    DATA lv_skip_dep TYPE abap_bool VALUE abap_false.
    DATA lv_bln_int_transf_r TYPE abap_bool VALUE abap_false.
    DATA lv_bln_int_transf_e TYPE abap_bool VALUE abap_false.


    CLEAR: lv_texto,
           lv_cest_mask,
           lv_matnr.

    CONDENSE cs_header-infcpl.

    ASSIGN ('(SAPLJ1BG)WNFFTX[]') TO <fs_nfetx_tab>.
    IF NOT <fs_nfetx_tab> IS ASSIGNED.
      ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.
    ENDIF.

    DATA lv_werks_e TYPE werks_d.
    DATA lv_werks_r TYPE werks_d.

    IF is_header-direct EQ '2'. "Saída
      TRY.

          IF NOT <fs_nflin>-xped IS INITIAL AND
             NOT <fs_nflin>-nitemped IS INITIAL.
            DATA(lv_ebeln) = CONV ebeln( <fs_nflin>-xped ).
            DATA(lv_ebelp) = CONV ebelp( <fs_nflin>-nitemped ).
            SELECT COUNT( * )
              FROM ztmm_his_dep_fec
             WHERE purchase_order EQ @lv_ebeln
               AND purchase_order_item EQ @lv_ebelp.
            IF sy-subrc EQ 0.
              lv_skip_dep = abap_true.
            ENDIF.
          ENDIF.

          IF lv_skip_dep EQ abap_false.

            TRY.
                lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                                 iv_chave1 = lc_param_df-chave1
                                                 iv_chave2 = lc_param_df-excecao
                                       IMPORTING et_range  = lt_werks_e ).

                CASE <fs_nflin>-reftyp.
                  WHEN 'MD'.

                    SELECT SINGLE werks_origem,
                                  werks_destino,
                                  werks_receptor,
                                  processo,
                                  tipooperacao
                      FROM ztsd_intercompan
                      INTO @DATA(ls_transf)
                     WHERE purchaseorder EQ @<fs_nflin>-xped
                       AND werks_origem EQ @<fs_nflin>-werks
                       AND processo = '1'.
                    IF sy-subrc EQ 0.

                      lv_werks_e = lt_werks_e[ low = ls_transf-werks_destino ]-high.
                      DATA(lv_lifn2) = |{ CONV lifn2( lv_werks_e ) ALPHA = IN }|.

                      SELECT COUNT( * )
                        FROM ekpa
                       WHERE ekpa~ebeln = @<fs_nflin>-xped
                         AND ekpa~parvw = 'ZU'
                         AND ekpa~lifn2 EQ @lv_lifn2.
                      IF sy-subrc NE 0.

                        SELECT COUNT( * )
                               BYPASSING BUFFER
                          FROM t001w
                         WHERE t001w~werks = @lv_werks_e.
                        IF sy-subrc NE 0.
                          lv_bln_int_transf_e = abap_true.
                        ENDIF.

                        lv_werks_r = ls_transf-werks_receptor.

                      ENDIF.

                    ENDIF.

                  WHEN 'BI'.

                    lv_werks_e = lt_werks_e[ low = <fs_nflin>-werks ]-high.

                    SELECT COUNT( * )
                    FROM t001w
                    WHERE werks EQ @lv_werks_e
                      AND kunnr EQ @is_header-parid.
                    IF sy-subrc EQ 0.
                      lv_bln_int_transf_e = abap_true.
                    ENDIF.

                  WHEN OTHERS.
                    lv_bln_int_transf_e = abap_true.
                ENDCASE.

              CATCH cx_sy_itab_line_not_found zcxca_tabela_parametros.
                lv_bln_int_transf_e = abap_true.
            ENDTRY.

            TRY.
                lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                                 iv_chave1 = lc_param_df-chave1
                                                 iv_chave2 = lc_param_df-local_ret
                                       IMPORTING et_range  = lt_werks_lr ).

                lv_werks_r = lt_werks_lr[ low = <fs_nflin>-werks ]-high.

              CATCH cx_sy_itab_line_not_found zcxca_tabela_parametros.
                lv_bln_int_transf_r = abap_true.
            ENDTRY.

*            IF lv_excecao IS INITIAL AND NOT lv_werks_lr IS INITIAL.
            IF lv_bln_int_transf_r = abap_false OR lv_bln_int_transf_e = abap_false.

              DATA(lv_texto_df) = |{ TEXT-t11 }|. "retiradas do

              CASE abap_false.
                WHEN lv_bln_int_transf_r.
                  REPLACE '&1' IN lv_texto_df WITH |retiradas do|.
                WHEN lv_bln_int_transf_e.
                  REPLACE '&1' IN lv_texto_df WITH |entregues no|.
                WHEN OTHERS.
              ENDCASE.

              SELECT SINGLE j_1bbranch
                FROM t001w
                INTO @DATA(lv_branch)
                WHERE werks EQ @lv_werks_r.

              IF sy-subrc EQ 0.
                CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
                  EXPORTING
                    branch            = lv_branch
                    bukrs             = is_header-bukrs
                  IMPORTING
                    address           = ls_address
                    branch_data       = ls_branch_data
                    cgc_number        = lv_cgc_number
                  EXCEPTIONS
                    branch_not_found  = 1
                    address_not_found = 2
                    company_not_found = 3
                    OTHERS            = 4.
                IF sy-subrc EQ 0.
                  SEARCH cs_header-infcpl FOR lv_texto_df. "TEXT-t11.
                  IF sy-subrc NE 0.
                    cs_header-infcpl = |{ cs_header-infcpl } { lv_texto_df }|. "{ TEXT-t11 }|.
                    cs_header-infcpl = |{ cs_header-infcpl } { ls_address-stras } { ls_address-ort02 }, |.
                    cs_header-infcpl = |{ cs_header-infcpl } { ls_address-ort01 } - { ls_address-regio }, |.
                    cs_header-infcpl = |{ cs_header-infcpl } Inscrição Estadual n(o) { ls_branch_data-state_insc }, |.
                    cs_header-infcpl = |{ cs_header-infcpl } CNPJ n(o) { lv_cgc_number }. |.
                    READ TABLE lt_itens_add ASSIGNING <fs_item_adicional> WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
                    IF sy-subrc EQ 0.
                      IF NOT <fs_item_adicional>-cest IS INITIAL.
                        CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
                          EXPORTING
                            input  = <fs_item_adicional>-cest
                          IMPORTING
                            output = lv_cest_mask.

                        lv_matnr = |{ <fs_nflin>-matnr ALPHA = OUT }|.

                        lv_texto = to_upper( |{ TEXT-f69 } { lv_matnr } { TEXT-f70 } { lv_cest_mask }| ).

                        CONDENSE lv_texto.
                        CONDENSE lv_matnr NO-GAPS.

                        IF cs_header-infcpl NS lv_texto.

                          cs_header-infcpl = |{ cs_header-infcpl } { to_upper( TEXT-f69 ) } { lv_matnr } { to_upper( TEXT-f70 ) } { lv_cest_mask }|.

                          DATA(lv_cest_ok) = abap_true.

                        ENDIF.

                      ENDIF.
                    ENDIF.

                    IF <fs_nfetx_tab> IS ASSIGNED.
                      REFRESH lt_out_lines1.
                      CLEAR: lv_seq,
                             lv_linha,
                             lv_linnum.
                      lv_linha = lv_texto_df. "TEXT-t11.
                      lv_linha = |{ lv_linha } { ls_address-stras } { ls_address-ort02 }, |.
                      lv_linha = |{ lv_linha } { ls_address-ort01 } - { ls_address-regio }, |.
                      lv_linha = |{ lv_linha } Inscrição Estadual n(o) { ls_branch_data-state_insc }, |.
                      lv_linha = |{ lv_linha } CNPJ n(o) { lv_cgc_number }. |.
                      IF NOT lv_cest_ok IS INITIAL.
                        lv_linha = |{ lv_linha } { to_upper( TEXT-f69 ) } { lv_matnr } { to_upper( TEXT-f70 ) } { lv_cest_mask }|.
                      ENDIF.

                      CALL FUNCTION 'RKD_WORD_WRAP'
                        EXPORTING
                          textline            = lv_linha
                          outputlen           = 72
                        TABLES
                          out_lines           = lt_out_lines1
                        EXCEPTIONS
                          outputlen_too_large = 1
                          OTHERS              = 2.

                      lt_nfetx = <fs_nfetx_tab>.

                      SORT lt_nfetx BY seqnum DESCENDING.

                      lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
                      lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).
                      LOOP AT lt_out_lines1 ASSIGNING FIELD-SYMBOL(<fs_out_lines1>).
                        ADD 1 TO lv_seq.
                        IF <fs_nfetx_tab> IS ASSIGNED.
                          APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_out_lines1> ) TO <fs_nfetx_tab>.
                        ENDIF.
                      ENDLOOP.

                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
*            CLEAR lv_excecao.
            CLEAR: lv_skip_dep, lv_bln_int_transf_r, lv_bln_int_transf_e.
          ENDIF.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.

    CLEAR: lv_texto,
           lv_matnr,
           lv_cest_mask,
           lv_cest_ok.

    TRY.
        DATA(ls_partner) = it_partner[ parvw = 'ZD' ].
        SEARCH cs_header-infcpl FOR TEXT-t10.
        IF sy-subrc NE 0.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Início
          SELECT SINGLE a~street, a~house_num1
            FROM adrc AS a
            INNER JOIN kna1 AS b ON a~addrnumber = b~adrnr
            INTO ( @DATA(lv_street), @DATA(lv_house_num1) )
            WHERE b~kunnr EQ @ls_partner-parid.
          IF sy-subrc EQ 0.
            DATA(lv_rua_nro) = CONV char200( |{ lv_street }, { lv_house_num1 }| ).
          ENDIF.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Fim
          cs_header-infcpl = |{ cs_header-infcpl } { TEXT-t10 }|.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Início
*          cs_header-infcpl = |{ cs_header-infcpl } { ls_partner-stras }, { ls_partner-ort02 }, |.
          cs_header-infcpl = |{ cs_header-infcpl } { lv_rua_nro }, { ls_partner-ort02 }, |.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Início
          cs_header-infcpl = |{ cs_header-infcpl } { ls_partner-ort01 } { ls_partner-regio }, |.
          cs_header-infcpl = |{ cs_header-infcpl } { ls_partner-pstlz } -|.
          cs_header-infcpl = |{ cs_header-infcpl } CNPJ: { ls_partner-cgc  }, |.
          cs_header-infcpl = |{ cs_header-infcpl } IE: { ls_partner-stains } |.
          READ TABLE lt_itens_add ASSIGNING <fs_item_adicional> WITH KEY itmnum = <fs_nflin>-itmnum BINARY SEARCH.
          IF sy-subrc EQ 0.
            IF NOT <fs_item_adicional>-cest IS INITIAL.
              CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
                EXPORTING
                  input  = <fs_item_adicional>-cest
                IMPORTING
                  output = lv_cest_mask.

              lv_matnr = |{ <fs_nflin>-matnr ALPHA = OUT }|.

              lv_texto = to_upper( |{ TEXT-f69 } { lv_matnr } { TEXT-f70 } { lv_cest_mask }| ).

              CONDENSE lv_texto.
              CONDENSE lv_matnr NO-GAPS.

              IF cs_header-infcpl NS lv_texto.

                cs_header-infcpl = |{ cs_header-infcpl } { to_upper( TEXT-f69 ) } { lv_matnr } { to_upper( TEXT-f70 ) } { lv_cest_mask }|.

                lv_cest_ok = abap_true.

              ENDIF.

            ENDIF.

          ENDIF.

          IF <fs_nfetx_tab> IS ASSIGNED.
            REFRESH lt_out_lines1.
            CLEAR: lv_seq,
                   lv_linha,
                   lv_linnum.

            CLEAR lv_linha.
            lv_linha = TEXT-t10.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Início
*            lv_linha = |{ lv_linha } { ls_partner-stras }, { ls_partner-ort02 }, |.
            lv_linha = |{ lv_linha } { lv_rua_nro }, { ls_partner-ort02 }, |.
* LSCHEPP - SD - 8000007730 - Tag local de entrega e dados adicionais - 23.05.2023 Fim
            lv_linha = |{ lv_linha } { ls_partner-ort01 } { ls_partner-regio }, |.
            lv_linha = |{ lv_linha } { ls_partner-pstlz } -|.
            lv_linha = |{ lv_linha } CNPJ: { ls_partner-cgc  }, |.
            lv_linha = |{ lv_linha } IE: { ls_partner-stains } |.
            IF NOT lv_cest_ok IS INITIAL.
              lv_linha = |{ lv_linha } { to_upper( TEXT-f69 ) } { lv_matnr } { to_upper( TEXT-f70 ) } { lv_cest_mask }|.
            ENDIF.

            CALL FUNCTION 'RKD_WORD_WRAP'
              EXPORTING
                textline            = lv_linha
                outputlen           = 72
              TABLES
                out_lines           = lt_out_lines1
              EXCEPTIONS
                outputlen_too_large = 1
                OTHERS              = 2.

            lt_nfetx = <fs_nfetx_tab>.

            SORT lt_nfetx BY seqnum DESCENDING.

            lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
            lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).
            LOOP AT lt_out_lines1 ASSIGNING <fs_out_lines1>.
              ADD 1 TO lv_seq.
              IF <fs_nfetx_tab> IS ASSIGNED.
                APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_out_lines1> ) TO <fs_nfetx_tab>.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
