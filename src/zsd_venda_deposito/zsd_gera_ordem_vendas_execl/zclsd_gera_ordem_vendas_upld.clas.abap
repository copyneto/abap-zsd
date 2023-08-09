CLASS zclsd_gera_ordem_vendas_upld DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Type Dados da tela
      BEGIN OF ty_header,
        salesdocumenttype   TYPE auart,
        salesorganization   TYPE vkorg,
        distributionchannel TYPE vtweg,
        sddocumentreason    TYPE augru,
      END OF ty_header.

    TYPES:
           "! Type Dados do arquivo
           tt_file TYPE TABLE OF ztsd_arq_ordvend.

    "! Dados para BAPI
    DATA gs_badi_sales_order TYPE zsca_header_pedido_venda.
    "! Dados Cliente BAPI
    DATA gs_numclient TYPE kunnr.
    "! Dados Itens BAPI
    DATA gs_itens TYPE zsca_itens_pedido_venda.
    "! Dados extensões BAPI
    DATA gs_ext   TYPE zsca_extension_pedido_venda.
    "! Contagem Item
    DATA gs_num_item TYPE char4 .
    "! Mensagem retorno
    DATA gt_return TYPE  bapiret2_tab.
    "! Mensagem retorno
    DATA gt_return_all TYPE  bapiret2_tab.

    "! Método principal
    "! @parameter is_header | Dados da tela
    "! @parameter it_file | Dados do arquivo
    METHODS main IMPORTING is_header TYPE ty_header
                           it_file   TYPE tt_file
                 EXPORTING et_return TYPE  bapiret2_tab .

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Tipo de Bp
    DATA gs_tipo_bp TYPE RANGE OF parvw.
    "! Tipo de Condição
    DATA gs_tipo_cond TYPE RANGE OF kscha.


    "! Seleciona os tipos de BP
    "! @parameter rv_tipo_bp |Tipo de Bp
    METHODS get_param_tipo_bp RETURNING VALUE(rv_tipo_bp) TYPE parvw.

    "! Seleciona os Tipos de Condição
    "! @parameter rv_tipo_cond |Tipo de Condição
    METHODS get_param_tipo_cond RETURNING VALUE(rv_tipo_cond) TYPE kscha.

    "! Alimenta estrutura Bapi
    "! @parameter iv_tipo_cond | Tipo de Condição
    "! @parameter is_file | Dados do arquivo
    METHODS fill_bapi
      IMPORTING
        iv_tipo_cond TYPE kscha
        is_file      TYPE ztsd_arq_ordvend.
    "! Chama a Bapi
    METHODS call_bapi.
    "! Seleciona dados do cliente
    METHODS get_data_client.
    "! Trata Material
    "! @parameter is_file | Dados arquivo
    METHODS get_material
      IMPORTING
        is_file TYPE ztsd_arq_ordvend.

ENDCLASS.



