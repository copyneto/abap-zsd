FUNCTION zfmsd_ckpt_fat_gerar_remessa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SALES_ORDER) TYPE  VBAK-VBELN
*"     VALUE(IV_BLOCK_DELIVERY) TYPE  ABAP_BOOLEAN
*"  EXPORTING
*"     VALUE(EV_DELIVERY_NO) TYPE  LIKP-VBELN
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA(lo_gerar_remessa) = NEW zclsd_ckpt_fat_gera_remessa( ).

  lo_gerar_remessa->call_bapi_create(
    EXPORTING
      iv_sales_order    = iv_sales_order
      iv_block_delivery = iv_block_delivery
    IMPORTING
      ev_delivery_no    = ev_delivery_no
      et_return         = et_return
  ).

ENDFUNCTION.
