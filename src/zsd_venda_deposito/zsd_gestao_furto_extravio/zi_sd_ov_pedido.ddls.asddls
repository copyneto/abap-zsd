@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Buscar OV pelo Pedido'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_OV_PEDIDO 
  as select from ZI_SD_MONITOR_OV 
{

  key PurchaseOrderByCustomer,
      case
          when instr(PurchaseOrderByCustomer, '|') = 14
        then LEFT( PurchaseOrderByCustomer, 13 )
            when instr(PurchaseOrderByCustomer, '|') = 15
        then LEFT( PurchaseOrderByCustomer, 14 )
            when instr(PurchaseOrderByCustomer, '|') = 16
        then LEFT( PurchaseOrderByCustomer, 15 )
      when instr(PurchaseOrderByCustomer, '|') = 17
        then LEFT( PurchaseOrderByCustomer, 16 )

      when instr(PurchaseOrderByCustomer, '|') = 18
        then LEFT(PurchaseOrderByCustomer, 17 )

      when instr(PurchaseOrderByCustomer, '|') = 19
        then LEFT( PurchaseOrderByCustomer, 18 )

      when instr(PurchaseOrderByCustomer, '|') = 20
        then LEFT(PurchaseOrderByCustomer, 19 )

       else PurchaseOrderByCustomer
        end as Referencia
}
