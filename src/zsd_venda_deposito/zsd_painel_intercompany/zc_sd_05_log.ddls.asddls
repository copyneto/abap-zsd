@EndUserText.label: 'Log - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@Search.searchable: true
define view entity ZC_SD_05_LOG
  as projection on ZI_SD_05_LOG
{
  @EndUserText: {label: 'Guid', quickInfo: 'Chave única gerada automaticamente'}
  key Guid,
  @EndUserText: {label: 'Sequencia'}
  key Seqnr,
      Msgty,
      Msgid,
      Msgno,
      Msgv1,
      Msgv2,
      Msgv3,
      Msgv4,
      Message,

      /* Associations */
      _cockpit : redirected to parent ZC_SD_01_COCKPIT

}
