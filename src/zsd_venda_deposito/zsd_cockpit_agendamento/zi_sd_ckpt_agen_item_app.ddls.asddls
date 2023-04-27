@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'App Cockpit de Agendamento'
define root view entity ZI_SD_CKPT_AGEN_ITEM_APP
  as select from           ZI_SD_AGEN_ENTREGA                                as I_Pedidos
    inner join             ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_AGENDAMENTO',
                                                      p_chave2 : 'TIPOS_OV') as _Param      on _Param.parametro = I_Pedidos.SalesOrderType
    inner join             I_SalesOrderItem                                  as _Item       on  I_Pedidos.SalesOrder           =  _Item.SalesOrder
                                                                                            and I_Pedidos.SalesOrderItem       =  _Item.SalesOrderItem
                                                                                            and (
                                                                                               _Item.SalesDocumentRjcnReason   =  ''
                                                                                               or(
                                                                                                 _Item.SalesDocumentRjcnReason <> ''
                                                                                                 and ( _Item.DeliveryStatus =  'B'
                                                                                                    or _Item.DeliveryStatus =  'C' )
                                                                                               )
                                                                                             )

  //    left outer join        ZI_SD_CKPT_AGEN_REMESSA                         as _Remessa    on  _Remessa.SalesOrder            = I_Pedidos.SalesOrder
    left outer to one join ZI_SD_CKPT_AGEND_REMESSA_ITEM                     as _Remessa    on  _Remessa.SalesOrder     = I_Pedidos.SalesOrder
                                                                                            and _Remessa.Document       = I_Pedidos.Remessa
                                                                                            and _Remessa.SalesOrderItem = I_Pedidos.SalesOrderItem

  //    left outer join ZI_SD_CKPT_AGEN_FATURA                as _Fatura     on  _Fatura.SalesOrder = I_Pedidos.Remessa
  //                                                                         and _Fatura.Item       = I_Pedidos.SalesOrderItem
  //    left outer join ZI_SD_CKPT_AGEN_FATURAMIN                       as _Fatura     on _Fatura.SalesOrder = I_Pedidos.Remessa
    left outer to one join ZI_SD_CKPT_AGEND_CICLO( p_tipo : 'M')             as _Fatura2    on  _Fatura2.SalesOrder = I_Pedidos.Remessa
                                                                                            and _Fatura2.Item       = I_Pedidos.SalesOrderItem
    left outer join        ZI_SD_FRETE_CONVERSION                            as _Frete2     on _Frete2.SalesOrder = I_Pedidos.SalesOrder
    left outer join        ZI_SD_FRETE(p_cat : 'TO')                         as _Frete      on _Frete.SalesOrder = I_Pedidos.Remessa     //_Frete2.Salesorder_conv
    left outer join        ZI_SD_FRETE(p_cat : 'FU')                         as _Fu         on _Fu.SalesOrder = I_Pedidos.Remessa        //_Frete2.Salesorder_conv
    left outer join        ZI_SD_SAIDA_VEI(p_cat: 'TO')                      as _SaidaVei   on  _SaidaVei.SalesOrder = I_Pedidos.Remessa //_Frete2.Salesorder_conv
                                                                                            and _SaidaVei.OrdemFrete = _Frete.OrdemFrete
    left outer join        ZI_SD_CKPT_AGEN_DATA_ENT(p_cat: 'FU')             as _DataEnt    on  _DataEnt.SalesOrder = I_Pedidos.Remessa
                                                                                            and _DataEnt.OrdemFrete = _Fu.OrdemFrete

    left outer join        ZI_SD_AGENDAMENTOS                                as _AgenChave  on  _AgenChave.Ordem   = I_Pedidos.SalesOrder
                                                                                            and _AgenChave.Item    = I_Pedidos.SalesOrderItem
                                                                                            and _AgenChave.Remessa = I_Pedidos.Remessa
                                                                                            and _AgenChave.NfE     = _Remessa.NotaFiscal

    left outer join        ZI_SD_AGENDAMENTOS                                as _AgenChave1 on  _AgenChave1.Ordem   = I_Pedidos.SalesOrder
                                                                                            and _AgenChave1.Item    = I_Pedidos.SalesOrderItem
                                                                                            and _AgenChave1.Remessa = I_Pedidos.Remessa

    left outer join        ZI_SD_AGENDAMENTOS                                as _AgenChave2 on  _AgenChave2.Ordem   = I_Pedidos.SalesOrder
                                                                                            and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                                                                                            and _AgenChave2.Remessa = 'X'
    left outer join        ZI_CA_VH_KVGR5                                    as _Agrup      on _Agrup.Agrupamento = I_Pedidos.kvgr5

  association to ZI_SD_KIT_BON_ORDER_VIEW as _ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = I_Pedidos.SalesOrder

