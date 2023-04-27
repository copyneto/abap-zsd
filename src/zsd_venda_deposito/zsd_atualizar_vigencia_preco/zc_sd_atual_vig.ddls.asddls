@EndUserText.label: 'Atualizar vigência'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define root view entity zc_sd_atual_vig
  as projection on zi_sd_atual_vig as Lista
{
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_DISTRIBUTIONCHANNEL', element: 'OrgUnidID' } }]
          //      @ObjectModel.text.element: ['CanalText']
  key     vtweg,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_PLTYP', element: 'PriceList' } }]
          //      @ObjectModel.text.element: ['PriceText']
  key     pltyp,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_WERKS', element: 'WerksCode' } }]
          //      @ObjectModel.text.element: ['WerksText']
  key     werks,
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATERIAL', element: 'Material' } }]
          //      @ObjectModel.text.element: ['MaterialText']
  key     matnr,
          @EndUserText.label: 'Válido até'
  key     datbi,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Escala'
  key     kstbm,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Sequencia Escala'
  key     klfn1,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Máximo'
  key     mxwrt,
          @Consumption.filter.hidden: true
          @EndUserText.label: 'Mínimo'
  key     gkwrt,
          @EndUserText.label: 'Válido desde'
          datab,

          knumh,
          kodatbi,
          kodatab,

          @Consumption.filter.hidden: true
          @EndUserText.label: 'Preço Sugerido'
          kbetr,
          konwa,
          meins,
          @EndUserText.label: 'Exclusão'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_FLAG', element: 'Flag' } }]
          loevm_ko,
          @EndUserText.label:'Desc. Material'
          MaterialText,
          @EndUserText.label:'Desc. Lista de Preço'
          PriceText,
          @EndUserText.label:'Desc. Centro'
          WerksText,
          @EndUserText.label:'Desc. Canal de Distribuição'
          CanalText,
          @EndUserText.label: 'Família'
          @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_CA_VH_MATKL', element: 'Matkl' } }]
          //      @ObjectModel.text.element: ['GrupoText']
          Grupo,
          @EndUserText.label:'Desc. Família'
          GrupoText,

          /* Associations */
          _Canal,
          _Filial,
          _Lista,
          _Material
}
