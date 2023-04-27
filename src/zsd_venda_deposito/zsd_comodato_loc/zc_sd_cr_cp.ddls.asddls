@EndUserText.label: 'Comodato e locação - Análise CR/CP'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_CR_CP
  as projection on ZI_SD_CR_CP
    association to ZC_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
      @UI.hidden: true
  key Contrato,
      @EndUserText.label: 'Parcela'
  key Parcela,
      @EndUserText.label: 'Parcela Item'
  key ParcelaItem,
      @EndUserText.label: 'Ordem'
      Ordem,
      @EndUserText.label: 'Remessa'
      Remessa,
      @EndUserText.label: 'Fatura'
      Fatura,
      Datafaturamento,
      @EndUserText.label: 'Doc.Fin.Fatura'
      DocFinFatura,
      @EndUserText.label: 'Data Geração'
      DataGeracao,
      @EndUserText.label: 'Atribuição'
      Atribuicao,
      Vencimento,
      @EndUserText.label: 'Valor'
      @Semantics.amount.currencyCode: 'Moeda'
      Valor,
      @EndUserText.label: 'Moeda'
      Moeda,
      @EndUserText.label: 'Data Criação'
      DataCriacao,
      @EndUserText.label: 'Doc.Fin.Recebimento'
      DocFinRecebimento,
      
      /* Associations */
      _Cockpit
//      _Cockpit : redirected to parent ZC_SD_COCKPIT_APP 
}
