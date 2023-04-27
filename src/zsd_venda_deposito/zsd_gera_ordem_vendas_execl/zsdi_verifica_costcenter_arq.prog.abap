*&---------------------------------------------------------------------*
*& Include          ZSDI_VERIFICA_COSTCENTER_ARQ
*&---------------------------------------------------------------------*
DATA: lt_arq       TYPE TABLE OF ztsd_arq_ordvend,
      lt_vbap      TYPE TABLE OF vbap,
      lr_matnr     TYPE RANGE OF matnr18,
      lv_matnr     TYPE ztsd_arq_ordvend-material,
      lv_refclient TYPE bstkd.

lt_vbap = xvbap[].

LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
  APPEND VALUE #( sign = 'I' option = 'EQ' low = |{ <fs_vbap>-matnr ALPHA = OUT }| ) TO lr_matnr.
ENDLOOP.

IF lr_matnr[] IS NOT INITIAL AND lt_vbap[] IS NOT INITIAL.
  IF vbak-bstnk IS INITIAL.
    lv_refclient = vbkd-bstkd_e.
  ELSE.
    lv_refclient = vbak-bstnk.
  ENDIF.
  SELECT *
  FROM ztsd_arq_ordvend
  INTO TABLE lt_arq
  FOR ALL ENTRIES IN lt_vbap
  WHERE numclient EQ vbak-kunnr
  AND plant       EQ lt_vbap-werks
  AND refclient   EQ lv_refclient
  AND material    IN lr_matnr.
*AND material    EQ lt_vbap-matnr(18).
*AND salesunit   EQ lt_vbap-meins
*AND deposit     EQ lt_vbap-lgort.               "#EC CI_FAE_NO_LINES_OK
ENDIF.
IF lt_arq IS NOT INITIAL.
  SORT lt_arq BY numclient
                 plant
                 refclient
                 material.
*                 salesunit
*                 deposit.

  LOOP AT xvbap[] ASSIGNING FIELD-SYMBOL(<fs_xvbap>).
    PACK <fs_xvbap>-matnr TO lv_matnr.
    CONDENSE lv_matnr.
    READ TABLE lt_arq ASSIGNING FIELD-SYMBOL(<fs_arq>) WITH KEY numclient = vbak-kunnr
                                                                plant     = <fs_xvbap>-werks
                                                                refclient = lv_refclient
                                                                material  = lv_matnr BINARY SEARCH.

    IF sy-subrc = 0 AND <fs_arq>-costcenter IS NOT INITIAL.
      <fs_xvbap>-kostl = <fs_arq>-costcenter.
      vbap-kostl       = <fs_arq>-costcenter.
    ENDIF.
  ENDLOOP.

ENDIF.
