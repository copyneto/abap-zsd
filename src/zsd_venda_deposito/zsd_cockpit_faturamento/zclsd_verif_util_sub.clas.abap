CLASS zclsd_verif_util_sub DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_sub_prod TYPE TABLE OF zc_sd_substituir_custom_app .
    TYPES:
      BEGIN OF ty_ordem_cond,
        salesorder          TYPE i_salesorder-salesorder,
        salesorderitem      TYPE i_salesorderitem-salesorderitem,
        pricelisttype       TYPE i_salesorder-pricelisttype,
        salesordercondition TYPE i_salesorder-salesordercondition,
        orderquantityunit   TYPE i_salesorderitem-orderquantityunit,
        plant               TYPE i_salesorderitem-plant,
        material            TYPE i_salesorderitem-material,
      END OF ty_ordem_cond .
    TYPES:
      BEGIN OF ty_item_qtd,
        salesorder        TYPE i_salesorderitem-salesorder,
        salesorderitem    TYPE i_salesorderitem-salesorderitem,
        orderquantityunit TYPE i_salesorderitem-orderquantityunit,
      END OF ty_item_qtd .
    TYPES:
      BEGIN OF ty_salesdocumentitem,
        salesdocument     TYPE i_salesdocumentitem-salesdocument,
        salesdocumentitem TYPE i_salesdocumentitem-salesdocumentitem,
        plant             TYPE i_salesdocumentitem-plant,
        storagelocation   TYPE i_salesdocumentitem-storagelocation,
        targetquantity    TYPE i_salesdocumentitem-targetquantity,
        requestedquantity TYPE i_salesdocumentitem-requestedquantity,
      END OF ty_salesdocumentitem .
    TYPES:
      BEGIN OF ty_knumh,
        vtweg TYPE a817-vtweg,
        werks TYPE a817-werks,
        matnr TYPE a817-matnr,
        kbetr TYPE konp-kbetr,
        pltyp TYPE a817-pltyp,
      END OF ty_knumh .
    TYPES:
      BEGIN OF ty_prcd_elements,
        knumv TYPE prcd_elements-knumv,
        kschl TYPE prcd_elements-kschl,
        kposn TYPE prcd_elements-kposn,
        kbetr TYPE prcd_elements-kbetr,
        kmein TYPE prcd_elements-kmein,
        pltyp TYPE a817-pltyp,
      END OF ty_prcd_elements .
    TYPES:
      BEGIN OF ty_cond,
        knumv TYPE knumv,
        kposn TYPE kposn,
        kbetr TYPE kbetr,
        kschl TYPE kschl,
      END OF ty_cond .

    DATA:
      gt_cond TYPE TABLE OF ty_cond .
    DATA:
     gt_costcenter TYPE TABLE OF zssd_sub_prod_costcenter.
    DATA gv_paramsub TYPE ze_param_low .
    DATA:
      gt_pricing_old TYPE TABLE OF ty_prcd_elements .
    DATA:
      gt_condition TYPE TABLE OF ty_knumh .
    DATA:
      gt_ordem_cond TYPE TABLE OF ty_ordem_cond .
    DATA:
      gt_salesdocumentitem TYPE TABLE OF ty_salesdocumentitem .
    DATA:
      gt_return_subs TYPE STANDARD TABLE OF bapiret2 .
    DATA:
      gt_order_item_in TYPE STANDARD TABLE OF bapisditm .
    DATA:
      gt_order_item_inclui_in TYPE STANDARD TABLE OF bapisditm .
    DATA:
      gt_order_item_desc_in TYPE STANDARD TABLE OF bapisditm .
    DATA:
  gt_order_item_desfaz_in TYPE STANDARD TABLE OF bapisditm .
    DATA:
      gt_order_item_inx TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      gt_order_item_inclui_inx TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      gt_order_item_desc_inx TYPE STANDARD TABLE OF bapisditmx .
    DATA:
  gt_order_item_desfaz_inx TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      gt_schedule_lines  TYPE STANDARD TABLE OF bapischdl .
    DATA:
      gt_schedule_linesx TYPE STANDARD TABLE OF bapischdlx .
    DATA:
      gt_schedule_recusa_lines  TYPE STANDARD TABLE OF bapischdl .
    DATA:
      gt_schedule_recusa_linesx TYPE STANDARD TABLE OF bapischdlx .
    DATA gs_schedule_lines TYPE bapischdl .
    DATA gs_schedule_linesx TYPE bapischdlx .
    DATA:
      gt_conditions_in   TYPE STANDARD TABLE OF bapicond .
    DATA:
      gt_conditions_inx  TYPE STANDARD TABLE OF bapicondx .
    DATA gs_conditions_in TYPE bapicond .
    DATA gs_conditions_inx TYPE bapicondx .

    METHODS substituir_produto
      IMPORTING
        !iv_order           TYPE vbeln_va
        !it_sub_prod        TYPE ty_sub_prod
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    METHODS selection_data
      IMPORTING
        !it_sub_prod TYPE ty_sub_prod .
    METHODS get_parametrosub .
    METHODS task_desconto
      IMPORTING
        !p_task TYPE clike .
    METHODS task_substituir
      IMPORTING
        !p_task TYPE clike .
    METHODS task_recusa
      IMPORTING
        !p_task TYPE clike .
    METHODS task_desfaz_recusa
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
PRIVATE SECTION.

  TYPES:
    ty_lr_kschl TYPE RANGE OF kschl .
  DATA gs_orderheader TYPE bapisdhd .
  DATA gs_order_header_inx TYPE bapisdh1x .
  DATA gs_order_item_in TYPE bapisditm .
  DATA:
    gt_orderitems TYPE STANDARD TABLE OF bapisditbos .
  DATA:
    gt_orderschedulelines TYPE STANDARD TABLE OF bapisdhedu .
  DATA:
    gt_orderconditem TYPE STANDARD TABLE OF bapicondit .
  DATA gt_vbkd TYPE vbkd_t .
  DATA:
    gt_return_desfaz_subs TYPE STANDARD TABLE OF bapiret2 .
  DATA gv_sub_prod TYPE abap_bool VALUE 'X' ##NO_TEXT.

  METHODS get_condition .
  METHODS call_get_details
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS validate_pricing
    IMPORTING
      !is_sub_prod     TYPE zc_sd_substituir_custom_app
    RETURNING
      VALUE(rv_return) TYPE abap_bool .
  METHODS get_a817
    IMPORTING
      !iv_material      TYPE matnr
      !iv_pricelisttype TYPE pltyp
      !iv_centro        TYPE werks_d
    RETURNING
      VALUE(rv_preco)   TYPE kbetr .
  METHODS get_a816
    IMPORTING
      !iv_material    TYPE matnr
      !iv_centro      TYPE werks_d
    RETURNING
      VALUE(rv_preco) TYPE kbetr .
  METHODS recusa_item
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS call_bapi_substituir
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS call_bapi_recusa_item
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS call_bapi_desfaz_recusa_item
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS get_pricing_old .
  METHODS get_salesorder
    IMPORTING
      !it_sub_prod TYPE zclsd_verif_util_sub=>ty_sub_prod .
  METHODS get_vbkd
    IMPORTING
      !it_sub_prod TYPE zclsd_verif_util_sub=>ty_sub_prod .
  METHODS set_itens_recusa
    IMPORTING
      !is_sub_prod TYPE zc_sd_substituir_custom_app .
  METHODS set_itens_desfaz_recusa
    IMPORTING
      !is_sub_prod TYPE zc_sd_substituir_custom_app .
  METHODS set_itens_inclusao
    IMPORTING
      !iv_item     TYPE posnr_va
      !is_sub_prod TYPE zc_sd_substituir_custom_app .
  METHODS set_condition
    IMPORTING
      !iv_item       TYPE posnr_va
      !is_sub_prod   TYPE zc_sd_substituir_custom_app
      !is_ordem_cond TYPE ty_ordem_cond .
  METHODS fill_data_bapi
    IMPORTING
      !it_sub_prod     TYPE zclsd_verif_util_sub=>ty_sub_prod
      !iv_ordem        TYPE vbeln
    RETURNING
      VALUE(rv_return) TYPE abap_bool .
  METHODS clear_tables
    RETURNING
      VALUE(rt_mensagens) TYPE bapiret2_tab .
  METHODS incluir_item
    IMPORTING
      !iv_order TYPE vbeln_va .
  METHODS format_message
    CHANGING
      !ct_return TYPE bapiret2_tab .
  METHODS get_salesdocumentitem
    IMPORTING
      !it_sub_prod TYPE zclsd_verif_util_sub=>ty_sub_prod .
