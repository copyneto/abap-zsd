CLASS zclsd_verif_util_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: gv_param TYPE ze_param_low.
    TYPES: ty_item_bapi TYPE TABLE OF bapisditm.
    TYPES: ty_itemx_bapi TYPE TABLE OF bapisditmx.
    "! Método para realizar a Ação Eliminar produto
    "! @parameter IV_ORDER         | Ordem
    "! @parameter RT_MENSAGENS     | Mensagens de erro
    METHODS eliminar_produto
      IMPORTING
        !iv_order           TYPE vbeln_va
*        !iv_item            TYPE posnr_va
        !is_orderx          TYPE bapisdh1x
        !it_item            TYPE ty_item_bapi
        !it_itemx           TYPE ty_itemx_bapi
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .

    "! Método para consultar tabela de parâmetro
    METHODS get_parametro
      RETURNING
        VALUE(rv_param) TYPE ze_param_low .

    "! Método para processamento em background da ação Eliminar produto
    "! @parameter P_TASK         | Parâmetro Standard
    METHODS task_finish_eliminar
      IMPORTING
        !p_task TYPE clike .
    "! Método para processamento em background da ação Substituir produto
    "! @parameter P_TASK         | Parâmetro Standard
    METHODS task_substituir
      IMPORTING
        !p_task TYPE clike .
    "! Método para processamento em background da ação Substituir produto
    "! @parameter P_TASK         | Parâmetro Standard
    METHODS task_desconto
      IMPORTING
        !p_task TYPE clike .
    "! Método para realizar a Ação Subistituir produto
    "! @parameter IV_ORDER         | Ordem
    "! @parameter IV_ITEM          | Item
    "! @parameter IV_NEW_MATERIAL  | Material novo
    "! @parameter RT_MENSAGENS     | Mensagens de erro
    METHODS substituir_produto
      IMPORTING
        !iv_order           TYPE vbeln_va
        !iv_item            TYPE posnr_va
        !iv_new_material    TYPE matnr
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .

    TYPES: BEGIN OF ty_knumh,
             knumh TYPE knumh,
           END OF ty_knumh.
    TYPES: tt_knumh TYPE TABLE OF ty_knumh.

    DATA: gt_knumh87 TYPE TABLE OF ty_knumh,
          gt_knumh86 TYPE TABLE OF ty_knumh.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gt_return_eliminar TYPE bapiret2_tab .
    DATA:
      gt_orderitems TYPE STANDARD TABLE OF bapisditbos .
    DATA:
      gt_orderschedulelines TYPE STANDARD TABLE OF bapisdhedu .
    DATA:
      gt_orderconditem TYPE STANDARD TABLE OF bapicondit .
    DATA gs_order_header_inx TYPE bapisdh1x .
    DATA gs_order_item_in TYPE bapisditm .
    DATA:
      gt_return_recusado TYPE STANDARD TABLE OF bapiret2 .
    DATA:
      gt_order_item_in TYPE STANDARD TABLE OF bapisditm .
    DATA:
      gt_order_item_inx TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      gt_return_subs TYPE STANDARD TABLE OF bapiret2 .
    DATA gs_orderheader TYPE bapisdhd .
    DATA gt_vbkd TYPE vbkd_t .

    DATA gt_schedule_lines  TYPE STANDARD TABLE OF bapischdl.
    DATA gt_schedule_linesx TYPE STANDARD TABLE OF bapischdlx.
    DATA gs_schedule_lines  TYPE  bapischdl.
    DATA gs_schedule_linesx TYPE  bapischdlx.
    DATA gt_conditions_in   TYPE STANDARD TABLE OF bapicond.
    DATA gt_conditions_inx  TYPE STANDARD TABLE OF bapicondx.
    DATA gs_conditions_in   TYPE  bapicond.
    DATA gs_conditions_inx  TYPE  bapicondx.
    TYPES: BEGIN OF ty_cond,
             kbetr TYPE kbetr,
             kschl TYPE kschl,
           END OF ty_cond.
    TYPES tt_cond TYPE TABLE OF ty_cond.
    DATA: gt_cond TYPE TABLE OF ty_cond.

    "! Método para realizar eliminação do produto
    "! @parameter IV_ORDER         | Ordem
    METHODS call_bapi_eliminar
      IMPORTING
        !iv_order  TYPE vbeln_va
