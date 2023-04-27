@EndUserText.label: 'CDS Table function'
define table function ZI_SD_TF_VERIF_DISP
returns
{
  client            : abap.clnt;
  data_solic        : abap.dats;
  material          : matnr;
  centro            : werks_d;
  acaolog           : flag;
  data_solic_logist : ze_sd_date;
  motivo_indisp     : ze_motivo_indisp;
  acao              : ze_acao;
}
implemented by method
  zclsd_verifica_disponibilidade=>check;
