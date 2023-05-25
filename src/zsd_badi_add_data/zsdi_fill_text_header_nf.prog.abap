*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_TEXT_HEADER_NF
*&---------------------------------------------------------------------*
   " Declarações variáveis locais
   INCLUDE zsdi_add_client_text_top IF FOUND.

   IF gv_manual EQ abap_true AND sy-tcode EQ lc_j1b2n.
     "Tratamento para não duplicar infadprod
     CLEAR ct_itens_adicional.
   ENDIF.

   IF gv_manual EQ abap_true.
*     ASSIGN ('(SAPLJ1BB2)WK_HEADER_MSG[]') TO <fs_nfetx_tab>.
     ASSIGN ('(SAPLJ1BB2)WK_FTX[]')        TO <fs_nfetx_tab>.
     ASSIGN ('(SAPLJ1BB2)W_ITEM_TAX[]')    TO <fs_wnfstx_tab>.
     ASSIGN ('(SAPLJ1BB2)WK_HEADER')       TO <fs_wk_header>.
   ENDIF.

   IF <fs_wk_header> IS ASSIGNED AND
      <fs_wk_header>-land1 NE 'BR'.
     <fs_wk_header>-foreignid = '999.999.999'.
   ENDIF.

   ASSIGN ('(SAPLJ1BG)WNFFTX[]') TO <fs_nfetx_tab>.
   IF NOT <fs_nfetx_tab> IS ASSIGNED.
     ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.
   ENDIF.

   ASSIGN ('(SAPLJ1BG)wnfstx[] ') TO <fs_wnfstx_tab>.
   IF <fs_wnfstx_tab> IS ASSIGNED.
     DATA(lt_wnfstx_tab) = <fs_wnfstx_tab>.
     SORT lt_wnfstx_tab BY docnum itmnum taxtyp.
   ENDIF.

   "Atualiza tag INFCPL
   IF <fs_nfetx_tab> IS ASSIGNED.
     LOOP AT <fs_nfetx_tab> ASSIGNING FIELD-SYMBOL(<fs_nfetx>).
       SEARCH cs_header-infcpl FOR <fs_nfetx>-message .
       IF sy-subrc NE 0.
         cs_header-infcpl = |{ cs_header-infcpl }  { <fs_nfetx>-message }|.
       ENDIF.
     ENDLOOP.
   ENDIF.

   "Texto direito fiscal no cabeçalho - DLIMA
   INCLUDE zmmi_direito_fiscal IF FOUND.

   "Texto Cliente
   INCLUDE zsdi_add_client_text IF FOUND.

   "Texto Fatura
   INCLUDE zsdi_fill_text_fatura IF FOUND.

   "Texto Ordem de Frete
   INCLUDE zsdi_add_ordem_frete_text IF FOUND.

   "Texto Local de Negócios
   INCLUDE zsdi_add_local_negocios IF FOUND.

   IF <fs_nfetx_tab> IS ASSIGNED.
     lt_nfetx = <fs_nfetx_tab>.
     SORT lt_nfetx BY seqnum DESCENDING.
   ENDIF.

* LSCHEPP - SD - 8000007675 - Junç itens Mens diferid e bc icms incorr - 24.05.2023 Início
   REFRESH: lt_mont_dif,
            lt_fcp_values.
   LOOP AT it_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin1>).
     INCLUDE zsdi_calc_montante_diferido IF FOUND.
* LSCHEPP - SD - 8000007840 - Quebra de lote - Total FCP e reembolso - 24.05.2023 Início
     INCLUDE zsdi_soma_add_fcp_text IF FOUND.
* LSCHEPP - SD - 8000007840 - Quebra de lote - Total FCP e reembolso - 24.05.2023 Fim
   ENDLOOP.
   SORT lt_mont_dif BY matnr.
   SORT lt_fcp_values BY itmnum taxtyp.
