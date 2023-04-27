"!<p><h2>ZCLSD_KITS_BONIFICACAO_ORDEM</h2></p>
"! Está classe realiza as ações de criar ordem e estorna ordem do Aplicativo Administrar Bonificação dos kits de venda  <br/>
"! <br/>
"!<p><strong>Autor:</strong> Willian Hazor</p>
"!<p><strong>Data:</strong> 20 de Jan de 2022</p>
CLASS zclsd_kits_bonificacao_ordem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    CONSTANTS:
      gc_modulo_sd       TYPE ze_param_modulo VALUE 'SD',
      gc_chave1_bon_kit  TYPE ze_param_chave  VALUE 'BON_KIT',
      gc_chave1_nfe_kit  TYPE ze_param_chave  VALUE 'NFE_KIT',
      gc_chave2_doc_type TYPE ze_param_chave  VALUE 'DOC_TYPE',
      gc_chave2_text_id  TYPE ze_param_chave  VALUE 'TEXT_ID',
      gc_chave2_abgru    TYPE ze_param_chave  VALUE 'ABGRU',
      gc_msg_classe      TYPE arbgb           VALUE 'ZSD_KIT_BONIFICACAO',
      gc_msg_type_error  TYPE char01          VALUE 'E',
      gc_msg_type_war    TYPE char01          VALUE 'E',
      gc_msg_001         TYPE char03          VALUE '001',
      gc_msg_002         TYPE char03          VALUE '002',
      gc_msg_003         TYPE char03          VALUE '003',
      gc_msg_012         TYPE char03          VALUE '012',
      gc_updateflag_i    TYPE char01          VALUE 'I',
      gc_partner_role_pc TYPE parvw           VALUE 'AG'.

    DATA: gt_return        TYPE TABLE OF bapiret2,
          gv_salesdocument TYPE vbeln_va,
          gv_wait          TYPE char01.

    METHODS:
      "! Criar ordem
      "! @parameter it_data |Nome do usuáio
      "! @parameter ev_salesdocument |Documento de venda
      "! @parameter ET_return |Mensagens
      create_order
        IMPORTING it_data          TYPE zctgsd_kit_bon_app
        EXPORTING
                  ev_salesdocument TYPE vbeln_va
                  et_return        TYPE bapiret2_t,
      recusar_order
        IMPORTING iv_salesodcument TYPE vbeln_va
*                  iv_itm_number    TYPE posnr_va
        EXPORTING
                  et_return        TYPE bapiret2_t.
    METHODS task_finish_est
      IMPORTING
        !p_task TYPE clike.
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .




  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCLSD_KITS_BONIFICACAO_ORDEM IMPLEMENTATION.


  METHOD create_order.


    TYPES: BEGIN OF ty_plant,
             plant TYPE werks_d,
           END OF ty_plant,
           BEGIN OF ty_item,
             plant       TYPE werks_d,
             partn_numb  TYPE kunnr,
             material    TYPE matnr,
             materialkit TYPE matnr,
             target_qty  TYPE dzmeng,
           END OF ty_item.

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
          lt_plan                TYPE TABLE OF ty_plant,
          lt_item                TYPE TABLE OF ty_item,
          ls_item                TYPE ty_item,
          lt_tline               TYPE TABLE OF tline,
          lt_ztsd_kitbon_ctr     TYPE zctgsd_kitbon_ctr.

    SELECT modulo, chave1, chave3, low UP TO 1 ROWS
      FROM ztca_param_val
      INTO @DATA(ls_doc_type)
      WHERE modulo = @gc_modulo_sd
        AND chave1 = @gc_chave1_bon_kit
        AND chave2 = @gc_chave2_doc_type.
    ENDSELECT.

    IF sy-subrc <> 0.
      APPEND VALUE #(
        type = gc_msg_type_error
        id   = gc_msg_classe
        number = gc_msg_001 )  TO et_return. "Parâmetros para Tipo de Documento não configurado
      RETURN.
    ENDIF.

    SELECT *
      FROM ztca_param_val
      INTO TABLE @DATA(lt_param)
      WHERE modulo = @gc_modulo_sd
        AND chave1 = @gc_chave1_bon_kit.

    IF sy-subrc IS INITIAL.
      SORT lt_param BY chave2.
    ENDIF.


