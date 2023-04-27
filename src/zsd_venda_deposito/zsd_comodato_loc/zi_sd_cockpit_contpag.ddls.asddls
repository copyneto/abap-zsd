@AbapCatalog.sqlViewName: 'ZVSD_CONTPAG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Contas a Pagar para CDS Cockpit'
define view ZI_SD_COCKPIT_CONTPAG
  as select from    vbfa
        
    left outer join vbrk   as vbrk_ref on vbrk_ref.vbeln = vbfa.vbeln

    left outer join acdoca as acdoca_d on  acdoca_d.rbukrs = vbrk_ref.bukrs 
                                       and acdoca_d.gjahr = substring(vbrk_ref.fkdat, 1, 4)
                                       and acdoca_d.koart  = 'D'
                                       and acdoca_d.kunnr  = vbrk_ref.kunag
                                       and acdoca_d.zuonr  = vbrk_ref.zuonr

    left outer join acdoca as acdoca_k on  acdoca_k.rbukrs = vbrk_ref.bukrs 
                                       and acdoca_k.gjahr = substring(vbrk_ref.fkdat, 1, 4)
                                       and acdoca_k.koart  = 'K'                                       
                                       and acdoca_k.zuonr  = vbrk_ref.zuonr
{
  key vbelv      as Contrato,
  acdoca_d.belnr as DocCliente,
  acdoca_k.belnr as DocForn

}
where
  vbtyp_n = 'M'  
