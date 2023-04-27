@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de preço - Alerta mínimo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_GESTAO_PRECO_MIN
  as select from ztsd_preco_m
  association        to parent ZI_SD_COCKPIT_GESTAO_PRECO as _Cockpit         on  _Cockpit.Guid = $projection.Guid

  association [0..1] to ZI_SD_GESTAO_PRECO_MATERIAL       as _Info            on  _Info.Guid = $projection.Guid
                                                                              and _Info.Line = $projection.Line
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_STATUS      as _Status          on  _Status.Status = $projection.Status
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_TP_OPER     as _OperationType   on  _OperationType.OperationType = $projection.OperationType
  association [0..1] to ZI_CA_VH_VTWEG                    as _DistChannel     on  _DistChannel.CanalDistrib = $projection.DistChannel
  association [0..1] to ZI_CA_VH_MATERIAL                 as _Material        on  _Material.Material = $projection.Material
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_REG_COND    as _ConditionRecord on  _ConditionRecord.ConditionRecord = $projection.ConditionRecord
  association [0..1] to ZI_CA_VH_WERKS                    as _Plant           on  _Plant.WerksCode = $projection.Plant
{
  key guid                                                             as Guid,
  key guid_line                                                        as GuidLine,
      line                                                             as Line,
      concat_with_space( 'Linha ', cast( line as abap.char(11) ) , 1 ) as LineText,
      case status when '00' then 0          -- Em aberto
            when '01' then 2                -- Em processamento
            when '02' then 3                -- OK
            when '03' then 1                -- Não OK
            when '04' then 3                -- Finalizado
            when '05' then 1                -- Alerta
            when '06' then 1                -- Análise
                      else 0
            end                                                        as LineCriticality,
      //      line_criticality                                                 as LineCriticality,
      status                                                           as Status,

      case status when '00' then 0          -- Em aberto
                  when '01' then 2          -- Em processamento
                  when '02' then 3          -- OK
                  when '03' then 1          -- Não OK
                  when '04' then 3          -- Finalizado
                  when '05' then 1          -- Alerta
                  when '06' then 1          -- Análise
                            else 0
                  end                                                  as StatusCriticality,

      operation_type                                                   as OperationType,

      case operation_type when 'IA817' then 3  -- Inclusão A817
                          when 'IA816' then 3  -- Inclusão A816
                          when 'IA627' then 3  -- Inclusão A627
                          when 'IA142' then 3  -- Inclusão A142
                          when 'IA626' then 3  -- Inclusão A626
                          when 'UA817' then 2  -- Alteração A817
                          when 'UA816' then 2  -- Alteração A816
                          when 'UA627' then 2  -- Alteração A627
                          when 'UA142' then 2  -- Alteração A142
                          when 'UA626' then 2  -- Alteração A626
                          when 'UA626' then 2  -- Alteração A626
                          when 'EA817' then 1  -- Exclusão A817
                          when 'EA816' then 1  -- Exclusão A816
                          when 'EA627' then 1  -- Exclusão A627
                          when 'EA142' then 1  -- Exclusão A142
                          when 'EA626' then 1  -- Exclusão A626
                          when 'TA817' then 1  -- Toca UMB A817
                          when 'TA816' then 1  -- Toca UMB A816
                          when 'TA627' then 1  -- Toca UMB A627
                          when 'TA142' then 1  -- Toca UMB A142
                          when 'TA626' then 1  -- Toca UMB A626
                                       else 0
                          end                                          as OperationTypeCriticality,

      _Info.Family                                                     as Family,
      _Info.Brand                                                      as Brand,
      dist_channel                                                     as DistChannel,
      dist_channel_criticality                                         as DistChannelCriticality,
      material                                                         as Material,
      material_criticality                                             as MaterialCriticality,
      plant                                                            as Plant,
      plant_criticality                                                as PlantCriticality,
//      @Semantics.amount.currencyCode : 'Currency'
      cast( min_value  as abap.dec( 23, 2 ) )                          as MinValue,
      min_value_criticality                                            as MinValueCriticality,
      currency                                                         as Currency,
      currency_criticality                                             as CurrencyCriticality,
      date_from                                                        as DateFrom,
      date_from_criticality                                            as DateFromCriticality,
      date_to                                                          as DateTo,
      date_to_criticality                                              as DateToCriticality,
      condition_record                                                 as ConditionRecord,

      @Semantics.user.createdBy: true
      created_by                                                       as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                                       as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                                  as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                                  as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                            as LocalLastChangedAt,

      /* Associations */
      _Cockpit,

      _Info,
      _Status,
      _DistChannel,
      _OperationType,
      _Material,
      _ConditionRecord,
      _Plant

}
