@EndUserText.label: 'Projection Substituir Produto'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_SUBSTITUIR_APP
  as projection on ZI_SD_SUBSTITUIR_APP
{
      @EndUserText.label: 'Ordem'
      @Consumption.filter.mandatory: true
  key SalesOrder,
      @EndUserText.label: 'Item'
  key SalesOrderItem,
      @EndUserText.label: 'Produto' 
      @ObjectModel.text.element: ['DescriptionMaterial']
  key MaterialAtual,
      @EndUserText.label: 'Produto Substituir'
  key Material,
      @EndUserText.label: 'Descrição do Material'
      DescriptionMaterial,
      @EndUserText.label: 'Quantidade OV'
      OrderQuantity,
      @UI.hidden: true
      OrderUnit,
      @EndUserText.label: 'UM Quantidade OV'
      OrderQuantityUnit,
      @EndUserText.label: 'Fator'
      Fator,
      @EndUserText.label: 'Unidade de Medida'
      Unit,
      @EndUserText.label: 'EAN'
      EAN,
      @EndUserText.label: 'Centro'
      Plant
//      @EndUserText.label: 'Estoque em utilização livre'
//      @Consumption.filter.hidden: true
//      EstoqueLivre,
//      @EndUserText.label: 'Estoque em Remessa'
//      EstoqueRemessa,
//      @EndUserText.label: 'Moeda'
//      Moeda,
//      @EndUserText.label: 'Unidade de preço'
//      UnitPreco,
//      @EndUserText.label: 'Preço'
//      Preco,
//      @EndUserText.label: 'UM preço'
//      UmPreco
}

