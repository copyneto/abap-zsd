@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Administrar Agendamento de Entrega'
define view entity ZI_SD_AGEN_ENTREGA
  as select from    ZI_SD_ORDERS_ITEMS      as I_Sales
  //  association to I_SDDocumentMultiLevelProcFlow as _Remessa on  _Remessa.PrecedingDocument          = I_Sales.SalesOrder
  //                                                            and _Remessa.PrecedingDocumentItem      = I_Sales.SalesOrderItem
  //                                                            and _Remessa.SubsequentDocumentItem     = I_Sales.SalesOrderItem
  //                                                            and _Remessa.SubsequentDocumentCategory = 'J'
  //    inner join   ZI_SD_CKPT_AGEN_MIN_ITEM as _Item on  _Item.SalesOrder     = I_Sales.SalesOrder
  //                                                   and _Item.SalesOrderItem = I_Sales.SalesOrderItem

  //  association to ZI_SD_CKPT_AGEN_REMESSA as _Remessa on  _Remessa.SalesOrder = I_Sales.SalesOrder
  //                                                     and _Remessa.Item       = I_Sales.SalesOrderItem


    left outer join ZI_SD_CKPT_AGEN_REMESSA as _Remessa on  _Remessa.SalesOrder = I_Sales.SalesOrder
                                                        and _Remessa.Item       = I_Sales.SalesOrderItem


  association to ZI_SD_CKPT_AGEN_PALLET as _Pallet on  _Pallet.SalesOrder     = I_Sales.SalesOrder
                                                   and _Pallet.SalesOrderItem = I_Sales.SalesOrderItem

{
  key I_Sales.SalesOrder,
  key I_Sales.SalesOrderItem,
      I_Sales.SoldToParty,
      I_Sales.SoldToPartyName,
      I_Sales.PurchaseOrderByCustomer,
      I_Sales.RequestedDeliveryDate,
      I_Sales.CreationDate,
      I_Sales.SalesOrganization,
      I_Sales.DistributionChannel,
      I_Sales.OrganizationDivision,
      I_Sales.CustomerAccountAssignmentGroup,
      I_Sales.SalesOrderI,
      I_Sales.Plant,
      I_Sales.TransactionCurrency,

      case
      when _Remessa.ItemGrossWeight is null
      then I_Sales.ItemWeightUnit
      else _Remessa.ItemWeightUnit
      end                                                   as ItemWeightUnit,

      case
      when _Remessa.ItemGrossWeight is null
      then cast( I_Sales.ItemGrossWeight as abap.dec( 15, 3 ))
      else cast( _Remessa.ItemGrossWeight as abap.dec( 15, 3 ))
      end                                                   as ItemGrossWeight,

      case
      when _Remessa.ItemNetWeight is null
      then cast( I_Sales.ItemNetWeight as abap.dec( 15, 3 ))
      else cast( _Remessa.ItemNetWeight as abap.dec( 15, 3 ))
      end                                                   as ItemNetWeight,



      //      I_Sales.Material,

      case
      when _Remessa.Material is null
       then I_Sales.Material
       else _Remessa.Material
       end                                                  as Material,

      case
      when _Remessa.DeliveryDocumentItemText is null
      then I_Sales.SalesOrderItemText
      else _Remessa.DeliveryDocumentItemText
      end                                                   as SalesOrderItemText,

      case
      when _Remessa.ItemVolume is null
      then cast( I_Sales.ItemVolume as abap.dec( 15, 3 ))
      else cast( _Remessa.ItemVolume as abap.dec( 15, 3 ))
      end                                                   as ItemVolume,

      case
      when _Remessa.ItemVolumeUnit is null
      then I_Sales.ItemVolumeUnit
      else _Remessa.ItemVolumeUnit
      end                                                   as ItemVolumeUnit,

      case
      when _Remessa.DeliveryQuantityUnit is null
      then I_Sales.OrderQuantityUnit
      else _Remessa.DeliveryQuantityUnit
      end                                                   as OrderQuantityUnit,

      case
      when _Remessa.OriginalDeliveryQuantity is null
      then cast( I_Sales.OrderQuantity as abap.dec( 13, 3 ))
      else cast( _Remessa.OriginalDeliveryQuantity as abap.dec( 13, 3 ))
      end                                                   as OrderQuantity,

      I_Sales.SalesDocumentRjcnReason,
      case I_Sales.OverallSDProcessStatus
                 when ' ' then 'Irrelevante'
                 when 'A' then 'Não processado'
                 when 'B' then 'Processado parcialmente'
                 else 'Processado completamente'
                 end                                        as OverallSDProcessStatus,

      case I_Sales.OverallSDProcessStatus
           when 'A' then 1 --Vermelho
           when 'B' then 2 --Amarelo
           when 'C' then 3 --Verde
           else 0 --Neutro
      end                                                   as OverallSDProcessStatusColor,
      I_Sales.SalesOrderType,
      I_Sales.SalesGroup,
      I_Sales.SalesDistrict,
      I_Sales.Route,
      I_Sales.CustomerPurchaseOrderDate,
      I_Sales.Supplier,
      I_Sales.kvgr5,
      I_Sales.regio,
      I_Sales.ort01,
      I_Sales.ort02,
      //      _Remessa.SubsequentDocument                           as Remessa,
      _Remessa.Document                                     as Remessa,

      case
               when _Remessa.Document is null
               then concat( I_Sales.SalesOrder, I_Sales.SalesOrderItem )
               else concat( concat( I_Sales.SalesOrder, I_Sales.SalesOrderItem ), _Remessa.Document )
             end                                            as ChaveOrdemRemessa,

      case
        when _Remessa.Document is null
        then I_Sales.SalesOrder
        else _Remessa.Document
      end                                                   as ChaveDinamica,

      fltp_to_dec( _Pallet.PalletItem as abap.dec( 15,8 ) ) as PalletItem,

      /* Associations */
      I_Sales._Cliente,
      I_Sales._Grupo,
      I_Sales._Item,
      I_Sales._Partner
      //      _Remessa
}
