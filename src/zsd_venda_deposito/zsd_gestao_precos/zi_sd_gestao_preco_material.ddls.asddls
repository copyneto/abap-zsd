@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados de material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_GESTAO_PRECO_MATERIAL
  as select from ztsd_preco_i as _Item
    inner join   ztsd_preco_h as _Header        on _Header.guid = _Item.guid
    inner join   marc         as _MaterialPlant on  _MaterialPlant.matnr = _Item.material
                                                and _MaterialPlant.werks = _Header.plant
    inner join   t2500        as _Family        on _Family.wwmt1 = substring(
      _MaterialPlant.prctr, 1, 2
    )
    inner join   t2249        as _Brand         on _Brand.kmbrnd = substring(
      _MaterialPlant.prctr, 3, 2
    )

  association [0..1] to t25a0 as _FamilyText on  _FamilyText.wwmt1 = $projection.Family
                                             and _FamilyText.spras = $session.system_language
  association [0..1] to t22e9 as _BrandText  on  _BrandText.kmbrnd = $projection.Brand
                                             and _BrandText.spras  = $session.system_language

{
  key _Item.guid                          as Guid,
  key _Item.line                          as Line,
      _Header.plant                       as Plant,
      _Item.material                      as Material,
      _MaterialPlant.prctr                as CostCenter,
      cast( _Family.wwmt1 as rkeg_wwmt1 ) as Family,
      cast( _Brand.kmbrnd as rkeskmbrnd ) as Brand,

      /* Associations */
      _FamilyText,
      _BrandText
}
