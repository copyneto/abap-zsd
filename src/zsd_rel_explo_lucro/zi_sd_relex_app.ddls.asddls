@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZI_SD_RELEX_APP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_APP
  as select from ZI_SD_RELEX_ITEM
{

  key CompanyCode,
      CompanyCodeName,
      CreationDate,
      BR_NFNumber,
      BR_NFSourceDocumentNumber,
      BusinessPlace,
      BR_NFDocumentType,
      BR_NotaFiscal,
      BR_NotaFiscalItem,
      Plant,
      Material,
      MaterialName,
      Batch,
      ValuationType,
      @ObjectModel.text.element: ['BR_CFOPDesc']
      BR_CFOPCode,
      BR_ReferenceNFNumber,
      BR_ReferenceNFItem,
      QtyDelivery,
      BaseUnit,
      doc_type,
      SalesDocumentCurrency,
      SalesOrganization,
      BusinessArea,
      FiscalMonthCurrentPeriod,
      FiscalYearCurrentPeriod,
      AdditionalMaterialGroup3Name,
      case
      when SalesOrganization is not initial and AdditionalMaterialGroup3Name is not initial
      then concat( concat(SalesOrganization, '-'), AdditionalMaterialGroup3Name )
      else SalesOrganization
       end                           as SalesOrgAtv,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      ValorTrans,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      BR_NFTotalAmount,
      /* Associations */
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      _ImpCOFINS.BR_NFItemTaxAmount  as VlrCONFIS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      _ImpICMS.BR_NFItemTaxAmount    as VlrICMS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      _ImpIPI.BR_NFItemTaxAmount     as VlrIPI,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      _ImpPIS.BR_NFItemTaxAmount     as VlrPIS,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      _ImpSUBTRIB.BR_NFItemTaxAmount as VlrSUBTRIB,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VlrTransLiq,

      _MARA,
      _ProductUnitEntryUnit,
      _ProductUnitUI,
      _MARA.MaterialBaseUnit,
      _CFOP.BR_CFOPDesc,
      @Aggregation.default: #SUM
      case
        when BaseUnit = 'KG'
        then QtyDelivery
        else
            case
              when _MARA.MaterialBaseUnit = 'KG'
              then QtyDelivery* DIVISION( (_ProductUnitEntryUnit.QuantityNumerator), (_ProductUnitEntryUnit.QuantityDenominator), 3)
              else QtyDelivery* DIVISION( (_ProductUnitEntryUnit.QuantityNumerator*_ProductUnitUI.QuantityDenominator), (_ProductUnitEntryUnit.QuantityDenominator*_ProductUnitUI.QuantityNumerator), 3)
              end
        end                          as QtyEmKg,
      StatusNF                       as StatusNF,
      _1Bstscode.text                as StatusNFText


      //    @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      //    unit_conversion( quantity    => QtyDelivery,
      //                     source_unit => BaseUnit,
      //                     target_unit => cast( 'KG' as abap.unit ) )  as QtyTeste

}
