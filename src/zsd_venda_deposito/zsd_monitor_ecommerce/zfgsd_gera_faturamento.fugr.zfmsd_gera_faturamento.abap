FUNCTION zfmsd_gera_faturamento.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      ET_BILLING_DATA_IN STRUCTURE  BAPIVBRK
*"      ET_CONDITION_DATA_IN STRUCTURE  BAPIKOMV
*"      ET_RETURN STRUCTURE  BAPIRETURN1
*"      ET_CCARD_DATA_IN STRUCTURE  BAPICCARD_VF
*"----------------------------------------------------------------------

  CALL FUNCTION 'BAPI_BILLINGDOC_CREATEFROMDATA'
    TABLES
      billing_data_in   = et_billing_data_in
      condition_data_in = et_condition_data_in
      returnlog_out     = et_return
      ccard_data_in     = et_ccard_data_in.

  SORT et_return BY type.
  READ TABLE et_return TRANSPORTING NO FIELDS WITH KEY type = 'E' BINARY SEARCH.
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ENDIF.



ENDFUNCTION.
