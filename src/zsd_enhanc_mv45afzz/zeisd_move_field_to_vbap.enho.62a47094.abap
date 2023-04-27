"Name: \PR:SAPMV45A\FO:USEREXIT_MOVE_FIELD_TO_VBAP\SE:BEGIN\EI
ENHANCEMENT 0 ZEISD_MOVE_FIELD_TO_VBAP.
*INCLUDE zsdi_tratar_devolucao_st_rs IF FOUND.

*** Transfere POSNR para POSEX VBAP
  IF sy-tcode NE 'VA03'.
    vbap-posex = vbap-posnr.
  ENDIF.

  IF ( vbkd-bsark EQ 'CARG' OR vbkd-bsark EQ 'FLUI' ) AND
     ( vbak-auart EQ 'Z023' OR vbak-auart EQ 'Z024' ).
    vbap-kwmeng   = '1.000'.
    veda-vlaufz   = 1.
    veda-vlaufk   = '02'.
    veda-vlauez   = '4'.
    veda-vkuesch  = '0001'.
  ENDIF.

ENDENHANCEMENT.
