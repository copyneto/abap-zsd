@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Valor Prd Conf'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_PRD_NF as 
    select from I_SalesOrderItem as _OrderItem
    inner join prcd_elements as _prcdElem on    _OrderItem.SalesOrderCondition = _prcdElem.knumv and
                                                _OrderItem.SalesOrderItem = _prcdElem.kposn and 
                                                _prcdElem.kschl = 'ZLPP'  
     
{
    key _OrderItem.SalesOrder,
    key _OrderItem.Material,
    sum(_prcdElem.kbetr) as VlUnitario,
    sum(cast(_prcdElem.kwert as abap.dec( 15, 2 ))) as VlTotal
}
group by
    _OrderItem.SalesOrder,
    _OrderItem.Material
