FUNCTION zfmsd_atualizar_vig.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA_IN) TYPE  DATS OPTIONAL
*"     VALUE(IV_DATA_FIM) TYPE  DATS OPTIONAL
*"     VALUE(IS_RECORD) TYPE  ZSSD_ATUAL_VIG
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
 FREE et_return.
  DATA(lo_atual) = NEW zclsd_atual_vig_methods( ).

  lo_atual->atualizar(
    EXPORTING
        iv_data_in   = iv_data_in
        iv_data_fim  = iv_data_fim
        is_record    = is_record
    IMPORTING
        et_return = et_return ).

ENDFUNCTION.
