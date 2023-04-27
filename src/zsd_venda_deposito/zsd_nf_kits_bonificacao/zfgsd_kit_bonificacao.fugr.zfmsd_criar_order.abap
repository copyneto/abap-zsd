function zfmsd_criar_order.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_ORDER_HEADER_IN) TYPE  BAPISDHD1
*"     VALUE(IT_ORDER_ITEMS_IN) TYPE  BAPISDITM_TT
*"     VALUE(IT_ORDER_ITEMS_INX) TYPE  BAPISDITMX_TT
*"     VALUE(IT_ORDER_PARTNERS) TYPE  CMP_T_PARNR
*"     VALUE(IT_ORDER_SCHEDULES_IN) TYPE  CMP_T_SCHDL
*"     VALUE(IT_ORDER_SCHEDULES_INX) TYPE  COD_T_BAPISCHDLX
*"     VALUE(IT_ORDER_TEXT) TYPE  BAPISDTEXT_T
*"     VALUE(IT_ZTSD_KITBON_CTR) TYPE  ZCTGSD_KITBON_CTR
*"  EXPORTING
*"     VALUE(EV_SALESDOCUMENT) TYPE  VBELN_VA
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  constants:
       gc_updateflag_i    TYPE char01          VALUE 'I'.

    DATA: ls_order_header_in     TYPE bapisdhd1,
          ls_order_header_inx    TYPE bapisdhd1x,
          lv_salesdocument       TYPE vbeln_va,
          lt_return              TYPE TABLE OF bapiret2,
          lt_order_items_in      TYPE TABLE OF bapisditm,
          lt_order_items_inx     TYPE TABLE OF bapisditmx,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_schedules_in  TYPE TABLE OF bapischdl,
          lt_order_schedules_inx TYPE TABLE OF bapischdlx,
          lt_order_text          TYPE TABLE OF bapisdtext,
          ls_order_items_in      TYPE bapisditm,
          ls_order_items_inx     TYPE bapisditmx,
          ls_order_partners      TYPE bapiparnr,
          ls_order_schedules_in  TYPE bapischdl,
          ls_order_schedules_inx TYPE bapischdlx,
          ls_order_text          TYPE bapisdtext,
          lt_ztsd_kitbon_ctr     type zctgsd_kitbon_ctr.

      ls_order_header_inx-updateflag    = gc_updateflag_i.
      ls_order_header_inx-doc_type      =
      ls_order_header_inx-sales_org     =
      ls_order_header_inx-division      =
      ls_order_header_inx-distr_chan    = abap_true.

      lt_order_partners = it_order_partners.

      lt_order_text = it_order_text.

      lt_order_items_in  = it_order_items_in.
      lt_order_items_inx = it_order_items_inx.

      lt_order_schedules_in  = it_order_schedules_in.
      lt_order_schedules_inx = it_order_schedules_inx.

      CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
        EXPORTING
          order_header_in     = is_order_header_in
          order_header_inx    = ls_order_header_inx
        IMPORTING
          salesdocument       = lv_salesdocument
        TABLES
          return              = lt_return
          order_items_in      = lt_order_items_in
          order_items_inx     = lt_order_items_inx
          order_partners      = lt_order_partners
          order_schedules_in  = lt_order_schedules_in
          order_schedules_inx = lt_order_schedules_inx
          order_text          = lt_order_text.

      IF lv_salesdocument IS NOT INITIAL.

        lt_ztsd_kitbon_ctr = it_ztsd_kitbon_ctr.

         loop at lt_ztsd_kitbon_ctr assigning field-symbol(<fs_ztsd_kitbon_ctr>).
            <fs_ztsd_kitbon_ctr>-vbeln = lv_salesdocument.
            <fs_ztsd_kitbon_ctr>-created_by  = sy-uname.
            GET TIME STAMP FIELD <fs_ztsd_kitbon_ctr>-created_at.
         endloop.

         modify ztsd_kitbon_ctr from table lt_ztsd_kitbon_ctr.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.

      ev_salesdocument = lv_salesdocument.
      APPEND LINES OF lt_return TO et_return.

ENDFUNCTION.
