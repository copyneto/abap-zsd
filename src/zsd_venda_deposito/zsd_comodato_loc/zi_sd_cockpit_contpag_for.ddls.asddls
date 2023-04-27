@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contas a Pagar para CDS Cockpit Fornecedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_CONTPAG_FOR 
  as select from    vbfa
        
    join vbrk   as vbrk_ref on vbrk_ref.vbeln = vbfa.vbeln


    join acdoca as acdoca_k on  acdoca_k.rbukrs = vbrk_ref.bukrs 
                                       //and acdoca_k.augbl  = vbrk_ref.belnr
                                       and acdoca_k.gjahr = substring(vbrk_ref.fkdat, 1, 4)
                                       and acdoca_k.koart  = 'K'    
                                       and acdoca_k.lifnr  = vbrk_ref.kunag                                   
                                       and acdoca_k.zuonr  = vbrk_ref.zuonr
{
  key vbfa.vbelv      as Contrato,  
  acdoca_k.belnr      as DocForn
}
where
  vbfa.vbtyp_n = 'M'  
group by
    vbfa.vbelv,
    acdoca_k.belnr
