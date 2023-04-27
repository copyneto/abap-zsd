@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão das devoluções e-commerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ECOMMERCE_DEV 
    as select from ZI_SD_MONITOR_APP as _Monitor
        inner join vbfa as _Fluxo on _Monitor.Fatura = _Fluxo.vbelv and _Fluxo.vbtyp_n = 'H'     

{
    key _Monitor.SalesOrder,
    key _Monitor.Fatura  
}
where 
    _Fluxo.posnv is initial
group by
    _Monitor.SalesOrder,
    _Monitor.Fatura
