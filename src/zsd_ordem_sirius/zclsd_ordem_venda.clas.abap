CLASS zclsd_ordem_venda DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: tt_vbap     TYPE TABLE OF vbap,
           tt_param_ov TYPE RANGE OF char4.

    METHODS:

      "! Processing start interface( Sales order - create ) - IN
      execute_in
        IMPORTING
          is_sirius TYPE zclsd_mt_criacao_ordem_venda
        RAISING
          zcxmm_erro_interface_mes,

      "! Processing start interface( Sales order - create Sirius ) - OUT
      execute_out
        IMPORTING
          is_vbak TYPE vbak
          is_vbkd TYPE vbkd
          it_vbap TYPE tt_vbap,

      "! Processing start interface( Sales order - Change ) - IN
      execute_change
        IMPORTING
          is_sirius TYPE zclsd_mt_alterar_ordem_venda_i
        RAISING
          zcxmm_erro_interface_mes.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: tt_order_items_inx      TYPE TABLE OF bapisditmx,
           tt_order_items_in       TYPE TABLE OF bapisditm,
           tt_order_schedules_inx  TYPE TABLE OF bapischdlx WITH DEFAULT KEY,
           tt_order_schedules_in   TYPE TABLE OF bapischdl,
           tt_order_conditions_inx TYPE TABLE OF bapicondx,
           tt_order_conditions_in  TYPE TABLE OF bapicond,
           tt_order_text           TYPE TABLE OF bapisdtext,
           tt_extension            TYPE TABLE OF bapiparex,
           tt_partner              TYPE TABLE OF bapiparnr,
           tt_item                 TYPE STANDARD TABLE OF zclsd_dt_ordem_venda_sap_siri1 WITH DEFAULT KEY,
           tt_ret                  TYPE TABLE OF bapiret2,
           tt_schedule             TYPE TABLE OF bapischdl WITH DEFAULT KEY,
           tt_schedulex            TYPE TABLE OF bapischdlx.

    CONSTANTS: gc_erro TYPE bapi_mtype  VALUE 'E'.

    DATA: gs_sirius   TYPE zclsd_mt_criacao_ordem_venda,
          gs_sirius_c TYPE zclsd_mt_alterar_ordem_venda_i,
          gs_vbak     TYPE vbak,
          gs_vbkd     TYPE vbkd,
          gt_vbap     TYPE tt_vbap.

    METHODS:

      "! Get data from tables
      get_data,

      "! Get data from table KNVV
      activity_sector,

      bapi
        RAISING
          zcxmm_erro_interface_mes,

      "! Fill data in item structure
      fill_item
        EXPORTING
          et_item  TYPE tt_order_items_in
          et_itemx TYPE tt_order_items_inx,

      "! Fill data in schedules structure
      fill_schedules
        EXPORTING
          et_schedules  TYPE tt_order_schedules_in
          et_schedulesx TYPE tt_order_schedules_inx,

      "! Fill data in condition structure
      fill_conditions
        EXPORTING
          et_conditions  TYPE tt_order_conditions_in
          et_conditionsx TYPE tt_order_conditions_inx,

      "! Fill data in extension structure
      extension
        EXPORTING
          et_extensionin TYPE tt_extension,

      "! Raising erro
      erro
        IMPORTING
          is_erro TYPE scx_t100key
        RAISING
          zcxmm_erro_interface_mes,

      "! Fill data item
      get_item_data,

      "! Send data to Sirius
      send_sirius
        IMPORTING
          is_ret TYPE zclsd_mt_ordem_venda_sap_siriu,

      "! Send the return of 'BAPI_SALESORDER_CREATEFROMDAT2'
      send_doc
        IMPORTING
          iv_doc    TYPE bapivbeln-vbeln
          it_return TYPE tt_ret,

      "! Fill data text
      fill_text
        EXPORTING
          et_text TYPE tt_order_text,

      "! Fill data partner
      fill_partner
        EXPORTING
          et_partner TYPE tt_partner,

      "! Fill data header
      fill_header
        EXPORTING
          es_header TYPE bapisdhd1,

      "! Fill structures changes to bapi 'BAPI_SALESORDER_CHANGE'
      fill_change
        RAISING
          zcxmm_erro_interface_mes,

      header_change
        EXPORTING
          es_header  TYPE bapisdh1
          es_headerx TYPE bapisdh1x,

      item_change
        EXPORTING
          et_item  TYPE tt_schedule
          et_itemx TYPE tt_schedulex,

      "! Execute bapi 'BAPI_SALESORDER_CHANGE'
      bapi_change
        IMPORTING
          is_header    TYPE bapisdh1
          is_headerx   TYPE bapisdh1x
          it_schedule  TYPE tt_schedule
          it_schedulex TYPE tt_schedulex
        RAISING
          zcxmm_erro_interface_mes,

      bapi_commit.

