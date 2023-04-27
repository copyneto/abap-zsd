@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tipo de Operação'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VH_TPOPER
  as select from    dd07l as Domain
    left outer join dd07t as Text on  Text.domname    = Domain.domname
                                  and Text.as4local   = Domain.as4local
                                  and Text.valpos     = Domain.valpos
                                  and Text.as4vers    = Domain.as4vers
                                  and Text.ddlanguage = $session.system_language
{
       @ObjectModel.text.element: ['Nome']
  key  Domain.domvalue_l as tpOper,
       Text.ddtext       as Nome,

       //       case substring(Domain.domvalue_l,1,1)
       case Domain.domvalue_l
         when 'INT1' then '2'
         when 'INT2' then '2'
         when 'INT3' then '2'
         when 'INT4' then '2'
         when 'INT5' then '2'
         when 'INT6' then '2'
         when 'INT7' then '2'
         when 'INT8' then '2'
         when 'TRA1' then '1'
         when 'TRA2' then '1'
         when 'TRA3' then '1'
         when 'TRA4' then '1'
         when 'TRA5' then '1'
         when 'TRA6' then '1'
         when 'TRA7' then '1'
         when 'TRA8' then '1'
         end             as Processo
}
where
      Domain.domname    =  'ZD_TPOP'
  and Domain.domvalue_l <> 'INT3'
