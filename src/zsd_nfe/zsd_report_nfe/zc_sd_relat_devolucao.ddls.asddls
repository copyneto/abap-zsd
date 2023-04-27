@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Sintético de NFs de Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_SD_RELAT_DEVOLUCAO
  as select from    I_BR_NFBrief_C                 as NFBrief

    left outer join I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlowFirst   on _NFDocumentFlowFirst.BR_NotaFiscal = NFBrief.BR_NotaFiscal

    left outer join ZI_SD_FATURA_PRIMEIRO_ITEM     as _FaturaItem            on _FaturaItem.BillingDocument = _NFDocumentFlowFirst.ReferenceDocument

    left outer join I_CustomerReturn               as _CustomerReturn        on _CustomerReturn.CustomerReturn = _FaturaItem.SalesDocument

    left outer join I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlowFirst_S on _NFDocumentFlowFirst_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber

    left outer join I_BR_NFDocument                as _NFDocument_S          on _NFDocument_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber

    left outer join ZI_SD_MOTIVOS_RESPONSAVEIS     as _MotivosOrdem_S        on _MotivosOrdem_S.Augru = _CustomerReturn.SDDocumentReason

    left outer join I_SalesDocumentPartner         as _Vendedor_S            on _Vendedor_S.SalesDocument     = _NFDocumentFlowFirst_S.OriginReferenceDocument
                                                                             and(
                                                                               _Vendedor_S.PartnerFunction    = 'ZI'
                                                                               or _Vendedor_S.PartnerFunction = 'ZE'
                                                                             )

    left outer join ZI_SD_NF_ITEMS                 as _OrdemFrete_S          on _OrdemFrete_S.Docnum = _NFDocumentFlowFirst.BR_ReferenceNFNumber

    left outer join ZI_SD_FATURA_PRIMEIRO_ITEM     as _FaturaItem_S          on _FaturaItem_S.BillingDocument = _NFDocumentFlowFirst_S.ReferenceDocument

    left outer join ZI_TM_GESTAO_FROTA_DRIVER      as _Motorista_S           on _Motorista_S.FreightOrder = concat(
      '0000000000', _OrdemFrete_S.Tor_id
    )

  association [0..1] to I_BR_NFDocument       as _NFDocument          on _NFDocument.BR_NotaFiscal = $projection.BR_NotaFiscal

  association [0..1] to I_BillingDocumentItem as _BillingDocumentItem on (
     _BillingDocumentItem.BillingDocument         = _FaturaItem.BillingDocument
     and _BillingDocumentItem.BillingDocumentItem = _FaturaItem.BillingDocumentItem
   )
  association [0..1] to I_BR_NFItem_C         as _NFItem              on (
                  _NFItem.BR_NotaFiscal         = _NFDocumentFlowFirst.BR_NotaFiscal
                  and _NFItem.BR_NotaFiscalItem = _NFDocumentFlowFirst.BR_NotaFiscalItem
                )

  association [1..1] to I_BR_BusinessPlace_C  as _BusinessPlace       on (
           _BusinessPlace.Branch          = $projection.BusinessPlace
           and _BusinessPlace.CompanyCode = NFBrief.CompanyCode
         )


  association [0..1] to I_BR_NFTax_C          as _IPI                 on (
                     _IPI.BR_NotaFiscal = $projection.BR_NotaFiscal
                     and _IPI.TaxGroup  = 'IPI'
                   )

  association [0..1] to I_BR_NFTax_C          as _PIS                 on (
                     _PIS.BR_NotaFiscal = $projection.BR_NotaFiscal
                     and _PIS.TaxGroup  = 'PIS'
                   )

  association [0..1] to I_BR_NFTax_C          as _COFINS              on (
                  _COFINS.BR_NotaFiscal = $projection.BR_NotaFiscal
                  and _COFINS.TaxGroup  = 'COFI'
                )

  association [0..1] to I_BR_NFBrief_C        as _NFBrief_S           on _NFBrief_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber


  association [0..1] to I_SalesDocumentItem   as _SalesDocumentItem   on (
       _SalesDocumentItem.SalesDocument         = _FaturaItem_S.SalesDocument
       and _SalesDocumentItem.SalesDocumentItem = _FaturaItem_S.SalesDocumentItem
     )

  association [0..1] to I_BR_NFTax_C          as _IPI_S               on (
                   _IPI_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber
                   and _IPI_S.TaxGroup  = 'IPI'
                 )

  association [0..1] to I_BR_NFTax_C          as _PIS_S               on (
                   _PIS_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber
                   and _PIS_S.TaxGroup  = 'PIS'
                 )

  association [0..1] to I_BR_NFTax_C          as _COFINS_S            on (
                _COFINS_S.BR_NotaFiscal = _NFDocumentFlowFirst.BR_ReferenceNFNumber
                and _COFINS_S.TaxGroup  = 'COFI'
              )

  association [0..1] to I_BuPaIdentification  as _BPVendedorIdent_S   on (
       _BPVendedorIdent_S.BusinessPartner          = _Vendedor_S.Supplier
       and _BPVendedorIdent_S.BPIdentificationType = 'MATRIC'
     )

  association [0..1] to I_BuPaIdentification  as _BPMotorista_S       on (
           _BPMotorista_S.BusinessPartner          = _Motorista_S.Driver
           and _BPMotorista_S.BPIdentificationType = 'MATRIC'
         )

  association [0..1] to I_Supplier            as _Supplier            on _Supplier.Supplier = $projection.Vendedor_S
  //association [0..1] to A_BusinessPartner     as _BusinessPartner     on _BusinessPartner.BusinessPartner = _NFDocument_S.BR_NFPartner


  association [0..1] to I_BillingDocument     as _BillingDocument_S   on _BillingDocument_S.BillingDocument = _NFDocumentFlowFirst_S.ReferenceDocument

