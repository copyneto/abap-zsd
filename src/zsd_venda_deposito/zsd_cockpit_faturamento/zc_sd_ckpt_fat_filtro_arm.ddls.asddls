@AbapCatalog.sqlViewName: 'ZSDI_FILTARM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Filtra Dados para o Retorno da Armazenagem'

@OData.entitySet.name: 'BuscaMaterialSet'
@OData.publish: true
define view ZC_SD_CKPT_FAT_FILTRO_ARM
  as select from ZI_SD_CKPT_FAT_FILTRO_RET_ARM  
{
  key SalesDocument,
      Material,
      Plant,
      StorageLocation,
      centrofaturamento
}
group by
  SalesDocument,
  Material,
  Plant,
  StorageLocation, 
  centrofaturamento
