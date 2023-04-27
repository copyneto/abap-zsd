@EndUserText.label: 'Busca primeiro item da ordem'
@AccessControl.authorizationCheck: #CHECK
define view entity ZI_SD_COCKPIT_DEV_ITEM_ORDEM
  as select from I_SalesDocumentItem as _ItemOrdem

{
  key _ItemOrdem.SalesDocument,
  key min( _ItemOrdem.SalesDocumentItem ) as Item,
      _ItemOrdem.Plant
}
group by
  _ItemOrdem.SalesDocument,
  _ItemOrdem.Plant
