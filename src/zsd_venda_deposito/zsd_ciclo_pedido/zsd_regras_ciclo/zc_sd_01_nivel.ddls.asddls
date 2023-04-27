@EndUserText.label: 'Níveis de serviço desejados'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@Search.searchable: true
@ObjectModel.semanticKey: ['Ziti', 'Zmed']

define root view entity ZC_SD_01_NIVEL
  as projection on ZI_SD_01_NIVEL as Nivel
{
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_ITINERARIO', element : 'Route' }}]
      @ObjectModel.text.element: ['DescItiner']
      @UI.textArrangement: #TEXT_LAST
  key Ziti,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_med', element : 'Med' }}]
  key Zmed,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_eveni', element : 'Evento' }}]
      ZevenI,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_evenf', element : 'Evento' }}]
      ZevenF,
      @ObjectModel.text.element: ['ZprahConv']
      @UI.textArrangement: #TEXT_ONLY
      Zprah,
      ZprahConv,
      Zprad,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_FABKL', element : 'IDCalend' }}]
      Zcale,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      _Medicao.Descricao as DescMedicao,
      _EveIni.Descricao  as DescIniEve,
      _EveFim.Descricao  as DescFimEve,
      _Itiner.Descricao  as DescItiner,

      /* Associations */
      _Hora : redirected to composition child zc_sd_02_hora,
      _Dia  : redirected to composition child ZC_SD_03_DIA
}
