@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Motivos de ordem x Responsabilidade'

@UI: {
 headerInfo: { typeName: 'Motivo', typeNamePlural: 'Motivos' } }
//               title: { type: #STANDARD, value: 'Augru' },
//               description: { value: 'Bezei' } } }

define root view entity ZC_SD_MOTIVOS_RESPONSAVEIS
  as projection on ZI_SD_MOTIVOS_RESPONSAVEIS
{

      @UI.facet: [
              {
                id:       'Motivo',
                purpose:  #STANDARD,
                type:     #IDENTIFICATION_REFERENCE,
                label:    'Motivo x Responsáveis',
                position: 10 }
            ]

      @UI: { lineItem:       [ { position: 10, importance: #HIGH } ],
             identification: [ { position: 10 } ], 
             selectionField: [ { position: 10 } ]
             }
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_SDDocumentReason', element: 'SDDocumentReason'  } }]
      @ObjectModel.text.element: ['Bezei'] 
  key Augru,
      
      @UI: { lineItem:       [ { position: 20, importance: #MEDIUM } ],
             identification: [ { position: 20 } ] }
      Embarque,
      
      @UI: { lineItem:       [ { position: 30, importance: #MEDIUM } ],
             identification: [ { position: 30 } ] }
      Qualidade,
  
      @UI: { lineItem:       [ { position: 40, importance: #MEDIUM } ],
             identification: [ { position: 40 } ] }
      Arearesp,
      
      @UI: { lineItem:       [ { position: 50, importance: #MEDIUM } ],
             identification: [ { position: 50 } ] }
      Impacto,
      
      @UI: { lineItem:       [ { position: 60, importance: #MEDIUM } ],
             identification: [ { position: 60 } ] }
      Detalhamento,
      
      _SDDocumentReasonText.SDDocumentReasonText as Bezei,
        
      /* Associations */
      _SDDocumentReason,
      _SDDocumentReasonText
}
