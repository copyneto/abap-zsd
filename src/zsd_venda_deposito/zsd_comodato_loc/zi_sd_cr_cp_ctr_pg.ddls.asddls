@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verificação status pagamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CR_CP_CTR_PG as 
    select from ZI_SD_CR_CP
    
    left outer join I_CalendarDate as _Calendar on _Calendar.CalendarDate = $session.system_date 

{
    key ZI_SD_CR_CP.Contrato                                   
}
where
    ZI_SD_CR_CP.DocFinRecebimento is not initial and 
    substring(ZI_SD_CR_CP.Datafaturamento, 5, 2) = _Calendar.CalendarMonth
group by
    ZI_SD_CR_CP.Contrato    
