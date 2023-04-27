@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Itens'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_UNION_ITEM_V2
  as select from    I_MaterialStock  as b
    inner join      I_Material       as a on a.Material = b.Material
    left outer join I_MaterialText   as c on c.Material = b.Material
                                      and c.Language = $session.system_language
                                      
                                      
                                    
                                      

{

  key b.Plant,
  key b.StorageLocation,

      b.Material,
      @Semantics.text: true
      c.MaterialName,
      cast( 0 as abap.dec( 31 ) )                       as QtdSol,
      b.MaterialBaseUnit,
      cast( b.MatlWrhsStkQtyInMatlBaseUnit as abap.dec( 31, 14 ) ) as MatlWrhsStkQtyInMatlBaseUnit



}
