@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'controle dos atrasos justificados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_JUSTIF_ATRASO_APP
  as select from ztsd_atraso_just
  association to ZI_SD_JUSTIF_ATRASO_TO as _TO on _TO.SalesOrder = $projection.OrdemVenda
  association to ZI_SD_JUSTIF_ATRASO_ITI as _ITI on _ITI.SalesOrder = $projection.OrdemVenda
  
 {
  key ordem_venda           as OrdemVenda,
  key centro                as Centro,
  key medicao               as Medicao,
      data_planejada        as DataPlanejada,
      motivo_atraso         as MotivoAtraso,
      _TO.OrdemFrete,
      _ITI.Itinerario,
      
      
      case motivo_atraso
       when '' then 'Novo'
       else 'Justificado'
      end as Status,
      
      case motivo_atraso
       when '' then 0
       else 3
      end as StatusColor,      

      created_by            as CreatedBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt
}
