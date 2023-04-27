@EndUserText.label: 'Materiais - Projection'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@Search.searchable: true
define view entity ZC_SD_02_ITEM
  as projection on ZI_SD_02_ITEM
{
      @EndUserText.label      : 'Guid'
  key Guid,
      @EndUserText.label      : 'Material'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.8
      @Search.ranking : #HIGH
  key Material,
      @Semantics.unitOfMeasure: true
  key MaterialBaseUnit,
      @EndUserText.label      : 'Descrição'
      @Search.defaultSearchElement : true
      @Search.fuzzinessThreshold : 0.7
      @Search.ranking : #LOW
      MaterialName,
      @EndUserText.label      : 'UM'
      MatlWrhsStkQtyInMatlBaseUnit,
      @EndUserText.label      : 'Quantidade solicitada'
      QtdSol,
      @EndUserText.label      : 'Quantidade Preenchida'
      Selected,
      /* Associations */
      _cockpit : redirected to parent ZC_SD_01_COCKPIT

}
