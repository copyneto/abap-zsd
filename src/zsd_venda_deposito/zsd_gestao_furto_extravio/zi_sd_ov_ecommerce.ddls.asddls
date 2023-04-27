@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem nota débito e-commerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_ECOMMERCE
  as select from vbfa              as _OrdemDeb
    inner join   I_SalesOrder      as _SalesEcommerce on _SalesEcommerce.SalesOrder = _OrdemDeb.vbelv
    inner join   ZI_SD_TYPE_OV      as _Param       on _Param.OrderType = _SalesEcommerce.SalesOrderType 
  association to ZI_SD_FAT_NOTA_DEB as _Fatura on _Fatura.SalesDocument = _SalesEcommerce.SalesOrder

{
  key  _OrdemDeb.vbeln                            as SalesOrder,
  key  _Fatura.SalesDocumentItem                  as SalesOrderItem,
       _SalesEcommerce.CorrespncExternalReference as CorrespncExternalReference,
       _SalesEcommerce.SoldToParty                as Soldtoparty,
       _SalesEcommerce.SDDocumentReason           as SDdocumentreason,
       _SalesEcommerce.PurchaseOrderByCustomer    as PurchaseOrderByCustomer,
       _SalesEcommerce.DistributionChannel        as DistributionChannel,
       _SalesEcommerce.CreationDate               as CreationDate,
       _Fatura.BR_NFeNumber                       as BR_NFeNumber,
       _Fatura.SubsequentDocument                 as SubsequentDocument,
       _OrdemDeb.vbelv                            as SalesOrderEcommerce,
       _OrdemDeb.posnv                            as SalesOrderEcommerceItem



}
where
  _OrdemDeb.vbtyp_n = 'C'
