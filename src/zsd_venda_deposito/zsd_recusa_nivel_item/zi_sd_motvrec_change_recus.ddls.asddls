@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Modificação da Recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MOTVREC_CHANGE_RECUS
  as select from    ZI_SD_MOTVREC_CDPOS as Cdpos

    left outer join cdhdr               as Cdhdr on cdhdr.changenr = Cdpos.changenr

{
  key substring(Cdpos.tabkey, 4, 10) as SalesOrder,
  key substring(Cdpos.tabkey, 14, 6) as SalesOrderItem,
      cdhdr.udate    as DataModificacao,
      cdhdr.username as ModificadoPor
}
