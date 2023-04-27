@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Processo vs Tipo de Operação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_PROCESSO_TPOPER
  as select from ZI_SD_VH_TPOPER as TpOper
  association [1] to ZI_SD_VH_PROCESSO as _Processo on _Processo.Processo = TpOper.Processo
  association [1] to ztca_param_val as _Param on  _Param.modulo = 'SD'
                                              and _Param.chave1 = 'ADM_INTER'
                                              and _Param.chave2 = 'SHIP_COND'
                                              and _Param.chave3 = TpOper.tpOper
                                              and _Param.sign   = 'I'
                                              and _Param.opt    = 'EQ'
{
      @ObjectModel.text.element: ['NomeTpOper']
      @EndUserText: {label: 'Tipo de Operação', quickInfo: 'Tipo de Operação'}
  key TpOper.tpOper  as TpOper,
      @EndUserText: {label: 'Desc. Tipo de Operação', quickInfo: 'Descrição do Tipo de Operação'}
      @Semantics.text: true
      TpOper.Nome    as NomeTpOper,
      @ObjectModel.text.element: ['NomeProcesso']
      @EndUserText: {label: 'Processo', quickInfo: 'Processo'}
      _Processo.Processo,
      @EndUserText: {label: 'Desc. Processo', quickInfo: 'Descrição do Processo'}
      @Semantics.text: true
      _Processo.Text as NomeProcesso,
      @EndUserText: {label: 'Cond. Expedição', quickInfo: 'Condição de Expedição'}
      _Param.low   as CondExp
}
