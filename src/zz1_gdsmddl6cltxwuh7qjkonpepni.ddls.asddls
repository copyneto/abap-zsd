@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_31231E18FC46'

extend view I_SALESDOCUMENT with ZZ1_GDSMDDL6CLTXWUH7QJKONPEPNI
    association [0..1] to I_CURRENCY as _ZZ1_PRICEKG_SDH
  on  $projection.ZZ1_PRICEKG_SDHC = _ZZ1_PRICEKG_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_PRICEKG_SDHC'
  _Extension.ZZ1_PRICEKG_SDH as ZZ1_PRICEKG_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_PRICEKG_SDH'
  _Extension.ZZ1_PRICEKG_SDHC as ZZ1_PRICEKG_SDHC,
  _ZZ1_PRICEKG_SDH
}
