FUNCTION ZFMSD_COCKPIT_DEVOL_BLQ_REM.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  LIKP-VBELN
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_events) = NEW zclsd_desbloqueia_ov_devolucao( ).

  lo_events->delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                             IMPORTING et_return = et_return ).

ENDFUNCTION.
