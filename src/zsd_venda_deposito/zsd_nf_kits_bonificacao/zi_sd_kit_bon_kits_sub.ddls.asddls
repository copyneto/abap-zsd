@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Kit Bonificação KITS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_KITS_sub
  as select from    mvke                     as _Mvke
    inner join      ZI_SD_KIT_BON_MATKL      as _Matkl           on _Mvke.mvgr4 = _Matkl.GrupoMerca
    inner join      nsdm_e_mseg              as _kit             on _kit.matnr = _Mvke.matnr

    inner join      t001w                    as _CentFil         on  _kit.werks  = _CentFil.werks
                                                                 and _Mvke.vkorg = _CentFil.vkorg
                                                                 and _Mvke.vtweg = _CentFil.vtweg

    inner join      ZI_SD_KIT_BON_MAST       as _mast            on _kit.matnr = _Mvke.matnr
    inner join      nsdm_e_mseg              as _free            on  _kit.ebeln  = _free.ebeln
                                                                 and _kit.ebelp  = _free.ebelp
                                                                 and _kit.mblnr  = _free.mblnr
                                                                 and _mast.Idnrk = _free.matnr
                                                                 and _mast.Matnr = _kit.matnr
                                                                 and '543'       = _free.bwart

    left outer join nsdm_e_mseg              as _estorno         on  _free.ebeln = _estorno.ebeln
                                                                 and _free.ebelp = _estorno.ebelp
                                                                 and '544'       = _estorno.bwart
                                                                 and _free.mblnr = _estorno.smbln
                                                                 and _free.zeile = _estorno.smblp

    left outer join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.ebeln      = _free.ebeln
                                                                 and _ztsd_kitbon_ctr.matnr_kit  = _kit.matnr
                                                                 and _ztsd_kitbon_ctr.matnr_free = _mast.Idnrk
                                                                 and _ztsd_kitbon_ctr.dockit     = _kit.mblnr
                                                                 and _ztsd_kitbon_ctr.estorno    is initial

    left outer join ZI_SD_KIT_BON_STPO_CALC1 as _QtdCalc1        on  _QtdCalc1.Stlnr = _mast.Stlnr
                                                                 and _QtdCalc1.Idnrk = _mast.Idnrk

    left outer join ZI_SD_KIT_BON_STPO_CALC2 as _QtdCalc2        on  _QtdCalc2.Stlnr = _mast.Stlnr
                                                                 and _QtdCalc2.Idnrk = _mast.Idnrk
{

  key _kit.matnr                                          as MatnrKit,
  key _kit.mblnr                                          as DocKit,
  key _kit.budat_mkpf                                     as PostingDate,
  key _kit.werks                                          as Plant,
  key _free.bwart                                         as GoodsMovementType,
  key _free.ebeln                                         as PediSubc,
  key _free.mblnr,
  key _free.zeile,
      _Mvke.vkorg                                         as OrganizacaoVendas,
      _Mvke.vtweg                                         as CanalDistribuicao,
      _CentFil.spart,
      _Matkl.GrupoMerca                                   as matkl,
      _mast.stlan                                         as Stlan,
      _mast.Stlnr                                         as Stlnr,
      _mast.Stlal                                         as Stlal,
      _mast.Erskz                                         as erskz,
      _mast.Idnrk                                         as MatnrFree,
      _mast.Posnr                                         as Posnr,
      _CentFil.kunnr                                      as kunnr,
      _free.meins                                         as BaseUnit,
      _free.meins                                         as EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      @DefaultAggregation: #SUM
      _free.menge                                          as QuantityInEntryUnit,

      fltp_to_dec( ( cast(  _free.menge as abap.fltp( 13, 3 ) ) / cast( _QtdCalc2.Menge as abap.fltp( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      * _QtdCalc1.Menge                                   as QuantityInEntryUnitCalc,

      _free.waers                                         as CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @DefaultAggregation: #SUM
      cast(_free.j_1bexbase as pph_dmbtr preserving type) as TotalGoodsMvtAmtInCCCrcy,
      ''                                                  as ManufacturingOrder,
      _ztsd_kitbon_ctr.vbeln                              as Vbeln,
      _ztsd_kitbon_ctr.created_by                         as CreatedBy,
      _ztsd_kitbon_ctr.created_at                         as CreatedAt,
      _ztsd_kitbon_ctr.last_changed_by                    as LastChangedBy,
      _ztsd_kitbon_ctr.last_changed_at                    as LastChangedAt,
      _ztsd_kitbon_ctr.local_last_changed_at              as LocalLastChangedAt,
      _ztsd_kitbon_ctr.estorno                            as Estorno,
      _estorno.mblnr                                      as estornomblnr
}
