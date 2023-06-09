*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET018...................................*
FORM GET_DATA_ZVSD_GNRET018.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GNRET018 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GNRET018 .
ZVSD_GNRET018-MANDT =
ZTSD_GNRET018-MANDT .
ZVSD_GNRET018-TXJCD =
ZTSD_GNRET018-TXJCD .
ZVSD_GNRET018-CMUN_ES =
ZTSD_GNRET018-CMUN_ES .
    SELECT SINGLE * FROM J_1BTXJUR WHERE
COUNTRY = 'BR' AND
TAXJURCODE = ZTSD_GNRET018-TXJCD .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM J_1BTXJURT WHERE
COUNTRY = J_1BTXJUR-COUNTRY AND
TAXJURCODE = J_1BTXJUR-TAXJURCODE AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVSD_GNRET018-TEXT =
J_1BTXJURT-TEXT .
      ENDIF.
    ENDIF.
<VIM_TOTAL_STRUC> = ZVSD_GNRET018.
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
FORM DB_UPD_ZVSD_GNRET018 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GNRET018.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GNRET018-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET018 WHERE
  TXJCD = ZVSD_GNRET018-TXJCD .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GNRET018 .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET018 WHERE
  TXJCD = ZVSD_GNRET018-TXJCD .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GNRET018.
    ENDIF.
ZTSD_GNRET018-MANDT =
ZVSD_GNRET018-MANDT .
ZTSD_GNRET018-TXJCD =
ZVSD_GNRET018-TXJCD .
ZTSD_GNRET018-CMUN_ES =
ZVSD_GNRET018-CMUN_ES .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GNRET018 ##WARN_OK.
    ELSE.
    INSERT ZTSD_GNRET018 .
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
CLEAR: STATUS_ZVSD_GNRET018-UPD_FLAG,
STATUS_ZVSD_GNRET018-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GNRET018.
  SELECT SINGLE * FROM ZTSD_GNRET018 WHERE
TXJCD = ZVSD_GNRET018-TXJCD .
ZVSD_GNRET018-MANDT =
ZTSD_GNRET018-MANDT .
ZVSD_GNRET018-TXJCD =
ZTSD_GNRET018-TXJCD .
ZVSD_GNRET018-CMUN_ES =
ZTSD_GNRET018-CMUN_ES .
    SELECT SINGLE * FROM J_1BTXJUR WHERE
COUNTRY = 'BR' AND
TAXJURCODE = ZTSD_GNRET018-TXJCD .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM J_1BTXJURT WHERE
COUNTRY = J_1BTXJUR-COUNTRY AND
TAXJURCODE = J_1BTXJUR-TAXJURCODE AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVSD_GNRET018-TEXT =
J_1BTXJURT-TEXT .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVSD_GNRET018-TEXT .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSD_GNRET018-TEXT .
    ENDIF.
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GNRET018 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GNRET018-TXJCD TO
ZTSD_GNRET018-TXJCD .
MOVE ZVSD_GNRET018-MANDT TO
ZTSD_GNRET018-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GNRET018'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GNRET018 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GNRET018'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
FORM COMPL_ZVSD_GNRET018 USING WORKAREA.
*      provides (read-only) fields from secondary tables related
*      to primary tables by foreignkey relationships
ZTSD_GNRET018-MANDT =
ZVSD_GNRET018-MANDT .
ZTSD_GNRET018-TXJCD =
ZVSD_GNRET018-TXJCD .
ZTSD_GNRET018-CMUN_ES =
ZVSD_GNRET018-CMUN_ES .
    SELECT SINGLE * FROM J_1BTXJUR WHERE
COUNTRY = 'BR' AND
TAXJURCODE = ZTSD_GNRET018-TXJCD .
    IF SY-SUBRC EQ 0.
      SELECT SINGLE * FROM J_1BTXJURT WHERE
COUNTRY = J_1BTXJUR-COUNTRY AND
TAXJURCODE = J_1BTXJUR-TAXJURCODE AND
SPRAS = SY-LANGU .
      IF SY-SUBRC EQ 0.
ZVSD_GNRET018-TEXT =
J_1BTXJURT-TEXT .
      ELSE.
        CLEAR SY-SUBRC.
        CLEAR ZVSD_GNRET018-TEXT .
      ENDIF.
    ELSE.
      CLEAR SY-SUBRC.
      CLEAR ZVSD_GNRET018-TEXT .
    ENDIF.
ENDFORM.
