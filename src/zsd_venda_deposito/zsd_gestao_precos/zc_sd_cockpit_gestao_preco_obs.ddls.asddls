@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão de Preço - Observações'
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_GESTAO_PRECO_OBS
  as projection on ZI_SD_COCKPIT_GESTAO_PRECO_OBS
{
  key  Guid,
  key  Line,  
       @EndUserText.label: 'Observação'
       Observacoes,
       @EndUserText.label: 'Criado por'
       CreatedBy,
       @EndUserText.label: 'Criado em'
       CreatedAt,
       @EndUserText.label: 'Alterado por'
       LastChangedBy,
       @EndUserText.label: 'Alterado em'
       LastChangedAt,
       LocalLastChangedAt,

       /* Associations */
       _Cockpit : redirected to parent ZC_SD_COCKPIT_GESTAO_PRECO
}
