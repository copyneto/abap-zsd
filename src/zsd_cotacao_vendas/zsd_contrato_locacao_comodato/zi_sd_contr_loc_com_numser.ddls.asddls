@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nº de série do material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONTR_LOC_COM_NUMSER
  as select from ser02 as _SER02
    inner join   objk  as _objk on _objk.obknr = _SER02.obknr
{

  key _SER02.obknr,
      _SER02.sdaufnr as SalesContract,
      _SER02.posnr   as SalesContractItem,
      //cast( _objk.sernr as abap.char( 18 )  )   as serie
      ltrim( _objk.sernr, '0' )  as serie

}
