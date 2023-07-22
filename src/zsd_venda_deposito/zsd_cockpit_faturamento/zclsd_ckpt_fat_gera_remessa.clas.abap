class ZCLSD_CKPT_FAT_GERA_REMESSA definition
  public
  final
  create public .

public section.

    "! Funcionalidade Gerar Remessa
    "! @parameter iv_ordem_venda | Ordem do cliente
    "! @parameter rt_return      | Mensagens de erro
  methods MAIN
    importing
      !IV_ORDEM_VENDA type ZI_SD_CKPT_FAT_APP-SALESORDER
      !IV_CLIENTE type ZI_SD_CKPT_FAT_APP-CUSTOMER
    returning
      value(RT_RETURN) type BAPIRET2_TAB .
    "! Método para criar Remessa
    "! @parameter iv_sales_order    | Ordem do cliente
    "! @parameter iv_block_delivery | Indica se remessa nasce bloqueada ou não
    "! @parameter ev_delivery_no    | Número da remessa gerada
    "! @parameter et_return         | Tabela de mensagens
  methods CALL_BAPI_CREATE
    importing
      !IV_SALES_ORDER type VBAK-VBELN
      !IV_BLOCK_DELIVERY type ABAP_BOOLEAN
    exporting
      !EV_DELIVERY_NO type LIKP-VBELN
      !ET_RETURN type BAPIRET2_T .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
  methods TASK_FINISH
    importing
      !P_TASK type CLIKE .
  methods TASK_FINISH_MOD
    importing
      !P_TASK type CLIKE .
  methods GET_PARAM_BLOQUEIO
    returning
      value(RV_BLOQUEIO) type LIFSK .
  PROTECTED SECTION.
private section.

    "! Retorno Mensagem Bapi
  data GT_RETURN type BAPIRET2_TAB .
    "! Retorno Mensagem Bapi
  data GT_RETURN_CHANGE type BAPIRET2_TAB .
    "! Remessa
  data GV_DELIVERY type BAPISHPDELIVNUMB-DELIV_NUMB .
    "! Modificação entrega dados de picking nível de cabeçalho
  data GS_HEADER_DATA type BAPIOBDLVHDRCHG .
    "! Dados de controle entrega nível de cabeçalho
  data GS_HEADER_CONTROL type BAPIOBDLVHDRCTRLCHG .
  constants:
      "! Constantes para tabela de parâmetros
    BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'BLOQ_REMESSA',
*        chave3 TYPE ztca_param_par-chave3 VALUE 'LIB_ROTA',
        chave3 TYPE ztca_param_par-chave3 VALUE 'ANALISE',
      END OF gc_parametros .
  data:
    "!  Bloqueio da remessa
    gs_bloqueio TYPE RANGE OF lifsk .

  methods VERIFICA_CLIENTE
    importing
      !IV_ORDEM_VENDA type ZI_SD_CKPT_FAT_APP-SALESORDER
      !IV_CLIENTE type ZI_SD_CKPT_FAT_APP-CUSTOMER .
ENDCLASS.



CLASS ZCLSD_CKPT_FAT_GERA_REMESSA IMPLEMENTATION.


  METHOD main.

    verifica_cliente( iv_ordem_venda = iv_ordem_venda iv_cliente = iv_cliente ).

    IF gt_return IS INITIAL.

      CALL FUNCTION 'ZFMSD_CKPT_FAT_GERAR_REMESSA'
        STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
        EXPORTING
          iv_sales_order    = iv_ordem_venda
          iv_block_delivery = abap_true.

      WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_return IS NOT INITIAL.
      rt_return = gt_return.
    ELSE.
      rt_return = gt_return.
    ENDIF.

  ENDMETHOD.


  METHOD verifica_cliente.

    SELECT SINGLE xdele, xblck, not_released
    FROM but000
    INTO @DATA(ls_cliente)
    WHERE partner EQ @iv_cliente.

    IF ls_cliente-xdele EQ abap_true.
      APPEND VALUE #( id         = 'ZSD_CKPT_FATURAMENTO'
                      number     = 018
                      type       = 'E'
                      message_v1 = iv_ordem_venda
                      message_v2 = iv_cliente ) TO gt_return.
    ENDIF.

    IF ls_cliente-xblck EQ abap_true.
      APPEND VALUE #( id         = 'ZSD_CKPT_FATURAMENTO'
                      number     = 019
                      type       = 'E'
                      message_v1 = iv_ordem_venda
                      message_v2 = iv_cliente ) TO gt_return.
    ENDIF.

    IF ls_cliente-not_released EQ abap_true.
      APPEND VALUE #( id         = 'ZSD_CKPT_FATURAMENTO'
                      number     = 020
                      type       = 'E'
                      message_v1 = iv_ordem_venda
                      message_v2 = iv_cliente ) TO gt_return.
    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_create.
    DATA lt_sales_order_items TYPE STANDARD TABLE OF bapidlvreftosalesorder.
    DATA lt_return            TYPE STANDARD TABLE OF bapiret2.
    DATA lt_return_aux        TYPE STANDARD TABLE OF bapiret2.
    DATA ls_header_data       TYPE bapiobdlvhdrchg.
    DATA ls_header_control    TYPE bapiobdlvhdrctrlchg.

    "Get single parameter
