@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para ZCLSD_CMDLOC_DEVOL_MERCADORIA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CMDLOC_DEVOL_MERC_MOV_L
  as select from vbak

{
  key vbak.vgbel        as SalesContract,
      max( vbak.vbeln ) as SalesDocument
}
where
       vbak.vbtyp = 'C'
  and(
       vbak.auart = 'Y075'
    or vbak.auart = 'Y074'
    or vbak.auart = 'Y076'
    or vbak.auart = 'Y077'
    or vbak.auart = 'YR75'
    or vbak.auart = 'YD75'
    or vbak.auart = 'YR76'
    or vbak.auart = 'YD76'
    or vbak.auart = 'YR74'
    or vbak.auart = 'YD74'
    or vbak.auart = 'YR77'
    or vbak.auart = 'YD77'
  )
group by
  vbak.vgbel
