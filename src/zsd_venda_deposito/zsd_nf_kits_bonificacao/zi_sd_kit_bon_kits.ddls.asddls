@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Kit Bonificação KITS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_KITS as select from mvke as _Mvke
  inner join ZI_SD_KIT_BON_MATKL as _Matkl on  _Mvke.mvgr4  = _Matkl.GrupoMerca  
  inner join I_MfgOrderMaterialDocumentItem as _I_DocumentItem on  _I_DocumentItem.Material = _Mvke.matnr
{
   
   key _Mvke.vkorg as OrganizacaoVendas,
   key _Mvke.vtweg as CanalDistribuicao,
   key _Mvke.matnr as Matnr,   
   _I_DocumentItem.MaterialDocument,
   _I_DocumentItem.PostingDate,
   _I_DocumentItem.Plant as Plant,
   _I_DocumentItem.ManufacturingOrder as OrdemProd,
   _Matkl.GrupoMerca as matkl //_I_DocumentItem._Material.MaterialGroup as matkl //_Mara.matkl
   //_Mvke.mvgr4 as matkl   
}
