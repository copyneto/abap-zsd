@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Ultima Fatura do Contrato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_INF_DISTRATO_FAT as 
    select from vbfa 
{
    key vbelv,
    key posnv,
    max(vbeln) as Fatura
}
where 
    vbtyp_n = 'O'
group by
    vbelv,
    posnv
