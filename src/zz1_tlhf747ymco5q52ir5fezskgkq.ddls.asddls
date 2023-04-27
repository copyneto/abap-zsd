@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_4BDF6EEF772A'

extend view C_SALESORDERWL_F1873 with ZZ1_TLHF747YMCO5Q52IR5FEZSKGKQ
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
