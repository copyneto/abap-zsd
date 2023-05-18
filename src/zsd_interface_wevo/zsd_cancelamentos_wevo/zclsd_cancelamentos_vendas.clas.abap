CLASS zclsd_cancelamentos_vendas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      "! Constructor
      constructor
        IMPORTING
          is_input TYPE zclsd_mt_venda_cancelamento
        RAISING
          zcxtm_erro_interface.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS gc_object     TYPE bal_s_log-object    VALUE 'ZSD_INTERFACE_WEVO' .
    CONSTANTS gc_subobject  TYPE bal_s_log-subobject VALUE 'CANCELAMENTO'.

    TYPES: tt_item  TYPE TABLE OF bapisditm,
           tt_itemx TYPE TABLE OF bapisditmx.

    DATA: gs_header       TYPE bapisdh1,
          gs_headerx      TYPE bapisdh1x,
          gt_item         TYPE tt_item,
          gt_itemx        TYPE tt_itemx,
          gv_check_commit TYPE c.

    DATA: gs_input  TYPE zclsd_mt_venda_cancelamento,
          gt_return TYPE bapiret2_t.

    METHODS:
      "! Process interface
      process_data
        RAISING
          zcxtm_erro_interface,

      "! Execute bapi 'BAPI_SALESORDER_CHANGE'
      bapi_change
        IMPORTING
          iv_salesdocument TYPE i_salesdocument-salesdocument OPTIONAL
          is_header        TYPE bapisdh1 OPTIONAL
          is_headerx       TYPE bapisdh1x OPTIONAL
          it_item          TYPE tt_item OPTIONAL
          it_itemx         TYPE tt_itemx OPTIONAL
        RAISING
          zcxtm_erro_interface,

      "! Log application error
      call_exeception
        IMPORTING
          iv_msgid TYPE symsgid
          iv_msgno TYPE symsgno
          iv_attr1 TYPE scx_attrname OPTIONAL
          iv_attr2 TYPE scx_attrname OPTIONAL
          iv_attr3 TYPE scx_attrname OPTIONAL
          iv_attr4 TYPE scx_attrname OPTIONAL
        RAISING
          zcxtm_erro_interface,

      bapi_commit.

ENDCLASS.