* LSCHEPP - SD - 8000007675 - Junç itens Mens diferid e bc icms incorr - 24.05.2023 Fim

   DATA(lt_nflin_group_batch) = it_nflin.
   DATA(lt_itens_adicional) = ct_itens_adicional.

   IF is_header-land1 = 'BR' AND
       check_coligada( is_header ) IS INITIAL.
     DATA(ls_nflin_index1) = VALUE #( it_nflin[ 1 ] OPTIONAL ).

     IF ls_nflin_index1-itmtyp <> '2'.

       SORT lt_nflin_group_batch BY docnum matnr itmnum.
       DELETE ADJACENT DUPLICATES FROM lt_nflin_group_batch COMPARING docnum matnr.
       SORT lt_nflin_group_batch BY docnum itmnum.

       LOOP AT lt_nflin_group_batch INTO DATA(ls_nflin_group_batch).
         READ TABLE lt_itens_adicional ASSIGNING FIELD-SYMBOL(<fs_item_adicional_x>) WITH KEY itmnum = ls_nflin_group_batch-itmnum BINARY SEARCH..
         IF sy-subrc <> 0.
           CONTINUE.
         ENDIF.
         LOOP AT it_nflin INTO DATA(ls_nflin_batch) WHERE docnum = ls_nflin_group_batch-docnum
                                                      AND matnr  = ls_nflin_group_batch-matnr.
           LOOP AT  lt_itens_adicional INTO DATA(ls_item_adicional) WHERE itmnum = ls_nflin_batch-itmnum.
             IF sy-subrc = 0.
               IF ls_nflin_group_batch-itmnum <> ls_nflin_batch-itmnum.
                 <fs_item_adicional_x>-vbcstret  = <fs_item_adicional_x>-vbcstret  + ls_item_adicional-vbcstret.
                 <fs_item_adicional_x>-vbcefet   = <fs_item_adicional_x>-vbcefet   + ls_item_adicional-vbcefet.
               ENDIF.
             ENDIF.
           ENDLOOP.
         ENDLOOP.
       ENDLOOP.
       LOOP AT lt_itens_adicional INTO ls_item_adicional.
         DATA(li_tabix_add) = sy-tabix.
         IF NOT line_exists( lt_nflin_group_batch[ itmnum = ls_item_adicional-itmnum ] ).
           DELETE lt_itens_adicional INDEX li_tabix_add.
         ENDIF.
       ENDLOOP.
     ENDIF.
   ENDIF.

   LOOP AT lt_nflin_group_batch ASSIGNING FIELD-SYMBOL(<fs_nflin>).
     DATA(lv_line_item) = sy-tabix.

     IF <fs_nflin>-itmnum = lc_itmnum.
       DATA(lv_motdesicms) = <fs_nflin>-motdesicms.
     ENDIF.

     "Texto Item/Cest/ExtIPI
     INCLUDE zsdi_add_cest_ext_ipi IF FOUND.

     "Textos leis Infadprod para nota manual
     IF gv_manual EQ abap_true AND sy-tcode NE lc_j1b2n.
       INCLUDE zsdi_get_tax_messages IF FOUND.
     ENDIF.

     "Ajuste texto longo Direito Fiscal ICMS
     IF gv_manual EQ abap_true AND sy-tcode EQ lc_j1b2n.
       INCLUDE zsdi_texto_dir_fiscal_icms IF FOUND.
     ENDIF.

     "Texto reembolso Infadprod
     INCLUDE zsdi_add_tax_cst60_f03 IF FOUND.
     "Texto FCP Infadprod
     INCLUDE zsdi_add_fcp_text IF FOUND.
     "Textos Valores efetivos Infadprod
     INCLUDE zsdi_add_valefet_text IF FOUND.
     "Textos Infadprod sem caracter espcial para MT
     INCLUDE zsdi_caracter_especiais_item IF FOUND.
     "Texto ICMS Desonerado
*    **     INCLUDE zsdi_fill_text_icms_deson IF FOUND.

     INCLUDE zsdi_add_text_deposito_fechado IF FOUND.

   ENDLOOP.



   "Texto FCP Infcpl
   INCLUDE zsdi_add_fcp_infcpl IF FOUND.

   " Texto Montante Total
   INCLUDE zsdi_add_mont_total_text IF FOUND.

   "Texto de zona franca
   INCLUDE zsdi_add_zona_franca_text IF FOUND.

   " Sintese de mensagem: Local de entrega
   INCLUDE zsdi_add_delivery_location IF FOUND.

   "Texto Emenda Constitucional 87/2015
   INCLUDE zsdi_add_emenda_constitucional IF FOUND.

   "Textos infCpl sem caracter espcial para MT
   INCLUDE zsdi_caracter_especiais_header IF FOUND.

   "Textos infCpl informacões de pauta
   INCLUDE zsdi_add_inf_pauta_infcpl IF FOUND.

   "Textos infCpl informacões imobilizado
   INCLUDE zsdi_add_imobilizado_infcpl IF FOUND.

   "Textos infCpl informacões número do pedido
   INCLUDE zsdi_add_numero_pedido IF FOUND.

   "Textos infCpl ordens de consignação
   INCLUDE zsdi_add_ordens_consig IF FOUND.

   "Atualiza tag Infadfisco
   INCLUDE zsdi_atualiza_infadfisco IF FOUND.

   "Preenche impostos
   INCLUDE zsdi_impostos IF FOUND.

   "Tratativa da tag indintermed para os casos de nota complementar.
   INCLUDE zsdi_nota_complementar IF FOUND.

   " Preenchimento da agenda do cliente
   INCLUDE zsdi_agendamento_cliente IF FOUND.

   "Textos infCpl informacões Kit de bonificação.
   INCLUDE zsdi_add_kit_bon_infcpl IF FOUND.

   "Textos infCpl informacões Regime Especial MG.
   INCLUDE zsdi_regime_especial_mg IF FOUND.

   "Textos infCpl intercompany transferência.
   INCLUDE zmmi_add_intercompany_infcpl IF FOUND.

* LSCHEPP - 8000006221 - [TI-C1-03.VENDA NAC]-ERRO NO DANFE x XML - 13.03.2023 Início
***   INCLUDE zmmi_fill_text_subc IF FOUND.
* LSCHEPP - 8000006221 - [TI-C1-03.VENDA NAC]-ERRO NO DANFE x XML - 13.03.2023 Fim

   INCLUDE zmmi_fill_text_mm IF FOUND.

   INCLUDE zmmi_add_text_deposito_fechado IF FOUND.

   INCLUDE zsdi_motivo_devolucao IF FOUND.

   INCLUDE zsdi_infadfisco_infcpl IF FOUND.

   INCLUDE zsdi_dados_certif_infcpl IF FOUND.

   INCLUDE zsdi_dados_ecommerce_infcpl IF FOUND.

   INCLUDE zmmi_imobilizado_infcpl IF FOUND.

   CONDENSE cs_header-infcpl.
