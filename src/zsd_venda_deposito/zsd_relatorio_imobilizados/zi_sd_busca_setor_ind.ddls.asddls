@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca Setor industrial'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_BUSCA_SETOR_IND
  as select from           kna1             as _Partner
    left outer to one join j_1btindtypt     as _JTypt     on  _JTypt.j_1bindtyp = _Partner.indtyp
                                                          and _JTypt.spras      = 'P'

    left outer to one join j_1bticmstaxpayt as _JTypticms on  _JTypticms.j_1bicmstaxpay = _Partner.icmstaxpay
                                                          and _JTypticms.spras          = 'P'
{

  key _Partner.kunnr,

      _Partner.indtyp     as Industry,
      _Partner.icmstaxpay as ICMSTAXPAY,
      _Partner.stcd2      as TaxNumber2,
      _Partner.stcd3      as TaxNumber3,
      _JTypt.j_1bindtypx,
      _JTypticms.j_1bicmstaxpayx


}
