@EndUserText.label: 'Comodato e locação - Locais/equipamentos'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_LOC_EQUIP
  as projection on ZI_SD_LOC_EQUIP
  association to ZC_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
      //      @UI.hidden: true
  key Contrato,
      @EndUserText.label: 'Item'
  key ContratoItem,
      @EndUserText.label: 'Remessa'
      Remessa,
      @EndUserText.label: 'Item Remessa'
      RemessaItem,
      @EndUserText.label: 'Produto'
      @ObjectModel.text.element: ['ProdutoTexto']
      Produto,
      @EndUserText.label: 'Produto'
      ProdutoTexto,
      @EndUserText.label: 'Série'
      Serie,
      @EndUserText.label: 'Série'
      SerieCV,
      @EndUserText.label: 'Centro'
      @ObjectModel.text.element: ['CentroTexto']
      Centro,
      @EndUserText.label: 'Centro'
      CentroTexto,
      @EndUserText.label: 'Cliente'
      @ObjectModel.text.element: ['ClienteTexto']
      Cliente,
      @EndUserText.label: 'Cliente'
      ClienteTexto,

      /* associations */
      _Cockpit
      //      _Cockpit : redirected to parent ZC_SD_COCKPIT_APP
}
