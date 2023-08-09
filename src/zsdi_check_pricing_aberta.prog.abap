***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Pricing aberta                                         *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 01/02/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_CHECK_PRICING_ABERTA
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


DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

TRY.
    lo_param->m_get_range( EXPORTING iv_modulo = lc_param_ord-modulo
                                     iv_chave1 = lc_param_ord-chave1
                                     iv_chave2 = lc_param_ord-chave2
                           IMPORTING et_range  = lt_auart ).
    IF comm_head_i-auart IN lt_auart.
      TRY.
          lo_param->m_get_range( EXPORTING iv_modulo = lc_param_cond-modulo
                                           iv_chave1 = lc_param_cond-chave1
                                           iv_chave2 = lc_param_cond-chave2
                                 IMPORTING et_range  = lt_kschl ).
          LOOP AT komt1 ASSIGNING FIELD-SYMBOL(<fs_komt1>) WHERE kschl IN lt_kschl.
            <fs_komt1>-kmanu = 'C'.
            <fs_komt1>-kposi = 'X'.
          ENDLOOP.
        CATCH zcxca_tabela_parametros.
      ENDTRY.
    ENDIF.
  CATCH zcxca_tabela_parametros.
ENDTRY.
