CLASS zclsd_cmdloc_pag_contrato DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS processar
      IMPORTING
        !iv_vbeln   TYPE vbeln_vf
      EXPORTING
        !ev_obj_key TYPE awkey
        !et_return  TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_param,
                 modulo      TYPE ze_param_modulo VALUE 'FI',
                 chave1      TYPE ze_param_chave  VALUE 'LOCACAOFATURA',
                 ch2_tp_doc  TYPE ze_param_chave  VALUE 'TIPODOC',
                 ch2_condpag TYPE ze_param_chave  VALUE 'CONDPAGAMENTO',
               END OF gc_param,

               BEGIN OF gc_message,
                 sucess TYPE sy-msgty VALUE 'S',
                 id_rw  TYPE sy-msgid VALUE 'RW',
                 no_614 TYPE sy-msgno VALUE '614',
                 no_605 TYPE sy-msgno VALUE '605',
               END OF gc_message.

    CONSTANTS: gc_obj_type TYPE awtyp         VALUE 'BKPFF',
               gc_moeda    TYPE waers         VALUE 'BRL',
               gc_cond_pis TYPE kscha         VALUE 'BX82',
               gc_cond_cof TYPE kscha         VALUE 'BX72',
               gc_cc_alug  TYPE ze_name_param VALUE 'CONTRATO_PAGAMENTO_CONTA_CC_ALUGUEL',
               gc_pis_cof  TYPE ze_name_param VALUE 'CONTRATO_PAGAMENTO_CONTA_PIS_COF_ALUGUEL'.
ENDCLASS.



CLASS zclsd_cmdloc_pag_contrato IMPLEMENTATION.


  METHOD processar.

    DATA: lt_return    TYPE bapiret2_t,
          lt_itemforn  TYPE STANDARD TABLE OF bapiacap09,
          lt_curr      TYPE STANDARD TABLE OF bapiaccr09,
          lt_itemrazao TYPE STANDARD TABLE OF bapiacgl09.

    DATA: lv_saldo_partida TYPE j_1bnflin-netpr,
          lv_ccusto        TYPE char10,
          lv_obj_key       TYPE bapiache09-obj_key,
          lv_pis           TYPE j_1bnflin-netpr,
          lv_cofins        TYPE j_1bnflin-netpr,
          lv_chave         TYPE char60,
          lv_conta         TYPE numc10,
          lv_conta_pis     TYPE numc10,
          lv_conta_cof     TYPE numc10,
          lv_contrato      TYPE vbap-vbeln,
          lv_string        TYPE string,
          lv_doc_type      TYPE blart,
          lv_zterm         TYPE acpi_zterm.

    CHECK iv_vbeln IS NOT INITIAL.

    DO 10 TIMES.

      SELECT bukrs,
             kunnr,
             zuonr,
             xblnr,
             gjahr,
             belnr,
             dmbtr
        FROM bsid_view
       WHERE belnr = @iv_vbeln
        INTO @DATA(ls_bsid)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc EQ 0.
        EXIT.
      ELSE.
        WAIT UP TO '0.5' SECONDS.
      ENDIF.

    ENDDO.

    IF sy-subrc IS NOT INITIAL.

      SELECT bukrs,
             kunnr,
             zuonr,
             xblnr,
             gjahr,
             belnr,
             dmbtr
        FROM bsad_view
       WHERE belnr = @iv_vbeln
        INTO @ls_bsid
          UP TO 1 ROWS.
      ENDSELECT.

      CHECK sy-subrc = 0.
    ENDIF.

    CHECK ls_bsid-xblnr CA '0123456789'.

    SPLIT ls_bsid-xblnr AT '_' INTO lv_contrato
                                    lv_string.

    CHECK lv_contrato IS NOT INITIAL.

    UNPACK lv_contrato TO lv_contrato.

    SELECT SINGLE vbeln
      FROM vbfa
     WHERE vbelv = @lv_contrato
       AND vbtyp_n = 'M'
       AND plmin   = '+'
      INTO @DATA(lv_vbeln).

    IF sy-subrc IS INITIAL.

      SELECT SINGLE vbeln,
                    fkdat,
                    kunag,
                    vkorg,
                    bukrs,
                    spart,
                    knumv
        FROM vbrk
       WHERE vbeln = @lv_vbeln
        INTO @DATA(ls_vbrk).

      CHECK ls_vbrk IS NOT INITIAL.

      SELECT knumv,
             kposn,
             kschl,
             kwert
        FROM prcd_elements
       WHERE knumv = @ls_vbrk-knumv
