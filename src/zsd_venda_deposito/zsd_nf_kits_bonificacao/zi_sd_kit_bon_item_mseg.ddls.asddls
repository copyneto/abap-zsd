@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens de Kit'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_ITEM_MSEG
  as select from ZI_SD_KIT_BON_KITS as _Kit

    inner join   t001w              as _CentFil on  _Kit.Plant             = _CentFil.werks
                                                and _Kit.OrganizacaoVendas = _CentFil.vkorg
                                                and _Kit.CanalDistribuicao = _CentFil.vtweg

    inner join   ZI_SD_KIT_BON_MAST as _MAST    on _Kit.Matnr = _MAST.Matnr
                                                and _Kit.Plant = _MAST.Werks

    inner join   nsdm_e_mseg            as _MSEG    on  _Kit.Matnr = _MSEG.matnr
                                                and _Kit.PostingDate = _MSEG.budat_mkpf
                                                and _Kit.Plant = _MSEG.werks
                                                and '534'      = _MSEG.bwart

  association [1] to ztsd_kitbon_ctr as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.ebeln      = $projection.ebeln
                                                         and _ztsd_kitbon_ctr.matnr_kit  = $projection.MatnrKit
                                                         and _ztsd_kitbon_ctr.matnr_free = $projection.MatnrFree
                                                         and _ztsd_kitbon_ctr.dockit     = $projection.DocKit
                                                         and _ztsd_kitbon_ctr.estorno    is initial
{
  key _Kit.Matnr                                          as MatnrKit,
      _MSEG.ebeln                                          as ebeln,
      _MSEG.mblnr                                         as DocKit,
      _Kit.PostingDate                                    as PostingDate,
      _MAST.Werks                                         as Plant,
      _Kit.OrganizacaoVendas,
      _Kit.CanalDistribuicao,
      _CentFil.spart,
      _Kit.matkl,
      _MAST.stlan                                         as Stlan,
      _MAST.Stlnr                                         as Stlnr,
      _MAST.Stlal                                         as Stlal,
      _MAST.Erskz                                         as erskz,
      _MAST.Idnrk                                         as MatnrFree,
      _MAST.Posnr                                         as Posnr,
      _CentFil.kunnr                                      as kunnr,
      _MSEG.meins                                         as BaseUnit,
      _MSEG.erfme                                         as EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @DefaultAggregation: #SUM
      _MSEG.menge                                         as QuantityInEntryUnit,

      _MSEG.waers                                         as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(_MSEG.j_1bexbase as pph_dmbtr preserving type) as TotalGoodsMvtAmtInCCCrcy,
      //      _MFGORDER.ManufacturingOrder,

      _MSEG.bwart                                         as GoodsMovementType,
      _ztsd_kitbon_ctr
}
