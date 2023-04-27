*&---------------------------------------------------------------------*
*& Include          ZSDI_CONDICAO_CONTRATO
*&---------------------------------------------------------------------*
DATA: lv_data_base TYPE dzfbdt.
DATA(lo_condicao_contrato) = NEW zclsd_condicao_contrato( ).

lv_data_base = lo_condicao_contrato->calcular_data_base( EXPORTING iv_kunnr  = cvbrk-kunag
                                                                   iv_vkorg  = cvbrk-vkorg
                                                                   iv_vtweg  = cvbrk-vtweg
                                                                   iv_spart  = cvbrk-spart
                                                                   iv_vbeln  = cvbrk-vbeln
                                                                   iv_aubel  = cvbrk-vbeln
                                                                   it_vbrpvb = cvbrp[]
                                                         CHANGING  ct_xaccit = xaccit[]
                                                                   ct_doc_uuid_h = lt_uuid ).

*IF lv_data_base IS NOT INITIAL.
*
*  LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_item>).
*    <fs_item>-zfbdt = lv_data_base.
*    <fs_item>-zbd1t = 0.
*    <fs_item>-zbd2t = 0.
*  ENDLOOP.
*ENDIF.

"Calcular a taxa
lo_condicao_contrato->calcular_taxa_item( EXPORTING iv_kunnr      = cvbrk-kunag
                                                    iv_vkorg      = cvbrk-vkorg
                                                    iv_vtweg      = cvbrk-vtweg
                                                    iv_spart      = cvbrk-spart
                                                    iv_vbeln      = cvbrk-vbeln
                                                    iv_vbtyp      = cvbrk-vbtyp
                                                    it_vbrpvb     = cvbrp[]
                                          CHANGING  ct_xaccit     = xaccit[]
                                                    ct_xacccr     = xacccr[]
                                                    ct_doc_uuid_h = lt_uuid ).
