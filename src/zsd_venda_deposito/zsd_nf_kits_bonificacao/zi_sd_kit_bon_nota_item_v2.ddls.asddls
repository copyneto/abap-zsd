@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Itens NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NOTA_ITEM_V2 
    as select from ZI_SD_KIT_BON_NOTA as _nota
    left outer join ZI_SD_KIT_BON_NOTA_IMP_H as _imp on _nota.NotaFiscal = _imp.BR_NotaFiscal       
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
      //case when _nota.NotaFiscal is not initial then _nota.NotaFiscal else  cast( '' as j_1bdocnum) end as NotaFiscal,
      _nota.NotaFiscal, 
      //_nota._nf_item.BR_NotaFiscal                                                                     as NotaFiscal,
      //ltrim(_nf_item.BR_NotaFiscal, '0') as Nfe_Output,                        
      ltrim(_nota.NotaFiscal, '0') as Nfe_Output,
      _imp.BaseAmountICM3 as baseicms,//as vlricms,
      _imp.TaxAmountICM3 as vlricms,//as baseicms,
      _imp.BaseAmountICS3 as baseicss,//as vlricss,
      _imp.TaxAmountICS3 as vlricss,//as baseicss,
      _imp.BaseAmountIPI3 as baseipi,//as vlripi,
      _imp.TaxAmountIPI3 as vlripi,//as baseipi,          
      _nf_document,
      _Matkit.MaterialName                                                                             as MaterialName_kit,
      _Matfre.MaterialName                                                                             as MaterialName_free    
}
group by
    _nota.MatnrKit,
    _nota.DocKit,
    _nota.PostingDate,
    _nota.Plant,
    _nota.matkl,
    _nota.MatnrFree,
    _nota.kunnr,
    _nota.BaseUnit,
    _nota.EntryUnit,
    _nota.QuantityInEntryUnit,
    _nota.CompanyCodeCurrency,
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
    _nota.NotaFiscal,  
    _imp.BaseAmountICM3,
    _imp.TaxAmountICM3,
    _imp.BaseAmountICS3,
    _imp.TaxAmountICS3,
    _imp.BaseAmountIPI3,
    _imp.TaxAmountIPI3,      
    _Matkit.MaterialName,
    _Matfre.MaterialName
