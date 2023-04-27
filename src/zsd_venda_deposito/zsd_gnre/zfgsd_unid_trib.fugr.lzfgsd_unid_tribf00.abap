*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_UNID_TRIB..................................*
FORM GET_DATA_ZVSD_UNID_TRIB.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_UNID_TRIB WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_UNID_TRIB .
ZVSD_UNID_TRIB-CLIENT =
ZTSD_UNID_TRIB-CLIENT .
ZVSD_UNID_TRIB-STEUC =
ZTSD_UNID_TRIB-STEUC .
ZVSD_UNID_TRIB-VALID_FROM =
ZTSD_UNID_TRIB-VALID_FROM .
ZVSD_UNID_TRIB-VALID_TO =
ZTSD_UNID_TRIB-VALID_TO .
ZVSD_UNID_TRIB-MSEHI =
ZTSD_UNID_TRIB-MSEHI .
ZVSD_UNID_TRIB-UN_XML =
ZTSD_UNID_TRIB-UN_XML .
<VIM_TOTAL_STRUC> = ZVSD_UNID_TRIB.
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
FORM DB_UPD_ZVSD_UNID_TRIB .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_UNID_TRIB.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_UNID_TRIB-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_UNID_TRIB WHERE
  STEUC = ZVSD_UNID_TRIB-STEUC AND
  VALID_FROM = ZVSD_UNID_TRIB-VALID_FROM .
    IF SY-SUBRC = 0.
    DELETE ZTSD_UNID_TRIB .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_UNID_TRIB WHERE
  STEUC = ZVSD_UNID_TRIB-STEUC AND
  VALID_FROM = ZVSD_UNID_TRIB-VALID_FROM .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_UNID_TRIB.
    ENDIF.
ZTSD_UNID_TRIB-CLIENT =
ZVSD_UNID_TRIB-CLIENT .
ZTSD_UNID_TRIB-STEUC =
ZVSD_UNID_TRIB-STEUC .
ZTSD_UNID_TRIB-VALID_FROM =
ZVSD_UNID_TRIB-VALID_FROM .
ZTSD_UNID_TRIB-VALID_TO =
ZVSD_UNID_TRIB-VALID_TO .
ZTSD_UNID_TRIB-MSEHI =
ZVSD_UNID_TRIB-MSEHI .
ZTSD_UNID_TRIB-UN_XML =
ZVSD_UNID_TRIB-UN_XML .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_UNID_TRIB ##WARN_OK.
    ELSE.
    INSERT ZTSD_UNID_TRIB .
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
CLEAR: STATUS_ZVSD_UNID_TRIB-UPD_FLAG,
STATUS_ZVSD_UNID_TRIB-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_UNID_TRIB.
  SELECT SINGLE * FROM ZTSD_UNID_TRIB WHERE
STEUC = ZVSD_UNID_TRIB-STEUC AND
VALID_FROM = ZVSD_UNID_TRIB-VALID_FROM .
ZVSD_UNID_TRIB-CLIENT =
ZTSD_UNID_TRIB-CLIENT .
ZVSD_UNID_TRIB-STEUC =
ZTSD_UNID_TRIB-STEUC .
ZVSD_UNID_TRIB-VALID_FROM =
ZTSD_UNID_TRIB-VALID_FROM .
ZVSD_UNID_TRIB-VALID_TO =
ZTSD_UNID_TRIB-VALID_TO .
ZVSD_UNID_TRIB-MSEHI =
ZTSD_UNID_TRIB-MSEHI .
ZVSD_UNID_TRIB-UN_XML =
ZTSD_UNID_TRIB-UN_XML .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_UNID_TRIB USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_UNID_TRIB-STEUC TO
ZTSD_UNID_TRIB-STEUC .
MOVE ZVSD_UNID_TRIB-VALID_FROM TO
ZTSD_UNID_TRIB-VALID_FROM .
MOVE ZVSD_UNID_TRIB-CLIENT TO
ZTSD_UNID_TRIB-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_UNID_TRIB'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_UNID_TRIB TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_UNID_TRIB'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
