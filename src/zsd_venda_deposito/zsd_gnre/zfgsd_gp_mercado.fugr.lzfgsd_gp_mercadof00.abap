*---------------------------------------------------------------------*
*    view related FORM routines
*---------------------------------------------------------------------*
*...processing: ZVSD_GP_MERCADOR................................*
FORM GET_DATA_ZVSD_GP_MERCADOR.
  PERFORM VIM_FILL_WHERETAB.
*.read data from database.............................................*
  REFRESH TOTAL.
  CLEAR   TOTAL.
  SELECT * FROM ZTSD_GP_MERCADOR WHERE
(VIM_WHERETAB) .
    CLEAR ZVSD_GP_MERCADOR .
ZVSD_GP_MERCADOR-CLIENT =
ZTSD_GP_MERCADOR-CLIENT .
ZVSD_GP_MERCADOR-CENTRO =
ZTSD_GP_MERCADOR-CENTRO .
ZVSD_GP_MERCADOR-UF =
ZTSD_GP_MERCADOR-UF .
ZVSD_GP_MERCADOR-GRPMERCADORIA =
ZTSD_GP_MERCADOR-GRPMERCADORIA .
ZVSD_GP_MERCADOR-DESCRICAO =
ZTSD_GP_MERCADOR-DESCRICAO .
ZVSD_GP_MERCADOR-AGREGADO =
ZTSD_GP_MERCADOR-AGREGADO .
ZVSD_GP_MERCADOR-ICMS_DEST =
ZTSD_GP_MERCADOR-ICMS_DEST .
ZVSD_GP_MERCADOR-ICMS_ORIG =
ZTSD_GP_MERCADOR-ICMS_ORIG .
ZVSD_GP_MERCADOR-COMPRA_INTERNA =
ZTSD_GP_MERCADOR-COMPRA_INTERNA .
ZVSD_GP_MERCADOR-BASE_RED_ORIG =
ZTSD_GP_MERCADOR-BASE_RED_ORIG .
ZVSD_GP_MERCADOR-BASE_RED_DEST =
ZTSD_GP_MERCADOR-BASE_RED_DEST .
ZVSD_GP_MERCADOR-TAXA_FCP =
ZTSD_GP_MERCADOR-TAXA_FCP .
ZVSD_GP_MERCADOR-ICMS_EFET =
ZTSD_GP_MERCADOR-ICMS_EFET .
ZVSD_GP_MERCADOR-BASEREDEFET =
ZTSD_GP_MERCADOR-BASEREDEFET .
ZVSD_GP_MERCADOR-PRECO_COMPAR =
ZTSD_GP_MERCADOR-PRECO_COMPAR .
ZVSD_GP_MERCADOR-PRECO_PAUTA =
ZTSD_GP_MERCADOR-PRECO_PAUTA .
ZVSD_GP_MERCADOR-AGREGADO_PAUTA =
ZTSD_GP_MERCADOR-AGREGADO_PAUTA .
ZVSD_GP_MERCADOR-NRO_UNIDS =
ZTSD_GP_MERCADOR-NRO_UNIDS .
ZVSD_GP_MERCADOR-UM =
ZTSD_GP_MERCADOR-UM .
ZVSD_GP_MERCADOR-MODALIDADE =
ZTSD_GP_MERCADOR-MODALIDADE .
ZVSD_GP_MERCADOR-CALC_EFETIVO =
ZTSD_GP_MERCADOR-CALC_EFETIVO .
ZVSD_GP_MERCADOR-PERC_BC_ICMS =
ZTSD_GP_MERCADOR-PERC_BC_ICMS .
<VIM_TOTAL_STRUC> = ZVSD_GP_MERCADOR.
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
FORM DB_UPD_ZVSD_GP_MERCADOR .
*.process data base updates/inserts/deletes.........................*
LOOP AT TOTAL.
  CHECK <ACTION> NE ORIGINAL.
MOVE <VIM_TOTAL_STRUC> TO ZVSD_GP_MERCADOR.
  IF <ACTION> = UPDATE_GELOESCHT.
    <ACTION> = GELOESCHT.
  ENDIF.
  CASE <ACTION>.
   WHEN NEUER_GELOESCHT.
