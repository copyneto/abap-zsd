@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Value Help Tipo fatura'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_VH_TIPO_FATURA
  as select from I_BillingDocumentTypeText
    inner join   ztca_param_val as _Param on  _Param.modulo = 'SD'
                                          and _Param.chave1 = 'RELATÓRIO IMOBILI'
                                          and _Param.chave2 = 'TIPO DE ATIVO'
                                          and _Param.chave3 = 'COMODATO'
                                          and _Param.sign   = 'I'
                                          and _Param.opt    = 'EQ'
                                          and _Param.low    = I_BillingDocumentTypeText.BillingDocumentType
{
      @ObjectModel.text.element: ['BillingDocumentTypeName']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key I_BillingDocumentTypeText.BillingDocumentType,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      I_BillingDocumentTypeText.BillingDocumentTypeName

}
where I_BillingDocumentTypeText.Language = $session.system_language
