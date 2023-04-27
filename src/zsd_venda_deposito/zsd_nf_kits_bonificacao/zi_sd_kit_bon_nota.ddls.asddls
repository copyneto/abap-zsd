@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS com as notas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NOTA
  as select from    ZI_SD_KIT_BON_CONT1 as _item
    left outer join ZI_SD_KIT_BON_FAT   as _DocFaturamentoItem on _DocFaturamentoItem.Ordem = _item.Vbeln
  //inner join  I_BR_NFItem as _nf_item on  _nf_item.BR_NFSourceDocumentNumber = _DocFaturamentoItem.SubsequentDocument
  //left outer join  I_BR_NFItem as _nf_item on  _nf_item.BR_NFSourceDocumentNumber = _DocFaturamentoItem.SubsequentDocument
  //and _nf_item.BR_NFSourceDocumentType   = 'BI'
    left outer join ZI_SD_KIT_BON_DOC   as _nf_item            on _nf_item.BR_NFSourceDocumentNumber = _DocFaturamentoItem.SubsequentDocument


{
  key _item.MatnrKit,
      _item.DocKit,
      _item.PostingDate,
      _item.Plant,
      _item.matkl,
      _item.MatnrFree,
      _item.kunnr,
      _item.BaseUnit,
      _item.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      @DefaultAggregation: #SUM
      case
      when _item.QuantityInEntryUnitCalc = _item.QuantityInEntryUnit
      then  cast( _item.QuantityInEntryUnit  as abap.dec( 13,3 ) )
      else _item.QuantityInEntryUnitCalc
      end                    as QuantityInEntryUnit,
      _item.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      _item.TotalGoodsMvtAmtInCCCrcy,
      _item.ManufacturingOrder,
      _item.GoodsMovementType,
      _item.Vbeln,
      _item.Posnr,
      _item.CreatedBy,
      _item.CreatedAt,
      _item.LastChangedBy,
      _item.LastChangedAt,
      _item.LocalLastChangedAt,
      _item.PediSubc,
      /* Associations */
      //      _item._SDDocument.SubsequentDocument,
      _DocFaturamentoItem.SubsequentDocument,
      //      _DocFaturamentoItem.posnr as Item,
      _nf_item.BR_NotaFiscal as NotaFiscal
}
