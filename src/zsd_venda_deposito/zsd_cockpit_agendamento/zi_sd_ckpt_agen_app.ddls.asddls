@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'App Cockpit de Agendamento'
define root view entity ZI_SD_CKPT_AGEN_APP
  //  as select from           ZI_SD_AGEN_ENTREGA                                    as I_Pedidos
  as select from           ZI_SD_CKPT_AGEN_ENTREGA_HD                            as _Header

  //    left outer to one join ZI_SD_CKPT_AGEN_MIN_ITEM                              as _Item       on  _Item.SalesOrder     = _Header.SalesOrder
  ////                                                                                                and _Item.SalesOrderItem = _Header.Item
  //    left outer to one join ZI_SD_AGEN_ENTREGA                                    as I_Pedidos   on _Header.SalesOrder = I_Pedidos.SalesOrder
  //                                                                                                and(
  //                                                                                                  (
  //                                                                                                    _Header.Document  = I_Pedidos.Remessa
  //                                                                                                    and _Header.Item  = I_Pedidos.SalesOrderItem
  //                                                                                                  )
  //                                                                                                  or(
  //                                                                                                    _Header.Document  is null
  //                                                                                                    and _Header.Item  = _Item.SalesOrderItem
  //                                                                                                  )
  //                                                                                                )
    left outer to one join ZI_SD_CKPT_AGEN_MIN_ITEM                              as _Item       on _Item.SalesOrder = _Header.SalesOrder
    left outer to one join ZI_SD_AGEN_ENTREGA                                    as I_Pedidos   on  I_Pedidos.SalesOrder     = _Header.SalesOrder
                                                                                                and I_Pedidos.Remessa        is null
                                                                                                and I_Pedidos.SalesOrderItem = _Item.SalesOrderItem
    inner join             ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
                                                          p_chave2 : 'TIPOS_OV') as _Param      on _Param.parametro = I_Pedidos.SalesOrderType
  //    inner join             ZI_SD_CKPT_AGEN_MIN_ITEM                              as _Item       on  _Item.SalesOrder     = I_Pedidos.SalesOrder
  //                                                                                                and _Item.SalesOrderItem = I_Pedidos.SalesOrderItem
  //    left outer join ZI_SD_CKPT_AGEN_REMESSA               as _Remessa    on  _Remessa.SalesOrder = I_Pedidos.SalesOrder
  //                                                                         and _Remessa.Document   = I_Pedidos.Remessa
  //                                                                         and _Remessa.Item       = I_Pedidos.SalesOrderItem
  //    left outer join        ZI_SD_CKPT_AGEN_REMESSA_HEADER                        as _Remessa    on  _Remessa.SalesOrder = I_Pedidos.SalesOrder
  //                                                                                                and _Remessa.Document   = I_Pedidos.Remessa
  //    left outer to one join I_OutboundDeliveryItem                                as _RemessaRef on  _RemessaRef.OutboundDelivery       =  _Remessa.Document
  //                                                                                                and _RemessaRef.ReferenceSDDocument    =  _Remessa.SalesOrder
  //                                                       and _RemessaRef.OutboundDeliveryItem   =  _Remessa.Item
  //                                                                                                and _RemessaRef.ActualDeliveryQuantity <> 0.000
  //    left outer join ZI_SD_CKPT_AGEN_FATURA                as _Fatura     on  _Fatura.SalesOrder = I_Pedidos.Remessa
  //                                                                         and _Fatura.Item       = I_Pedidos.SalesOrderItem

    left outer to one join ZI_SD_CKPT_AGEN_HD_REMESSA                            as _Remessa    on _Remessa.SalesOrder = _Header.SalesOrder
                                                                                                and _Remessa.Document is null

  //                                                                                                and _Remessa.Item       = _Header.Item


    left outer join        ZI_SD_CKPT_AGEN_FATURAMIN                             as _Fatura     on _Fatura.SalesOrder = I_Pedidos.Remessa
  //                                                                         and _Fatura.Item       = I_Pedidos.SalesOrderItem
    left outer join        ZI_SD_FRETE_CONVERSION                                as _Frete2     on _Frete2.SalesOrder = I_Pedidos.SalesOrder
    left outer join        ZI_SD_FRETE_ALL                                       as _Frete      on  _Frete.SalesOrder = I_Pedidos.Remessa //_Frete2.Salesorder_conv
                                                                                                and _Frete.tor_cat    = 'TO'

    left outer join        ZI_SD_FRETE_ALL                                       as _Fu         on  _Fu.SalesOrder = I_Pedidos.Remessa    //_Frete2.Salesorder_conv
                                                                                                and _Fu.tor_cat    = 'FU'

  //    left outer join ZI_SD_FRETE(p_cat : 'TO')             as _Frete      on _Frete.SalesOrder = I_Pedidos.Remessa //_Frete2.Salesorder_conv
  //    left outer join ZI_SD_FRETE(p_cat : 'FU')             as _Fu         on _Fu.SalesOrder = I_Pedidos.Remessa //_Frete2.Salesorder_conv
    left outer join        ZI_SD_SAIDA_VEI(p_cat: 'TO')                          as _SaidaVei   on  _SaidaVei.SalesOrder = I_Pedidos.Remessa //_Frete2.Salesorder_conv
                                                                                                and _SaidaVei.OrdemFrete = _Frete.OrdemFrete
    left outer join        ZI_SD_CKPT_AGEN_DATA_ENT(p_cat: 'TO')                 as _DataEnt    on  _DataEnt.SalesOrder = I_Pedidos.Remessa
                                                                                                and _DataEnt.OrdemFrete = _Frete.OrdemFrete
  //    left outer to one join ZI_SD_AGENDAMENTOS                    as _AgenChave  on  _AgenChave.Ordem   = I_Pedidos.SalesOrder
  //                                                                         and _AgenChave.Item    = I_Pedidos.SalesOrderItem
  //                                                                         and _AgenChave.Remessa = I_Pedidos.Remessa
  //                                                                         and _AgenChave.NfE     = _Remessa.NotaFiscal
  //
  //    left outer to one join ZI_SD_AGENDAMENTOS                    as _AgenChave1 on  _AgenChave1.Ordem   = I_Pedidos.SalesOrder
  //                                                                         and _AgenChave1.Item    = I_Pedidos.SalesOrderItem
  //                                                                         and _AgenChave1.Remessa = I_Pedidos.Remessa
  //
  //    left outer to one join ZI_SD_AGENDAMENTOS                    as _AgenChave2 on  _AgenChave2.Ordem   = I_Pedidos.SalesOrder
  //                                                                         and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
  //                                                                         and _AgenChave2.Remessa = 'X'
    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave  on  _AgenChave.Ordem       = I_Pedidos.SalesOrder
    //                                                                         and _AgenChave.Item    = I_Pedidos.SalesOrderItem
                                                                                                and _AgenChave.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave.NfE         = _Remessa.NotaFiscal
                                                                                                and _AgenChave.Agend_Valid = 'X'

    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave1 on  _AgenChave1.Ordem       = I_Pedidos.SalesOrder
    //                                                                         and _AgenChave1.Item    = I_Pedidos.SalesOrderItem
                                                                                                and _AgenChave1.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave1.Agend_Valid = 'X'

    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave2 on  _AgenChave2.Ordem       = I_Pedidos.SalesOrder
    //                                                                         and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                                                                                                and _AgenChave2.Remessa     = 'X'
                                                                                                and _AgenChave2.Agend_Valid = 'X'

    left outer join        ZI_SD_KIT_BON_ORDER_PESO                              as _Peso       on _Peso.SalesOrder = I_Pedidos.SalesOrder

    left outer join        ZI_CA_VH_KVGR5                                        as _Agrup      on _Agrup.Agrupamento = I_Pedidos.kvgr5

  association to ZI_SD_CKPT_AGEN_PALLET_TOTAL as _Pallet                    on _Pallet.SalesOrder = I_Pedidos.SalesOrder

  association to ZI_SD_KIT_BON_ORDER_VIEW     as _ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = I_Pedidos.SalesOrder

