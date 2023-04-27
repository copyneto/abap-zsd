*&---------------------------------------------------------------------*
*& Include          ZSDI_GNRE_CALC_ICMS_PART_SAVE
*&---------------------------------------------------------------------*
  IF sy-ucomm <> 'KTPR' AND tkomk IS NOT INITIAL AND tkomp IS NOT INITIAL AND
    vbrk IS NOT INITIAL AND vbrp IS NOT INITIAL AND xkomv[] IS NOT INITIAL AND
    vbrk-vbeln IS NOT INITIAL AND vbrk-vbeln(1) <> '$'.

    SELECT COUNT(*)
      FROM vbrk
      WHERE vbeln = vbrk-vbeln.

    "Executa apenas para os casos onde o documento não existe
    IF sy-subrc IS NOT INITIAL.
      DATA(lo_gnre_calc_icms_partilha) = NEW zclsd_gnre_calc_icms_partilha( ).

      TRY.
          DATA(ls_tkomp) = tkomp[ kposn = vbrp-posnr ].
        CATCH cx_sy_itab_line_not_found.
          ls_tkomp = tkomp.
      ENDTRY.

      "Armazena o cálculo de ICMS Partilha, Pessoa Física
      lo_gnre_calc_icms_partilha->calculate_save( is_komk = tkomk
                                                  is_komp = ls_tkomp
                                                  is_komv = CORRESPONDING #( xkomv[] )
                                                  is_vbrk = vbrk
                                                  is_vbrp = vbrp                       ).

    ENDIF.

  ENDIF.
