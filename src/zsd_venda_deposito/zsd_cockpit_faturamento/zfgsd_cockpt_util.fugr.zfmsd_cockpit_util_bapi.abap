FUNCTION zfmsd_cockpit_util_bapi.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ORDER) TYPE  VBELN_VA
*"     VALUE(IS_ORDERX) TYPE  BAPISDH1X
*"  TABLES
*"      TT_ITEM STRUCTURE  BAPISDITM
*"      TT_ITEMX STRUCTURE  BAPISDITMX
*"      TT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------


  DATA: ls_orderx TYPE bapisdh1x.
  DATA: lt_return TYPE TABLE OF bapiret2.
  DATA: lt_item   TYPE TABLE OF bapisditm.
  DATA: lt_itemx  TYPE TABLE OF bapisditmx.
  DATA: lv_param TYPE ze_param_low.


*  SELECT SINGLE low
*INTO lv_param
*FROM ztca_param_val
*WHERE modulo = 'SD'
*  AND chave1 = 'ADM_FATURAMENTO'
*  AND chave2 = 'REASON_REJ'
*  AND chave3 = 'ELIMINAR'.

*  ls_orderx-updateflag = 'U'.
*  ls_orderx-dlv_block = abap_true.
*
*  APPEND VALUE #( itm_number = iv_item
*                  reason_rej = iv_param ) TO lt_item.
*
*  APPEND VALUE #( itm_number = iv_item
*                  updateflag = 'U'
*                  reason_rej = abap_true ) TO lt_itemx.

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_order
      order_header_inx = is_orderx
*      order_header_inx = ls_orderx
    TABLES
      return           = lt_return[]
      order_item_in    = tt_item[]
      order_item_inx   = tt_itemx[].
*      order_item_in    = lt_item
*      order_item_inx   = lt_itemx.

  IF line_exists( lt_return[ type = 'S' ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ENDIF.


  tt_return[] = lt_return[].

ENDFUNCTION.
