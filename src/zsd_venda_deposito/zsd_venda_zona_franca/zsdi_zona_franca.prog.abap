*&---------------------------------------------------------------------*
*& Include          ZSDI_ZONA_FRANCA
*&---------------------------------------------------------------------*

  vbap-j_1btaxlw2 = NEW zclsd_zona_franca(  )->execute(
    iv_j_1btaxlw2 = vbap-j_1btaxlw2
    iv_werks = vbap-werks
    iv_txjcd = tkomk-txjcd
    iv_brsch = tkomk-brsch
    iv_matkl = vbap-matkl
  ).

  DATA: ls_pis_confins TYPE ztsd_pis_cofins,
        lv_cofins      TYPE knuma_bo,
        lv_pis         TYPE knuma_bo.

  CONSTANTS: lc_icol TYPE komv-kschl VALUE 'ICOL',
             lc_bpil TYPE komv-kschl VALUE 'BPIL'.

*  SELECT SINGLE tdt
*     FROM ztsd_pis_cofins
*    INTO ls_pis_confins
*        WHERE werks = vbap-werks
*          AND brsch = tkomk-brsch
*          AND tdt   = tkomk-tdt
*          AND matkl = vbap-matkl.
*
*  IF ls_pis_confins IS NOT INITIAL.

  DATA(lt_xkomv) = xkomv[].
* LSCHEPP - 8000006853 - Erro no CST do PIS - 28.04.2023 Início
*    SORT lt_xkomv BY kschl.
  SORT lt_xkomv BY kschl kposn.
* LSCHEPP - 8000006853 - Erro no CST do PIS - 28.04.2023 Fim
  READ TABLE lt_xkomv[] ASSIGNING FIELD-SYMBOL(<fs_xkomv>) WITH KEY kschl = lc_icol
                                                                    kposn = vbap-posnr BINARY SEARCH.
  IF sy-subrc = 0.

    SELECT SINGLE knuma_bo
      FROM konp
      INTO lv_cofins
      WHERE knumh = <fs_xkomv>-knumh.

    IF sy-subrc = 0.
      vbap-j_1btaxlw4  = lv_cofins.
    ENDIF.

  ENDIF.

* LSCHEPP - 8000006853 - Erro no CST do PIS - 28.04.2023 Início
  SORT lt_xkomv BY kschl kposn.
* LSCHEPP - 8000006853 - Erro no CST do PIS - 28.04.2023 Fim

  READ TABLE lt_xkomv ASSIGNING <fs_xkomv> WITH KEY kschl = lc_bpil
                                                    kposn = vbap-posnr BINARY SEARCH.
  IF sy-subrc = 0.

    SELECT SINGLE knuma_bo
      FROM konp
      INTO lv_pis
      WHERE knumh = <fs_xkomv>-knumh.

    IF sy-subrc = 0.
      vbap-j_1btaxlw5  = lv_pis.
    ENDIF.

  ENDIF.

*  ENDIF.
