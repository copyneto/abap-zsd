@AbapCatalog.sqlViewName: 'ZVSD_OVCLIENTE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ordem Cliente'
define view ZI_SD_ORDEM_CLIENTE
  as select from I_SalesDocument     as SalesOrder
    inner join   ZI_SD_OV_CLIENTE as _Param on _Param.OrderType = SalesOrder.SalesDocumentType

{

  key SalesDocument as SalesOrder,
      CreationDate,
      CreationTime,
      CorrespncExternalReference
} 
