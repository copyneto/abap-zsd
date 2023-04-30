*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRET006...................................*
FORM GET_DATA_ZVSD_GNRET006.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GNRET006 WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GNRET006 .
ZVSD_GNRET006-MANDT =
ZTSD_GNRET006-MANDT .
ZVSD_GNRET006-TPGUIA =
ZTSD_GNRET006-TPGUIA .
ZVSD_GNRET006-TAXTYP =
ZTSD_GNRET006-TAXTYP .
ZVSD_GNRET006-RECEITA =
ZTSD_GNRET006-RECEITA .
ZVSD_GNRET006-DETALHA_RECEITA =
ZTSD_GNRET006-DETALHA_RECEITA .
ZVSD_GNRET006-PRODUTO =
ZTSD_GNRET006-PRODUTO .
ZVSD_GNRET006-TPDOC_ORIGEM =
ZTSD_GNRET006-TPDOC_ORIGEM .
ZVSD_GNRET006-CONVENIO =
ZTSD_GNRET006-CONVENIO .
ZVSD_GNRET006-COD_ACCESSKEY =
ZTSD_GNRET006-COD_ACCESSKEY .
ZVSD_GNRET006-PERIODO =
ZTSD_GNRET006-PERIODO .
ZVSD_GNRET006-ENVIAR_DESTINATARIO =
ZTSD_GNRET006-ENVIAR_DESTINATARIO .
ZVSD_GNRET006-ENVIAR_VENCIMENTO =
ZTSD_GNRET006-ENVIAR_VENCIMENTO .
ZVSD_GNRET006-ENVIAR_PARCELA =
ZTSD_GNRET006-ENVIAR_PARCELA .
<VIM_TOTAL_STRUC> = ZVSD_GNRET006.
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
FORM DB_UPD_ZVSD_GNRET006 .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GNRET006.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GNRET006-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET006 WHERE
  TPGUIA = ZVSD_GNRET006-TPGUIA AND
  TAXTYP = ZVSD_GNRET006-TAXTYP .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GNRET006 .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRET006 WHERE
  TPGUIA = ZVSD_GNRET006-TPGUIA AND
  TAXTYP = ZVSD_GNRET006-TAXTYP .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GNRET006.
    ENDIF.
ZTSD_GNRET006-MANDT =
ZVSD_GNRET006-MANDT .
ZTSD_GNRET006-TPGUIA =
ZVSD_GNRET006-TPGUIA .
ZTSD_GNRET006-TAXTYP =
ZVSD_GNRET006-TAXTYP .
ZTSD_GNRET006-RECEITA =
ZVSD_GNRET006-RECEITA .
ZTSD_GNRET006-DETALHA_RECEITA =
ZVSD_GNRET006-DETALHA_RECEITA .
ZTSD_GNRET006-PRODUTO =
ZVSD_GNRET006-PRODUTO .
ZTSD_GNRET006-TPDOC_ORIGEM =
ZVSD_GNRET006-TPDOC_ORIGEM .
ZTSD_GNRET006-CONVENIO =
ZVSD_GNRET006-CONVENIO .
ZTSD_GNRET006-COD_ACCESSKEY =
ZVSD_GNRET006-COD_ACCESSKEY .
ZTSD_GNRET006-PERIODO =
ZVSD_GNRET006-PERIODO .
ZTSD_GNRET006-ENVIAR_DESTINATARIO =
ZVSD_GNRET006-ENVIAR_DESTINATARIO .
ZTSD_GNRET006-ENVIAR_VENCIMENTO =
ZVSD_GNRET006-ENVIAR_VENCIMENTO .
ZTSD_GNRET006-ENVIAR_PARCELA =
ZVSD_GNRET006-ENVIAR_PARCELA .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GNRET006 ##WARN_OK.
    ELSE.
    INSERT ZTSD_GNRET006 .
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
CLEAR: STATUS_ZVSD_GNRET006-UPD_FLAG,
STATUS_ZVSD_GNRET006-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GNRET006.
  SELECT SINGLE * FROM ZTSD_GNRET006 WHERE
TPGUIA = ZVSD_GNRET006-TPGUIA AND
TAXTYP = ZVSD_GNRET006-TAXTYP .
ZVSD_GNRET006-MANDT =
ZTSD_GNRET006-MANDT .
ZVSD_GNRET006-TPGUIA =
ZTSD_GNRET006-TPGUIA .
ZVSD_GNRET006-TAXTYP =
ZTSD_GNRET006-TAXTYP .
ZVSD_GNRET006-RECEITA =
ZTSD_GNRET006-RECEITA .
ZVSD_GNRET006-DETALHA_RECEITA =
ZTSD_GNRET006-DETALHA_RECEITA .
ZVSD_GNRET006-PRODUTO =
ZTSD_GNRET006-PRODUTO .
ZVSD_GNRET006-TPDOC_ORIGEM =
ZTSD_GNRET006-TPDOC_ORIGEM .
ZVSD_GNRET006-CONVENIO =
ZTSD_GNRET006-CONVENIO .
ZVSD_GNRET006-COD_ACCESSKEY =
ZTSD_GNRET006-COD_ACCESSKEY .
ZVSD_GNRET006-PERIODO =
ZTSD_GNRET006-PERIODO .
ZVSD_GNRET006-ENVIAR_DESTINATARIO =
ZTSD_GNRET006-ENVIAR_DESTINATARIO .
ZVSD_GNRET006-ENVIAR_VENCIMENTO =
ZTSD_GNRET006-ENVIAR_VENCIMENTO .
ZVSD_GNRET006-ENVIAR_PARCELA =
ZTSD_GNRET006-ENVIAR_PARCELA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GNRET006 USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GNRET006-TPGUIA TO
ZTSD_GNRET006-TPGUIA .
MOVE ZVSD_GNRET006-TAXTYP TO
ZTSD_GNRET006-TAXTYP .
MOVE ZVSD_GNRET006-MANDT TO
ZTSD_GNRET006-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GNRET006'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GNRET006 TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GNRET006'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*