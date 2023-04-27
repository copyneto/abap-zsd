@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf - Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_NF
  as select from I_BR_NFItem
  association to I_BR_NFDocument as _Nfe    on _Nfe.BR_NotaFiscal = $projection.BR_NotaFiscal
  association to I_BR_NFeActive  as _NfeAct on _NfeAct.BR_NotaFiscal = $projection.BR_NotaFiscal
{
  BR_NFSourceDocumentNumber,
  BR_NotaFiscal,
  max(BR_CFOPCode) as BR_CFOPCode,
  _Nfe.BR_NFNetAmount,
  _Nfe.BR_NFPostingDate,
  @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
  _Nfe.HeaderNetWeight,
  @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
  _Nfe.HeaderGrossWeight,
  _Nfe.BR_NFIsPrinted,
  _Nfe.HeaderWeightUnit,
  _NfeAct.BR_NFeNumber,
  _NfeAct.BR_NFAuthenticationDate


}
where
  BR_NFSourceDocumentType = 'BI'
group by
  BR_NFSourceDocumentNumber,
  BR_NotaFiscal,
  //  BR_CFOPCode,
  _Nfe.BR_NFNetAmount,
  _Nfe.BR_NFPostingDate,
  _Nfe.HeaderNetWeight,
  _Nfe.HeaderGrossWeight,
  _Nfe.BR_NFIsPrinted,
  _Nfe.HeaderWeightUnit,
  _NfeAct.BR_NFeNumber,
  _NfeAct.BR_NFAuthenticationDate
