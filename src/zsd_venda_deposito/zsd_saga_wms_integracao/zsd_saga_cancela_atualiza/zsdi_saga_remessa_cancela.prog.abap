*&---------------------------------------------------------------------*
*& Include          ZSDI_SAGA_REMESSA_CANCELA
*&---------------------------------------------------------------------*

DATA lr_proxy type ref to zclsd_saga_remessa_cancel.
lr_proxy ?= zclsd_saga_integracoes=>factory( iv_kind = |C| ).

lr_proxy->set_data( iv_likp = likp ).
lr_proxy->zifsd_saga_integracoes~build( ).

lr_proxy->zifsd_saga_integracoes~execute( ).
