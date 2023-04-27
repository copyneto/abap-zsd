@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona Paletização'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_PALLET
  as select from    ZI_SD_CKPT_AGEN_REG_COND      as _RegistroCondicoes
    left outer join kondp                         as _Condicoes       on _Condicoes.knumh = _RegistroCondicoes.RegCondicao
    left outer join I_PackingInstructionHeader    as _HeaderEmbalagem on _HeaderEmbalagem.PackingInstructionSystemUUID = _Condicoes.packnr
    left outer join I_PackingInstructionComponent as _Pallet          on  _Pallet.PackingInstructionSystemUUID   = _HeaderEmbalagem.PackingInstructionSystemUUID
                                                                      and _Pallet.PackingInstructionItemCategory = 'P'
    left outer join I_PackingInstructionComponent as _PalletItem      on  _PalletItem.PackingInstructionSystemUUID = _HeaderEmbalagem.PackingInstructionSystemUUID
                                                                      and _PalletItem.Material                     = _RegistroCondicoes.Material

{
  key _RegistroCondicoes.SalesOrder,
  key _RegistroCondicoes.SalesOrderItem,
      _RegistroCondicoes.RegCondicao,
      _Condicoes.packnr                                                                       as NomeEmbalagem,
      _HeaderEmbalagem.PackingInstructionSystemUUID                                           as NormaEmbalagem,
      _Pallet.BaseUnitofMeasure,
      @Semantics.quantity.unitOfMeasure: 'BaseUnitofMeasure'
      _Pallet.PackingInstructionItmTargetQty                                                  as QtyPallet,
      @Semantics.quantity.unitOfMeasure: 'BaseUnitofMeasure'
      _PalletItem.PackingInstructionItmTargetQty                                              as QtyPalletItem,
      @Semantics.quantity.unitOfMeasure: 'BaseUnitofMeasure'
      _RegistroCondicoes.OrderQuantity,

      cast( _Pallet.PackingInstructionItmTargetQty as abap.fltp )  /
      cast( _PalletItem.PackingInstructionItmTargetQty as abap.fltp )  *
      cast( _RegistroCondicoes.OrderQuantity as abap.fltp  )                                  as PalletItem


}
where
  _RegistroCondicoes.RegCondicao is not initial