*        !iv_item  TYPE posnr_va
        !is_orderx TYPE bapisdh1x
        !it_item   TYPE ty_item_bapi
        !it_itemx  TYPE ty_itemx_bapi.

    METHODS get_parametrosub
      RETURNING
        VALUE(rv_paramsub) TYPE ze_param_low .
    "! Método para realizar commit das modificações
    METHODS commit_work .
    "! Método para realizar substituição do produto
    "! @parameter IV_ORDER         | Ordem
    METHODS call_bapi_substituir
      IMPORTING
        !iv_order TYPE vbeln_va .
    "! Método para realizar recusa do item
    "! @parameter IV_ORDER         | Ordem
    "! @parameter IV_ITEM          | Item
    METHODS recusa_item
      IMPORTING
        !iv_order TYPE vbeln_va
        !iv_item  TYPE posnr_va .
    "! Método para realizar seleção do item
    "! @parameter RV_ITEM          | Item
    METHODS seleciona_item
      RETURNING
        VALUE(rv_item) TYPE posnr_va .
    "! Método para realizar inclusão do item
    "! @parameter IV_ITEM          | Item
    "! @parameter IV_ORDER          | Ordem
    METHODS incluir_item
      IMPORTING
        !iv_item         TYPE posnr_va
        !iv_order        TYPE vbeln_va
        !iv_new_material TYPE matnr.
    "! Método para seleção dos dados da ordem
    "! @parameter IV_ORDER          | Ordem
    METHODS call_get_details
      IMPORTING
        !iv_order TYPE vbeln_va .
    "! Método para realizar validação dos preços entre o material antigo e o novo
    "! @parameter IV_NEW_MATERIAL      | Material novo
    "! @parameter IV_ITEM              | Item
    "! @parameter RV_RETURN            | Verdadeiro ou Falso
    METHODS validate_pricing
      IMPORTING
        !iv_new_material TYPE matnr
        !iv_item         TYPE posnr_va
        !iv_order        TYPE vbeln_va
      RETURNING
        VALUE(rv_return) TYPE abap_bool .
    "! Método para realizar seleção na tabela A817
    "! @parameter IV_MATERIAL          | Material
    "! @parameter IV_PRICELISTTYPE     | Tipo da lista de preço
    "! @parameter IV_CENTRO            | Centro
    METHODS get_a817
      IMPORTING
        !iv_material      TYPE matnr
        !iv_pricelisttype TYPE pltyp
        !iv_centro        TYPE werks_d
*      RETURNING
*        VALUE(rv_knumh)   TYPE knumh .
      EXPORTING
        !et_knumh87       TYPE tt_knumh.
    "! Método para realizar seleção na tabela A816
    "! @parameter IV_MATERIAL          | Material
    "! @parameter IV_CENTRO            | Centro
    METHODS get_a816
      IMPORTING
        !iv_material TYPE matnr
        !iv_centro   TYPE werks_d
*      RETURNING
*        VALUE(rv_knumh)   TYPE knumh .
      EXPORTING
        !et_knumh86  TYPE tt_knumh.
    METHODS valida_desconto
      IMPORTING
        !iv_item  TYPE posnr_va
        !iv_order TYPE vbeln_va.


    "! Método para realizar seleção na tabela KONP
    METHODS get_konp
      IMPORTING
*        !iv_knumh       TYPE knumh
        !it_knumh       TYPE tt_knumh
      RETURNING
        VALUE(rv_kbetr) TYPE kbetr .

    METHODS get_konp_kmein
      IMPORTING
*        !iv_knumh       TYPE knumh
        !it_knumh       TYPE tt_knumh
      RETURNING
        VALUE(rv_kmein) TYPE kmein .
    "! Método para realizar inclusão do item
    "! @parameter IV_ITEM          | Item
    METHODS obter_preco
      IMPORTING
        !iv_item        TYPE posnr_va
        !iv_material    TYPE matnr
        !iv_condition   TYPE knumv
      RETURNING
        VALUE(rv_kbetr) TYPE kbetr .
    "! Método para realizar inclusão do item
    "! @parameter IV_ITEM          | Item
    METHODS obter_kmein
      IMPORTING
        !iv_item        TYPE posnr_va
        !iv_material    TYPE matnr
        !iv_condition   TYPE knumv
      RETURNING
        VALUE(rv_kmein) TYPE kmein .
    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_message
      IMPORTING iv_change_error_type   TYPE flag OPTIONAL
                iv_change_warning_type TYPE flag OPTIONAL
      CHANGING  ct_return              TYPE bapiret2_t.
