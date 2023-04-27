@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Desc. tip.prin ind.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_FISCAL_SAIDA_DescTip
  as select from    kna1  as _KNA1
    left outer join t016t as _T016T on  _T016T.brsch = _KNA1.brsch
                                    and _T016T.spras = $session.system_language
  association to j_1btindtypt as _J1BTINDTYPT on  _J1BTINDTYPT.j_1bindtyp = $projection.indtyp
                                              and _J1BTINDTYPT.spras      = $session.system_language
{

  key _KNA1.kunnr,
      _KNA1.brsch,
      _KNA1.icmstaxpay,
      _KNA1.tdt,
      _KNA1.indtyp,
      _T016T.brtxt,
      _J1BTINDTYPT.j_1bindtypx

}
