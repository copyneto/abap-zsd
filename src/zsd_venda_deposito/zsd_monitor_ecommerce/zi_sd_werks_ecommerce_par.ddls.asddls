@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Centros Parâmetros Ecommerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_WERKS_ECOMMERCE_PAR as select from ztca_param_val
{
    key modulo,
    key chave1,
    key chave2,
    key chave3,
    key cast( low as werks_d ) as Werks   
}
where 
    modulo = 'SD' and 
    chave1 = 'ECOMMERCE' and 
    chave2 = 'CENTROS_ECOMMERCE'
