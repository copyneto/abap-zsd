@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução NFE Complementar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_NFE 
 as select from I_SDDocumentProcessFlow as _NfeComp
association to ZI_SD_COCKPIT_DEVOLUCAO_NFNUM as _Nfe on _Nfe.DocOrigem = $projection.FaturaNfe{
  
  key  _NfeComp.DocRelationshipUUID          as Documento,
       _NfeComp.PrecedingDocument            as DocumentoVendas,
       _NfeComp.SubsequentDocument           as FaturaNfe,
       _Nfe.NfeComp                          as NfeComp
} where _NfeComp.SubsequentDocumentCategory =  'M'
