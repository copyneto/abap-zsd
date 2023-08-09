CLASS zclsd_criacao_ordens_vendas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS:
      constructor
        IMPORTING
          is_input TYPE zclsd_mt_criacao_ordem_venda_f
        RAISING
          zcxsd_erro_interface.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA: gs_input     TYPE zclsd_mt_criacao_ordem_venda_f.

    METHODS:
      process_data
        RAISING
          zcxsd_erro_interface,

      "! Raising erro
      erro
        IMPORTING
          is_erro TYPE scx_t100key
        RAISING
          zcxsd_erro_interface,

      bapi_commit,
      conv
        IMPORTING
          iv_materiais_target_qu TYPE zclsd_dt_criacao_ordem_venda_8-target_qu
        RETURNING
          VALUE(rv_result)       TYPE string .

ENDCLASS.



CLASS ZCLSD_CRIACAO_ORDENS_VENDAS IMPLEMENTATION.


  METHOD constructor.
    MOVE-CORRESPONDING is_input TO gs_input.
    me->process_data( ).
  ENDMETHOD.


  METHOD process_data.

    CONSTANTS:
      lc_setor_comum     TYPE spart VALUE '99',
      lc_tp_pedido_fluig TYPE bsark VALUE 'FLUI',
      lc_valor_zero      TYPE string VALUE '0.00'.

    DATA: ls_order_header_in     TYPE bapisdhd1,
          lv_salesdocument       TYPE bapivbeln-vbeln,
          lv_target_qu           TYPE bapisditm-target_qu,
          lt_order_items_in      TYPE TABLE OF bapisditm,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_conditions_in TYPE TABLE OF bapicond,
          lt_order_schedules_in  TYPE STANDARD TABLE OF  bapischdl,
          lt_order_schedules_inx TYPE STANDARD TABLE OF  bapischdlx,
          lt_ret                 TYPE TABLE OF bapiret2,
          lt_arq_ordvend         TYPE TABLE OF ztsd_arq_ordvend,
*          lo_status_ordem        TYPE REF TO zclsd_co_si_status_ordem_venda,
          lt_linhas              TYPE zclsd_dt_status_ordem_vend_tab,
          ls_output              TYPE zclsd_mt_status_ordem_venda_fl,
          lt_doc_type            TYPE tms_t_auart_range.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " INSERT - JWSILVA - 22.07.2023

    TRY.

        lo_param->m_get_single(                                   " CHANGE - JWSILVA - 22.07.2023
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'FLUIG'
            iv_chave2 = 'TARGET_QU'
          IMPORTING
            ev_param  = lv_target_qu
        ).
      CATCH zcxca_tabela_parametros.
        FREE lv_target_qu.
    ENDTRY.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = lv_target_qu
      IMPORTING
        output         = lv_target_qu
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.
    IF sy-subrc IS NOT INITIAL.
      CLEAR lv_target_qu.
    ENDIF.

