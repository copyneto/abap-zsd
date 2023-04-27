@AbapCatalog.sqlViewName: 'ZVSD_CKPTFATMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona material conforme Ordem'
define view ZI_SD_CKPT_FAT_MAT
  as select from I_SalesOrder     as _SalesOrder
    inner join   I_SalesOrderItem as _Item on _Item.SalesOrder = _SalesOrder.SalesOrder
{

  key _SalesOrder.SalesOrder,
  key _Item.Material

}
