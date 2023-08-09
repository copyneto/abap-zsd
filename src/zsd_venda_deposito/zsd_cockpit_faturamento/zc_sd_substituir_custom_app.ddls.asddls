@EndUserText.label: 'Custom Entity App Substiruir'
@UI: { headerInfo: { typeName: 'Substituir Produto',
                     typeNamePlural: 'Substituir Produtos',
                     title: { type: #STANDARD, label: 'Ordem do Cliente', value: 'SalesOrder' } } }
@Metadata.allowExtensions: true
@ObjectModel: { query.implementedBy: 'ABAP:ZCLSD_SUBSTITUIR_CUSTOM'}
define root custom entity ZC_SD_SUBSTITUIR_CUSTOM_APP
{
      @Consumption.filter.hidden : true
      //      _SUBST_MATERIAL            : association to ZI_SD_VH_SUBST_MATERIAL  on _SUBST_MATERIAL.Material = $projection.Material;

      _ZI_SalesDocumentQuiqkView : association to ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = $projection.SalesOrder;
      // ------------------------------------------------------
      // Informações de cabeçalho
      // ------------------------------------------------------
      @UI.facet                  : [ { id:              'Substituir',
                     purpose     :         #STANDARD,
                     type        :            #IDENTIFICATION_REFERENCE,
                     label       :           'Ordem do Cliente',
                     position    :        10 } ]

      // ------------------------------------------------------
      // Informações de campo
      // ------------------------------------------------------

      @UI                        : {  lineItem:       [ { position: 10, label: 'Ordem do Cliente' }],
              identification     : [ { position: 10, label: 'Ordem do Cliente'} ],
              selectionField     : [ { position: 10 } ] }
      @Consumption.semanticObject: 'SalesDocument'
      @Consumption.filter.mandatory: true
      //      @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuickView'
      @EndUserText.label         : 'Ordem de cliente'
  key SalesOrder                 : vdm_sales_order;

      @UI                        : {  lineItem:       [ { position: 20 } ],
            identification       : [ { position: 20 } ],
            selectionField       : [ { position: 20 } ] }
      @EndUserText.label         : 'Item'
  key SalesOrderItem             : sales_order_item;

      @UI                        : {  lineItem:       [ { position: 30 } ],
          identification         : [ { position: 30 } ],
          selectionField         : [ { position: 30 } ] }
      //      @ObjectModel.text.element  : ['DescriptionMaterial']
      @EndUserText.label         : 'Produto'
      @UI.textArrangement        : #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]

  key MaterialAtual              : matnr;

      @UI                        : {  lineItem:       [ { position: 40 } ],
            identification       : [ { position: 40 } ],
            selectionField       : [ { position: 40 } ] }
      @ObjectModel.text.element  : ['DescriptionMaterial']
      @EndUserText.label         : 'Produto Substituir'
      @UI.textArrangement        : #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
  key Material                   : matnr;

      @UI                        : {  lineItem:       [ { position: 50 } ],
            identification       : [ { position: 50 } ],
            selectionField       : [ { position: 40 } ] }
      @EndUserText.label         : 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      Plant                      : werks_ext;

      @UI                        : {  lineItem:       [ { position: 40 } ],
          identification         : [ { position: 40 } ] }
      @EndUserText.label         : 'Descrição Produto'
      DescriptionMaterial2       : maktx;

      @UI                        : {  lineItem:       [ { position: 60 } ],
      identification             : [ { position: 60 } ] }
      @EndUserText.label         : 'Descrição Produto Substituir'
      DescriptionMaterial        : maktx;


      @UI                        : {  lineItem:       [ { position: 70 } ],
         identification          : [ { position: 70 } ],
         selectionField          : [ { position: 50 } ] }
      @EndUserText.label         : 'EAN'
      Ean                        : ean11;
      @UI                        : {  lineItem:       [ { position: 90 } ],
         identification          : [ { position: 90 } ],
         selectionField          : [ { position: 60 } ] }
      @EndUserText.label         : 'Fator'

      Fator                      : umziz;

      @UI                        : {  lineItem:       [ { position: 100 } ],
         identification          : [ { position: 100 } ],
         selectionField          : [ { position: 70 } ] }
      @EndUserText.label         : 'Qtde'
      @Semantics.quantity.unitOfMeasure: 'OrderUnit'
      OrderQuantity              : kwmeng;

      @UI.hidden                 : true
      OrderUnit                  : meins;

      @UI                        : {  lineItem:       [ { position:110 } ],
        identification           : [ { position: 110 } ],
        selectionField           : [ { position: 80 } ] }
      @EndUserText.label         : 'UMB'
      OrderQuantityUnit          : meins;

      @UI                        : {  lineItem:       [ { position: 120 } ],
      identification             : [ { position: 120 } ] }
      @EndUserText.label         : 'Estoque em Utilização Livre'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      EstoqueLivre               : mengv13;

      @UI                        : {  lineItem:       [ { position: 130 } ],
      identification             : [ { position: 130 } ]}
      @EndUserText.label         : 'Estoque em Remessa'
      @Semantics.quantity.unitOfMeasure: 'Unit'
      EstoqueRemessa             : mengv13;

      @UI.hidden                 : true
      ClasseDoc                  : kalvg;

      @UI                        : {  lineItem:       [ { position: 140 } ],
        identification           : [ { position: 140 } ],
        selectionField           : [ { position: 120 } ] }
      @EndUserText.label         : 'Moeda'
      Moeda                      : konwa;
      @UI                        : {  lineItem:       [ { position: 150 } ],
      identification             : [ { position: 150 } ],
      selectionField             : [ { position: 130 } ] }
      @EndUserText.label         : 'Unidade de Preço'
      UnitPreco                  : kpein;
      @UI                        : {  lineItem:       [ { position: 160 } ],
      identification             : [ { position: 160 } ],
      selectionField             : [ { position: 140 } ] }
      @Semantics.amount.currencyCode : 'Moeda'
      @EndUserText.label         : 'Preço'
      Preco                      : kbetr_kond;
      @UI                        : {  lineItem:       [ { position: 170 } ],
      identification             : [ { position: 170 } ],
      selectionField             : [ { position: 150 } ] }
      @EndUserText.label         : 'UM preço'
      UmPreco                    : kmein;

      @UI.hidden                 : true
      Unit                       : meins;

      @EndUserText.label         : 'Limite Inferior'
      @Semantics.amount.currencyCode : 'Moeda'
      ValorMin                   : mxwrt;
      @EndUserText.label         : 'Limite Superior'
      @Semantics.amount.currencyCode : 'Moeda'
      ValorMax                   : gkwrt;
      // ------------------------------------------------------
      // Buttons information
      // ------------------------------------------------------
      @UI.lineItem               : [{ position: 10, type: #FOR_ACTION, dataAction: 'SubstituirProduto', label: 'Substituir produto', invocationGrouping: #CHANGE_SET  },
                                    { position: 20, type: #FOR_ACTION, dataAction: 'SubstituirProdutoTeste', label: 'Substituir produto teste', invocationGrouping: #CHANGE_SET  }]
      @UI.hidden                 : true
      Action                     : abap.char(1);
}
