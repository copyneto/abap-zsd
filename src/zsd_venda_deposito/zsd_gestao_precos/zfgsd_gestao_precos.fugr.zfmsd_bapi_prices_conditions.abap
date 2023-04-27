FUNCTION zfmsd_bapi_prices_conditions.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_BAPICONDCT) TYPE  BBPT_CND_MM_CONDCT
*"     VALUE(IT_BAPICONDHD) TYPE  BBPT_CND_MM_CONDHD
*"     VALUE(IT_BAPICONDIT) TYPE  BBPT_CND_MM_CONDIT
*"     VALUE(IT_BAPICONDQS) TYPE  BBPT_CND_MM_CONDQS
*"     VALUE(IT_BAPICONDVS) TYPE  BBPT_CND_MM_CONDVS
*"     VALUE(IT_BAPIKNUMHS) TYPE  ZCTGSD_BAPIKNUMHS
*"     VALUE(IT_MEM_INITIAL) TYPE  ZCTGSD_MEM_INITIAL
*"     VALUE(IV_DELETE) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_COND_NO) TYPE  KNUMH
*"  EXPORTING
*"     VALUE(ET_MESSAGES) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  FREE: et_messages.

  DATA(lo_events) = NEW zclsd_gestao_preco_events( ).
  lo_events->gs_delete = iv_delete.

  lo_events->call_bapi_prices_conditions(
    EXPORTING
      it_bapicondct  = it_bapicondct
      it_bapicondhd  = it_bapicondhd
      it_bapicondit  = it_bapicondit
      it_bapicondqs  = it_bapicondqs
      it_bapicondvs  = it_bapicondvs
      it_bapiknumhs  = it_bapiknumhs
      it_mem_initial = it_mem_initial
      iv_cond_no     = iv_cond_no
    IMPORTING
      et_return      = et_messages ).


ENDFUNCTION.
