@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Devolução Replicada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DEVOLUCAO_REPLIC
  as select from I_BR_NFDocument as _Devolucao
{
  key BR_NotaFiscal        as Devolucao,
      BR_NFType            as NfType,
      BR_NFObservationText as Nfe,
      BR_NFPostingDate     as Data
}
