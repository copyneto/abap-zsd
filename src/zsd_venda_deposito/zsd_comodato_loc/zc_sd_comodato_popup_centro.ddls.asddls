@EndUserText.label: 'Pop-up Centro Destino'
@Metadata.allowExtensions: true
define abstract entity ZC_SD_COMODATO_POPUP_CENTRO
{
  @Consumption.valueHelpDefinition: [{ entity : {name: 'ZI_SD_VH_CENTRO_DEST_COMOD', element: 'WerksCode' },
                                       additionalBinding: [{ element: 'Kunnr', localElement: 'EmissorOrdem' }]} ]
  werks_dest   : werks_d;
  EmissorOrdem : kunag;
}
