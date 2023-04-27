FUNCTION zfmsd_atualizacao_remessa.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_REMESSA) TYPE  VBKOK-VBELN_VL
*"     VALUE(IV_VOLUME) TYPE  VBKOK-ANZPK
*"     VALUE(IT_ITENS) TYPE  ZCTGSD_RFC_ITEM_REMESSA
*"  EXPORTING
*"     VALUE(ES_RETORNO) TYPE  ZSSD_RFC_ITEM_REMESSA_RETORNO
*"--------------------------------------------------------------------
  DATA : lt_vbpok    TYPE TABLE OF vbpok,
         ls_vbkok    TYPE vbkok,
         lv_delivery TYPE likp-vbeln.

  DATA: lv_error  TYPE  xfeld.

  DATA: lv_error_any_0              TYPE  xfeld,
        lv_error_in_item_deletion_0 TYPE  xfeld,
        lv_error_in_pod_update_0    TYPE  xfeld,
        lv_error_in_interface_0     TYPE  xfeld,
        lv_error_in_goods_issue_0   TYPE  xfeld,
        lv_error_in_final_check_0   TYPE  xfeld,
        lv_error_partner_update     TYPE  xfeld,
        lv_error_sernr_update       TYPE  xfeld.


  ls_vbkok-vbeln_vl = iv_remessa.
  ls_vbkok-vbeln    = iv_remessa.
  ls_vbkok-wabuc    = 'X'.
  ls_vbkok-kzapk    = 'X'.
  ls_vbkok-anzpk    = iv_volume.
  ls_vbkok-kzntg    = 'X'.
  lv_delivery       = iv_remessa.

  LOOP AT it_itens ASSIGNING FIELD-SYMBOL(<fs_ITENS>).
    APPEND INITIAL LINE TO lt_vbpok ASSIGNING FIELD-SYMBOL(<fs_vbpok>).

    <fs_vbpok>-vbeln_vl  = iv_remessa.
    <fs_vbpok>-posnr_vl  = <fs_ITENS>-id_item.
    <fs_vbpok>-vbeln     = iv_remessa.
    <fs_vbpok>-posnn     = <fs_ITENS>-id_item.
    <fs_vbpok>-pikmg     = <fs_ITENS>-qtd_pikmg.
    <fs_vbpok>-charg     = <fs_ITENS>-nr_lote.
  ENDLOOP.

  CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
    EXPORTING
      vbkok_wa                  = ls_vbkok
      synchron                  = abap_true
      commit                    = abap_true
      delivery                  = lv_delivery
      update_picking            = abap_true
      nicht_sperren_1           = abap_true
      if_database_update_1      = '1'
    IMPORTING
      ef_error_any              = lv_error_any_0
      ef_error_in_item_deletion = lv_error_in_item_deletion_0
      ef_error_in_pod_update    = lv_error_in_pod_update_0
      ef_error_in_interface     = lv_error_in_interface_0
      ef_error_in_goods_issue   = lv_error_in_goods_issue_0
      ef_error_in_final_check   = lv_error_in_final_check_0
      ef_error_partner_update   = lv_error_partner_update
      ef_error_sernr_update     = lv_error_sernr_update
    TABLES
      vbpok_tab                 = lt_vbpok
    EXCEPTIONS
      error_message             = 4.


  IF sy-subrc EQ 4.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO es_retorno-mensagem.
    es_retorno-tipo = 'E'.

    else.

    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO es_retorno-mensagem.
    es_retorno-tipo = 'S'.

  ENDIF.



ENDFUNCTION.
