@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'DOCFLOW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_PICKING_DOCFLOW
  as select from I_SDDocumentMultiLevelProcFlow
  association [0..1] to I_UnitOfMeasure as _BaseUnit
    on $projection.BaseUnit = _BaseUnit.UnitOfMeasure
  association [0..1] to I_Currency      as _StatisticsCurrency
    on $projection.StatisticsCurrency = _StatisticsCurrency.Currency

{
      //Key
  key DocRelationshipUUID,

      //Preceding
      PrecedingDocument,
      PrecedingDocumentItem,
      PrecedingDocumentCategory,

      //Subsequent
      SubsequentDocument,
      SubsequentDocumentItem,
      SubsequentDocumentCategory,

      //Process Flow Level
      ProcessFlowLevel,

      //Admin
      @Semantics.systemDate.createdAt: true
      CreationDate,
      CreationTime,
      @Semantics.systemDate.lastChangedAt: true
      LastChangeDate,

      //Quantity of subsequent document
      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      QuantityInBaseUnit,
      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      RefQuantityInOrdQtyUnitAsFloat,
      @DefaultAggregation: #SUM
      @Semantics.quantity.unitOfMeasure: 'BaseUnit'
      RefQuantityInBaseUnitAsFloat,

      @ObjectModel.foreignKey.association: '_BaseUnit'
      BaseUnit,

      @ObjectModel.foreignKey.association: '_OrderQuantityUnit'
      OrderQuantityUnit,
      SDFulfillmentCalculationRule,

      //Pricing of subsequent document
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'StatisticsCurrency'
      NetAmount,

      @ObjectModel.foreignKey.association: '_StatisticsCurrency'
      StatisticsCurrency,

      //Pick Pack Load
      TransferOrderInWrhsMgmtIsConfd,

      // Delivery related fields
      WarehouseNumber,
      MaterialDocumentYear,

      // Billing Plan related fields
      BillingPlan,
      BillingPlanItem,

      _BaseUnit,
      _OrderQuantityUnit,
      _StatisticsCurrency
}
where
  ProcessFlowLevel = '00';
