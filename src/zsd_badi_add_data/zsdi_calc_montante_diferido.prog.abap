*&---------------------------------------------------------------------*
*& Include          ZSDI_CALC_MONTANTE_DIFERIDO
*&---------------------------------------------------------------------*
DATA: lv_rate      TYPE i,
      lv_vicms     TYPE f,
      lv_vicmsop   TYPE f,
      lv_vicmsdif1 TYPE f.


CLEAR ls_mont_dif.

IF <fs_nflin1>-reftyp = gc_fat.

  READ TABLE lt_vbrp_aux ASSIGNING FIELD-SYMBOL(<fs_vbrp>) WITH KEY posnr = <fs_nflin1>-refitm
                                                           BINARY SEARCH.

  IF sy-subrc = 0.

    READ TABLE lt_itens_add ASSIGNING FIELD-SYMBOL(<fs_item_adicional>) WITH KEY itmnum = <fs_nflin1>-itmnum
                                                                        BINARY SEARCH.

    IF sy-subrc = 0.

      SELECT SINGLE knumv FROM vbak INTO @DATA(lv_knumv) WHERE vbeln = @<fs_vbrp>-aubel.

      IF lv_knumv IS NOT INITIAL.
        SELECT prcd_elements~kbetr
          FROM prcd_elements
          INTO @DATA(lv_kbetr)
          UP TO 1 ROWS
          WHERE knumv = @lv_knumv
            AND kposn = @<fs_vbrp>-aupos
            AND kschl = @lc_kschl.
        ENDSELECT.
      ENDIF.

      READ TABLE lt_wnfstx_tab ASSIGNING FIELD-SYMBOL(<fs_wnfstx>) WITH KEY docnum = <fs_nflin1>-docnum
                                                                            itmnum = <fs_nflin1>-itmnum
                                                                            taxtyp = lc_taxtyp BINARY SEARCH.
      IF sy-subrc = 0.
        lv_kzwi6_aux  = lv_kbetr.
        lv_novokzwi6  = 1 - ( lv_kzwi6_aux / 100 ).
        lv_vicmsdif1  = ( <fs_wnfstx>-taxval / lv_novokzwi6  ) * lv_kzwi6_aux.

        lv_vicmsdif1 = lv_vicmsdif1 / 100.

        IF  <fs_nflin1>-taxsit EQ 'B'.
          DATA(lv_rate_i) = <fs_wnfstx>-rate.
          IF NOT <fs_wnfstx>-base IS INITIAL.
            lv_rate = ( ( lv_vicmsdif1 + <fs_wnfstx>-taxval ) / <fs_wnfstx>-base ) * 100.
            <fs_wnfstx>-rate = lv_rate.


            lv_vicmsop = <fs_wnfstx>-rate * <fs_wnfstx>-base / 100.
            lv_vicms = <fs_wnfstx>-base * lv_rate_i / 100.
            lv_vicmsdif1 = lv_vicmsop - lv_vicms.
            lv_vicmsdif = lv_vicmsdif1.
          ENDIF.
        ELSE.
          lv_vicmsdif = lv_vicmsdif1.
        ENDIF.

      ENDIF.

      CLEAR lv_kbetr.

    ENDIF.

  ENDIF.

  ls_mont_dif-matnr    = <fs_nflin1>-matnr.
  ls_mont_dif-vicmsdif = lv_vicmsdif.
  COLLECT ls_mont_dif INTO lt_mont_dif.

ENDIF.
