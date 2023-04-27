@EndUserText.label: 'Projection Cockpit Devolução Anexo'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_DEVOLUCAO_ANEXO
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_ANEXO as Arquivos
{
  key Guid,
  key Line,
      LocalNegocio,
      TipoDevolucao,
      Regiao,
      Ano,
      Mes,
      Cnpj,
      Modelo,
      Serie,
      Nfe,
      DigitoVerific,
      Filename,
      Mimetype,
      Value,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      /* Associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_DEVOLUCAO
}
