@EndUserText.label: 'Custom Entity App Verificar Utilização'
@UI: { headerInfo: { typeName: 'Verificar Utilização',
                     typeNamePlural: 'Verificar Utilização',
                     title: { type: #STANDARD, label: 'Ordem do Cliente', value: 'SalesOrder' } } }
@Metadata.allowExtensions: true
@ObjectModel: { query.implementedBy: 'ABAP:ZCLSD_VERIF_UTIL_CUSTOM'}
define root custom entity ZC_SD_VERIF_UTIL_CUSTOM_APP
{
      @Consumption.filter.hidden : true
//      _SUBST_MATERIAL            : association to ZI_SD_VH_SUBST_MATERIAL  on _SUBST_MATERIAL.Material = $projection.Material;
                                                                        
      _ZI_SalesDocumentQuiqkView : association to ZI_SalesDocumentQuiqkView on _ZI_SalesDocumentQuiqkView.SalesDocument = $projection.SalesOrder;
      // ------------------------------------------------------
      // Informações de cabeçalho
      // ------------------------------------------------------
      @UI.facet                  : [ { id:              'VerifUtil',
                     purpose     :         #STANDARD,
                     type        :            #IDENTIFICATION_REFERENCE,
                     label       :           'Ordem do Cliente',
                     position    :        10 } ]

      // ------------------------------------------------------
      // Informações de campo
      // ------------------------------------------------------

      @UI                        : {  lineItem:       [ { position: 10, label: 'Ordem do Cliente' },
                                 { type: #FOR_ACTION, dataAction: 'EliminarProduto',invocationGrouping: #CHANGE_SET, label: 'Eliminar produto'  } ,
                                 { type: #FOR_ACTION, dataAction: 'SubstituirProduto', label: 'Substituir produto'  } ],
              identification     : [ { position: 10, label: 'Ordem do Cliente'} ],
              selectionField     : [ { position: 10 } ] }
      @Consumption.semanticObject: 'SalesDocument'
      @ObjectModel.foreignKey.association: '_ZI_SalesDocumentQuickView'
      @EndUserText.label         : 'Ordem de cliente'
  key SalesOrder                 : vdm_sales_order;

      @UI                        : {  lineItem:       [ { position: 20 } ],
            identification       : [ { position: 20 } ],
            selectionField       : [ { position: 20 } ] }
      @EndUserText.label         : 'Item'
  key SalesOrderItem             : sales_order_item;

      @UI                        : {  lineItem:       [ { position: 30 } ],
            identification       : [ { position: 30 } ],
            selectionField       : [ { position: 30 } ] }
//      @ObjectModel.text.element  : ['DescriptionMaterial']
      @EndUserText.label         : 'Material'
      @Consumption.filter.mandatory: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } } ]
      Material                   : matnr;

      @UI                        : {  lineItem:       [ { position: 50 } ],
            identification       : [ { position: 50 } ],
            selectionField       : [ { position: 40 } ] }
      @EndUserText.label         : 'Centro'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_PlantStdVH', element: 'Plant' } } ]
      @Consumption.filter.mandatory: true
      Plant                      : werks_ext;

      @UI                        : {  lineItem:       [ { position: 40 } ],
            identification       : [ { position: 40 } ] }
      @EndUserText.label         : 'Descrição do Material'
      DescriptionMaterial        : maktx;

      @UI                        : {  lineItem:       [ { position: 130 } ],
         identification          : [ { position: 130 } ],
         selectionField          : [ { position: 110 } ] }
      @EndUserText.label         : 'EAN'
      Ean                        : ean11;

      @UI                        : {  lineItem:       [ { position: 60 } ],
        identification           : [ { position: 60 } ],
        selectionField           : [ { position: 50 } ] }
//      @ObjectModel.text.element  : ['CustomerName']
      @EndUserText.label         : 'Emissor da Ordem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_CUSTOMER', element: 'Customer' } } ]
      Customer                   : kunnr;

      @UI                        : {  lineItem:       [ { position: 70 } ],
        identification           : [ { position: 70 } ] }
      @EndUserText.label         : 'Nome do Emissir da ordem'
      CustomerName               : name1_gp;

      @UI                        : {  lineItem:       [ { position: 80 } ],
        identification           : [ { position: 80 } ],
        selectionField           : [ { position: 60 } ] }
      @EndUserText.label         : 'Tipo de Ordem'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_AUART', element: 'SalesDocumentType' } } ]
//      @ObjectModel.text.element  : ['NameSalesOrderType']
      SalesOrderType             : sales_order_type;

      @UI                        : {  lineItem:       [ { position: 90 } ],
        identification           : [ { position: 90 } ] }
      @EndUserText.label         : 'Descrição Tipo de Ordem'
      NameSalesOrderType         : tvakt_bezei;

      @UI                        : {  lineItem:       [ { position: 100 } ],
         identification          : [ { position: 100 } ],
         selectionField          : [ { position: 70 } ] }
      @EndUserText.label         : 'Qtde'
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      OrderQuantity              : kwmeng;

      @UI                        : {  lineItem:       [ { position: 110 } ],
        identification           : [ { position: 110 } ],
        selectionField           : [ { position: 80 } ] }
      @EndUserText.label         : 'UMB'
      OrderQuantityUnit          : meins;

      @UI                        : {  lineItem:       [ { position: 120 } ],
      identification             : [ { position: 120 } ] }
      @Consumption.filter.hidden : true
      @EndUserText.label         : 'Qtde. base'
      @Semantics.quantity.unitOfMeasure: 'UMbase'
      Qtdebase                   : mng01;

      @UI                        : {  lineItem:       [ { position: 140 } ],
      identification             : [ { position: 140 } ]}
      @Consumption.filter.hidden : true
      @EndUserText.label         : 'UM base'
      UMbase                     : meins;

      @UI                        : {  lineItem:       [ { position: 160, label: 'Data entrega/agenda' } ],
        identification           : [ { position: 160, label: 'Data entrega/agenda' } ],
        selectionField           : [ { position: 110 } ] }
      @EndUserText.label         : 'Data entrega/agenda'
      DataFat                    : fkdat;

      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VKORG', element: 'OrgVendas' } } ]
      SalesOrganization          : vkorg;

      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_VTWEG', element: 'CanalDistrib' } } ]
      DistributionChannel        : vtweg;

      @Consumption.filter.hidden : true
      @UI.hidden                 : true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PLTYP', element: 'PriceList' } } ]
      PriceListType              : pltyp;

      @UI                        : {  lineItem:       [ { position: 170 } ],
      identification             : [ { position: 170 } ] }
      @EndUserText.label         : 'Deposito da ordem'
      StorageLocation            : lgort_d;

}
