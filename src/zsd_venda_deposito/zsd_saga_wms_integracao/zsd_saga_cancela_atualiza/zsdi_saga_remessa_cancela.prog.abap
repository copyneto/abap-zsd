*&---------------------------------------------------------------------*
*& Include          ZSDI_SAGA_REMESSA_CANCELA
*&---------------------------------------------------------------------*

DATA lr_proxy TYPE REF TO zclsd_saga_remessa_cancel.
lr_proxy ?= zclsd_saga_integracoes=>factory( iv_kind = |C| ).

lr_proxy->set_data( iv_likp = likp ).
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Início
IF NOT lr_proxy->check_sent( ) IS INITIAL.
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Fim
  lr_proxy->zifsd_saga_integracoes~build( ).

  lr_proxy->zifsd_saga_integracoes~execute( ).
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Início
ENDIF.
* LSCHEPP - 8000006844 - Erro Saga - EnviarCancelarAtualizarRemes - 02.05.2023 Fim
