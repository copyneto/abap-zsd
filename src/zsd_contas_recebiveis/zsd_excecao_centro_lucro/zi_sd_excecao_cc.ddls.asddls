@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Exceção Centro de Custo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_EXCECAO_CC as select from ztsd_excecao_cc
    association [0..1] to ZI_CA_VH_WERKS as _Centro on _Centro.WerksCode =  $projection.Centro
    association [0..1] to ZI_CA_VH_BZIRK as _RegiaoVendas on _RegiaoVendas.RegiaoVendas =  $projection.RegiaoVendas
    association [0..1] to ZI_CA_VH_KOSTL as _CentroCusto on _CentroCusto.CentroCusto =  $projection.CentroCusto
                                                     

{
    key werks as Centro,    
    key bzirk as RegiaoVendas,    
    kostl as CentroCusto,
    _Centro.WerksCodeName as DescricaoCentro,
    _RegiaoVendas.RegiaoVendasText as DescricaoRegiaoVendas,
    _CentroCusto.Descricao as DescricaoCentroCusto,
    @Semantics.user.createdBy: true
    created_by as CreatedBy,
    @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
    @Semantics.user.lastChangedBy: true
    last_changed_by as LastChangedBy,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at as LastChangedAt,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at as LocalLastChangedAt
}
