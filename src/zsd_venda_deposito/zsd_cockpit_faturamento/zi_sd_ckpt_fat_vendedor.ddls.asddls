@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Vendedor da ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_VENDEDOR
  as select from I_SalesOrderPartner                                                               as _SalesOrderPartner
    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_faturamento', p_chave2 : 'PARVW_VEND') as _Param 
    on _Param.parametro = _SalesOrderPartner.PartnerFunction
{

  key _SalesOrderPartner.SalesOrder,
      _SalesOrderPartner.Personnel

}
