@AbapCatalog.sqlViewName: 'ZSD_AGEND_U'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS PARA UNION HEADER'
define view ZI_SD_CKPT_AGEND_UNION

  as select from           ZI_SD_CKPT_AGEN_ENTREGA_HD                            as _Header
    left outer to one join ZI_SD_CKPT_AGEN_MIN_ITEM                              as _Item       on _Item.SalesOrder = _Header.SalesOrder
    left outer to one join ZI_SD_AGEN_ENTREGA                                    as I_Pedidos   on  I_Pedidos.SalesOrder = _Header.SalesOrder
                                                                                                and _Header.Document     = I_Pedidos.Remessa
                                                                                                and _Header.Item         = I_Pedidos.SalesOrderItem
    inner join             ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_AGENDAMENTO',
                                                          p_chave2 : 'TIPOS_OV') as _Param      on _Param.parametro = I_Pedidos.SalesOrderType
    left outer to one join ZI_SD_CKPT_AGEN_HD_REMESSA                            as _Remessa    on  _Remessa.SalesOrder = _Header.SalesOrder
                                                                                                and _Remessa.Document   = I_Pedidos.Remessa
    left outer join        ZI_SD_CKPT_AGEN_FATURAMIN                             as _Fatura     on _Fatura.SalesOrder = I_Pedidos.Remessa
    left outer join        ZI_SD_FRETE_CONVERSION                                as _Frete2     on _Frete2.SalesOrder = I_Pedidos.SalesOrder
    left outer join        ZI_SD_FRETE_ALL                                       as _Frete      on  _Frete.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Frete.tor_cat    = 'TO'

    left outer join        ZI_SD_FRETE_ALL                                       as _Fu         on  _Fu.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Fu.tor_cat    = 'FU'
    left outer join        ZI_SD_SAIDA_VEI(p_cat: 'TO')                          as _SaidaVei   on  _SaidaVei.SalesOrder = I_Pedidos.Remessa
                                                                                                and _SaidaVei.OrdemFrete = _Frete.OrdemFrete
    left outer join        ZI_SD_CKPT_AGEN_DATA_ENT(p_cat: 'FU')                 as _DataEnt    on  _DataEnt.SalesOrder = I_Pedidos.Remessa
                                                                                                and _DataEnt.OrdemFrete = _Fu.OrdemFrete
    left outer join        ZI_SD_CKPT_AGEND_TIMEZONE(p_cat: 'FU')                as _Zone       on  _Zone.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Zone.OrdemFrete = _Fu.OrdemFrete

    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave  on  _AgenChave.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave.NfE         = _Remessa.NotaFiscal
                                                                                                and _AgenChave.Agend_Valid = 'X'

    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave1 on  _AgenChave1.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave1.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave1.Agend_Valid = 'X'

    left outer to one join ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave2 on  _AgenChave2.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave2.Remessa     = 'X'
                                                                                                and _AgenChave2.Agend_Valid = 'X'

    left outer join        ZI_SD_KIT_BON_ORDER_PESO                              as _Peso       on _Peso.SalesOrder = I_Pedidos.SalesOrder

    left outer join        ZI_CA_VH_KVGR5                                        as _Agrup      on _Agrup.Agrupamento = I_Pedidos.kvgr5

