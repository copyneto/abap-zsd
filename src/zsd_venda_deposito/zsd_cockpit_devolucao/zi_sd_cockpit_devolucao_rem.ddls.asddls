@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_REM
  as select from I_DeliveryDocumentItem as _DocItem
  association to I_DeliveryDocument          as _Documento on _Documento.DeliveryDocument = $projection.Remessa
  association to ZI_SD_COCKPIT_DEVOLUCAO_FAT as _Fatura    on _Fatura.DocumentoVendas = $projection.Remessa
{

       //  key  _Remessa.DocRelationshipUUID          as Documento,
       //       _Remessa.PrecedingDocument            as DocumentoVendas,
       //       _Remessa.SubsequentDocument           as Remessa,
  key  _DocItem.DeliveryDocument             as Remessa,
  key  min( _DocItem.DeliveryDocumentItem )  as ItemRemessa,
       _DocItem.ReferenceSDDocument          as DocumentoVendas,
       _Documento.OverallGoodsMovementStatus as StatusMovMercadorias,
       _Documento.DeliveryBlockReason        as BloqueioRemessa,
       _Fatura.Fatura                        as Fatura,
       _Fatura.OrdemComplementar             as OrdemComplementar,
       _Fatura.NfeComp                       as NfeComp,
       _Fatura.BloqueioFaturamento           as BloqueioFaturamento,
       @Semantics.amount.currencyCode: 'MoedaSD'
       @Aggregation.default:#SUM
       _Fatura.NfTotal                       as NfTotal,
       _Fatura.MoedaSD                       as MoedaSD,
       _Fatura.DocNfStatus,
       _Fatura.DocNf,
       _Fatura.Cancelado,
       _Fatura.Nfe

}
//where
//  _Remessa.SubsequentDocumentCategory = 'J'
where
  _DocItem.ReferenceSDDocument <> ''
group by
//  _Remessa.DocRelationshipUUID,
//  _Remessa.PrecedingDocument,
//  _Remessa.SubsequentDocument,
  _DocItem.DeliveryDocument,
  _DocItem.ReferenceSDDocument,
  _Documento.OverallGoodsMovementStatus,
  _Documento.DeliveryBlockReason,
  _Fatura.Fatura,
  _Fatura.OrdemComplementar,
  _Fatura.NfeComp,
  _Fatura.BloqueioFaturamento,
  _Fatura.NfTotal,
  _Fatura.MoedaSD,
  _Fatura.DocNfStatus,
  _Fatura.DocNf,
  _Fatura.Cancelado,
  _Fatura.Nfe
