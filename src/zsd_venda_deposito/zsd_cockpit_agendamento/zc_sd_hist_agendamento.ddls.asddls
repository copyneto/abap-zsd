@EndUserText.label: 'CDS de projeção - Histórico de Agendamento'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_HIST_AGENDAMENTO
  as projection on ZI_SD_HIST_AGENDAMENTO

{
            @EndUserText.label: 'Ordem do Cliente'
  key       SalesOrder,
            @Consumption.filter.hidden: true
  key       Item,
  key       Remessa,
  key       DocNum,
            @EndUserText.label: 'Data agendada'
  key       DataAgendada,
            @EndUserText.label: 'Hora agendada'
  key       HoraAgendada,

            //      @EndUserText.label: 'Data e Hora do registro'
            //      DataHoraAgendada,
            @EndUserText.label: 'Motivo Agenda'
            @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_VSTGA', element: 'Motivo' }}]
            Motivo,
            @EndUserText.label: 'Descrição Motivo Agenda'
            MotivoText,
            Senha,
            @Consumption.filter.hidden: true
            @EndUserText.label: 'Observações'
            Observacoes,
            @EndUserText.label: 'Data do Registro'
            DataRegistro,
            @EndUserText.label: 'Hora do Registro'
            HoraRegistro,
            Usuario,
            @Consumption.filter.hidden: true
            @Consumption.hidden: true
            Max_DataHoraAgendada,
            @EndUserText.label: 'Agendamento Válido'
            Agend_Valid,
            @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_WERKS', element: 'WerksCode' }}]
            Centro,
            @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
            Canal,
            @Consumption.filter.hidden: true
            @UI.hidden: true
            TextoMotivo

}
