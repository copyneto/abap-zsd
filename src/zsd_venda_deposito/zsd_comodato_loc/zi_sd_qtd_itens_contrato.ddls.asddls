@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Qtd Itens Contrato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_QTD_ITENS_CONTRATO
  as select from vbap
{
  key vbeln       as Contrato,
//  key posnr       as ItemContrato,
      count ( * ) as QtdContrato
}
group by
  vbeln
