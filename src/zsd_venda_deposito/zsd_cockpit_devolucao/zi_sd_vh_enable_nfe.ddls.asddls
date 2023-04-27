@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help search Tipo de devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
@UI.presentationVariant: [{ sortOrder: [{ by: 'TipoDev', direction: #ASC }] }]
define view entity ZI_SD_VH_ENABLE_NFE
  as select from dd07t as Domain
{
      @ObjectModel.text.element: [ 'StatusText' ]
  key domvalue_l as TipoDev,
      @UI.hidden: true
      ddlanguage as Language,
      ddtext     as StatusText,
      @UI.hidden: true
      case
      when domvalue_l = '1'
      then cast( ' ' as flag )
      else cast( 'X' as flag )
      end        as Enable


}
where
      Domain.domname  = 'ZD_TIPO_DEVOLUCAO'
  and Domain.as4local = 'A';
