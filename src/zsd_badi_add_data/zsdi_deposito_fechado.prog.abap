*&---------------------------------------------------------------------*
*& Include          ZSDI_DEPOSITO_FECHADO
*&---------------------------------------------------------------------*
    CONSTANTS: BEGIN OF lc_param_df,
                 modulo    TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1    TYPE ztca_param_par-chave1 VALUE 'DEPÓSITO FECHADO',
                 excecao   TYPE ztca_param_par-chave2 VALUE 'EXCEÇÕES',
                 local_ret TYPE ztca_param_par-chave2 VALUE 'LOCAL RETIRADA',
               END OF lc_param_df.

    FIELD-SYMBOLS: <fs_item_tab>    TYPE j_1bnflin_tab,
                   <fs_partner_tab> TYPE nfe_partner_tab.

    DATA: lt_werks_e  TYPE wrma_werks_ran_tab,
          lt_werks_lr TYPE wrma_werks_ran_tab.

    DATA: ls_address    TYPE sadr,
          ls_branch     TYPE j_1bbranch,
          lv_cgc_number TYPE j_1bcgc,
          ls_address1   TYPE addr1_val.

* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Início
*    IF it_doc-direct EQ '2' AND "Saída
*       it_lin-reftyp EQ 'BI'. "Faturamento
    IF it_doc-direct EQ '2'.

      IF it_lin-reftyp EQ 'BI'. "Faturamento
        DATA(lv_check) = abap_true.
      ENDIF.
      IF it_doc-manual EQ abap_true. "Nota Manual
        lv_check = abap_true.
      ENDIF.

      IF NOT lv_check IS INITIAL.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Fim

        ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM[]') TO <fs_item_tab>.
        IF <fs_item_tab> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

        READ TABLE <fs_item_tab> INTO DATA(ls_item) INDEX 1.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Início
*        IF ls_item-itmnum EQ it_lin-itmnum.
        IF NOT ls_item-werks IS INITIAL.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Fim
          TRY.
              lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                               iv_chave1 = lc_param_df-chave1
                                               iv_chave2 = lc_param_df-excecao
                                     IMPORTING et_range  = lt_werks_e ).
              TRY.
                  DATA(lv_werks_e) = lt_werks_e[ low = ls_item-werks ]-high.
                  SELECT COUNT( * )
                    FROM t001w
                    WHERE werks EQ @lv_werks_e
                      AND kunnr EQ @it_doc-parid.
                  IF sy-subrc EQ 0.
                    DATA(lv_excecao) = abap_true.
                  ENDIF.
                  IF lv_excecao IS INITIAL.
                    TRY.
                        lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                                         iv_chave1 = lc_param_df-chave1
                                                         iv_chave2 = lc_param_df-local_ret
                                               IMPORTING et_range  = lt_werks_lr ).
                        TRY.
                            DATA(lv_werks_lr) = lt_werks_lr[ low = ls_item-werks ]-high.
                          CATCH cx_sy_itab_line_not_found.
                            lv_excecao = abap_true.
                        ENDTRY.
                      CATCH zcxca_tabela_parametros.
                        lv_excecao = abap_true.
                    ENDTRY.
                  ENDIF.
                CATCH cx_sy_itab_line_not_found.
                  lv_excecao = abap_true.
              ENDTRY.
            CATCH zcxca_tabela_parametros.
              lv_excecao = abap_true.
          ENDTRY.

          IF lv_excecao IS INITIAL AND
             NOT lv_werks_lr IS INITIAL.

            SELECT SINGLE werks, j_1bbranch, adrnr
              FROM t001w
              INTO @DATA(ls_retirada)
              WHERE werks EQ @lv_werks_lr.
            IF sy-subrc NE 0.
              RETURN.
            ENDIF.

            SELECT bukrs, branch
              FROM j_1bbranch
              INTO TABLE @DATA(lt_1bbranch)
              WHERE branch EQ @ls_retirada-j_1bbranch.
            IF sy-subrc NE 0.
              RETURN.
            ENDIF.

            READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.

            ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <fs_xmlh>.
            IF <fs_xmlh> IS NOT ASSIGNED.
              RETURN.
            ENDIF.

            CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
              EXPORTING
                branch            = ls_1bbranch-branch
                bukrs             = ls_1bbranch-bukrs
              IMPORTING
                address           = ls_address
                branch_data       = ls_branch
                cgc_number        = lv_cgc_number
                address1          = ls_address1
              EXCEPTIONS
                branch_not_found  = 1
                address_not_found = 2
                company_not_found = 3
                OTHERS            = 4.
            IF sy-subrc EQ 0.
              <fs_xmlh>-f_cnpj = lv_cgc_number.
              <fs_xmlh>-f_ie   = ls_branch-state_insc.
              <fs_xmlh>-f_fone = ls_address1-tel_number.
            ENDIF.


            SELECT addrnumber, name2, street, house_num1, city1,
                   city2, taxjurcode, region, post_code1, country
              FROM adrc
              INTO TABLE @DATA(lt_adrc)
              WHERE addrnumber EQ @ls_retirada-adrnr.
            IF sy-subrc NE 0.
              RETURN.
            ENDIF.

            READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.

            <fs_xmlh>-f_xnome   = ls_adrc-name2.
            <fs_xmlh>-f_xlgr    = ls_adrc-street.
            <fs_xmlh>-f_nro     = ls_adrc-house_num1.
            <fs_xmlh>-f_xbairro = ls_adrc-city2.
            <fs_xmlh>-f_cmun    = ls_adrc-taxjurcode+3.
            <fs_xmlh>-f_xmun    = ls_adrc-city1.
            <fs_xmlh>-f_uf      = ls_adrc-region.

            TRANSLATE ls_adrc-post_code1 USING '- '.
            CONDENSE ls_adrc-post_code1 NO-GAPS.
            <fs_xmlh>-f_cep     = ls_adrc-post_code1.
            <fs_xmlh>-f_cpais   = '1058'.
            SELECT SINGLE landx
              FROM t005t
              INTO @<fs_xmlh>-f_xpais
              WHERE spras = @sy-langu
                AND land1 = @ls_adrc-country.

          ENDIF.
          CLEAR lv_excecao.
        ENDIF.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Início