IF STATUS_ZVSD_GP_MERCADOR-ST_DELETE EQ GELOESCHT.
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GP_MERCADOR WHERE
  CENTRO = ZVSD_GP_MERCADOR-CENTRO AND
  UF = ZVSD_GP_MERCADOR-UF AND
  GRPMERCADORIA = ZVSD_GP_MERCADOR-GRPMERCADORIA .
    IF SY-SUBRC = 0.
    DELETE ZTSD_GP_MERCADOR .
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
  SELECT SINGLE FOR UPDATE * FROM ZTSD_GP_MERCADOR WHERE
  CENTRO = ZVSD_GP_MERCADOR-CENTRO AND
  UF = ZVSD_GP_MERCADOR-UF AND
  GRPMERCADORIA = ZVSD_GP_MERCADOR-GRPMERCADORIA .
    IF SY-SUBRC <> 0.   "insert preprocessing: init WA
      CLEAR ZTSD_GP_MERCADOR.
    ENDIF.
ZTSD_GP_MERCADOR-CLIENT =
ZVSD_GP_MERCADOR-CLIENT .
ZTSD_GP_MERCADOR-CENTRO =
ZVSD_GP_MERCADOR-CENTRO .
ZTSD_GP_MERCADOR-UF =
ZVSD_GP_MERCADOR-UF .
ZTSD_GP_MERCADOR-GRPMERCADORIA =
ZVSD_GP_MERCADOR-GRPMERCADORIA .
ZTSD_GP_MERCADOR-DESCRICAO =
ZVSD_GP_MERCADOR-DESCRICAO .
ZTSD_GP_MERCADOR-AGREGADO =
ZVSD_GP_MERCADOR-AGREGADO .
ZTSD_GP_MERCADOR-ICMS_DEST =
ZVSD_GP_MERCADOR-ICMS_DEST .
ZTSD_GP_MERCADOR-ICMS_ORIG =
ZVSD_GP_MERCADOR-ICMS_ORIG .
ZTSD_GP_MERCADOR-COMPRA_INTERNA =
ZVSD_GP_MERCADOR-COMPRA_INTERNA .
ZTSD_GP_MERCADOR-BASE_RED_ORIG =
ZVSD_GP_MERCADOR-BASE_RED_ORIG .
ZTSD_GP_MERCADOR-BASE_RED_DEST =
ZVSD_GP_MERCADOR-BASE_RED_DEST .
ZTSD_GP_MERCADOR-TAXA_FCP =
ZVSD_GP_MERCADOR-TAXA_FCP .
ZTSD_GP_MERCADOR-ICMS_EFET =
ZVSD_GP_MERCADOR-ICMS_EFET .
ZTSD_GP_MERCADOR-BASEREDEFET =
ZVSD_GP_MERCADOR-BASEREDEFET .
ZTSD_GP_MERCADOR-PRECO_COMPAR =
ZVSD_GP_MERCADOR-PRECO_COMPAR .
ZTSD_GP_MERCADOR-PRECO_PAUTA =
ZVSD_GP_MERCADOR-PRECO_PAUTA .
ZTSD_GP_MERCADOR-AGREGADO_PAUTA =
ZVSD_GP_MERCADOR-AGREGADO_PAUTA .
ZTSD_GP_MERCADOR-NRO_UNIDS =
ZVSD_GP_MERCADOR-NRO_UNIDS .
ZTSD_GP_MERCADOR-UM =
ZVSD_GP_MERCADOR-UM .
ZTSD_GP_MERCADOR-MODALIDADE =
ZVSD_GP_MERCADOR-MODALIDADE .
ZTSD_GP_MERCADOR-CALC_EFETIVO =
ZVSD_GP_MERCADOR-CALC_EFETIVO .
ZTSD_GP_MERCADOR-PERC_BC_ICMS =
ZVSD_GP_MERCADOR-PERC_BC_ICMS .
    IF SY-SUBRC = 0.
    UPDATE ZTSD_GP_MERCADOR ##WARN_OK.
    ELSE.
    INSERT ZTSD_GP_MERCADOR .
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
CLEAR: STATUS_ZVSD_GP_MERCADOR-UPD_FLAG,
STATUS_ZVSD_GP_MERCADOR-UPD_CHECKD.
MESSAGE S018(SV).
ENDFORM.
*---------------------------------------------------------------------*
FORM READ_SINGLE_ZVSD_GP_MERCADOR.
  SELECT SINGLE * FROM ZTSD_GP_MERCADOR WHERE