*           AND kposn = @ls_vbrk-posnv
         AND kschl IN ( @gc_cond_cof , @gc_cond_pis )
        INTO TABLE @DATA(lt_prcd).

      IF sy-subrc IS INITIAL.

        CLEAR: lv_pis,
               lv_cofins.

        LOOP AT lt_prcd ASSIGNING FIELD-SYMBOL(<fs_prcd>).

          IF <fs_prcd>-kschl EQ gc_cond_cof.
            lv_cofins = lv_cofins + <fs_prcd>-kwert.
          ELSE.
            lv_pis = lv_pis + <fs_prcd>-kwert.
          ENDIF.

        ENDLOOP.
      ENDIF.

    ENDIF.

    IF ls_vbrk IS INITIAL.
      RETURN.
    ENDIF.

    SELECT bukrs,
           bupla,
           cgc,
           kunnr,
           lifnr,
           filial,
           vkorg,
           col_ci
      FROM ztfi_cgc_coligad
     WHERE kunnr = @ls_vbrk-kunag
      INTO @DATA(ls_cgc_kunnr)
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE werks,
                    spart,
                    gsber
        FROM t134g
       WHERE werks = @ls_vbrk-bukrs
         AND spart = @ls_vbrk-spart
        INTO @DATA(ls_divisao).

      SELECT bukrs,
             bupla,
             cgc,
             kunnr,
             lifnr,
             filial,
             vkorg,
             col_ci
        FROM ztfi_cgc_coligad
       WHERE vkorg = @ls_vbrk-vkorg
        INTO @DATA(ls_cgc_lifnr)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS NOT INITIAL.
        RETURN.
      ENDIF.

    ELSE.
      RETURN.
    ENDIF.

*---------  Verifica se gerado as partidas contas a pagar em aberto
    SELECT bukrs,
           lifnr,
           xblnr,
           belnr    " Partidas no conta a pagar em aberto
      FROM bsik_view
     WHERE xblnr = @ls_bsid-xblnr
       AND bukrs = @ls_cgc_kunnr-bukrs
       AND bupla = @ls_cgc_kunnr-bupla
       AND lifnr = @ls_cgc_lifnr-lifnr
      INTO TABLE @DATA(lt_bsik).

    CHECK sy-subrc NE 0.

*---------  Verifica partida pagas
    SELECT bukrs,
           lifnr,
           xblnr,
           belnr    " Partidas no conta a pagar em aberto
      FROM bsak_view
     WHERE xblnr = @ls_bsid-xblnr
       AND bukrs = @ls_cgc_kunnr-bukrs
       AND bupla = @ls_cgc_kunnr-bupla
       AND lifnr = @ls_cgc_lifnr-lifnr
      INTO TABLE @DATA(lt_bsak).

    CHECK sy-subrc NE 0.

*    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*      EXPORTING
*        input  = lv_contrato
*      IMPORTING
*        output = lv_contrato.

