@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit gerenciamento de remessas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}

define view entity ZI_SD_REMESSA_INFO_ORDEM_FRETE
  as select from /scmtms/d_torrot as _FreightOrder
    inner join   /scmtms/d_torite as _Entrega on  _Entrega.parent_key   = _FreightOrder.db_key
                                              and _Entrega.base_btd_tco = '73' -- Remessa

{
  key cast( substring( _Entrega.base_btd_id, 26, 10) as vbeln_vl ) as DeliveryDocument,
      max( _FreightOrder.tor_id )                                  as FreightOrder,
      max( _FreightOrder.created_on )                              as CreatedOn
      //      _FreightOrder.labeltxt                                       as FreightOrderLabelTxt,
      //      substring( cast(_FreightOrder.created_on as abap.char(29)), 1,8)  as CreatedOnDat

}
where
      _FreightOrder.tor_id    is not initial
  and _FreightOrder.tor_cat   =  'TO' -- Ordem de frete
  and _FreightOrder.lifecycle <> '10'

group by
  _Entrega.base_btd_id
//  _FreightOrder.tor_id,
//  _FreightOrder.labeltxt,
//  _FreightOrder.created_on
