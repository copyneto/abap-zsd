@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Entrada Mercadorias'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_ENTRAD_MERC 
as select from mseg as _EntradMerc
 inner join ZI_SD_PARAM_ENTRAD_MERC  as _Param  on _Param.TpMov   = _EntradMerc.bwart
 association to ZI_SD_DOC_MAT_TRANSF as _DocMat on _DocMat.DocMat = $projection.EntradMerc {
   key _EntradMerc.mblnr as EntradMerc,
       _EntradMerc.bwart as TpMov,
       _DocMat.Nfe       as Nfe
}