{
  key                case
                        when _Remessa.Document is null
                        then concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem )
                        else concat( concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem ), _Remessa.Document )
                      end                                                 as ChaveOrdemRemessa,

  key                case
                 when _Remessa.Document is null
                 then I_Pedidos.SalesOrder
                 else _Remessa.Document
               end                                                        as ChaveDinamica,
  key                I_Pedidos.SalesOrder,
  key                I_Pedidos.SalesOrderItem,
  key                _Remessa.Document                                    as Remessa,
  key                _Remessa.SalesOrder                                  as Ordem_remessa,
  key                I_Pedidos.SoldToParty,
                     I_Pedidos.CreationDate,
                     I_Pedidos.SoldToPartyName,
                     I_Pedidos.PurchaseOrderByCustomer,
                     I_Pedidos.RequestedDeliveryDate,

                     I_Pedidos.SalesOrganization,
                     I_Pedidos.DistributionChannel,
                     I_Pedidos.OrganizationDivision,
                     I_Pedidos.SalesOrderI,
                     I_Pedidos.Plant,
                     case
                     when  _Remessa.Document is null or _Remessa.Document is initial
                     then _Peso.ItemWeightUnit
                     else _Remessa.HeaderWeightUnit
                     end                                                  as ItemWeightUnit,
                     case
                     when  _Remessa.Document is null or _Remessa.Document is initial
                     then
                     _Peso.HeaderGrossWeight
                     else _Remessa.HeaderGrossWeight end                  as ItemGrossWeight,
                     case
                     when _Remessa.Document is null or _Remessa.Document is initial
                     then
                     _Peso.HeaderNetWeight
                     else _Remessa.HeaderNetWeight end                    as ItemNetWeight,
                     I_Pedidos.Material,
                     I_Pedidos.SalesOrderItemText,
                     case
                     when _Remessa.Document is null or _Remessa.Document is initial
                     then cast( I_Pedidos.ItemVolume as abap.dec( 15, 3 ))
                     else
                     cast( _Remessa.ItemVolume as abap.dec( 15, 3 ))  end as ItemVolume,
                     case
                     when _Remessa.Document is null or _Remessa.Document is initial
                     then I_Pedidos.ItemVolumeUnit
                     else
                     _Remessa.ItemVolumeUnit  end                         as ItemVolumeUnit,
                     I_Pedidos.OrderQuantityUnit,
                     I_Pedidos.OverallSDProcessStatus,
                     I_Pedidos.OverallSDProcessStatusColor,
                     I_Pedidos.SalesOrderType,
                     I_Pedidos.SalesDistrict,
                     I_Pedidos.Route,
                     I_Pedidos.CustomerPurchaseOrderDate,
                     I_Pedidos.Supplier,
                     I_Pedidos.kvgr5,
                     _Agrup.Texto                                         as AgrupametoText,
                     I_Pedidos.regio,
                     I_Pedidos.ort01,
                     I_Pedidos.ort02,
                     _Remessa.Document,
                     _Fatura.DocNum,
                     @Semantics.amount.currencyCode:'Currency'
                     _Fatura.Total_Nfe_Header                             as Total_Nfe,
                     //                     _Fatura.Currency,
                     _Header.TransactionCurrency                          as Currency,

                     _Fatura.NotaFiscal,
                     ltrim( _Frete.OrdemFrete, '0')                       as OrdemFrete,
                     ltrim( _Fu.OrdemFrete, '0' )                         as UnidadeFrete,
                     case
                      when _AgenChave.DataAgendada  is  not null
                       then _AgenChave.DataAgendada
                     else
                      case when _AgenChave1.DataAgendada  is not null
                             then _AgenChave1.DataAgendada
                           when _AgenChave2.DataAgendada  is not null
                     //                            and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                             then _AgenChave2.DataAgendada
                              else _AgenChave.DataAgendada
                     //                           else cast( '00000000' as abap.dats )
                      end
                     end                                                  as DataAgendada,

                     case
                      when _AgenChave.DataAgendada  is  not null
                       then _AgenChave.HoraAgendada
                     else
                     case
                     when _AgenChave1.DataAgendada  is not null
                     then _AgenChave1.HoraAgendada
                     when _AgenChave2.DataAgendada  is not null
//                     and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                     then _AgenChave2.HoraAgendada
                         else _AgenChave.HoraAgendada
                     //                       else cast( '000000' as abap.tims )
                        end
                     end                                                  as HoraAgendada,

                     ''                                                   as MotivoAgenda,
                     case when _AgenChave.DataAgendada  is  not null
                           then _AgenChave.motivo
                          else
                     case
                      when _AgenChave1.DataAgendada  is not null
                       then _AgenChave1.motivo
                      when _AgenChave2.DataAgendada  is not null
//                       and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                       then _AgenChave2.motivo
                      else _AgenChave.motivo
                     //                      else cast( '' as abap.char( 4 ) )
                      end
                     end                                                  as Motivo,

                     case when _AgenChave.DataAgendada  is  not null
                           then _AgenChave.Texto
                          else
                     case
                      when _AgenChave1.DataAgendada  is not null
                       then _AgenChave1.Texto
                      when _AgenChave2.DataAgendada  is not null
