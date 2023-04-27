@EndUserText.label: 'Custom Entity App Verifica Disp.'
@UI: { headerInfo: { typeName: 'Verifica Disponibilidade',
                     typeNamePlural: 'Verifica Disponibilidade',
                     title: { type: #STANDARD, label: 'Material', value: 'Material' } } }
@Metadata.allowExtensions: true
@ObjectModel: { query.implementedBy: 'ABAP:ZCLSD_VERIF_DISP_CUSTOM'}
//@UI.presentationVariant: [{
//     requestAtLeast: [ 'dataSolic', 'StatusDesc', 'ColorStatus', 'ColorAcaoLogistica', 'MotivoText', 'AcaoText' ] }]
define root custom entity ZC_SD_VERIF_DISP_CUSTOM_APP
{
      // ------------------------------------------------------
      // Informações de cabeçalho
      // ------------------------------------------------------
      //      @UI.facet          : [ { id:              'VerifDisp',
      //                     purpose:         #STANDARD,
      //                     type:            #IDENTIFICATION_REFERENCE,
      //                     label:           'Material',
      //                     position:        10 } ]

      // ------------------------------------------------------
      // Informações de campo
      // ------------------------------------------------------
      @UI                : {  lineItem:       [ { position: 10, label: 'Material' },
                                 { type: #FOR_ACTION, dataAction: 'AcionaLogistica',                 label: 'Acionar logística'  } ,
                                 { type: #FOR_ACTION, dataAction: 'AtribuiMoticoAcao',               label: 'Atribuir motivo Ação'  } ],
      //                         identification: [ { position: 10, label: 'Material'} ],
                         selectionField: [ { position: 10 } ] }
      @EndUserText.label : 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
  key Material           : matnr;

      @UI                : {  lineItem: [ { position: 30 } ],
      //                        identification: [ { position: 30 } ],
                        selectionField: [ { position: 20 } ] }
      @EndUserText.label : 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      @Consumption.filter.mandatory: true
  key Plant              : werks_d;

      @UI                : {  lineItem: [ { position: 40 } ],
      //                        identification: [ { position: 40 } ],
                        selectionField: [ { position: 30 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DEPOSITO_ESTOQUE', element: 'StorageLocation' } } ]
      @Consumption.filter.mandatory: true
  key Deposito           : lgort_d;

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      @EndUserText.label : 'Data Solicitação Logística'
      dataSolic          : abap.dats(8);

      @UI                : {  lineItem: [ { position: 150 } ],
      //        identification   : [ { position: 150 } ],
        selectionField   : [ { position: 60 } ] }
      @EndUserText.label : 'Motivo da Indisponibilidade'
      @ObjectModel.text.element: ['MotivoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_MOTIVO', element: 'Movito' }}]
      motivoIndisp       : ze_motivo_indisp;

      @UI                : {  lineItem: [ { position: 160 } ],
      //        identification   : [ { position: 160 } ],
        selectionField   : [ { position: 70 } ] }
      @EndUserText.label : 'Ação Necessária'
      @ObjectModel.text.element: ['AcaoText']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_ACAO', element: 'Acao' }}]
      acaoNecessaria     : ze_acao;

      @UI                : {  lineItem: [ { position: 20 } ]}
      //                        identification: [ { position: 20 } ] }
      @EndUserText.label : 'Descrição do Material'
      Descricao          : maktx;

      @UI                : {   lineItem: [ { position: 50 } ]}
      //                         identification: [ { position: 50 } ] }
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      @EndUserText.label : 'Qtde em Ordem'
      QtdOrdem           : mng01;

      @UI                : {  lineItem: [ { position: 60 } ]}
      //                        identification: [ { position: 60 } ] }
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      @EndUserText.label : 'Qtde em Remessa'
      QtdRemessa         : mng01;

      @UI                : {  lineItem: [ { position: 70 } ]}
      //                        identification: [ { position: 70 } ] }
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      @EndUserText.label : 'Estoque Utilização Livre'
      QtdEstoqueLivre    : mng01;

      @UI                : {  lineItem: [ { position: 80 } ] }
      //                        identification: [ { position: 80 } ] }
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      @EndUserText.label : 'Saldo'
      Saldo              : mng01;

      @UI                : {  lineItem: [ { position: 90 } ]}
      //                        identification: [ { position: 90 } ] }
      @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
      @EndUserText.label : 'Estoque Depósito Fechado'
      QtdDepositoFechado : mng01;

      @UI                : {  lineItem: [ { position: 100 } ]}
      //                        identification: [ { position: 100 } ] }
      @EndUserText.label : 'Unidade de Medida Básica '
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MEINS', element: 'UnidadeMed' } } ]
      OrderQuantityUnit  : meins;

      @UI                : {  lineItem: [ { position: 130, criticality: 'ColorAcaoLogistica' } ],
      //        identification   : [ { position: 130, criticality: 'ColorAcaoLogistica' } ],
        selectionField   : [ { position: 50 } ] }
      @Consumption.filter:{ selectionType: #SINGLE }
      @EndUserText.label : 'Ação Logística'
      acaoLogistica      : boole_d;

      @UI                : {  lineItem: [ { position: 09 , criticality: 'ColorStatus' } ],
      //        identification   : [ { position: 09, criticality: 'ColorStatus' } ],
        selectionField   : [ { position: 150 } ] }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_STATUS_ESTOQUE', element: 'StatusEstoque' } } ]
      @ObjectModel.text.element: ['StatusDesc']
      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label : 'Status'
      Status             : ze_status_estoque;

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      StatusDesc         : abap.char(12);

      @UI                : {  lineItem:       [ { position: 140 } ],
      //        identification   : [ { position: 140 } ],
        selectionField   : [ { position: 80 } ] }
      @Consumption.filter:{ selectionType: #INTERVAL }
      @EndUserText.label : 'Data Solicitação Logística'
      data_solic_logist  : ze_sd_date;

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      ColorStatus        : abap.int1(3);

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      ColorAcaoLogistica : abap.int1(3);

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      MotivoText         : val_text;

      @Consumption.filter.hidden: true
      @UI.hidden         : true
      AcaoText           : val_text;

      @UI                : {  lineItem:       [ { position: 120, label: 'Centro Depósito Fechado' } ],
      //        identification   : [ { position: 120, label: 'Centro Depósito Fechado' } ],
        selectionField   : [ { position: 40 } ] }
      @EndUserText.label :'Centro Depósito Fechado'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      CentroDepFechado   : werks_ext;
}
