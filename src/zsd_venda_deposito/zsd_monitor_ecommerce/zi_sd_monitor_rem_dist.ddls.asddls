@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de Remessa Distinct'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_MONITOR_REM_DIST as select from ZI_SD_MONITOR_REM 
{    
    key DocRelationshipUUID,
    key PrecedingDocument,
    key PrecedingDocumentItem,
    PrecedingDocumentCategory,
    SubsequentDocument,
    SubsequentDocumentItem,
    SubsequentDocumentCategory,
    Remessa,
    CreationDate,
    CreationTime,
    PickingDate,
    PickingTime,
    ActualGoodsMovementDate,
    ActualGoodsMovementTime,
    ShippingPoint,
    OrdemFrete,
    ActualDate,
    ActualDateSaida,
    DateSaida,
    HoraSaida,
    UnidadeFrete,
    Fatura,
    BR_NotaFiscal,
    BR_NFPartnerRegionCode,
    BR_NFIsPrinted,
    BR_NFeDocumentStatus,
    BR_NFeNumber,
    BillingDocumentIsCancelled,
    CreationDateFatura,
    CreationTimeFatura
}