ENDCLASS.



CLASS ZCLSD_VERIF_UTIL_SUB IMPLEMENTATION.


  METHOD validate_pricing.

    READ TABLE gt_ordem_cond ASSIGNING FIELD-SYMBOL(<fs_ordem_cond>) WITH KEY salesorder = is_sub_prod-salesorder salesorderitem = is_sub_prod-salesorderitem BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      READ TABLE gt_pricing_old ASSIGNING FIELD-SYMBOL(<fs_pricing_old>) WITH KEY knumv = <fs_ordem_cond>-salesordercondition
                                                                                  kschl = 'ZPR0'
                                                                                  kposn = is_sub_prod-salesorderitem BINARY SEARCH.

      IF <fs_pricing_old> IS NOT ASSIGNED.
        APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = is_sub_prod-materialatual type = 'E' ) TO gt_return_subs.
        rv_return = abap_false.
        RETURN.
      ENDIF.

      IF is_sub_prod-umpreco <> <fs_pricing_old>-kmein.
        APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 021 message_v1 = is_sub_prod-salesorder message_v2 = is_sub_prod-materialatual message_v3 = is_sub_prod-material  type = 'E' ) TO gt_return_subs.
        rv_return = abap_false.
        RETURN.
      ENDIF.


*****      DATA(lv_pricing_new) = get_a817( EXPORTING iv_material = is_sub_prod-material iv_pricelisttype = <fs_ordem_cond>-pricelisttype iv_centro = <fs_ordem_cond>-plant ).
*****      IF lv_pricing_new IS INITIAL.
*****        lv_pricing_new  = get_a816( EXPORTING iv_material = is_sub_prod-material iv_centro = <fs_ordem_cond>-plant  ).
*****      ENDIF.

      DATA(lv_pricing_new) = is_sub_prod-preco.

      IF lv_pricing_new IS INITIAL.
        APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 007 message_v1 = <fs_ordem_cond>-material type = 'E' ) TO gt_return_subs.
        rv_return = abap_false.
        RETURN.
      ENDIF.


      IF <fs_pricing_old>-kbetr = lv_pricing_new.
        rv_return = abap_true.
      ELSE.
        rv_return = abap_false.
        DATA(ls_msg_new) = is_sub_prod-material.
        SHIFT ls_msg_new LEFT DELETING LEADING '0'.
        DATA(ls_msg_old) = is_sub_prod-materialatual.
        SHIFT ls_msg_old LEFT DELETING LEADING '0'.

        APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 012 type = 'E' message_v1 = ls_msg_new message_v2 = lv_pricing_new ) TO gt_return_subs.
        APPEND VALUE bapiret2( id = 'ZSD_CKPT_FATURAMENTO' number = 013 type = 'E' message_v1 = ls_msg_old message_v2 = <fs_pricing_old>-kbetr ) TO gt_return_subs.
      ENDIF.

      UNASSIGN: <fs_pricing_old>, <fs_ordem_cond>.
    ENDIF.

  ENDMETHOD.


  METHOD task_substituir.
