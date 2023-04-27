@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor Total un prd conf NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_TJ1BLPP as 
    select from I_BR_NFItem as _NFitem
    inner join j_1blpp as _J1BLPP on _NFitem.Material = _J1BLPP.matnr
     
{
    key _NFitem.BR_NotaFiscal as NotaFiscal,    
    _J1BLPP.lppid, 
    sum( cast(_J1BLPP.lppbrt as abap.fltp(16) ) + cast(_J1BLPP.subtval as abap.fltp(16) ) ) as VlTotalUnPrdConfS,
    sum( cast(_J1BLPP.lppbrt as abap.fltp(16) ) )                                            as VlUnPrdConfI    
}
group by
  _NFitem.BR_NotaFiscal,
  _J1BLPP.lppid  
  
