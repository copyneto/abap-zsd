@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ciclo de Pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CICLO_PO
  as select from ztsd_ciclo_po as _CicloPO
{
      @EndUserText.label: 'Ordem de Venda'
  key ordem_venda,
      @EndUserText.label: 'Remessa'
  key remessa,
      @EndUserText.label: 'Data/Hora do Registro'
  key data_hora_registro,
      @EndUserText.label: 'Tipo de Medição'
  key medicao,
      @EndUserText.label: 'Data/Hora Planejada da Medição'
      data_hora_planejada,
      @EndUserText.label: 'Data/Hora Realizada da Medição'
      data_hora_realizada
}
