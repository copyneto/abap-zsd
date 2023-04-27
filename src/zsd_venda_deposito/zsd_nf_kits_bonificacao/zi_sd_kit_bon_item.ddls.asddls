@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens de Kit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_ITEM
  as select from    ZI_SD_KIT_BON_KITS             as _Kit

    inner join      t001w                          as _CentFil on  _Kit.Plant             = _CentFil.werks
                                                               and _Kit.OrganizacaoVendas = _CentFil.vkorg
                                                               and _Kit.CanalDistribuicao = _CentFil.vtweg


    inner join ZI_SD_KIT_BON_MAST             as _MAST    on  _Kit.Matnr = _MAST.Matnr
                                                               and _Kit.Plant = _MAST.Werks

    inner join I_MfgOrderMaterialDocumentItem as _Mov     on   _Mov.ManufacturingOrder = _Kit.OrdemProd //and _Mov.MaterialDocument = _Kit.MaterialDocument
                                                               and _Mov.Material         = _MAST.Idnrk

    inner join  I_MfgOrderMaterialDocumentItem as _MFGORDER    on  _MFGORDER.ManufacturingOrder = _Kit.OrdemProd //_MFGORDER.MaterialDocument = $projection.DocKit
                                                               and _MFGORDER.Material           = _MAST.Idnrk
                                                               and _MFGORDER.PostingDate        = _Kit.PostingDate
                                                               and _MFGORDER.MaterialDocumentItem  =  _Mov.MaterialDocumentItem

/*  association [1] to t001w                          as _t001w           on  _t001w.werks = _Kit.Plant
  association [1] to I_MfgOrderMaterialDocumentItem as _MFGORDER        on  _MFGORDER.ManufacturingOrder = _Kit.OrdemProd //_MFGORDER.MaterialDocument = $projection.DocKit
                                                                        and _MFGORDER.Material           = $projection.MatnrFree
                                                                        and _MFGORDER.PostingDate        = _Kit.PostingDate
  association [1] to ztsd_kitbon_ctr                as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.aufnr      = $projection.manufacturingorder
                                                                        and _ztsd_kitbon_ctr.matnr_kit  = $projection.MatnrKit
                                                                        and _ztsd_kitbon_ctr.matnr_free = $projection.MatnrFree
                                                                        and _ztsd_kitbon_ctr.dockit     = _Kit.MaterialDocument
                                                                        and _ztsd_kitbon_ctr.estorno    is initial */
{
  key _Kit.Matnr                                                            as MatnrKit,
      //_Kit.MaterialDocument                                                 as DocKit,
      _MFGORDER.MaterialDocument                                            as DocKit,
      //_Mov.MaterialDocument                                                 as DocKit,
      _Kit.PostingDate                                                      as PostingDate,
      _Kit.Plant                                                            as Plant,
      _Kit.OrganizacaoVendas,
      _Kit.CanalDistribuicao,      
      _CentFil.spart,
      _Mov.MaterialDocumentItem                                             as item,
      _Kit.matkl                                                            as matkl,
      _MAST.stlan                                                           as Stlan,
      _MAST.Stlnr                                                           as Stlnr,
      _MAST.Stlal                                                           as Stlal,
      _MAST.Erskz                                                           as erskz,
      _MAST.Idnrk                                                           as MatnrFree,
      _MAST.Posnr                                                           as Posnr,
      _CentFil.kunnr                                                          as kunnr,
      _MFGORDER.BaseUnit                                                    as BaseUnit,
      _MFGORDER.EntryUnit,
      _MFGORDER.MaterialDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @DefaultAggregation: #SUM
      _MFGORDER.QuantityInBaseUnit                                          as QuantityInEntryUnit,

      _MFGORDER.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(_MFGORDER.TotalGoodsMvtAmtInCCCrcy as pph_dmbtr preserving type) as TotalGoodsMvtAmtInCCCrcy,
      _MFGORDER.ManufacturingOrder,

      case
      when cast( coalesce( _Mov.GoodsMovementType, '' ) as abap.char(3) ) = ''
      then _MFGORDER.GoodsMovementType
      else _Mov.GoodsMovementType
      end                                                                   as GoodsMovementType,
      _Kit.Plant as KitPlant,
      _CentFil.werks as CentFilwerks,
      _Kit.OrganizacaoVendas as KitOrganizacaoVendas, 
      _CentFil.vkorg as CentFilvkorg,
      _Kit.CanalDistribuicao as KitCanalDistribuicao,
      _CentFil.vtweg as CentFilvtweg,
      _Kit.Matnr as KitMatnr,
      _MAST.Matnr as MASTMatnr,
      _Kit.Plant as KitPlant1,
      _MAST.Werks as MASTWerks
}
