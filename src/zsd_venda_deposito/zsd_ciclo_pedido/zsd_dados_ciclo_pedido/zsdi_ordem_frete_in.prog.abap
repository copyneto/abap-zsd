*&---------------------------------------------------------------------*
*& Include          ZSDI_ORDEM_FRETE_IN
*&---------------------------------------------------------------------*
DATA: lo_dados_ciclo_pedido TYPE REF TO zclsd_dados_ciclo_pedido.

*IF sy-uname EQ 'BCOSTA'.
*
*  ASSIGN ('ls_mod-data->actual_date') TO FIELD-SYMBOL(<fs_actual_date>).
*
*  IF <ls_root>-key IS NOT INITIAL.
*
*    lo_dados_ciclo_pedido = NEW #( ).
*
*    lo_dados_ciclo_pedido->calculo_ordem_frete(
*      EXPORTING
*        iv_key        = <ls_root>-key       " NodeID
*        iv_date       = <fs_actual_date>    " Data do evento
*        iv_event_code = space               " Evento que ocorre durante uma atividade de transporte
*        iv_evento     = abap_true           " Tipo de evento
*    ).
*
*  ENDIF.
*
*ENDIF.
