@AbapCatalog.sqlViewName: 'ZVSD_DFAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface documento de fat. e itens'
define view ZI_SD_FATURAMENTO_E_ITEM
  as select from I_BillingDocumentItem as _BillingDocumentItem
    inner join   I_BillingDocument     as _BillingDocument on (
      _BillingDocumentItem.BillingDocument = _BillingDocument.BillingDocument )
{
  key _BillingDocument.BillingDocument            as DocFaturamento,
      _BillingDocument.BillingDocumentDate        as DataFaturamento,
      _BillingDocument.FiscalYear                 as Periodo,
      _BillingDocument.BillingDocumentIsCancelled as FaturaEstornada,
      _BillingDocument.CancelledBillingDocument   as CancelledBillingDocument,

      _BillingDocumentItem.SalesDocument,
      _BillingDocumentItem.SalesDocumentItem,
      _BillingDocumentItem.PriceDetnExchangeRate  as DolarFaturamento,
      _BillingDocumentItem.TransactionCurrency    as Moeda,
      _BillingDocumentItem.BillingDocumentItem    as DocFaturamentoItem
}
where
  (
        _BillingDocument.BillingDocumentIsCancelled = ''
    and _BillingDocument.CancelledBillingDocument   = ''
  )
