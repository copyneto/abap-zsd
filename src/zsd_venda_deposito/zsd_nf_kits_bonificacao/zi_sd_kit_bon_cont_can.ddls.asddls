@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDs com as inf controle cancelamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_CONT_CAN 
as select from    ZI_SD_KIT_BON_KITS      as _kit
    inner join ZI_SD_KIT_BON_ITEM      as _item on _item.MatnrKit = _kit.Matnr
    
    //left outer join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.aufnr      = _item.ManufacturingOrder
    inner join ztsd_kitbon_ctr          as _ztsd_kitbon_ctr on  _ztsd_kitbon_ctr.aufnr      = _item.ManufacturingOrder    
                                            and _ztsd_kitbon_ctr.matnr_kit  = _item.MatnrKit
                                            and _ztsd_kitbon_ctr.matnr_free = _item.MatnrFree
                                            and _ztsd_kitbon_ctr.dockit     = _kit.MaterialDocument
                                            and _ztsd_kitbon_ctr.estorno    is not initial    
    
//    left outer join ZI_SD_KIT_BON_ITEM_MSEG as _mseg on _mseg.MatnrKit = _kit.Matnr
{
  key _kit.Matnr                                   as MatnrKit, 
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
      _item.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _item.TotalGoodsMvtAmtInCCCrcy,
      _item.ManufacturingOrder,
      _item.GoodsMovementType,
      _item.Posnr,
      ' '                 as Vbeln,
      _ztsd_kitbon_ctr.created_by            as CreatedBy,
      _ztsd_kitbon_ctr.created_at            as CreatedAt,
      _ztsd_kitbon_ctr.last_changed_by       as LastChangedBy,
      _ztsd_kitbon_ctr.last_changed_at       as LastChangedAt,
      _ztsd_kitbon_ctr.local_last_changed_at as LocalLastChangedAt,
      _ztsd_kitbon_ctr.aufnr                as ztsd_kitbon_ctraufnr,
      _item.ManufacturingOrder              as itemManufacturingOrder,
      _ztsd_kitbon_ctr.matnr_kit            as ztsd_kitbon_ctrmatnr_kit, 
      _item.MatnrKit                        as itemMatnrKit,
      _ztsd_kitbon_ctr.matnr_free           as ztsd_kitbon_ctrmatnr_free,
      _item.MatnrFree                       as itemMatnrFree,
      _ztsd_kitbon_ctr.dockit               as ztsd_kitbon_ctrdockit,
      _kit.MaterialDocument                 as kitMaterialDocument,
      _ztsd_kitbon_ctr.estorno              as ztsd_kitbon_ctrestorno
}    
//where
    //( _ztsd_kitbon_ctr.estorno is not initial )
