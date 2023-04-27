FUNCTION zfmsd_monitor_gerar_ordemfrete.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REMESSA) TYPE  LIKP-VBELN
*"     VALUE(IV_UNIDADE_FRETE) TYPE  /SCMTMS/TOR_ID
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAL_T_MSGR
*"----------------------------------------------------------------------
  DATA(lo_gerar_of) = NEW zcltm_process_of( ).

  CALL METHOD lo_gerar_of->execute
    EXPORTING
      ir_num_fu   = VALUE #( ( sign = 'I' option = 'EQ' low = iv_unidade_frete ) )
      ir_remessas = VALUE #( ( sign = 'I' option = 'EQ' low = iv_remessa ) ).

  et_return = lo_gerar_of->read_log( )."#EC CI_CONV_OK

ENDFUNCTION.
