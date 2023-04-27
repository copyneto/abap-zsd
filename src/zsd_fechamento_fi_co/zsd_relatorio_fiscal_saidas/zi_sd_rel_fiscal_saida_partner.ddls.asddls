@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_PARTNER
  as select from           I_BR_NFDocument      as _Doc
    inner join             ZI_SD_BUSCA_PARCEIRO as _PARCNFE   on _PARCNFE.docnum = _Doc.BR_NotaFiscal
  //  association to I_Customer as _Partner on _Partner.Customer = $projection.BR_NFPartner
  //      inner join             I_Customer           as _Partner on _Partner.Customer = _PARCNFE.parid
  

    left outer to one join j_1btindtypt         as _JTypt     on  _JTypt.j_1bindtyp = _PARCNFE.indtyp
                                                              and _JTypt.spras      = 'P'

    left outer to one join j_1bticmstaxpayt     as _JTypticms on  _JTypticms.j_1bicmstaxpay = _PARCNFE.icmstaxpay
                                                              and _JTypticms.spras          = 'P'

{
  
  key _Doc.BR_NotaFiscal,
      _PARCNFE.parid,
      _PARCNFE.indtyp as Industry,
      _PARCNFE.icmstaxpay,
      _PARCNFE.stcd2  as TaxNumber2,
      _PARCNFE.stcd3  as TaxNumber3,
      _JTypt.j_1bindtypx,
      _JTypticms.j_1bicmstaxpayx
}
