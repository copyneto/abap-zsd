@AbapCatalog.sqlViewName: 'ZENFITM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Impressão Nota Fiscal em Massa'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view ZI_IMP_NOTAFISCAL_MASSA_ITM
  as select from    j_1bnflin as _Lin

    left outer join vbrk      as _Vbrk on _Vbrk.vbeln = left(
      _Lin.refkey, 10
    )

{

  key _Lin.docnum as Docnum,
      _Lin.refkey as Refkey,
      _Lin.werks  as Werks,
      _Vbrk.fkart as Fkart,
      _Vbrk.vbtyp as Vbtyp,
      _Vbrk.belnr as Belnr
}
