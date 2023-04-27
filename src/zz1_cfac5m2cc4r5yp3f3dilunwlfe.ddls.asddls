@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_88AADAFF9AC7'

extend view E_SALESDOCUMENTBASIC with ZZ1_CFAC5M2CC4R5YP3F3DILUNWLFE
    association [0..1] to I_CURRENCY as _ZZ1_PRICEKG_SDH
  on  $projection.ZZ1_PRICEKG_SDHC = _ZZ1_PRICEKG_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_PRICEKG_SDHC'
  Persistence.ZZ1_PRICEKG_SDH as ZZ1_PRICEKG_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_PRICEKG_SDH'
  Persistence.ZZ1_PRICEKG_SDHC as ZZ1_PRICEKG_SDHC,
  _ZZ1_PRICEKG_SDH
}
