@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS com os item da notas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NOTAITEM
  as select from ZI_SD_KIT_BON_NOTA   as _nota

  association [1] to I_BR_NFTax      as _icm3        on  _icm3.BR_NotaFiscal = $projection.NotaFiscal
                                                     and _icm3.BR_TaxType    = 'ICM3'
  association [1] to I_BR_NFTax      as _ics3        on  _ics3.BR_NotaFiscal = $projection.NotaFiscal
                                                     and _ics3.BR_TaxType    = 'ICS3'
  association [1] to I_BR_NFTax      as _ipi3        on  _ipi3.BR_NotaFiscal = $projection.NotaFiscal
                                                     and _ipi3.BR_TaxType    = 'IPI3'
  association [1] to I_BR_NFDocument as _nf_document on  _nf_document.BR_NotaFiscal = $projection.NotaFiscal
  association     to C_Materialvh    as _Matkit      on  $projection.MatnrKit = _Matkit.Material
  association     to C_Materialvh    as _Matfre      on  $projection.MatnrFree = _Matfre.Material

{
  key _nota.MatnrKit,
      _nota.DocKit,
      _nota.PostingDate,
      _nota.Plant,
      _nota.matkl,
      _nota.MatnrFree,
      _nota.kunnr,
      _nota.BaseUnit,
      _nota.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      _nota.QuantityInEntryUnit,
      _nota.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _nota.TotalGoodsMvtAmtInCCCrcy,
      _nota.ManufacturingOrder,
      _nota.GoodsMovementType,
      _nota.Vbeln,
      _nota.Posnr,
      _nota.CreatedBy,
      _nota.CreatedAt,
      _nota.LastChangedBy,
      _nota.LastChangedAt,
      _nota.LocalLastChangedAt,
      _nota.SubsequentDocument,
      _nota.PediSubc,
      concat( substring( _nota.PostingDate, 5, 2 ), concat('.', substring( _nota.PostingDate, 1, 4 ))) as referencia,
      concat( substring( _nota.PostingDate, 5, 2 ), concat('.', substring( _nota.PostingDate, 1, 4 ))) as competencia,
      /* Associations */
      NotaFiscal,
      //_nota._nf_item.BR_NotaFiscal                                                                     as NotaFiscal,
      //ltrim(_nf_item.BR_NotaFiscal, '0') as Nfe_Output,                        
      ltrim(NotaFiscal, '0') as Nfe_Output,
      _icm3,
      _ics3,
      _ipi3,
      _nf_document,
      _Matkit.MaterialName                                                                             as MaterialName_kit,
      _Matfre.MaterialName                                                                             as MaterialName_free
            
}