//                       and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                       then _AgenChave2.Texto
                     else _AgenChave.Texto
                     //                      else cast( '' as abap.char( 20 ) )
                      end
                     end                                                  as MotivoText,

                     case
                      when _AgenChave.DataAgendada  is  not null
                       then _AgenChave.Senha
                     else
                     case
                     when _AgenChave1.DataAgendada  is not null
                     then _AgenChave1.Senha
                     when _AgenChave2.DataAgendada  is not null
//                     and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is  null )
                     then _AgenChave2.Senha
                        else _AgenChave.Senha
                     //                      else cast( '' as abap.char( 30 ) )
                      end
                     end                                                  as Senha,

                     case
                     when _AgenChave.DataAgendada  is  not null
                     then _AgenChave.observacoes
                     else
                     case
                     when _AgenChave1.DataAgendada  is not null
                     then _AgenChave1.observacoes
                     when _AgenChave2.DataAgendada  is not null
//                     and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                     then _AgenChave2.observacoes
                        else _AgenChave.observacoes
                     //                      else cast( '' as abap.char( 20 ) )
                      end
                     end                                                  as Observacoes,

                     _SaidaVei.EventCode,
                     _DataEnt.EventCode                                   as FreteEventCode,

                     case
                      when I_Pedidos.Remessa is null
                        then '4'//Em Ordem
                      when _Fatura.NotaFiscal is null
                        then '3'//Em Remessa
                      when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                        then '2'//Em NF-e
                      when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                        then '1' //Saída do Veículo
                      when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                        then '5' //Entrega Realizada
                      when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                        then '5' //Entrega Realizada
                     end                                                  as Status,

                     case
                     when I_Pedidos.Remessa is null
                     then 'Em Ordem'
                     when _Fatura.NotaFiscal is null
                     then 'Em Remessa'
                     when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                     then 'Em NF-e'
                     when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                     then 'Saída do Veículo'
                     when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                     then 'Entrega Realizada'
                     when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                     then 'Entrega Realizada'
                     end                                                  as StatusText,

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
                           end                                            as StatusColor,

                     _Frete2.Salesorder_conv,
                     I_Pedidos._Cliente,
                     I_Pedidos._Grupo,
                     I_Pedidos._Item,
                     I_Pedidos._Partner,
                     //                     I_Pedidos._Remessa,
                     _DataEnt.DataEntrega,
                     case
                     when _DataEnt.actual_tzone is initial or _DataEnt.actual_tzone is null
                     then _Zone.time_zone
                     else _DataEnt.actual_tzone end                       as time_zone,
                     'A'                                                  as tipo

}
union select distinct from ZI_SD_CKPT_AGEN_ENTREGA_HD                            as _Header
  left outer to one join   ZI_SD_CKPT_AGEN_MIN_ITEM                              as _Item       on _Item.SalesOrder = _Header.SalesOrder
  left outer to one join   ZI_SD_AGEN_ENTREGA                                    as I_Pedidos   on  I_Pedidos.SalesOrder = _Header.SalesOrder
                                                                                                and I_Pedidos.Remessa    is null
  inner join               ZI_SD_CKPT_AGEND_ENTREGA_MIN                          as _ped        on  _ped.SalesOrder     = _Header.SalesOrder
                                                                                                and _ped.Remessa        is null
                                                                                                and _ped.SalesOrderItem = I_Pedidos.SalesOrderItem
  inner join               ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_AGENDAMENTO',
                                                          p_chave2 : 'TIPOS_OV') as _Param      on _Param.parametro = I_Pedidos.SalesOrderType
  left outer to one join   ZI_SD_CKPT_AGEN_HD_REMESSA                            as _Remessa    on  _Remessa.SalesOrder = _Header.SalesOrder
                                                                                                and _Remessa.Document   is null
  left outer join          ZI_SD_CKPT_AGEN_FATURAMIN                             as _Fatura     on _Fatura.SalesOrder = I_Pedidos.Remessa
  left outer join          ZI_SD_FRETE_CONVERSION                                as _Frete2     on _Frete2.SalesOrder = I_Pedidos.SalesOrder
  left outer join          ZI_SD_FRETE_ALL                                       as _Frete      on  _Frete.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Frete.tor_cat    = 'TO'

  left outer join          ZI_SD_FRETE_ALL                                       as _Fu         on  _Fu.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Fu.tor_cat    = 'FU'
  left outer join          ZI_SD_SAIDA_VEI(p_cat: 'TO')                          as _SaidaVei   on  _SaidaVei.SalesOrder = I_Pedidos.Remessa
                                                                                                and _SaidaVei.OrdemFrete = _Frete.OrdemFrete
  left outer join          ZI_SD_CKPT_AGEN_DATA_ENT(p_cat: 'FU')                 as _DataEnt    on  _DataEnt.SalesOrder = I_Pedidos.Remessa
                                                                                                and _DataEnt.OrdemFrete = _Fu.OrdemFrete
  left outer join          ZI_SD_CKPT_AGEND_TIMEZONE(p_cat: 'FU')                as _Zone       on  _Zone.SalesOrder = I_Pedidos.Remessa
                                                                                                and _Zone.OrdemFrete = _Fu.OrdemFrete

  left outer to one join   ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave  on  _AgenChave.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave.NfE         = _Remessa.NotaFiscal
                                                                                                and _AgenChave.Agend_Valid = 'X'

  left outer to one join   ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave1 on  _AgenChave1.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave1.Remessa     = I_Pedidos.Remessa
                                                                                                and _AgenChave1.Agend_Valid = 'X'

  left outer to one join   ZI_SD_CKPT_AGEN_HIST2                                 as _AgenChave2 on  _AgenChave2.Ordem       = I_Pedidos.SalesOrder
                                                                                                and _AgenChave2.Remessa     = 'X'
                                                                                                and _AgenChave2.Agend_Valid = 'X'

  left outer join          ZI_SD_KIT_BON_ORDER_PESO                              as _Peso       on _Peso.SalesOrder = I_Pedidos.SalesOrder

  left outer join          ZI_CA_VH_KVGR5                                        as _Agrup      on _Agrup.Agrupamento = I_Pedidos.kvgr5


