@AbapCatalog.sqlViewName: 'ZVSD_DESC_ITEM'
@AccessControl.authorizationCheck: #CHECK
@AbapCatalog.preserveKey: true
@EndUserText.label: 'Desconto do item da ordem'

define root view ZC_SD_SalesOrderPricingElement
  as select from prcd_elements as i
{
  key    i.knumv        as PricingDocument,
  key    i.kposn        as PricingDocumentItem,
         @Semantics.amount.currencyCode: 'TransactionCurrency'
         sum( i.kwert ) as ConditionAmount,
         @Semantics.currencyCode: true
         //      @ObjectModel.foreignKey.association: 'Waerk'
         max( i.waerk ) as TransactionCurrency
}
where
     i.kschl = 'ZBON'
  or i.kschl = 'ZBOS'
group by
  i.knumv,
  i.kposn
