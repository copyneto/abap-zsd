@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Search Help CFOP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_SD_REL_VH_CFOP
  as select from j_1bagn  as J_1bagn
    join         j_1bagnt as _Text on  _Text.cfop    = j_1bagn.cfop
                                   and _Text.version = j_1bagn.version
                                   and _Text.cfotxt  <> ''
                                   and _Text.spras   = $session.system_language
{

      //@ObjectModel.virtualElement: true
      //@ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLCA_CDS_CFOP'
      @EndUserText.label: 'CFOP'
      @ObjectModel.text.element: ['TextCfop']
      @Search.ranking: #MEDIUM
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key j_1bagn.cfop as Cfop,
      //@ObjectModel.text.element: ['TextCfop']      
      //@Search.ranking: #HIGH
      //@Search.defaultSearchElement: true
      //@Search.fuzzinessThreshold: 0.7      
      //j_1bagn.cfop as CfopBasic,
      @Search.ranking: #LOW
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7      
      _Text.cfotxt as TextCfop            
      //max(j_1bagn.version) as Version      
}
//group by
    //j_1bagn.cfop,
    //_Text.cfotxt
    
