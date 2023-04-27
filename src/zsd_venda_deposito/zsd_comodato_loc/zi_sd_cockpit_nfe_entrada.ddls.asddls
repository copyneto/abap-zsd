@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit NFE Entrada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_NFE_ENTRADA
  as select from I_BR_NFDocument         as Doc
    inner join   ZI_SD_COMODATO_FLTR_LIN as Lin on Lin.docnum = Doc.BR_NotaFiscal

{

  key Doc.BR_NFeNumber  as Nfenum,
      Doc.BR_NotaFiscal as Docnum,
      Lin.MBLNR,
      Lin.MJAHR,
      Lin.Werks

}
where
  Doc.BR_NFType = 'Y6'
