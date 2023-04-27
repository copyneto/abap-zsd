*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_CBENEF.....................................*
FORM GET_DATA_ZVSD_CBENEF.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_CBENEF WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_CBENEF .
ZVSD_CBENEF-CLIENT =
ZTSD_CBENEF-CLIENT .
ZVSD_CBENEF-ID =
ZTSD_CBENEF-ID .
ZVSD_CBENEF-SHIPFROM =
ZTSD_CBENEF-SHIPFROM .
ZVSD_CBENEF-SHIPTO =
ZTSD_CBENEF-SHIPTO .
ZVSD_CBENEF-AUART =
ZTSD_CBENEF-AUART .
ZVSD_CBENEF-AUGRU =
ZTSD_CBENEF-AUGRU .
ZVSD_CBENEF-MATNR =
ZTSD_CBENEF-MATNR .
ZVSD_CBENEF-MATKL =
ZTSD_CBENEF-MATKL .
ZVSD_CBENEF-BWART =
ZTSD_CBENEF-BWART .
ZVSD_CBENEF-CFOP =
ZTSD_CBENEF-CFOP .
ZVSD_CBENEF-TAXSIT =
ZTSD_CBENEF-TAXSIT .
ZVSD_CBENEF-CBENEF =
ZTSD_CBENEF-CBENEF .
ZVSD_CBENEF-MOTDESICMS =
ZTSD_CBENEF-MOTDESICMS .
ZVSD_CBENEF-TIPO_CALC =
ZTSD_CBENEF-TIPO_CALC .
<VIM_TOTAL_STRUC> = ZVSD_CBENEF.
    APPEND TOTAL.
  ENDSELECT.
  SORT TOTAL BY <VIM_XTOTAL_KEY>.
  <STATUS>-ALR_SORTED = 'R'.
*.check dynamic selectoptions (not in DDIC)...........................*
  IF X_HEADER-SELECTION NE SPACE.
    PERFORM CHECK_DYNAMIC_SELECT_OPTIONS.
  ELSEIF X_HEADER-DELMDTFLAG NE SPACE.
    PERFORM BUILD_MAINKEY_TAB.
  ENDIF.
  REFRESH EXTRACT.
ENDFORM.
*---------------------------------------------------------------------*
FORM DB_UPD_ZVSD_CBENEF .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_CBENEF.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_CBENEF-ST_DELETE EQ GELOESCHT.
     READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
     IF SY-SUBRC EQ 0.
       DELETE EXTRACT INDEX SY-TABIX.
     ENDIF.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN GELOESCHT.
  SELECT SINGLE FOR UPDATE * FROM ZTSD_CBENEF WHERE
  ID = ZVSD_CBENEF-ID AND
  SHIPFROM = ZVSD_CBENEF-SHIPFROM AND
  SHIPTO = ZVSD_CBENEF-SHIPTO AND
  AUART = ZVSD_CBENEF-AUART AND
  AUGRU = ZVSD_CBENEF-AUGRU AND
  MATNR = ZVSD_CBENEF-MATNR AND
  MATKL = ZVSD_CBENEF-MATKL AND
  BWART = ZVSD_CBENEF-BWART AND
  CFOP = ZVSD_CBENEF-CFOP AND
  TAXSIT = ZVSD_CBENEF-TAXSIT .
    IF SY-SUBRC = 0.
    DELETE ZTSD_CBENEF .
    ENDIF.
    IF STATUS-DELETE EQ GELOESCHT.
      READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY> BINARY SEARCH.
      DELETE EXTRACT INDEX SY-TABIX.
    ENDIF.
    DELETE TOTAL.
    IF X_HEADER-DELMDTFLAG NE SPACE.
      PERFORM DELETE_FROM_MAINKEY_TAB.
    ENDIF.
   WHEN OTHERS.
  SELECT SINGLE FOR UPDATE * FROM ZTSD_CBENEF WHERE
  ID = ZVSD_CBENEF-ID AND
  SHIPFROM = ZVSD_CBENEF-SHIPFROM AND
  SHIPTO = ZVSD_CBENEF-SHIPTO AND
  AUART = ZVSD_CBENEF-AUART AND
  AUGRU = ZVSD_CBENEF-AUGRU AND
  MATNR = ZVSD_CBENEF-MATNR AND
  MATKL = ZVSD_CBENEF-MATKL AND
  BWART = ZVSD_CBENEF-BWART AND
  CFOP = ZVSD_CBENEF-CFOP AND
  TAXSIT = ZVSD_CBENEF-TAXSIT .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_CBENEF.
    ENDIF.
