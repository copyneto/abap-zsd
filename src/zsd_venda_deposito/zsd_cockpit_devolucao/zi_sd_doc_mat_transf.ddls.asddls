@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documento Material Transferência'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_DOC_MAT_TRANSF 
 as select from mkpf as _DocMat 
 association to I_BR_NFDocument as _Nf  on _Nf.BR_NotaFiscal     = $projection.DocRef 
                                      and _Nf.BR_NFPostingDate  = $projection.Data {
    key _DocMat.mblnr        as DocMat,
        _DocMat.xblnr        as DocRef,
        _DocMat.budat        as Data,
        _Nf.BR_NFeNumber     as Nfe
}  