*    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
    TABLES
      tt_return          = gt_return_subs
      tt_item            = gt_order_item_inclui_in
      tt_itemx           = gt_order_item_inclui_inx
      tt_schedule_lines  = gt_schedule_lines
      tt_schedule_linesx = gt_schedule_linesx
      tt_conditions_in   = gt_conditions_in
      tt_conditions_inx  = gt_conditions_inx
      tt_costcenter      = gt_costcenter.

    RETURN.
  ENDMETHOD.


  METHOD task_recusa.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
    TABLES
      tt_return          = gt_return_subs
      tt_item            = gt_order_item_in
      tt_itemx           = gt_order_item_inx
      tt_schedule_lines  = gt_schedule_recusa_lines
      tt_schedule_linesx = gt_schedule_recusa_linesx.

    RETURN.

  ENDMETHOD.


  METHOD task_desfaz_recusa.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
    TABLES
      tt_return          = gt_return_desfaz_subs
      tt_item            = gt_order_item_desfaz_in
      tt_itemx           = gt_order_item_desfaz_inx
      tt_schedule_lines  = gt_schedule_recusa_lines
      tt_schedule_linesx = gt_schedule_recusa_linesx.

    RETURN.

  ENDMETHOD.


  METHOD task_desconto.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
    TABLES
      tt_return          = gt_return_subs
      tt_item            = gt_order_item_desc_in
      tt_itemx           = gt_order_item_desc_inx
      tt_schedule_lines  = gt_schedule_lines
      tt_schedule_linesx = gt_schedule_linesx
      tt_conditions_in   = gt_conditions_in
      tt_conditions_inx  = gt_conditions_inx.

    RETURN.
  ENDMETHOD.


  METHOD substituir_produto.

    rt_mensagens = clear_tables( ).

