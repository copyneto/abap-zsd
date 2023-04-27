@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_A227AD897807'

extend view C_INCOMPL_SALESDOCWL_F2430 with ZZ1_YP3FQL56GO7Q7OHQYY2N5XSNKY
    association [0..1] to I_CURRENCY as _ZZ1_DIF_SDH
  on  $projection.ZZ1_DIF_SDHC = _ZZ1_DIF_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_DIF_SDHC'
  _Extension.ZZ1_DIF_SDH as ZZ1_DIF_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_DIF_SDH'
  _Extension.ZZ1_DIF_SDHC as ZZ1_DIF_SDHC,
  _ZZ1_DIF_SDH
}