{

             //  key    I_Pedidos.ChaveOrdemRemessa,
             //  key    I_Pedidos.ChaveDinamica,

  key        case
                when _Remessa.Document is null
                then concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem )
                else concat( concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem ), _Remessa.Document )
              end                                                  as ChaveOrdemRemessa,

  key        case
         when _Remessa.Document is null
         then I_Pedidos.SalesOrder
         else _Remessa.Document
       end                                                         as ChaveDinamica,
             @Consumption.semanticObject: 'SalesDocument'
             @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuiqkView'
  key        I_Pedidos.SalesOrder,
  key        I_Pedidos.SalesOrderItem,
             _Remessa.Document                                     as Remessa,
             _Remessa.SalesOrder                                   as Ordem_remessa,
             I_Pedidos.SoldToParty,
             I_Pedidos.SoldToPartyName,
             I_Pedidos.PurchaseOrderByCustomer,
             I_Pedidos.RequestedDeliveryDate,
             I_Pedidos.CreationDate,
             I_Pedidos.SalesOrganization,
             I_Pedidos.DistributionChannel,
             I_Pedidos.OrganizationDivision,
             //            I_Pedidos.CustomerAccountAssignmentGroup,
             //            cast( round( _Pallet.PalletTotal,3 ) as abap.dec( 15,3 ) ) as PalletTotal,
             @ObjectModel.virtualElement: true
             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PALLET'
             cast( '' as abap.char( 20 )  )                        as PalletTotal,
             I_Pedidos.SalesOrderI,
             I_Pedidos.Plant,
             _Peso.ItemWeightUnit,
             _Peso.HeaderGrossWeight                               as ItemGrossWeight,
             _Peso.HeaderNetWeight                                 as ItemNetWeight,
             I_Pedidos.Material,
             I_Pedidos.SalesOrderItemText,
             case
             when I_Pedidos.ItemVolume is initial or I_Pedidos.ItemVolume is null
             then cast( _Remessa.ItemVolume as abap.dec( 15, 3 ))
             else
             cast( I_Pedidos.ItemVolume as abap.dec( 15, 3 ))  end as ItemVolume,
             case
             when I_Pedidos.ItemVolume is initial or I_Pedidos.ItemVolume is null
             then _Remessa.ItemVolumeUnit
             else
             I_Pedidos.ItemVolumeUnit  end                         as ItemVolumeUnit,
             //

             //             I_Pedidos.ItemVolume,
             //             I_Pedidos.ItemVolumeUnit,

             I_Pedidos.OrderQuantityUnit,
             I_Pedidos.OverallSDProcessStatus,
             I_Pedidos.OverallSDProcessStatusColor,
             I_Pedidos.SalesOrderType,
             I_Pedidos.SalesDistrict,
             I_Pedidos.Route,
             I_Pedidos.CustomerPurchaseOrderDate,
             I_Pedidos.Supplier,
             I_Pedidos.kvgr5,
             _Agrup.Texto                                          as AgrupametoText,
             I_Pedidos.regio,
             I_Pedidos.ort01,
             I_Pedidos.ort02,


             _Remessa.Document,
             _Fatura.DocNum,
             @Semantics.amount.currencyCode:'Currency'
             _Fatura.Total_Nfe_Header                              as Total_Nfe,
             _Fatura.Currency,
             _Fatura.NotaFiscal,
             ltrim( _Frete.OrdemFrete, '0')                        as OrdemFrete,
             ltrim( _Fu.OrdemFrete, '0' )                          as UnidadeFrete,
             cast( _DataEnt.DataEntrega as tzntstmpl)              as DataEntrega,
             //             @ObjectModel.virtualElement: true
             //            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_CONV'
             //             cast( '' as abap.char( 20 )  ) as DataFrete,

             ////             _DataEnt.DataEntrega           as dats,
             //
             //
             //
             //                          concat(   concat(   concat(   concat(substring( _DataEnt.DataEntrega, 7, 2 ), '.'),
             //                                    concat(   substring( _DataEnt.DataEntrega, 5, 2 ), concat('.', substring( _DataEnt.DataEntrega, 1, 4 )))),
             //
             //                                    concat('-', concat(   concat(substring( _DataEnt.DataEntrega, 9, 2 ), ':'),
             //                                              concat(substring(_DataEnt.DataEntrega, 11, 2 ), ':')) )),
             //
             //                                    substring( _DataEnt.DataEntrega, 13, 2 )
             //                                    )                    as DataEntrega,
             ////             @ObjectModel.virtualElement: true
             ////             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_CONV'
             ////             cast( '' as abap.char( 20 )  ) as DataEntrega,
             //
             ////             @ObjectModel.virtualElement: true
             ////             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_DATAENTREGA'
             //             cast( '' as abap.char( 20 )  ) as DataEntregaConv,

             @ObjectModel.virtualElement: true
             @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PALLET'
             cast( '' as abap.char( 20 )  )                        as PalletFracionado,
             //            _AgenChave2.DataAgendada,
             //_AgenChave1.HoraAgendada,
             //_AgenChave1.motivo,
             //_AgenChave1.Senha,
             //_AgenChave1.observacoes,
             case
              when _AgenChave.DataAgendada  is  not null
               then _AgenChave.DataAgendada
             else
               case
                when _AgenChave1.DataAgendada  is not null
                 then _AgenChave1.DataAgendada
                 when _AgenChave2.DataAgendada  is not null //and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                 then _AgenChave2.DataAgendada
                else _AgenChave.DataAgendada
                end
             end                                                   as DataAgendada,

             case
              when _AgenChave.DataAgendada  is  not null
               then _AgenChave.HoraAgendada
             else
               case
                when _AgenChave1.DataAgendada  is not null
                 then _AgenChave1.HoraAgendada
                when _AgenChave2.DataAgendada  is not null  //and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                 then _AgenChave2.HoraAgendada
                else _AgenChave.HoraAgendada
                end
             end                                                   as HoraAgendada,

             ''                                                    as MotivoAgenda,
             case
             when _AgenChave.DataAgendada  is  not null
             then _AgenChave.motivo
             else
             case
             when _AgenChave1.DataAgendada  is not null
             then _AgenChave1.motivo
             when _AgenChave2.DataAgendada  is not null  //and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                 then _AgenChave2.motivo
                else _AgenChave.motivo
             end
             end                                                   as Motivo,

             case
              when _AgenChave.DataAgendada  is  not null
              then _AgenChave.Texto
              else
              case
              when _AgenChave1.DataAgendada  is not null
              then _AgenChave1.Texto
              when _AgenChave2.DataAgendada  is not null //and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                  then _AgenChave2.Texto
                 else _AgenChave.Texto
              end
              end                                                  as MotivoText,

             case
              when _AgenChave.DataAgendada  is  not null
               then _AgenChave.Senha
             else
               case
                when _AgenChave1.DataAgendada  is not null
                 then _AgenChave1.Senha
                 when _AgenChave2.DataAgendada  is not null //and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                 then _AgenChave2.Senha
                else _AgenChave.Senha
                end
             end                                                   as Senha,


             case
             when _AgenChave.DataAgendada  is  not null
             then _AgenChave.observacoes
             else
             case
             when _AgenChave1.DataAgendada  is not null
             then _AgenChave1.observacoes
             when _AgenChave2.DataAgendada  is not null // and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                 then _AgenChave2.observacoes
                else _AgenChave.observacoes
             end
             end                                                   as Observacoes,

             _SaidaVei.EventCode,
             _DataEnt.EventCode                                    as FreteEventCode,

             case
                         when I_Pedidos.Remessa is null
                           then 'Em Ordem'
                         when _Fatura.NotaFiscal is null
                           then 'Em Remessa'
                         when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                           then  'Em NF-e'
                         when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                           then 'Saída do Veículo'
                         when  _DataEnt.EventCode = 'ENTREGUE_NO_CLIENTE'
                           then 'Entrega realizada'
             end                                                   as Status,

             case
                               when I_Pedidos.Remessa is initial
                                 then 0
                               when _Remessa.NotaFiscal is initial
                                 then 0
                               when  _SaidaVei.EventCode <> 'CHECK_OUT'
                                 then 0
                               when _SaidaVei.EventCode = 'CHECK_OUT' and _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE'
                                 then 0
                               when  _DataEnt.EventCode = 'ENTREGUE_NO_CLIENTE'
                                 then 3
                                     else 0
                   end                                             as StatusColor,

             _Frete2.Salesorder_conv,

             //            case
             //             when _AgenChave.DataAgendada  is  not null
             //              then cast( 'X' as flag)
             //            else
             //              case
             //               when _AgenChave1.DataAgendada  is not null
             //                then cast( 'X' as flag)
             //                when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
             //                then cast( 'X' as flag)
             //               else ' '
             //               end
             //            end                                                        as Confirmar,

             /* Associations */
             I_Pedidos._Cliente,
             I_Pedidos._Grupo,
             I_Pedidos._Item,
             I_Pedidos._Partner,
//             I_Pedidos._Remessa,
             _ZI_SalesDocumentQuiqkView

}
