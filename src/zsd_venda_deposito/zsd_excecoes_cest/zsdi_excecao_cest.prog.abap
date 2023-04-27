*&---------------------------------------------------------------------*
*& Include          ZSDI_EXCECAO_CEST
*&---------------------------------------------------------------------*

DATA: ls_pis_confins TYPE ztsd_pis_cofins,
      lv_cofins      TYPE knuma_bo,
      lv_pis         TYPE knuma_bo.

SELECT  SINGLE *
   FROM ztsd_pis_cofins
  INTO ls_pis_confins
      WHERE werks = komp-werks
        AND brsch = komk-brsch
        AND tdt   = komk-tdt
        AND matkl = komp-matkl.

IF sy-subrc = 0.

  READ TABLE xkomv[] ASSIGNING FIELD-SYMBOL(<fs_xkomv>) WITH KEY kschl = 'ICOL'.
  IF sy-subrc = 0.

    SELECT SINGLE knuma_bo
      FROM konp
      INTO lv_cofins
      WHERE knumh = <fs_xkomv>-knumh.

    IF sy-subrc = 0.
      vbap-j_1btaxlw4  = lv_cofins.
    ENDIF.

  ENDIF.

  READ TABLE xkomv[] ASSIGNING <fs_xkomv> WITH KEY kschl = 'BPIL'.
  IF sy-subrc = 0.

    SELECT SINGLE knuma_bo
      FROM konp
      INTO lv_pis
      WHERE knumh = <fs_xkomv>-knumh.

    IF sy-subrc = 0.
      vbap-j_1btaxlw5  = lv_pis.
    ENDIF.

  ENDIF.

ENDIF.
