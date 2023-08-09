@EndUserText.label: 'Consumo ZI_SD_NF_IMP_MASSA'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_NF_IMP_MASSA
  as projection on ZI_SD_NF_IMP_MASSA
  association [0..1] to ZI_CA_VH_PADEST as _Printer on _Printer.Printer = $projection.Printer
{
      @UI.selectionField: [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_BR_NFDOCUMENT', element: 'BR_NOTAFISCAL'  } }]
  key Docnum, 
      @UI.selectionField: [{ position: 70 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_DIRECAO_NF', element: 'BR_NFDirection'  } }]
      Direct, 
      @UI.selectionField: [{ position: 40 }]
      @Consumption.filter: {
          mandatory: true
      }
      TorId, 
      StopOrder, 
      @UI.selectionField: [{ position: 20 }]
      Credat,
      Model,
      Parid,
      Nfenum,
      Printd,
      Criticality,
      Contabilizado,
      Criticality_c,
      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'P_BUSINESSPLACE', element: 'branch'  } }]
      @Consumption.filter: {
          mandatory: true
      }
      Branch,
      @UI.selectionField: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity : {name: 'SHSM_T001W', element: 'werks'  } }]
      Werks,
      Code,
      Name1,
      //      Stras,
      Ort01,
      @UI.selectionField: [{ position: 60 }]
      CCe,
      @EndUserText.label: 'Impressora'
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_CA_VH_PADEST', element: 'Printer' }}]
      Printer,

      _Printer
}
