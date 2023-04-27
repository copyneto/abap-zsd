FUNCTION zfmsd_recusar_ordem.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SALESDOCUMENT) TYPE  VBELN
*"     VALUE(IS_ORDER_HEADER_IN) TYPE  BAPISDH1
*"     VALUE(IS_ORDER_HEADER_INX) TYPE  BAPISDH1X
*"     VALUE(IT_ORDER_ITEM_IN) TYPE  BAPISDITM_TT
*"     VALUE(IT_ORDER_ITEM_INX) TYPE  BAPISDITMX_TT
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA: ls_order_header_in  TYPE bapisdh1,
        ls_order_header_inx TYPE bapisdh1x,
        lt_return           TYPE bapiret2_t,
        lt_order_item_in    TYPE TABLE OF bapisditm,
        lt_order_item_inx   TYPE TABLE OF bapisditmx,
        lv_last_changed_at  type ZE_LAST_CHANGED_AT.

  lt_order_item_in = it_order_item_in.
  lt_order_item_inx = it_order_item_inx.

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_salesdocument
      order_header_in  = is_order_header_in
      order_header_inx = is_order_header_inx
    TABLES
      return           = lt_return
      order_item_in    = lt_order_item_in
      order_item_inx   = lt_order_item_inx.

  IF line_exists( lt_return[ type = 'E' ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
  ELSE.

    GET TIME STAMP FIELD lv_last_changed_at.

    update ZTSD_KITBON_CTR
     set estorno = ABAP_true
         last_changed_by = sy-uname
         last_changed_at = lv_last_changed_at
       where VBELN = iv_salesdocument.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

  et_return = lt_return.

ENDFUNCTION.
