*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_PAYMENT
*&---------------------------------------------------------------------*
  CONSTANTS: BEGIN OF lc_param,
               modulo TYPE ztca_param_par-modulo VALUE 'MM',
               chave1 TYPE ztca_param_par-chave1 VALUE 'SUBCON',
               reftyp TYPE ztca_param_par-chave2 VALUE 'REFTYP',
               itmtyp TYPE ztca_param_par-chave2 VALUE 'ITMTYP',
             END OF lc_param.

  CONSTANTS: lc_entrada TYPE char1 VALUE '1',
             lc_saida   TYPE char1 VALUE '2',
             lc_ref     TYPE j_1bnflin-reftyp VALUE 'BI'.

  DATA: lv_reftyp TYPE j_1breftyp,
        lv_mwskz  TYPE mwskz.

  DATA lt_itmtyp TYPE RANGE OF j_1bitmtyp.

  CLEAR ct_payment.
*    CASE is_header-direct.
*      WHEN lc_entrada. " ENTRADA MM
*      WHEN lc_saida. "

  DATA(lt_nflin) = it_nflin.
  SORT lt_nflin BY reftyp.

* LSCHEPP - Remessa Subcontratação - 01.06.2022 Início
  DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 20.07.2023

  TRY.
      CALL METHOD lo_param->m_get_single
        EXPORTING
          iv_modulo = lc_param-modulo
          iv_chave1 = lc_param-chave1
          iv_chave2 = lc_param-reftyp
        IMPORTING
          ev_param  = lv_reftyp.
      TRY.
          CALL METHOD lo_param->m_get_range
            EXPORTING
              iv_modulo = lc_param-modulo
              iv_chave1 = lc_param-chave1
              iv_chave2 = lc_param-itmtyp
            IMPORTING
              et_range  = lt_itmtyp.

          LOOP AT lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>)
            WHERE ( reftyp EQ lv_reftyp OR reftyp EQ space )
              AND itmtyp IN lt_itmtyp.

            APPEND INITIAL LINE TO ct_payment ASSIGNING FIELD-SYMBOL(<fs_payment>).
            <fs_payment>-mandt   = sy-mandt.
            <fs_payment>-docnum  = is_header-docnum.
            <fs_payment>-ind_pag = '1'.
            <fs_payment>-counter = 1.
            <fs_payment>-t_pag   = '90'.
            CLEAR <fs_payment>-v_pag.

          ENDLOOP.
        CATCH zcxca_tabela_parametros.
      ENDTRY.
    CATCH zcxca_tabela_parametros.
  ENDTRY.
* LSCHEPP - Remessa Subcontratação - 01.06.2022 Fim

  READ TABLE lt_nflin TRANSPORTING NO FIELDS WITH KEY reftyp = lc_ref BINARY SEARCH.
  IF sy-subrc = 0.
    "SAIDA SD
    CALL METHOD fill_payment_out
      EXPORTING
        is_header  = is_header
        it_nflin   = it_nflin
        is_vbrk    = is_vbrk
      CHANGING
        ct_payment = ct_payment.

  ELSE.
    IF is_header-direct EQ lc_entrada
   AND ct_payment IS INITIAL.
      " ENTRADA MM
      CALL METHOD fill_payment_in
        EXPORTING
          is_header  = is_header
          it_nflin   = it_nflin
        CHANGING
          ct_payment = ct_payment.
    ENDIF.
  ENDIF.

  TRY.
      lo_param->m_get_single( EXPORTING iv_modulo = 'SD'
                                        iv_chave1 = 'CONTRATOS FOOD'
                                        iv_chave2 = 'ENTRADA MM'
                                        iv_chave3 = 'MWSKZ'
                              IMPORTING ev_param  = lv_mwskz ).
    CATCH zcxca_tabela_parametros.
  ENDTRY.

  IF lv_mwskz IS NOT INITIAL.
    LOOP AT lt_nflin ASSIGNING <fs_nflin>.
      IF <fs_nflin>-mwskz = lv_mwskz.
        APPEND INITIAL LINE TO ct_payment ASSIGNING <fs_payment>.
        <fs_payment>-mandt   = sy-mandt.
        <fs_payment>-docnum  = is_header-docnum.
        <fs_payment>-ind_pag = '1'.
        <fs_payment>-counter = 1.
        <fs_payment>-t_pag   = '90'.
        CLEAR <fs_payment>-v_pag.
      ENDIF.
    ENDLOOP.
  ENDIF.
*    ENDCASE.

  DELETE ADJACENT DUPLICATES FROM ct_payment COMPARING docnum counter.
