@AbapCatalog.sqlViewName: 'ZKITBONCONT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'ZI_SD_KIT_BON_CONT1'
define view ZI_SD_KIT_BON_CONT1 (
  MatnrKit,
  DocKit,
  PostingDate,
  Plant,
  matkl,
  MatnrFree,
  kunnr,
  BaseUnit,
  EntryUnit,
  QuantityInEntryUnit,
  QuantityInEntryUnitCalc,
  CompanyCodeCurrency,
  TotalGoodsMvtAmtInCCCrcy,
  ManufacturingOrder,
  GoodsMovementType,
  Vbeln,
  Posnr,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  PediSubc,
  table1  
) 
as select from ZI_SD_KIT_BON_CONT {
 MatnrKit,
 DocKit,
 PostingDate,
 Plant,
 matkl,
 MatnrFree,
 kunnr,
 BaseUnit,
 EntryUnit,
 QuantityInEntryUnit,
 QuantityInEntryUnitCalc,
 CompanyCodeCurrency,
 TotalGoodsMvtAmtInCCCrcy,
 ManufacturingOrder,
 GoodsMovementType,
 Vbeln,
 Posnr,
 CreatedBy,
 CreatedAt,
 LastChangedBy,
 LastChangedAt,
 LocalLastChangedAt,
 cast( '          ' as ebeln preserving type) as PediSubc,
 '1' as table1   
} union all
select from ZI_SD_KIT_BON_KITS_sub
{
  MatnrKit,
  DocKit,
  PostingDate,
  Plant,
  matkl,
  MatnrFree,
  kunnr,
  BaseUnit,
  EntryUnit,
  QuantityInEntryUnit,
  QuantityInEntryUnitCalc,
  CompanyCodeCurrency,
  TotalGoodsMvtAmtInCCCrcy,
  ManufacturingOrder,
  GoodsMovementType,
  Vbeln,
  Posnr,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt,
  LocalLastChangedAt,
  PediSubc,
  '2' as table1 
} /*union all
select from ZI_SD_KIT_BON_CONT_CAN {
 MatnrKit,
 DocKit,
 PostingDate,
 Plant,
 matkl,
 MatnrFree,
 kunnr,
 BaseUnit,
 EntryUnit,
 QuantityInEntryUnit,
 CompanyCodeCurrency,
 TotalGoodsMvtAmtInCCCrcy,
 ManufacturingOrder,
 GoodsMovementType,
 Vbeln,
 Posnr,
 CreatedBy,
 CreatedAt,
 LastChangedBy,
 LastChangedAt,
 LocalLastChangedAt,
 cast( '          ' as ebeln preserving type) as PediSubc,
 '1' as table1   
}*/


