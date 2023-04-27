@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit do Ciclo do Pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CICLO_PO
  as select from ztsd_ciclo_po
{
  key ordem_venda                                                                                                                          as OrdemVenda,
  key remessa                                                                                                                              as Remessa,
  key medicao                                                                                                                              as Medicao,
      data_hora_registro                                                                                                                   as DataHoraRegistro,
      tstmp_to_dats( cast( data_hora_registro as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL')   as DataRegistro,
      tstmp_to_tims( cast( data_hora_registro as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' )  as HoraRegistro,
      data_hora_planejada                                                                                                                  as DataHoraPlanejada,
      tstmp_to_dats( cast( data_hora_planejada as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL')  as DataPlanejada,
      tstmp_to_tims( cast( data_hora_planejada as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' ) as HoraPlanejda,
      data_hora_realizada                                                                                                                  as DataHoraRealizada,
      tstmp_to_dats( cast( data_hora_realizada as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL')  as DataRealizada,
      tstmp_to_tims( cast( data_hora_realizada as tzntstmps),abap_system_timezone( $session.client,'INITIAL' ),$session.client,'INITIAL' ) as HoraRealizada

}
