@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contas a Pagar para CDS Cockpit Cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_CONTPAG_CLI 
  as select from    vbfa
        
    join vbrk   as vbrk_ref on vbrk_ref.vbeln = vbfa.vbeln
    
    join acdoca as acdoca_d on acdoca_d.rbukrs = vbrk_ref.bukrs 
                                       and acdoca_d.belnr = vbrk_ref.belnr 
                                       and acdoca_d.gjahr = substring(vbrk_ref.fkdat, 1, 4)
                                       and acdoca_d.koart  = 'D'
                                       and acdoca_d.kunnr  = vbrk_ref.kunag
                                       and acdoca_d.zuonr  = vbrk_ref.zuonr    

//    join acdoca as acdoca_d on  acdoca_d.rbukrs = vbrk_ref.bukrs 
//                                       and acdoca_d.gjahr = substring(vbrk_ref.fkdat, 1, 4)
//                                       and acdoca_d.koart  = 'D'
//                                       and acdoca_d.kunnr  = vbrk_ref.kunag
//                                       and acdoca_d.zuonr  = vbrk_ref.zuonr
{
  key vbfa.vbelv    as Contrato,
  acdoca_d.belnr    as DocCliente
}
where
  vbfa.vbtyp_n = 'M' 
 group by 
    vbfa.vbelv,
    acdoca_d.belnr