* LSCHEPP - 8000006885 - [FLUIG] - Erro_retorno. SAP_Prç_OV_Desp. - 03.05.2023 Início
*    SELECT SINGLE low
*    INTO @DATA(lv_low)
*    FROM ztca_param_val
*    WHERE modulo = 'SD'
*    AND chave1 = 'FLUIG'
*    AND chave2 = 'ZPR0'.

    TRY.
        lo_param->m_get_range(                                  " CHANGE - JWSILVA - 22.07.2023
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'FLUIG'
            iv_chave2 = 'ZPR0'
          IMPORTING
            et_range  = lt_doc_type
        ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.
* LSCHEPP - 8000006885 - [FLUIG] - Erro_retorno. SAP_Prç_OV_Desp. - 03.05.2023 Fim

    ls_order_header_in-doc_type    = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-doc_type.
    ls_order_header_in-sales_org   = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-sales_org.
    ls_order_header_in-distr_chan  = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-distr_chan.
    ls_order_header_in-purch_no_c  = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c.
    ls_order_header_in-po_method   = lc_tp_pedido_fluig.
    ls_order_header_in-pymt_meth   = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-pymt_meth.
    ls_order_header_in-ord_reason  = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-ord_reason.
    ls_order_header_in-division    = lc_setor_comum.

    DATA(lv_lines_table) = lines( gs_input-mt_criacao_ordem_venda_fluig-cabecalho-itens ).

    LOOP AT gs_input-mt_criacao_ordem_venda_fluig-cabecalho-itens ASSIGNING FIELD-SYMBOL(<fs_itens>).
      DATA(lv_lines) = sy-tabix.

      LOOP AT <fs_itens>-materiais ASSIGNING FIELD-SYMBOL(<fs_materiais>).

        APPEND VALUE #(
                itm_number  = <fs_materiais>-ind
                material    = |{ <fs_materiais>-material ALPHA = IN }|
                plant       = <fs_materiais>-plant
                store_loc   = <fs_materiais>-store_loc
                wbs_elem    = <fs_materiais>-wbs_element
                target_qty  = <fs_materiais>-target_qty
                sales_unit  = conv( <fs_materiais>-target_qu )
*                target_qu   = <fs_materiais>-target_qu
*                target_qu   = lv_target_qu
                dlv_prio    = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-dlv_prio
            ) TO lt_order_items_in.

        APPEND VALUE #(
                partn_role = 'AG'
                partn_numb = <fs_itens>-partn_numb
            ) TO lt_order_partners.

        IF gs_input-mt_criacao_ordem_venda_fluig-cabecalho-partn_numb2 IS NOT INITIAL.
          APPEND VALUE #(
                  partn_role = 'SP'
                  partn_numb = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-partn_numb2
              ) TO lt_order_partners.
        ENDIF.

*        IF <fs_materiais>-valor_unit NE lc_valor_zero AND lv_low IS INITIAL.
* LSCHEPP - 8000006885 - [FLUIG] - Erro_retorno. SAP_Prç_OV_Desp. - 03.05.2023 Início
*        IF <fs_materiais>-valor_unit NE lc_valor_zero.
        IF <fs_materiais>-valor_unit NE lc_valor_zero AND
           gs_input-mt_criacao_ordem_venda_fluig-cabecalho-doc_type NOT IN lt_doc_type.
* LSCHEPP - 8000006885 - [FLUIG] - Erro_retorno. SAP_Prç_OV_Desp. - 03.05.2023 Fim

          APPEND VALUE #(
                    itm_number = <fs_materiais>-ind
                    cond_type  = 'ZPR0'
                    cond_value = ( <fs_materiais>-valor_unit / 10 )
              ) TO lt_order_conditions_in.

*      APPEND VALUE #( itm_number = iv_item-item
*                      req_qty    = abap_true          ) TO lt_order_schedules_inx.

        ENDIF.

        APPEND VALUE #(
              itm_number = <fs_materiais>-ind
              req_qty    = <fs_materiais>-target_qty ) TO lt_order_schedules_in.


        APPEND VALUE #( numclient       = <fs_itens>-partn_numb
                        plant           = <fs_materiais>-plant
                        deposit         = <fs_materiais>-store_loc
                        refclient       = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c
                        material        = <fs_materiais>-material
                        quantity        = <fs_materiais>-target_qty
                        cond_value      = <fs_materiais>-valor_unit
                        costcenter      = <fs_materiais>-costcenter
                        salesunit       = lv_target_qu
                        dlv_prio        = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-dlv_prio
                        created_by      = sy-uname
                        created_at      = sy-uzeit
                        last_changed_by = sy-uname
                        last_changed_at = sy-uzeit ) TO lt_arq_ordvend.

      ENDLOOP.

      IF lt_arq_ordvend IS NOT INITIAL.
        MODIFY ztsd_arq_ordvend FROM TABLE lt_arq_ordvend.
        COMMIT WORK.
      ENDIF.

      CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
        EXPORTING
          order_header_in     = ls_order_header_in
        IMPORTING
          salesdocument       = lv_salesdocument
        TABLES
          return              = lt_ret
          order_items_in      = lt_order_items_in
          order_partners      = lt_order_partners
          order_conditions_in = lt_order_conditions_in
          order_schedules_in  = lt_order_schedules_in.

      FREE: lt_order_items_in,
            lt_order_partners,
            lt_order_conditions_in,
            lt_order_schedules_in.

      SORT lt_ret BY type.

      IF ( line_exists( lt_ret[ type = 'E' ] ) ).



        LOOP AT <fs_itens>-materiais ASSIGNING FIELD-SYMBOL(<fs_materiais_ret>).

          ls_output-mt_status_ordem_venda_fluig-assignee  = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c.
          ls_output-mt_status_ordem_venda_fluig-comment   = TEXT-001.
          ls_output-mt_status_ordem_venda_fluig-ped_fluig = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c.

          DATA(ls_ret) = VALUE #( lt_ret[ type = 'E' ] OPTIONAL ).

          MESSAGE ID ls_ret-id
                  TYPE ls_ret-type
                  NUMBER ls_ret-number
                  WITH ls_ret-message_v1
                       ls_ret-message_v2
                       ls_ret-message_v3
                       ls_ret-message_v4
                       INTO DATA(lv_msg).

          APPEND VALUE #(
              desc_status = 'status___' && <fs_materiais_ret>-ind
              status      = '02'
              processado  = 'processado___' && <fs_materiais_ret>-ind
              desc_processado = lv_msg
          ) TO lt_linhas. "ls_output-mt_status_ordem_venda_fluig-form_fields-lista.

        ENDLOOP.

        "Status é passado apenas para o último item
        IF lv_lines_table = lv_lines.
          ls_output-mt_status_ordem_venda_fluig-form_fields-lista = lt_linhas.

          TRY.
              NEW zclsd_co_si_status_ordem_venda( )->si_status_ordem_venda_fluig_ou( output = ls_output ).
              FREE ls_output.
            CATCH cx_ai_system_fault.
              FREE ls_output.
          ENDTRY.
        ENDIF.
