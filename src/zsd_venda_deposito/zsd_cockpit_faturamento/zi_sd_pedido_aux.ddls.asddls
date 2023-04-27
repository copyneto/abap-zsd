@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Pedido Auxiliar'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_PEDIDO_AUX
  as select from I_SalesOrder                                        as _SalesOrder
    inner join   ZI_SD_CKPT_FAT_PARAMETROS_3( p_chave1 : 'ADM_FATURAMENTO',
                                              p_chave2 : 'TIPOS_OV',
                                              p_chave3 : 'PED_AUX') as _Param on _Param.parametro = _SalesOrder.SalesOrderType
{
  key _SalesOrder.SalesOrder,
      _SalesOrder.CorrespncExternalReference 
}
