*&---------------------------------------------------------------------*
*& Include          ZSDI_ORDEM_FRETE
*&---------------------------------------------------------------------*
DATA: lo_dados_ciclo_pedido TYPE REF TO zclsd_dados_ciclo_pedido.

IF sy-uname EQ 'BCOSTA'.

  ASSIGN ('ls_mod-data->event_code') TO FIELD-SYMBOL(<fs_event_code>).

  ASSIGN ('ls_mod-data->actual_date') TO FIELD-SYMBOL(<fs_actual_date>).

  IF <fs_event_code> IS ASSIGNED.

    lo_dados_ciclo_pedido = NEW #( ).

    lo_dados_ciclo_pedido->calculo_ordem_frete(
      EXPORTING
        iv_key        = <ls_d_root>-key     " NodeID
        iv_date       = <fs_actual_date>    " Data do evento
        iv_event_code = <fs_event_code>     " Evento que ocorre durante uma atividade de transporte
        iv_evento     = abap_false          " Tipo de evento
    ).

  ENDIF.

ENDIF.
