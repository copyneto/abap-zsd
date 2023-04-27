@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Interf. - Busca Descrição Motivo Recusa'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_RECUSA_TEXT
  as select from vbap
    association to tvagt as _DocVenda on vbap.abgru = _DocVenda.abgru
                                      and _DocVenda.spras = 'P'
  
{
    key vbeln,
        abgru,
        _DocVenda.bezei as DescMotivoRecusa
}
where vbap.posnr = '000010'