CLASS zclsd_cancelamentos_vendas IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
*    me->save_error_logs( ).
  ENDMETHOD.


  METHOD process_data.
    TYPES: BEGIN OF ty_salesdocument,
             salesdocument TYPE i_salesdocument-salesdocument,
           END OF ty_salesdocument.

    TYPES: BEGIN OF ty_deliverydocumentitem,
             deliverydocument    TYPE i_deliverydocumentitem-deliverydocument,
             referencesddocument TYPE i_deliverydocumentitem-referencesddocument,
             goodsmovementstatus TYPE i_deliverydocumentitem-goodsmovementstatus,
           END OF ty_deliverydocumentitem.

    TYPES: BEGIN OF ty_salesdocumentitem,
             salesdocument     TYPE i_salesdocumentitem-salesdocument,
             salesdocumentitem TYPE i_salesdocumentitem-salesdocumentitem,
             material          TYPE i_salesdocumentitem-material,
           END OF ty_salesdocumentitem.

    DATA: lt_salesdocument        TYPE TABLE OF ty_salesdocument,
          lt_deliverydocumentitem TYPE TABLE OF ty_deliverydocumentitem,
          lt_salesdocumentitem    TYPE TABLE OF ty_salesdocumentitem,
          ls_vbkok_wa             TYPE vbkok,
          lv_salesdocument        TYPE i_salesdocument-salesdocument.


    DATA: lv_purchaseorderbycustomer(35) TYPE c.
    lv_purchaseorderbycustomer = gs_input-mt_venda_cancelamento-purchaseorderbycustomer.

    DATA: lv_length TYPE i.
    lv_length = strlen( lv_purchaseorderbycustomer ).

    IF lv_length <= 10.

      SELECT salesdocument
        FROM i_salesdocument
        WHERE salesdocument EQ @lv_purchaseorderbycustomer
        INTO TABLE @lt_salesdocument.
      IF sy-subrc NE 0.
        SELECT salesdocument
          FROM i_salesdocument
          WHERE purchaseorderbycustomer EQ @lv_purchaseorderbycustomer
          INTO TABLE @lt_salesdocument.
        IF sy-subrc NE 0.
          me->call_exeception(  iv_msgid = CONV symsgid( TEXT-002 )
                                iv_msgno = 001
                                iv_attr1 = CONV scx_attrname( lv_purchaseorderbycustomer ) ).
        ENDIF.
      ENDIF.
    ELSE.
      SELECT salesdocument
        FROM i_salesdocument
        WHERE purchaseorderbycustomer EQ @lv_purchaseorderbycustomer
        INTO TABLE @lt_salesdocument.
      IF sy-subrc NE 0.
        me->call_exeception(  iv_msgid = CONV symsgid( TEXT-002 )
                              iv_msgno = 001
                              iv_attr1 = CONV scx_attrname( lv_purchaseorderbycustomer ) ).
      ENDIF.
    ENDIF.

    IF gs_input-mt_venda_cancelamento-salesdocumentrjcnreason IS NOT INITIAL.

      SELECT deliverydocument,
             referencesddocument,
             goodsmovementstatus
          INTO TABLE @lt_deliverydocumentitem
          FROM i_deliverydocumentitem
          FOR ALL ENTRIES IN @lt_salesdocument
          WHERE referencesddocument = @lt_salesdocument-salesdocument
          AND goodsmovementstatus <> 'C'.
      IF sy-subrc = 0.

        LOOP AT lt_deliverydocumentitem ASSIGNING FIELD-SYMBOL(<fs_deliverydocumentitem>).
          ls_vbkok_wa-vbeln_vl = <fs_deliverydocumentitem>-deliverydocument.
          ls_vbkok_wa-likp_del = abap_true.

          CALL FUNCTION 'WS_DELIVERY_UPDATE'
            EXPORTING
              vbkok_wa      = ls_vbkok_wa
              commit        = 'X'
              delivery      = ls_vbkok_wa-vbeln_vl
            EXCEPTIONS
              error_message = 99.

          IF sy-subrc <> 0.
            me->call_exeception( iv_msgid = sy-msgid
                                 iv_msgno = sy-msgno
                                 iv_attr1 = CONV scx_attrname( sy-msgv1 )
                                 iv_attr2 = CONV scx_attrname( sy-msgv2 )
                                 iv_attr3 = CONV scx_attrname( sy-msgv3 )
                                 iv_attr4 = CONV scx_attrname( sy-msgv4 ) ).
          ENDIF.
        ENDLOOP.

        WAIT UP TO 5 SECONDS.

      ENDIF.

    ENDIF.

    IF lt_salesdocument IS NOT INITIAL.

      READ TABLE lt_salesdocument ASSIGNING FIELD-SYMBOL(<fs_salesdocument>) INDEX 1.
      lv_salesdocument = <fs_salesdocument>-salesdocument.

      SELECT salesdocument,
             salesdocumentitem,
             material
          INTO TABLE @lt_salesdocumentitem
          FROM i_salesdocumentitem
          FOR ALL ENTRIES IN @lt_salesdocument
          WHERE salesdocument = @lt_salesdocument-salesdocument.

      gs_headerx-updateflag = 'U'.
      gs_headerx-bill_block = abap_true.
      gs_header-bill_block  = gs_input-mt_venda_cancelamento-headerbillingblockreason.

      IF gs_input-mt_venda_cancelamento-salesdocumentrjcnreason IS NOT INITIAL.

        LOOP AT lt_salesdocumentitem ASSIGNING FIELD-SYMBOL(<fs_salesdocumentitem>).

          APPEND INITIAL LINE TO gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
          <fs_item>-itm_number = <fs_salesdocumentitem>-salesdocumentitem.
          <fs_item>-material = <fs_salesdocumentitem>-material.
          <fs_item>-reason_rej = gs_input-mt_venda_cancelamento-salesdocumentrjcnreason.

        ENDLOOP.

      ENDIF.

      me->bapi_change( EXPORTING iv_salesdocument = lv_salesdocument is_header = gs_header is_headerx = gs_headerx it_item = gt_item it_itemx = gt_itemx ).

*      IF gv_check_commit = abap_true.
*
*        me->bapi_change( EXPORTING iv_salesdocument = lv_salesdocument is_header = gs_header is_headerx = gs_headerx it_item = gt_item it_itemx = gt_itemx ).
*      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD bapi_change.
    DATA: lt_ret              TYPE STANDARD TABLE OF bapiret2,
          lv_doc              TYPE vbeln,
          ls_order_header_in  TYPE bapisdh1,
          ls_order_header_inx TYPE bapisdh1x,
          lt_order_item_in    TYPE TABLE OF bapisditm,
          lt_order_item_inx   TYPE TABLE OF bapisditmx.

    MOVE-CORRESPONDING is_header TO ls_order_header_in.
    MOVE-CORRESPONDING is_headerx TO ls_order_header_inx.
    lt_order_item_in[] = it_item[].
    lt_order_item_inx[] = it_itemx[].

    lv_doc = iv_salesdocument.
    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
      EXPORTING
        salesdocument    = lv_doc
        order_header_in  = ls_order_header_in
        order_header_inx = ls_order_header_inx
      TABLES
        return           = lt_ret
        order_item_in    = lt_order_item_in
        order_item_inx   = lt_order_item_inx
      EXCEPTIONS
        error_message    = 1
        OTHERS           = 2.

    IF ( sy-subrc NE 0 AND line_exists( lt_ret[ type = 'E' ] ) ) OR
       ( sy-subrc EQ 0 AND line_exists( lt_ret[ type = 'E' ] ) ).
      APPEND LINES OF lt_ret TO me->gt_return.
    ELSE.

      me->bapi_commit(  ).
      gv_check_commit = abap_true.
    ENDIF.
  ENDMETHOD.


  METHOD bapi_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.
  METHOD call_exeception.

    RAISE EXCEPTION TYPE zcxtm_erro_interface
      EXPORTING
        iv_textid = VALUE scx_t100key( msgid = iv_msgid
                                       msgno = iv_msgno
                                       attr1 = iv_attr1
                                       attr2 = iv_attr2
                                       attr3 = iv_attr3
                                       attr4 = iv_attr4 ).

  ENDMETHOD.

ENDCLASS.