ENDCLASS.



CLASS ZCLSD_ORDEM_VENDA IMPLEMENTATION.


  METHOD execute_in.

    gs_sirius = is_sirius.

    me->get_data(  ).
    me->bapi(  ).

  ENDMETHOD.


  METHOD get_data.

*    me->field_store_loc(  ).
    me->activity_sector(  ).

  ENDMETHOD.


  METHOD activity_sector.

    DATA(lv_kunnr) = VALUE #( gs_sirius-mt_criacao_ordem_venda-order_partners[ 1 ]-partn_numb OPTIONAL ).

    IF lv_kunnr IS NOT INITIAL.

      SELECT SINGLE spart, vkgrp, vkbur FROM knvv
     INTO ( @gs_sirius-mt_criacao_ordem_venda-order_header_in-division , @gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_grp , @gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_off )
      WHERE kunnr = @lv_kunnr
        AND vkorg = @gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_org
        AND vtweg = @gs_sirius-mt_criacao_ordem_venda-order_header_in-distr_chan.

    ENDIF.

  ENDMETHOD.


  METHOD bapi.

    DATA: lv_doc    TYPE bapivbeln-vbeln,
          lt_return TYPE TABLE OF bapiret2.

***    DATA: ls_logic_switch     TYPE bapisdls,
***          ls_order_header_inx TYPE bapisdh1x.


    me->fill_header( IMPORTING es_header = DATA(ls_header) ).

    me->fill_item( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).

    me->fill_partner( IMPORTING et_partner = DATA(lt_partner) ).

    me->fill_schedules( IMPORTING et_schedules = DATA(lt_schedules) et_schedulesx = DATA(lt_schedulesx) ).

    me->fill_conditions( IMPORTING et_conditions = DATA(lt_conditions) et_conditionsx =  DATA(lt_conditionsx) ).

    me->fill_text( IMPORTING et_text = DATA(lt_text) ).

    me->extension( IMPORTING et_extensionin =  DATA(lt_extension) ).

    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2' ##COMPATIBLE
      EXPORTING
        order_header_in      = ls_header
***        logic_switch         = ls_logic_switch
      IMPORTING
        salesdocument        = lv_doc
      TABLES
        return               = lt_return
        order_items_in       = lt_item
        order_items_inx      = lt_itemx
        order_partners       = lt_partner
        order_schedules_in   = lt_schedules
        order_schedules_inx  = lt_schedulesx
        order_conditions_in  = lt_conditions
        order_conditions_inx = lt_conditionsx
        order_text           = lt_text
        extensionin          = lt_extension
      EXCEPTIONS
        error_message        = 1
        OTHERS               = 2.

    IF sy-subrc EQ 0 .

      me->bapi_commit(  ).

    ENDIF.

    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WITH KEY type = 'E'
                                                                      number = '384'.
    IF sy-subrc EQ 0.
      TRY.
          DATA(lv_matnr) = lt_item[ itm_number = <fs_return>-message_v2 ]-material.
          <fs_return>-message = |{ <fs_return>-message } { TEXT-001 } { lv_matnr }|.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.
    ENDIF.

    me->send_doc( EXPORTING iv_doc = lv_doc it_return = lt_return ).

********************************************