ZTSD_CBENEF-CLIENT =
ZVSD_CBENEF-CLIENT .
ZTSD_CBENEF-ID =
ZVSD_CBENEF-ID .
ZTSD_CBENEF-SHIPFROM =
ZVSD_CBENEF-SHIPFROM .
ZTSD_CBENEF-SHIPTO =
ZVSD_CBENEF-SHIPTO .
ZTSD_CBENEF-AUART =
ZVSD_CBENEF-AUART .
ZTSD_CBENEF-AUGRU =
ZVSD_CBENEF-AUGRU .
ZTSD_CBENEF-MATNR =
ZVSD_CBENEF-MATNR .
ZTSD_CBENEF-MATKL =
ZVSD_CBENEF-MATKL .
ZTSD_CBENEF-BWART =
ZVSD_CBENEF-BWART .
ZTSD_CBENEF-CFOP =
ZVSD_CBENEF-CFOP .
ZTSD_CBENEF-TAXSIT =
ZVSD_CBENEF-TAXSIT .
ZTSD_CBENEF-CBENEF =
ZVSD_CBENEF-CBENEF .
ZTSD_CBENEF-MOTDESICMS =
ZVSD_CBENEF-MOTDESICMS .
ZTSD_CBENEF-TIPO_CALC =
ZVSD_CBENEF-TIPO_CALC .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_CBENEF ##WARN_OK.
    ELSE.
    INSERT ZTSD_CBENEF .
    ENDIF.
    READ TABLE EXTRACT WITH KEY <VIM_XTOTAL_KEY>.
    IF SY-SUBRC EQ 0.
      <XACT> = ORIGINAL.
      MODIFY EXTRACT INDEX SY-TABIX.
    ENDIF.
    <ACTION> = ORIGINAL.
    MODIFY TOTAL.
  ENDCASE.
ENDLOOP.
CLEAR: STATUS_ZVSD_CBENEF-UPD_FLAG,
STATUS_ZVSD_CBENEF-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_CBENEF.
  SELECT SINGLE * FROM ZTSD_CBENEF WHERE
ID = ZVSD_CBENEF-ID AND
SHIPFROM = ZVSD_CBENEF-SHIPFROM AND
SHIPTO = ZVSD_CBENEF-SHIPTO AND
AUART = ZVSD_CBENEF-AUART AND
AUGRU = ZVSD_CBENEF-AUGRU AND
MATNR = ZVSD_CBENEF-MATNR AND
MATKL = ZVSD_CBENEF-MATKL AND
BWART = ZVSD_CBENEF-BWART AND
CFOP = ZVSD_CBENEF-CFOP AND
TAXSIT = ZVSD_CBENEF-TAXSIT .
ZVSD_CBENEF-CLIENT =
ZTSD_CBENEF-CLIENT .
ZVSD_CBENEF-ID =
ZTSD_CBENEF-ID .
ZVSD_CBENEF-SHIPFROM =
ZTSD_CBENEF-SHIPFROM .
ZVSD_CBENEF-SHIPTO =
ZTSD_CBENEF-SHIPTO .
ZVSD_CBENEF-AUART =
ZTSD_CBENEF-AUART .
ZVSD_CBENEF-AUGRU =
ZTSD_CBENEF-AUGRU .
ZVSD_CBENEF-MATNR =
ZTSD_CBENEF-MATNR .
ZVSD_CBENEF-MATKL =
ZTSD_CBENEF-MATKL .
ZVSD_CBENEF-BWART =
ZTSD_CBENEF-BWART .
ZVSD_CBENEF-CFOP =
ZTSD_CBENEF-CFOP .
ZVSD_CBENEF-TAXSIT =
ZTSD_CBENEF-TAXSIT .
ZVSD_CBENEF-CBENEF =
ZTSD_CBENEF-CBENEF .
ZVSD_CBENEF-MOTDESICMS =
ZTSD_CBENEF-MOTDESICMS .
ZVSD_CBENEF-TIPO_CALC =
ZTSD_CBENEF-TIPO_CALC .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_CBENEF USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_CBENEF-ID TO
ZTSD_CBENEF-ID .
MOVE ZVSD_CBENEF-SHIPFROM TO
ZTSD_CBENEF-SHIPFROM .
MOVE ZVSD_CBENEF-SHIPTO TO
ZTSD_CBENEF-SHIPTO .
MOVE ZVSD_CBENEF-AUART TO
ZTSD_CBENEF-AUART .
MOVE ZVSD_CBENEF-AUGRU TO
ZTSD_CBENEF-AUGRU .
MOVE ZVSD_CBENEF-MATNR TO
ZTSD_CBENEF-MATNR .
MOVE ZVSD_CBENEF-MATKL TO
ZTSD_CBENEF-MATKL .
MOVE ZVSD_CBENEF-BWART TO
ZTSD_CBENEF-BWART .
MOVE ZVSD_CBENEF-CFOP TO
ZTSD_CBENEF-CFOP .
MOVE ZVSD_CBENEF-TAXSIT TO
ZTSD_CBENEF-TAXSIT .
MOVE ZVSD_CBENEF-CLIENT TO
ZTSD_CBENEF-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_CBENEF'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_CBENEF TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_CBENEF'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
