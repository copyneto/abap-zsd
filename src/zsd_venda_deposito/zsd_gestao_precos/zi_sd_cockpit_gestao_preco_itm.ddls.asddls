@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de preço - Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_GESTAO_PRECO_ITM
  as select from ztsd_preco_i
  association        to parent ZI_SD_COCKPIT_GESTAO_PRECO as _Cockpit         on  _Cockpit.Guid = $projection.Guid
  association [0..1] to ZI_SD_GESTAO_PRECO_MATERIAL       as _Info            on  _Info.Guid = $projection.Guid
                                                                              and _Info.Line = $projection.Line
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_STATUS      as _Status          on  _Status.Status = $projection.Status
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_TP_OPER     as _OperationType   on  _OperationType.OperationType = $projection.OperationType
  association [0..1] to ZI_CA_VH_VTWEG                    as _DistChannel     on  _DistChannel.CanalDistrib = $projection.DistChannel
  association [0..1] to ZI_CA_VH_PLTYP                    as _PriceList       on  _PriceList.PriceList = $projection.PriceList
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
                  when '10' then 1          -- Alerta Exportação
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
                          when 'EA817' then 1  -- Exclusão A817
                          when 'EA816' then 1  -- Exclusão A816
                          when 'EA627' then 1  -- Exclusão A627
                          when 'EA142' then 1  -- Exclusão A142
                          when 'EA626' then 1  -- Exclusão A626
                          when 'TA817' then 2  -- Toca UMB A817
                          when 'TA816' then 2  -- Toca UMB A816
                          when 'TA627' then 2  -- Toca UMB A627
                          when 'TA142' then 2  -- Toca UMB A142
                          when 'TA626' then 2  -- Toca UMB A626
                          when 'AA817' then 3  -- Aumento A817
                          when 'AA816' then 3  -- Aumento A816
                          when 'AA627' then 3  -- Aumento A627
                          when 'AA142' then 3  -- Aumento A142
                          when 'AA626' then 3  -- Aumento A626
                          when 'RA817' then 1  -- Rebaixa A817 
                          when 'RA816' then 1  -- Rebaixa A816 
                          when 'RA627' then 1  -- Rebaixa A627 
                          when 'RA142' then 1  -- Rebaixa A142 
                          when 'RA626' then 1  -- Rebaixa A626 
                                       else 0
                          end                                          as OperationTypeCriticality,

      dist_channel                                                     as DistChannel,
      dist_channel_criticality                                         as DistChannelCriticality,
      price_list                                                       as PriceList,
      price_list_criticality                                           as PriceListCriticality,

      _Info.Family                                                     as Family,
      _Info.Brand                                                      as Brand,

      material                                                         as Material,
      material_criticality                                             as MaterialCriticality,
      plant                                                            as Plant,
      plant_criticality                                                as PlantCriticality,
      //      @Semantics.quantity.unitOfMeasure : 'BaseUnit'
      cast( scale as abap.dec( 15,3 ) )                                as Scale,
      scale_criticality                                                as ScaleCriticality,
      base_unit                                                        as BaseUnit,
      base_unit_criticality                                            as BaseUnitCriticality,
      //      @Semantics.amount.currencyCode : 'Currency'
      cast( min_value  as abap.dec( 23,2 ) )                           as MinValue,
      min_value_criticality                                            as MinValueCriticality,
      //      @Semantics.amount.currencyCode : 'Currency'
      cast( sug_value  as abap.dec( 23,2 ) )                           as SugValue,
      sug_value_criticality                                            as SugValueCriticality,
      //            @Semantics.amount.currencyCode : 'Currency'
      cast( max_value    as abap.dec( 23,2 ) )                         as MaxValue,
      max_value_criticality                                            as MaxValueCriticality,
      currency                                                         as Currency,
      currency_criticality                                             as CurrencyCriticality,
      date_from                                                        as DateFrom,
      date_from_criticality                                            as DateFromCriticality,
      date_to                                                          as DateTo,
      date_to_criticality                                              as DateToCriticality,
      condition_record                                                 as ConditionRecord,
      //            @Semantics.amount.currencyCode : 'Currency'
      cast( minimum    as abap.dec( 23,2 ) )                           as Minimum,
      minimum_criticality                                              as MinimumCriticality,
      cast( round( minimum_perc, 1 )   as abap.dec( 20,1 ) )           as MinimumPerc,
      minimum_perc_criticality                                         as MinimumPercCriticality,
      cast( round( min_value_perc, 1 )   as abap.dec( 20,1 ) )         as MinValuePerc,
      min_value_perc_criticality                                       as MinValuePercCriticality,
      cast( round( max_value_perc, 1 )   as abap.dec( 20,1 ) )         as MaxValuePerc,
      max_value_perc_criticality                                       as MaxValuePercCriticality,
      cast( round( sug_value_perc, 1 )   as abap.dec( 20,1 ) )         as SugValuePerc,
      sug_value_perc_criticality                                       as SugValuePercCriticality,
      //      @Semantics.amount.currencyCode : 'ActiveCurrency'
      cast(active_min_value    as abap.dec( 23,2 ) )                   as ActiveMinValue,
      //      @Semantics.amount.currencyCode : 'ActiveCurrency'
      cast(active_sug_value    as abap.dec( 23,2 ) )                   as ActiveSugValue,
      //      @Semantics.amount.currencyCode : 'ActiveCurrency'
      cast(active_max_value    as abap.dec( 23,2 ) )                   as ActiveMaxValue,
      active_currency                                                  as ActiveCurrency,
      active_condition_record                                          as ActiveConditionRecord,
      zzdelete                                                         as DeleteItem,

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
      _OperationType,
      _DistChannel,
      _PriceList,
      _Material,
      _ConditionRecord,
      _Plant

}
