@EndUserText.label: 'Gestão de preço - Invasão'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

define view entity ZC_SD_COCKPIT_GESTAO_PRECO_INV
  as projection on ZI_SD_COCKPIT_GESTAO_PRECO_INV
{
      @EndUserText.label: 'GUID'
  key Guid,
      @EndUserText.label: 'Linha GUID'
  key GuidLine,
      @EndUserText.label: 'Linha'
      @ObjectModel.text.element: ['LineText']
      Line,
      LineText,
      LineCriticality,
      @EndUserText.label: 'Status'
      @ObjectModel.text.element: ['StatusText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_STATUS', element: 'Status' } }]
      Status,
      _Status.StatusText               as StatusText,
      StatusCriticality,
      @EndUserText.label: 'Tipo de operação'
      @ObjectModel.text.element: ['OperationTypeText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_GESTAO_PRECO_TP_OPER', element: 'OperationType' } }]
      OperationType,
      _OperationType.OperationTypeText as OperationTypeText,
      OperationTypeCriticality,
      //@EndUserText.label: 'Lista de Preço'
      //@ObjectModel.text.element: ['PriceListText']
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PLTYP', element: 'PriceList' } }]
      //PriceList,
      //_PriceList.PriceListText         as PriceListText,
      //PriceListCriticality,
      @EndUserText.label: 'Valor'
      MinValue,
      MinValueCriticality,
      @EndUserText.label: 'Moeda'
      Currency,
      CurrencyCriticality,
      @EndUserText.label: 'Data desde'
      DateFrom,
      DateFromCriticality,
      @EndUserText.label: 'Data até'
      DateTo,
      DateToCriticality,
      @EndUserText.label: 'Condição'
      ConditionRecord,
      _ConditionRecord.ConditionRecordCriticality,
      @EndUserText.label: 'Cód Cliente'
      Kunnr,
      KunnrCriticality,
      @EndUserText.label: 'Desc. Cliente'
      KunnrName,      
      @UI.hidden: true
      DeleteInv,
      @EndUserText.label: 'Criado por'
      CreatedBy,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      LastChangedBy,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,
      LocalLastChangedAt,

      /* Associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_GESTAO_PRECO

}
