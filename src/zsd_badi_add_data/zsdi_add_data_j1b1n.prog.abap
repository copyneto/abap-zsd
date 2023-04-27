*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_DATA_J1B1N
*&---------------------------------------------------------------------*

    CALL METHOD fill_item_add
      EXPORTING
        is_header = is_header
        it_nflin  = it_nflin
      CHANGING
        ct_item   = et_item.

    CALL METHOD fill_payment_j1b1n
      EXPORTING
        is_header  = is_header
        it_nflin   = it_nflin
      CHANGING
        ct_payment = et_payment.

    CALL METHOD fill_resp_tec
      EXPORTING
        is_header   = is_header
      CHANGING
        cs_tec_resp = es_tec_resp.

    CALL METHOD fill_import
      EXPORTING
        is_header    = is_header
        it_nflin     = it_nflin
        it_nfstx     = it_nfstx
        it_import_di = et_import_di
        it_nfftx     = it_nfftx
      CHANGING
        ct_add_info  = et_add_info
        cs_header    = es_header.

    CALL METHOD fill_text_lei_transparencia
      EXPORTING
        is_header    = is_header
        it_nflin     = it_nflin
        it_nfstx     = it_nfstx
        it_import_di = et_import_di
        it_nfftx     = it_nfftx
      CHANGING
        ct_add_info  = et_add_info
        cs_header    = es_header.

*    CALL METHOD fill_text_fatura
*      EXPORTING
*        is_header   = is_header
*        it_nflin    = it_nflin
*      CHANGING
*        ct_add_info = et_add_info.
*
    CALL METHOD fill_trans_vol
      EXPORTING
        is_header   = is_header
        it_nflin    = it_nflin
      CHANGING
        cs_transvol = et_transvol
        cs_header   = es_header.

    CALL METHOD fill_text_header_nf
      EXPORTING
        is_header          = is_header
        it_nflin           = it_nflin
*       it_vbrp            = it_vbrp
        it_nfstx           = it_nfstx
        it_partner         = it_partner
        it_nfftx           = it_nfftx
        it_nfref           = it_nfref
      CHANGING
        cs_header          = es_header
        ct_itens_adicional = et_item.
