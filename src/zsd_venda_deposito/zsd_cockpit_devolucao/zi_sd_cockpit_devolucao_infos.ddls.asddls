@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Devolução Aba Informações'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_INFOS
  as select from ztsd_devolucao as _Devolucao
  association to parent ZI_SD_COCKPIT_DEVOLUCAO as _Cockpit     on  $projection.Guid = _Cockpit.Guid
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
  association to ZI_SD_INFOS_NFTOTAL            as _InfosTotal  on  _InfosTotal.CNPJCliente = _Devolucao.cnpj
                                                                and _InfosTotal.Centro      = _Devolucao.centro
                                                                and _InfosTotal.Nfe         = _Devolucao.numero_nfe
                                                                and _InfosTotal.Serie       = _Devolucao.serie

  association to dd07t                          as _TextoStatus on  _TextoStatus.domvalue_l = $projection.Situacao
                                                                and _TextoStatus.domname    = 'ZD_SITUACAO_DEV'
                                                                and _TextoStatus.as4local   = 'A'
                                                                and _TextoStatus.ddlanguage = $session.system_language
{
  key _Devolucao.guid                  as Guid,
      _Devolucao.regiao                as Regiao,
      _Devolucao.ano                   as Ano,
      _Devolucao.mes                   as Mes,
      _Devolucao.modelo                as Modelo,
      _Devolucao.serie                 as Serie,
      _Devolucao.digito_verific        as DigitoVerific,
      _Devolucao.local_negocio         as Local_Negocio,
      _Devolucao.tipo_devolucao        as Tipo_Devolucao,
      _Devolucao.numero_nfe            as NumNFE,
      _Devolucao.cnpj                  as CNPJ,
      case when _Devolucao.cnpj  is initial then ''
           else concat( substring(_Devolucao.cnpj, 1, 2),
                concat( '.',
                concat( substring(_Devolucao.cnpj, 3, 3),
                concat( '.',
                concat( substring(_Devolucao.cnpj, 6, 3),
                concat( '/',
                concat( substring(_Devolucao.cnpj, 9, 4),
                concat( '-',  substring(_Devolucao.cnpj, 13, 2) ) ) ) ) ) ) ) )
       end                             as CNPJText,
      _Devolucao.ordem                 as Ordem_Info,
      _Devolucao.cliente               as Cliente_Info,
      _Devolucao.moedasd               as MoedaSd,
      @Semantics.amount.currencyCode: 'MoedaSd'
      _Devolucao.valor_totalnfe        as NFE_Total,
      _Devolucao.situacao              as Situacao,
      case _Devolucao.situacao
      when '0'
      then  0
      when '1'
      then  3
      when '2'
      then  3
      when '3'
      then  1
      when '4'
      then  2
      when '5'
      then  2
      else  0
      end                              as CorSituacao,
      _TextoStatus.ddtext              as StatusText, 
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
group by
  _Devolucao.guid,
  _Devolucao.regiao,
  _Devolucao.ano,
  _Devolucao.mes,
  _Devolucao.modelo,
  _Devolucao.serie,
  _Devolucao.digito_verific,
  _Devolucao.local_negocio,
  _Devolucao.tipo_devolucao,
  _Devolucao.numero_nfe,
  _Devolucao.cnpj,
  _Devolucao.ordem,
  _Devolucao.cliente,
  _Devolucao.moedasd,
  _Devolucao.valor_totalnfe,
  _Devolucao.situacao,
  _TextoStatus.ddtext,
  _Devolucao.created_by,
  _Devolucao.created_at,
  _Devolucao.last_changed_by,
  _Devolucao.last_changed_at,
  _Devolucao.local_last_changed_at
