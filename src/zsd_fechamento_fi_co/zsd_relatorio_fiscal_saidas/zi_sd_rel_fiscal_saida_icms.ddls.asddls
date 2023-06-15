@AbapCatalog.sqlViewName: 'ZVRELSAIDA'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Saida Icms'
define view ZI_SD_REL_FISCAL_SAIDA_ICMS
  as select from I_BR_NFDocument               as _Doc
    inner join   j_1bbranch                    as _Branch      on  _Branch.bukrs  = _Doc.CompanyCode
                                                               and _Branch.branch = _Doc.BusinessPlace

    inner join   adrc                          as _Adrc        on _Adrc.addrnumber = _Branch.adrnr
    inner join   ZTF_SD_REL_FISCAL_SAIDA_TXIC1 as _IcmsByRegio on  _IcmsByRegio.Land1    = _Adrc.country
                                                               and _IcmsByRegio.Shipfrom = _Adrc.region
                                                               and _IcmsByRegio.Shipto   = _Doc.BR_NFPartnerRegionCode
{
  key _Doc.BR_NotaFiscal,
  key _IcmsByRegio.Land1,
  key _IcmsByRegio.Shipfrom,
  key _IcmsByRegio.Shipto,
      _IcmsByRegio.Validfrom,
      _IcmsByRegio.Rate,
      _IcmsByRegio.RateF,
      _IcmsByRegio.SpecfRate,
      _IcmsByRegio.SpecfBase,
      _IcmsByRegio.PartilhaExempt,
      _IcmsByRegio.SpecfResale
}
