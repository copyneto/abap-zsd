@AbapCatalog.sqlViewName: 'ZVSD_MATCOST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Custo do material por período'
define view ZI_SD_REL_FISCAL_SAIDA_MBEW
  as select from Mbv_Mbew
{
  matnr,
  bwkey,
  bwtar,
  lfgja,
  lfmon,
  case
    when verpr = 0 or verpr is null
      then cast( stprs as logbr_invoicenetamount)
      else cast( verpr as logbr_invoicenetamount)
    end as PrecoCustoUnitario
}
//where
//      matnr = $parameters.p_material
//  and bwkey = $parameters.p_area_avaliacao
//  and bwtar = $parameters.p_tipo_avaliacao
//  and lfgja = substring($parameters.p_data, 1, 4)
//  and lfmon = substring($parameters.p_data, 5, 2)

union select from Mbv_Mbewh
{
  matnr,
  bwkey,
  bwtar,
  lfgja,
  lfmon,
  case
    when verpr = 0 or verpr is null
      then cast( stprs as logbr_invoicenetamount)
      else cast( verpr as logbr_invoicenetamount)
    end as PrecoCustoUnitario
}
//where
//      matnr = $parameters.p_material
//  and bwkey = $parameters.p_area_avaliacao
//  and bwtar = $parameters.p_tipo_avaliacao
//  and lfgja = substring($parameters.p_data, 1, 4)
//  and lfmon = substring($parameters.p_data, 5, 2);
