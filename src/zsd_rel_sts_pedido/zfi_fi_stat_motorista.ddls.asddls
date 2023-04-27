@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interface - Busca de campo Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZFI_FI_STAT_MOTORISTA as select from but000
{    
    key but000.partner,    
    case when
        but000.name1_text is not initial
    then
        but000.name1_text
     else
        concat( but000.name_first, but000.name_last ) end as name1    
}
