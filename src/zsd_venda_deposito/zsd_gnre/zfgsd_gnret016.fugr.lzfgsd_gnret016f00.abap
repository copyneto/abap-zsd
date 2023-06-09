*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET016...................................*
FORM GET_DATA_ZVSD_GNRET016.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GNRET016 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GNRET016 .
ZVSD_GNRET016-MANDT =
ZTSD_GNRET016-MANDT .
ZVSD_GNRET016-SHIPFROM =
ZTSD_GNRET016-SHIPFROM .
ZVSD_GNRET016-SHIPTO =
ZTSD_GNRET016-SHIPTO .
ZVSD_GNRET016-WERKS =
ZTSD_GNRET016-WERKS .
ZVSD_GNRET016-MATNR =
ZTSD_GNRET016-MATNR .
ZVSD_GNRET016-MVA =
ZTSD_GNRET016-MVA .
ZVSD_GNRET016-ICMS_ORIG =
ZTSD_GNRET016-ICMS_ORIG .
ZVSD_GNRET016-ICMS_DEST =
ZTSD_GNRET016-ICMS_DEST .
ZVSD_GNRET016-BC_REDUZIDA_ORIG =
ZTSD_GNRET016-BC_REDUZIDA_ORIG .
ZVSD_GNRET016-BC_REDUZIDA_DEST =
ZTSD_GNRET016-BC_REDUZIDA_DEST .
ZVSD_GNRET016-ALIQ_FCP =
ZTSD_GNRET016-ALIQ_FCP .
ZVSD_GNRET016-BC_REDUZIDA_FCP =
ZTSD_GNRET016-BC_REDUZIDA_FCP .
ZVSD_GNRET016-PAUTA_ST =
ZTSD_GNRET016-PAUTA_ST .
ZVSD_GNRET016-PRECO_FIXO =
ZTSD_GNRET016-PRECO_FIXO .
ZVSD_GNRET016-ALIQ_FIXA =
ZTSD_GNRET016-ALIQ_FIXA .
ZVSD_GNRET016-NUM_UNIDADE =
ZTSD_GNRET016-NUM_UNIDADE .
ZVSD_GNRET016-MEINS =
ZTSD_GNRET016-MEINS .
<VIM_TOTAL_STRUC> = ZVSD_GNRET016.
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
FORM DB_UPD_ZVSD_GNRET016 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GNRET016.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GNRET016-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET016 WHERE
  SHIPFROM = ZVSD_GNRET016-SHIPFROM AND
  SHIPTO = ZVSD_GNRET016-SHIPTO AND
  WERKS = ZVSD_GNRET016-WERKS AND
  MATNR = ZVSD_GNRET016-MATNR .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GNRET016 .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET016 WHERE
  SHIPFROM = ZVSD_GNRET016-SHIPFROM AND
  SHIPTO = ZVSD_GNRET016-SHIPTO AND
  WERKS = ZVSD_GNRET016-WERKS AND
  MATNR = ZVSD_GNRET016-MATNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GNRET016.
    ENDIF.
