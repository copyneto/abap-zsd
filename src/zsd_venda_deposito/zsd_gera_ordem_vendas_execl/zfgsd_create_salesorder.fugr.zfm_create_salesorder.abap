FUNCTION zfm_create_salesorder.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DADOS) TYPE  ZSCA_HEADER_PEDIDO_VENDA
*"  EXPORTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_TAB
*"  TABLES
*"      T_RETURN TYPE  BAPIRET2_TAB OPTIONAL
*"----------------------------------------------------------------------
  DATA: lt_log TYPE TABLE OF ztsd_logmsg_ov.

  NEW zclca_create_salesorder( )->main( EXPORTING iv_dados = iv_dados
                                        IMPORTING et_return = et_return ).

  LOOP AT et_return ASSIGNING FIELD-SYMBOL(<fs_return>).

    APPEND INITIAL LINE TO lt_log ASSIGNING FIELD-SYMBOL(<fs_log>).

    CALL FUNCTION 'GUID_CREATE'
      IMPORTING
        ev_guid_16 = <fs_log>-guid.

    <fs_log>-msgty             = <fs_return>-type.
    <fs_log>-msgid             = <fs_return>-id.
    <fs_log>-msgno             = <fs_return>-number.
    <fs_log>-msgv1             = <fs_return>-message_v1.
    <fs_log>-msgv2             = <fs_return>-message_v2.
    <fs_log>-msgv3             = <fs_return>-message_v3.
    <fs_log>-msgv4             = <fs_return>-message_v4.

    MESSAGE ID <fs_log>-msgid TYPE <fs_log>-msgty NUMBER <fs_log>-msgno
      WITH <fs_log>-msgv1 <fs_log>-msgv2 <fs_log>-msgv3 <fs_log>-msgv4
      INTO <fs_log>-message.

    APPEND <fs_return> TO t_return.

  ENDLOOP.

  IF lt_log[] IS NOT INITIAL.
    MODIFY ztsd_logmsg_ov FROM TABLE lt_log.
  ENDIF.

ENDFUNCTION.