ENDCLASS.



CLASS ZCLSD_VERIF_UTIL_ACTIONS IMPLEMENTATION.


  METHOD call_bapi_eliminar.

*    DATA: ls_orderx TYPE bapisdh1x.
    DATA: lt_return TYPE TABLE OF bapiret2.
*    DATA: lt_item   TYPE TABLE OF bapisditm.
*    DATA: lt_itemx  TYPE TABLE OF bapisditmx.
*
*    ls_orderx-updateflag = 'U'.
*    ls_orderx-dlv_block = abap_true.
*
*    APPEND VALUE #( itm_number = iv_item
*                    reason_rej = get_parametro( ) ) TO lt_item.
*
*    APPEND VALUE #( itm_number = iv_item
*                    updateflag = 'U'
*                    reason_rej = abap_true ) TO lt_itemx.
*
*    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
*      STARTING NEW TASK 'ELIMINAR' CALLING task_finish_eliminar ON END OF TASK
*      EXPORTING
*        salesdocument    = iv_order
*        order_header_inx = ls_orderx
*      TABLES
*        return           = lt_return
*        order_item_in    = lt_item
*        order_item_inx   = lt_itemx.
*
*    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.
*
*
*    CHECK  line_exists( gt_return_eliminar[ type = 'S' ] ). "#EC CI_STDSEQ
*    commit_work( ).
*
    CALL FUNCTION 'ZFMSD_COCKPIT_UTIL_BAPI'
      STARTING NEW TASK 'ELIMINAR' CALLING task_finish_eliminar ON END OF TASK
      EXPORTING
        iv_order  = iv_order
        is_orderx = is_orderx
*       iv_item   = iv_item
*       iv_param  = gv_param
      TABLES
        tt_item   = it_item
        tt_itemx  = it_itemx
        tt_return = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

  ENDMETHOD.


  METHOD commit_work.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
      EXPORTING
        wait = 'X'.
  ENDMETHOD.


  METHOD eliminar_produto.

    call_bapi_eliminar( EXPORTING iv_order  = iv_order
                                  is_orderx = is_orderx
                                  it_item   = it_item
                                  it_itemx  = it_itemx ).
*                                  iv_item = iv_item ).

    APPEND LINES OF  gt_return_eliminar TO rt_mensagens.

  ENDMETHOD.


  METHOD get_parametro.

    SELECT SINGLE low
      INTO rv_param
      FROM ztca_param_val
      WHERE modulo = 'SD'
        AND chave1 = 'ADM_FATURAMENTO'
        AND chave2 = 'REASON_REJ'
        AND chave3 = 'ELIMINAR'.

  ENDMETHOD.


  METHOD task_finish_eliminar.

*    RECEIVE RESULTS FROM FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
*     TABLES
*      return = gt_return_eliminar.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_COCKPIT_UTIL_BAPI'
          TABLES
            tt_return   = gt_return_eliminar.

    RETURN.

  ENDMETHOD.


  METHOD substituir_produto.

    DATA lt_msg TYPE bapiret2_t.

    CLEAR: lt_msg[],  rt_mensagens[], gt_return_subs[].

    call_get_details( iv_order ).

    DATA(lv_return) = validate_pricing( EXPORTING iv_new_material = iv_new_material
                                                  iv_item = iv_item
                                                  iv_order = iv_order ).
    IF gt_return_subs IS NOT INITIAL.
      APPEND LINES OF  gt_return_subs TO rt_mensagens.
    ENDIF.

    CHECK lv_return = abap_true.

    recusa_item( iv_order = iv_order iv_item = iv_item ).
    APPEND LINES OF gt_return_subs TO rt_mensagens.

    valida_desconto( iv_item = iv_item iv_order = iv_order ).

    incluir_item( iv_item = iv_item iv_order = iv_order iv_new_material = iv_new_material ).
    APPEND LINES OF gt_return_subs TO rt_mensagens.

    DELETE ADJACENT DUPLICATES FROM rt_mensagens COMPARING id type number.

    lt_msg[] = rt_mensagens[].

    me->format_message( CHANGING ct_return = lt_msg[] ).

  ENDMETHOD.


  METHOD call_get_details.

    CALL FUNCTION 'BAPI_SALESORDER_GETDETAILBOS'
      EXPORTING
        salesdocument      = iv_order
      IMPORTING
        orderheader        = gs_orderheader
      TABLES
        orderitems         = gt_orderitems
        orderschedulelines = gt_orderschedulelines
        orderconditem      = gt_orderconditem.

    IF gt_orderitems[] IS NOT INITIAL.
      SELECT *
        INTO TABLE gt_vbkd
        FROM vbkd
        FOR ALL ENTRIES IN gt_orderitems
        WHERE vbeln = iv_order
          AND posnr = gt_orderitems-itm_number.
      IF sy-subrc IS INITIAL.
        SORT: gt_vbkd BY vbeln posnr.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD incluir_item.

    CLEAR: gt_order_item_inx,  gs_order_item_in, gt_return_subs, gs_order_header_inx, gs_schedule_lines, gs_schedule_linesx.



    SORT gt_orderitems BY itm_number.
    READ TABLE gt_orderitems ASSIGNING FIELD-SYMBOL(<fs_orderitems>) WITH KEY itm_number = iv_item BINARY SEARCH.
    IF sy-subrc = 0.