***    call_get_details( iv_order ).

    DATA(lv_return) = fill_data_bapi( it_sub_prod = it_sub_prod iv_ordem = iv_order ).

    IF gt_return_subs IS NOT INITIAL.
      APPEND LINES OF  gt_return_subs TO rt_mensagens.

      IF  gt_order_item_in IS INITIAL.
        EXIT.
      ENDIF.

    ENDIF.

*    recusa_item( iv_order = iv_order ).
*    APPEND LINES OF gt_return_subs TO rt_mensagens.

    incluir_item( iv_order = iv_order ).
    APPEND LINES OF gt_return_subs TO rt_mensagens.

    DELETE ADJACENT DUPLICATES FROM rt_mensagens COMPARING id type number.

    DATA(lt_msg) = rt_mensagens[].

    me->format_message( CHANGING ct_return = rt_mensagens[] ).



  ENDMETHOD.


  METHOD set_itens_recusa.

    APPEND VALUE #( itm_number = is_sub_prod-salesorderitem
                    reason_rej = gv_paramsub
                  ) TO gt_order_item_in.

    APPEND VALUE #( itm_number  = is_sub_prod-salesorderitem
                     updateflag = 'U'
                     reason_rej = abap_true ) TO gt_order_item_inx.

    gs_order_header_inx-updateflag = 'U'.

  ENDMETHOD.


  METHOD set_itens_desfaz_recusa.

    APPEND VALUE #( itm_number = is_sub_prod-salesorderitem
                    reason_rej = space
                  ) TO gt_order_item_desfaz_in.

    APPEND VALUE #( itm_number  = is_sub_prod-salesorderitem
                     updateflag = 'U'
                     reason_rej = abap_true ) TO gt_order_item_desfaz_inx.

    gs_order_header_inx-updateflag = 'U'.

  ENDMETHOD.


  METHOD set_itens_inclusao.

    APPEND VALUE #( itm_number = is_sub_prod-salesorderitem
                    reason_rej = gv_paramsub ) TO gt_order_item_inclui_in.

    APPEND VALUE #( itm_number  = is_sub_prod-salesorderitem
                     updateflag = 'U'
                     reason_rej = abap_true ) TO  gt_order_item_inclui_inx.

