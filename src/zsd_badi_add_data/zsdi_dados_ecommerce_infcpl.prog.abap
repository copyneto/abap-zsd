*&---------------------------------------------------------------------*
*& Include ZSDI_DADOS_ECOMMERCE_INFCPL
*&---------------------------------------------------------------------*

IF is_header-form EQ 'ZF55'.

  lt_vbfa = it_vbfa[].
  SORT lt_vbfa  BY vbtyp_v vbtyp_n.
  READ TABLE lt_vbfa ASSIGNING <fs_vbfa> WITH KEY vbtyp_v = lc_remessa
                                                  vbtyp_n = lc_fatura
                                                  BINARY SEARCH.
  IF sy-subrc EQ 0.
    lv_remessa = <fs_vbfa>-vbelv.
  ENDIF.
  DATA(lv_danfe_simpl) = CONV char200( | { TEXT-t04 } { TEXT-t05 } { TEXT-t06 } { lv_remessa }| ).
  SEARCH cs_header-infcpl FOR lv_danfe_simpl.
  IF sy-subrc NE 0.
    cs_header-infcpl = |{ cs_header-infcpl } { lv_danfe_simpl }|.
  ENDIF.

ENDIF.