*      gs_order_item_in = CORRESPONDING #( <fs_orderitems>  ).
      gs_order_item_in-itm_number = seleciona_item( ).
      gs_order_item_in-material   = iv_new_material.
      gs_order_item_in-plant      = <fs_orderitems>-plant.
      gs_order_item_in-target_qty = <fs_orderitems>-target_qty.
    ENDIF.

    SORT gt_orderitems BY itm_number.
    READ TABLE gt_orderschedulelines ASSIGNING FIELD-SYMBOL(<fs_orderschedulelines>) WITH KEY itm_number = iv_item BINARY SEARCH.
    IF sy-subrc = 0.
*      gs_order_item_in = CORRESPONDING #( <fs_orderschedulelines>  ).
      gs_schedule_lines-itm_number  = seleciona_item( ).
      gs_schedule_lines-req_qty     = <fs_orderschedulelines>-req_qty.
      gs_schedule_linesx-itm_number = seleciona_item( ).
      gs_schedule_linesx-updateflag = 'I'.
      gs_schedule_linesx-req_qty    = 'X'.

    ENDIF.
*
*    SORT gt_orderitems BY itm_number.
*    READ TABLE gt_orderconditem ASSIGNING FIELD-SYMBOL(<fs_orderconditem>) WITH KEY itm_number = iv_item BINARY SEARCH.
*    IF sy-subrc = 0.
*      gs_order_item_in = CORRESPONDING #( <fs_orderitems>  ).
*    ENDIF.


*    gs_order_item_in-itm_number = seleciona_item( ).

    SELECT SINGLE  orderquantityunit
    FROM i_salesorderitem
    INTO @DATA(lv_sales_unit)
    WHERE salesorder = @iv_order
    AND   salesorderitem = @iv_item.
    IF sy-subrc IS INITIAL.
      gs_order_item_in-sales_unit = lv_sales_unit.
    ENDIF.

    CLEAR gt_order_item_in[].

    APPEND gs_order_item_in   TO gt_order_item_in.
    APPEND gs_schedule_lines  TO gt_schedule_lines.
    APPEND gs_schedule_linesx TO gt_schedule_linesx.


    APPEND VALUE #( itm_number  = seleciona_item( )
                    updateflag  = 'I'
                    material    = 'X'
                    plant       = 'X'
                    target_qty  = 'X'
                    sales_unit  = 'X') TO gt_order_item_inx.

    gs_order_header_inx-updateflag = 'U'.
    call_bapi_substituir( iv_order ).

    CLEAR: gt_order_item_in[], gt_schedule_lines[], gt_schedule_linesx[], gt_order_item_inx[].

  ENDMETHOD.


  METHOD seleciona_item.

    SORT gt_orderitems DESCENDING BY itm_number.
    READ TABLE gt_orderitems ASSIGNING FIELD-SYMBOL(<fs_items>) INDEX 1.
    IF sy-subrc = 0.
