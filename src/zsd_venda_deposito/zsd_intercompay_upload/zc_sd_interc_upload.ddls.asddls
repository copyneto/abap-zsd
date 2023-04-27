@EndUserText.label: 'Pedidos intercompany via Excel'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity ZC_SD_INTERC_UPLOAD
  as projection on ZI_SD_INTERC_UPLOAD
{
  key Guid,
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
      CenterOrigin,  //Centro de origem
      FileDirectory, //Nome do arquivo
      @Consumption.filter.mandatory: true
      CreatedDate,   //Data de criação
      CreatedTime,   //Hora de criação
      CreatedUser    //Usuário
}