***    READ TABLE gt_orderitems ASSIGNING FIELD-SYMBOL(<fs_orderitems>) WITH KEY itm_number = is_sub_prod-salesorderitem BINARY SEARCH.
    READ TABLE gt_salesdocumentitem ASSIGNING FIELD-SYMBOL(<fs_salesdocumentitem>) WITH KEY salesdocument = is_sub_prod-salesorder salesdocumentitem = is_sub_prod-salesorderitem BINARY SEARCH.
    IF sy-subrc = 0.
      READ TABLE gt_ordem_cond ASSIGNING FIELD-SYMBOL(<fs_ordem_cond>) WITH KEY salesorder = is_sub_prod-salesorder salesorderitem = is_sub_prod-salesorderitem BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        APPEND VALUE #(  itm_number = iv_item
                         material   = is_sub_prod-material
***                         plant      = <fs_orderitems>-plant
                         plant      = <fs_salesdocumentitem>-plant
***                         target_qty = <fs_orderitems>-target_qty
                         store_loc  = <fs_salesdocumentitem>-storagelocation
                         target_qty = <fs_salesdocumentitem>-targetquantity
                         sales_unit = <fs_ordem_cond>-orderquantityunit ) TO gt_order_item_inclui_in.

        APPEND VALUE #( vbeln     = is_sub_prod-salesorder
                        posnr     = is_sub_prod-salesorderitem
                        posnr_new = iv_item  ) TO gt_costcenter.

*        APPEND VALUE #(  itm_number = iv_item
*                         material   = is_sub_prod-material
*                         plant      = <fs_orderitems>-plant
*                         target_qty = abap_false
*                         sales_unit = <fs_ordem_cond>-orderquantityunit ) TO gt_order_item_desc_in.

        set_condition( iv_item = iv_item  is_sub_prod = is_sub_prod  is_ordem_cond = <fs_ordem_cond> ).

        APPEND VALUE #( itm_number  = iv_item
                        req_qty     = <fs_salesdocumentitem>-requestedquantity ) TO gt_schedule_lines.

        APPEND VALUE #( itm_number = iv_item
                        updateflag = 'I'
                        req_qty    = 'X' ) TO gt_schedule_linesx.

      ENDIF.
    ENDIF.

***    READ TABLE gt_orderschedulelines ASSIGNING FIELD-SYMBOL(<fs_orderschedulelines>) WITH KEY itm_number = is_sub_prod-salesorderitem BINARY SEARCH.
***    IF sy-subrc = 0.
***      APPEND VALUE #( itm_number  = iv_item
***                      req_qty     = <fs_orderschedulelines>-req_qty ) TO gt_schedule_lines.
***
***      APPEND VALUE #( itm_number = iv_item
***                      updateflag = 'I'
***                      req_qty    = 'X' ) TO gt_schedule_linesx.
***
***    ENDIF.


    APPEND VALUE #( itm_number  = iv_item
                    updateflag  = 'I'
                    material    = 'X'
                    plant       = 'X'
                    store_loc   = 'X'
                    target_qty  = 'X'
                    sales_unit  = 'X') TO gt_order_item_inclui_inx.

*    APPEND VALUE #( itm_number  = iv_item
*                    updateflag  = 'U'
*                    material    = 'X'
*                    plant       = 'X'
*                    target_qty  = ' '
*                    sales_unit  = 'X') TO gt_order_item_desc_inx.

    gs_order_header_inx-updateflag = 'U'.

***    UNASSIGN: <fs_orderitems>, <fs_orderschedulelines>, <fs_ordem_cond>.
    UNASSIGN: <fs_salesdocumentitem>, <fs_ordem_cond>.

  ENDMETHOD.


  METHOD set_condition.

    READ TABLE gt_cond TRANSPORTING NO FIELDS WITH KEY knumv = is_ordem_cond-salesordercondition
                                                       kposn = is_sub_prod-salesorderitem  BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      LOOP AT gt_cond ASSIGNING FIELD-SYMBOL(<fs_cond>) FROM sy-tabix.
        IF <fs_cond>-knumv = is_ordem_cond-salesordercondition
       AND <fs_cond>-kposn = is_sub_prod-salesorderitem.

          APPEND VALUE #( cond_type   = <fs_cond>-kschl
                          cond_value  = <fs_cond>-kbetr / 10
                          itm_number  = iv_item ) TO gt_conditions_in.

          APPEND VALUE #( cond_type  = <fs_cond>-kschl
                          cond_value = 'X'
                          itm_number = iv_item
                          updateflag = 'I' ) TO gt_conditions_inx.
        ELSE.
          EXIT.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD selection_data.

    IF it_sub_prod IS NOT INITIAL.

      get_parametrosub( ).

