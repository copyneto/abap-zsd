*&---------------------------------------------------------------------*
*& Include          ZSDI_MARKETPLACE_J1B1N
*&---------------------------------------------------------------------*
IF it_nflin IS NOT INITIAL.

  DATA(lv_vbelv) = CONV vbfa-vbelv( it_nflin[ 1 ]-refkey ).

  SELECT SINGLE vbeln
    FROM vbfa
    INTO @DATA(lv_vbeln)
    WHERE vbelv EQ @lv_vbelv.

  IF sy-subrc IS INITIAL.

    SELECT SINGLE lifnr
      FROM vbpa
      INTO @DATA(lv_lifnr)
      WHERE vbeln EQ @lv_vbeln
        AND parvw EQ 'RP'.

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

      ENDIF.

    ENDIF.

  ENDIF.

ENDIF.