*    " Busca todos itens dos  contrato
*    SELECT vbeln,
*           posnr,
*           matnr,
*           werks,
*           meins,
*           vstel,
*           lgort,
*           abgru
*      FROM vbap
*     WHERE vbeln EQ @lv_contrato
*      INTO TABLE @DATA(lt_vbap_contratos).
*
*    IF sy-subrc IS INITIAL.
*
*      DATA(lt_vbap) = lt_vbap_contratos[].
*      FREE: lt_vbap[].
*
*      LOOP AT lt_vbap_contratos ASSIGNING FIELD-SYMBOL(<fs_vbap_contratos>).
*
*        IF <fs_vbap_contratos>-abgru IS INITIAL.
*          APPEND <fs_vbap_contratos> TO lt_vbap.
*        ENDIF.
*
*      ENDLOOP.
*
*      IF lt_vbap IS NOT INITIAL.
*
*        SELECT a~vbelv,
*               a~posnv,
*               a~vbeln,
*               a~posnn,
*               b~knumv
*          FROM vbfa AS a
*         INNER JOIN vbak AS b ON a~vbeln = b~vbeln
*           FOR ALL ENTRIES IN @lt_vbap
*         WHERE vbelv   = @lt_vbap-vbeln
*           AND posnv   = @lt_vbap-posnr
*          INTO TABLE @DATA(lt_vfa_vbak).
*
*        IF sy-subrc IS INITIAL.
*
*          DATA(lt_vfa_vbak_fae) = lt_vfa_vbak[].
*          SORT lt_vfa_vbak_fae BY knumv
*                                  posnv.
*          DELETE ADJACENT DUPLICATES FROM lt_vfa_vbak_fae COMPARING knumv
*                                                                    posnv.
*
*          SELECT knumv,
*                 kposn,
*                 kschl,
*                 kwert
*            FROM prcd_elements
*             FOR ALL ENTRIES IN @lt_vfa_vbak_fae
*           WHERE knumv = @lt_vfa_vbak_fae-knumv
*             AND kposn = @lt_vfa_vbak_fae-posnv
*             AND kschl IN ( @gc_cond_cof , @gc_cond_pis )
*            INTO TABLE @DATA(lt_prcd).
*
*          IF sy-subrc IS INITIAL.
*
*            CLEAR: lv_pis,
*                   lv_cofins.
*
*            LOOP AT lt_prcd ASSIGNING FIELD-SYMBOL(<fs_prcd>).
*
*              IF <fs_prcd>-kschl EQ gc_cond_cof.
*                lv_cofins = lv_cofins + <fs_prcd>-kwert.
*              ELSE.
*                lv_pis = lv_pis + <fs_prcd>-kwert.
*              ENDIF.
*
*            ENDLOOP.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                          iv_chave1 = gc_param-chave1
                                          iv_chave2 = gc_param-ch2_tp_doc
                                IMPORTING ev_param  = lv_doc_type ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                          iv_chave1 = gc_param-chave1
                                          iv_chave2 = gc_param-ch2_condpag
                                IMPORTING ev_param  = lv_zterm ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
    ENDTRY.

    lv_saldo_partida = ls_bsid-dmbtr - ( lv_pis + lv_cofins ).

    DATA(ls_header) = VALUE bapiache09( obj_type   = gc_obj_type
                                        username   = sy-uname
                                        doc_type   = lv_doc_type
                                        header_txt = |{ TEXT-t13 } - { ls_vbrk-fkdat+4(2) }/{ ls_vbrk-fkdat(4) }|
                                        comp_code  = ls_cgc_kunnr-bukrs
                                        ref_doc_no = ls_bsid-xblnr
                                        doc_date   = ls_vbrk-fkdat
                                        pstng_date = ls_vbrk-fkdat
                                        fisc_year  = ls_vbrk-fkdat(4)
                                        fis_period = ls_vbrk-fkdat+4(2) ).

    DATA(ls_itemforn) = VALUE bapiacap09( itemno_acc    = 1
                                          vendor_no     = ls_cgc_lifnr-lifnr
                                          businessplace = ls_cgc_kunnr-bupla
                                          comp_code     = ls_cgc_kunnr-bukrs
                                          bus_area      = ls_divisao-gsber
                                          pmnttrms      = lv_zterm
                                          item_text     = |{ TEXT-t13 } - { ls_vbrk-fkdat+4(2) }/{ ls_vbrk-fkdat(4) }|
                                          alloc_nmbr    = ls_bsid-zuonr
                                          bline_date    = sy-datum ).

    DATA(ls_curr) = VALUE bapiaccr09( itemno_acc = ls_itemforn-itemno_acc
                                      currency   = gc_moeda
                                      amt_doccur = ls_bsid-dmbtr * -1 ).
    " Itens
    APPEND: ls_itemforn TO lt_itemforn,
            ls_curr     TO lt_curr.

    IF lv_ccusto IS NOT INITIAL.
      UNPACK lv_ccusto TO lv_ccusto.
    ENDIF.

    SELECT bukrs,
           branch,
           chave,
           conteudo,
           descricao
      FROM ztfi_denm_coliga
     WHERE bukrs = @ls_cgc_kunnr-bukrs
      INTO TABLE @DATA(lt_denom).

    IF sy-subrc IS INITIAL.
      SORT lt_denom BY bukrs
                       branch
                       chave.

      READ TABLE lt_denom ASSIGNING FIELD-SYMBOL(<fs_denom>)
                                        WITH KEY bukrs  = ls_cgc_kunnr-bukrs
                                                 branch = ls_cgc_kunnr-bupla
                                                 chave  = gc_cc_alug
                                                 BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        READ TABLE lt_denom ASSIGNING <fs_denom>
                             WITH KEY bukrs = ls_cgc_kunnr-bukrs
                                      chave = gc_cc_alug
                                      BINARY SEARCH.

      ENDIF.

      IF sy-subrc IS INITIAL.
        CLEAR: lv_conta,
               lv_ccusto.

        SPLIT <fs_denom>-conteudo AT '-' INTO lv_conta
                                              lv_ccusto.
      ENDIF.

      READ TABLE lt_denom ASSIGNING <fs_denom>
                           WITH KEY bukrs  = ls_cgc_kunnr-bukrs
                                    branch = ls_cgc_kunnr-bupla
                                    chave  = gc_pis_cof
                                    BINARY SEARCH.
      IF sy-subrc IS NOT INITIAL.
        READ TABLE lt_denom ASSIGNING <fs_denom>
                             WITH KEY bukrs = ls_cgc_kunnr-bukrs
                                      chave = gc_pis_cof
                                      BINARY SEARCH.
      ENDIF.

      IF sy-subrc IS INITIAL.
        CLEAR: lv_conta_pis,
               lv_conta_cof.
        SPLIT <fs_denom>-conteudo AT '-' INTO lv_conta_pis
                                              lv_conta_cof.
      ENDIF.
    ENDIF.

    IF lv_ccusto IS NOT INITIAL.

      SELECT SINGLE gsber FROM csks
      WHERE kokrs EQ 'AC3C'
        AND kostl EQ @lv_ccusto
        AND datbi GE @sy-datum
        AND datab LE @sy-datum
        INTO @DATA(lv_gsber).

      IF  sy-subrc EQ 0
      AND lt_itemforn IS NOT INITIAL.
        lt_itemforn[ 1 ]-bus_area = lv_gsber.
      ENDIF.

    ENDIF.

    " Monta Item Razaão
    DATA(ls_itemrazao) = VALUE bapiacgl09( itemno_acc = 2
                                           gl_account = lv_conta
                                           comp_code  = ls_cgc_kunnr-bukrs
                                           bus_area   = lv_gsber "ls_divisao-gsber
                                           plant      = ls_divisao-werks
                                           costcenter = lv_ccusto
                                           item_text  = |{ TEXT-t13 } - { ls_vbrk-fkdat+4(2) }/{ ls_vbrk-fkdat(4) }| ).

    ls_curr = VALUE bapiaccr09( itemno_acc = ls_itemrazao-itemno_acc
                                currency   = gc_moeda
                                amt_doccur = lv_saldo_partida ).

    " Itens
    APPEND: ls_itemrazao TO lt_itemrazao,
            ls_curr      TO lt_curr.

    CLEAR: ls_itemrazao,
           ls_curr.

