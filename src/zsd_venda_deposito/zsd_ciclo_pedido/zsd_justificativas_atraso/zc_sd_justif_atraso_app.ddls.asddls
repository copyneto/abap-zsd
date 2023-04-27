@EndUserText.label: 'Controle dos atrasos justificados'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_JUSTIF_ATRASO_APP
  as projection on ZI_SD_JUSTIF_ATRASO_APP
{
  key OrdemVenda,
  key Centro,
  key Medicao,
      DataPlanejada,
      MotivoAtraso,
      @EndUserText.label: 'Ordem de Frete'
      OrdemFrete,
      Itinerario,
      @EndUserText.label: 'Status da Justificativa'
      Status,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
