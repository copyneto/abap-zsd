"!<p>Classe utilizada para calculo e construção dos dados a serem persistidos na tabela no cenário especifico do Cockpit de Faturamento <strong>ZTSD_CICLO_PO</strong>
"!<p><strong>Autor:</strong> Schinaider Sá - Meta</p>
"!<p><strong>Data:</strong> 27/01/2022</p>
CLASS zclsd_dados_ciclo_pedido_fat DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_vbeln,
        vbeln TYPE vbap-vbeln,
      END OF ty_vbeln,

      tt_vbeln_list TYPE STANDARD TABLE OF ty_vbeln WITH EMPTY KEY,

      BEGIN OF ty_vbap_data,
        vbeln TYPE vbap-vbeln,
        route TYPE vbap-route,
      END OF ty_vbap_data,

      tt_vbap_data TYPE STANDARD TABLE OF ty_vbap_data WITH EMPTY KEY.


    "! Construtor
    METHODS constructor.

    "! Calculo do Ciclo de Pedido para Cockpit de Faturamento
    "! @parameter it_vbeln | Lista de Pedidos
    "! @raising zcxsd_ciclo_pedido | Mensagem de erro convertida em exceção
    METHODS calculate_cockpit_faturamento
      IMPORTING
        it_vbeln TYPE tt_vbeln_list
      RAISING
        zcxsd_ciclo_pedido.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      go_ciclo_po_updater  TYPE REF TO zclsd_update_ciclo_po_tab,
      go_ciclo_pedido_util TYPE REF TO zclsd_ciclo_pedido_util.

    "! Faz update na tabela ZTSD_CICLO_PO
    "! @parameter it_ciclo_po | Tabela Ciclo PO
    METHODS update_ciclo_po
      IMPORTING
        it_ciclo_po TYPE zttsd_ciclo_po.

    "! Seleciona VBAP para obter id da rota
    "! @parameter it_vbeln_list | Lista de Pedidos
    "! @parameter rt_result | Lista de Pedidos + rota
    METHODS select_vbap_data
      IMPORTING
        it_vbeln_list    TYPE tt_vbeln_list
      RETURNING
        VALUE(rt_result) TYPE tt_vbap_data.

ENDCLASS.

CLASS zclsd_dados_ciclo_pedido_fat IMPLEMENTATION.
  METHOD constructor.
    go_ciclo_po_updater = NEW #( ).
    go_ciclo_pedido_util = NEW #( ).
  ENDMETHOD.

  METHOD calculate_cockpit_faturamento.
    CONSTANTS:
      lc_evento_inicio_type    TYPE ze_evento VALUE 'X',
      lc_evento_aciona_estoque TYPE ze_even   VALUE '003'.

    DATA lt_table_update_ciclo_po TYPE zttsd_ciclo_po.
    DATA(lt_vbap) = select_vbap_data( it_vbeln ).

    LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>).
      APPEND LINES OF go_ciclo_pedido_util->build_ciclo_po(
        iv_ordem       = <fs_vbap>-vbeln
        iv_rota        = <fs_vbap>-route
        iv_data_evento = sy-datum
        iv_evento      = lc_evento_inicio_type
        iv_evento_i    = lc_evento_aciona_estoque
      ) TO lt_table_update_ciclo_po.
    ENDLOOP.

    update_ciclo_po( lt_table_update_ciclo_po ).
  ENDMETHOD.

  METHOD update_ciclo_po.
    go_ciclo_po_updater->update_ciclo_po_tab( it_ciclo_po ).
  ENDMETHOD.

  METHOD select_vbap_data.
    SELECT DISTINCT
      db_tab~vbeln,
      db_tab~route
      FROM vbap AS db_tab
      INNER JOIN @it_vbeln_list AS itab
        ON db_tab~vbeln = itab~vbeln
      ORDER BY db_tab~route
      INTO TABLE @rt_result.
  ENDMETHOD.

ENDCLASS.
