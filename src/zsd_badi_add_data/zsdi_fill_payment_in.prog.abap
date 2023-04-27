*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_PAYMENT_IN
*&---------------------------------------------------------------------*
    CONSTANTS:
      lc_indpag  TYPE char1  VALUE '0',
      lc_doctyp  TYPE char1  VALUE '8',
      lc_doctyp2 TYPE char1  VALUE '6',
      lc_vpag    TYPE char4  VALUE '0.00',

      BEGIN OF lc_param_paym_in,
        modulo TYPE ztca_param_par-modulo VALUE 'MM',
        chave1 TYPE ztca_param_par-chave1 VALUE 'SUBCON',
        reftyp TYPE ztca_param_par-chave2 VALUE 'REFTYP',
        itmtyp TYPE ztca_param_par-chave2 VALUE 'ITMTYP',
      END OF lc_param_paym_in.

    DATA(ls_payment) = VALUE j_1bnfe_s_badi_payment_400( mandt   = sy-mandt
                                                         docnum  = is_header-docnum
                                                         counter = 1
                                                         v_pag = is_header-nftot
                                                         ind_pag = lc_indpag ).

    IF is_header-doctyp = lc_doctyp.

      ls_payment-t_pag   = gc_nenhum_pag.

    ELSE.

      ls_payment-t_pag   = gc_outros.

    ENDIF.


    IF is_header-doctyp = lc_doctyp2.

      ls_payment-t_pag   = gc_nenhum_pag.
      ls_payment-v_pag   = lc_vpag .

    ENDIF.

*    DATA(lo_param) = NEW zclca_tabela_parametros( ).
*
*    TRY.
*        lo_param->m_get_single( EXPORTING iv_modulo = lc_param_paym_in-modulo
*                                          iv_chave1 = lc_param_paym_in-chave1
*                                          iv_chave2 = lc_param_paym_in-reftyp
*                                IMPORTING ev_param  = lv_reftyp ).
*        TRY.
*            lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
*                                             iv_chave1 = lc_param-chave1
*                                             iv_chave2 = lc_param-itmtyp
*                                   IMPORTING et_range  = lt_itmtyp ).
*            LOOP AT lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>) WHERE reftyp EQ lv_reftyp
*                                                                  AND itmtyp IN lt_itmtyp.
*              APPEND INITIAL LINE TO ct_payment ASSIGNING FIELD-SYMBOL(<fs_payment>).
*              <fs_payment>-mandt   = sy-mandt.
*              <fs_payment>-docnum  = is_header-docnum.
*              <fs_payment>-ind_pag = '1'.
*              <fs_payment>-counter = 1.
*              <fs_payment>-t_pag   = '90'.
*              CLEAR <fs_payment>-v_pag.
*            ENDLOOP.
*          CATCH zcxca_tabela_parametros.
*        ENDTRY.
*      CATCH zcxca_tabela_parametros.
*    ENDTRY.

    APPEND ls_payment TO ct_payment.

    IF is_header-land1 NE gc_land. "Importação
      SORT ct_payment BY counter.
      READ TABLE ct_payment ASSIGNING FIELD-SYMBOL(<fs_payment>) WITH KEY counter = 1 BINARY SEARCH.
      IF sy-subrc EQ 0.
        <fs_payment>-ind_pag = lc_indpag.
      ENDIF.
    ENDIF.
