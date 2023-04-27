@AbapCatalog.sqlViewName: 'ZSDI_FILT_DISP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Filtra Dados para o verifica disponibilidade'

define view ZI_SD_CKPT_FAT_FILTRO_DIP
  as select from I_SalesDocumentItem         as _OrdemItem
    inner join   ZI_SD_CKPT_FAT_PARAM_ORDENS as _Param on _Param.parametro <> _OrdemItem.SDProcessStatus
{
  key _OrdemItem.SalesDocument,
      _OrdemItem.Material,
      _OrdemItem.Plant,
      _OrdemItem.StorageLocation
}
where
  SalesDocumentRjcnReason = ' ' 
group by
  SalesDocument,
  Material,
  Plant,
  StorageLocation
