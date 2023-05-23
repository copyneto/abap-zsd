@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de remessa'
@Metadata.allowExtensions: true
@VDM.viewType: #COMPOSITE
define root view entity ZI_SD_RELATORIO_REMESSA 
  as select from    I_SalesDocumentItem       as SalesDocumentItem

    left outer join I_SalesDocument           as SalesDocument          on SalesDocument.SalesDocument = SalesDocumentItem.SalesDocument
    left outer join vbak                      as SalesDocumentCompl     on SalesDocumentCompl.vbeln = SalesDocumentItem.SalesDocument
    left outer join I_MaterialText            as MaterialText           on  MaterialText.Material = SalesDocumentItem.Material
                                                                        and MaterialText.Language = $session.system_language
    left outer join I_DeliveryDocumentItem    as DeliveryDocumentItem   on  DeliveryDocumentItem.ReferenceSDDocument     =  SalesDocumentItem.SalesDocument
                                                                        and DeliveryDocumentItem.ReferenceSDDocumentItem =  SalesDocumentItem.SalesDocumentItem
                                                                        and DeliveryDocumentItem.ItemIsBillingRelevant   <> ' '
    left outer join lips                      as DeliveryItemCompl      on  DeliveryItemCompl.vbeln = DeliveryDocumentItem.DeliveryDocument
                                                                        and DeliveryItemCompl.posnr = DeliveryDocumentItem.DeliveryDocumentItem
    left outer join I_BillingDocItemAnalytics as BillingDocumentItem    on  BillingDocumentItem.ReferenceSDDocument        = DeliveryDocumentItem.DeliveryDocument
                                                                        and BillingDocumentItem.ReferenceSDDocumentItem    = DeliveryDocumentItem.DeliveryDocumentItem
                                                                        and BillingDocumentItem.BillingDocumentIsCancelled = ' '
                                                                        and BillingDocumentItem.CancelledBillingDocument   = ' '
    left outer join I_BR_NFItem               as NFDocumentItem         on  NFDocumentItem.BR_NFSourceDocumentType   = 'BI'
                                                                        and NFDocumentItem.BR_NFSourceDocumentNumber = BillingDocumentItem.BillingDocument
                                                                        and NFDocumentItem.BR_NFSourceDocumentItem   = BillingDocumentItem.BillingDocumentItem
    left outer join I_BR_NFDocument           as NFDocument             on  NFDocument.BR_NotaFiscal     =  NFDocumentItem.BR_NotaFiscal
                                                                        and NFDocument.BR_NFIsCanceled   =  ' '
                                                                        and NFDocument.BR_NFDocumentType <> '5'
    left outer join I_BR_NFeActive            as NFDocumentActive       on NFDocumentActive.BR_NotaFiscal = NFDocument.BR_NotaFiscal
    left outer join I_SalesDocumentPartner    as Seller                 on Seller.SalesDocument     = SalesDocumentItem.SalesDocument
                                                                        and(
                                                                          Seller.PartnerFunction    = 'ZE'
                                                                          or Seller.PartnerFunction = 'ZI'
                                                                        )
    left outer join I_Supplier                as SellerName             on SellerName.Supplier = Seller.Supplier
    left outer join I_SalesDocumentPartner    as CustomerUNOP           on  CustomerUNOP.SalesDocument   = SalesDocument.SalesDocument
                                                                        and CustomerUNOP.PartnerFunction = 'Z2'
    left outer join I_SDDocumentPartner       as FreightAgent           on  FreightAgent.SDDocument      = DeliveryDocumentItem.DeliveryDocument
                                                                        and FreightAgent.PartnerFunction = 'SP'
    left outer join I_Supplier                as FreightAgentName       on FreightAgentName.Supplier = FreightAgent.Supplier
    left outer join I_Customer                as CustomerUNOPName       on CustomerUNOPName.Customer = CustomerUNOP.Customer
    left outer join vbap                      as SalesDocumentItemCompl on  SalesDocumentItemCompl.vbeln = SalesDocumentItem.SalesDocument
                                                                        and SalesDocumentItemCompl.posnr = SalesDocumentItem.SalesDocumentItem
    left outer join kna1                      as Customer               on Customer.kunnr = SalesDocument.SoldToParty


  association [0..1] to I_SalesDocumentItem           as _SalesDocumentItem           on  _SalesDocumentItem.SalesDocument     = $projection.SalesOrderDocument
                                                                                      and _SalesDocumentItem.SalesDocumentItem = $projection.SalesOrderDocumentItem
  association [0..1] to I_DeliveryDocument            as _DeliveryDocument            on  _DeliveryDocument.DeliveryDocument = $projection.DeliveryDocument
  association [0..1] to I_SDDocumentPartner           as _FreightAgent                on  _FreightAgent.SDDocument      = $projection.DeliveryDocument
                                                                                      and _FreightAgent.PartnerFunction = 'SP'
  association [0..1] to I_SalesDocumentPartner        as _CustomerUNOP                on  _CustomerUNOP.SalesDocument   = $projection.SalesOrderDocument
                                                                                      and _CustomerUNOP.PartnerFunction = 'Z2'
  association [0..1] to I_SalesDocument               as _SalesDocument               on  _SalesDocument.SalesDocument = $projection.SalesOrderDocument
  association [0..1] to I_ShippingConditionText       as _ShippingConditionText       on  _ShippingConditionText.ShippingCondition = $projection.shippingcondition
                                                                                      and _ShippingConditionText.Language          = $session.system_language
  association [0..1] to I_ProductHierarchyNodeText    as _ProductHierarchyNodeText    on  _ProductHierarchyNodeText.ProductHierarchyNode = $projection.ProductFamily
                                                                                      and _ProductHierarchyNodeText.Language             = $session.system_language
  association [0..1] to I_SalesDocumentTypeText       as _SalesDocumentTypeText       on  _SalesDocumentTypeText.SalesDocumentType = $projection.salesdocumenttype
                                                                                      and _SalesDocumentTypeText.Language          = $session.system_language
  association [0..1] to I_DeliveryBlockReasonText     as _DeliveryBlockReasonText     on  _DeliveryBlockReasonText.DeliveryBlockReason = $projection.deliveryblockreason
  association [0..1] to I_SalesDocumentRjcnReasonText as _SalesDocumentRjcnReasonText on  _SalesDocumentRjcnReasonText.SalesDocumentRjcnReason = $projection.salesdocumentrjcnreason
                                                                                      and _SalesDocumentRjcnReasonText.Language                = $session.system_language
  association [0..1] to I_MaterialGroupText           as _MaterialGroupText           on  _MaterialGroupText.MaterialGroup = $projection.materialgroup
                                                                                      and _MaterialGroupText.Language      = $session.system_language
  association [0..1] to I_GoodsMovementDocument       as _GoodsMovementDocument       on  _GoodsMovementDocument.DeliveryDocument         = $projection.DeliveryDocument
                                                                                      and _GoodsMovementDocument.DeliveryDocumentItem     = $projection.DeliveryDocumentItem
                                                                                      and _GoodsMovementDocument.IsReversalMovementType   = ' '
                                                                                      and _GoodsMovementDocument.GoodsMovementIsCancelled = ' '
                                                                                      and _GoodsMovementDocument.IsEffectiveGoodsMovement = 'X'
  association [0..1] to ZI_TM_FLUXO_ORDEM_TRANSPORTE  as _FreightOrderFlow            on  _FreightOrderFlow.DeliveryDocument = $projection.DeliveryDocument
                                                                                      and _FreightOrderFlow.DeliveryDocItem  = $projection.DeliveryDocumentItem
{

  key SalesDocumentItem.SalesDocument                                                                                     as SalesOrderDocument,
  key SalesDocumentItem.SalesDocumentItem                                                                                 as SalesOrderDocumentItem,
  key DeliveryDocumentItem.DeliveryDocument,
  key DeliveryDocumentItem.DeliveryDocumentItem,
      DeliveryDocumentItem.DeliveryDocumentItemText,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      DeliveryDocumentItem.ItemNetWeight,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      DeliveryDocumentItem.ItemGrossWeight,
      DeliveryDocumentItem.ItemWeightUnit,
      DeliveryDocumentItem.ActualDeliveryQuantity,
      DeliveryDocumentItem.DeliveryQuantityUnit,  
      DeliveryDocumentItem._DeliveryDocument.ShipToParty,
      DeliveryDocumentItem._DeliveryDocument.ShippingPoint,
      DeliveryDocumentItem._DeliveryDocument.ShippingCondition,
      DeliveryDocumentItem._DeliveryDocument.DeliveryBlockReason,
      
      
      _SalesDocument.DistributionChannel,
      _SalesDocument.SalesOrganization,
      _SalesDocument.SalesDocumentType,
      _SalesDocument.PurchaseOrderByCustomer                                                                              as PurchaseDocument,
      _SalesDocument.PaymentMethod,
      _SalesDocument.CustomerPurchaseOrderDate                                                                            as SiriusDate,
      _SalesDocument.CustomerPurchaseOrderType,
      _SalesDocument.CreationDate                                                                                         as SalesOrderDate,
      _SalesDocument.PurchaseOrderByShipToParty,
      _SalesDocument.CreatedByUser                                                                                        as SalesOrderCreatedByUser,
      _SalesDocument.OverallSDProcessStatus,
      _SalesDocument.SalesDistrict,
      _SalesDocument.SDDocumentReason,
      _SalesDocument.SalesOffice,
      _SalesDocument.CreationDate                                                                                         as DeliveryDocumentDate,
      SalesDocumentCompl.vsnmr_v                                                                                          as Matricula,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      _SalesDocumentItem.OrderQuantity,
      _SalesDocumentItem.OrderQuantityUnit,
      _SalesDocumentItem.Plant,
      _SalesDocumentItem.StorageLocation,
      _SalesDocumentItem.Material,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SalesDocumentItem.Subtotal1Amount                                                                                  as SalesOrderNetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( _SalesDocumentItem.NetAmount as abap.fltp ) + cast( _SalesDocumentItem.TaxAmount as abap.fltp )               as NetAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SalesDocumentItem.CostAmount,
      _SalesDocumentItem.TransactionCurrency,
      _SalesDocumentItem.MaterialGroup,
      _SalesDocumentItem.SalesDocumentRjcnReason,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SalesDocumentItem.NetPriceAmount,
      _SalesDocumentItem.ProductHierarchyNode                                                                             as ProductFamily,
      cast( _SalesDocumentItem.WBSElement as abap.numc( 8 ) )                                                             as WBSElement,
      cast( SalesDocumentItemCompl.kostl as abap.char( 10 ) )                                                             as CostElement,
      MaterialText.MaterialName,
      _FreightAgent.Supplier                                                                                              as FreightAgent,
      FreightAgentName.SupplierName                                                                                       as FreightAgentName,
      _CustomerUNOP.Customer                                                                                              as CustomerUNOP,
      CustomerUNOPName.CustomerName                                                                                       as CustomerUNOPName,
      _SalesDocument._StandardPartner.SoldToParty                                                                         as Customer,
      _SalesDocument._StandardPartner._SoldToParty.CustomerFullName                                                       as CustomerName,
      _SalesDocument._StandardPartner._SoldToParty.Region                                                                 as CustomerRegion,
      _SalesDocument._StandardPartner._SoldToParty.CityName                                                               as CustomerCityName,
      Customer.katr9                                                                                                      as CustomerAreaAtendimento,
      _SalesDocument._StandardPartner._SoldToParty._StandardAddress.District                                              as CustomerDistrict,
      Seller.Supplier                                                                                                     as Seller,
      SellerName.SupplierFullName                                                                                         as SellerName,
      _GoodsMovementDocument.MaterialDocument,
      _FreightOrderFlow.TransportationOrder,
      _FreightOrderFlow.CreatedOn,
      _FreightOrderFlow.Motorista,
      _FreightOrderFlow.NomeMotorista,
      _FreightOrderFlow.PlacaVeiculo,
      //      _FreightOrderFlow.EventName,
      BillingDocumentItem.BillingDocument,
      BillingDocumentItem.CreationDate,

      case
        when BillingDocumentItem.BillingDocument <> ' ' then cast( BillingDocumentItem.BillingDocumentItem as char6 ) end as BillingDocumentItem,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      case when _SalesDocumentItem.OrderQuantity <> 0
           then cast( _SalesDocumentItem.Subtotal1Amount as abap.fltp ) / cast( _SalesDocumentItem.OrderQuantity as abap.fltp )     
           else cast( 0 as abap.fltp ) 
           end as CreditRelatedPrice,

      case
        when NFDocument.BR_NotaFiscal <> '0000000000' then NFDocumentItem.BR_NotaFiscal end                               as NotaFiscal,

      case
        when NFDocument.BR_NotaFiscal <> '0000000000' then NFDocumentItem.BR_NotaFiscalItem end                           as NotaFiscalItem,

      DeliveryDocumentItem.Batch,

      cast( SalesDocumentItemCompl.j_1bcfop as abap.char(10) )      as CFOPCode,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      NFDocument.BR_NFNetAmount                                                                                           as NFNetAmount,
      NFDocument.SalesDocumentCurrency,
      NFDocument.BR_NFPostingDate                                                                                         as NFPostingDate,
      NFDocument.BR_NFIsPrinted                                                                                           as NFIsPrinted,
      @Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      NFDocument.HeaderGrossWeight                                                                                        as HeaderGrossWeight,
      NFDocument.HeaderWeightUnit,
      NFDocument.BR_NFeNumber                                                                                             as NFeNumber,
      NFDocumentActive.BR_NFAuthenticationDate                                                                            as NFAuthenticationDate,


      /* Associations */
      _DeliveryDocument,
      _FreightAgent,
      _ShippingConditionText,
      _ProductHierarchyNodeText,
      _SalesDocumentTypeText,
      _DeliveryBlockReasonText,
      _SalesDocumentRjcnReasonText,
      _MaterialGroupText,
      _CustomerUNOP,
      _SalesDocument

}
