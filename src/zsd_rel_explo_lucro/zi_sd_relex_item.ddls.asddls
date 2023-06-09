@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens do relatório'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_RELEX_ITEM
  as select from           I_BR_NFItem                    as _NFItem

    left outer join        I_BillingDocument              as _BillingDoc    on _BillingDoc.BillingDocument = _NFItem.BR_NFSourceDocumentNumber
    left outer to one join I_AccountingDocument           as _Accont        on  _BillingDoc.AccountingDocument = _Accont.AccountingDocument
                                                                            and _BillingDoc.BillingDocument    = _Accont.OriginalReferenceDocument


    left outer join        ZI_SD_RELEX_FILT_LAST_MVKE     as _Mvke          on  _Mvke.Matnr = _NFItem.Material
                                                                            and _Mvke.VKorg = _BillingDoc.SalesOrganization

  //    left outer join mvke                           as _VendaMaterial on _NFItem.Material = _VendaMaterial.matnr
    left outer join        I_AdditionalMaterialGroup3Text as _MaterialGroup on  _MaterialGroup.AdditionalMaterialGroup3 = _Mvke.Mvgr3
                                                                            and _MaterialGroup.Language                 = $session.system_language

  association [1]    to ZI_SD_RELEX_TAX         as _ImpICMS              on  _NFItem.BR_NotaFiscal     = _ImpICMS.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpICMS.BR_NotaFiscalItem
                                                                         and 'ICMS'                    = _ImpICMS.GrupoImposto

  association [1]    to ZI_SD_RELEX_TAX         as _ImpIPI               on  _NFItem.BR_NotaFiscal     = _ImpIPI.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpIPI.BR_NotaFiscalItem
                                                                         and 'IPI'                     = _ImpIPI.GrupoImposto
  association [1]    to ZI_SD_RELEX_TAX         as _ImpFCP               on  _NFItem.BR_NotaFiscal     = _ImpFCP.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpFCP.BR_NotaFiscalItem
                                                                         and 'FCP'                     = _ImpFCP.GrupoImposto

  association [1]    to ZI_SD_RELEX_TAX         as _ImpSUBTRIB           on  _NFItem.BR_NotaFiscal     = _ImpSUBTRIB.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpSUBTRIB.BR_NotaFiscalItem
                                                                         and 'SUBTRIB'                 = _ImpSUBTRIB.GrupoImposto

  association [1]    to ZI_SD_RELEX_TAX         as _ImpPIS               on  _NFItem.BR_NotaFiscal     = _ImpPIS.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpPIS.BR_NotaFiscalItem
                                                                         and 'PIS'                     = _ImpPIS.GrupoImposto

  association [1]    to ZI_SD_RELEX_TAX         as _ImpCOFINS            on  _NFItem.BR_NotaFiscal     = _ImpCOFINS.BR_NotaFiscal
                                                                         and _NFItem.BR_NotaFiscalItem = _ImpCOFINS.BR_NotaFiscalItem
                                                                         and 'COFINS'                  = _ImpCOFINS.GrupoImposto

  association [0..1] to I_Material              as _MARA                 on  $projection.Material = _MARA.Material
  association [0..1] to I_ProductUnitsOfMeasure as _ProductUnitUI        on  _ProductUnitUI.Product         = $projection.Material
                                                                         and _ProductUnitUI.AlternativeUnit = 'KG'

  association [0..1] to I_ProductUnitsOfMeasure as _ProductUnitEntryUnit on  $projection.Material = _ProductUnitEntryUnit.Product
                                                                         and $projection.BaseUnit = _ProductUnitEntryUnit.AlternativeUnit

  association [0..1] to I_BR_CFOPText           as _CFOP                 on  _CFOP.Language    = $session.system_language
                                                                         and _CFOP.BR_CFOPCode = $projection.BR_CFOPCode

  association [0..1] to I_BillingDocument       as _HeaderFat            on  _HeaderFat.BillingDocument = $projection.BR_NFSourceDocumentNumber

  association [0..1] to I_BillingDocumentItem   as _ItemFat              on  _ItemFat.BillingDocument        = $projection.BR_NFSourceDocumentNumber
                                                                         and _ItemFat.BillingDocumentItem    = _NFItem.BR_NotaFiscalItem
                                                                         and _NFItem.BR_NFSourceDocumentType = 'BI'

  association [0..1] to I_ProductValuation      as _ProductValuation     on  _ProductValuation.Product       = $projection.Material
                                                                         and _ProductValuation.ValuationArea = $projection.ValuationArea
                                                                         and _ProductValuation.ValuationType = $projection.ValuationType

  association [0..1] to j_1bnfe_active          as _Active               on  _Active.docnum = _NFItem.BR_NotaFiscal

  association [0..1] to j_1bstscodet            as _1Bstscode            on  _1Bstscode.spras = $session.system_language
                                                                         and _1Bstscode.code  = $projection.StatusNF
{
  _NFItem._BR_NotaFiscal.CompanyCode,
  _NFItem._BR_NotaFiscal.CompanyCodeName,
  _NFItem._BR_NotaFiscal.CreationDate,
  //  _NFItem._BR_NotaFiscal.BR_NFNumber,
  _Active.nfnum9                                            as BR_NFNumber,
  _NFItem._BR_NotaFiscal.BusinessPlace,
  _NFItem._BR_NotaFiscal.BR_NFDocumentType,
  _NFItem.BR_NotaFiscal,
  _NFItem.BR_NotaFiscalItem,
  _NFItem.Plant,
  _NFItem.Material,
  _NFItem.MaterialName,
  _NFItem.Batch,
  _NFItem.ValuationType,
  _NFItem.ValuationArea,
  _NFItem.BR_CFOPCode,
  _NFItem.BR_ReferenceNFNumber,
  _NFItem.BR_ReferenceNFItem,
  _NFItem.BR_NFSourceDocumentNumber,
  _NFItem._BR_NotaFiscal.SalesDocumentCurrency,
  @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  @Aggregation.default:#SUM
  _NFItem.BR_NFTotalAmount,
  cast(_NFItem.QuantityInBaseUnit as logbr_sumofbothmonths) as QtyDelivery,
  _NFItem.BaseUnit,
  case
    when _NFItem._BR_NotaFiscal.BR_NFDocumentType = '1' then 'NV'
    when _NFItem._BR_NotaFiscal.BR_NFDocumentType = '6' then 'DV'
    else ''
  end                                                       as doc_type,


  @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  //    cast(  cast(  _NFItem.NetValueAmount as abap.dec(15,2) ) +
  //           cast( _ImpIPI.BR_NFItemTaxAmount as abap.dec(15,2) ) +
  //           cast( _ImpSUBTRIB.BR_NFItemTaxAmount as abap.dec(15,2) ) as abap.curr(15,2) ) as ValorTrans,

  cast(       case
//     when _NFItem.NetValueAmount  is null then cast( 0 as abap.dec(15,2))
//     else cast( _NFItem.NetValueAmount as abap.dec(15,2))
//     when _NFItem.BR_NFTotalAmount  is null then cast( 0 as abap.dec(15,2))
//     else cast( _NFItem.BR_NFTotalAmount as abap.dec(15,2))
//     when _NFItem.BR_NFValueAmountWithTaxes is initial or _NFItem.BR_NFValueAmountWithTaxes is null
//     then 0
//     else cast(_NFItem.BR_NFValueAmountWithTaxes as abap.dec( 15, 2 ) )
     when _NFItem.BR_NFTotalAmountWithTaxes is initial or _NFItem.BR_NFValueAmountWithTaxes is null
     then 0
     else cast(_NFItem.BR_NFTotalAmountWithTaxes as abap.dec( 15, 2 ) )
     end
     +
     case
     when _ImpIPI.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
     else cast( _ImpIPI.BR_NFItemTaxAmount as abap.dec(15,2))
     end
     +
     case
     when _ImpFCP.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
     else cast( _ImpFCP.BR_NFItemTaxAmount as abap.dec(15,2))
     end
     +
     case
     when _ImpSUBTRIB.BR_NFItemTaxAmount  is null then cast( 0 as abap.dec(15,2))
     else cast( _ImpSUBTRIB.BR_NFItemTaxAmount  as abap.dec(15,2))
     end  as abap.curr(15,2) )                              as ValorTrans,

  //  _NFItem.NetValueAmount                                    as ValorTrans,

  //    @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  //    cast(cast( _NFItem.BR_NFTotalAmount as abap.dec(15,2)) -
  //    ( cast( _ImpCOFINS.BR_NFItemTaxAmount as abap.dec(15,2)) + cast( _ImpICMS.BR_NFItemTaxAmount as abap.dec(15,2)) +
  //     cast( _ImpIPI.BR_NFItemTaxAmount as abap.dec(15,2)) + cast( _ImpPIS.BR_NFItemTaxAmount as abap.dec(15,2)) +
  //     cast( _ImpSUBTRIB.BR_NFItemTaxAmount as abap.dec(15,2)) ) as abap.curr(15,2))  as VlrTransLiq,

  @Semantics.amount.currencyCode:'SalesDocumentCurrency'
  cast(case
        when _NFItem.BR_NFTotalAmount is null then cast( 0 as abap.dec(15,2))
        else cast( _NFItem.BR_NFTotalAmount as abap.dec(15,2))
        end
        - (
        case
        when _ImpCOFINS.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
        else cast( _ImpCOFINS.BR_NFItemTaxAmount as abap.dec(15,2))
        end
        +
        case
        when _ImpICMS.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
        else cast( _ImpICMS.BR_NFItemTaxAmount as abap.dec(15,2))
        end
        +
//        case
//        when _ImpIPI.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
//        else cast( _ImpIPI.BR_NFItemTaxAmount as abap.dec(15,2))
//        end
//        +
        case
        when _ImpPIS.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
        else cast( _ImpPIS.BR_NFItemTaxAmount as abap.dec(15,2))
        end )
//        +
//        case
//        when _ImpSUBTRIB.BR_NFItemTaxAmount is null then cast( 0 as abap.dec(15,2))
//        else cast( _ImpSUBTRIB.BR_NFItemTaxAmount as abap.dec(15,2))
//       end ) 
 as abap.curr(15,2) )                           as VlrTransLiq,

  _Active.code                                              as StatusNF,

  _HeaderFat.SalesOrganization,
  _ItemFat.BusinessArea,
  _ProductValuation.FiscalMonthCurrentPeriod,
  //  _ProductValuation.FiscalYearCurrentPeriod,
  case
  when _Accont.FiscalYear is initial or _Accont.FiscalYear = '0000'
  then RIGHT(_NFItem.BR_NFSourceDocumentNumber,4)
  else _Accont.FiscalYear end                               as FiscalYearCurrentPeriod,
  _MaterialGroup.AdditionalMaterialGroup3Name,
  _ImpICMS,
  _ImpIPI,
  _ImpSUBTRIB,
  _ImpPIS,
  _ImpCOFINS,
  _MARA,
  _ProductUnitUI,
  _ProductUnitEntryUnit,
  _CFOP,
  _1Bstscode

}
where
   ( _NFItem._BR_NotaFiscal.BR_NFDocumentType = '1' or
     _NFItem._BR_NotaFiscal.BR_NFDocumentType = '2' or
     _NFItem._BR_NotaFiscal.BR_NFDocumentType = '6' )
  and
    ( ( ( _BillingDoc.BillingDocumentType = 'Z005' or 
          _HeaderFat .BillingDocumentType = 'Z005' or
          _ItemFat.SalesDocumentItemCategory = 'Z005' ) and 
         _Active.docsta = '1' ) or 
         _Active.code   = '100' )
