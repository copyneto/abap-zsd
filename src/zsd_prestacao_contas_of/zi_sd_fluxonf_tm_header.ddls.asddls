@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo TM-Cab para prestação de contas OF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_FLUXONF_TM_HEADER
  as select from    ZI_TM_FLUXONF_ITEM

  //Recupera data de encerramento
    left outer join ZI_TM_STOP          as _StopOri           on  ZI_TM_FLUXONF_ITEM.SourceStopUUID = _StopOri.DbKey
                                                              and _StopOri.stop_cat                 = 'O'
                                                              and _StopOri.stop_seq_pos             = 'F'

  //Região de vendas
    left outer join I_CustomerGroupText as _CustomerGroupText on  ZI_TM_FLUXONF_ITEM.CustomerGroup = _CustomerGroupText.CustomerGroup
                                                              and _CustomerGroupText.Language      = $session.system_language

  //Parada ordem de frete
    left outer join ZI_SD_STOP_TM_OF    as _StopOF            on ZI_TM_FLUXONF_ITEM.DestinationStopUUID = _StopOF.DbKey

  //Local de destino
    left outer join ZI_SD_LOCATION_OF   as _LocationOF        on _StopOF.LogLocid = _LocationOF.Location

  //Local de expedição
    left outer join I_ShippingPointText as _ShippingPoint     on  ZI_TM_FLUXONF_ITEM.ShippingPoint = _ShippingPoint.ShippingPoint
                                                              and _ShippingPoint.Language          = $session.system_language

  //Ordem de frete
  association [1..1] to I_TransportationOrder as _TransportationOrder on $projection.TransportationOrderUUID = _TransportationOrder.TransportationOrderUUID

{
  key ZI_TM_FLUXONF_ITEM.TransportationOrderUUID,                                        //Ordem de transporte UUID
      ZI_TM_FLUXONF_ITEM.TransportationOrder,                                            //Ordem de transporte
      ZI_TM_FLUXONF_ITEM.CreationDateTime           as CreationDateTimeFreightOrder,     //Data de criação da ordem de frete
      ZI_TM_FLUXONF_ITEM.ShippingPoint,                                                  //Local de expedição
      ZI_TM_FLUXONF_ITEM.CustomerGroup,                                                  //Região de vendas

      //*Ordem de transporte*//
      _TransportationOrder.TranspOrdLifeCycleStatus,                                     //Status do ciclo
      tstmp_to_dats( _TransportationOrder.TranspOrdLfcycStsChgDteTime,
                     abap_user_timezone(   $session.user,$session.client,'NULL' ) ,
                                           $session.client,
                                           'NULL' ) as FreightOrderEndDate,              //Data de encerramento da ordem de frete

      //*Local de expedição*//
      ZI_TM_FLUXONF_ITEM.ShippingPoint              as ShippingPointTransportationOrd, //Local de expedição
      _ShippingPoint.ShippingPointName,                                                  //Local de expedição(Nome)

      //*Condição de expedição*//
      _StopOri.CondicaoExpedicao                    as ShippingCondition,                //Condição de expedição
      _StopOri.DescCondicaoExpedicao                as ShippingConditionName,            //Condição de expedição(Nome)

      //*Região de vendas*//
      _CustomerGroupText.CustomerGroupName, //Região de vendas(Nome)

      //*UF*//
      _LocationOF._Address.Region //UF - Destino

}

group by
  ZI_TM_FLUXONF_ITEM.TransportationOrderUUID,
  ZI_TM_FLUXONF_ITEM.TransportationOrder,
  ZI_TM_FLUXONF_ITEM.CreationDateTime,
  ZI_TM_FLUXONF_ITEM.ShippingPoint,
  ZI_TM_FLUXONF_ITEM.CustomerGroup,
  ZI_TM_FLUXONF_ITEM.ShippingPoint,
  _TransportationOrder.TranspOrdLifeCycleStatus,
  _TransportationOrder.TranspOrdLfcycStsChgDteTime,
  _ShippingPoint.ShippingPoint,
  _ShippingPoint.ShippingPointName,
  _StopOri.CondicaoExpedicao,
  _StopOri.DescCondicaoExpedicao,
  _CustomerGroupText.CustomerGroupName,
  _LocationOF._Address.Region
