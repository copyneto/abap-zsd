@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona Paletização Total Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_PALLET_TOTAL
  as select from ZI_SD_AGEN_ENTREGA as I_Pedidos

{
  key I_Pedidos.SalesOrder,

      sum( I_Pedidos.PalletItem ) as PalletTotal

}
where
  I_Pedidos.SalesDocumentRjcnReason is initial
group by
  I_Pedidos.SalesOrder
