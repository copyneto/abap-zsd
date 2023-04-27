@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de preço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_COCKPIT_GESTAO_PRECO
  as select from ztsd_preco_h

  composition [0..*] of ZI_SD_COCKPIT_GESTAO_PRECO_ITM as _Item
  composition [0..*] of ZI_SD_COCKPIT_GESTAO_PRECO_MIN as _Minimo
  composition [0..*] of ZI_SD_COCKPIT_GESTAO_PRECO_INV as _Invasao
  composition [0..*] of ZI_SD_COCKPIT_GESTAO_PRECO_MSG as _Mensagem
  composition [0..*] of ZI_SD_COCKPIT_GESTAO_PRECO_OBS    as _Observacoes 


  association [0..1] to ZI_SD_GESTAO_PRECO_COND_PARAM  as _Param         on _Param.ConditionType = $projection.ConditionType
  association [0..1] to ZI_SD_VH_GESTAO_PRECO_STATUS   as _Status        on _Status.Status = $projection.Status
  association [0..1] to ZI_SD_VH_TIPO_CONDICAO         as _ConditionType on _ConditionType.ConditionType = $projection.ConditionType
  association [0..1] to ZI_CA_VH_USER                  as _RequestUser   on _RequestUser.Bname = $projection.RequestUser
//  association [0..1] to ZI_CA_VH_USER                  as _ApproveUser   on _ApproveUser.Bname = $projection.approveuser
  association [0..1] to ZI_CA_VH_USER                  as _CreatedBy     on _CreatedBy.Bname = $projection.CreatedBy
  association [0..1] to ZI_CA_VH_USER                  as _LastChangedBy on _LastChangedBy.Bname = $projection.LastChangedBy
  association [0..1] to ZI_CA_VH_WERKS                 as _Plant         on _Plant.WerksCode = $projection.Plant

{
  key guid                                                   as Guid,
      id                                                     as Id,
      concat_with_space( 'Documento ', ltrim( id, '0' ), 1 ) as IdText,
      status                                                 as Status,
      
      case when condition_type <> 'ZPR0'
           then 'X'
           else ' ' end           as hiddenITM,
      
      case when condition_type <> 'ZVMC'
           then 'X'
           else ' ' end           as hiddenMIN,
      
      case when condition_type <> 'ZALT'
           then 'X'
           else ' ' end           as hiddenINV,

      case status when '00' then 0      -- Em aberto
                  when '01' then 2      -- Em processamento
                  when '02' then 2      -- OK
                  when '03' then 1      -- Não OK
                  when '04' then 3      -- Finalizado
                  when '05' then 1      -- Alerta
                  when '10' then 1      -- Alerta Exportação
                  when '06' then 1      -- Análise
                            else 0
                  end                                        as StatusCriticality,

      condition_type                                         as ConditionType,
      _Param.PresentationType                                as PresentationType,
      request_user                                           as RequestUser,
//      approve_user                                           as ApproveUser,
//      approve_user_criticality                               as ApproveUserCriticality,
      plant                                                  as Plant,
      plant_criticality                                      as PlantCriticality,
      process_date                                           as ProcessDate,
      process_time                                           as ProcessTime,
      import_time                                            as ImportTime,
      @Semantics.user.createdBy: true
      created_by                                             as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                                             as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by                                        as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at                                        as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at                                  as LocalLastChangedAt,

      /* composition */
      _Item,
      _Minimo,
      _Invasao,
      _Mensagem,
      _Observacoes,
      /* Associations */
      _Param,
      _Status,
      _ConditionType,
      _RequestUser,
//      _ApproveUser,
      _Plant,
      _CreatedBy,
      _LastChangedBy
      
}
