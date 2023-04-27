@EndUserText.label: 'Consumo ZI_SD_NF_IMP_MASSA'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define root view entity ZC_SD_CANHOTO_IMP_MASSA
  as projection on ZI_SD_CANHOTO_IMP_MASSA

{

  key       Docnum,
            @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_TM_VH_ORDEM_FRETE', element: 'OrdemFrete'  } }]
  key       TorId,
            //Bukrs,
            Parid,
            @Consumption.valueHelpDefinition: [{ entity : {name: 'I_BR_NFDOCUMENT', element: 'BR_NFENUMBER'  } }]
            Nfenum,
            Name1,
            OriginReferenceDocument, 
            PedidoCliente,
            @ObjectModel.text.element: ['TPagText']
            TPag,
            TPagText,
            Waerk,
            BR_NFPartner,
            Auart,
            @Semantics.amount.currencyCode: 'Waerk'
            NfTot

}
