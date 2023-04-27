@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Concatenação Chave'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_CHAVE
  as select from    ZI_SD_AGEN_ENTREGA         as I_Pedidos
    left outer join ZI_SD_CICLO( p_tipo : 'J') as _Remessa on _Remessa.Document = I_Pedidos.Remessa
    left outer join ZI_SD_AGENDAMENTOS         as _Agen    on  _Agen.Ordem   = I_Pedidos.SalesOrder
                                                           and _Remessa.Item = I_Pedidos.SalesOrderItem
{

  key I_Pedidos.SalesOrder,
  key I_Pedidos.SalesOrderItem,
  key I_Pedidos.Remessa,
  key _Remessa.NotaFiscal,

      case
         when _Agen.Remessa is null
         then I_Pedidos.SalesOrder
         when _Agen.NfE is null
         then  concat(I_Pedidos.SalesOrder, _Agen.Remessa )
      else
      concat(I_Pedidos.SalesOrder, concat(_Agen.Remessa, _Agen.NfE ))
         end as Chave

}
