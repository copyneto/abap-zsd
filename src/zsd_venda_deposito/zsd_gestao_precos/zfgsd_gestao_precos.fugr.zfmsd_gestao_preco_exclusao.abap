FUNCTION zfmsd_gestao_preco_exclusao.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DATA_IN) TYPE  DATS OPTIONAL
*"     VALUE(IV_DATA_FIM) TYPE  DATS OPTIONAL
*"     VALUE(IS_RECORD) TYPE  ZI_SD_LISTA_DE_PRECO
*"     VALUE(IS_NEWITEM) TYPE  ZI_SD_LISTA_DE_PRECO
*"     VALUE(IV_OP_TYPE) TYPE  CHAR5 OPTIONAL
*"     VALUE(IV_ALTERA_VIGENCIA) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_ALTERA_PERIODO) TYPE  CHAR1 OPTIONAL
*"     VALUE(IV_ALTERA_EXCLUSAO) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  TABLES
*"      IT_NEW_SCALE STRUCTURE  ZTSD_PRECO_I OPTIONAL
*"      IT_OLD_SCALE STRUCTURE  ZTSD_PRECO_I OPTIONAL
*"----------------------------------------------------------------------
*    it_old_scale TYPE zi_sd_lista_de_preco OPTIONAL.


  FREE et_return.
  DATA(lo_atual) = NEW zclsd_gestao_preco_exclusao( ).

  IF iv_altera_vigencia EQ abap_true.

    lo_atual->atualizar_vigencia(
    EXPORTING
        iv_data_in   = iv_data_in
        iv_data_fim  = iv_data_fim
        iv_op_type   = iv_op_type
        is_record    = is_record
        it_scale     = it_new_scale[]
        it_old_scale = it_old_scale[]
    IMPORTING
        et_return    = et_return
    CHANGING
        cs_newitem   = is_newitem ).

  ELSEIF iv_altera_periodo EQ abap_true.

    lo_atual->atualizar_periodo(
  EXPORTING
      iv_data_in   = iv_data_in
      iv_data_fim  = iv_data_fim
      iv_op_type   = iv_op_type
      is_record    = is_record
      it_scale     = it_new_scale[]
      it_old_scale = it_old_scale[]
  IMPORTING
      et_return = et_return
  CHANGING
      cs_newitem   = is_newitem ).

" INSERT - LSCHEPP - 07.08.2023
  ELSEIF iv_altera_exclusao EQ abap_true.

    lo_atual->exclusao_inclusao(
      EXPORTING
          iv_data_in   = iv_data_in
          iv_data_fim  = iv_data_fim
          iv_op_type   = iv_op_type
          is_record    = is_record
          is_newitem   = is_newitem
          it_scale     = it_new_scale[]
          it_old_scale = it_old_scale[]
      IMPORTING
          et_return = et_return ).
" INSERT - LSCHEPP - 07.08.2023

  ELSE.

    lo_atual->exclusao(
      EXPORTING
          iv_data_in   = iv_data_in
          iv_data_fim  = iv_data_fim
          iv_op_type   = iv_op_type
          is_record    = is_record
          is_newitem   = is_newitem
          it_scale     = it_new_scale[]""***Inclusão para ajuste card 8000007283
          it_old_scale = it_old_scale[]""***Inclusão para ajuste card 8000007283
      IMPORTING
          et_return = et_return ).

  ENDIF.

ENDFUNCTION.
