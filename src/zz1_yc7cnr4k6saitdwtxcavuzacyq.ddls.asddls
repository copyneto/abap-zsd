@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_1A53AAD03275'

extend view C_QUOTATIONWL_F1852 with ZZ1_YC7CNR4K6SAITDWTXCAVUZACYQ
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