*-------------- PIS
    ls_itemrazao = VALUE bapiacgl09( itemno_acc = 3
                                     gl_account = lv_conta_pis
                                     comp_code  = ls_cgc_kunnr-bukrs
                                     bus_area   = lv_gsber "ls_divisao-gsber
                                     plant      = ls_divisao-werks
                                     item_text  = |{ TEXT-t14 } - { ls_vbrk-fkdat+4(2) }/{ ls_vbrk-fkdat(4) }| ).

    ls_curr = VALUE bapiaccr09( itemno_acc = ls_itemrazao-itemno_acc
                                currency   = gc_moeda
                                amt_doccur = lv_pis ).

    " Itens
    APPEND: ls_itemrazao TO lt_itemrazao,
            ls_curr      TO lt_curr.

    CLEAR: ls_itemrazao,
           ls_curr.

*-------------- COF
    ls_itemrazao = VALUE bapiacgl09( itemno_acc = 4
                                     gl_account = lv_conta_cof
                                     comp_code  = ls_cgc_kunnr-bukrs
                                     bus_area   = lv_gsber " ls_divisao-gsber
                                     plant      = ls_divisao-werks
                                     item_text  = |{ TEXT-t15 } - { ls_vbrk-fkdat+4(2) }/{ ls_vbrk-fkdat(4) }| ).

    ls_curr = VALUE bapiaccr09( itemno_acc = ls_itemrazao-itemno_acc
                                currency   = gc_moeda
                                amt_doccur = lv_cofins ).

    " Itens
    APPEND: ls_itemrazao TO lt_itemrazao,
            ls_curr      TO lt_curr.

    CLEAR: ls_itemrazao,
           ls_curr.

    FREE: lt_return[].

    " Checa Lançamento Financeiro
    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = ls_header
      TABLES
        accountpayable = lt_itemforn
        accountgl      = lt_itemrazao
        currencyamount = lt_curr
        return         = lt_return.

    SORT lt_return BY type
                      id
                      number.

    READ TABLE lt_return TRANSPORTING NO FIELDS
                                       WITH KEY type   = gc_message-sucess
                                                id     = gc_message-id_rw
                                                number = gc_message-no_614
                                                BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      FREE: lt_return[].

      " Chama Transação Lançamento Financeiro
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          documentheader = ls_header
        IMPORTING
          obj_key        = ev_obj_key
        TABLES
          accountpayable = lt_itemforn
          accountgl      = lt_itemrazao
          currencyamount = lt_curr
          return         = lt_return.

      SORT lt_return BY type
                        id
                        number.

      READ TABLE lt_return TRANSPORTING NO FIELDS
                                         WITH KEY type = gc_message-sucess
                                                  id = gc_message-id_rw
                                                  number = gc_message-no_605
                                                  BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ENDIF.
    ELSE.
      et_return[] = lt_return[].
    ENDIF.

  ENDMETHOD.
ENDCLASS.
