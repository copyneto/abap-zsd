@AbapCatalog.internal.setChange: 'FLDADD_NO_ASS_INFLUENCE'
@AbapCatalog.sqlViewAppendName: 'ZZ1_80D83CB1F672'

extend view E_SALESDOCUMENTBASIC with ZZ1_ZJFIGBD7N46CPRYNREOXNNLYXA
    association [0..1] to I_CURRENCY as _ZZ1_PRICE_LB_SDH
  on  $projection.ZZ1_PRICE_LB_SDHC = _ZZ1_PRICE_LB_SDH.Currency 
 
{ 
@Semantics.amount.currencyCode: 'ZZ1_PRICE_LB_SDHC'
  Persistence.ZZ1_PRICE_LB_SDH as ZZ1_PRICE_LB_SDH,
@Semantics.currencyCode: true
@ObjectModel.foreignKey.association: '_ZZ1_PRICE_LB_SDH'
  Persistence.ZZ1_PRICE_LB_SDHC as ZZ1_PRICE_LB_SDHC,
  _ZZ1_PRICE_LB_SDH
}
