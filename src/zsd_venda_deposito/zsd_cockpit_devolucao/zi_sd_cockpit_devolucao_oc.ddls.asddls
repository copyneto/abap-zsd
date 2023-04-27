@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Ordem Complementar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_OC  
 as select from I_SDDocumentProcessFlow as _OrdemComp  
 association to  ZI_SD_COCKPIT_DEVOLUCAO_NFE as _Nfe on _Nfe.DocumentoVendas  = $projection.OrdemComplementar
 association to I_SalesOrder                 as _Ordem   on _Ordem.SalesOrder = $projection.OrdemComplementar{
  
  key  _OrdemComp.DocRelationshipUUID          as Documento,
       _OrdemComp.PrecedingDocument            as DocumentoVendas,
       _OrdemComp.SubsequentDocument           as OrdemComplementar,
       _Nfe.NfeComp                            as NfeComp,
       _Ordem.HeaderBillingBlockReason         as BloqueioFaturamento 
       
} where _OrdemComp.SubsequentDocumentCategory =  'C'
