@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VisãoConsumo - Relatório de NF canceladas - Sintético'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true

define view entity ZC_SD_BR_RELATORIO_NF_AT
  as select from    I_BR_NFBrief_C                 as VerifyNF

    left outer join I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlow  on _NFDocumentFlow.BR_NotaFiscal = VerifyNF.BR_NotaFiscal

    left outer join I_BillingDocument              as _BillingDocument on _BillingDocument.BillingDocument = _NFDocumentFlow.ReferenceDocument

    left outer join I_SalesOrder                   as _SalesOrder      on _SalesOrder.SalesOrder = _NFDocumentFlow.OriginReferenceDocument

    left outer join I_BR_NFDocument                as _NFDocument      on _NFDocument.BR_NotaFiscal = VerifyNF.BR_NotaFiscal


    left outer join I_BR_NFItem                    as _NFItem          on  _NFItem.BR_NotaFiscal     = VerifyNF.BR_NotaFiscal
                                                                       and _NFItem.BR_NotaFiscalItem = _NFDocumentFlow.BR_NotaFiscalItem

  association [0..1] to I_CompanyCodeVH            as _CompanyCodeSearchHelp   on  _CompanyCodeSearchHelp.CompanyCode = $projection.CompanyCode

  association [0..1] to I_BR_NFBusinessPlace_SH    as _BusinessPlaceSearchHelp on  _BusinessPlaceSearchHelp.Branch = $projection.BusinessPlace

  association [0..1] to I_BR_NFPartnerTypeText     as _NFPartnerType           on  _NFPartnerType.Language         = $session.system_language
                                                                               and _NFPartnerType.BR_NFPartnerType = $projection.BR_NFPartnerType

  association [0..1] to I_BR_NFAdministration_C    as _NFAdministration        on  _NFAdministration.BR_NotaFiscal = $projection.BR_NotaFiscal

  association [0..1] to I_BR_NFTransport_C         as _NFTransport             on  _NFTransport.BR_NotaFiscal = $projection.BR_NotaFiscal

  association [0..1] to ZI_CA_VH_DIRECAO_NF        as _NFDirection             on  _NFDirection.BR_NFDirection = $projection.BR_NFDirection

  association [0..1] to I_BR_NFeDocumentStatusText as _NFeDocumentStatusText   on  _NFeDocumentStatusText.BR_NFeDocumentStatus = $projection.BR_NFeDocumentStatus
                                                                               and _NFeDocumentStatusText.Language             = $session.system_language

