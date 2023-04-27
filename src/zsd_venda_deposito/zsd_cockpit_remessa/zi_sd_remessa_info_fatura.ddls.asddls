@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_INFO_FATURA
  as select from           ZI_SD_CICLO( p_tipo : 'M') as _Fatura
      inner join   I_BillingDocumentItemBasic as _FaturaRef on  _FaturaRef.BillingDocument     = _Fatura.Document
                                                            and _FaturaRef.ReferenceSDDocument = _Fatura.SalesOrder
                                                            and _FaturaRef.BillingDocumentItem = '000010'

    inner join             I_BillingDocumentBasic     as _FaturaHeader on  _FaturaHeader.BillingDocument      =  _Fatura.Document
                                                                       and _FaturaHeader.OverallBillingStatus <> 'C'

{

  key _Fatura.SalesOrder,
  key _Fatura.Document,
      _Fatura.DocNum,
      _Fatura.Currency,
      _Fatura.NotaFiscal,
      @Semantics.amount.currencyCode: 'Currency'
      @Aggregation.default:#SUM
      _Fatura.Total_Nfe_Header


}
where
  _Fatura.DocNum != '0000000000'

group by
  _Fatura.SalesOrder,
  _Fatura.Document,
  _Fatura.DocNum,
  _Fatura.Currency,
  _Fatura.NotaFiscal,
  _Fatura.Total_Nfe_Header
