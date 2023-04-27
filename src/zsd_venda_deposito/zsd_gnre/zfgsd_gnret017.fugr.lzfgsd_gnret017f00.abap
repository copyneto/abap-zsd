*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET017...................................*
FORM GET_DATA_ZVSD_GNRET017.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GNRET017 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GNRET017 .
ZVSD_GNRET017-MANDT =
ZTSD_GNRET017-MANDT .
ZVSD_GNRET017-SHIPFROM =
ZTSD_GNRET017-SHIPFROM .
ZVSD_GNRET017-SHIPTO =
ZTSD_GNRET017-SHIPTO .
ZVSD_GNRET017-WERKS =
ZTSD_GNRET017-WERKS .
ZVSD_GNRET017-MATKL =
ZTSD_GNRET017-MATKL .
ZVSD_GNRET017-MVA =
ZTSD_GNRET017-MVA .
ZVSD_GNRET017-ICMS_ORIG =
ZTSD_GNRET017-ICMS_ORIG .
ZVSD_GNRET017-ICMS_DEST =
ZTSD_GNRET017-ICMS_DEST .
ZVSD_GNRET017-BC_REDUZIDA_ORIG =
ZTSD_GNRET017-BC_REDUZIDA_ORIG .
ZVSD_GNRET017-BC_REDUZIDA_DEST =
ZTSD_GNRET017-BC_REDUZIDA_DEST .
ZVSD_GNRET017-ALIQ_FCP =
ZTSD_GNRET017-ALIQ_FCP .
ZVSD_GNRET017-BC_REDUZIDA_FCP =
ZTSD_GNRET017-BC_REDUZIDA_FCP .
ZVSD_GNRET017-PAUTA_ST =
ZTSD_GNRET017-PAUTA_ST .
ZVSD_GNRET017-PRECO_FIXO =
ZTSD_GNRET017-PRECO_FIXO .
ZVSD_GNRET017-ALIQ_FIXA =
ZTSD_GNRET017-ALIQ_FIXA .
ZVSD_GNRET017-NUM_UNIDADE =
ZTSD_GNRET017-NUM_UNIDADE .
ZVSD_GNRET017-MEINS =
ZTSD_GNRET017-MEINS .
<VIM_TOTAL_STRUC> = ZVSD_GNRET017.
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
FORM DB_UPD_ZVSD_GNRET017 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GNRET017.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GNRET017-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET017 WHERE
  SHIPFROM = ZVSD_GNRET017-SHIPFROM AND
  SHIPTO = ZVSD_GNRET017-SHIPTO AND
  WERKS = ZVSD_GNRET017-WERKS AND
  MATKL = ZVSD_GNRET017-MATKL .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GNRET017 .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET017 WHERE
  SHIPFROM = ZVSD_GNRET017-SHIPFROM AND
  SHIPTO = ZVSD_GNRET017-SHIPTO AND
  WERKS = ZVSD_GNRET017-WERKS AND
  MATKL = ZVSD_GNRET017-MATKL .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GNRET017.
    ENDIF.
