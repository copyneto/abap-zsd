@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'VisãoConsumo - Relatório materiais em poder de terceiros'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION
//@UI.lineItem: [{criticality: 'PrioCriticality'}]

define view entity ZC_SD_REL_MATERIAL_TERC
  as select from ZI_SD_REL_MATERIAL_TERC
{
  key          MaterialDocument,

  key          MaterialDocumentItem,

               @Consumption.valueHelpDefinition: [{
                   entity: {
                       name: 'F_Mmim_Matdoc_Year_Vh',
                       element: 'MaterialDocumentYear'
                   }
               }]
  key          MaterialDocumentYear,

               Plant,

               @Consumption.valueHelpDefinition: [{
                    entity: {
                        name: 'F_Mmim_Customer_Vh',
                        element: 'Customer'
                    }
                }]
               Customer,

               CustomerName,

               @Consumption.valueHelpDefinition: [{
                    entity: {
                        name: 'I_MaterialVH',
                        element: 'Material'
                    }
                }]
               Material,

               MaterialName,

               Batch,

               @Aggregation.default: #SUM
               QuantityInEntryUnit,

               EntryUnit,

               BR_NotaFiscal,

               BR_NFeNumber,

               BR_NFIssueDate,

               BR_NFPartnerCityName,

               BR_NFPartnerRegionCode,

               BR_CFOPCode,

               ReferenceDocument,

               StorageLocation,

               BillingDocument,
               
               @UI.textArrangement: #TEXT_LAST
               @ObjectModel.text.element: ['BillingDocumentTypeName']
               BillingDocumentType,
               
               BillingDocumentTypeName,

               PostingDate,

               @Consumption.valueHelpDefinition: [{
                    entity: {
                        name: 'ZI_SD_VH_TipoMovPoderTerc',
                        element: 'GoodsMovementType'
                    }
                }]
               GoodsMovementType,

               GoodsMovementTypeName,

               BR_NFDirection,

               MaterialBaseUnit,

               @Aggregation.default: #SUM
               BR_NFTotalAmount,

               NFCanceled,

               BR_NFeDocumentStatus,

               BR_NFeDocumentStatusDesc,
               //@Consumption.filter.hidden: true
               StatusCriticality

               //               @ObjectModel.readOnly: true
               //               case BR_NFeDocumentStatus
               //               when '2' then 'com.sap.vocabularies.UI.v1.CriticalityType/Negative'
               //               when '3' then 'com.sap.vocabularies.UI.v1.CriticalityType/Negative'
               //               when ' ' then 'com.sap.vocabularies.UI.v1.CriticalityType/Critical'
               //               when '1' then 'com.sap.vocabularies.UI.v1.CriticalityType/Positive'
               //               else 'com.sap.vocabularies.UI.v1.CriticalityType/Neutral'
               //               end as PrioCriticality

               /*
                         when ' ' then 2    -- '1a Tela'
                         when '1' then 3    -- 'Autorizado'
                         when '2' then 1    -- 'Recusado'
                         when '3' then 1    -- 'Rejeitado'
                                   else 0
                                   */

}
where
      NFCanceled        is initial
  and BR_NFDocumentType <> '5'