*      get_vbkd( it_sub_prod ).

      get_salesorder( it_sub_prod ).
      get_salesdocumentitem( it_sub_prod ).

      IF gt_ordem_cond IS NOT INITIAL.
        get_condition( ).
        get_pricing_old( ).
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD recusa_item.

    call_bapi_recusa_item( iv_order = iv_order ).

  ENDMETHOD.


  METHOD incluir_item.
    call_bapi_substituir( iv_order = iv_order ).
  ENDMETHOD.


  METHOD get_vbkd.

    IF it_sub_prod IS NOT INITIAL.
      SELECT *
        INTO TABLE gt_vbkd
        FROM vbkd
        FOR ALL ENTRIES IN it_sub_prod
        WHERE vbeln = it_sub_prod-salesorder
          AND posnr = it_sub_prod-salesorderitem.
      IF sy-subrc IS INITIAL.
        SORT: gt_vbkd BY vbeln posnr.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_salesorder.

    IF it_sub_prod IS NOT INITIAL.
      SELECT a~salesorder, b~salesorderitem, a~pricelisttype, a~salesordercondition,
             b~orderquantityunit, b~plant, b~material
       FROM i_salesorder AS a
        INNER JOIN i_salesorderitem AS b
        ON b~salesorder = a~salesorder
       INTO TABLE @gt_ordem_cond
       FOR ALL ENTRIES IN @it_sub_prod
      WHERE a~salesorder = @it_sub_prod-salesorder.

      IF sy-subrc IS INITIAL.
        SORT: gt_ordem_cond BY salesorder salesorderitem.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_pricing_old.

    IF gt_ordem_cond IS NOT INITIAL.
      SELECT knumv,kschl, kposn, kbetr, kmein
      FROM   prcd_elements
      INTO TABLE  @gt_pricing_old
        FOR ALL ENTRIES IN @gt_ordem_cond
      WHERE knumv = @gt_ordem_cond-salesordercondition
      AND   kschl = 'ZPR0'
      AND   kposn = @gt_ordem_cond-salesorderitem.

      IF gt_pricing_old IS NOT INITIAL.
        SORT gt_pricing_old BY knumv kschl kposn kbetr.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_parametrosub.
    SELECT SINGLE low