***    IF NOT lv_doc IS INITIAL.
***
***      ls_order_header_inx-updateflag  = 'U'.
***      ls_logic_switch-pricing         = 'C'.
***
***      CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
***        EXPORTING
***          salesdocument    = lv_doc
***          order_header_inx = ls_order_header_inx
***          logic_switch     = ls_logic_switch
***        TABLES
***          return           = lt_return.
***
***      IF line_exists( lt_return[ type = 'S' ] ).
***        me->bapi_commit(  ).
***      ENDIF.
***
***    ENDIF.

********************************************

  ENDMETHOD.


  METHOD fill_item.

    DATA: lv_matnr       TYPE matnr18,
          lv_matnr_out   TYPE matnr18,
          lt_arq_ordvend TYPE TABLE OF ztsd_arq_ordvend.

    TRY.
        DATA(lv_partn_numb) = gs_sirius-mt_criacao_ordem_venda-order_partners[ partn_role = 'AG' ]-partn_numb.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

    LOOP AT gs_sirius-mt_criacao_ordem_venda-order_items_in ASSIGNING FIELD-SYMBOL(<fs_item>).

      lv_matnr = <fs_item>-material.

      UNPACK lv_matnr  TO lv_matnr.

      et_item = VALUE #( BASE et_item (
        itm_number = <fs_item>-itm_number
        material   = lv_matnr
        plant      = <fs_item>-plant
        store_loc  = <fs_item>-store_loc
        target_qty = <fs_item>-target_qty
        target_qu  = <fs_item>-target_qu
        sales_unit = <fs_item>-target_qu
       ) ).


      et_itemx = VALUE #( BASE et_itemx (
        itm_number = <fs_item>-itm_number
        material   = abap_true
        plant      = abap_true
        store_loc  = abap_true
        target_qty = abap_true
        target_qu  = abap_true
        sales_unit = abap_true
       ) ).

      TRY.
          DATA(lv_cond_value) = gs_sirius-mt_criacao_ordem_venda-order_conditions_in[ itm_number = <fs_item>-itm_number
                                                                                      cond_type = 'ZPR0' ]-cond_value.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      lv_matnr_out = |{ lv_matnr ALPHA = OUT }|.

      APPEND VALUE #(
                   numclient       = lv_partn_numb
                   plant           = <fs_item>-plant
                   deposit         = <fs_item>-store_loc
                   refclient       = gs_sirius-mt_criacao_ordem_venda-order_header_in-purch_no_c
                   material        = lv_matnr_out
                   quantity        = <fs_item>-target_qty
                   cond_value      = lv_cond_value
                   costcenter      = <fs_item>-costcenter
                   salesunit       = <fs_item>-target_qu
                   created_by      = sy-uname
                   created_at      = sy-uzeit
                   last_changed_by = sy-uname
                   last_changed_at = sy-uzeit ) TO lt_arq_ordvend.

    ENDLOOP.

    IF NOT lt_arq_ordvend IS INITIAL.
      MODIFY ztsd_arq_ordvend FROM TABLE lt_arq_ordvend.
      IF sy-subrc EQ 0.
        CALL FUNCTION 'DB_COMMIT'.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD fill_schedules.

    IF gs_sirius-mt_criacao_ordem_venda-order_schedules_in IS NOT INITIAL.

      et_schedules = VALUE tt_schedule( FOR ls_sched IN gs_sirius-mt_criacao_ordem_venda-order_schedules_in (
                                        itm_number = ls_sched-itm_number
                                        req_qty    = ls_sched-req_qty
                                       ) ).

    ELSE.

      et_schedules = VALUE tt_schedule( FOR ls_item IN gs_sirius-mt_criacao_ordem_venda-order_items_in (
                                        itm_number = ls_item-itm_number
                                        req_qty    = ls_item-target_qty
                                       ) ).

    ENDIF.

    et_schedulesx = VALUE tt_order_schedules_inx( FOR ls_sched2 IN et_schedules (
      itm_number  = ls_sched2-itm_number
      req_qty     = abap_true
     ) ).

  ENDMETHOD.


  METHOD fill_conditions.

    DATA: lt_param     TYPE tt_param_ov,
          lt_regio     TYPE RANGE OF regio,
          lt_cond_type TYPE RANGE OF kscha.

    CONSTANTS: BEGIN OF lc_param,
                 modulo TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1 TYPE ztca_param_par-chave1 VALUE 'SIRIUS',
                 chave2 TYPE ztca_param_par-chave2 VALUE 'DESC_INCOND',
                 chave3 TYPE ztca_param_par-chave3 VALUE 'TIPO_OV',
               END OF lc_param.

    TRY.
        zclca_tabela_parametros=>get_instance( )->m_get_range( " CHANGE - LSCHEPP - 24.07.2023
            EXPORTING
                iv_modulo = 'SD'
                iv_chave1 = 'SIRIUS'
                iv_chave2 = 'TIPO_OV'
                iv_chave3 = 'COND'
            IMPORTING
                et_range = lt_param

             ).
      CATCH  zcxca_tabela_parametros.
        RETURN.
    ENDTRY.

    TRY.
        NEW zclca_tabela_parametros(  )->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                                                iv_chave1 = lc_param-chave1
                                                                iv_chave2 = lc_param-chave2
                                                      IMPORTING et_range  = lt_regio ).
        TRY.
            DATA(lv_part_numb) = gs_sirius-mt_criacao_ordem_venda-order_partners[ partn_role = 'AG' ]-partn_numb.
            SELECT SINGLE regio
              FROM kna1
              INTO @DATA(lv_regio)
              WHERE kunnr = @lv_part_numb.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    TRY.
        NEW zclca_tabela_parametros(  )->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                                                iv_chave1 = lc_param-chave1
                                                                iv_chave2 = lc_param-chave2
                                                                iv_chave3 = lc_param-chave3
                                                      IMPORTING et_range  = lt_cond_type ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    LOOP AT gs_sirius-mt_criacao_ordem_venda-order_conditions_in ASSIGNING FIELD-SYMBOL(<fs_conditions>).

      CHECK line_exists( lt_param[ low = <fs_conditions>-cond_type ] ).

      IF lv_regio IN lt_regio AND
         <fs_conditions>-cond_type IN lt_cond_type.
        DATA(lv_cond_type) = 'ZBOS'.
        READ TABLE gs_sirius-mt_criacao_ordem_venda-order_items_in ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY itm_number = <fs_conditions>-itm_number.
        IF sy-subrc EQ 0.
          DATA(lv_cond_unit) = CONV kpein( <fs_item>-target_qty ).
          IF NOT lv_cond_unit IS INITIAL.
            DATA(lv_cond_unitx) = abap_true.
          ENDIF.
          DATA(lv_target_qu) = <fs_item>-target_qu.
          IF NOT lv_target_qu IS INITIAL.
            DATA(lv_target_qux) = abap_true.
          ENDIF.
        ENDIF.
      ELSE.
        IF <fs_conditions>-cond_type EQ 'ZBON'.
          lv_cond_type = 'ZBON'.
          READ TABLE gs_sirius-mt_criacao_ordem_venda-order_items_in ASSIGNING <fs_item> WITH KEY itm_number = <fs_conditions>-itm_number.
          IF sy-subrc EQ 0.
            lv_cond_unit = CONV kpein( <fs_item>-target_qty ).
            IF NOT lv_cond_unit IS INITIAL.
              lv_cond_unitx = abap_true.
            ENDIF.
            lv_target_qu = <fs_item>-target_qu.
            IF NOT lv_target_qu IS INITIAL.
              lv_target_qux = abap_true.
            ENDIF.
          ENDIF.
        ELSE.
          lv_cond_type = <fs_conditions>-cond_type.
        ENDIF.

      ENDIF.

      et_conditions = VALUE #( BASE et_conditions (
        itm_number = <fs_conditions>-itm_number
        cond_count = '01'
        cond_type  = lv_cond_type
        cond_value = <fs_conditions>-cond_value
        currency   = <fs_conditions>-currency
        cond_unit  = lv_target_qu
        cond_p_unt = lv_cond_unit
       ) ).

      et_conditionsx = VALUE #( BASE et_conditionsx (
        itm_number = <fs_conditions>-itm_number
        cond_count = '01'
        cond_type  = lv_cond_type
        cond_value = abap_true
        currency   = abap_true
        cond_unit  = lv_target_qux
        cond_p_unt = lv_cond_unitx
       ) ).

      CLEAR: lv_cond_unit,
             lv_target_qu,
             lv_cond_unitx,
             lv_target_qux.

    ENDLOOP.

  ENDMETHOD.


  METHOD extension.
    DATA ls_salesorderdoc_ext TYPE bape_sdsalesdoc.

    "//set additional fields - extensibility
    ls_salesorderdoc_ext-key                = gs_sirius-mt_criacao_ordem_venda-order_header_in-ref_1.
    ls_salesorderdoc_ext-data-zz1_qtde_sdh  = gs_sirius-mt_criacao_ordem_venda-order_header_in-qtd_volumes.
    ls_salesorderdoc_ext-datax-zz1_qtde_sdh = abap_true.

    TRY.
        cl_cfd_bapi_mapping=>get_instance( )->map_to_bapiparex_single(
        EXPORTING
          ir_source_structure = REF #( ls_salesorderdoc_ext )
        CHANGING
          ct_bapiparex = et_extensionin ).
      CATCH cx_cfd_bapi_mapping INTO DATA(lx_cfd).
    ENDTRY.
    "//-

    IF gs_sirius-mt_criacao_ordem_venda-extensionin IS NOT INITIAL.
      et_extensionin = VALUE #( BASE et_extensionin ( structure = gs_sirius-mt_criacao_ordem_venda-extensionin-structure ) ).
    ENDIF.

  ENDMETHOD.


  METHOD erro.

    RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
      EXPORTING
        textid = is_erro.

  ENDMETHOD.


  METHOD execute_out.

    gs_vbak = is_vbak.
    gs_vbkd = is_vbkd.
    gt_vbap = it_vbap.

    me->get_item_data(  ).

  ENDMETHOD.


  METHOD get_item_data.

    IF gt_vbap IS NOT INITIAL.

      LOOP AT gt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
        DATA(lv_vrkme) = <fs_vbap>-vrkme.
        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
          EXPORTING
            input          = <fs_vbap>-vrkme
          IMPORTING
            output         = <fs_vbap>-vrkme
          EXCEPTIONS
            unit_not_found = 1
            OTHERS         = 2.
        IF sy-subrc <> 0.
          <fs_vbap>-vrkme = lv_vrkme.
        ENDIF.
      ENDLOOP.

      DATA(ls_res) = VALUE zclsd_mt_ordem_venda_sap_siriu( mt_ordem_venda_sap_sirius-cabecalho-vbeln = gs_vbak-vbeln
                                            mt_ordem_venda_sap_sirius-cabecalho-btskd_e = gs_vbkd-bstkd_e
                                            mt_ordem_venda_sap_sirius-cabecalho-augru   = gs_vbak-augru
                                            mt_ordem_venda_sap_sirius-cabecalho-bsark   = gs_vbak-bsark
                                            mt_ordem_venda_sap_sirius-cabecalho-lifsk   = gs_vbak-lifsk
                                            mt_ordem_venda_sap_sirius-cabecalho-vtweg   = gs_vbak-vtweg
                                            mt_ordem_venda_sap_sirius-cabecalho-kunnr   = gs_vbak-kunnr
                                            mt_ordem_venda_sap_sirius-cabecalho-auart   = gs_vbak-auart
                                            mt_ordem_venda_sap_sirius-cabecalho-zterm   = gs_vbkd-zterm
                                            mt_ordem_venda_sap_sirius-cabecalho-vkorg   = gs_vbak-vkorg
                                            mt_ordem_venda_sap_sirius-cabecalho-inco1   = gs_vbkd-inco1
                                            mt_ordem_venda_sap_sirius-cabecalho-erdat   = gs_vbak-erdat
                                            mt_ordem_venda_sap_sirius-cabecalho-zlsch   = gs_vbkd-zlsch
                                            mt_ordem_venda_sap_sirius-cabecalho-volum   = REDUCE dec015( INIT lv_kwmeng TYPE dec015
                                                                                               FOR ls_item IN gt_vbap
                                                                                               NEXT lv_kwmeng = lv_kwmeng + ls_item-kwmeng )
                                            mt_ordem_venda_sap_sirius-cabecalho-vdatu   = gs_vbak-vdatu
                                            mt_ordem_venda_sap_sirius-cabecalho-bstnk   = gs_vbak-bstnk
                                            mt_ordem_venda_sap_sirius-cabecalho-item   = VALUE tt_item(
                                                               FOR ls_item IN gt_vbap (
                                                               kzwi3 = ls_item-kzwi6
                                                               netwr = COND #( WHEN ls_item-kwmeng > 0 THEN	ls_item-kzwi1 / ls_item-kwmeng ELSE 0 )
                                                               posnr = ls_item-posnr
                                                               netpr = ls_item-netpr
                                                               posex = ls_item-posex
                                                               matnr = ls_item-matnr
                                                               kwmeng = ls_item-kwmeng
                                                               vrkme = ls_item-vrkme
                                                               abgru = ls_item-abgru
                                                               werks = ls_item-werks
                                                   ) )
                                                ).

      me->send_sirius( ls_res ).

    ENDIF.

  ENDMETHOD.


  METHOD send_sirius.

    TRY.

        DATA(lo_sirius) = NEW zclsd_co_si_envia_ordem_venda(  ).

        lo_sirius->si_envia_ordem_venda_sap_siriu( is_ret ).

        COMMIT WORK AND WAIT.

      CATCH cx_ai_system_fault.
    ENDTRY.

  ENDMETHOD.


  METHOD send_doc.

    TRY.

        NEW zclsd_co_si_enviar_status_cria(  )->si_enviar_status_criacao_ordem(
                     output =  VALUE zclsd_mt_status_criacao_ordem(
                                          mt_status_criacao_ordem_venda-cabecalho-purch_no_c = gs_sirius-mt_criacao_ordem_venda-order_header_in-purch_no_c
                                          mt_status_criacao_ordem_venda-cabecalho-salesdocum = iv_doc
                                          mt_status_criacao_ordem_venda-cabecalho-return     = VALUE zclsd_dt_status_criacao_or_tab(
                                                                     FOR ls_ret IN it_return WHERE ( type = gc_erro ) (
                                                                         symsgid    = ls_ret-id
                                                                         symsgno    = ls_ret-log_msg_no
                                                                         bapi_mtype = ls_ret-type
                                                                         bapi_msg   = ls_ret-message
                                                 ) ) ) ).

        me->bapi_commit(  ).

      CATCH cx_ai_system_fault  .

    ENDTRY.

  ENDMETHOD.


  METHOD fill_text.

    LOOP AT  gs_sirius-mt_criacao_ordem_venda-order_text ASSIGNING FIELD-SYMBOL(<fs_text>).

      et_text = VALUE #( BASE et_text ( text_id = <fs_text>-text_id langu = sy-langu text_line = <fs_text>-text_line ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_partner.

    LOOP AT  gs_sirius-mt_criacao_ordem_venda-order_partners ASSIGNING FIELD-SYMBOL(<fs_partner>).

      et_partner = VALUE #( BASE et_partner ( partn_role = <fs_partner>-partn_role partn_numb = <fs_partner>-partn_numb ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD fill_header.

    es_header = VALUE bapisdhd1(  doc_type    = gs_sirius-mt_criacao_ordem_venda-order_header_in-doc_type
                                  sales_org   = gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_org
                                  distr_chan  = gs_sirius-mt_criacao_ordem_venda-order_header_in-distr_chan
                                  division    = gs_sirius-mt_criacao_ordem_venda-order_header_in-division
                                  sales_grp   = gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_grp
                                  sales_off   = gs_sirius-mt_criacao_ordem_venda-order_header_in-sales_off
                                  incoterms1  = gs_sirius-mt_criacao_ordem_venda-order_header_in-incoterms1
                                  version     = gs_sirius-mt_criacao_ordem_venda-order_header_in-version
                                  ord_reason  = gs_sirius-mt_criacao_ordem_venda-order_header_in-ord_reason
                                  incoterms2  = gs_sirius-mt_criacao_ordem_venda-order_header_in-incoterms1 "2
                                  pmnttrms    = gs_sirius-mt_criacao_ordem_venda-order_header_in-pmnttrms
                                  dlv_block   = gs_sirius-mt_criacao_ordem_venda-order_header_in-dlv_block
                                  purch_date  = gs_sirius-mt_criacao_ordem_venda-order_header_in-purch_date
                                  purch_no_c  = gs_sirius-mt_criacao_ordem_venda-order_header_in-purch_no_s
                                  purch_no_s  = gs_sirius-mt_criacao_ordem_venda-order_header_in-purch_no_c
                                  ref_1       = gs_sirius-mt_criacao_ordem_venda-order_header_in-ref_1
                                  doc_date    = gs_sirius-mt_criacao_ordem_venda-order_header_in-doc_date
                                  pymt_meth   = gs_sirius-mt_criacao_ordem_venda-order_header_in-pymt_meth
                                  price_date  = gs_sirius-mt_criacao_ordem_venda-order_header_in-price_date
                                  price_list  = gs_sirius-mt_criacao_ordem_venda-order_header_in-price_list
                                  req_date_h  = gs_sirius-mt_criacao_ordem_venda-order_header_in-req_date_h
                                  po_method   = gs_sirius-mt_criacao_ordem_venda-order_header_in-po_method
                                   ).

  ENDMETHOD.


  METHOD execute_change.

    gs_sirius_c = is_sirius.

    me->fill_change( ).

  ENDMETHOD.


  METHOD fill_change.

    me->header_change( IMPORTING es_header = DATA(ls_header) es_headerx = DATA(ls_headerx) ).
    me->item_change( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).

    me->bapi_change( EXPORTING is_header = ls_header is_headerx = ls_headerx it_schedule = lt_item it_schedulex = lt_itemx ).

  ENDMETHOD.


  METHOD header_change.

    es_header = VALUE bapisdh1( collect_no = gs_sirius_c-mt_alterar_ordem_venda_in-order_header_in-salesdocument
                                dlv_block  = gs_sirius_c-mt_alterar_ordem_venda_in-order_header_in-dlv_block ).

    es_headerx = VALUE bapisdh1x( collect_no = abap_true
                                  dlv_block  = abap_true
                                  updateflag = 'U' ).

  ENDMETHOD.


  METHOD item_change.

    LOOP AT gs_sirius_c-mt_alterar_ordem_venda_in-order_header_in-schedule_lines ASSIGNING FIELD-SYMBOL(<fs_schedules>).

      et_item = VALUE #( BASE et_item ( itm_number = <fs_schedules>-itm_number
                                        req_dlv_bl = <fs_schedules>-req_dlv_bl ) ).

      et_itemx = VALUE #( BASE et_itemx ( itm_number = <fs_schedules>-itm_number
                                          req_dlv_bl = abap_true ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD bapi_change.

    DATA: lt_ret TYPE STANDARD TABLE OF bapiret2,
          lv_doc TYPE vbeln.

    UNPACK gs_sirius_c-mt_alterar_ordem_venda_in-order_header_in-salesdocument TO lv_doc.

    CALL FUNCTION 'BAPI_SALESORDER_CHANGE' ##COMPATIBLE
      EXPORTING
        salesdocument    = lv_doc
        order_header_in  = is_header
        order_header_inx = is_headerx
      TABLES
        return           = lt_ret
        schedule_lines   = it_schedule
        schedule_linesx  = it_schedulex
      EXCEPTIONS
        error_message    = 1
        OTHERS           = 2.

    IF ( sy-subrc NE 0 AND line_exists( lt_ret[ type = 'E' ] ) ) OR "#EC CI_STDSEQ
       ( sy-subrc EQ 0 AND line_exists( lt_ret[ type = 'E' ] ) ). "#EC CI_STDSEQ

      me->erro( VALUE scx_t100key( msgid = lt_ret[ 1 ]-id
                                   msgno = lt_ret[ 1 ]-number
                                   attr1 = lt_ret[ 1 ]-message
                                   attr2 = lt_ret[ 1 ]-message_v1
                                   attr3 = lt_ret[ 1 ]-message_v2
                                   attr4 = lt_ret[ 1 ]-message_v3
                                    ) ).

    ELSE.

      me->bapi_commit(  ).

    ENDIF.



  ENDMETHOD.


  METHOD bapi_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_True.

  ENDMETHOD.
ENDCLASS.