*      rv_item  = <fs_items>-itm_number + 10.
      rv_item  = 000000.
    ENDIF.

  ENDMETHOD.


  METHOD recusa_item.

    FREE: gt_cond.

    APPEND VALUE #( itm_number = iv_item
                    reason_rej = get_parametrosub( )
                  ) TO gt_order_item_in.

    APPEND VALUE #( itm_number  = iv_item
                     updateflag = 'U'
                     reason_rej = abap_true ) TO gt_order_item_inx.

    gs_order_header_inx-updateflag = 'U'.

    call_bapi_substituir( iv_order ).

  ENDMETHOD.


  METHOD call_bapi_substituir.

    DATA: lt_return TYPE TABLE OF bapiret2.

*    CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
*      STARTING NEW TASK 'SUBSTITUIR' CALLING task_substituir ON END OF TASK
*      EXPORTING
*        salesdocument    = iv_order
*        order_header_inx = gs_order_header_inx
*      TABLES
*        return           = lt_return
*        order_item_in    = gt_order_item_in
*        order_item_inx   = gt_order_item_inx
*        schedule_lines   = gt_schedule_lines
*        schedule_linesx  = gt_schedule_linesx.
*
*
*    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.
*
*    CHECK  line_exists( gt_return_subs[ type = 'S' ] ).
*
*    commit_work(  ).

    DATA lv_order TYPE  vbeln_va.
    DATA ls_orderx TYPE  bapisdh1x.

    lv_order = iv_order.
    ls_orderx  = gs_order_header_inx.

    CALL FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
      STARTING NEW TASK 'SUBSTITUIR' CALLING task_substituir ON END OF TASK
      EXPORTING
        iv_order           = lv_order
        is_orderx          = ls_orderx
      TABLES
        tt_return          = lt_return
        tt_item            = gt_order_item_in
        tt_itemx           = gt_order_item_inx
        tt_schedule_lines  = gt_schedule_lines
        tt_schedule_linesx = gt_schedule_linesx.


    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.



    IF gt_cond[] IS NOT INITIAL.

      FREE:  gt_schedule_lines, gt_schedule_linesx, gt_conditions_in, gt_conditions_inx.
      CLEAR: gs_conditions_in, gs_conditions_inx.


      SELECT MAX( salesorderitem )
      FROM i_salesorderitem
      INTO @DATA(lv_item)
      WHERE salesorder = @lv_order
      .

      READ TABLE gt_order_item_in ASSIGNING FIELD-SYMBOL(<fs_orderitems>) INDEX 1.
      IF sy-subrc = 0.
*      gs_order_item_in = CORRESPONDING #( <fs_orderitems>  ).
        <fs_orderitems>-itm_number = lv_item.
        <fs_orderitems>-target_qty = abap_false.
      ENDIF.
      READ TABLE gt_order_item_inx ASSIGNING FIELD-SYMBOL(<fs_orderitemsx>) INDEX 1.
      IF sy-subrc = 0.
*      gs_order_item_in = CORRESPONDING #( <fs_orderitems>  ).
        <fs_orderitemsx>-itm_number = lv_item.
        <fs_orderitemsx>-target_qty = abap_false.
        <fs_orderitemsx>-updateflag = 'U'.
      ENDIF.

      LOOP AT gt_cond ASSIGNING FIELD-SYMBOL(<fs_cond>).
        gs_conditions_in-cond_type  = <fs_cond>-kschl.
        gs_conditions_in-cond_value = <fs_cond>-kbetr / 10.
        gs_conditions_in-itm_number = lv_item.
        gs_conditions_inx-cond_type  = <fs_cond>-kschl.
        gs_conditions_inx-cond_value = 'X'.
        gs_conditions_inx-itm_number = lv_item.
        gs_conditions_inx-updateflag = 'I'.

        APPEND gs_conditions_in  TO gt_conditions_in.
        APPEND gs_conditions_inx TO gt_conditions_inx.
        CLEAR: gs_conditions_in, gs_conditions_inx.

      ENDLOOP.

      CALL FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
        STARTING NEW TASK 'DESCONTO' CALLING task_desconto ON END OF TASK
        EXPORTING
          iv_order           = lv_order
          is_orderx          = ls_orderx
        TABLES
          tt_return          = lt_return
          tt_item            = gt_order_item_in
          tt_itemx           = gt_order_item_inx
          tt_schedule_lines  = gt_schedule_lines
          tt_schedule_linesx = gt_schedule_linesx
          tt_conditions_in   = gt_conditions_in
          tt_conditions_inx  = gt_conditions_inx.



      WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.


    ENDIF.

  ENDMETHOD.


  METHOD task_substituir.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
      TABLES
        tt_return          = gt_return_subs
        tt_item            = gt_order_item_in
        tt_itemx           = gt_order_item_inx
        tt_schedule_lines  = gt_schedule_lines
        tt_schedule_linesx = gt_schedule_linesx.

    RETURN.

  ENDMETHOD.


  METHOD task_desconto.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
      TABLES
        tt_return          = gt_return_subs
        tt_item            = gt_order_item_in
        tt_itemx           = gt_order_item_inx
        tt_schedule_lines  = gt_schedule_lines
        tt_schedule_linesx = gt_schedule_linesx
        tt_conditions_in   = gt_conditions_in
        tt_conditions_inx  = gt_conditions_inx.

    RETURN.

  ENDMETHOD.


  METHOD get_a816.

