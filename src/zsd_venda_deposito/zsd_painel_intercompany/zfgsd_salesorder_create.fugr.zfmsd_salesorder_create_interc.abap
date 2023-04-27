FUNCTION zfmsd_salesorder_create_interc .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_ORDER_HEADER_IN) LIKE  BAPISDHD1 STRUCTURE  BAPISDHD1
*"     VALUE(IS_ORDER_HEADER_INX) LIKE  BAPISDHD1X STRUCTURE
*"        BAPISDHD1X OPTIONAL
*"     VALUE(IV_GUID) TYPE  SYSUUID_X16 OPTIONAL
*"     VALUE(IV_CONTINUAR) TYPE  CHAR1 OPTIONAL
*"  EXPORTING
*"     VALUE(EV_SALESDOCUMENT) LIKE  BAPIVBELN-VBELN
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"      ET_ORDER_ITEMS_IN STRUCTURE  BAPISDITM OPTIONAL
*"      ET_ORDER_ITEMS_INX STRUCTURE  BAPISDITMX OPTIONAL
*"      ET_ORDER_PARTNERS STRUCTURE  BAPIPARNR
*"      ET_ORDER_SCHEDULES_IN STRUCTURE  BAPISCHDL OPTIONAL
*"      ET_ORDER_SCHEDULES_INX STRUCTURE  BAPISCHDLX OPTIONAL
*"      ET_ORDER_TEXT STRUCTURE  BAPISDTEXT OPTIONAL
*"      ET_EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"----------------------------------------------------------------------
  CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
    EXPORTING
      order_header_in     = is_order_header_in
      order_header_inx    = is_order_header_inx
    IMPORTING
      salesdocument       = ev_salesdocument
    TABLES
      return              = et_return
      order_items_in      = et_order_items_in
      order_items_inx     = et_order_items_inx
      order_partners      = et_order_partners
      order_schedules_in  = et_order_schedules_in
      order_schedules_inx = et_order_schedules_inx
      order_text          = et_order_text
      extensionin         = et_extensionin.

  IF ev_salesdocument IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

  CHECK ev_salesdocument IS NOT INITIAL.

  IF iv_continuar IS INITIAL.

    UPDATE ztsd_intercompan SET salesorder = ev_salesdocument
      WHERE guid = iv_guid.


  ELSE.

    UPDATE ztsd_intercompan SET salesorder2 = ev_salesdocument
      WHERE guid = iv_guid.

    SELECT SINGLE *
           INTO @DATA(ls_inter)
    FROM ztsd_intercompan
    WHERE guid = @iv_guid.

    IF sy-subrc = 0.
      "cria linha nova para a segunta etapa
      LS_INTER-SALESORDER    = ev_salesdocument.
      ls_inter-tipooperacao  = 'INT1'. "INTERCOMPANY NORMAL
      ls_inter-werks_origem  = ls_inter-werks_destino.
      ls_inter-lgort_origem  = ls_inter-lgort_destino.
      ls_inter-werks_destino = ls_inter-werks_receptor.
      ls_inter-GUID          =   NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).

      CLEAR: ls_inter-purchaseorder,
             ls_inter-remessa,
             ls_inter-br_notafiscal,
             ls_inter-ztraid,
             ls_inter-salesorder2,
             ls_inter-purchaseorder2,
             ls_inter-remessa_origem,
             ls_inter-werks_receptor.

      "INSERE LINHA DA SEGUNDA ETAPA
      MODIFY ztsd_intercompan FROM ls_inter.
      CLEAR: ls_inter.


    ENDIF.

  ENDIF.
ENDFUNCTION.
