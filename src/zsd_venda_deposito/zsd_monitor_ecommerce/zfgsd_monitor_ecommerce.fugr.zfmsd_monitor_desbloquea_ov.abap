FUNCTION zfmsd_monitor_desbloquea_ov.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ORDEM) TYPE  VBELN_VA
*"  TABLES
*"      ET_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  DATA lt_return TYPE bapiret2_tab.

  CONSTANTS: lc_update TYPE char1 VALUE 'U',
             lc_true   TYPE char1 VALUE 'X',
             lc_sucess TYPE char1 VALUE 'S'.

  DATA(ls_order_header) = VALUE bapisdh1x( updateflag = lc_update
                                           dlv_block  = lc_true ).
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_ordem
      order_header_inx = ls_order_header
    TABLES
      return           = lt_return.

  SORT lt_return BY type.
  READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type = lc_sucess BINARY SEARCH.
  IF sy-subrc = 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = lc_true.
  ENDIF.

  et_return[] = lt_return.

ENDFUNCTION.
