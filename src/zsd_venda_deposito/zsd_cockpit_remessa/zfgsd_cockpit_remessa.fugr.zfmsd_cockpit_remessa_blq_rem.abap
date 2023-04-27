FUNCTION zfmsd_cockpit_remessa_blq_rem.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  LIKP-VBELN
*"     VALUE(IV_LIFSK) TYPE  LIKP-LIFSK
*"     VALUE(IV_DELETE) TYPE  LIKP_DEL OPTIONAL
*"     VALUE(IV_BACKGROUND) TYPE  FLAG OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

  lo_events->delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_lifsk  = iv_lifsk
                                       iv_delete = iv_delete
                             IMPORTING et_return = et_return ).

  IF iv_background = abap_true.
    lo_events->save_delivery_log(
      iv_vbeln  = iv_vbeln
      it_return = et_return
    ).
  ENDIF.

ENDFUNCTION.
