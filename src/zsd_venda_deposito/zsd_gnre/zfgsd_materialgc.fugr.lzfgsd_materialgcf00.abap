*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_MATERIAL_GC................................*
FORM GET_DATA_ZVSD_MATERIAL_GC.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_MATERIAL_GC WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_MATERIAL_GC .
ZVSD_MATERIAL_GC-CLIENT =
ZTSD_MATERIAL_GC-CLIENT .
ZVSD_MATERIAL_GC-MATNR =
ZTSD_MATERIAL_GC-MATNR .
<VIM_TOTAL_STRUC> = ZVSD_MATERIAL_GC.
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
FORM DB_UPD_ZVSD_MATERIAL_GC .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_MATERIAL_GC.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_MATERIAL_GC-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_MATERIAL_GC WHERE
  MATNR = ZVSD_MATERIAL_GC-MATNR .
    IF SY-SUBRC = 0.
    DELETE ZTSD_MATERIAL_GC .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_MATERIAL_GC WHERE
  MATNR = ZVSD_MATERIAL_GC-MATNR .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_MATERIAL_GC.
    ENDIF.
ZTSD_MATERIAL_GC-CLIENT =
ZVSD_MATERIAL_GC-CLIENT .
ZTSD_MATERIAL_GC-MATNR =
ZVSD_MATERIAL_GC-MATNR .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_MATERIAL_GC ##WARN_OK.
    ELSE.
    INSERT ZTSD_MATERIAL_GC .
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
CLEAR: STATUS_ZVSD_MATERIAL_GC-UPD_FLAG,
STATUS_ZVSD_MATERIAL_GC-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_MATERIAL_GC.
  SELECT SINGLE * FROM ZTSD_MATERIAL_GC WHERE
MATNR = ZVSD_MATERIAL_GC-MATNR .
ZVSD_MATERIAL_GC-CLIENT =
ZTSD_MATERIAL_GC-CLIENT .
ZVSD_MATERIAL_GC-MATNR =
ZTSD_MATERIAL_GC-MATNR .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_MATERIAL_GC USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_MATERIAL_GC-MATNR TO
ZTSD_MATERIAL_GC-MATNR .
MOVE ZVSD_MATERIAL_GC-CLIENT TO
ZTSD_MATERIAL_GC-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_MATERIAL_GC'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_MATERIAL_GC TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_MATERIAL_GC'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
