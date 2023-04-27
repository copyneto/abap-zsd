FUNCTION zfmsd_saida_mercadoria_inter.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_REMESSA) TYPE  ZTSD_REMESSA
*"  TABLES
*"      ET_RETURN TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  CONSTANTS lc_vl09 TYPE sy-tcode VALUE 'VL09'.
  DATA lt_mesg      TYPE mesg_t.

  LOOP AT it_remessa INTO DATA(ls_remessa).

*---Reversing goods movement document (Transaction VL09)
    CALL FUNCTION 'WS_REVERSE_GOODS_ISSUE'
      EXPORTING
        i_vbeln                   = ls_remessa-vbeln
        i_budat                   = sy-datum
        i_tcode                   = lc_vl09
        i_vbtyp                   = ls_remessa-vbtyp
      TABLES
        t_mesg                    = lt_mesg
      EXCEPTIONS
        error_reverse_goods_issue = 1
        OTHERS                    = 2.

    IF sy-subrc = 0.
*---commit
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      APPEND VALUE #( type = 'S' id = 'ZSD_INTERCOMPANY' number = '047' message_v1 = ls_remessa-vbeln  ) TO et_return.

    ELSE.
      APPEND VALUE #( type = 'S' id = 'ZSD_INTERCOMPANY' number = '048' message_v1 = ls_remessa-vbeln  ) TO et_return.
    ENDIF.
  ENDLOOP.




ENDFUNCTION.