ZTSD_GNRET017-MANDT =
ZVSD_GNRET017-MANDT .
ZTSD_GNRET017-SHIPFROM =
ZVSD_GNRET017-SHIPFROM .
ZTSD_GNRET017-SHIPTO =
ZVSD_GNRET017-SHIPTO .
ZTSD_GNRET017-WERKS =
ZVSD_GNRET017-WERKS .
ZTSD_GNRET017-MATKL =
ZVSD_GNRET017-MATKL .
ZTSD_GNRET017-MVA =
ZVSD_GNRET017-MVA .
ZTSD_GNRET017-ICMS_ORIG =
ZVSD_GNRET017-ICMS_ORIG .
ZTSD_GNRET017-ICMS_DEST =
ZVSD_GNRET017-ICMS_DEST .
ZTSD_GNRET017-BC_REDUZIDA_ORIG =
ZVSD_GNRET017-BC_REDUZIDA_ORIG .
ZTSD_GNRET017-BC_REDUZIDA_DEST =
ZVSD_GNRET017-BC_REDUZIDA_DEST .
ZTSD_GNRET017-ALIQ_FCP =
ZVSD_GNRET017-ALIQ_FCP .
ZTSD_GNRET017-BC_REDUZIDA_FCP =
ZVSD_GNRET017-BC_REDUZIDA_FCP .
ZTSD_GNRET017-PAUTA_ST =
ZVSD_GNRET017-PAUTA_ST .
ZTSD_GNRET017-PRECO_FIXO =
ZVSD_GNRET017-PRECO_FIXO .
ZTSD_GNRET017-ALIQ_FIXA =
ZVSD_GNRET017-ALIQ_FIXA .
ZTSD_GNRET017-NUM_UNIDADE =
ZVSD_GNRET017-NUM_UNIDADE .
ZTSD_GNRET017-MEINS =
ZVSD_GNRET017-MEINS .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GNRET017 ##WARN_OK.
    ELSE.
    INSERT ZTSD_GNRET017 .
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
CLEAR: STATUS_ZVSD_GNRET017-UPD_FLAG,
STATUS_ZVSD_GNRET017-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GNRET017.
  SELECT SINGLE * FROM ZTSD_GNRET017 WHERE
SHIPFROM = ZVSD_GNRET017-SHIPFROM AND
SHIPTO = ZVSD_GNRET017-SHIPTO AND
WERKS = ZVSD_GNRET017-WERKS AND
MATKL = ZVSD_GNRET017-MATKL .
ZVSD_GNRET017-MANDT =
ZTSD_GNRET017-MANDT .
ZVSD_GNRET017-SHIPFROM =
ZTSD_GNRET017-SHIPFROM .
ZVSD_GNRET017-SHIPTO =
ZTSD_GNRET017-SHIPTO .
ZVSD_GNRET017-WERKS =
ZTSD_GNRET017-WERKS .
ZVSD_GNRET017-MATKL =
ZTSD_GNRET017-MATKL .
ZVSD_GNRET017-MVA =
ZTSD_GNRET017-MVA .
ZVSD_GNRET017-ICMS_ORIG =
ZTSD_GNRET017-ICMS_ORIG .
ZVSD_GNRET017-ICMS_DEST =
ZTSD_GNRET017-ICMS_DEST .
ZVSD_GNRET017-BC_REDUZIDA_ORIG =
ZTSD_GNRET017-BC_REDUZIDA_ORIG .
ZVSD_GNRET017-BC_REDUZIDA_DEST =
ZTSD_GNRET017-BC_REDUZIDA_DEST .
ZVSD_GNRET017-ALIQ_FCP =
ZTSD_GNRET017-ALIQ_FCP .
ZVSD_GNRET017-BC_REDUZIDA_FCP =
ZTSD_GNRET017-BC_REDUZIDA_FCP .
ZVSD_GNRET017-PAUTA_ST =
ZTSD_GNRET017-PAUTA_ST .
ZVSD_GNRET017-PRECO_FIXO =
ZTSD_GNRET017-PRECO_FIXO .
ZVSD_GNRET017-ALIQ_FIXA =
ZTSD_GNRET017-ALIQ_FIXA .
ZVSD_GNRET017-NUM_UNIDADE =
ZTSD_GNRET017-NUM_UNIDADE .
ZVSD_GNRET017-MEINS =
ZTSD_GNRET017-MEINS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GNRET017 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GNRET017-SHIPFROM TO
ZTSD_GNRET017-SHIPFROM .
MOVE ZVSD_GNRET017-SHIPTO TO
ZTSD_GNRET017-SHIPTO .
MOVE ZVSD_GNRET017-WERKS TO
ZTSD_GNRET017-WERKS .
MOVE ZVSD_GNRET017-MATKL TO
ZTSD_GNRET017-MATKL .
MOVE ZVSD_GNRET017-MANDT TO
ZTSD_GNRET017-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GNRET017'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GNRET017 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GNRET017'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
