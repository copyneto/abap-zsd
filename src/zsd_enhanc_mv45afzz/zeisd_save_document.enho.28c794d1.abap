"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT\SE:BEGIN\EI
ENHANCEMENT 0 ZEISD_SAVE_DOCUMENT.
  CONSTANTS lc_sich TYPE sy-ucomm VALUE 'SICH'.
  CONSTANTS lc_ont TYPE sy-ucomm VALUE '&ONT'.

  INCLUDE zsde_salesorder IF FOUND.

  IF sy-ucomm EQ lc_sich
    OR sy-ucomm EQ lc_ont.

    INCLUDE zsdi_calculo_ciclo_ped IF FOUND.    " GAP SD-347 - CGALORO
    INCLUDE zmmi_deposito_fechado_parc IF FOUND.
  ENDIF.

  INCLUDE zsdi_mv45afzz_proce_indus IF FOUND.

ENDENHANCEMENT.
