@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Ativos imobilizados'

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_ATIVOS_IMOBILIZADOS
  as select from ztsd_ativos_imob
{
  key fkart                 as Fkart,
      @EndUserText.label: 'Região de Saída'
  key regiao_saida          as RegiaoSaida,
      @EndUserText.label: 'Região de Destino'
  key regiao_destino        as RegiaoDestino,
      @EndUserText.label: 'Prazo mínimo de retorno'
      dias_atraso1          as DiasAtraso1,
      @EndUserText.label: 'Prazo Máximo de retorno'
      dias_atraso2          as DiasAtraso2,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      local_last_changed_at as LocalLastChangedAt

}
