@AbapCatalog.sqlViewName: 'ZSDI_FILT_ARM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Filtra Dados para o Retorno da Armazenagem'

define view ZI_SD_CKPT_FAT_FILTRO_RET_ARM
  as select from    I_SalesDocumentItem         as _OrdemItem
    left outer join ztsd_centrofatdf            as _CentroDF on _CentroDF.centrofaturamento = _OrdemItem.Plant
    inner join      ZI_SD_CKPT_FAT_PARAM_ORDENS as _Param    on _Param.parametro <> _OrdemItem.SDProcessStatus
{
  key _OrdemItem.SalesDocument,
      _OrdemItem.Material,
      _OrdemItem.Plant,
      _OrdemItem.StorageLocation,
      _CentroDF.centrodepfechado as centrofaturamento
  
}
where
  SalesDocumentRjcnReason = ' '
group by
  SalesDocument,
  Material,
  Plant,
  StorageLocation,
  centrodepfechado
