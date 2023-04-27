FUNCTION zfmsd_altera_motivo_recusa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SALESDOCUMENT) TYPE  VBELN_VA OPTIONAL
*"     VALUE(IS_ORDER_HEADER_INX) TYPE  BAPISDH1X OPTIONAL
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2
*"      ET_ORDER_ITEM_IN STRUCTURE  BAPISDITM
*"      ET_ORDER_ITEM_INX STRUCTURE  BAPISDITMX
*"----------------------------------------------------------------------
  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_salesdocument
      order_header_inx = is_order_header_inx
    TABLES
      return           = et_return
      order_item_in    = et_order_item_in
      order_item_inx   = et_order_item_inx.

  SORT et_return BY type.
  READ TABLE et_return TRANSPORTING NO FIELDS WITH KEY type = 'E' BINARY SEARCH.
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
