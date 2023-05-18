@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Prestação de contas - Ordem de frete'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_PREST_CONTAS_OF
  as select from ZI_TM_COCKPIT_PRESTACAO_CONTAS as _CockpitPrestContas

  association [0..1] to ZI_SD_FLUXONF_TM_HEADER   as _FluxoTransportationOrder on  $projection.FreightOrderUUID = _FluxoTransportationOrder.TransportationOrderUUID
                                                                               and $projection.FreightUnitUUID  = _FluxoTransportationOrder.FreightUnitUUID

  association [0..1] to ZI_SD_DT_EVT_PREST_CONTAS as _LastEventUF              on  $projection.FreightUnitUUID = _LastEventUF.TransportationOrderUUID

  association [0..1] to ZI_SD_DT_ETG_PREST_CONTAS as _LastDeliveryUF           on  $projection.FreightUnitUUID = _LastDeliveryUF.TransportationOrderUUID

{

      //*Campos Cockpit prestação de compras*//
  key FreightOrderUUID, //Ordem de frete UUID
  key FreightUnitUUID,  //Unidade de frete UUID

      //*Status da provisão*//
      case 'X'
       when StatusEntregue    then 'Entregue'
       when StatusDevolvido   then 'Devolvido'
       when StatusPendente    then 'Pendente'
       when StatusSinistro    then 'Sinistro'
       when StatusColetado    then 'Coletado'
       when StatusNaoColetado then 'Não Coletado'
       else 'Sem status' end                  as StatusProvision,

      case 'X'
       when StatusEntregue    then 3
       when StatusDevolvido   then 3
       when StatusPendente    then 2
       when StatusSinistro    then 2
       when StatusColetado    then 2
       when StatusNaoColetado then 0
       else 0 end                             as StatusProvisionCriticality,

      //*Data referente ao último evento citado*//
      case when StatusEntregue = 'X'
        or StatusDevolvido     = 'X'
        or StatusPendente      = 'X'
        or StatusSinistro      = 'X'
        or StatusColetado      = 'X'
        or StatusNaoColetado   = 'X'
      then
      _LastEventUF.TranspOrdEvtActualDate end as DateStatusProvision,

      //*Canhoto Eletrônico?*//
      cast( case when TranspOrdEventCodeSignature = 'X'
                  and TranspOrdEventCode <> 'ENTREGUE'
                  and TranspOrdEventCode <> 'DEVOLVIDO'
                  and TranspOrdEventCode <> 'PENDENTE'
                  and TranspOrdEventCode <> 'SINISTRO'
                  and TranspOrdEventCode <> 'COLETADO'
                  and TranspOrdEventCode <> 'NÃO COLETADO'
                 then 'Sim'
                 else 'Não'
                 end as abap.char(3) )        as ElectronicStub,

      FreightOrder,                     //Ordem de frete
      TranspOrdLifeCycleStatus,         //Status ordem de frete
      TranspOrdLifeCycleStatusDesc,     //Status ordem de frete(Descrição)
      TranspOrdLifeCycleStatusCrit,     //Criticidade do status da ordem
      FreightUnit,                      //Unidade de frete
      TranspOrdEventCode,               //Status unidade de frete
      TranspOrdEventCodeDesc,           //Status unidade de frete(Descrição)
      TranspOrdEventCodeCrit,           //Criticidade unidade de frete

      //*Data de entrega, parcial ou total*//
      _LastDeliveryUF.TranspOrdEvtActualDate  as DateDelivery,

      SalesDocument,                    //Ordem de venda
      SalesDocumentType,                //Tipo de Ordem de Venda
      DeliveryDocument,                 //Entrega
      BR_NotaFiscal,                    //Nota Fiscal
      DriverId,                         //Motorista
      DriverName,                       //Motorista(Nome)
      ConsigneeId,                      //Recebedor
      ConsigneeName,                    //Recebedor(Nome)
      BusinessPartner,                  //Destino/Emissor da Ordem
      LocationDescription,              //Destino(Descrição)
      PostalCode,                       //CEP
      StreetName,                       //Rua
      HouseNumber,                      //Número
      CityName,                         //Cidade
      _FluxoTransportationOrder.Region, //UFA
      Country,                          //País
      PaymentMethod,                    //Forma de pagamento
      AmountValue,                      //Valor total

      //*Fluxo - Planej de Entrega e Distribuição*//
      _FluxoTransportationOrder.CreationDateTimeFreightOrder, //Data de criação da ordem de frete

      case
       when _FluxoTransportationOrder.TranspOrdLifeCycleStatus = '05'
       then _FluxoTransportationOrder.FreightOrderEndDate
          end                                 as FreightOrderEndDate, //Data de encerramento da ordem de frete

      _FluxoTransportationOrder.ShippingPointTransportationOrd, //Local de expedição
      _FluxoTransportationOrder.ShippingPointName,              //Local de expedição(Nome)

      _FluxoTransportationOrder.ShippingCondition,              //Condição de expedição
      _FluxoTransportationOrder.ShippingConditionName,          //Condição de expedição(Nome)

      _FluxoTransportationOrder.CustomerGroup,                  //Região de vendas
      _FluxoTransportationOrder.CustomerGroupName               //Região de vendas(Nome)

}
