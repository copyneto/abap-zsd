*&---------------------------------------------------------------------*
*& Include          ZSDI_DIFERIMENTO
*&---------------------------------------------------------------------*

  CONSTANTS:
    lc_condicao_iclw TYPE komv-kschl VALUE 'ICLW'.
  DATA:
    lv_lei_icms TYPE konp-knuma_bo,
    lv_taxlw1   TYPE j_1bsdica-taxlw1.

  IF ( vbak-auart <> 'Z022' AND vbak-auart <> 'Z016' ) AND vbak-vbtyp <> 'H'.  "Nota complementar de imposto
    DATA(lt_xkomv_dif) = xkomv[].
    SORT lt_xkomv_dif BY kposn kschl.
    READ TABLE lt_xkomv_dif ASSIGNING FIELD-SYMBOL(<fs_xkomv_dif>) WITH KEY kposn = vbap-posnr kschl = lc_condicao_iclw BINARY SEARCH.
    IF sy-subrc = 0.
      SELECT SINGLE knuma_bo
        FROM konp
        INTO lv_lei_icms
        WHERE knumh = <fs_xkomv_dif>-knumh.

      IF sy-subrc = 0.
        vbap-j_1btaxlw1  = lv_lei_icms.
      ELSE.
        DATA(lv_busca_j_1bsdica) = abap_true.
      ENDIF.
    ELSE.
      lv_busca_j_1bsdica = abap_true.
    ENDIF.

    IF lv_busca_j_1bsdica = abap_true.
      SELECT SINGLE taxlw1 FROM j_1bsdica
        INTO lv_taxlw1
        WHERE auart = vbak-auart
          AND pstyv = vbap-pstyv.
      IF sy-subrc = 0.
        vbap-j_1btaxlw1 = lv_taxlw1.
      ENDIF.
    ENDIF.
  ENDIF.