CLASS zclsd_gera_ordem_vendas_upld IMPLEMENTATION.


  METHOD get_param_tipo_bp.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    CLEAR gs_tipo_bp.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'TIPO_BP'
          IMPORTING
            et_range  = gs_tipo_bp
        ).

        READ TABLE gs_tipo_bp ASSIGNING FIELD-SYMBOL(<fs_tipo_bp>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_tipo_bp = <fs_tipo_bp>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_param_tipo_cond.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    CLEAR gs_tipo_cond.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'TIPO_COND'
          IMPORTING
            et_range  = gs_tipo_cond
        ).

        READ TABLE gs_tipo_cond ASSIGNING FIELD-SYMBOL(<fs_tipo_cond>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_tipo_cond = <fs_tipo_cond>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD main.

    DELETE FROM ztsd_logmsg_ov WHERE message IS NOT INITIAL.

    DATA(lv_tipo_bp) = get_param_tipo_bp(  ).
    DATA(lv_tipo_cond) = get_param_tipo_cond(  ).

    gs_badi_sales_order-doc_type     = is_header-salesdocumenttype.
    gs_badi_sales_order-sales_org    = is_header-salesorganization.
    gs_badi_sales_order-canal_vendas = is_header-distributionchannel.
    gs_badi_sales_order-po_method    = 'EXCE'.
    gs_badi_sales_order-ord_reason   = is_header-sddocumentreason.

    gs_badi_sales_order-partn_role = lv_tipo_bp.


    LOOP AT it_file ASSIGNING FIELD-SYMBOL(<fs_file>).

      DATA(lv_client) = <fs_file>-numclient.
      UNPACK lv_client TO lv_client.

      IF gs_numclient IS INITIAL
       OR ( gs_badi_sales_order-partn_numb = lv_client
       AND gs_badi_sales_order-purch_no_c  = <fs_file>-refclient ).

        fill_bapi( iv_tipo_cond = lv_tipo_cond is_file = <fs_file> ).

      ELSE.

        call_bapi( ).

        CLEAR: gs_itens, gs_ext, gs_badi_sales_order-itens, gs_numclient, gs_num_item.

        fill_bapi( iv_tipo_cond = lv_tipo_cond is_file = <fs_file> ).

      ENDIF.
*
    ENDLOOP.

    CHECK gs_badi_sales_order IS NOT INITIAL.
    call_bapi( ).
    et_return = gt_return_all.

  ENDMETHOD.


  METHOD call_bapi.

    DATA:
         lt_return    TYPE STANDARD TABLE OF bapireturn1.

    CALL FUNCTION 'ZFM_CREATE_SALESORDER'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_dados = gs_badi_sales_order
      TABLES
        t_return = gt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    APPEND LINES OF gt_return TO gt_return_all.
  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFM_CREATE_SALESORDER'
      TABLES
        et_return  = gt_return.
    RETURN.
  ENDMETHOD.


  METHOD fill_bapi.



    gs_badi_sales_order-purch_no_c = is_file-refclient.
    gs_badi_sales_order-centro     = is_file-plant.
    gs_badi_sales_order-partn_numb = is_file-numclient.

    UNPACK gs_badi_sales_order-partn_numb TO gs_badi_sales_order-partn_numb.

    get_data_client( ).

    gs_numclient         = gs_badi_sales_order-partn_numb.
    gs_num_item          = gs_num_item + 10.
    gs_itens-item        = gs_num_item.
    get_material( is_file ).
    gs_itens-store_loc   = is_file-deposit.
    gs_itens-wbs_elem    = is_file-pep.
    gs_itens-quantidade  = is_file-quantity.
    gs_itens-target_qu   = is_file-salesunit.


    gs_itens-cond_type       = iv_tipo_cond.
    gs_itens-valor_item_desc = is_file-cond_value.

    gs_ext-structure         = 'BAPE_VBAP'.
    gs_ext-fieldname         = 'ZZKOSTL'.
    gs_ext-value             = is_file-costcenter.
    APPEND gs_ext   TO gs_itens-extension.

    APPEND gs_itens TO gs_badi_sales_order-itens.
    CLEAR:gs_itens-extension, gs_itens.


  ENDMETHOD.

  METHOD get_material.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = is_file-material
      IMPORTING
        output       = gs_itens-produto
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
      gs_itens-produto = is_file-material.
    ENDIF.

  ENDMETHOD.



  METHOD get_data_client.

    CHECK gs_badi_sales_order-setor_atividade IS INITIAL AND
    gs_badi_sales_order-equipe_vendas IS INITIAL AND
    gs_badi_sales_order-escritorio_vendas IS INITIAL.

    SELECT SINGLE spart, vkgrp, vkbur                "#EC CI_SEL_NESTED
  FROM knvv
  INTO @DATA(ls_knvv)
  WHERE kunnr EQ @gs_badi_sales_order-partn_numb
    AND vkorg EQ @gs_badi_sales_order-sales_org
    AND vtweg EQ @gs_badi_sales_order-canal_vendas.

    IF ls_knvv IS NOT INITIAL.
      gs_badi_sales_order-setor_atividade   = ls_knvv-spart.
      gs_badi_sales_order-equipe_vendas     = ls_knvv-vkgrp.
      gs_badi_sales_order-escritorio_vendas = ls_knvv-vkbur.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