* LSCHEPP - SD - 8000007531 - CORE 8 - SEM Tag do local de entrega - 18.05.2023 Início
        ASSIGN ('(SAPLJ_1B_NFE)WK_PARTNER[]') TO <fs_partner_tab>.
        IF <fs_partner_tab> IS NOT ASSIGNED.
          RETURN.
        ENDIF.

        TRY.
            DATA(ls_partner) = <fs_partner_tab>[ parvw = 'ZD' ].
            ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <fs_xmlh>.
            IF <fs_xmlh> IS NOT ASSIGNED.
              RETURN.
            ENDIF.
            <fs_xmlh>-g_cnpj    = ls_partner-cgc.
            <fs_xmlh>-g_ie      = ls_partner-stains.
            <fs_xmlh>-g_fone    = ls_partner-telf1.
            <fs_xmlh>-g_xnome   = ls_partner-name1.
            <fs_xmlh>-g_xbairro = ls_partner-ort02.
            <fs_xmlh>-g_cmun    = ls_partner-txjcd+3.
            <fs_xmlh>-g_xmun    = ls_partner-ort01.
            <fs_xmlh>-g_uf      = ls_partner-regio.

            TRANSLATE ls_partner-pstlz USING '- '.
            CONDENSE ls_partner-pstlz NO-GAPS.
            <fs_xmlh>-g_cep     = ls_partner-pstlz.
            <fs_xmlh>-g_cpais   = '1058'.
            <fs_xmlh>-g_xpais   = TEXT-t13.

            SELECT SINGLE a~street, a~house_num1
              FROM adrc AS a
              INNER JOIN kna1 AS b ON a~addrnumber = b~adrnr
              INTO ( @<fs_xmlh>-g_xlgr, @<fs_xmlh>-g_nro )
              WHERE b~kunnr EQ @ls_partner-parid.

          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
* LSCHEPP - SD - 8000007531 - CORE 8 - SEM Tag do local de entrega - 18.05.2023 Fim
      ENDIF.
      CLEAR lv_check.
* LSCHEPP - SD - 8000007071 - TAG LOCAL DE RETIRADA - 11.05.2023 Fim
    ENDIF.