*    IF sy-subrc <> 0.
*      APPEND VALUE #(
*        type = gc_msg_type_war
*        id   = gc_msg_classe
*        number = gc_msg_003 )  TO et_return. "Parâmetros para o TEXT_ID não configurado
*    ENDIF.




    LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      APPEND <fs_data>-plant TO lt_plan.
      CLEAR: ls_item.

      ls_item-plant       = <fs_data>-plant.
      ls_item-partn_numb  = <fs_data>-kunnr.
      ls_item-material    = <fs_data>-matnrfree.

      READ TABLE lt_item WITH KEY plant = ls_item-plant
                                  partn_numb = ls_item-partn_numb
                                  material = ls_item-material
                                  INTO DATA(ls_kit).

      IF sy-subrc <> 0.
        ls_item-materialkit = <fs_data>-matnrkit.
      ELSE.
        ls_item-materialkit = ls_kit-materialkit.
      ENDIF.


      ls_item-target_qty  = <fs_data>-quantityinentryunit.
      COLLECT ls_item INTO lt_item.
    ENDLOOP.

    IF  NOT lt_item IS INITIAL.
      SELECT *
        INTO TABLE @DATA(lt_makt)
        FROM makt
        FOR ALL ENTRIES IN @lt_item
        WHERE matnr = @lt_item-materialkit
          AND spras = @sy-langu.

      IF sy-subrc IS INITIAL.
        SORT lt_makt BY matnr.
      ENDIF.
    ENDIF.

    SORT lt_plan. DELETE ADJACENT DUPLICATES FROM lt_plan.

    CHECK lt_plan IS NOT INITIAL.

    SELECT werks, vkorg, vtweg, spart
     FROM t001w
     INTO TABLE @DATA(lt_t001w)
     FOR ALL ENTRIES IN @lt_plan
     WHERE werks = @lt_plan-plant.

    IF sy-subrc <> 0.
      APPEND VALUE #(
        type = gc_msg_type_error
        id   = gc_msg_classe
        number = gc_msg_002 )  TO et_return. "Centro & não localizado
      RETURN.
    ENDIF.


    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item_a>)
        GROUP BY ( plant = <fs_item_a>-plant partn_numb = <fs_item_a>-partn_numb )
            ASCENDING
            ASSIGNING FIELD-SYMBOL(<fs_group>).

      CLEAR: ls_order_header_in, lt_order_items_in, ls_order_header_inx,
      lt_order_items_in, lt_order_items_inx, lt_order_schedules_in, lt_order_schedules_inx, lt_order_text .

      READ TABLE lt_t001w INTO DATA(ls_t001w) WITH KEY werks = <fs_group>-plant BINARY SEARCH.

      IF sy-subrc <> 0.
        APPEND VALUE #(
          type = gc_msg_type_error
          id   = gc_msg_classe
          number = gc_msg_002 )  TO et_return. "Centro & não localizado
        CONTINUE.
      ENDIF.

      ls_order_header_in-doc_type       = ls_doc_type-low.
      ls_order_header_in-sales_org      = ls_t001w-vkorg.
      ls_order_header_in-distr_chan     = ls_t001w-vtweg.
      ls_order_header_in-division       = ls_t001w-spart.

      ls_order_header_inx-updateflag    = gc_updateflag_i.
      ls_order_header_inx-doc_type      =
      ls_order_header_inx-sales_org     =
      ls_order_header_inx-division      =
      ls_order_header_inx-distr_chan    = abap_true.

