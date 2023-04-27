@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_FAT
  as select from I_SDDocumentProcessFlow as Flow
    inner join   ZI_SD_FILT_STATUS_FAT   as Filter on  Filter.PrecedingDocument  = Flow.PrecedingDocument
                                                   and Filter.SubsequentDocument = Flow.SubsequentDocument

  association to ZI_SD_STATUS_NF   as _Nfe     on _Nfe.BR_NFSourceDocumentNumber = $projection.SubsequentDocument
  association to I_BillingDocument as _Billing on _Billing.BillingDocument = $projection.SubsequentDocument
{
      //Preceding
  key Flow.PrecedingDocument,
  key Flow.SubsequentDocument,
      Flow.PrecedingDocumentItem,
      Flow.PrecedingDocumentCategory,
      Flow.SubsequentDocumentItem,
      Flow.SubsequentDocumentCategory,
      _Nfe.BR_NotaFiscal,
      _Nfe.BR_CFOPCode,
      _Nfe.BR_NFNetAmount,
      _Nfe.BR_NFPostingDate,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _Nfe.HeaderNetWeight,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      _Nfe.HeaderGrossWeight,
      _Nfe.BR_NFIsPrinted,
      _Nfe.HeaderWeightUnit,
      _Nfe.BR_NFeNumber,
      _Nfe.BR_NFAuthenticationDate,
      _Billing.BillingDocument,
      _Billing.CreationDate

}
where
      Flow.SubsequentDocumentCategory = 'M'
  and Flow.SubsequentDocumentItem     = '000010'
