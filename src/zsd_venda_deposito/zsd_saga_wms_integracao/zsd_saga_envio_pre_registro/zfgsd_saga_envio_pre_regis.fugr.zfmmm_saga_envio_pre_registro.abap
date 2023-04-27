FUNCTION zfmmm_saga_envio_pre_registro.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REMESSA) TYPE  VBELN
*"     VALUE(IV_XBLNR) TYPE  XBLNR OPTIONAL
*"     VALUE(IV_INNFEHD) TYPE  /XNFE/INNFEHD OPTIONAL
*"     VALUE(IV_EBELN) TYPE  EBELN OPTIONAL
*"     VALUE(IV_ENTREGA) TYPE  /SCMTMS/BASE_BTD_TCO OPTIONAL
*"----------------------------------------------------------------------
  TRY .

      IF iv_remessa IS NOT INITIAL.
        NEW zclmm_saga_envio_pre_registro( )->envio_registro(
                                    EXPORTING
                                        iv_remessa          = iv_remessa
                                        is_innfehd          = iv_innfehd
                                        iv_xblnr            = iv_xblnr
                                        iv_ebeln            = iv_ebeln
                                        iv_item_btd_entrega = iv_entrega
                                   IMPORTING
                                        et_return    = DATA(lt_return) ).
      ENDIF.

    CATCH cx_mdg_missing_input_parameter INTO DATA(lo_catch). " Missing Input parameter in a method

      CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2' "Convert Expection into Message
        EXPORTING
          i_r_exception = lo_catch             " cx_root       Abstract Superclass for All Global Exceptions
        CHANGING
          c_t_bapiret2  = lt_return.           " bapirettab    BW: Table with Messages (Application Log)

  ENDTRY.

ENDFUNCTION.
