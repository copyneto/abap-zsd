@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data da liberação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_DATALIB
  as select from cdhdr as _cdhdr
    inner join   cdpos as _cdpos on _cdpos.changenr = _cdhdr.changenr
{

    key _cdpos.tabkey as SalesOrder,
    max(_cdpos.changenr ) as changenr,
    _cdhdr.udate


}
where
      _cdpos.objectclas = 'VERKBELEG'
  and _cdpos.tabname    = 'VBAK'
  and _cdpos.fname      = 'LIFSK'
group by
  _cdpos.objectid,
  _cdpos.tabkey,
  _cdpos.fname,
  _cdhdr.udate
