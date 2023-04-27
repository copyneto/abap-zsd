
*&---------------------------------------------------------------------*
*& Include          ZSDI_CONVERT_PESOL_PESOB
*&---------------------------------------------------------------------*
DATA: lv_matnr   TYPE mara-matnr,
      lv_in_me   TYPE mara-meins,
      lv_out_me  TYPE mara-meins,
      lv_menge_i TYPE ekpo-menge,
      lv_menge_o TYPE ekpo-menge.


REFRESH lt_item.
lt_item = it_nflin.

TRY.
    DATA(ls_item) = lt_item[ 1 ].
    SELECT SINGLE matnr, meins, brgew, ntgew, gewei
      FROM mara
      INTO @DATA(ls_mara)
      WHERE matnr EQ @ls_item-matnr.
    IF sy-subrc EQ 0.

      IF ls_mara-meins NE ls_item-meins.

        lv_matnr   = ls_mara-matnr.
        lv_in_me   = ls_item-meins.
        lv_out_me  = ls_mara-meins.
        lv_menge_i = ls_item-menge.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = lv_matnr
            i_in_me              = lv_in_me
            i_out_me             = lv_out_me
            i_menge              = lv_menge_i
          IMPORTING
            e_menge              = lv_menge_o
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.
      ELSE.
        lv_menge_o = ls_item-menge.
      ENDIF.

      IF <fs_transvol>-pesob IS INITIAL.
        <fs_transvol>-pesob = lv_menge_o * ls_mara-brgew.
      ENDIF.
      IF <fs_transvol>-pesol IS INITIAL.
        <fs_transvol>-pesol = lv_menge_o * ls_mara-ntgew.
      ENDIF.

    ENDIF.
  CATCH cx_sy_itab_line_not_found.
ENDTRY.
