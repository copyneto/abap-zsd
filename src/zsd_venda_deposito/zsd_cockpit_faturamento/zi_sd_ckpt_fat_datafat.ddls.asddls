@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Data do Faturamento'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_DATAFAT
  as select from vbfa as _vbfa 
  association to vbrk as _vbrk_ref on _vbrk_ref.vbeln = $projection.fatura
{
  key  _vbfa.vbelv     as SalesOrder,
       _vbfa.vbeln     as fatura,
       _vbrk_ref.fkdat as data_fatura
       
}
where
      vbelv   = _vbfa.vbelv
  and vbtyp_n = 'M'
  and vbtyp_v = 'C'
