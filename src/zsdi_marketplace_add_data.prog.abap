*&---------------------------------------------------------------------*
*& Include          ZSDI_MARKETPLACE_ADD_DATA
*&---------------------------------------------------------------------*
IF it_vbfa IS NOT INITIAL.

  DATA(lv_vbelv) = CONV vbpa-vbeln( it_vbfa[ 1 ]-vbelv ).

  SELECT SINGLE lifnr
    FROM vbpa
    INTO @DATA(lv_lifnr)
    WHERE vbeln EQ @lv_vbelv
    AND   parvw EQ 'ZE'.

  IF sy-subrc IS INITIAL.

    SELECT SINGLE *
      FROM ztsd_t048
      INTO @DATA(ls_zsdt048)
      WHERE lifnr EQ @lv_lifnr.

    IF sy-subrc IS INITIAL.

      es_header-indintermed  = ls_zsdt048-indintermed.
      es_header-ind_pres     = ls_zsdt048-ind_pres.
      es_header-idcadinttran = ls_zsdt048-idcadinttran.
      es_header-cnpjintermed = ls_zsdt048-cnpjintermed.
*          es_header-cnpj_bupla   = ls_zsdt048-cnpj_bupla.

    ENDIF.
  ENDIF.
ENDIF.
