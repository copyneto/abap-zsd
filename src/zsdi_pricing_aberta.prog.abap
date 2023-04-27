***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Pricing aberta                                         *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 19/01/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_PRICING_ABERTA
*&--------------------------------------------------------------------*
CONSTANTS: BEGIN OF lc_param_ord,
             modulo TYPE ztca_param_par-modulo VALUE 'SD',
             chave1 TYPE ztca_param_par-chave1 VALUE 'ORD_PRICE_ABERTA',
             chave2 TYPE ztca_param_par-chave2 VALUE 'AUART',
           END OF lc_param_ord,

           BEGIN OF lc_param_cond,
             modulo TYPE ztca_param_par-modulo VALUE 'SD',
             chave1 TYPE ztca_param_par-chave1 VALUE 'COND_PRICE_ABERTA',
             chave2 TYPE ztca_param_par-chave2 VALUE 'KSCHL',
           END OF lc_param_cond.

DATA: lt_auart TYPE RANGE OF auart,
      lt_kschl TYPE RANGE OF kschl.


DATA(lo_param) = NEW zclca_tabela_parametros( ).

TRY.
    lo_param->m_get_range( EXPORTING iv_modulo = lc_param_ord-modulo
                                     iv_chave1 = lc_param_ord-chave1
                                     iv_chave2 = lc_param_ord-chave2
                           IMPORTING et_range  = lt_auart ).
    IF vbak-auart IN lt_auart.
      TRY.
          lo_param->m_get_range( EXPORTING iv_modulo = lc_param_cond-modulo
                                           iv_chave1 = lc_param_cond-chave1
                                           iv_chave2 = lc_param_cond-chave2
                                 IMPORTING et_range  = lt_kschl ).
          LOOP AT xkomv ASSIGNING FIELD-SYMBOL(<fs_xkomv>) WHERE kschl IN lt_kschl.
            <fs_xkomv>-kmanu     = 'C'.
            <fs_xkomv>-kaend_btr = abap_true.
            <fs_xkomv>-kaend_wrt = abap_true.
          ENDLOOP.
        CATCH zcxca_tabela_parametros.
      ENDTRY.
    ENDIF.
  CATCH zcxca_tabela_parametros.
ENDTRY.
