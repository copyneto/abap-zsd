@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_JUSTIF_ATRASO_TO as select from /scmtms/d_tordrf as _DRF
    inner join /scmtms/d_torrot as _ROT on _ROT.db_key = _DRF.parent_key
                                       and _ROT.tor_cat = 'TO'

 {
    key _DRF.btd_id as SalesOrder,
        _ROT.tor_id as OrdemFrete
} where _DRF.btd_tco = '114'