*    SELECT SINGLE knumh
*     INTO rv_knumh
    SELECT  knumh
    INTO TABLE et_knumh86
     FROM a816
     WHERE vtweg = gs_orderheader-distr_chan
       AND werks = iv_centro
       AND matnr = iv_material.

  ENDMETHOD.


  METHOD get_a817.

*    SELECT SINGLE knumh
*     INTO rv_knumh
    SELECT  knumh
     INTO TABLE et_knumh87
     FROM a817
     WHERE vtweg = gs_orderheader-distr_chan
       AND pltyp = iv_pricelisttype
       AND werks = iv_centro
       AND matnr = iv_material.

  ENDMETHOD.


  METHOD get_konp.

    CLEAR: rv_kbetr.

    IF it_knumh[] IS NOT INITIAL.
*    SELECT SINGLE kbetr
*      INTO rv_kbetr
      SELECT kbetr
      INTO TABLE @DATA(lt_kbetr)
      FROM konp
      FOR ALL ENTRIES IN @it_knumh
      WHERE knumh    = @it_knumh-knumh
      AND   loevm_ko = @space.

      IF sy-subrc IS INITIAL.

        rv_kbetr =  lt_kbetr[ 1 ]-kbetr.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_pricing.

    DATA: lv_material TYPE matnr.

    lv_material = VALUE #( gt_orderitems[ itm_number = iv_item ]-material DEFAULT '' ).
    DATA(lv_centro) = VALUE #( gt_orderitems[ itm_number = iv_item ]-plant DEFAULT '' ).
    DATA(lv_pricelisttype) = VALUE #( gt_vbkd[ vbeln = gs_orderheader-doc_number posnr = iv_item ]-pltyp DEFAULT '' ).

    IF lv_pricelisttype IS INITIAL.
      SELECT pricelisttype, salesordercondition
        FROM i_salesorder
       WHERE salesorder     = @iv_order
        INTO @DATA(ls_salesorder)
      UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL.

        lv_pricelisttype   = ls_salesorder-pricelisttype.
        DATA(lv_condition) = ls_salesorder-salesordercondition.

      ENDIF.

    ENDIF.

*    DATA(lv_knumh_old) = get_a817( EXPORTING iv_material = lv_material iv_pricelisttype = lv_pricelisttype iv_centro = lv_centro ).
    DATA(lv_pricing_old) = obter_preco( EXPORTING iv_item = iv_item iv_material = lv_material iv_condition = lv_condition ).

*    DATA(lv_knumh_new87) = get_a817( EXPORTING iv_material = iv_new_material iv_pricelisttype = lv_pricelisttype iv_centro = lv_centro ).
    get_a817( EXPORTING iv_material = iv_new_material iv_pricelisttype = lv_pricelisttype iv_centro = lv_centro
              IMPORTING et_knumh87 = gt_knumh87 ).
    get_a816( EXPORTING iv_material = iv_new_material iv_centro = lv_centro
              IMPORTING et_knumh86 = gt_knumh86 ).


*    IF lv_knumh_old IS INITIAL.
*      lv_knumh_old = get_a816( EXPORTING iv_material = lv_material iv_centro = lv_centro ).
*    ENDIF.

*    IF lv_knumh_new IS INITIAL.
*    DATA(lv_knumh_new86) = get_a816( EXPORTING iv_material = iv_new_material iv_centro = lv_centro ).
*    ENDIF.

