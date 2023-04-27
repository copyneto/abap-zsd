"Name: \PR:SAPLV50S\FO:TM_INT_FINALIZE\SE:BEGIN\EI
ENHANCEMENT 0 ZEI_TM_SKIP_TM_CHANGE_DELIVERY.
  DATA(lt_stack) = cl_abap_get_call_stack=>get_call_stack( ).
  LOOP AT lt_stack ASSIGNING FIELD-SYMBOL(<fs_stack_entry>).
    IF <fs_stack_entry>-program_info CS 'ZFGSD_COCKPIT_REMESSA' OR
       <fs_stack_entry>-program_info CS 'ZCLTM_SAGA_CONF_SEP_CARREG' OR
       <fs_stack_entry>-program_info CS 'ZLC_TESTE_UPDATE_DELIVERY'.
      DATA(lv_exit_process) = abap_true.
      EXIT.
    ENDIF.
  ENDLOOP.
  IF lv_exit_process = abap_true.
    RETURN.
  ENDIF.
ENDENHANCEMENT.