{
      @Consumption.semanticObject: 'NotaFiscal'
      @UI: { lineItem:        [ { position: 15,
                                  type:     #WITH_INTENT_BASED_NAVIGATION,
                                  semanticObjectAction: 'zzdisplay' }]}
      @UI.selectionField: [{ position: 9 }]
      @EndUserText.label: 'Docnum Dev'
  key NFBrief.BR_NotaFiscal,

      @UI.lineItem: [{ position: 1 }]
      @UI.selectionField: [{ position: 1 }]
      @Consumption.valueHelpDefinition: [{
          entity: {
              name: 'I_CompanyCodeVH',
              element: 'CompanyCode'
          }
      }]
      //@ObjectModel.text.element: ['CompanyCodeName']
      @Consumption.filter.mandatory: true
      NFBrief.CompanyCode,

      @UI.lineItem: [{ position: 2 }]
      @EndUserText.label: 'Nome da Empresa'
      _NFDocument.CompanyCodeName,

      @UI.lineItem: [{ position: 3 }]
      @UI.selectionField: [{ position: 2 }]
      @Consumption.valueHelpDefinition: [{
         entity: {
             name: 'I_BR_NFBusinessPlace_SH',
             element: 'Branch'
         },
         additionalBinding: [{ element: 'CompanyCode', localElement: 'CompanyCode' } ]
      }]
      //@ObjectModel.text.element: ['BusinessPlaceName']
      NFBrief.BusinessPlace,

      @UI.lineItem: [{ position: 4 }]
      @EndUserText.label: 'Descrição l. negócio'
      _BusinessPlace.BusinessPlaceName,

      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'I_Plant',
                element: 'Plant'
            }
        }]
      @UI.lineItem: [{ position: 5 }]
      @UI.selectionField: [{ position: 3 }]
      @Consumption.filter.mandatory: true
      _NFItem.Plant,

      @UI.lineItem: [{ position: 6 }]
      @EndUserText.label: 'Descrição Centro'
      substring( _NFItem.BR_PlantNameFrmtdDesc, 7, 20 )                                                               as PlantName,

      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_CA_VH_USER',
                element: 'Bname'
            }
        }]
      @UI.lineItem: [{ position: 7 }]
      @EndUserText.label: 'Criado Por'
      _NFDocument.CreatedByUser,

      //      @Consumption.valueHelpDefinition: [{
      //          entity: {
      //              name: 'ZI_CA_VH_DOCTYP_NF',
      //              element: 'BR_NFDocumentType'
      //          }
      //      }]
      @UI.hidden: true
      _NFDocument.BR_NFDocumentType,

      @UI.lineItem: [{ position: 8 }]
      @UI.selectionField: [{ position: 6, exclude: true }]
      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_CA_VH_AUART',
                element: 'SalesDocumentType'
            }
        }]
      //@ObjectModel.text.element: ['CustomerDocumentTypeName']
      @EndUserText.label: 'Tipo OV Devol'
      _CustomerReturn.CustomerReturnType,

      @UI.lineItem: [{ position: 8 }]
      @EndUserText.label: 'Descrição Tp. OV Devol'
      _CustomerReturn._CustomerReturnType._Text[1: Language = $session.system_language ].SalesDocumentTypeName        as CustomerDocumentTypeName,

      @UI.lineItem: [{ position: 9 }]
      @UI.selectionField: [{ position: 7 }]
      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'I_DistributionChannel',
                element: 'DistributionChannel'
            }
        }]
      //@ObjectModel.text.element: ['DistributionChannelName']
      _BillingDocumentItem._BillingDocument.DistributionChannel,

      @UI.selectionField: [{ position: 10 }]
      _BillingDocumentItem._BillingDocument._DistributionChannel._Text[1: Language = $session.system_language ].DistributionChannelName,

      @Consumption.valueHelpDefinition: [{ entity : { name    : 'ZI_CA_SETOR_ATIV_LIST', element : 'Division' } }]
      @EndUserText.label: 'Setor de atividade'
      _BillingDocumentItem._BillingDocument.Division                                                                  as Division,

      @UI.lineItem: [{ position: 11 }]
      @UI.selectionField: [{ position: 8, exclude: true }]
      @Consumption.valueHelpDefinition: [{
           entity: {
               name: 'ZI_CA_VH_CUSTOMER_CNPJ',
               element: 'Customer'
           }
       }]
      @EndUserText.label: 'Cliente'
      _NFDocument.BR_NFPartner,

      @UI.lineItem: [{ position: 12 }]
      @EndUserText.label: 'Nome Cliente'
      _NFDocument.BR_NFPartnerName1,

      @UI.lineItem: [{ position: 13 }]
      @EndUserText.label: 'UF'
      _NFDocument.BR_NFPartnerRegionCode,

      @UI.lineItem: [{ position: 14 }]
      @EndUserText.label: 'Município'
      _NFDocument.BR_NFPartnerCityName,

      @UI.lineItem: [{ position: 16 }]
      @UI.selectionField: [{ position: 11 }]
      @EndUserText.label: 'Nro NFe Dev'
      lpad( NFBrief.BR_NFeNumber, 9, '0'      )                                                                       as BR_NFeNumber,

      @UI.lineItem: [{ position: 17 }]
      @EndUserText.label: 'Tipo Doc Faturamento Dev'
      @Consumption.valueHelpDefinition: [{ entity:
                                            { name: 'I_BILLINGDOCUMENTTYPE',
                                              element: 'BillingDocumentType' }
                                          }]
      _BillingDocumentItem._BillingDocument.BillingDocumentType,

      @UI.lineItem: [{ position: 17 }]
      @EndUserText.label: 'Doc Faturamento de Dev'
      _BillingDocumentItem.BillingDocument,

      @UI.lineItem: [{ position: 18 }]
      @EndUserText.label: 'Data de Emissão Dev'
      NFBrief.BR_NFIssueDate,

      @UI.lineItem: [{ position: 19 }]
      @UI.selectionField: [{ position: 16 }]
      @EndUserText.label: 'Data de Lançamento Dev'
      @Consumption.filter.mandatory: true
      NFBrief.BR_NFPostingDate,

      @UI.lineItem: [{ position: 20 }]
      @EndUserText.label: 'Valor NFe Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_NFTotalAmount,

      @UI.lineItem: [{ position: 21 }]
      @EndUserText.label: 'Valor Produto Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_NFNetPriceTotalAmount,

      @UI.lineItem: [{ position: 22 }]
      @Aggregation.default: #SUM
      @EndUserText.label: 'Peso NFe Dev'
      cast(NFBrief.HeaderGrossWeight as abap.dec( 15, 3 ) )                                                           as HeaderGrossWeight,

      @UI.lineItem: [{ position: 23 }]
      @EndUserText.label: 'Categ NF Dev'
      _NFDocument.BR_NFType,

      @UI.lineItem: [{ position: 24 }]
      @EndUserText.label: 'BC ICMS Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_ICMSBaseTotalAmount,

      @UI.lineItem: [{ position: 25 }]
      @EndUserText.label: 'ICMS Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_ICMSTaxTotalAmount,

      @UI.lineItem: [{ position: 26 }]
      @EndUserText.label: 'BC IPI Dev'
      @Aggregation.default: #SUM
      cast(_IPI.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                         as BR_IPIBaseTotalAmount,

      @UI.lineItem: [{ position: 27 }]
      @EndUserText.label: 'IPI Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_IPITaxTotalAmount,

      @UI.lineItem: [{ position: 28 }]
      @EndUserText.label: 'BC ICMS ST Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_ICMSSTBaseTotalAmount,

      @UI.lineItem: [{ position: 29 }]
      @EndUserText.label: 'ICMS ST Dev'
      @Aggregation.default: #SUM
      NFBrief.BR_ICMSSTTaxTotalAmount,

      @UI.lineItem: [{ position: 30 }]
      @EndUserText.label: 'BC PIS Dev'
      @Aggregation.default: #SUM
      cast(_PIS.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                         as BR_PISBaseTotalAmount,

      @UI.lineItem: [{ position: 31 }]
      @EndUserText.label: 'PIS Dev'
      @Aggregation.default: #SUM
      cast(_PIS.BR_NFTaxTotalAmount as logbr_nficmsstamount)                                                          as BR_PISTaxTotalAmount,

      @UI.lineItem: [{ position: 32 }]
      @EndUserText.label: 'BC COFINS Dev'
      @Aggregation.default: #SUM
      cast(_COFINS.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                      as BR_COFINSBaseTotalAmount,

      @UI.lineItem: [{ position: 33 }]
      @EndUserText.label: 'COFINS Dev'
      @Aggregation.default: #SUM
      cast(_COFINS.BR_NFTaxTotalAmount as logbr_nficmsstamount)                                                       as BR_COFINSTaxTotalAmount,

      @UI.hidden: true
      _BillingDocumentItem.SalesDocument                                                                              as CustomerReturn,

      @UI.selectionField: [{ position: 17 }]
      @EndUserText.label: 'Data do Faturamento'
      _BillingDocumentItem._BillingDocument.BillingDocumentDate,

      //@UI.selectionField: [{ position: 18, exclude: true }]
      //_NFDocument.BR_NFCancellationDate,

      @UI.selectionField: [{ position: 19 }]
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZI_CA_TP_DOC_NF', element: 'BR_NFIsCreatedManually' } }]
      @EndUserText.label: 'Tipo do Documento'
      _NFDocument.BR_NFIsCreatedManually,

      // ------------------------------------------------------
      // Informações das Notas Fiscais de Saída
      // ------------------------------------------------------
      @Consumption.semanticObject: 'NotaFiscal'
      @UI: { lineItem:        [ { position: 34, semanticObjectAction: 'display?sap-ui-tech-hint=GUI', type: #WITH_URL

                                   }]}
      @EndUserText.label: 'Docnum Saída'
      _NFBrief_S.BR_NotaFiscal                                                                                        as BR_NotaFiscal_S,

      @UI.lineItem: [{ position: 35 }]
      @EndUserText.label: 'Nro NFe Saída'
      lpad( _NFBrief_S.BR_NFeNumber, 9, '0' )                                                                         as BR_NFeNumber_S,

      @UI.lineItem: [{ position: 35 }]
      @Consumption.valueHelpDefinition: [{ entity:
                                            { name : 'I_SalesDocumentType',
                                              element: 'SalesDocumentType' }
                                          }]
      @EndUserText.label: 'Tipo Doc. de Venda Saida'
      _SalesDocumentItem._SalesDocument.SalesDocumentType                                                             as SalesDocumentType_S,

      @UI.lineItem: [{ position: 36 }]
      @EndUserText.label: 'Desc Tipo de Doc Vendas Saida'
      _SalesDocumentItem._SalesDocument._SalesDocumentType._Text
      [1:Language = $session.system_language].SalesDocumentTypeName                                                   as SalesOrderTypeName_S,

      @UI.lineItem: [{ position: 37 }]
      @EndUserText.label: 'Data de Lançamento Saida'
      _NFBrief_S.BR_NFPostingDate                                                                                     as BR_NFPostingDate_S,

      @UI.lineItem: [{ position: 38 }]
      @EndUserText.label: 'Data de Emissão Saida'
      _NFBrief_S.BR_NFIssueDate                                                                                       as BR_NFIssueDate_S,

      @UI.lineItem: [{ position: 39 }]
      @EndUserText.label: 'Doc Faturamento de Saida'
      _NFDocumentFlowFirst_S.ReferenceDocument                                                                        as BR_NFReferenceDocument_S,

      @UI.lineItem: [{ position: 39 }]
      @EndUserText.label: 'Tipo Doc Faturamento Saída'
      @Consumption.valueHelpDefinition: [{ entity:
                                            { name: 'I_BILLINGDOCUMENTTYPE',
                                              element: 'BillingDocumentType' }
                                          }]
      _BillingDocument_S.BillingDocumentType                                                                          as BillingDocumentType_S,

      @UI.lineItem: [{ position: 40 }]
      @EndUserText.label: 'Valor NFe Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_NFTotalAmount                                                                                     as BR_NFTotalAmount_S,

      @UI.lineItem: [{ position: 41 }]
      @EndUserText.label: 'Valor Produto Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_NFNetPriceTotalAmount                                                                             as BR_NFNetPriceTotalAmount_S,

      @UI.lineItem: [{ position: 42 }]
      @EndUserText.label: 'Categ NF  Saída'
      _NFDocument_S.BR_NFType                                                                                         as BR_NFType_S,

      @UI.lineItem: [{ position: 43 }]
      @EndUserText.label: 'BC ICMS Saida'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_ICMSBaseTotalAmount                                                                               as BR_ICMSBaseTotalAmount_S,

      @UI.lineItem: [{ position: 44 }]
      @EndUserText.label: 'ICMS Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_ICMSTaxTotalAmount                                                                                as BR_ICMSTaxTotalAmount_S,

      @UI.lineItem: [{ position: 45 }]
      @EndUserText.label: 'BC IPI Saída'
      @Aggregation.default: #SUM
      cast(_IPI_S.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                       as BR_IPIBaseTotalAmount_S,

      @UI.lineItem: [{ position: 46 }]
      @EndUserText.label: 'IPI Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_IPITaxTotalAmount                                                                                 as BR_IPITaxTotalAmount_S,

      @UI.lineItem: [{ position: 47 }]
      @EndUserText.label: 'BC ICMS ST Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_ICMSSTBaseTotalAmount                                                                             as BR_ICMSSTBaseTotalAmount_S,

      @UI.lineItem: [{ position: 48 }]
      @EndUserText.label: 'ICMS ST Saída'
      @Aggregation.default: #SUM
      _NFBrief_S.BR_ICMSSTTaxTotalAmount                                                                              as BR_ICMSSTTaxTotalAmount_S,

      @UI.lineItem: [{ position: 49 }]
      @EndUserText.label: 'BC PIS Saída'
      @Aggregation.default: #SUM
      cast(_PIS_S.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                       as BR_PISBaseTotalAmount_S,

      @UI.lineItem: [{ position: 50 }]
      @EndUserText.label: 'PIS Saída'
      @Aggregation.default: #SUM
      cast(_PIS_S.BR_NFTaxTotalAmount as logbr_nficmsstamount)                                                        as BR_PISTaxTotalAmount_S,

      @UI.lineItem: [{ position: 51 }]
      @EndUserText.label: 'BC COFINS Saída'
      @Aggregation.default: #SUM
      cast(_COFINS_S.BR_NFBaseTotalAmount as logbr_nficmsstamount)                                                    as BR_COFINSBaseTotalAmount_S,

      @UI.lineItem: [{ position: 52 }]
      @EndUserText.label: 'COFINS Saída'
      @Aggregation.default: #SUM
      cast(_COFINS_S.BR_NFTaxTotalAmount as logbr_nficmsstamount)                                                     as BR_COFINSTaxTotalAmount_S,

      @UI.lineItem: [{ position: 53 }]
      @Consumption.valueHelpDefinition: [ { entity:
                                            { name: 'I_SDDocumentReason',
                                              element: 'SDDocumentReason' }
                                           } ]
      _CustomerReturn.SDDocumentReason,

      @UI.lineItem: [{ position: 54 }]
      @EndUserText.label: 'Descrição do Motivo'
      _CustomerReturn._SDDocumentReason._Text[1:Language = $session.system_language].SDDocumentReasonText             as SDDocumentReasonText_S,

      @UI.lineItem: [{ position: 55 }]
      @EndUserText.label: 'Área Responsável-Dev'
      _MotivosOrdem_S.Arearesp                                                                                        as AreaResponsavel_S,

      @UI.lineItem: [{ position: 56 }]
      @EndUserText.label: 'Impacto Indicador'
      _MotivosOrdem_S.Impacto,

      @UI.lineItem: [{ position: 57 }]
      @EndUserText.label: 'Com Embarque'
      _MotivosOrdem_S.Embarque,

      @UI.lineItem: [{ position: 58 }]
      @EndUserText.label: 'Indicador Avarias'
      _MotivosOrdem_S.Qualidade,

      @UI.lineItem: [{ position: 59 }]
      @EndUserText.label: 'Cód Vendedor'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier_VH', element: 'Supplier' } }]
      //@Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PARID', element: 'BR_NFPartner' } }]
      _Vendedor_S.Supplier                                                                                            as Vendedor_S,

      @UI.lineItem: [{ position: 60 }]
      @EndUserText.label: 'Nome Vendedor'
      _Supplier.SupplierFullName                                                                                      as NomeVendedor_S,

      @UI.lineItem: [{ position: 61 }]
      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_BP_IDENTIFICATION',
                element: 'BPIdentificationNumber'
            }
        }]
      @EndUserText.label: 'Matrícula do Vendedor'
      _BPVendedorIdent_S.BPIdentificationNumber                                                                       as BPIdentificationNumber_S,

      @UI.lineItem: [{ position: 62 }]
      @EndUserText.label: 'Cód Motorista'
      _Motorista_S.Driver                                                                                             as Motorista_S,

      @UI.lineItem: [{ position: 63 }]
      @EndUserText.label: 'Nome do Motorista'
      _Motorista_S.DriverName                                                                                         as NomeMotorista_S,

      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_BP_IDENTIFICATION',
                element: 'BPIdentificationNumber'
            }
        }]
      @UI.lineItem: [{ position: 64 }]
      @EndUserText.label: 'Matrícula do Motorista'
      _BPMotorista_S.BPIdentificationNumber                                                                           as MatriculaMotorista_S,

      @UI.lineItem: [{ position: 66 }]
      @EndUserText.label: 'Ordem de Frete '
      _OrdemFrete_S.Tor_id                                                                                            as OrdemFrete_S,

      @UI.lineItem: [{ position: 67 }]
      @EndUserText.label: 'Itinerário'
      _SalesDocumentItem._Route.Route                                                                                 as Route_S,

      @UI.lineItem: [{ position: 68 }]
      @EndUserText.label: 'Descrição de Itinerário'
      _SalesDocumentItem._Route._Text[1:Language = $session.system_language].RouteName                                as RouteTextInv_S,

      @UI.lineItem: [{ position: 69 }]
      @EndUserText.label: 'Descrição do Itinerário'
      _SalesDocumentItem._Route._Text                                                                                 as RouteText_S,

      @UI.lineItem: [{ position: 70 }]
      @EndUserText.label: 'Cod região de Vendas'
      _SalesDocumentItem._SalesDocument.SalesDistrict                                                                 as SalesDistrict_S,

      @UI.lineItem: [{ position: 71 }]
      @EndUserText.label: 'Desc. Região de Vendas'
      _SalesDocumentItem._SalesDocument._SalesDistrict._Text[1:Language = $session.system_language].SalesDistrictName as SalesDistrictName_S,

      @UI.lineItem: [{ position: 72 }]
      @EndUserText.label: 'Escritório de Vendas'
      _SalesDocumentItem._SalesDocument.SalesOffice                                                                   as SalesOffice_S,

      @UI.selectionField: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{
            entity: {
                name: 'ZI_CA_VH_SALESORG', element: 'SalesOrgID'
            }
          }]
      _SalesDocumentItem._SalesDocument.SalesOrganization                                                             as SalesOrganization_S,

      @UI.lineItem: [{ position: 73 }]
      @Aggregation.default: #SUM
      @EndUserText.label: 'Peso NFe Saída'
      cast(_NFBrief_S.HeaderGrossWeight as abap.dec( 15, 3 ) )                                                        as HeaderGrossWeight_S

      //@UI.lineItem: [{ position: 72 }]
      //@EndUserText.label: 'Matrícula2'
      //_BusinessPartner._BuPaIdentification[ BPIdentificationType = 'MATRIC' ].BPIdentificationNumber                  as Matricula2
}
where
      _NFDocument.BR_NFDocumentType    = '6'
  and _NFDocument.BR_NFIsCanceled      = ' '
  and _NFDocument.BR_NFeDocumentStatus = '1'
  and NFBrief.BR_NFDirection           = '1'