INTO gv_paramsub
FROM ztca_param_val
WHERE modulo = 'SD'
  AND chave1 = 'ADM_FATURAMENTO'
  AND chave2 = 'REASON_REJ'
  AND chave3 = 'SUBSTITU'.
  ENDMETHOD.


  METHOD get_condition.

    CONSTANTS: lc_sd     TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_DESCONTO'.

    DATA: lr_kschl TYPE RANGE OF kschl.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.

        lo_param->m_get_range( EXPORTING iv_modulo = lc_sd
                                         iv_chave1 = lc_chave1
                                         iv_chave2 = lc_chave2
                               IMPORTING et_range  = lr_kschl ).

      CATCH zcxca_tabela_parametros.

        RETURN.

    ENDTRY.

    IF gt_ordem_cond IS NOT INITIAL.
      SELECT knumv, kposn, kbetr, kschl
      FROM prcd_elements
      INTO TABLE @gt_cond
      FOR ALL ENTRIES IN @gt_ordem_cond
      WHERE knumv = @gt_ordem_cond-salesordercondition
      AND   kposn = @gt_ordem_cond-salesorderitem
      AND   kschl IN @lr_kschl.

      IF sy-subrc = 0.
        SORT gt_cond BY knumv kposn.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_a817.

    SELECT SINGLE b~kbetr
     INTO @rv_preco
     FROM a817 AS a
      INNER JOIN konp AS b
      ON b~knumh = a~knumh
       WHERE a~kappl    = 'V'
         AND a~kschl    = 'ZPR0'
         AND a~vtweg    = @gs_orderheader-distr_chan
         AND a~pltyp    = @iv_pricelisttype
         AND a~werks    = @iv_centro
         AND a~matnr    = @iv_material
         AND b~loevm_ko = @space.

  ENDMETHOD.


  METHOD get_a816.

    SELECT SINGLE b~kbetr
 INTO @rv_preco
 FROM a816 AS a
  INNER JOIN konp AS b
  ON b~knumh = a~knumh
   WHERE a~kappl    = 'V'
     AND a~kschl    = 'ZPR0'
     AND a~vtweg    = @gs_orderheader-distr_chan
     AND a~werks    = @iv_centro
     AND a~matnr    = @iv_material
     AND b~loevm_ko = @space.

  ENDMETHOD.


  METHOD format_message.
    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    SORT ct_return BY type id number.
    DELETE ADJACENT DUPLICATES FROM ct_return COMPARING type id number.
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


  METHOD fill_data_bapi.

    SELECT MAX( salesorderitem )
    FROM i_salesorderitem
    INTO @DATA(lv_item)
    WHERE salesorder = @iv_ordem.

    READ TABLE it_sub_prod TRANSPORTING NO FIELDS WITH KEY salesorder = iv_ordem.
    IF sy-subrc = 0.

      LOOP AT it_sub_prod ASSIGNING FIELD-SYMBOL(<fs_sub_prod>) FROM sy-tabix.

        IF  <fs_sub_prod>-salesorder = iv_ordem.

          CLEAR: rv_return.

          IF <fs_sub_prod>-classedoc NE 'M'.
            rv_return  = validate_pricing( EXPORTING  is_sub_prod = <fs_sub_prod> ).
          ENDIF.

          IF rv_return = abap_true OR <fs_sub_prod>-classedoc EQ 'M'.

*            set_itens_recusa( <fs_sub_prod> ).

*            set_itens_desfaz_recusa( <fs_sub_prod> ).

            lv_item = lv_item + 10.

            set_itens_inclusao( iv_item = lv_item  is_sub_prod = <fs_sub_prod> ).

          ENDIF.

        ELSE.
          EXIT.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD clear_tables.

    CLEAR: rt_mensagens[], gt_return_subs[], gt_order_item_inx[],  gt_order_item_in[],
    gt_order_item_inclui_inx[],  gt_order_item_inclui_in[], gt_return_subs[],
    gt_conditions_in[], gt_conditions_inx[], gs_orderheader, gt_orderitems[], gt_orderschedulelines[],
    gt_orderconditem[], gt_schedule_recusa_lines[], gt_schedule_recusa_linesx[], gt_order_item_inclui_in[],
    gt_order_item_inclui_inx[], gt_order_item_desc_in[], gt_order_item_desc_inx[], gt_order_item_desfaz_in[],
    gt_order_item_desfaz_inx[], gt_schedule_lines[], gt_schedule_linesx[].


  ENDMETHOD.


  METHOD call_get_details.

    "O Import será feito dentro da pricing para que nãao haja um recalculo
    EXPORT gv_sub_prod FROM gv_sub_prod TO MEMORY ID 'ZSD_SUB_PROD'.

    CALL FUNCTION 'BAPI_SALESORDER_GETDETAILBOS'
      EXPORTING
        salesdocument      = iv_order
      IMPORTING
        orderheader        = gs_orderheader
      TABLES
        orderitems         = gt_orderitems
        orderschedulelines = gt_orderschedulelines
        orderconditem      = gt_orderconditem.

    SORT gt_orderitems         BY itm_number.
    SORT gt_orderschedulelines BY itm_number.

  ENDMETHOD.


  METHOD call_bapi_substituir.

    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA lv_order TYPE  vbeln_va.
    DATA ls_orderx TYPE  bapisdh1x.

    IF  NOT line_exists( gt_return_subs[ type = 'E' ] ).

      CLEAR gt_return_subs.
      lv_order = iv_order.
      ls_orderx  = gs_order_header_inx.

      FREE: gt_return_subs.

