@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_156201D1903D'

extend view E_SALESDOCUMENTBASIC with ZZ1_OBZJFGNC5UXV5HWUGLIEUTQNTQ
    association [0..1] to I_CURRENCY as _ZZ1_DIF_SDH
  on  $projection.ZZ1_DIF_SDHC = _ZZ1_DIF_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_DIF_SDHC'
  Persistence.ZZ1_DIF_SDH as ZZ1_DIF_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_DIF_SDH'
  Persistence.ZZ1_DIF_SDHC as ZZ1_DIF_SDHC,
  _ZZ1_DIF_SDH
}
