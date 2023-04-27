@AccessControl.authorizationCheck: #CHECK
@AbapCatalog.sqlViewName: 'ZZ1_1F4D73EE5BE1'
@EndUserText.label: 'PRODUTIVDADE'
@AbapCatalog.compiler.compareFilter: true
@Search.searchable: false
@Metadata.allowExtensions: true
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
@DataAging.noAgingRestriction: true

define view ZZ1_PRODUTIVDADE

as select from I_ManufacturingOrder as I_ManufacturingOrder
association[0..*] to I_ManufacturingOrderOperation as _I_ManufacturingOrderOperation on _I_ManufacturingOrderOperation.ManufacturingOrder = _I_ManufacturingOrderOperation.ManufacturingOrder
association[0..*] to I_ManufacturingOrderItem as _I_ManufacturingOrderItem on _I_ManufacturingOrderItem.ManufacturingOrder = _I_ManufacturingOrderItem.ManufacturingOrder
association[0..*] to I_MfgOrderOperationComponent as _I_MfgOrderOperationComponent on _I_MfgOrderOperationComponent.ManufacturingOrder = _I_ManufacturingOrderItem.ManufacturingOrder
association[1..1] to I_ManufacturingOrder as _CKE_toBase
on ( _CKE_toBase.ManufacturingOrder = I_ManufacturingOrder.ManufacturingOrder or ( _CKE_toBase.ManufacturingOrder is null and I_ManufacturingOrder.ManufacturingOrder is null ) )

{
@EndUserText.label: 'Ordem de produção'
@ObjectModel.text.element: null
@Consumption.hidden: false
@Consumption.filter.mandatory: false
@Consumption.filter.multipleSelections: false
key I_ManufacturingOrder.ManufacturingOrder as ManufacturingOrder,

@ObjectModel.text.element: null
@Consumption.hidden: true
_CKE_toBase as _CKE_toBase
}
