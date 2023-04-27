@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissor da ordem, Fornecedor e Vendedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONTR_LOC_COM_PARTNERS
  with parameters
    p_PartnerFunction : abap.char( 2 )
  as select from vbpa as _vbpa
  association to kna1 as _PartnerCustomer on _PartnerCustomer.kunnr = $projection.Partner

{
  key _vbpa.vbeln                           as SDDocument,
  key cast( _vbpa.parvw as abap.char( 2 ) ) as PartnerFunction,

      _vbpa.kunnr                           as Partner,
      _PartnerCustomer.name1                as PartnerName

}
where
  _vbpa.parvw = $parameters.p_PartnerFunction
