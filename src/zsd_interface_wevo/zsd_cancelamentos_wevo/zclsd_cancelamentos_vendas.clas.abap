CLASS zclsd_cancelamentos_vendas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          is_input TYPE zclsd_mt_venda_cancelamento.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: tt_item  TYPE TABLE OF bapisditm,
           tt_itemx TYPE TABLE OF bapisditmx.

    DATA: gs_header       TYPE bapisdh1,
          gs_headerx      TYPE bapisdh1x,
          gt_item         TYPE tt_item,
          gt_itemx        TYPE tt_itemx,
          gv_check_commit TYPE c.

    DATA: gs_input     TYPE zclsd_mt_venda_cancelamento.

    METHODS:
      process_data
        RAISING
          zcxsd_erro_interface,

      "! Execute bapi 'BAPI_SALESORDER_CHANGE'
      bapi_change
        IMPORTING
          iv_salesdocument TYPE i_salesdocument-salesdocument OPTIONAL
          is_header        TYPE bapisdh1 OPTIONAL
          is_headerx       TYPE bapisdh1x OPTIONAL
          it_item          TYPE tt_item OPTIONAL
          it_itemx         TYPE tt_itemx OPTIONAL
        RAISING
          zcxsd_erro_interface,

      "! Raising erro
      erro
        IMPORTING
          is_erro TYPE scx_t100key
        RAISING
          zcxsd_erro_interface,

      bapi_commit.

ENDCLASS.



CLASS ZCLSD_CANCELAMENTOS_VENDAS IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
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
          me->erro( VALUE scx_t100key( msgid = TEXT-002
                                       msgno = '001'
                                       attr1 = TEXT-001
          ) ).

        ENDIF.
      ENDIF.
    ELSE.
      SELECT salesdocument
        FROM i_salesdocument
        WHERE purchaseorderbycustomer EQ @lv_purchaseorderbycustomer
        INTO TABLE @lt_salesdocument.
      IF sy-subrc NE 0.
        me->erro( VALUE scx_t100key( msgid = TEXT-002
                                     msgno = '001'
                                     attr1 = TEXT-001
        ) ).

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
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
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
          lt_order_item_in    TYPE TABLE of bapisditm,
          lt_order_item_inx   TYPE TABLE of bapisditmx.

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

      me->erro( VALUE scx_t100key( msgid = lt_ret[ 1 ]-id
                                   msgno = lt_ret[ 1 ]-number
                                   attr1 = lt_ret[ 1 ]-message
                                   attr2 = lt_ret[ 1 ]-message_v1
                                   attr3 = lt_ret[ 1 ]-message_v2
                                   attr4 = lt_ret[ 1 ]-message_v3
                                    ) ).

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


  METHOD erro.

    RAISE EXCEPTION TYPE zcxsd_erro_interface
      EXPORTING
        textid = is_erro.

  ENDMETHOD.
ENDCLASS.