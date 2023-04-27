@EndUserText.label: 'Comodato e locação - Detalhes do JOB'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define root view entity ZC_SD_DET_JOBS
  as projection on ZI_SD_DET_JOBS
  association to ZC_SD_COCKPIT_APP as _Cockpit on $projection.Contrato = _Cockpit.SalesContract
{
      @UI.hidden: true
  key Contrato,
      @UI.hidden: true
  key Modulo,
      @UI.hidden: true
  key Chave1,
      @UI.hidden: true
  key Chave2,
      @EndUserText.label: 'Chave'
  key Chave3,
      @UI.hidden: true
  key Sign,
      @UI.hidden: true
  key Opt,
      @EndUserText.label: 'Nome do Job'
  key Low,
      @EndUserText.label: 'Descrição'
      Descricao,
      @EndUserText.label: 'Número do Job'
      NumeroJob,
      @EndUserText.label: 'Data Início'
      DataInicio,
      @EndUserText.label: 'Hora Início'
      HoraInicio,
      @EndUserText.label: 'Data Fim'
      DataFim,
      @EndUserText.label: 'Hora Fim'
      HoraFim,

      /* Associations */
      _Cockpit
      //      _Cockpit : redirected to parent ZC_SD_COCKPIT_APP
}
