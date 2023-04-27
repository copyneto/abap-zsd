FUNCTION zfmsd_saga_envio_pre_registro.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REMESSA) TYPE  VBELN
*"----------------------------------------------------------------------

  DATA(lo_object) = NEW zclsd_saga_envio_pre_registro( ).

  TRY .

      IF iv_remessa IS NOT INITIAL.
        lo_object->envio_registro( EXPORTING iv_remessa   = iv_remessa
                                   IMPORTING et_return    = DATA(lt_return) ).
      ENDIF.

    CATCH cx_mdg_missing_input_parameter INTO DATA(lo_catch). " Missing Input parameter in a method

      CALL FUNCTION 'RS_EXCEPTION_TO_BAPIRET2' "Convert Expection into Message
        EXPORTING
          i_r_exception = lo_catch             " cx_root       Abstract Superclass for All Global Exceptions
        CHANGING
          c_t_bapiret2  = lt_return.           " bapirettab    BW: Table with Messages (Application Log)

  ENDTRY.

ENDFUNCTION.
