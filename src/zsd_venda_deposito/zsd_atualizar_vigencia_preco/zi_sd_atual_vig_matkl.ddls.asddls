@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDs Grupo de Mercadoria'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ATUAL_VIG_MATKL 
as select from  mara as _mara  
inner join t023 as _t023 on _mara.matkl = _t023.matkl
inner join t023t as t023t on  t023t.spras = $session.system_language and 
                              t023t.matkl = _t023.matkl
{
    key _mara.matnr as matnr,
    key _mara.matkl as matkl,
    t023t.wgbez60 as matklText
    
}
