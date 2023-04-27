@EndUserText.label: 'Comodato e locação - Info. Distrato'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_INF_DISTRATO
  as projection on ZI_SD_INF_DISTRATO
  
    association to ZC_SD_COCKPIT_APP as _Cockpit on _Cockpit.SalesContract = $projection.Contrato
{
      @UI.hidden: true
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
      @EndUserText.label: 'Código Equipamento'
      CodigoEquip,
      @EndUserText.label: 'Descrição Equipamento'
      DescricaoEquip,
      @EndUserText.label: 'Número de Série'
      SerieCV,
      @EndUserText.label: 'NF-e saída'
      NFeNumber,
      @EndUserText.label: 'Ordem de frete'
      OrdemFrete,
      @EndUserText.label: 'NF-e Retorno'
      NFRetorno,

      /* Associations */
      _Cockpit
      //      _Cockpit : redirected to parent ZC_SD_COCKPIT_APP
}