***    DATA(lv_delivery_block_code) = me->get_param_bloqueio( ).

    "Create delivery
    lt_sales_order_items = VALUE #( ( ref_doc = iv_sales_order ) ).

    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_SLS'
      IMPORTING
        delivery          = ev_delivery_no
      TABLES
        sales_order_items = lt_sales_order_items
        return            = lt_return.

    IF line_exists( lt_return[ id = 'VU' number = '013' ] ) OR
       line_exists( lt_return[ id = 'VU' number = '014' ] ) OR
       line_exists( lt_return[ id = 'VU' number = '019' ] ) OR
       line_exists( lt_return[ id = 'VU' number = '020' ]  ).

      APPEND VALUE #(
 id         = 'VU'
 number     = 013
 type       = 'E'
           message_v1 = space
          message_v2 = space
          parameter  = space

) TO et_return.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      "Block delivery
***      IF NOT ( ev_delivery_no         IS INITIAL
***     AND NOT   lv_delivery_block_code IS INITIAL ).
***
***        LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
***
***          IF <fs_return>-id = 'VL' AND <fs_return>-number = '311'.
***
***            ls_header_data = VALUE #( deliv_numb = |{ <fs_return>-message_v1(10) ALPHA = IN  }| "ev_delivery_no
***                                       dlv_block = lv_delivery_block_code ).
***
***            ls_header_control = VALUE #( deliv_numb    = |{ <fs_return>-message_v1(10) ALPHA = IN  }| "ev_delivery_no
***                                         dlv_block_flg = abap_true ).
***
***            CALL FUNCTION 'ZFMSD_CKPT_FAT_MOD_REMESSA'
***              STARTING NEW TASK 'BACKGROUND_MOD' CALLING task_finish_mod ON END OF TASK
***              EXPORTING
***                is_header_data    = ls_header_data
***                is_header_control = ls_header_control
***                iv_delivery_no    = ev_delivery_no
***              TABLES
***                tt_return         = lt_return.
***
****            CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
****              EXPORTING
****                header_data    = ls_header_data
****                header_control = ls_header_control
****                delivery       = ev_delivery_no
****              TABLES
****                return         = lt_return.
****
****            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
****              EXPORTING
****                wait = abap_true.
***
***            APPEND LINES OF lt_return TO lt_return_aux.
***
***          ENDIF.
***        ENDLOOP.
***
***      ENDIF.

***      IF lt_return_aux IS NOT INITIAL.
***        SORT lt_return_aux BY id  number message.
***        DELETE ADJACENT DUPLICATES FROM lt_return_aux COMPARING id  number message.
***        lt_return = lt_return_aux.
***      ENDIF.

      IF line_exists( lt_return[ type = 'E' ] ).         "#EC CI_STDSEQ
        LOOP AT lt_return INTO DATA(ls_return) WHERE type = 'E'. "#EC CI_STDSEQ
          MESSAGE ID ls_return-id TYPE ls_return-type
          NUMBER     ls_return-number
          WITH       ls_return-message_v1 ls_return-message_v2 ls_return-message_v3 ls_return-message_v4
          INTO DATA(lv_message).

          APPEND VALUE #(
            id         = 'ZSD_CKPT_FATURAMENTO'
            number     = 010
            type       = 'E'
            message_v1 = iv_sales_order
            message_v2 = lv_message
            parameter  = iv_sales_order
          ) TO et_return.
        ENDLOOP.
      ELSE.
        APPEND VALUE #(
          id         = 'ZSD_CKPT_FATURAMENTO'
          number     = 011
          type       = 'S'
          message_v1 = iv_sales_order
          message_v2 = ev_delivery_no
          parameter  = iv_sales_order
        ) TO et_return.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CKPT_FAT_GERAR_REMESSA'
     IMPORTING
      ev_delivery_no = me->gv_delivery
      et_return      = me->gt_return.

  ENDMETHOD.


  METHOD get_param_bloqueio.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_bloqueio.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-chave2
      iv_chave3 = gc_parametros-chave3
          IMPORTING
            et_range  = gs_bloqueio
        ).

        READ TABLE gs_bloqueio ASSIGNING FIELD-SYMBOL(<fs_bloqueio>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_bloqueio = <fs_bloqueio>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.


  ENDMETHOD.


  METHOD task_finish_mod.

* RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CKPT_FAT_MOD_REMESSA'
* IMPORTING
*  tt_return      = me->gt_return.
RETURN.
  ENDMETHOD.
ENDCLASS.
