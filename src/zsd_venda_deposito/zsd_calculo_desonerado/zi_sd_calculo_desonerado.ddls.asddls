@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cóg Benefício e Valor ICMS Desonerado'
@Metadata.allowExtensions: true

define root view entity ZI_SD_CALCULO_DESONERADO
  as select from ztsd_cbenef
{
  key id                    as Id,
  key shipfrom              as ShipFrom,
  key shipto                as ShipTo,
  key auart                 as DocumentType,
  key augru                 as OrderReason,
  key matnr                 as MaterialNumber,
  key matkl                 as MaterialGroup,
  key bwart                 as MovementType,
      
      @EndUserText.label: 'CFOP'         
  key cfop                  as CfopExternal,
      @EndUserText.label: 'Situação tributária ICMS'
  key taxsit                as TaxSituation,
      cbenef                as BenefitCode,
      motdesicms            as ICMSExemption,
      @EndUserText.label: 'Tipo de Cálculo'      
      tipo_calc             as TypeCalc,
//      ststcl_vicmsdeson     as StatisticalExemptionICMS,
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt

}
