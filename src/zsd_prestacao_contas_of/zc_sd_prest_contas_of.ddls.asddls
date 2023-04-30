@EndUserText.label: 'Prestação de contas - Ordem de frete'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_PREST_CONTAS_OF
  as projection on ZI_SD_PREST_CONTAS_OF
{
  key FreightOrderUUID,
  key FreightUnitUUID,
      StatusProvision,
      StatusProvisionCriticality,
      DateStatusProvision,
      ElectronicStub,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_ORDEM_FRETE', element: 'TransportationOrder' } }]
      FreightOrder,
      @Consumption.valueHelpDefinition:   [{ entity: {name: 'ZI_SD_VH_LIFECYCLE_STATUS', element: 'TranspOrdLifeCycleStatus' } }]
      @ObjectModel.text.element: ['TranspOrdLifeCycleStatusDesc']
      TranspOrdLifeCycleStatus,
      TranspOrdLifeCycleStatusDesc,
      TranspOrdLifeCycleStatusCrit,
      CreationDateTimeFreightOrder,
      FreightOrderEndDate,
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_ShippingPointStdVH', element: 'ShippingPoint' } } ]
      @ObjectModel.text.element: ['ShippingPointName']
      ShippingPointTransportationOrd,
      ShippingPointName,
      @ObjectModel.text.element: ['ShippingConditionName']
      ShippingCondition,
      ShippingConditionName,
      @ObjectModel.text.element: ['CustomerGroupName']
      CustomerGroup,
      CustomerGroupName,
      FreightUnit,
      @ObjectModel.text.element: ['TranspOrdEventCodeDesc']
      TranspOrdEventCode,
      TranspOrdEventCodeDesc,
      TranspOrdEventCodeCrit,
      DateDelivery,
      SalesDocument,
      SalesDocumentType,
      DeliveryDocument,
      BR_NotaFiscal,
      @ObjectModel.text.element: ['DriverName']
      DriverId,
      DriverName,
      @ObjectModel.text.element: ['ConsigneeName']
      ConsigneeId,
      ConsigneeName,
      @ObjectModel.text.element: ['LocationDescription']
      BusinessPartner,
      LocationDescription,
      PostalCode,
      StreetName,
      HouseNumber,
      CityName,
      Region,
      Country,
      PaymentMethod,
      AmountValue
}