{
  key           case
                  when _Remessa.Document is null
                    then concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem )
                  else concat( concat( I_Pedidos.SalesOrder, I_Pedidos.SalesOrderItem ), _Remessa.Document )
                 end                                                   as ChaveOrdemRemessa,

  key           case
            when _Remessa.Document is null
            then I_Pedidos.SalesOrder
            else _Remessa.Document
          end                                                          as ChaveDinamica,
  key           I_Pedidos.SalesOrder,
  key           I_Pedidos.SalesOrderItem,
  key           _Remessa.Document                                      as Remessa,
  key           _Remessa.SalesOrder                                    as Ordem_remessa,
  key           I_Pedidos.SoldToParty,
                I_Pedidos.CreationDate,
                I_Pedidos.SoldToPartyName,
                I_Pedidos.PurchaseOrderByCustomer,
                I_Pedidos.RequestedDeliveryDate,

                I_Pedidos.SalesOrganization,
                I_Pedidos.DistributionChannel,
                I_Pedidos.OrganizationDivision,
                I_Pedidos.SalesOrderI,
                I_Pedidos.Plant,
                case
                 when  _Remessa.Document is null or _Remessa.Document is initial
                  then _Peso.ItemWeightUnit
                 else _Remessa.HeaderWeightUnit
                 end                                                   as ItemWeightUnit,
                case
                 when  _Remessa.Document is null or _Remessa.Document is initial
                  then _Peso.HeaderGrossWeight
                 else _Remessa.HeaderGrossWeight end                   as ItemGrossWeight,
                case
                 when _Remessa.Document is null or _Remessa.Document is initial
                  then _Peso.HeaderNetWeight
                 else _Remessa.HeaderNetWeight end                     as ItemNetWeight,
                I_Pedidos.Material,
                I_Pedidos.SalesOrderItemText,
                case
                 when _Remessa.Document is null or _Remessa.Document is initial
                  then cast( I_Pedidos.ItemVolume as abap.dec( 15, 3 ))
                 else
                  cast( _Remessa.ItemVolume as abap.dec( 15, 3 ))  end as ItemVolume,
                case
                 when _Remessa.Document is null or _Remessa.Document is initial
                  then I_Pedidos.ItemVolumeUnit
                 else
                _Remessa.ItemVolumeUnit  end                           as ItemVolumeUnit,
                I_Pedidos.OrderQuantityUnit,
                I_Pedidos.OverallSDProcessStatus,
                I_Pedidos.OverallSDProcessStatusColor,
                I_Pedidos.SalesOrderType,
                I_Pedidos.SalesDistrict,
                I_Pedidos.Route,
                I_Pedidos.CustomerPurchaseOrderDate,
                I_Pedidos.Supplier,
                I_Pedidos.kvgr5,
                _Agrup.Texto                                           as AgrupametoText,
                I_Pedidos.regio,
                I_Pedidos.ort01,
                I_Pedidos.ort02,
                _Remessa.Document,
                _Fatura.DocNum,
                @Semantics.amount.currencyCode:'Currency'
                _Fatura.Total_Nfe_Header                               as Total_Nfe,
                //                _Fatura.Currency,
                _Header.TransactionCurrency                            as Currency,
                _Fatura.NotaFiscal,
                ltrim( _Frete.OrdemFrete, '0')                         as OrdemFrete,
                ltrim( _Fu.OrdemFrete, '0' )                           as UnidadeFrete,
                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.DataAgendada
                else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.DataAgendada
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.DataAgendada
                   else _AgenChave.DataAgendada
                //                else cast( '00000000' as abap.dats )
                 end
                end                                                    as DataAgendada,

                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.HoraAgendada
                else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.HoraAgendada
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.HoraAgendada
                   else _AgenChave.HoraAgendada
                //                else cast( '000000' as abap.tims )
                 end
                end                                                    as HoraAgendada,

                ''                                                     as MotivoAgenda,
                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.motivo
                 else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.motivo
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.motivo
                   else _AgenChave.motivo
                //                else cast( '' as abap.char( 4 ) )
                 end
                end                                                    as Motivo,

                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.Texto
                 else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.Texto
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.Texto
                    else _AgenChave.Texto
                //                else cast( '' as abap.char( 20 ) )
                  end
                end                                                    as MotivoText,

                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.Senha
                 else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.Senha
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.Senha
                   else _AgenChave.Senha
                //                else cast( '' as abap.char( 30 ) )
                 end
                end                                                    as Senha,


                case
                 when _AgenChave.DataAgendada  is  not null
                  then _AgenChave.observacoes
                 else
                case
                when _AgenChave1.DataAgendada  is not null
                then _AgenChave1.observacoes
                when _AgenChave2.DataAgendada  is not null
