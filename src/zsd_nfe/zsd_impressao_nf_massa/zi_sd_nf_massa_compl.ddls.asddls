@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações comp. Download NF em Mass'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NF_MASSA_COMPL
  as select from vbfa             as _VBFA
    inner join   /scmtms/d_tordrf as _TorDrf on  _VBFA.vbelv     = right(
      _TorDrf.btd_id, 10
    )
                                             and _TorDrf.btd_tco = '73'
    inner join   /scmtms/d_torrot as _Torrot on  _Torrot.db_key  = _TorDrf.parent_key
                                             and _Torrot.tor_cat = 'TO'
  association [0..1] to ZI_TM_PLANO_CARGA as _Carga on  _Carga.DeliveryDocument       = _VBFA.vbelv
                                                    and _Carga.TransportationOrderKey = _Torrot.db_key
  //                                                    and _Torrot.tor_cat     = 'TO'
  //  association [0..1] to /scmtms/d_torrot as _Torrot on  _Torrot.base_btd_id = _VBFA.vbelv
  //                                                    and _Torrot.tor_cat     = 'TO'
{

  key _VBFA.vbeln                as Vbeln,
      //      _VBFA.vbelv    as Vbelv,
      right( _Torrot.tor_id, 10) as Tor_id,
      _Carga.StopOrder           as StopOrder

}
where
       _VBFA.vbtyp_v = 'J'

