@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de interface - Busca de campo Motorista'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_STATUS_MOTORISTA
  as select from vbpa
    inner join   lfb1 as _FornMasterEmp   on _FornMasterEmp.pernr = vbpa.pernr
    join         lfa1 as _FornMasterGeral on _FornMasterGeral.lifnr = _FornMasterEmp.lifnr
{
  key vbpa.vbeln,
      vbpa.pernr,
      _FornMasterGeral.name1
}
where
  vbpa.parvw = 'YM'
