FUNCTION zfmsd_substituir_produto.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ORDER) TYPE  VBELN_VA
*"     VALUE(IS_ORDERX) TYPE  BAPISDH1X
*"  TABLES
*"      TT_RETURN STRUCTURE  BAPIRET2
*"      TT_ITEM STRUCTURE  BAPISDITM
*"      TT_ITEMX STRUCTURE  BAPISDITMX
*"      TT_SCHEDULE_LINES STRUCTURE  BAPISCHDL OPTIONAL
*"      TT_SCHEDULE_LINESX STRUCTURE  BAPISCHDLX OPTIONAL
*"----------------------------------------------------------------------
  data: lt_return TYPE table of bapiret2.

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_order
      order_header_inx = is_orderx
    TABLES
      return           = lt_return
      order_item_in    = tt_item
      order_item_inx   = tt_itemx
      schedule_lines   = tt_schedule_lines
      schedule_linesx  = tt_schedule_linesx.
  DELETE lt_return WHERE  type = 'W'.

  IF line_exists( lt_return[ type = 'S' ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ENDIF.


  tt_return[] = lt_return[].

ENDFUNCTION.
