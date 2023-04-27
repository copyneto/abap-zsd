@EndUserText.label: 'Administrar Bonificação de Kits'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_KIT_BON_APP
  as projection on ZI_SD_KIT_BON_APP as Monitor
{
          @EndUserText.label: 'Competência'
  key     competencia,
          @EndUserText.label: 'Centro'
  key     Plant,
          @EndUserText.label: 'Documento Material'
  key     DocKit,
          @EndUserText.label: 'Material (KIT)'
          //       @ObjectModel.text.element: ['MaterialName_kit']
          @Consumption.valueHelpDefinition: [
            { entity:  { name:    'ZI_SD_KIT_BON_KITS',
                         element: 'Matnr' }
            }]
  key     MatnrKit,
          @EndUserText.label: 'Material (Gratuito)'
          //       @ObjectModel.text.element: ['MaterialName_free']
  key     MatnrFree,
          @EndUserText.label: 'Emissor da Ordem'
  key     kunnr,
          @EndUserText.label: 'Número Item'
  key     Posnr,
          @EndUserText.label: 'Nfe Retorno'
  key     NfRetorno,    
          @EndUserText.label: 'Ordem do Cliente'
          @Consumption.semanticObject: 'SalesDocument'
          Vbeln,
          @EndUserText.label: 'Data Lançamento Doc. Mat'
          PostingDate,
          @EndUserText.label: 'Unidade de medida básica (UMB)'
          BaseUnit,
          @EndUserText.label: 'Emissor da ordem'
          EntryUnit,
          @EndUserText.label: 'Quantidade'
          QuantityInEntryUnit,
          @EndUserText.label: 'Moeda'
          CompanyCodeCurrency,
          @EndUserText.label: 'Montante em MI'
          TotalGoodsMvtAmtInCCCrcy,
          @EndUserText.label: 'Ordem de produção'
          ManufacturingOrder,
          @EndUserText.label: 'Tipo de Movimento'
          GoodsMovementType,
          @EndUserText.label: 'OV Criado por'
          CreatedBy,
          @EndUserText.label: 'Data Criação Ordem do Cliente'
          CreatedAt,
          @EndUserText.label: 'Modificado por'
          LastChangedBy,
          @EndUserText.label: 'Modificado em'
          LastChangedAt,
          @EndUserText.label: 'Modificado em'
          LocalLastChangedAt,
          @EndUserText.label: 'Documento de Faturamento'
          SubsequentDocument,
          @EndUserText.label: 'Nota Fiscal'
          NotaFiscal,
          //@EndUserText.label: 'Nfe Retorno'
          //NfRetorno,
          @EndUserText.label: 'Status Nfe Retorno'
          @ObjectModel.text.element: ['NfRetorno_Stt_text']
          NfRetorno_Status,
          @EndUserText.label: 'Status Retorno de Saída Desc'
          _I_BR_NFeDocStatusTxt_NF_E.BR_NFeDocumentStatusDesc as NfRetorno_Stt_text,
          @EndUserText.label: 'Valor do ICMS'
          vlricms,
          @EndUserText.label: 'Base do ICMS'
          baseicms,
          @EndUserText.label: 'Valor do ICMS-ST'
          vlricss,
          @EndUserText.label: 'Base do ICMS-ST'
          baseicss,
          @EndUserText.label: 'Valor do IPI'
          vlripi,
          @EndUserText.label: 'Base do IPI'
          baseipi,
          @EndUserText.label: 'Status NF de Saída'
          @ObjectModel.text.element: ['NfNota_Stt_text']
          BR_NFeDocumentStatus,
          @EndUserText.label: 'Status NF de Saída Desc'
          _I_BR_NFeDocStatusTxt_NF.BR_NFeDocumentStatusDesc as NfNota_Stt_text,
          @EndUserText.label: 'Data da Emissão da Nota'
          BR_NFPostingDate,
          @EndUserText.label: 'Vlr da Nota'
          BR_NFTotalAmount,
          @EndUserText.label: 'Moeda da Nota'
          BR_NFCurrency,
          @EndUserText.label: 'Material (Kit) - denominação'
          MaterialName_kit,
          @EndUserText.label: 'Material (Gratuito) - denominação'
          MaterialName_free,
          @EndUserText.label: 'Doc. Estorno'
          DocEstorno,
          @EndUserText.label: 'Pedido Subc.'
          PediSubc,
          @Consumption.filter.hidden: true
          EstornoColor,
          @Consumption.filter.hidden: true
          NfRetorno_StatusColor,
          @Consumption.filter.hidden: true
          BR_NFeDocumentStatusColor,          
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_KIT_BON_URL' }
  virtual URL_NfRetorno : eso_longtext,
          _ZI_SalesDocumentQuiqkView
}
