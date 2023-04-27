@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS calculo peso'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_PESO
  as select from I_SalesOrderItem                                  as _Header
    inner join   ZI_SD_AGEN_ENTREGA                                as I_Pedidos on  I_Pedidos.SalesOrder     = _Header.SalesOrder
                                                                                and I_Pedidos.Remessa        is null
                                                                                and I_Pedidos.SalesOrderItem = _Header.SalesOrderItem
    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                            p_chave2 : 'TIPOS_OV') as _Param    on _Param.parametro = I_Pedidos.SalesOrderType

{

  key _Header.SalesOrder,
      sum(  cast( _Header.ItemVolume as abap.dec( 15, 3 ))) as ITEMVOLUME

}
where _Header.SalesDocumentRjcnReason = ''
group by
  _Header.SalesOrder
