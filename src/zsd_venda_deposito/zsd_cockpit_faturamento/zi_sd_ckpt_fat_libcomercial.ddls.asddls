@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Última liberação comercial na OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_LIBCOMERCIAL
  as select from cdpos as _CDPOS
  association [1..1] to cdhdr as _CDHDR on  _CDPOS.objectclas = _CDPOS.objectclas
                                        and _CDPOS.objectid   = _CDPOS.objectid
                                        and _CDHDR.changenr   = _CDPOS.changenr
{
  max( _CDPOS.changenr ) as CHANGENR,
  max( _CDHDR.udate    ) as DataLiberacao,
  max( _CDHDR.utime    ) as HoraLiberacao,
  _CDPOS.objectid        as SalesOrder
}
where
      _CDPOS.objectclas = 'VERKBELEG'
  and _CDPOS.tabname    = 'VBAK'
  and _CDPOS.fname      = 'LIFSK'
  and _CDPOS.value_new  = ' '

group by
  _CDPOS.objectid
