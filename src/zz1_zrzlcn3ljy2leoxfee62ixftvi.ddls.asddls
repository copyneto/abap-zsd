@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_5C9C38784A73'

extend view C_INCOMPL_SALESDOCWL_F2430 with ZZ1_ZRZLCN3LJY2LEOXFEE62IXFTVI
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
