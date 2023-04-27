*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GNRE_CONFIG................................*
FORM GET_DATA_ZVSD_GNRE_CONFIG.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GNRE_CONFIG WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GNRE_CONFIG .
ZVSD_GNRE_CONFIG-MANDT =
ZTSD_GNRE_CONFIG-MANDT .
ZVSD_GNRE_CONFIG-REGIO =
ZTSD_GNRE_CONFIG-REGIO .
ZVSD_GNRE_CONFIG-TAXTYP =
ZTSD_GNRE_CONFIG-TAXTYP .
ZVSD_GNRE_CONFIG-RECEITA =
ZTSD_GNRE_CONFIG-RECEITA .
ZVSD_GNRE_CONFIG-DETALHA_RECEITA =
ZTSD_GNRE_CONFIG-DETALHA_RECEITA .
ZVSD_GNRE_CONFIG-PRODUTO =
ZTSD_GNRE_CONFIG-PRODUTO .
ZVSD_GNRE_CONFIG-TIPO_DOC_ORIGEM =
ZTSD_GNRE_CONFIG-TIPO_DOC_ORIGEM .
ZVSD_GNRE_CONFIG-CONVENIO =
ZTSD_GNRE_CONFIG-CONVENIO .
ZVSD_GNRE_CONFIG-CODIGO_CHAVEACESSO =
ZTSD_GNRE_CONFIG-CODIGO_CHAVEACESSO .
ZVSD_GNRE_CONFIG-PERIODO =
ZTSD_GNRE_CONFIG-PERIODO .
ZVSD_GNRE_CONFIG-ENVIAR_DESTINATARIO =
ZTSD_GNRE_CONFIG-ENVIAR_DESTINATARIO .
ZVSD_GNRE_CONFIG-ENVIAR_VENCIMENTO =
ZTSD_GNRE_CONFIG-ENVIAR_VENCIMENTO .
ZVSD_GNRE_CONFIG-ENVIAR_PARCELA =
ZTSD_GNRE_CONFIG-ENVIAR_PARCELA .
<VIM_TOTAL_STRUC> = ZVSD_GNRE_CONFIG.
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
FORM DB_UPD_ZVSD_GNRE_CONFIG .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GNRE_CONFIG.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GNRE_CONFIG-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRE_CONFIG WHERE
  REGIO = ZVSD_GNRE_CONFIG-REGIO AND
  TAXTYP = ZVSD_GNRE_CONFIG-TAXTYP .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GNRE_CONFIG .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GNRE_CONFIG WHERE
  REGIO = ZVSD_GNRE_CONFIG-REGIO AND
  TAXTYP = ZVSD_GNRE_CONFIG-TAXTYP .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GNRE_CONFIG.
    ENDIF.
ZTSD_GNRE_CONFIG-MANDT =
ZVSD_GNRE_CONFIG-MANDT .
ZTSD_GNRE_CONFIG-REGIO =
ZVSD_GNRE_CONFIG-REGIO .
ZTSD_GNRE_CONFIG-TAXTYP =
ZVSD_GNRE_CONFIG-TAXTYP .
ZTSD_GNRE_CONFIG-RECEITA =
ZVSD_GNRE_CONFIG-RECEITA .
ZTSD_GNRE_CONFIG-DETALHA_RECEITA =
ZVSD_GNRE_CONFIG-DETALHA_RECEITA .
ZTSD_GNRE_CONFIG-PRODUTO =
ZVSD_GNRE_CONFIG-PRODUTO .
ZTSD_GNRE_CONFIG-TIPO_DOC_ORIGEM =
ZVSD_GNRE_CONFIG-TIPO_DOC_ORIGEM .
ZTSD_GNRE_CONFIG-CONVENIO =
ZVSD_GNRE_CONFIG-CONVENIO .
ZTSD_GNRE_CONFIG-CODIGO_CHAVEACESSO =
ZVSD_GNRE_CONFIG-CODIGO_CHAVEACESSO .
ZTSD_GNRE_CONFIG-PERIODO =
ZVSD_GNRE_CONFIG-PERIODO .
ZTSD_GNRE_CONFIG-ENVIAR_DESTINATARIO =
ZVSD_GNRE_CONFIG-ENVIAR_DESTINATARIO .
ZTSD_GNRE_CONFIG-ENVIAR_VENCIMENTO =
ZVSD_GNRE_CONFIG-ENVIAR_VENCIMENTO .
ZTSD_GNRE_CONFIG-ENVIAR_PARCELA =
ZVSD_GNRE_CONFIG-ENVIAR_PARCELA .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GNRE_CONFIG ##WARN_OK.
    ELSE.
    INSERT ZTSD_GNRE_CONFIG .
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
CLEAR: STATUS_ZVSD_GNRE_CONFIG-UPD_FLAG,
STATUS_ZVSD_GNRE_CONFIG-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GNRE_CONFIG.
  SELECT SINGLE * FROM ZTSD_GNRE_CONFIG WHERE
REGIO = ZVSD_GNRE_CONFIG-REGIO AND
TAXTYP = ZVSD_GNRE_CONFIG-TAXTYP .
ZVSD_GNRE_CONFIG-MANDT =
ZTSD_GNRE_CONFIG-MANDT .
ZVSD_GNRE_CONFIG-REGIO =
ZTSD_GNRE_CONFIG-REGIO .
ZVSD_GNRE_CONFIG-TAXTYP =
ZTSD_GNRE_CONFIG-TAXTYP .
ZVSD_GNRE_CONFIG-RECEITA =
ZTSD_GNRE_CONFIG-RECEITA .
ZVSD_GNRE_CONFIG-DETALHA_RECEITA =
ZTSD_GNRE_CONFIG-DETALHA_RECEITA .
ZVSD_GNRE_CONFIG-PRODUTO =
ZTSD_GNRE_CONFIG-PRODUTO .
ZVSD_GNRE_CONFIG-TIPO_DOC_ORIGEM =
ZTSD_GNRE_CONFIG-TIPO_DOC_ORIGEM .
ZVSD_GNRE_CONFIG-CONVENIO =
ZTSD_GNRE_CONFIG-CONVENIO .
ZVSD_GNRE_CONFIG-CODIGO_CHAVEACESSO =
ZTSD_GNRE_CONFIG-CODIGO_CHAVEACESSO .
ZVSD_GNRE_CONFIG-PERIODO =
ZTSD_GNRE_CONFIG-PERIODO .
ZVSD_GNRE_CONFIG-ENVIAR_DESTINATARIO =
ZTSD_GNRE_CONFIG-ENVIAR_DESTINATARIO .
ZVSD_GNRE_CONFIG-ENVIAR_VENCIMENTO =
ZTSD_GNRE_CONFIG-ENVIAR_VENCIMENTO .
ZVSD_GNRE_CONFIG-ENVIAR_PARCELA =
ZTSD_GNRE_CONFIG-ENVIAR_PARCELA .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GNRE_CONFIG USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GNRE_CONFIG-REGIO TO
ZTSD_GNRE_CONFIG-REGIO .
MOVE ZVSD_GNRE_CONFIG-TAXTYP TO
ZTSD_GNRE_CONFIG-TAXTYP .
MOVE ZVSD_GNRE_CONFIG-MANDT TO
ZTSD_GNRE_CONFIG-MANDT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GNRE_CONFIG'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GNRE_CONFIG TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GNRE_CONFIG'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
