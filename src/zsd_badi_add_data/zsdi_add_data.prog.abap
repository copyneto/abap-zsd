*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_DATA
*&---------------------------------------------------------------------*

    CALL METHOD fill_item_add
      EXPORTING
        is_header       = is_header
        it_nflin        = it_nflin
        it_vbrp         = it_vbrp
      CHANGING
        ct_traceability = et_traceability
        ct_item         = et_item.

    CALL METHOD fill_payment
      EXPORTING
        is_header  = is_header
        it_nflin   = it_nflin
        is_vbrk    = is_vbrk
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
*        it_vbrp     = it_vbrp
*      CHANGING
*        ct_add_info = et_add_info.

    CALL METHOD fill_text_ref_rem_simb
      EXPORTING
        is_header   = is_header
        it_nflin    = it_nflin
      CHANGING
        cs_header   = es_header
        ct_add_info = et_add_info.

    CALL METHOD fill_text_header_nf
      EXPORTING
        is_header          = is_header
        it_nflin           = it_nflin
        it_vbrp            = it_vbrp
        is_vbrk            = is_vbrk
        it_nfstx           = it_nfstx
        it_partner         = it_partner
        it_vbfa            = it_vbfa
      CHANGING
        cs_header          = es_header
        ct_itens_adicional = et_item
        ct_add_info        = et_add_info.

    CALL METHOD fill_modalidade_frete
      EXPORTING
        is_header = is_header
        it_nflin  = it_nflin
      CHANGING
        cs_header = es_header.

    CALL METHOD fill_trans_vol
      EXPORTING
        is_header   = is_header
        it_nflin    = it_nflin
        it_vbrp     = it_vbrp
      CHANGING
        cs_transvol = et_transvol
        cs_header   = es_header.

    NEW zclsd_diferimento_pr_sc( )->atualiza_valor_provisao_icms(
      EXPORTING
        it_itens_nf = it_nflin
        it_vbrp     = it_vbrp
      CHANGING
        ct_itens_adicional = et_item
    ).

    NEW zclmm_diferimento_pr_sc( )->atualiza_valor_provisao_icms(
      EXPORTING
        is_header   = is_header
        it_itens_nf = it_nflin
      CHANGING
        ct_itens_adicional = et_item
        cs_header          = es_header
    ).

    NEW zclsd_envio_xml( )->execute(
    EXPORTING
      is_header  = is_header
      it_partner = it_partner
      it_itens   = it_nflin
      it_vbrp    = it_vbrp
      IMPORTING
        et_add_info = et_add_info
      ).