ZTSD_GNRET016-MANDT =
ZVSD_GNRET016-MANDT .
ZTSD_GNRET016-SHIPFROM =
ZVSD_GNRET016-SHIPFROM .
ZTSD_GNRET016-SHIPTO =
ZVSD_GNRET016-SHIPTO .
ZTSD_GNRET016-WERKS =
ZVSD_GNRET016-WERKS .
ZTSD_GNRET016-MATNR =
ZVSD_GNRET016-MATNR .
ZTSD_GNRET016-MVA =
ZVSD_GNRET016-MVA .
ZTSD_GNRET016-ICMS_ORIG =
ZVSD_GNRET016-ICMS_ORIG .
ZTSD_GNRET016-ICMS_DEST =
ZVSD_GNRET016-ICMS_DEST .
ZTSD_GNRET016-BC_REDUZIDA_ORIG =
ZVSD_GNRET016-BC_REDUZIDA_ORIG .
ZTSD_GNRET016-BC_REDUZIDA_DEST =
ZVSD_GNRET016-BC_REDUZIDA_DEST .
ZTSD_GNRET016-ALIQ_FCP =
ZVSD_GNRET016-ALIQ_FCP .
ZTSD_GNRET016-BC_REDUZIDA_FCP =
ZVSD_GNRET016-BC_REDUZIDA_FCP .
ZTSD_GNRET016-PAUTA_ST =
ZVSD_GNRET016-PAUTA_ST .
ZTSD_GNRET016-PRECO_FIXO =
ZVSD_GNRET016-PRECO_FIXO .
ZTSD_GNRET016-ALIQ_FIXA =
ZVSD_GNRET016-ALIQ_FIXA .
ZTSD_GNRET016-NUM_UNIDADE =
ZVSD_GNRET016-NUM_UNIDADE .
ZTSD_GNRET016-MEINS =
ZVSD_GNRET016-MEINS .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GNRET016 ##WARN_OK.
    ELSE.
    INSERT ZTSD_GNRET016 .
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
CLEAR: STATUS_ZVSD_GNRET016-UPD_FLAG,
STATUS_ZVSD_GNRET016-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GNRET016.
  SELECT SINGLE * FROM ZTSD_GNRET016 WHERE
SHIPFROM = ZVSD_GNRET016-SHIPFROM AND
SHIPTO = ZVSD_GNRET016-SHIPTO AND
WERKS = ZVSD_GNRET016-WERKS AND
MATNR = ZVSD_GNRET016-MATNR .
ZVSD_GNRET016-MANDT =
ZTSD_GNRET016-MANDT .
ZVSD_GNRET016-SHIPFROM =
ZTSD_GNRET016-SHIPFROM .
ZVSD_GNRET016-SHIPTO =
ZTSD_GNRET016-SHIPTO .
ZVSD_GNRET016-WERKS =
ZTSD_GNRET016-WERKS .
ZVSD_GNRET016-MATNR =
ZTSD_GNRET016-MATNR .
ZVSD_GNRET016-MVA =
ZTSD_GNRET016-MVA .
ZVSD_GNRET016-ICMS_ORIG =
ZTSD_GNRET016-ICMS_ORIG .
ZVSD_GNRET016-ICMS_DEST =
ZTSD_GNRET016-ICMS_DEST .
ZVSD_GNRET016-BC_REDUZIDA_ORIG =
ZTSD_GNRET016-BC_REDUZIDA_ORIG .
ZVSD_GNRET016-BC_REDUZIDA_DEST =
ZTSD_GNRET016-BC_REDUZIDA_DEST .
ZVSD_GNRET016-ALIQ_FCP =
ZTSD_GNRET016-ALIQ_FCP .
ZVSD_GNRET016-BC_REDUZIDA_FCP =
ZTSD_GNRET016-BC_REDUZIDA_FCP .
ZVSD_GNRET016-PAUTA_ST =
ZTSD_GNRET016-PAUTA_ST .
ZVSD_GNRET016-PRECO_FIXO =
ZTSD_GNRET016-PRECO_FIXO .
ZVSD_GNRET016-ALIQ_FIXA =
ZTSD_GNRET016-ALIQ_FIXA .
ZVSD_GNRET016-NUM_UNIDADE =
ZTSD_GNRET016-NUM_UNIDADE .
ZVSD_GNRET016-MEINS =
ZTSD_GNRET016-MEINS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GNRET016 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GNRET016-SHIPFROM TO
ZTSD_GNRET016-SHIPFROM .
MOVE ZVSD_GNRET016-SHIPTO TO
ZTSD_GNRET016-SHIPTO .
MOVE ZVSD_GNRET016-WERKS TO
ZTSD_GNRET016-WERKS .
MOVE ZVSD_GNRET016-MATNR TO
ZTSD_GNRET016-MATNR .
MOVE ZVSD_GNRET016-MANDT TO
ZTSD_GNRET016-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GNRET016'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GNRET016 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GNRET016'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