{
  key VerifyNF.BR_NotaFiscal                                 as BR_NotaFiscal,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant', element: 'Plant' } }]
      _NFItem.Plant,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DistributionChannel', element: 'DistributionChannel' } }]
      _BillingDocument.DistributionChannel                   as DistributionChannel,
      @Consumption.valueHelpDefinition: [{ entity : { name    : 'ZI_CA_SETOR_ATIV_LIST', element : 'Division' } }]
      _BillingDocument.Division                              as Division,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BILLINGDOCUMENTTYPE', element: 'BillingDocumentType' } }]
      _BillingDocument.BillingDocumentType                   as BillingDocumentType,
      _SalesOrder.SalesOrderType                             as SalesOrderType,
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_SDDocumentReason', element: 'SDDocumentReason' } } ]
      _SalesOrder.SDDocumentReason                           as SDDocumentReason,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' } }]
      VerifyNF.CompanyCode                                   as CompanyCode,
      _CompanyCodeSearchHelp.CompanyCodeName                 as CompanyCodeName,
      //@ObjectModel.text.element: ['BusinessPlaceText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BR_NFBusinessPlace_SH', element: 'Branch' },
                                           additionalBinding: [{ element: 'CompanyCode', localElement: 'CompanyCode' } ]}]
      VerifyNF.BusinessPlace                                 as BusinessPlace,
      _BusinessPlaceSearchHelp.BusinessPlace                 as BusinessPlaceText,
      _NFAdministration.CreatedByUser                        as CreatedByUser,
      _NFAdministration.LastChangedByUser                    as LastChangedByUser,

      case _NFDocument.BR_NFDirection
      when '2' then _NFDocument.BR_NFPartner
      else _NFDocument.BusinessPlace
      end                                                    as ZBR_NFPartner,

      case _NFDocument.BR_NFDirection
        when '2' then _NFDocument.BR_NFPartnerName1
        else _BusinessPlaceSearchHelp.BusinessPlace
      end                                                    as BR_NFReceiverNameFrmtdDesc,

      //@Consumption.valueHelpDefinition: [{ entity : { name: 'I_BR_NFDOCUMENT', element: 'BR_NFENUMBER'  } }]
      VerifyNF.BR_NFeNumber                                  as BR_NFeNumber,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NotaFiscalTypeText', element: 'BR_NFType' } }]
      _NFAdministration.BR_NFType                            as BR_NFType,
      VerifyNF.BR_NFIssueDate                                as BR_NFIssueDate,
      VerifyNF.BR_NFPostingDate                              as BR_NFPostingDate,
      _NFAdministration.CreationTime                         as CreationTime,
      _NFDocument.BR_NFCancellationDate                      as BR_NFCancellationDate,
      _NFDocument.LastChangeTime                             as CancellationLastChangeTime,
      @ObjectModel.text.element: ['BR_NFPartnerTypeDesc']
      //@Consumption.valueHelpDefinition: [{entity: {name: 'I_BR_NFPartnerTypeText', element: 'BR_NFPartnerType' }}]
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_PARTYP_LIST', element: 'BR_NFPartnerType' } }]
      _NFDocument.BR_NFPartnerType                           as BR_NFPartnerType,
      _NFPartnerType.BR_NFPartnerTypeDesc                    as BR_NFPartnerTypeDesc,
      _NFDocument.BR_NFIsCanceled                            as BR_NFIsCanceled,
      //@Semantics.quantity.unitOfMeasure: 'HeaderWeightUnit'
      cast(VerifyNF.HeaderGrossWeight as abap.dec( 15, 3 ) ) as HeaderGrossWeight,
      _NFTransport.HeaderWeightUnit                          as HeaderWeightUnit,
      VerifyNF.SalesDocumentCurrency,
      //@Semantics.amount.currencyCode:'SalesDocumentCurrency'
      @Aggregation.default: #SUM
      VerifyNF.BR_NFTotalAmount                              as BR_NFTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSBaseTotalAmount                        as BR_ICMSBaseTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSTaxTotalAmount                         as BR_ICMSTaxTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_IPITaxTotalAmount                          as BR_IPITaxTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSSTBaseTotalAmount                      as BR_ICMSSTBaseTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSSTTaxTotalAmount                       as BR_ICMSSTTaxTotalAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSDestinationTaxAmount                   as BR_ICMSDestinationTaxAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_ICMSOriginTaxAmount                        as BR_ICMSOriginTaxAmount,
      @Aggregation.default: #SUM
      VerifyNF.BR_FCPOnICMSTaxAmount                         as BR_FCPOnICMSTaxAmount,
      @Consumption.valueHelpDefinition: [{entity: { name: 'I_BR_NFeDocumentStatus', element: 'BR_NFeDocumentStatus' } }]
      @ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
      _NFDocument.BR_NFeDocumentStatus                       as BR_NFeDocumentStatus,

      _NFeDocumentStatusText.BR_NFeDocumentStatusDesc,

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_TP_DOC_NF', element: 'BR_NFIsCreatedManually' } }]
      _NFDocument.BR_NFIsCreatedManually,

      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_VH_DIRECAO_NF', element: 'BR_NFDirection' } }]
      @ObjectModel.text.element: ['BR_NFDirectionDesc']
      VerifyNF.BR_NFDirection,

      _NFDirection.BR_NFDirectionDesc

}
where
     VerifyNF.BR_NFModel = '01'
  or VerifyNF.BR_NFModel = '55'
  or VerifyNF.BR_NFModel = '02'
  or VerifyNF.BR_NFModel = '06'
  or VerifyNF.BR_NFModel = '21'
  or VerifyNF.BR_NFModel = '22'
  or VerifyNF.BR_NFModel = '66'
