@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Log de criação ordem de venda excel'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_LOGMSG_OV as select from ztsd_logmsg_ov {
    key guid as Guid,
    msgty as Msgty,
    msgid as Msgid,
    msgno as Msgno,
    msgv1 as Msgv1,
    msgv2 as Msgv2,
    msgv3 as Msgv3,
    msgv4 as Msgv4,
    message as Message
}
