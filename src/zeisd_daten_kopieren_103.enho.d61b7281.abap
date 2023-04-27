"Name: \PR:SAPFV45C\FO:DATEN_KOPIEREN_103\SE:END\EI
ENHANCEMENT 0 ZEISD_DATEN_KOPIEREN_103.
 DATA lv_guzte TYPE guzte.

 SELECT SINGLE guzte
   FROM knb1
   into lv_guzte
   WHERE kunnr = vbak-kunnr
     AND bukrs = cvbrk-bukrs.
   IF sy-subrc EQ 0.
     vbkd-zterm = lv_guzte.
   ENDIF.
ENDENHANCEMENT.