{
  key       I_Pedidos.ChaveOrdemRemessa,
  key       I_Pedidos.ChaveDinamica,
  key       I_Pedidos.SalesOrderItem,
            @Consumption.semanticObject: 'SalesDocument'
            @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuiqkView'
            I_Pedidos.SalesOrder,
            I_Pedidos.Remessa,
            _Remessa.SalesOrder                                                     as Ordem_remessa,
            I_Pedidos.SoldToParty,
            I_Pedidos.SoldToPartyName,
            I_Pedidos.PurchaseOrderByCustomer,
            I_Pedidos.RequestedDeliveryDate,
            I_Pedidos.CreationDate,
            I_Pedidos.SalesOrganization,
            I_Pedidos.DistributionChannel,
            I_Pedidos.OrganizationDivision,
            //            I_Pedidos.CustomerAccountAssignmentGroup,
            //            cast( round( I_Pedidos.PalletItem,3 ) as abap.dec( 15,3 ) ) as PalletItem,
            @ObjectModel.virtualElement: true
            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PLTITM'
            cast( '' as abap.char( 20 )  )                                          as PalletItem,
            I_Pedidos.SalesOrderI,
            I_Pedidos.Plant,
            case
            when I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null
            then I_Pedidos.ItemWeightUnit
            else
            _Remessa.ItemWeightUnit  end                                            as ItemWeightUnit,
            @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
            //            _Item.ItemGrossWeight,
            cast( case
            when I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null
            then cast(_Item.ItemGrossWeight  as abap.dec(15,3) )
            else cast(_Remessa.ItemGrossWeight as abap.dec(15,3) ) end as ntgew_15) as ItemGrossWeight,
            @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
            cast( case
             when I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null
             then cast(_Item.ItemNetWeight  as abap.dec(15,3) )
             else cast(_Remessa.ItemNetWeight  as abap.dec(15,3) ) end as ntgew_15) as ItemNetWeight,
            //            _Item.ItemWeightUnit,

            //            _Remessa.ItemWeightUnit,
            I_Pedidos.Material,
            I_Pedidos.SalesOrderItemText,
            //            @Semantics.quantity.unitOfMeasure: 'ItemVolumeUnit'
            //            I_Pedidos.ItemVolume,
            case
            when I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null
            then cast( I_Pedidos.ItemVolume as abap.dec( 15, 3 ))
            else
            cast( _Remessa.ItemVolume as abap.dec( 15, 3 ))  end                    as ItemVolume,
            case
            when I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null
            then I_Pedidos.ItemVolumeUnit
            else
            _Remessa.ItemVolumeUnit  end                                            as ItemVolumeUnit,
            I_Pedidos.OrderQuantityUnit,
            cast(I_Pedidos.OrderQuantity as abap.dec( 13, 3 ))                      as OrderQuantityItem,
            case
            when _Remessa.ActualDeliveryQuantity is initial or _Remessa.ActualDeliveryQuantity is null
            then cast(I_Pedidos.OrderQuantity as abap.dec( 13, 3 ))
            else

            //            @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
            cast( _Remessa.ActualDeliveryQuantity as abap.dec( 13, 3 )) end         as OrderQuantity,

            I_Pedidos.SalesDocumentRjcnReason,
            I_Pedidos.OverallSDProcessStatus,
            I_Pedidos.OverallSDProcessStatusColor,
            I_Pedidos.SalesOrderType,
            I_Pedidos.SalesDistrict,
            I_Pedidos.Route,
            I_Pedidos.CustomerPurchaseOrderDate,
            I_Pedidos.Supplier,
            I_Pedidos.kvgr5,
            _Agrup.Texto                                                            as AgrupametoText,
            I_Pedidos.regio,
            I_Pedidos.ort01,
            I_Pedidos.ort02,

            _Remessa.Document,
            _Fatura2.DocNum,
            @Semantics.amount.currencyCode:'Currency'
            _Fatura2.Total_Nfe,
            //            _Fatura2.ValorTax,
            //            _Fatura2.Currency,
            _Item.TransactionCurrency                                               as Currency,
            _Fatura2.NotaFiscal,
            ltrim( _Frete.OrdemFrete, '0')                                          as OrdemFrete,
            ltrim( _Fu.OrdemFrete, '0' )                                            as UnidadeFrete,


            //            concat(   concat(   concat(   concat(substring( _DataEnt.DataEntrega, 7, 2 ), '.'),
            //                      concat(   substring( _DataEnt.DataEntrega, 5, 2 ), concat('.', substring( _DataEnt.DataEntrega, 1, 4 )))),
            //
            //                      concat('-', concat(   concat(substring( _DataEnt.DataEntrega, 9, 2 ), ':'),
            //                                concat(substring(_DataEnt.DataEntrega, 11, 2 ), ':')) )),
            //
            //                      substring( _DataEnt.DataEntrega, 13, 2 )
            //                      )                                      as DataEntrega,
            //
            //            @ObjectModel.virtualElement: true
            //            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_CONV'
            //            cast( '' as abap.char( 20 )  )                   as DataEntregaConv,
            cast( _DataEnt.DataEntrega as tzntstmpl)                                as DataEntregaConv,
            @ObjectModel.virtualElement: true
            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CKPT_AGEND_PLTITM'
            cast( '' as abap.char( 20 )  )                                          as PalletFracionado,


            case
             when _AgenChave.DataAgendada  is  not null
              then _AgenChave.DataAgendada
            else
              case
               when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.DataAgendada
               when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                then _AgenChave2.DataAgendada
               else _AgenChave.DataAgendada
               end
            end                                                                     as DataAgendada,

            case
             when _AgenChave.DataAgendada  is  not null
              then _AgenChave.HoraAgendada
            else
              case
               when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.HoraAgendada
               when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                then _AgenChave2.HoraAgendada
               else _AgenChave.HoraAgendada
               end
            end                                                                     as HoraAgendada,

            ''                                                                      as MotivoAgenda,
            case
             when _AgenChave.DataAgendada  is  not null
              then _AgenChave.motivo
            else
              case
               when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.motivo
            when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                then _AgenChave2.motivo
               else _AgenChave.motivo
               end
            end                                                                     as Motivo,

            case
            when _AgenChave.DataAgendada  is  not null
            then _AgenChave.Texto
            else
            case
            when _AgenChave1.DataAgendada  is not null
            then _AgenChave1.Texto
            when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
            then _AgenChave2.Texto
            else _AgenChave.Texto
            end
            end                                                                     as MotivoText,


            case
             when _AgenChave.DataAgendada  is  not null
              then _AgenChave.Senha
            else
              case
               when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.Senha
                when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                then _AgenChave2.Senha
               else _AgenChave.Senha
               end
            end                                                                     as Senha,

            case
            when _AgenChave.DataAgendada  is  not null
            then _AgenChave.observacoes
            else
            case
            when _AgenChave1.DataAgendada  is not null
            then _AgenChave1.observacoes
            when _AgenChave2.DataAgendada  is not null and _AgenChave2.Item    = I_Pedidos.SalesOrderItem
                then _AgenChave2.observacoes
               else _AgenChave.observacoes
            end
            end                                                                     as Observacoes,

            case
                        when I_Pedidos.Remessa is null
                          then '4'//Em Ordem
                        when _Fatura2.NotaFiscal is null
                          then '3'//Em Remessa
                        when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                          then '2'//Em NF-e
                        when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                          then '1' //Saída do Veículo
                        when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                          then '5' //Entrega Realizada
                        when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                          then '5' //Entrega Realizada
            end                                                                     as Status,

            case
                        when I_Pedidos.Remessa is null
                          then 'Em Ordem'
                        when _Fatura2.NotaFiscal is null
                          then 'Em Remessa'
                        when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                          then 'Em NF-e'
                        when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                          then 'Saída do Veículo'
                        when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                          then 'Entrega Realizada'
                        when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                          then 'Entrega Realizada'
            end                                                                     as StatusText,

            case
                         when I_Pedidos.Remessa is initial
                           then 0
                         when _Remessa.NotaFiscal is initial
                           then 0
                         when  _SaidaVei.EventCode <> 'CHECK_OUT'
                           then 0
                         when _SaidaVei.EventCode = 'CHECK_OUT' and _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE'
                           then 0
                        when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                           then 3
                        when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                           then 3
                               else 0
             end                                                                    as StatusColor,
            case
            _Item.DeliveryStatus
            when 'A' then 'Não fornecido'
            when 'B' then 'Remessa parcial'
            when 'C' then 'Fornecido completamente'
            else ' Irrelevante' end                                                 as DeliveryStatus,

            _Frete2.Salesorder_conv,

            /* Associations */
            I_Pedidos._Cliente,
            I_Pedidos._Grupo,
            I_Pedidos._Item,
            I_Pedidos._Partner,
            //            I_Pedidos._Remessa,
            _ZI_SalesDocumentQuiqkView
}
