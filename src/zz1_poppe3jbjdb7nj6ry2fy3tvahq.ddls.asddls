@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_35A6F580E7C3'

extend view I_SALESDOCUMENT with ZZ1_POPPE3JBJDB7NJ6RY2FY3TVAHQ
    association [0..1] to I_CURRENCY as _ZZ1_PRICE_LB_SDH
  on  $projection.ZZ1_PRICE_LB_SDHC = _ZZ1_PRICE_LB_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_PRICE_LB_SDHC'
  _Extension.ZZ1_PRICE_LB_SDH as ZZ1_PRICE_LB_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_PRICE_LB_SDH'
  _Extension.ZZ1_PRICE_LB_SDHC as ZZ1_PRICE_LB_SDHC,
  _ZZ1_PRICE_LB_SDH
}
