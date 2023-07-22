@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para ZCLSD_CMDLOC_DEVOL_MERCADORIA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CMDLOC_DEVOL_MERC_MOV_MM
  as select from ZI_SD_CMDLOC_DEVOL_MERC_MOV
{
  key SalesContract,
      SalesDocument,
      Solicitacao,
      TpOperacao,
      DocnumNfeSaida,
      DocnumEntrada,
      DocFatura,
      max( CentroDestino ) as CentroDestino,
      max( CentroOrigem )  as CentroOrigem,
      NfeSaida
}
group by
  SalesContract,
  SalesDocument,
  Solicitacao,
  TpOperacao,
  DocnumNfeSaida,
  DocnumEntrada,
  DocFatura,
  NfeSaida