*      IF ls_text_id-low IS NOT INITIAL.
*        ls_order_text-text_id = ls_text_id-low.
*        APPEND ls_order_text TO lt_order_text.
*      ENDIF.

      ls_order_partners-partn_numb = <fs_group>-partn_numb.
      ls_order_partners-partn_role = gc_partner_role_pc.
      APPEND ls_order_partners TO lt_order_partners.

      CLEAR lt_ztsd_kitbon_ctr.

      LOOP AT GROUP <fs_group> ASSIGNING FIELD-SYMBOL(<fs_item>).


        CLEAR ls_order_items_in.
        ls_order_items_in-itm_number  = sy-tabix * 10.
        ls_order_items_in-material    = <fs_item>-material.
        DATA(lv_material) = <fs_item>-material.
        ls_order_items_in-plant       = <fs_group>-plant.
*        ls_order_items_in-store_loc   = '1006'.
        ls_order_items_in-target_qty  = <fs_item>-target_qty.
        APPEND ls_order_items_in  TO  lt_order_items_in.

        CLEAR ls_order_items_inx.
        ls_order_items_inx-itm_number  = ls_order_items_in-itm_number.
        ls_order_items_inx-material    =
        ls_order_items_inx-plant       =
*        ls_order_items_inx-store_loc   = '1006'.
        ls_order_items_inx-target_qty  = abap_true.
        APPEND ls_order_items_inx  TO  lt_order_items_inx.

        CLEAR ls_order_schedules_in.
        ls_order_schedules_in-itm_number = ls_order_items_in-itm_number.
        ls_order_schedules_in-req_qty    = <fs_item>-target_qty.
        APPEND ls_order_schedules_in TO lt_order_schedules_in.

        CLEAR ls_order_schedules_inx.
        ls_order_schedules_inx-itm_number = ls_order_items_in-itm_number.
        ls_order_schedules_inx-req_qty    = abap_true.
        APPEND ls_order_schedules_inx TO lt_order_schedules_inx.


        LOOP AT it_data ASSIGNING <fs_data>.
          CHECK <fs_data>-plant = <fs_item>-plant
            AND <fs_data>-kunnr = <fs_group>-partn_numb.
          APPEND VALUE #( aufnr = <fs_data>-manufacturingorder
                          ebeln = <fs_data>-PediSubc
                          matnr_kit = <fs_data>-matnrkit
                          matnr_free = <fs_data>-matnrfree
                          dockit     = <fs_data>-dockit
            ) TO lt_ztsd_kitbon_ctr.
        ENDLOOP.

        DATA(lv_name) = CONV tdobname( VALUE tdobname( lt_param[ chave2 = 'NAME' ]-low DEFAULT '' ) ).

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = 'ST'
            language                = sy-langu
            name                    = lv_name
            object                  = 'TEXT'
          TABLES
            lines                   = lt_tline
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc <> 0.
        ENDIF.

        LOOP AT lt_tline ASSIGNING FIELD-SYMBOL(<fs_tline>).

          DATA(lv_descr) = VALUE #( lt_makt[ matnr = <fs_item>-materialkit ]-maktx DEFAULT '' ).

          DATA(lv_material_out)  = |{ <fs_item>-materialkit ALPHA = OUT }|.
          CONDENSE lv_material_out NO-GAPS.

          DATA(lv_mat_descr) = |{ lv_material_out } { lv_descr }| .

          DATA(lv_text) = CONV tdline( <fs_tline>-tdline ).

          REPLACE FIRST OCCURRENCE OF '&' IN lv_text WITH lv_mat_descr.

          APPEND VALUE #(  text_id    = VALUE #( lt_param[ chave2 = 'TEXT_ID' ]-low DEFAULT '' )
                           langu      = sy-langu
                           text_line  = lv_text ) TO lt_order_text.

        ENDLOOP.


      ENDLOOP.

      CLEAR: gt_return, gv_salesdocument.



      gv_wait = abap_true.

      CALL FUNCTION 'ZFMSD_CRIAR_ORDER'
        STARTING NEW TASK 'BACKGROUND' CALLING task_finish_est ON END OF TASK
        EXPORTING
          is_order_header_in     = ls_order_header_in
          it_order_items_in      = lt_order_items_in
          it_order_items_inx     = lt_order_items_inx
          it_order_partners      = lt_order_partners
          it_order_schedules_in  = lt_order_schedules_in
          it_order_schedules_inx = lt_order_schedules_inx
          it_order_text          = lt_order_text
          it_ztsd_kitbon_ctr     = lt_ztsd_kitbon_ctr.

      WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait IS INITIAL.

      LOOP AT gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        IF <fs_return>-type = 'W'.
          <fs_return>-type = 'I'.
        ENDIF.
        APPEND <fs_return> TO et_return.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD task_finish_est.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CRIAR_ORDER'
      IMPORTING
        ev_salesdocument = gv_salesdocument
        et_return        = gt_return.

    CLEAR gv_wait.

    RETURN.
  ENDMETHOD.


  METHOD recusar_order.

    DATA: lv_salesdocument    TYPE vbeln,
          ls_order_header_in  TYPE bapisdh1,
          ls_order_header_inx TYPE bapisdh1x,
          lt_order_item_in    TYPE bapisditm_tt,
          lt_order_item_inx   TYPE bapisditmx_tt.


    SELECT modulo, chave1, low UP TO 1 ROWS
      FROM ztca_param_val
      INTO @DATA(ls_doc_type)
      WHERE modulo = @gc_modulo_sd
        AND chave1 = @gc_chave1_nfe_kit.
    ENDSELECT.

    IF sy-subrc <> 0.
      APPEND VALUE #(
        type = gc_msg_type_error
        id   = gc_msg_classe
        number = gc_msg_001 )  TO et_return. "Parâmetros para Tipo de Documento não configurado
      RETURN.
    ENDIF.

    SELECT modulo, chave1, chave3, low UP TO 1 ROWS
  FROM ztca_param_val
  INTO @DATA(ls_reason_rej)
  WHERE modulo = @gc_modulo_sd
    AND chave1 = @gc_chave1_bon_kit
    AND chave2 = @gc_chave2_abgru.
    ENDSELECT.

    IF sy-subrc <> 0.
      APPEND VALUE #(
        type = gc_msg_type_error
        id   = gc_msg_classe
        number = gc_msg_012 )  TO et_return. "Parâmetros para Motivo de Recusa não configurado
      RETURN.
    ENDIF.

    lv_salesdocument = iv_salesodcument.
    ls_order_header_inx-updateflag = 'U'.

    CLEAR: gt_return.

    SELECT *
        FROM vbap
        INTO TABLE @DATA(lt_vbap)
        WHERE vbeln = @lv_salesdocument.

    IF sy-subrc EQ 0.
      LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
        APPEND VALUE #( itm_number = <fs_vbap>-posnr  reason_rej = ls_reason_rej-low ) TO lt_order_item_in.
        APPEND VALUE #( itm_number = <fs_vbap>-posnr  updateflag = 'U' reason_rej = abap_true  ) TO lt_order_item_inx.
      ENDLOOP.
    ENDIF.

*    APPEND VALUE #( itm_number = ls_doc_type-low  reason_rej = ls_reason_rej-low ) TO lt_order_item_in.

*    APPEND VALUE #( updateflag = 'U' reason_rej = abap_true  ) TO lt_order_item_inx.

    gv_wait = abap_true.

    CALL FUNCTION 'ZFMSD_RECUSAR_ORDEM'
      STARTING NEW TASK 'BACKESTORNO' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_salesdocument    = lv_salesdocument
        is_order_header_in  = ls_order_header_in
        is_order_header_inx = ls_order_header_inx
        it_order_item_in    = lt_order_item_in
        it_order_item_inx   = lt_order_item_inx.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait IS INITIAL.
    APPEND LINES OF gt_return TO et_return.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_RECUSAR_ORDEM'
      IMPORTING
        et_return        = gt_return.

    CLEAR gv_wait.

    RETURN.

  ENDMETHOD.
ENDCLASS.
