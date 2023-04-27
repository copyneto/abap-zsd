@EndUserText.label: 'Verificação de Disponibilidade'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SD_VERIF_DISP_APP
  as projection on ZI_SD_VERIF_DISP_APP
  //  association to ZI_SD_VH_MOTIVO as _motivo on _motivo.Movito = $projection.motivoIndisp
  //  association to ZI_SD_VH_ACAO   as _acao   on _acao.Acao = $projection.acaoNecessaria
{
          @EndUserText.label: 'Material'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
          //          @ObjectModel.text.element: ['Descricao']
  key     Material,
          @EndUserText.label: 'Centro'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
  key     Plant,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_DEPOSITO_ESTOQUE', element: 'StorageLocation' } } ]
  key     Deposito,
          @EndUserText.label: 'Data Solicitação Logística'
          dataSolic,
          @EndUserText.label: 'Motivo da Indisponibilidade'
          @ObjectModel.text.element: ['MotivoText']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_MOTIVO', element: 'Movito' }}]
          motivoIndisp,
          @EndUserText.label: 'Ação Necessária'
          @ObjectModel.text.element: ['AcaoText']
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_ACAO', element: 'Acao' }}]
          acaoNecessaria,
          //    @EndUserText.label: 'Ordem de cliente'
          //    SalesOrder,
          @EndUserText.label: 'Descrição do Material'
          Descricao,
          
          @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
          @EndUserText.label: 'Qtde em Ordem'
          QtdOrdem,
          @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
          @EndUserText.label: 'Qtde em Remessa'
          QtdRemessa,
          @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
          @EndUserText.label: 'Estoque Utilização Livre'
          QtdEstoqueLivre,
          @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
          @EndUserText.label: 'Estoque Depósito Fechado'
          QtdDepositoFechado,
          @Semantics.quantity.unitOfMeasure : 'OrderQuantityUnit'
          @EndUserText.label: 'Saldo'
          Saldo,
          
          @EndUserText.label: 'Unidade de Medida Básica '
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MEINS', element: 'UnidadeMed' } } ]
          OrderQuantityUnit,
          //          @EndUserText.label: 'Centro Depósito Fechado'
          //          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DEPOSITO', element: 'Plant' }}]
          //          StorageLocation,
          @EndUserText.label: 'Ação Logística'
          acaoLogistica,
          //    @EndUserText.label: 'Data solicitação logística'
          //    dataSolic,
          //       @EndUserText.label: 'Motivo da indisponibilidade'
          //       @ObjectModel.text.element: ['MotivoText']
          //       motivoIndisp,
          //       @EndUserText.label: 'Ação necessária'
          //       @ObjectModel.text.element: ['AcaoText']
          //       acaoNecessaria,

          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_STATUS_ESTOQUE', element: 'StatusEstoque' } } ]
          @ObjectModel.text.element: ['StatusDesc']
          @UI.textArrangement: #TEXT_ONLY
          @EndUserText.label : 'Status'
          Status,
          @Consumption.filter.hidden: true
          @UI.hidden         : true
          StatusDesc,

          @Consumption.filter.hidden: true
          @UI.hidden         : true
          ColorStatus,

          @EndUserText.label: 'Data Solicitação Logística'
          data_solic_logist,
          //          ColorStatus,
          ColorAcaoLogistica,
          @Consumption.filter.hidden: true
          MotivoText,
          @Consumption.filter.hidden: true
          AcaoText,
          @EndUserText.label:'Centro Depósito Fechado'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
          CentroDepFechado



          //          _motivo,
          //          _acao

}
