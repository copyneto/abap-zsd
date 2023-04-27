FUNCTION zfmsd_cockpit_remessa_roadnet.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_VBELN) TYPE  VBELN_VL_T OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

  lo_events->roadnet_session( EXPORTING it_vbeln  = it_vbeln
                              IMPORTING et_return = et_return ).

ENDFUNCTION.
