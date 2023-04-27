@AbapCatalog.sqlViewName: 'ZSDLOGSOLIC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS tabela LOG'
define view ZI_SD_VERIF_DISP_LOG
  as select from ztsd_solic_log
{

  key material          as Material,
  key centro            as Centro,
  key acaolog           as Acaolog,
  max( data_solic ) as DataSolic
//      data_solic_logist as DataSolicLogist,
//      motivo_indisp     as MotivoIndisp,
//      acao              as Acao
}
group by
  material,
  centro,
  acaolog
//  data_solic_logist,
//  motivo_indisp,
//  acao 
