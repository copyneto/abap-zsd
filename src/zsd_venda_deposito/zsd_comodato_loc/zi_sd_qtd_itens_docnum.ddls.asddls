@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de Interface - Qtd Itens Docnum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_QTD_ITENS_DOCNUM
  as select from I_BR_NFItem
{
  key BR_NotaFiscal,
      count ( * ) as QtdDocNum
}
group by
  BR_NotaFiscal
