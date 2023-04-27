@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS PARA UNION HEADER app'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CKPT_AGEND_UNION_APP
  as select from           ZI_SD_CKPT_AGEND_UNION as _Union
    left outer to one join ZI_SD_CKPT_AGEND_PESO            as _Peso on _Union.SalesOrder = _Peso.SalesOrder
  association to ZI_SD_KIT_BON_ORDER_VIEW as _ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = _Union.SalesOrder
{
         @Consumption.semanticObject: 'SalesDocument'
         @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuiqkView'
  key    _Union.ChaveOrdemRemessa,
  key    _Union.ChaveDinamica,
  key    _Union.SalesOrder,
  key    _Union.SalesOrderItem,
  key    _Union.Remessa,
  key       _Union.Ordem_remessa,
  key       _Union.SoldToParty,
              _Union.CreationDate,
         _Union.SoldToPartyName,
         _Union.PurchaseOrderByCustomer,
         _Union.RequestedDeliveryDate,

         _Union.SalesOrganization,
         _Union.DistributionChannel,
         _Union.OrganizationDivision,
         _Union.SalesOrderI,
         _Union.Plant,

         _Union.ItemWeightUnit,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         _Union.ItemGrossWeight,
         @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
         _Union.ItemNetWeight,
         _Union.Material,
         _Union.SalesOrderItemText,
         _Union.ItemVolumeUnit,
         _Union.OrderQuantityUnit,
         _Union.OverallSDProcessStatus,
         _Union.OverallSDProcessStatusColor,
         _Union.SalesOrderType,
         _Union.SalesDistrict,
         _Union.Route,
         _Union.CustomerPurchaseOrderDate,
         _Union.Supplier,
         _Union.kvgr5,
         _Union.AgrupametoText,
         _Union.regio,
         _Union.ort01,
         _Union.ort02,
         _Union.Document,
         _Union.DocNum,
         @Semantics.amount.currencyCode:'Currency'
         _Union.Total_Nfe,
         _Union.Currency,
         _Union.NotaFiscal,
         _Union.OrdemFrete,
         _Union.UnidadeFrete,
         _Union.DataAgendada,
         _Union.HoraAgendada,
//         '' as MotivoAgenda,
//         _Union.MotivoAgenda,
         _Union.Motivo as MotivoAgenda,
         _Union.MotivoText,
         _Union.Senha,
         _Union.Observacoes,
         _Union.EventCode,
         _Union.FreteEventCode,
         _Union.Status,
         _Union.StatusText,
         _Union.StatusColor,
         _Union.Salesorder_conv,
         _Union.DataEntrega,
         _Union.time_zone,
         _Union.tipo,
         _Union._Cliente,
         _Union._Grupo,
         _Union._Item,
         _Union._Partner,
//         _Union._Remessa,
         case
         when _Union.Remessa is null or _Union.Remessa is initial
         then _Peso.ITEMVOLUME
         else
         _Union.ItemVolume end as ItemVolume,
         _ZI_SalesDocumentQuiqkView 
}
