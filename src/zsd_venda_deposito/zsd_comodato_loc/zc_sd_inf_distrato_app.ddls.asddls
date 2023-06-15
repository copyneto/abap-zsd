@EndUserText.label: 'Comodato e locação - Info. Distrato'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_INF_DISTRATO_APP
  as projection on ZI_SD_INF_DISTRATO_APP
{
      @EndUserText.label: 'Contrato'
  key Contrato,
      @EndUserText.label: 'Item'
  key ContratoItem,
      @EndUserText.label: 'Solicitação distrato'
      Solicitacao,
      @EndUserText.label: 'Ordem'
      Ordem,
      @EndUserText.label: 'Remessa'
      Remessa,
      @EndUserText.label: 'Fatura'
      Fatura,
      @EndUserText.label: 'Número de Série'
      Serie,
      @EndUserText.label: 'Número de Série'
      SerieCV,
      @EndUserText.label: 'Código Equipamento'
      CodigoEquip,
      @EndUserText.label: 'Descrição Equipamento'
      DescricaoEquip,
      @EndUserText.label: 'NF-e saída'
      NFeNumber,
      @EndUserText.label: 'Ordem de frete'
      OrdemFrete,
      @EndUserText.label: 'NF-e Retorno'
      NFRetorno,
      Centro,
      @EndUserText.label: 'Material'
      Material

}
