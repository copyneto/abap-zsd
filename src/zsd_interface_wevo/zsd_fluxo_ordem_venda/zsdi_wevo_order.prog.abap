*&---------------------------------------------------------------------*
*& Include          ZSDI_WEVO_ORDER
*&---------------------------------------------------------------------*

  DATA: BEGIN OF ls_param,
          modulo TYPE ztca_param_par-modulo VALUE 'SD',
          chave1 TYPE ztca_param_par-chave1 VALUE 'WEVO',
          chave2 TYPE ztca_param_par-chave2 VALUE 'AUART',
          chave3 TYPE ztca_param_par-chave3 VALUE 'VSART',
        END OF ls_param.

  DATA: lr_auart TYPE RANGE OF vbak-auart.
  DATA(lo_parametros_order) = NEW  zclca_tabela_parametros( ).

  TRY.

      lo_parametros_order->m_get_range(
        EXPORTING
          iv_modulo = ls_param-modulo
          iv_chave1 = ls_param-chave1
          iv_chave2 = ls_param-chave2
          iv_chave3 = ls_param-chave3
        IMPORTING
          et_range  = lr_auart ).

    CATCH zcxca_tabela_parametros.

  ENDTRY.

  CHECK lr_auart IS NOT INITIAL.

  READ TABLE lr_auart WITH KEY low = xvbak-auart INTO DATA(ls_auart).

  CHECK ls_auart IS NOT INITIAL AND ls_auart-high IS NOT INITIAL.

  LOOP AT xvbkd[] ASSIGNING FIELD-SYMBOL(<fs_xvbkd>).
    <fs_xvbkd>-vsart = ls_auart-high.
  ENDLOOP.