*      CALL FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
      CALL FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
        STARTING NEW TASK 'SUBSTITUIR' CALLING task_substituir ON END OF TASK
        EXPORTING
          iv_order           = lv_order
          is_orderx          = ls_orderx
        TABLES
          tt_return          = lt_return
          tt_item            = gt_order_item_inclui_in
          tt_itemx           = gt_order_item_inclui_inx
          tt_schedule_lines  = gt_schedule_lines
          tt_schedule_linesx = gt_schedule_linesx
          tt_conditions_in   = gt_conditions_in
          tt_conditions_inx  = gt_conditions_inx
          tt_costcenter      = gt_costcenter.

      WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_return_subs IS NOT INITIAL.

*
*      IF  NOT line_exists( gt_return_subs[ type = 'E' ] ).
*
*        FREE:  gt_schedule_lines, gt_schedule_linesx.
*
*        CALL FUNCTION 'ZFMSD_SUBSTITUIR_DESCONTO'
*          STARTING NEW TASK 'DESCONTO' CALLING task_desconto ON END OF TASK
*          EXPORTING
*            iv_order           = lv_order
*            is_orderx          = ls_orderx
*          TABLES
*            tt_return          = lt_return
*            tt_item            = gt_order_item_desc_in
*            tt_itemx           = gt_order_item_desc_inx
*            tt_schedule_lines  = gt_schedule_lines
*            tt_schedule_linesx = gt_schedule_linesx
*            tt_conditions_in   = gt_conditions_in
*            tt_conditions_inx  = gt_conditions_inx.
*
*        WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.
*      ELSE.

*      IF line_exists( gt_return_subs[ type = 'E' ] ).
*
*        call_bapi_desfaz_recusa_item( iv_order = iv_order ).
*
*      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_desfaz_recusa_item.

    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA lv_order TYPE  vbeln_va.
    DATA ls_orderx TYPE  bapisdh1x.

    lv_order   = iv_order.
    ls_orderx  = gs_order_header_inx.

    CALL FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
      STARTING NEW TASK 'RECUSA' CALLING task_desfaz_recusa ON END OF TASK
      EXPORTING
        iv_order           = lv_order
        is_orderx          = ls_orderx
      TABLES
        tt_return          = lt_return
        tt_item            = gt_order_item_desfaz_in
        tt_itemx           = gt_order_item_desfaz_inx
        tt_schedule_lines  = gt_schedule_recusa_lines
        tt_schedule_linesx = gt_schedule_recusa_linesx.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

  ENDMETHOD.


  METHOD call_bapi_recusa_item.

    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA lv_order TYPE  vbeln_va.
    DATA ls_orderx TYPE  bapisdh1x.

    lv_order = iv_order.
    ls_orderx  = gs_order_header_inx.

    FREE: gt_return_subs.

    CALL FUNCTION 'ZFMSD_SUBSTITUIR_PRODUTO'
      STARTING NEW TASK 'RECUSA' CALLING task_recusa ON END OF TASK
      EXPORTING
        iv_order           = lv_order
        is_orderx          = ls_orderx
      TABLES
        tt_return          = lt_return
        tt_item            = gt_order_item_in
        tt_itemx           = gt_order_item_inx
        tt_schedule_lines  = gt_schedule_recusa_lines
        tt_schedule_linesx = gt_schedule_recusa_linesx.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_return_subs IS NOT INITIAL.

  ENDMETHOD.


  METHOD get_salesdocumentitem.

    IF NOT it_sub_prod IS INITIAL.
      SELECT salesdocument, salesdocumentitem, plant, storagelocation, targetquantity, requestedquantity
        FROM i_salesdocumentitem
        INTO TABLE @gt_salesdocumentitem
        FOR ALL ENTRIES IN @it_sub_prod
        WHERE salesdocument = @it_sub_prod-salesorder.
      IF sy-subrc IS INITIAL.
        SORT gt_salesdocumentitem BY salesdocument salesdocumentitem.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
