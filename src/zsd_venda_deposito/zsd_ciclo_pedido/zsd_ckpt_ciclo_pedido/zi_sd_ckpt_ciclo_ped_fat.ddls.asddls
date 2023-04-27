@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Doc Fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_CICLO_PED_FAT
  as select from I_SDDocumentProcessFlow
  association to ZI_SD_CKPT_CICLO_PED_NF as _Nfe     on _Nfe.BR_NFSourceDocumentNumber = $projection.SubsequentDocument
  association to I_BillingDocument       as _Billing on _Billing.BillingDocument = $projection.SubsequentDocument
{

  key DocRelationshipUUID,

      //Preceding
      PrecedingDocument,
      PrecedingDocumentItem,
      PrecedingDocumentCategory,

      //Subsequent
      SubsequentDocument,
      SubsequentDocumentItem,
      SubsequentDocumentCategory,
      _Nfe.BR_NotaFiscal,
      _Nfe.BR_NFPartnerRegionCode,
      _Nfe.BR_NFIsPrinted,
      _Nfe.BR_NFeDocumentStatus,
      _Nfe.BR_NFeNumber,
      _Billing.BillingDocumentIsCancelled,
      _Billing.CreationDate,
      _Billing.CreationTime

}
where
      SubsequentDocumentCategory          = 'M'
  and _Billing.BillingDocumentIsCancelled = ''
