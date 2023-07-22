@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status disponibilidade estoque'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_STATUS_DISP_HEADER
  as select from ZI_SD_CKPT_STATUS_DISP as _StatusEstoque
{
  key _StatusEstoque.SalesDocument,
      _StatusEstoque.Status,
      _StatusEstoque.ColorStatus,
      _StatusEstoque.StatusDf,
      _StatusEstoque.ColorStatusDf

}
group by
  _StatusEstoque.SalesDocument,
  _StatusEstoque.Status,
  _StatusEstoque.ColorStatus,
  _StatusEstoque.StatusDf,
  _StatusEstoque.ColorStatusDf
