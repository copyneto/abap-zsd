FUNCTION zfmsd_adm_agendamento.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_LIKP) TYPE  LIKP
*"----------------------------------------------------------------------
  DATA lr_proxy TYPE REF TO zclsd_saga_remessa_update.
  lr_proxy ?= zclsd_saga_integracoes=>factory( iv_kind = |U| ).

  lr_proxy->set_data( iv_likp = iv_likp ).
  lr_proxy->zifsd_saga_integracoes~build( ).

  lr_proxy->zifsd_saga_integracoes~execute( ).

  IF sy-subrc EQ 0.
    COMMIT WORK.
  ENDIF.

ENDFUNCTION.
