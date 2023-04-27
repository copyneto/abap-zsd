@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Doc Fatura e Remessa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_CICLO_PED_DOC
  as select from I_SDDocumentProcessFlow as _SDDocumentFlow
  association to ZI_SD_MONITOR_FAT as _FlowFatura on _FlowFatura.PrecedingDocument = $projection.SubsequentDocument
{
  key _SDDocumentFlow.DocRelationshipUUID,

  key _SDDocumentFlow.PrecedingDocument,
  key _SDDocumentFlow.PrecedingDocumentItem,
      _SDDocumentFlow.SubsequentDocument,
      case
        when _SDDocumentFlow.SubsequentDocument is not null then _SDDocumentFlow.SubsequentDocument
        else cast( '0000000000' as vbeln )
      end as Remessa,
      case
      when _FlowFatura.SubsequentDocument is not null then _FlowFatura.SubsequentDocument
      else cast( '0000000000' as vbeln )
      end as Fatura,

      case
          when _FlowFatura.BR_NotaFiscal is not null then _FlowFatura.BR_NotaFiscal
          else cast( '0000000000' as j_1bdocnum )
      end as BR_NotaFiscal,
      case
        when _FlowFatura.BR_NFeNumber is not null then _FlowFatura.BR_NFeNumber
        else cast( '000000000' as logbr_nfnum9 )
      end as BR_NFeNumber
}
where
      _SDDocumentFlow.SubsequentDocumentCategory = 'J'
  and _SDDocumentFlow.SubsequentDocumentItem     = '000010'
