FUNCTION zfmsd_ckpt_fat_mod_remessa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADER_DATA) TYPE  BAPIOBDLVHDRCHG
*"     VALUE(IS_HEADER_CONTROL) TYPE  BAPIOBDLVHDRCTRLCHG
*"     VALUE(IV_DELIVERY_NO) TYPE  LIKP-VBELN
*"  EXPORTING
*"     VALUE(EV_DELIVERY_NO) TYPE  LIKP-VBELN
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  TABLES
*"      TT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
*  DATA lv_remessa  TYPE likp-vbeln.

*  WHILE lv_remessa IS INITIAL.
*    SELECT SINGLE vbeln
*      FROM likp
*      INTO lv_remessa
*      WHERE vbeln EQ iv_delivery_no.
*  ENDWHILE.
*
*  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
*    EXPORTING
*      header_data    = is_header_data
*      header_control = is_header_control
*      delivery       = iv_delivery_no
*    TABLES
*      return         = tt_return.
*
*  IF sy-subrc = 0.
*    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*      EXPORTING
*        wait = abap_true.
*  ENDIF.
RETURN.
ENDFUNCTION.
