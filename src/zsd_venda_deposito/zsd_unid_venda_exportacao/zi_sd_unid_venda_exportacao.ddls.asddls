@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Unidade de venda para o exterior'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_UNID_VENDA_EXPORTACAO
  as select from ztsd_unid_trib
    association to t006a as _Text on $projection.Unit      = _Text.msehi
                                 and _Text.spras = $session.system_language 
    association to t006a as _TextXml on $projection.UnitXml      = _TextXml.msehi
                                 and _TextXml.spras = $session.system_language
    association [1..1] to t604n as _TextSteuc on $projection.ControlCode = _TextSteuc.steuc
                                         and _TextSteuc.spras = $session.system_language                                     
                                                                
{
  key steuc                 as ControlCode,
  key valid_from            as ValidFrom,
      valid_to              as ValidTo,
      msehi                 as Unit,
      un_xml                as UnitXml,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Text,
      _TextXml,
      _TextSteuc
}