//                and ( I_Pedidos.Remessa is initial or I_Pedidos.Remessa is null )
                then _AgenChave2.observacoes
                   else _AgenChave.observacoes
                //                else cast( '' as abap.char( 20 ) )
                 end
                end                                                    as Observacoes,

                _SaidaVei.EventCode,
                _DataEnt.EventCode                                     as FreteEventCode,

                case
                 when I_Pedidos.Remessa is null
                   then '4'     //Em Ordem
                 when _Fatura.NotaFiscal is null
                   then '3'     //Em Remessa
                 when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                   then '2'     //Em NF-e
                 when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                   then '1'      //Saída do Veículo
                 when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                   then '5'      //Entrega Realizada
                 when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                   then '5'      //Entrega Realizada
                end                                                    as Status,

                case
                 when I_Pedidos.Remessa is null
                   then 'Em Ordem'
                 when _Fatura.NotaFiscal is null
                   then 'Em Remessa'
                 when  ( _SaidaVei.EventCode is null or _SaidaVei.EventCode <> 'CHECK_OUT' ) and _DataEnt.EventCode is null
                   then 'Em NF-e'
                 when _SaidaVei.EventCode = 'CHECK_OUT' and ( _DataEnt.EventCode is null or _DataEnt.EventCode <> 'ENTREGUE_NO_CLIENTE' )
                   then 'Saída do Veículo'
                 when  _DataEnt.EventCode = 'ENTREGA_PARCIAL'
                   then 'Entrega Realizada'
                 when  _DataEnt.EventCode = 'ENTREGA_TOTAL'
                   then 'Entrega Realizada'
                end                                                    as StatusText,

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
                end                                                    as StatusColor,

                _Frete2.Salesorder_conv,
                I_Pedidos._Cliente,
                I_Pedidos._Grupo,
                I_Pedidos._Item,
                I_Pedidos._Partner,
                //                I_Pedidos._Remessa,
                _DataEnt.DataEntrega,
                _Zone.time_zone,
                'B'                                                    as tipo

}
