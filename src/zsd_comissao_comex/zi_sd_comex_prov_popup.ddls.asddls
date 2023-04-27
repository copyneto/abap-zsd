@EndUserText.label: 'Popup Provisionar'
define abstract entity ZI_SD_COMEX_PROV_POPUP
{

  Zdatabl  : j_1bdocdat;

  @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_COMEX_MES', element: 'Mes' } } ]

  Zperiodo : poper;

  zajuste  : zvalor_curr;

  prov     : bapiscmbyesno;

  @EndUserText.label  : 'Observação'
  zobs     : zobs;

}
