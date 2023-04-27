@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ORDEM_DEV
  as select from I_SDDocumentMultiLevelProcFlow as _OrdemDev
  association to ZI_SD_ORDEM_CLIENTE as _Order
    on _Order.SalesOrder = $projection.SubsequentDocument
  association to ZI_SD_REMESSA_DEV   as _RemessaDev
    on _RemessaDev.PrecedingDocument = $projection.SubsequentDocument
{
  _OrdemDev.PrecedingDocument,
  _OrdemDev.SubsequentDocumentCategory,
  _OrdemDev.SubsequentDocument,
  _OrdemDev.PrecedingDocumentItem,
  _Order.SalesOrder,
  _Order.CreationDate,
  _Order.CreationTime,
  _Order.CorrespncExternalReference,
  case when _RemessaDev.SubsequentDocument <> '0000000000' then _RemessaDev.SubsequentDocument
  else '0000000000'
  end as RemessaDev,
  case when _RemessaDev.FaturaDev <> '0000000000' then _RemessaDev.FaturaDev
  else '0000000000'
  end as FaturaDev,
  _RemessaDev.BR_NFeNumber,
  _RemessaDev.BR_NFeDocumentStatus
}
where
      SubsequentDocumentCategory =  'H'
  and PrecedingDocumentCategory  =  'C'
  --and PrecedingDocumentCategory  =  'M'  
  and PrecedingDocumentItem      =  '000010'
  and _Order.SalesOrder          <> ' '
