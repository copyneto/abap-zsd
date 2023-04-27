@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Aba Transporte'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_TRANS
  as select from ztsd_devolucao as _Devolucao
  association to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit    on  $projection.Guid = _Cockpit.Guid
//  association to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit    on  $projection.Local_Negocio  = _Cockpit.LocalNegocio
//                                                               and $projection.Tipo_Devolucao = _Cockpit.TipoDevolucao
//                                                               and $projection.Regiao         = _Cockpit.Regiao
//                                                               and $projection.Ano            = _Cockpit.Ano
//                                                               and $projection.Mes            = _Cockpit.Mes
//                                                               and $projection.CNPJ           = _Cockpit.Cnpj
//                                                               and $projection.Modelo         = _Cockpit.Modelo
//                                                               and $projection.Serie          = _Cockpit.Serie
//                                                               and $projection.NumNFE         = _Cockpit.Nfe
//                                                               and $projection.DigitoVerific  = _Cockpit.DigitoVerific

{
  key _Devolucao.guid               as Guid,
      _Devolucao.regiao             as Regiao,
      _Devolucao.ano                as Ano,
      _Devolucao.mes                as Mes,
      _Devolucao.modelo             as Modelo,
      _Devolucao.serie              as Serie,
      _Devolucao.digito_verific     as DigitoVerific,
      _Devolucao.local_negocio      as Local_Negocio,
      _Devolucao.tipo_devolucao     as Tipo_Devolucao,
      _Devolucao.numero_nfe         as NumNFE,
      _Devolucao.cnpj               as CNPJ,
      _Devolucao.motorista          as Motorista,
      _Devolucao.placa              as Placa,
      _Devolucao.tipo_expedicao     as Tipo_Expedicao,
      _Devolucao.transportadora     as Transportadora,
      @Semantics.user.createdBy: true
      _Devolucao.created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      _Devolucao.created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      _Devolucao.last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      _Devolucao.last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      _Devolucao.local_last_changed_at as LocalLastChangedAt,

      /* associations */
      _Cockpit
}
