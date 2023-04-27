@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pedido de Compras Ativo'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_SD_PO_ATIVA
  as select from I_PurchaseOrderItem
{
  key PurchaseOrder,
      count( * ) as ItensValidos
}
where
  PurchasingDocumentDeletionCode <> 'L'
group by
  PurchaseOrder
