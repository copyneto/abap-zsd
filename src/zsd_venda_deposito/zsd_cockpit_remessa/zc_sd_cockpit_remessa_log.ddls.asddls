@EndUserText.label: 'Cockpit gerenciamento de remessas - Log'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_REMESSA_LOG
  as projection on ZI_SD_COCKPIT_REMESSA_LOG
{
      @EndUserText.label: 'Ordem de Venda'
  key SalesDocument,
      @EndUserText.label: 'Remessa'
  key OutboundDelivery,
      @EndUserText.label: 'Linha'
  key Line,
      @EndUserText.label: 'Criticalidade'
      Criticality,
      @EndUserText.label: 'Tipo'
      Msgty,
      @EndUserText.label: 'ID'
      Msgid,
      @EndUserText.label: 'Número'
      Msgno,
      @EndUserText.label: 'Variável 1'
      Msgv1,
      @EndUserText.label: 'Variável 2'
      Msgv2,
      @EndUserText.label: 'Variável 3'
      Msgv3,
      @EndUserText.label: 'Variável 4'
      Msgv4,
      @EndUserText.label: 'Mensagem'
      Message,
      @EndUserText.label: 'Criado por'
      @ObjectModel.text.element: ['CreatedByName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      CreatedBy,
      CreatedByName,
      @EndUserText.label: 'Criado em'
      CreatedAt,
      @EndUserText.label: 'Alterado por'
      @ObjectModel.text.element: ['LastChangedByName']
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_USER', element: 'Bname' } } ]
      LastChangedBy,
      LastChangedByName,
      @EndUserText.label: 'Alterado em'
      LastChangedAt,
      @EndUserText.label: 'Registro'
      LocalLastChangedAt,

      /* Associations */
      _Cockpit : redirected to parent ZC_SD_COCKPIT_REMESSA
}
