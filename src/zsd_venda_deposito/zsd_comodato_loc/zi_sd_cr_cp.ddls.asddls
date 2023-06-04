@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Comodato e locação - Análise CR/CP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CR_CP
  as select from ZI_SD_CR_CP_CTR as AnaliseCRCP
//  association to parent ZI_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
  key Contrato,
  key Parcela, 
  key ParcelaItem,
      Ordem,
      Fatura,
      Remessa,
      Datafaturamento,
      DocFinFatura,
      DataGeracao,
      Atribuicao,
      Vencimento,
      @Semantics.amount.currencyCode: 'Moeda'
      Valor,
      Moeda,
      DataCriacao,
      DocFinRecebimento

      /* associations */
//      _Cockpit
}
where Estorno = ''
