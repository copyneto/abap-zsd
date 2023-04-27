@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Contratos - Informações NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_INF_DISTRATO_CTR_NF as 
    select from matdoc as _matdoc

    join ser03 as _ser03 on _matdoc.mblnr = _ser03.mblnr and 
                            _matdoc.mjahr = _ser03.mjahr and 
                            _matdoc.zeile = _ser03.zeile
    
    left outer join objk as _objk on _ser03.obknr = _objk.obknr 
{
    key _objk.sernr as Serie,    
    max(_matdoc.xblnr) as DocReferencia
}
where
    _ser03.bwart = 'YG6' or _ser03.bwart = 'YG8'
group by
    _objk.sernr,
    _matdoc.xblnr
