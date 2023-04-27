"Name: \PR:SAPLV60A\FO:USEREXIT_PRICING_PREPARE_TKOMK\SE:END\EI
ENHANCEMENT 0 ZEISD_PRICING_PREPARE_TKOMK_2.
CONSTANTS: lc_sich type sy-ucomm VALUE 'SICH',
           lc_samo type sy-ucomm VALUE 'SAMO',
           lc_vf01 type sy-tcode VALUE 'VF01',
           lc_vf04 type sy-tcode VALUE 'VF04'.

IF  sy-ucomm EQ lc_sich OR  sy-ucomm EQ lc_samo
  OR  sy-tcode EQ lc_vf01 OR  sy-tcode EQ lc_vf04 .

    INCLUDE zsdi_calculo_ciclo_ped_fat IF FOUND.    " GAP SD-347 - CGALORO
    INCLUDE zsdi_refer_bonificacao IF FOUND.        "Ajuste GAP 175 - VARAUJO
    INCLUDE zsdi_suframa IF FOUND.
    INCLUDE zsdi_ov_bloqueada_faturamento IF FOUND.

  ENDIF.

ENDENHANCEMENT.
