@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help meio de pagamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_SD_VH_MEIO_PAGAMENTO
  as select from t042z as FormaPagto

  association        to t042zt                    as _Text      on  $projection.FormaPagtoId = _Text.zlsch
                                                                and $projection.Pais         = _Text.land1
                                                                and _Text.spras              = $session.system_language
  association [1..1] to ZI_SD_COCKPIT_NOTA_FISCAL as _Devolucao on  _Devolucao.Nfe = $projection.Nfe
{

  key land1                        as Pais,
      @ObjectModel.text.element: ['Texto']
      @Search.defaultSearchElement: true
  key zlsch                        as FormaPagtoId,
      @Search.defaultSearchElement: true
      _Text.text2                  as Texto,
      @UI.hidden: true
      _Devolucao.ChaveAcesso,
      _Devolucao.Cliente,
      @UI.hidden: true
      _Devolucao.Nfe               as Nfe,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_MEIO_PAGAMENTO'
      @UI.hidden: true
      cast( ' ' as abap.char(15) ) as Banco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_MEIO_PAGAMENTO'
      @UI.hidden: true
      cast( ' ' as abap.char(60) ) as DenomiBanco,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_MEIO_PAGAMENTO'
      @UI.hidden: true
      cast( ' ' as abap.char(15) ) as Agencia,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_MEIO_PAGAMENTO'
      @UI.hidden: true
      cast( ' ' as abap.char(18) ) as Conta,
      cast( ' ' as  fleet_flag )   as FlagDadosBancarios

}
where
  FormaPagto.land1 = 'BR'
//group by
//  land1,
//  zlsch,
//  _Text.text2,
//  _Devolucao.Nfe
