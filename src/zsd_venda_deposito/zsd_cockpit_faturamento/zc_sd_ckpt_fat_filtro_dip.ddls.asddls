@AbapCatalog.sqlViewName: 'ZSDI_FILTDISP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Filtra Dados para o verifica disponibilidade'

@OData.entitySet.name: 'BuscaMaterialSet'
@OData.publish: true
define view ZC_SD_CKPT_FAT_FILTRO_DIP
  as select from ZI_SD_CKPT_FAT_FILTRO_DIP  
{
  key SalesDocument,
      Material,
      Plant,
      StorageLocation
}
group by
  SalesDocument,
  Material,
  Plant,
  StorageLocation
