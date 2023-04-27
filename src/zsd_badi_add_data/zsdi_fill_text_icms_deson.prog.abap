*&---------------------------------------------------------------------*
*& Include ZSDI_FILL_TEXT_ICMS_DESON
*&---------------------------------------------------------------------*

DATA: lv_deson      TYPE c LENGTH 15,
      lv_icms_deson TYPE j_1bnfstx-taxval.

READ TABLE lt_wnfstx_tab ASSIGNING <fs_wnfstx> WITH KEY docnum = <fs_nflin>-docnum
                                                        itmnum = <fs_nflin>-itmnum
                                                        taxtyp = lc_taxtyp2 BINARY SEARCH.
IF sy-subrc = 0.
  lv_icms_deson = <fs_wnfstx>-taxval.
  MULTIPLY lv_icms_deson BY -1.
  WRITE lv_icms_deson TO lv_deson NO-GAP CURRENCY 'BRL'.
  CONDENSE lv_deson.
  <fs_item_add>-infadprod  = |{ <fs_item_add>-infadprod } { TEXT-t02 } { lv_deson }|.
ENDIF.
