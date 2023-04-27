@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help Referência Cliente'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_CA_VH_REF_CLIENTE
  as select from           I_SalesDocumentBasic as SalesDocumentBasic
    left outer to one join vbkd on  SalesDocumentBasic.SalesDocument = vbkd.vbeln
                                and vbkd.posnr                       = '000000'
    left outer to one join veda on  SalesDocumentBasic.SalesDocument = veda.vbeln
                                and veda.vposn                       = '000000'
{
  key SalesDocumentBasic.SalesDocument,
  key vbkd.bstkd as Referencia

}
