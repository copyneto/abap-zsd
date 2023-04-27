FUNCTION zfmsd_gera_ov_devolucao.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_RETURN_HEADER_IN) TYPE  BAPISDHD1
*"     VALUE(IS_RETURN_HEADER_INX) TYPE  BAPISDHD1X
*"  EXPORTING
*"     VALUE(EV_SALESDOCUMENT) TYPE  VBELN_VA
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2
*"      IT_ITEMS_IN STRUCTURE  BAPISDITM
*"      IT_ITEMS_INX STRUCTURE  BAPISDITMX
*"      IT_PARTNERS STRUCTURE  BAPIPARNR
*"      IT_SCHEDULES_IN STRUCTURE  BAPISCHDL
*"      IT_SCHEDULES_INX STRUCTURE  BAPISCHDLX
*"      IT_CONDITIONS_IN STRUCTURE  BAPICOND
*"      IT_LPP STRUCTURE  ZSSD_CKPT_DEL_ZLPP OPTIONAL
*"----------------------------------------------------------------------
  " Tabela global utilizada na exit para passar o cost center
  gt_items_in = it_items_in[].
  " Tabela global utilizada na rotina RV61A617 para não determinar o ZLPP
  gt_lpp = it_lpp[].

  CALL FUNCTION 'BAPI_CUSTOMERRETURN_CREATE'
    EXPORTING
      return_header_in     = is_return_header_in
      return_header_inx    = is_return_header_inx
    IMPORTING
      salesdocument        = ev_salesdocument
    TABLES
      return               = et_return
      return_items_in      = it_items_in
      return_items_inx     = it_items_inx
      return_partners      = it_partners
      return_schedules_in  = it_schedules_in
      return_schedules_inx = it_schedules_inx
      return_conditions_in = it_conditions_in.

  IF NOT ev_salesdocument IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
