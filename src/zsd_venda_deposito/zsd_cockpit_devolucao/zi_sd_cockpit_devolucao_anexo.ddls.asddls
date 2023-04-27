@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Anexo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_ANEXO
  as select from ztsd_anexo_dev
  association to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit on $projection.Guid = _Cockpit.Guid
  //  association to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit on $projection.LocalNegocio          = _Cockpit.LocalNegocio
  //                                                           and $projection.TipoDevolucao         = _Cockpit.TipoDevolucao
  //                                                           and $projection.Regiao                = _Cockpit.Regiao
  //                                                           and $projection.Ano                   = _Cockpit.Ano
  //                                                           and $projection.Mes                   = _Cockpit.Mes
  //                                                           and $projection.Cnpj                  = _Cockpit.Cnpj
  //                                                           and $projection.Modelo                = _Cockpit.Modelo
  //                                                           and $projection.Serie                 = _Cockpit.Serie
  //                                                           and $projection.Nfe                   = _Cockpit.Nfe
  //                                                           and $projection.DigitoVerific         = _Cockpit.DigitoVerific
{
       @UI.hidden: true
  key  guid                  as Guid,
       @UI.hidden: true
  key  line                  as Line,
       local_negocio         as LocalNegocio,
       @UI.hidden: true
       tipo_devolucao        as TipoDevolucao,
       @UI.hidden: true
       regiao                as Regiao,
       @UI.hidden: true
       ano                   as Ano,
       @UI.hidden: true
       mes                   as Mes,
       @UI.hidden: true
       cnpj                  as Cnpj,
       @UI.hidden: true
       modelo                as Modelo,
       @UI.hidden: true
       serie                 as Serie,
       @UI.hidden: true
       numero_nfe            as Nfe,
       @UI.hidden: true
       digito_verific        as DigitoVerific,

       @EndUserText.label: 'Arquivo'
       filename              as Filename,
       @EndUserText.label: 'Extensão'
       mimetype              as Mimetype,
       @UI.hidden: true
       @EndUserText.label: 'Conteúdo'
       value                 as Value,
       @Semantics.user.createdBy: true
       created_by            as CreatedBy,
       @Semantics.systemDateTime.createdAt: true
       created_at            as CreatedAt,
       @Semantics.user.lastChangedBy: true
       last_changed_by       as LastChangedBy,
       @Semantics.systemDateTime.lastChangedAt: true
       last_changed_at       as LastChangedAt,
       @Semantics.systemDateTime.localInstanceLastChangedAt: true
       local_last_changed_at as LocalLastChangedAt,

       _Cockpit

}