*    IF lv_knumh_old IS NOT INITIAL.
*      DATA(lv_pricing_old) = get_konp( lv_knumh_old ).
*    ELSE.
*      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = lv_material type = 'E' ) TO gt_return_subs.
*      rv_return = abap_false.
*      RETURN.
*    ENDIF.

    IF gt_knumh87[] IS NOT INITIAL OR gt_knumh86 IS NOT INITIAL.
*      DATA(lv_pricing_new) = get_konp( lv_knumh_new ).
      DATA(lv_pricing_new) = get_konp( gt_knumh87 ).
      IF lv_pricing_new IS INITIAL.
        lv_pricing_new = get_konp( gt_knumh86 ).
      ENDIF.
    ELSE.
      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = iv_new_material type = 'E' ) TO gt_return_subs.
      rv_return = abap_false.
      RETURN.
    ENDIF.

    IF lv_pricing_old IS INITIAL.
      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = lv_material type = 'E' ) TO gt_return_subs.
      rv_return = abap_false.
      RETURN.
    ENDIF.

    IF lv_pricing_new IS INITIAL.
      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = iv_new_material type = 'E' ) TO gt_return_subs.
      rv_return = abap_false.
      RETURN.
    ENDIF.

    IF lv_pricing_old = lv_pricing_new.
      rv_return = abap_true.
    ELSE.
      rv_return = abap_false.
      DATA(ls_msg_new) = iv_new_material.
      SHIFT ls_msg_new LEFT DELETING LEADING '0'.
      DATA(ls_msg_old) = lv_material.
      SHIFT ls_msg_old LEFT DELETING LEADING '0'.

      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 012 type = 'E' message_v1 = ls_msg_new message_v2 = lv_pricing_new ) TO gt_return_subs.
      APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 013 type = 'E' message_v1 = ls_msg_old message_v2 = lv_pricing_old ) TO gt_return_subs.
    ENDIF.

  ENDMETHOD.


  METHOD get_parametrosub.

    SELECT SINGLE low
    INTO rv_paramsub
    FROM ztca_param_val
    WHERE modulo = 'SD'
      AND chave1 = 'ADM_FATURAMENTO'
      AND chave2 = 'REASON_REJ'
      AND chave3 = 'SUBSTITU'.

  ENDMETHOD.


  METHOD obter_preco.

    SELECT SINGLE kbetr
    FROM   prcd_elements
    INTO  rv_kbetr
    WHERE knumv = iv_condition
    AND   kschl = 'ZPR0'
    AND   kposn = iv_item.

  ENDMETHOD.


  METHOD format_message.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E'
                                THEN 'I'
                                WHEN ls_return->type EQ 'W'
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD get_konp_kmein.

    CLEAR: rv_kmein.

    IF it_knumh[] IS NOT INITIAL.
*    SELECT SINGLE kbetr
*      INTO rv_kbetr
      SELECT kmein
      INTO TABLE @DATA(lt_kmein)
      FROM konp
      FOR ALL ENTRIES IN @it_knumh
      WHERE knumh    = @it_knumh-knumh
      AND   loevm_ko = @space.

      IF sy-subrc IS INITIAL.

        rv_kmein =  lt_kmein[ 1 ]-kmein.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD obter_kmein.

    SELECT SINGLE kmein
    FROM   prcd_elements
    INTO  rv_kmein
    WHERE knumv = iv_condition
    AND   kschl = 'ZPR0'
    AND   kposn = iv_item.

  ENDMETHOD.


  METHOD valida_desconto.

    CONSTANTS: lc_sd     TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_DESCONTO'.

    DATA: lr_kschl TYPE RANGE OF kschl.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    FREE: gt_cond.

    TRY.

        lo_param->m_get_range( EXPORTING iv_modulo = lc_sd
                                         iv_chave1 = lc_chave1
                                         iv_chave2 = lc_chave2
                               IMPORTING et_range  = lr_kschl ).

      CATCH zcxca_tabela_parametros.

        RETURN.

    ENDTRY.

    SELECT SINGLE salesordercondition
    FROM i_salesorder
    WHERE salesorder = @iv_order
    INTO @DATA(lv_cond)
    .
    IF sy-subrc IS INITIAL.

      SELECT kbetr, kschl
      FROM prcd_elements
      INTO TABLE @gt_cond
      WHERE knumv = @lv_cond
      AND   kposn = @iv_item
      AND   kschl IN @lr_kschl.

    ENDIF.

    CLEAR: lv_cond.


  ENDMETHOD.
ENDCLASS.
