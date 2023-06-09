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

    select from           vbap                      as _ContratoItem

    join                  vbak                      as _Contrato      on _ContratoItem.vbeln = _Contrato.vbeln
    
    join                  ser02                     as _Ser02         on  _Ser02.sdaufnr = _ContratoItem.vbeln
                                                                      and _Ser02.posnr   = _ContratoItem.posnr    
    
    join                  objk                      as _Objk          on _Objk.obknr = _Ser02.obknr
    
    join                  ZI_SD_INF_DISTRATO_CTR_NF as _objnf         on _Objk.sernr = _objnf.Serie
    
    join                  vbkd                      as _Vbkd          on  _Vbkd.vbeln = _ContratoItem.vbeln
                                                                      and _Vbkd.posnr = _ContratoItem.posnr        
    
    join j_1bnfdoc                                  as _Doc           on _objnf.DocReferencia = _Doc.nfenum      

{
    key _ContratoItem.vbeln as Contrato,
    key _ContratoItem.posnr as ContratoItem,
    key _objnf.DocReferencia as NFRetorno,
    key _Doc.docnum,
    _Contrato.vtweg as DistributionChannel,
    _Contrato.vkorg as SalesOrganization,
    _Vbkd.ihrez as Solicitacao,           
    _Objk.sernr as Serie    
}
group by
    _ContratoItem.vbeln,
    _ContratoItem.posnr,
    _objnf.DocReferencia,
    _Doc.docnum,
    _Contrato.vtweg,
    _Contrato.vkorg,
    _Vbkd.ihrez,
    _Objk.sernr
