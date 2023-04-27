@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monitor E-Commerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define root view entity ZI_SD_MONITOR_APP
  as select from ZI_SD_MONITOR_APP_N
{
  key SalesOrder,
  key Remessa,
  key Fatura,
  key NfeNum,
      RemessaDisplay,
      FaturaDisplay,
      NfeNumDisplay,
      Customer,
      CustomerName,
      Supplier,
      SupplierName,
      PurchaseOrder,
      CreationDate,
      DistributionChannel,
      CreationTime,
      DeliveryBlockReason,
      SalesOrderType,
      Status,
      StatusColor,
      NFDocnum,
      OrdemFrete,
      FreightOrder,
      UnidadeFrete,
      BillingDocumentIsCancelled,
      ActualDate,
      Centro,
      Region,
      StatusPrint,
      StatusPrintColor,
      StatusNfe,
      StatusNfeColor,
      DateTimeCreate,
      DateTimePicking,
      DateTimeMovement,
      DateTimeCreateBilling,
      ActualDateSaida,
      PlantName

      //////  //  as select from I_SalesOrder      as _SalesOrderView
      //////  as select from    ZI_SD_MONITOR_OV           as _SalesOrderView
      //////
      //////  //    left outer join I_SalesOrderItem  as _SalesOrderItem
      //////  //      on _SalesOrderItem.SalesOrder = _SalesOrderView.SalesOrder
      //////
      //////    inner join      ZI_SD_MONITOR_TYP          as _Param          on _Param.OrderType = _SalesOrderView.SalesOrderType
      //////
      //////  //  association [0..1] to I_SalesOrderItem           as _SalesOrderItem
      //////  //    on _SalesOrderItem.SalesOrder = $projection.SalesOrder
      //////    left outer join ZI_SD_MONITOR_PICKING_REM  as _Pick           on _Pick.PrecedingDocument = _SalesOrderView.SalesOrder
      //////  //  association to ZI_SD_MONITOR_REM          as _FlowRemessa    on  _FlowRemessa.PrecedingDocument = $projection.SalesOrder
      //////    left outer join ZI_SD_MONITOR_REM          as _FlowRemessa    on _FlowRemessa.PrecedingDocument = _SalesOrderView.SalesOrder
      //////  //association        to ZI_SD_MONITOR_REM_DIST       as _FlowRemessa    on _FlowRemessa.PrecedingDocument = $projection.SalesOrder
      //////
      //////  //    and _FlowRemessa.PrecedingDocumentItem = $projection.SalesOrderItem
      //////
      //////    left outer join ZI_SD_MONITOR_SUPPLIER     as _Supplier       on _Supplier.SDDocument = _SalesOrderView.SalesOrder
      //////
      //////    left outer join ZI_SD_MONITOR_PARTNER      as _Partner        on _Partner.SDDocument = _SalesOrderView.SalesOrder
      //////
      //////  //  association to ZI_SD_MONITOR_SUPPLIER     as _Supplier       on  _Supplier.SDDocument = $projection.SalesOrder
      //////
      //////    left outer join ZI_SD_MONITOR_REGIO_CUSTOM as _CustomerRegion on _CustomerRegion.SDDocument = _SalesOrderView.SalesOrder
      //////
      //////  association [1..1] to I_Plant as _Plant on  _Plant.Plant    = $projection.Centro
      //////                                          and _Plant.Language = $session.system_language
      //////  //    left outer join I_Plant                    as _Plant          on  _Plant.Plant    = _SalesOrderView.Plant
      //////  //                                                                  and _Plant.Language = $session.system_language
      //////
      //////{
      //////  key          _SalesOrderView.SalesOrder                                                                     as SalesOrder,
      //////               //  key    _FlowRemessa.Remessa                                                                           as Remessa,
      //////               //  key    _FlowRemessa.Fatura                                                                            as Fatura,
      //////               //  key    _FlowRemessa.BR_NFeNumber                                                                      as NfeNum,
      //////  key          case
      //////                      when _FlowRemessa.Remessa is not null then _FlowRemessa.Remessa
      //////                      else '-'
      //////                  end                                                                                         as Remessa,
      //////  key          case
      //////                       when _FlowRemessa.Fatura is not null then _FlowRemessa.Fatura
      //////                       else '0000000000'
      //////                  end                                                                                         as Fatura,
      //////  key          case
      //////                      when _FlowRemessa.BR_NFeNumber is not null then _FlowRemessa.BR_NFeNumber
      //////                      else '000000000'
      //////                  end                                                                                         as NfeNum,
      //////               case
      //////                 when ( _FlowRemessa.Remessa is not null and _FlowRemessa.Remessa <> '0000000000' ) then _FlowRemessa.Remessa
      //////                 else ''
      //////               end                                                                                            as RemessaDisplay,
      //////
      //////               case
      //////                   when ( _FlowRemessa.Fatura is not null and _FlowRemessa.Fatura <> '0000000000' ) then _FlowRemessa.Fatura
      //////                   else ''
      //////               end                                                                                            as FaturaDisplay,
      //////
      //////               case
      //////                 when ( _FlowRemessa.BR_NFeNumber is not null and _FlowRemessa.BR_NFeNumber <> '000000000' ) then _FlowRemessa.BR_NFeNumber
      //////                 else ''
      //////               end                                                                                            as NfeNumDisplay,
      //////
      //////               //'' as Customer,
      //////               //'' as CustomerName,
      //////               _Partner.Customer                                                                              as Customer,
      //////               _Partner.CustomerName                                                                          as CustomerName,
      //////
      //////
      //////               _Supplier.Supplier                                                                             as Supplier,
      //////               _Supplier.SupplierName                                                                         as SupplierName,
      //////               _SalesOrderView.PurchaseOrderByCustomer                                                        as PurchaseOrder,
      //////               _SalesOrderView.CreationDate                                                                   as CreationDate,
      //////               _SalesOrderView.DistributionChannel                                                            as DistributionChannel,
      //////               _SalesOrderView.CreationTime                                                                   as CreationTime,
      //////               _SalesOrderView.DeliveryBlockReason                                                            as DeliveryBlockReason,
      //////               _Param.OrderType                                                                               as SalesOrderType,
      //////
      //////
      //////               case
      //////               //            when _FlowRemessa.BR_NFeDocumentStatus = '1' then 'Concluído'
      //////                    when (_FlowRemessa.OrdemFrete is not null or _FlowRemessa.OrdemFrete <> '' )  then 'Concluído'
      //////                    when _SalesOrderView.OverallSDDocumentRejectionSts = 'C' then 'Cancelado'
      //////                    else 'Pendente'
      //////               end                                                                                            as Status,
      //////
      //////               case
      //////               //            when _FlowRemessa.BR_NFeDocumentStatus = '1' then 3 --Verde
      //////                    when (_FlowRemessa.OrdemFrete is not null or _FlowRemessa.OrdemFrete <> '' ) then  3 --Verde
      //////                    when _SalesOrderView.OverallSDDocumentRejectionSts = 'C' then 1 --Vermelho
      //////                    else 2 --Amarelo
      //////               end                                                                                            as StatusColor,
      //////
      //////               _FlowRemessa.BR_NotaFiscal                                                                     as NFDocnum,
      //////               _FlowRemessa.OrdemFrete                                                                        as OrdemFrete,
      //////               _FlowRemessa.OrdemFrete                                                                        as FreightOrder,
      //////               _FlowRemessa.UnidadeFrete                                                                      as UnidadeFrete,
      //////               _FlowRemessa.BillingDocumentIsCancelled,
      //////               cast( _FlowRemessa.ActualDate as tzntstmpl )                                                   as ActualDate,
      //////
      //////               case
      //////                 when _FlowRemessa.ShippingPoint is not null then _FlowRemessa.ShippingPoint
      //////               //         else _SalesOrderItem.Plant
      //////                        else _SalesOrderView.Plant
      //////               end                                                                                            as Centro,
      //////
      //////               //              case
      //////               //                when _FlowRemessa.BR_NFPartnerRegionCode <> ' ' then _FlowRemessa.BR_NFPartnerRegionCode
      //////               //                else _CustomerRegion.Region
      //////               //              end                                                                                            as Region,
      //////               _CustomerRegion.Region,
      //////
      //////               case _FlowRemessa.BR_NFIsPrinted
      //////                    when 'X' then 'Sim'
      //////                    else 'Não'
      //////               end                                                                                            as StatusPrint,
      //////
      //////               case _FlowRemessa.BR_NFIsPrinted
      //////                    when 'X' then 3 --Verde
      //////                    else 2 --Amarelo
      //////               end                                                                                            as StatusPrintColor,
      //////
      //////               case _FlowRemessa.BR_NFeDocumentStatus
      //////                    when '1' then 'Autorizado'
      //////                    when '2' then 'Recusado'
      //////                    when '3' then 'Rejeitado'
      //////                    else '1ª tela'
      //////               end                                                                                            as StatusNfe,
      //////
      //////               case _FlowRemessa.BR_NFeDocumentStatus
      //////                    when '1' then 3 --Verde
      //////                    when '2' then 1 --Amarelo
      //////                    when '3' then 1 --Vermelho
      //////                    else 0 --Neutro
      //////               end                                                                                            as StatusNfeColor,
      //////
      //////
      //////               //       concat(   concat(   concat(   concat(substring( _FlowRemessa.CreationDate, 7, 2 ), '.'),
      //////               //                 concat(   substring( _FlowRemessa.CreationDate, 5, 2 ), concat('.', substring( _FlowRemessa.CreationDate, 1, 4 )))),
      //////               //
      //////               //                 concat('  ', concat(   concat(substring( _FlowRemessa.CreationTime, 1, 2 ), ':'),
      //////               //                           concat(substring( _FlowRemessa.CreationTime, 3, 2 ), ':')) ) ),
      //////               //
      //////               //                 substring( _FlowRemessa.CreationTime, 5, 2 )
      //////               //                 )                                                                                                                     as DateTimeCreate,
      //////
      //////
      //////               concat_with_space( concat( concat(substring( _FlowRemessa.CreationDate, 7, 2 ), '.'),
      //////                                          concat(substring( _FlowRemessa.CreationDate, 5, 2 ), concat('.', substring( _FlowRemessa.CreationDate, 1, 4 )))),
      //////                                  concat( concat(substring( _FlowRemessa.CreationTime, 1, 2 ), ':'),
      //////                                          concat( concat(substring( _FlowRemessa.CreationTime, 3, 2 ), ':'),
      //////                                                  substring( _FlowRemessa.CreationTime, 5, 2 )) ), 1 )        as DateTimeCreate,
      //////
      //////               //       concat(   concat(   concat(   concat(substring( _FlowRemessa.PickingDate, 7, 2 ), '.'),
      //////               //                 concat(   substring( _FlowRemessa.PickingDate, 5, 2 ), concat('.', substring( _FlowRemessa.PickingDate, 1, 4 )))),
      //////               //
      //////               //                 concat('  ', concat(   concat(substring( _FlowRemessa.PickingTime, 1, 2 ), ':'),
      //////               //                           concat(substring( _FlowRemessa.PickingTime, 3, 2 ), ':')) ) ),
      //////               //
      //////               //                 substring( _FlowRemessa.PickingTime, 5, 2 )
      //////               //                 )                                                                                                                     as DateTimePicking,
      //////               //       concat_with_space( concat( concat(substring( _FlowRemessa.PickingDate, 7, 2 ), '.'),
      //////               //                                  concat(substring( _FlowRemessa.PickingDate, 5, 2 ), concat('.', substring( _FlowRemessa.PickingDate, 1, 4 )))),
      //////               //                          concat( concat(substring( _FlowRemessa.PickingTime, 1, 2 ), ':'),
      //////               //                                  concat( concat(substring( _FlowRemessa.PickingTime, 3, 2 ), ':'),
      //////               //                                          substring( _FlowRemessa.PickingTime, 5, 2 )) ), 1 )         as DateTimePicking,
      //////               concat_with_space( concat( concat(substring( _Pick.CreationDate, 7, 2 ), '.'),
      //////               concat(substring( _Pick.CreationDate, 5, 2 ), concat('.', substring( _Pick.CreationDate, 1, 4 )))),
      //////               concat( concat(substring( _Pick.CreationTime, 1, 2 ), ':'),
      //////               concat( concat(substring( _Pick.CreationTime, 3, 2 ), ':'),
      //////               substring( _Pick.CreationTime, 5, 2 )) ), 1 )                                                  as DateTimePicking,
      //////
      //////
      //////
      //////               //       concat(   concat(   concat(   concat(substring( _FlowRemessa.ActualGoodsMovementDate, 7, 2 ), '.'),
      //////               //                 concat(   substring( _FlowRemessa.ActualGoodsMovementDate, 5, 2 ), concat('.', substring( _FlowRemessa.ActualGoodsMovementDate, 1, 4 )))),
      //////               //
      //////               //                 concat('  ', concat(   concat(substring( _FlowRemessa.ActualGoodsMovementTime, 1, 2 ), ':'),
      //////               //                           concat(substring( _FlowRemessa.ActualGoodsMovementTime, 3, 2 ), ':')) )),
      //////               //
      //////               //                 substring( _FlowRemessa.ActualGoodsMovementTime, 5, 2 )
      //////               //                 )                                                                             as DateTimeMovement,
      //////
      //////               case when ( _FlowRemessa.ActualGoodsMovementDate <> '00000000') then
      //////
      //////                   concat_with_space( concat( concat(substring( _FlowRemessa.ActualGoodsMovementDate, 7, 2 ), '.'),
      //////                                              concat(substring( _FlowRemessa.ActualGoodsMovementDate, 5, 2 ), concat('.', substring( _FlowRemessa.ActualGoodsMovementDate, 1, 4 )))),
      //////                                      concat( concat(substring( _FlowRemessa.ActualGoodsMovementTime, 1, 2 ), ':'),
      //////                                              concat( concat(substring( _FlowRemessa.ActualGoodsMovementTime, 3, 2 ), ':'),
      //////                                                      substring( _FlowRemessa.ActualGoodsMovementTime, 5, 2 )) ), 1 )
      //////
      //////               else ''
      //////               end                                                                                            as DateTimeMovement,
      //////
      //////
      //////
      //////               //       concat(   concat(   concat(   concat(substring( _FlowRemessa.CreationDateFatura, 7, 2 ), '.'),
      //////               //                 concat(   substring( _FlowRemessa.CreationDateFatura, 5, 2 ), concat('.', substring( _FlowRemessa.CreationDateFatura, 1, 4 )))),
      //////               //
      //////               //                 concat('  ', concat(   concat(substring( _FlowRemessa.CreationTimeFatura, 1, 2 ), ':'),
      //////               //                           concat(substring( _FlowRemessa.CreationTimeFatura, 3, 2 ), ':')) )),
      //////               //
      //////               //                 substring( _FlowRemessa.CreationTimeFatura, 5, 2 )
      //////               //                 )                                                                                        as DateTimeCreateBilling,
      //////               concat_with_space( concat( concat(substring( _FlowRemessa.CreationDateFatura, 7, 2 ), '.'),
      //////                                          concat(substring( _FlowRemessa.CreationDateFatura, 5, 2 ), concat('.', substring( _FlowRemessa.CreationDateFatura, 1, 4 )))),
      //////                                  concat( concat(substring( _FlowRemessa.CreationTimeFatura, 1, 2 ), ':'),
      //////                                          concat( concat(substring( _FlowRemessa.CreationTimeFatura, 3, 2 ), ':'),
      //////                                                  substring( _FlowRemessa.CreationTimeFatura, 5, 2 )) ), 1 )  as DateTimeCreateBilling,
      //////
      //////               //      concat(   concat(   concat(   concat(substring( _FlowRemessa.ActualDateSaida, 7, 2 ), '.'),
      //////               //                concat(   substring( _FlowRemessa.ActualDateSaida, 5, 2 ), concat('.', substring( _FlowRemessa.ActualDateSaida, 1, 4 )))),
      //////               //
      //////               //                concat('-', concat(   concat(substring( _FlowRemessa.ActualDateSaida, 9, 2 ), ':'),
      //////               //                          concat(substring(_FlowRemessa.ActualDateSaida, 11, 2 ), ':')) )),
      //////               //
      //////               //                substring( _FlowRemessa.ActualDateSaida, 13, 2 )
      //////               //                )                                 as ActualDateSaida
      //////
      //////               //       @ObjectModel.virtualElement: true
      //////               //       @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONV_DATA_ENTREGA'
      //////               //       _FlowRemessa.ActualDateSaida                                                                  as ActualDateSaida,
      //////
      //////
      //////               /*concat_with_space( concat( concat(substring( _FlowRemessa.DateSaida, 7, 2 ), '.'),
      //////                                       concat(substring( _FlowRemessa.DateSaida, 5, 2 ), concat('.', substring( _FlowRemessa.DateSaida, 1, 4 )))),
      //////                                   concat( concat(substring( _FlowRemessa.HoraSaida, 1, 2 ), ':'),
      //////                                   concat( concat(substring( _FlowRemessa.HoraSaida, 3, 2 ), ':'),
      //////                                           substring( _FlowRemessa.HoraSaida, 5, 2 )) ), 1 ) as ActualDateSaida,*/
      //////
      //////               case
      //////                when ( _FlowRemessa.ActualDateSaida <> '0' )
      //////               then
      //////                concat_with_space( concat( concat(substring( _FlowRemessa.DateSaida, 7, 2 ), '.'),
      //////                                        concat(substring( _FlowRemessa.DateSaida, 5, 2 ), concat('.', substring( _FlowRemessa.DateSaida, 1, 4 )))),
      //////                                concat( concat(substring( _FlowRemessa.HoraSaida, 1, 2 ), ':'),
      //////                                        concat( concat(substring( _FlowRemessa.HoraSaida, 3, 2 ), ':'),
      //////                                                substring( _FlowRemessa.HoraSaida, 5, 2 )) ), 1 ) else '' end as ActualDateSaida,
      //////               _Plant
      //////               //_Plant.PlantName                                                                               as PlantName
}