*        APPEND ls_output TO lt_output[].
*        FREE ls_output.

**        me->erro( VALUE scx_t100key( msgid = lt_ret[ 1 ]-id
**                                     msgno = lt_ret[ 1 ]-number
**                                     attr1 = lt_ret[ 1 ]-message
**                                     attr2 = lt_ret[ 1 ]-message_v1
**                                     attr3 = lt_ret[ 1 ]-message_v2
**                                     attr4 = lt_ret[ 1 ]-message_v3
**                                     attr1 = lt_ret[ 1 ]-message_v1
**                                     attr2 = lt_ret[ 1 ]-message_v2
**                                     attr3 = lt_ret[ 1 ]-message_v3
**                                     attr4 = lt_ret[ 1 ]-message_v4
**                                      ) ).

      ELSE.
        me->bapi_commit(  ).

        LOOP AT <fs_itens>-materiais ASSIGNING <fs_materiais_ret>.

          ls_output-mt_status_ordem_venda_fluig-assignee  = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c.
          ls_output-mt_status_ordem_venda_fluig-comment   = TEXT-001.
          ls_output-mt_status_ordem_venda_fluig-ped_fluig = gs_input-mt_criacao_ordem_venda_fluig-cabecalho-purch_no_c.

          APPEND VALUE #(
              desc_status = 'status___' && <fs_materiais_ret>-ind
              status      = '01'
              processado  = 'processado___' && <fs_materiais_ret>-ind
              desc_processado = TEXT-002 && lv_salesdocument
          ) TO lt_linhas."ls_output-mt_status_ordem_venda_fluig-form_fields-lista.

        ENDLOOP.

        "Status é passado apenas para o último item
        IF lv_lines_table = lv_lines.
          ls_output-mt_status_ordem_venda_fluig-form_fields-lista = lt_linhas.

          TRY.
              NEW zclsd_co_si_status_ordem_venda( )->si_status_ordem_venda_fluig_ou( output = ls_output ).
              FREE ls_output.
            CATCH cx_ai_system_fault.
              FREE ls_output.
          ENDTRY.

        ENDIF.

*        APPEND ls_output TO lt_output[].
*        FREE ls_output.

      ENDIF.
      CLEAR: lv_salesdocument.
    ENDLOOP.

*    TRY.
*        NEW zclsd_co_si_status_ordem_venda( )->si_status_ordem_venda_fluig_ou( output = ls_output ).
*        FREE ls_output.
*      CATCH cx_ai_system_fault.
*        FREE ls_output.
*    ENDTRY.

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


  METHOD conv.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = iv_materiais_target_qu
      IMPORTING
        output         = rv_result
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc NE 0.
      CLEAR rv_result.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
