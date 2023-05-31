@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Obter informações para NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_INF_DISTRATO_NF as 

select from ZI_SD_INF_DISTRATO_CTR as _InfDis

join I_SalesContract as _Contrato on _InfDis.Contrato = _Contrato.SalesContract

join j_1bnfdoc as _doc on _InfDis.NFRetorno = _doc.nfenum      

{
    key _InfDis.Contrato,
    key _InfDis.ContratoItem,
    key _InfDis.NFRetorno,
    key _doc.docnum,
    _Contrato.DistributionChannel,
    _Contrato.SalesOrganization,
    _InfDis.Solicitacao,           
    _InfDis.Serie    
}
group by
    _InfDis.Contrato,
    _InfDis.ContratoItem,
    _InfDis.NFRetorno,
    _doc.docnum,
    _Contrato.DistributionChannel,
    _Contrato.SalesOrganization,
    _InfDis.Solicitacao,
    _InfDis.Serie  
