@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS com as informações de controle'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_CONT
  as select from    ZI_SD_KIT_BON_ITEM       as _item

    left outer join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr     on  _ztsd_kitbon_ctr.aufnr      = _item.ManufacturingOrder
    //inner join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.aufnr      = _item.ManufacturingOrder
                                                                     and _ztsd_kitbon_ctr.matnr_kit  = _item.MatnrKit
                                                                     and _ztsd_kitbon_ctr.matnr_free = _item.MatnrFree
                                                                     and _ztsd_kitbon_ctr.dockit     = _item.DocKit
                                                                     and _ztsd_kitbon_ctr.estorno    is initial

    left outer join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr_can on  _ztsd_kitbon_ctr.aufnr          = _item.ManufacturingOrder
    //inner join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.aufnr      = _item.ManufacturingOrder
                                                                     and _ztsd_kitbon_ctr_can.matnr_kit  = _item.MatnrKit
                                                                     and _ztsd_kitbon_ctr_can.matnr_free = _item.MatnrFree
                                                                     and _ztsd_kitbon_ctr_can.dockit     = _item.DocKit
                                                                     and _ztsd_kitbon_ctr_can.estorno    is not initial

  //    left outer join ZI_SD_KIT_BON_ITEM_MSEG as _mseg on _mseg.MatnrKit = _kit.Matnr

    left outer join ZI_SD_KIT_BON_STPO_CALC1 as _QtdCalc1            on  _QtdCalc1.Stlnr = _item.Stlnr
                                                                     and _QtdCalc1.Idnrk = _item.MatnrFree

    left outer join ZI_SD_KIT_BON_STPO_CALC2 as _QtdCalc2            on  _QtdCalc2.Stlnr = _item.Stlnr
                                                                     and _QtdCalc2.Idnrk = _item.MatnrFree

{
  key _item.MatnrKit                                                                                                                                  as MatnrKit,
      _item.DocKit,
      _item.PostingDate,
      _item.Plant,
      _item.matkl,
      _item.MatnrFree,
      _item.kunnr,
      _item.BaseUnit,
      _item.EntryUnit,
      @Semantics.quantity.unitOfMeasure: 'EntryUnit'
      _item.QuantityInEntryUnit,
      fltp_to_dec( ( cast(  _item.QuantityInEntryUnit as abap.fltp( 13, 3 ) ) / cast( _QtdCalc2.Menge as abap.fltp( 13, 3 ) ) ) as abap.dec( 13, 3 ) )
      * _QtdCalc1.Menge                                                                                                                               as QuantityInEntryUnitCalc,

      _item.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _item.TotalGoodsMvtAmtInCCCrcy,
      _item.ManufacturingOrder,
      _item.GoodsMovementType,
      _item.Posnr,

      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.vbeln else _ztsd_kitbon_ctr_can.vbeln end                                 as Vbeln,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.created_by else _ztsd_kitbon_ctr_can.created_by end                       as CreatedBy,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.created_at else _ztsd_kitbon_ctr_can.created_at end                       as CreatedAt,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.last_changed_by else _ztsd_kitbon_ctr_can.last_changed_by end             as LastChangedBy,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.last_changed_at else _ztsd_kitbon_ctr_can.last_changed_at end             as LastChangedAt,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.local_last_changed_at else _ztsd_kitbon_ctr_can.local_last_changed_at end as LocalLastChangedAt,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.aufnr else _ztsd_kitbon_ctr_can.aufnr end                                 as ztsd_kitbon_ctraufnr,

      --_ztsd_kitbon_ctr.vbeln                 as Vbeln,
      --_ztsd_kitbon_ctr.created_by            as CreatedBy,
      --_ztsd_kitbon_ctr.created_at            as CreatedAt,
      --_ztsd_kitbon_ctr.last_changed_by       as LastChangedBy,
      --_ztsd_kitbon_ctr.last_changed_at       as LastChangedAt,
      --_ztsd_kitbon_ctr.local_last_changed_at as LocalLastChangedAt,
      --_ztsd_kitbon_ctr.aufnr                as ztsd_kitbon_ctraufnr,
      _item.ManufacturingOrder                                                                                                                        as itemManufacturingOrder,

      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.matnr_kit else _ztsd_kitbon_ctr_can.matnr_kit end                         as ztsd_kitbon_ctrmatnr_kit,
      --_ztsd_kitbon_ctr.matnr_kit            as ztsd_kitbon_ctrmatnr_kit,
      _item.MatnrKit                                                                                                                                  as itemMatnrKit,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.matnr_free else _ztsd_kitbon_ctr_can.matnr_free end                       as ztsd_kitbon_ctrmatnr_free,
      --_ztsd_kitbon_ctr.matnr_free           as ztsd_kitbon_ctrmatnr_free,
      _item.MatnrFree                                                                                                                                 as itemMatnrFree,
      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.dockit else _ztsd_kitbon_ctr_can.aufnr end                                as ztsd_kitbon_ctrdockit,
      --_ztsd_kitbon_ctr.dockit               as ztsd_kitbon_ctrdockit,

      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.dockit else _ztsd_kitbon_ctr_can.dockit end                               as kitMaterialDocument,
      --'1'                 as kitMaterialDocument,
      --_kit.MaterialDocument                 as kitMaterialDocument,

      case when _ztsd_kitbon_ctr.vbeln is not initial then _ztsd_kitbon_ctr.estorno else _ztsd_kitbon_ctr_can.estorno end                             as ztsd_kitbon_ctrestorno
      --_ztsd_kitbon_ctr.estorno              as ztsd_kitbon_ctrestorno
}
