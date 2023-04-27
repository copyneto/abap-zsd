@AbapCatalog.sqlViewName: 'ZVSDVHINDPRES'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help IndPres'
define view ZI_SD_VH_IndPres
  as select from dd07t
{
      @ObjectModel.text.element: ['descricao']
  key domvalue_l as Indpres,
      ddtext     as descricao
}
where
      domname    = 'J_1BNFE_INDPRES'
  and ddlanguage = $session.system_language
