@AbapCatalog.sqlViewName: 'ZSDLOGSOLIC2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS tabela LOG'
define view ZI_SD_VERIF_DISP_LOG2
  as select distinct from ztsd_solic_log       as _solicLog2
    inner join            ZI_SD_VERIF_DISP_LOG as _solicLog on  _solicLog.DataSolic = _solicLog2.data_solic
                                                            and _solicLog.Material  = _solicLog2.material
                                                            and _solicLog.Centro    = _solicLog2.centro
                                                            and _solicLog.Acaolog   = _solicLog2.acaolog
{

  key _solicLog2.material          as Material,
  key _solicLog2.centro            as Centro,
  key _solicLog2.acaolog           as Acaolog,
      _solicLog2.data_solic        as DataSolic,
      _solicLog2.data_solic_logist as DataSolicLogist,
      _solicLog2.motivo_indisp     as MotivoIndisp,
      _solicLog2.acao              as Acao

}
