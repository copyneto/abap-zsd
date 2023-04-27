@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Coleta de Avarias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define root view entity zi_sd_coleta_avarias
  as select from    I_SalesOrder                   as _SalesOrder
    inner join      zi_sd_coleta_avarias_tp_ov_par as _Param          on _Param.OrderType = _SalesOrder.SalesOrderType
    left outer join zi_sd_coleta_avarias_doc_flow  as _SDDocumentFlow on _SDDocumentFlow.ordemVendas = _SalesOrder.SalesOrder
    left outer join zi_sd_coleta_avarias_tm_item   as _TorItem        on _TorItem.remessaBtdId = _SDDocumentFlow.remessaBtdId
    left outer join /scmtms/d_torrot               as _TorRot         on _TorRot.db_key = _TorItem.parent_key
{

  key _SalesOrder.SalesOrder,
      @ObjectModel.text.element: ['CustomerName']
      _SalesOrder.SoldToParty,
      _SalesOrder._SoldToParty.CustomerName,
      cast( _SDDocumentFlow.remessa as vbeln_vl ) as remessa,
      _TorRot.tor_id,
      _SalesOrder.CreationDate,
      _SalesOrder.SalesOrderDate,
      cast ( 'X' as xfeld ) as ImprimeForm,
      _SalesOrder.SalesOrganization,
      _SalesOrder.DistributionChannel

}
