FUNCTION zfmsd_entrada_mercadoria.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GOODSMVT_HEADER) TYPE  BAPI2017_GM_HEAD_01 OPTIONAL
*"     VALUE(IV_GOODSMVT_CODE) TYPE  BAPI2017_GM_CODE OPTIONAL
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2
*"      ET_GOODSMVT_ITEM STRUCTURE  BAPI2017_GM_ITEM_CREATE
*"      ET_GOODSMVT_SERIALNUMBER STRUCTURE  BAPI2017_GM_SERIALNUMBER
*"----------------------------------------------------------------------

  gv_cockpit = abap_true.

  DATA: lv_check TYPE abap_bool VALUE abap_true.
  EXPORT lv_check FROM lv_check TO MEMORY ID 'ZMVT_CMM'.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header       = is_goodsmvt_header
      goodsmvt_code         = iv_goodsmvt_code
    TABLES
      goodsmvt_item         = et_goodsmvt_item
      goodsmvt_serialnumber = et_goodsmvt_serialnumber
      return                = et_return.

  CLEAR gv_cockpit.

  SORT et_return BY type.
  READ TABLE et_return TRANSPORTING NO FIELDS WITH KEY type = 'E' BINARY SEARCH.
  IF sy-subrc <> 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

    MESSAGE ID 'ZSD_COMODATO_LOC' TYPE 'S' NUMBER '007' INTO DATA(lv_msg_sucess).

    et_return[] = VALUE #( BASE et_return[] ( type    = 'S'
                                              id      = 'ZSD_COMODATO_LOC'
                                              number  = '007'
                                              message = lv_msg_sucess ) ).

  ENDIF.

ENDFUNCTION.
