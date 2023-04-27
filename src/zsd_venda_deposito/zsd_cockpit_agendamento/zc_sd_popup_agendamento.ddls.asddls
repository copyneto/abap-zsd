@EndUserText.label: 'Realizar Agendamento'
@Metadata.allowExtensions: true
define abstract entity ZC_SD_POPUP_AGENDAMENTO
{
  @EndUserText.label      : 'Data Agendada'
  DataAgendada : j_1bdocdat;
  @EndUserText.label      : 'Hora Agendada'
  HoraAgendada : j_1bauthtime;
//  @EndUserText.label      : 'Movito Agenda'
  MotivoAgenda : vstga;
  @EndUserText.label      : 'Senha'
  Senha        : ze_senha;
  @EndUserText.label      : 'Observações'
  Observacoes  : abap.char( 20 );
}
