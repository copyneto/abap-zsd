FUNCTION zfmsd_outb_delivery_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADER_DATA) TYPE  BAPIOBDLVHDRCHG
*"     VALUE(IS_HEADER_CONTROL) TYPE  BAPIOBDLVHDRCTRLCHG OPTIONAL
*"     VALUE(IV_DELIVERY) TYPE  BAPIOBDLVHDRCHG-DELIV_NUMB OPTIONAL
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  CONSTANTS: lc_erro TYPE sy-msgty VALUE 'E'.

  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data    = is_header_data
      header_control = is_header_control
      delivery       = iv_delivery
    TABLES
      return         = et_return.

  IF NOT line_exists( et_return[ type = lc_erro ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDIF.

ENDFUNCTION.
