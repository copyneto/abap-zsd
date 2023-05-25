*&---------------------------------------------------------------------*
*& Include          ZSDI_CTRL_BLOQUEIO_REMESSA
*&---------------------------------------------------------------------*

CONSTANTS:                                                  "8000006102
  lc_module_sd       TYPE ze_param_modulo  VALUE 'SD',      "8000006102
  lc_parameter_wevo  TYPE ze_param_chave   VALUE 'WEVO',    "8000006102
  lc_parameter_augru TYPE ze_param_chave   VALUE 'AUGRU',   "8000006102
  lc_parameter_devol TYPE ze_param_chave_3 VALUE 'DEVOL'.   "8000006102

DATA:                                                       "8000006102
  parameter_value TYPE augru.                               "8000006102

IF t180-trtyp = 'H'.

* LSCHEPP - SD - 8000007558 - Cancelamento pedido Ecomm - 23.05.2023 Início
  IF vbak-faksk EQ '15'.
    MESSAGE e014(zsd).
  ENDIF.
* LSCHEPP - SD - 8000007558 - Cancelamento pedido Ecomm - 23.05.2023 Fim

  ">>> 8000006102: Bloqueio remessa - FURTO/EXTRAVIO
  TRY.
      DATA(sales_order) = xlips[ 1 ]-vgbel.

      SELECT SINGLE augru
        FROM vbak
        WHERE vbeln = @sales_order
        INTO @DATA(sales_reason).

      IF sy-subrc <> 0.
        sales_reason = vbak-augru.
      ENDIF.

      NEW zclca_tabela_parametros( )->m_get_single(
                                        EXPORTING
                                          iv_modulo = lc_module_sd
                                          iv_chave1 = lc_parameter_wevo
                                          iv_chave2 = lc_parameter_augru
                                          iv_chave3 = lc_parameter_devol
                                        IMPORTING
                                          ev_param  = parameter_value
                                      ).

      IF sales_reason = parameter_value.
        CLEAR xlikp[ 1 ]-lifsk.
        CLEAR xlikp-lifsk.
        RETURN.
      ENDIF.

    CATCH zcxca_tabela_parametros. "Parâmetro não encontrado
      "Nada a fazer

    CATCH cx_sy_itab_line_not_found. "Registro não encontrado na tabela XLIPS/XLIKP
      "Nada a fazer
  ENDTRY.
  "<<< 8000006102: Bloqueio remessa - FURTO/EXTRAVIO

  IF xlikp-lifsk IS INITIAL.

    SELECT lifsp,
           lfart
      UP TO 1 ROWS
      FROM tvlsp
      INTO @DATA(lv_tvlsp)
      WHERE lfart = @xlikp-lfart.
    ENDSELECT.

    IF sy-subrc IS INITIAL.

      xlikp-lifsk = lv_tvlsp-lifsp.

      READ TABLE xlikp[] ASSIGNING FIELD-SYMBOL(<fs_xlikp>) INDEX 1.
      IF <fs_xlikp> IS ASSIGNED.
        <fs_xlikp>-lifsk = lv_tvlsp-lifsp.
      ENDIF.

    ENDIF.
  ENDIF.
ENDIF.
