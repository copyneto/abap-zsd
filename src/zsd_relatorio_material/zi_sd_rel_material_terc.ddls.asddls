@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de Material em Poder de Terceiros'
@Metadata.ignorePropagatedAnnotations: true
@VDM.viewType: #COMPOSITE
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_REL_MATERIAL_TERC
  as select from    F_Mmim_Findmatdoch    as DocMaterial

    left outer join I_BillingDocumentItem as _BillingDocumentItem on  _BillingDocumentItem.ReferenceSDDocument     = DocMaterial.DocumentReferenceId
                                                                  and _BillingDocumentItem.ReferenceSDDocumentItem = DocMaterial.DeliveryDocumentItem

    left outer join I_BR_NFDocumentFlow_C as _NFDocumentFlow      on  _NFDocumentFlow.ReferenceDocument     = _BillingDocumentItem.BillingDocument
                                                                  and _NFDocumentFlow.ReferenceDocumentItem = _BillingDocumentItem.BillingDocumentItem

   //association [0..1] to I_BR_NFDocument                as _NFDocument          on _NFDocument.BR_NotaFiscal = $projection.BR_NotaFiscal

  association [0..1] to I_BR_NFItem                    as _NFItem              on (
                  _NFItem.BR_NotaFiscal         = _NFDocumentFlow.BR_NotaFiscal
                  and _NFItem.BR_NotaFiscalItem = _NFDocumentFlow.BR_NotaFiscalItem
                )

  association [0..1] to I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlowSaida on _NFDocumentFlowSaida.BR_NotaFiscal = _NFDocumentFlow.BR_ReferenceNFNumber

{

  key       DocMaterial.MaterialDocument,

  key       DocMaterial.MaterialDocumentItem,

  key       DocMaterial.MaterialDocumentYear,

            @Consumption.valueHelpDefinition: [{
                  entity: {
                      name: 'I_Plant',
                      element: 'Plant'
                  }
              }]
            DocMaterial.Plant,

            DocMaterial.Customer,

            DocMaterial._Customer.CustomerName,

            DocMaterial.Material,

            DocMaterial._Material._Text[1: Language = $session.system_language ].MaterialName,

            DocMaterial.Batch,

            case DocMaterial.DebitCreditCode
              when 'S' then ( cast(DocMaterial.QuantityInEntryUnit as abap.dec( 13, 3 ) ) * -1 )
              when 'H' then cast(DocMaterial.QuantityInEntryUnit as abap.dec( 13, 3 ) )
            end                                                                  as QuantityInEntryUnit,

            DocMaterial.EntryUnit,

            //_NFDocumentFlow.BR_NotaFiscal,
            _NFItem.BR_NotaFiscal,

            _NFItem._BR_NotaFiscal.BR_NFeNumber,

            _NFItem._BR_NotaFiscal.BR_NFIssueDate,

            _NFItem._BR_NotaFiscal.BR_NFPartnerCityName,

            _NFItem._BR_NotaFiscal.BR_NFPartnerRegionCode,

            _NFItem.BR_CFOPCode,

            case _NFItem._BR_NotaFiscal.BR_NFDirection
              when '1' then _NFDocumentFlowSaida.ReferenceDocument
              else ' '
            end                                                                  as ReferenceDocument,

//            DocMaterial.StorageLocation,
            _BillingDocumentItem.StorageLocation,
            _BillingDocumentItem.BillingDocument,
            
            _BillingDocumentItem._BillingDocument.BillingDocumentType,
            
            _BillingDocumentItem._BillingDocument._BillingDocumentType._Text[ Language = $session.system_language ].BillingDocumentTypeName,

            DocMaterial.PostingDate,

            DocMaterial.GoodsMovementType,

            DocMaterial._F_Mmim_Gmtype_Vh2.GoodsMovementTypeName,

            _NFItem._BR_NotaFiscal.BR_NFDirection,

            DocMaterial.MaterialBaseUnit,

            cast(_NFItem.BR_NFTotalAmount as logbr_nftotalamount) as BR_NFTotalAmount,


            COALESCE( _NFItem._BR_NotaFiscal.BR_NFIsCanceled, ' ' )              as NFCanceled,

            COALESCE( _NFItem._BR_NotaFiscal.BR_NFDocumentType, '0' )            as BR_NFDocumentType,

            //@ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
            _NFItem._BR_NotaFiscal.BR_NFeDocumentStatus,

            _NFItem._BR_NotaFiscal._BR_NFeDocumentStatus._Text[1: Language = $session.system_language ].BR_NFeDocumentStatusDesc,

            case _NFItem._BR_NotaFiscal.BR_NFeDocumentStatus
              when ' ' then 2    -- '1a Tela'
              when '1' then 3    -- 'Autorizado'
              when '2' then 1    -- 'Recusado'
              when '3' then 1    -- 'Rejeitado'
                        else 0
            end                                                                  as StatusCriticality


}
where
       DocMaterial.StockChangeType   =  '05'
  and  DocMaterial.IsCancelled       <> 'X'
  and(
       DocMaterial.GoodsMovementType =  '631'
    or DocMaterial.GoodsMovementType =  '632'
    or DocMaterial.GoodsMovementType =  '633'
    or DocMaterial.GoodsMovementType =  '634'
    or DocMaterial.GoodsMovementType =  'Y81'
    or DocMaterial.GoodsMovementType =  'Y82'
    or DocMaterial.GoodsMovementType =  'Y83'
    or DocMaterial.GoodsMovementType =  'Y84'
  )