CENTRO = ZVSD_GP_MERCADOR-CENTRO AND
UF = ZVSD_GP_MERCADOR-UF AND
GRPMERCADORIA = ZVSD_GP_MERCADOR-GRPMERCADORIA .
ZVSD_GP_MERCADOR-CLIENT =
ZTSD_GP_MERCADOR-CLIENT .
ZVSD_GP_MERCADOR-CENTRO =
ZTSD_GP_MERCADOR-CENTRO .
ZVSD_GP_MERCADOR-UF =
ZTSD_GP_MERCADOR-UF .
ZVSD_GP_MERCADOR-GRPMERCADORIA =
ZTSD_GP_MERCADOR-GRPMERCADORIA .
ZVSD_GP_MERCADOR-DESCRICAO =
ZTSD_GP_MERCADOR-DESCRICAO .
ZVSD_GP_MERCADOR-AGREGADO =
ZTSD_GP_MERCADOR-AGREGADO .
ZVSD_GP_MERCADOR-ICMS_DEST =
ZTSD_GP_MERCADOR-ICMS_DEST .
ZVSD_GP_MERCADOR-ICMS_ORIG =
ZTSD_GP_MERCADOR-ICMS_ORIG .
ZVSD_GP_MERCADOR-COMPRA_INTERNA =
ZTSD_GP_MERCADOR-COMPRA_INTERNA .
ZVSD_GP_MERCADOR-BASE_RED_ORIG =
ZTSD_GP_MERCADOR-BASE_RED_ORIG .
ZVSD_GP_MERCADOR-BASE_RED_DEST =
ZTSD_GP_MERCADOR-BASE_RED_DEST .
ZVSD_GP_MERCADOR-TAXA_FCP =
ZTSD_GP_MERCADOR-TAXA_FCP .
ZVSD_GP_MERCADOR-ICMS_EFET =
ZTSD_GP_MERCADOR-ICMS_EFET .
ZVSD_GP_MERCADOR-BASEREDEFET =
ZTSD_GP_MERCADOR-BASEREDEFET .
ZVSD_GP_MERCADOR-PRECO_COMPAR =
ZTSD_GP_MERCADOR-PRECO_COMPAR .
ZVSD_GP_MERCADOR-PRECO_PAUTA =
ZTSD_GP_MERCADOR-PRECO_PAUTA .
ZVSD_GP_MERCADOR-AGREGADO_PAUTA =
ZTSD_GP_MERCADOR-AGREGADO_PAUTA .
ZVSD_GP_MERCADOR-NRO_UNIDS =
ZTSD_GP_MERCADOR-NRO_UNIDS .
ZVSD_GP_MERCADOR-UM =
ZTSD_GP_MERCADOR-UM .
ZVSD_GP_MERCADOR-MODALIDADE =
ZTSD_GP_MERCADOR-MODALIDADE .
ZVSD_GP_MERCADOR-CALC_EFETIVO =
ZTSD_GP_MERCADOR-CALC_EFETIVO .
ZVSD_GP_MERCADOR-PERC_BC_ICMS =
ZTSD_GP_MERCADOR-PERC_BC_ICMS .
ENDFORM.
*---------------------------------------------------------------------*
FORM CORR_MAINT_ZVSD_GP_MERCADOR USING VALUE(CM_ACTION) RC.
  DATA: RETCODE LIKE SY-SUBRC, COUNT TYPE I, TRSP_KEYLEN TYPE SYFLENG.
  FIELD-SYMBOLS: <TAB_KEY_X> TYPE X.
  CLEAR RC.
MOVE ZVSD_GP_MERCADOR-CENTRO TO
ZTSD_GP_MERCADOR-CENTRO .
MOVE ZVSD_GP_MERCADOR-UF TO
ZTSD_GP_MERCADOR-UF .
MOVE ZVSD_GP_MERCADOR-GRPMERCADORIA TO
ZTSD_GP_MERCADOR-GRPMERCADORIA .
MOVE ZVSD_GP_MERCADOR-CLIENT TO
ZTSD_GP_MERCADOR-CLIENT .
  CORR_KEYTAB             =  E071K.
  CORR_KEYTAB-OBJNAME     = 'ZTSD_GP_MERCADOR'.
  IF NOT <vim_corr_keyx> IS ASSIGNED.
    ASSIGN CORR_KEYTAB-TABKEY TO <vim_corr_keyx> CASTING.
  ENDIF.
  ASSIGN ZTSD_GP_MERCADOR TO <TAB_KEY_X> CASTING.
  PERFORM VIM_GET_TRSPKEYLEN
    USING 'ZTSD_GP_MERCADOR'
    CHANGING TRSP_KEYLEN.
  <VIM_CORR_KEYX>(TRSP_KEYLEN) = <TAB_KEY_X>(TRSP_KEYLEN).
  PERFORM UPDATE_CORR_KEYTAB USING CM_ACTION RETCODE.
  ADD: RETCODE TO RC, 1 TO COUNT.
  IF RC LT COUNT AND CM_ACTION NE PRUEFEN.
    CLEAR RC.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
