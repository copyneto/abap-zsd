@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Verifica Disponibilidade Log'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity zi_sd_verif_dispon_log
  as select from zi_sd_verif_disp_max_dat_logis as _maxDatLogis
{
  key material,
  key centro,
      motivo_indisp,
      acao,
      cast( data_solic_logist as timestamp ) as data_solic_logist,
      data_solic,
      cast (
       case
          when (
          acaolog = 'X' and
          data_solic = $session.system_date )
          then 'X'
          else ''
       end  as boole_d preserving type )     as acaoLogistica
}
