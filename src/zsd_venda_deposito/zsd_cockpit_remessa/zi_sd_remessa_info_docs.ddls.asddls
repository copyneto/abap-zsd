@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REMESSA_INFO_DOCS
  as select from    I_DeliveryDocumentItem         as Delivery

    left outer join ZI_SD_REMESSA_INFO_ORDEM_FRETE as _FreightOrder on _FreightOrder.DeliveryDocument = Delivery.DeliveryDocument

  //    left outer join I_BillingDocumentItem          as _Billing      on  _Billing.SalesDocument     = Delivery.ReferenceSDDocument
    left outer join ZI_SD_REMESSA_BILLING          as _Billing      on  _Billing.SalesDocument       = Delivery.ReferenceSDDocument
                                                                    and _Billing.ReferenceSDDocument = Delivery.DeliveryDocument

                                                                    and _Billing.SalesDocumentItem   = Delivery.ReferenceSDDocumentItem
    left outer join I_BR_NFItem                    as _NFItem       on  _NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                    and _NFItem.BR_NFSourceDocumentNumber = _Billing.BillingDocument
                                                                    and _NFItem.BR_NFSourceDocumentItem   = _Billing.BillingDocumentItem
  //  association [0..1] to I_BR_NFItem as _NFItem on  _NFItem.BR_NFSourceDocumentType   = 'BI'
  //                                               and _NFItem.BR_NFSourceDocumentNumber = _Billing.BillingDocument
  //                                               and _NFItem.BR_NFSourceDocumentItem   = _Billing.BillingDocumentItem
{
  key Delivery.ReferenceSDDocument                                          as SalesDocument,
      min( Delivery.ReferenceSDDocumentItem )                               as SalesDocumentFirstItem,
      Delivery.DeliveryDocument                                             as DeliveryDocument,
      min( Delivery.DeliveryDocumentItem )                                  as DeliveryDocumentFirstItem,
      ltrim(max( _FreightOrder.FreightOrder ), '0' )                        as FreightOrder,
      max( _FreightOrder.FreightOrder )                                     as FreightOrderComplete,
      max(_Billing.BillingDocument )                                        as BillingDocument,
      //      _Billing.BillingDocument                       as BillingDocument,
      //      max( cast( _NFItem.BR_NotaFiscal as abap.char(10) ) ) as BR_NotaFiscal,
      min( cast( _NFItem.BR_NotaFiscal as abap.char(10) ) )                 as BR_NotaFiscal,

      concat(min(_NFItem._BR_NotaFiscal.BR_NFeNumber),
       concat('-', lpad(min(_NFItem._BR_NotaFiscal.BR_NFSeries), 6, '0') )) as BR_NFeNumber,
      min(_NFItem._BR_NotaFiscal.BR_NFeNumber)                              as BR_NFeNumber2,
      max(_FreightOrder.CreatedOn)                                          as CreatedOn
      //      cast( _NFItem.BR_NotaFiscal as abap.char(10) ) as BR_NotaFiscal

}

group by
  Delivery.ReferenceSDDocument,
  Delivery.DeliveryDocument
//  _NFItem._BR_NotaFiscal.BR_NFeNumber,
//  _NFItem._BR_NotaFiscal.BR_NFSeries
//  _Billing.BillingDocument,
//  _NFItem.BR_NotaFiscal
