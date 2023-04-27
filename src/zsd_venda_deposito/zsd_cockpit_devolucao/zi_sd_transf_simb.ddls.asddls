@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Transferência Simbolica'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_TRANSF_SIMB 
 as select from mseg as _Transferencia
 inner join ZI_SD_PARAM_TRANSF_SIMB  as _Param  on _Param.TpMov   = _Transferencia.bwart
 association to ZI_SD_DOC_MAT_TRANSF as _DocMat on _DocMat.DocMat = $projection.NumDocMat {
   key _Transferencia.mblnr as NumDocMat,
       _Transferencia.bwart as TpMov,
       _DocMat.Nfe          as Nfe
}
