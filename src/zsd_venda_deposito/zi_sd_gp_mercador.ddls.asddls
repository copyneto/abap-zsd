@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface cadastro de Grp Mercadorias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@Metadata.allowExtensions: true
define root view entity ZI_SD_GP_MERCADOR
  as select from ztsd_gp_mercador
{
  key centro                as Centro,
  key uf                    as Uf,
  key grpmercadoria         as GrpMercadoria,
      descricao             as Descricao,
      agregado              as Agregado,
      icms_dest             as IcmsDest,
      icms_orig             as IcmsOrig,
      compra_interna        as CompraInterna,
      base_red_orig         as BaseRedOrig,
      base_red_dest         as BaseRedDest,
      taxa_fcp              as TaxaFcp,
      icms_efet             as IcmsEfet,
      baseredefet           as BaseRedEfet,
      preco_compar          as PrecoCompar,
      preco_pauta           as PrecoPauta,
      agregado_pauta        as AgregadoPauta,
      nro_unids             as NroUnids,
      um                    as Um,
      modalidade            as Modalidade, 
      calc_efetivo          as CalcEfetivo,
      perc_bc_icms          as PercentualBcIcms,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt
      
     
}
