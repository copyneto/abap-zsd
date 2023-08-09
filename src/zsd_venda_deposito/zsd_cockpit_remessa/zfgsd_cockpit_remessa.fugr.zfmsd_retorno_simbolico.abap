FUNCTION zfmsd_retorno_simbolico.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REMESSA) TYPE  VBELN_VL OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA ls_header_data TYPE bapiobdlvhdrchg.
  DATA ls_header_control TYPE bapiobdlvhdrctrlchg.
  DATA lt_return TYPE TABLE OF bapiret2.
  DATA lv_value TYPE likp-lifsk.

  DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

  DATA(ls_parameter) = VALUE ztca_param_val( modulo = 'SD'
                                         chave1 = 'ADM_FATURAMENTO'
                                         chave2 = 'BLOQ_DF_AGUARDA' ).

  TRY.
      lo_param->m_get_single( EXPORTING iv_modulo = ls_parameter-modulo
                                        iv_chave1 = ls_parameter-chave1
                                        iv_chave2 = ls_parameter-chave2
                                        iv_chave3 = ls_parameter-chave3
                          IMPORTING ev_param  = lv_value ).
    CATCH zcxca_tabela_parametros.
  ENDTRY.

  ls_header_data-deliv_numb = iv_remessa.
  ls_header_data-dlv_block  = lv_value.

  ls_header_control-deliv_numb = iv_remessa.
  ls_header_control-dlv_block_flg = 'X'.

  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data    = ls_header_data
      header_control = ls_header_control
      delivery       = iv_remessa
    TABLES
      return         = lt_return.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.


  et_return = lt_return.



ENDFUNCTION.
