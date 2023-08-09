@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Limite Min. e Max.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_SUBSTITUIR_MIN_MAX
  as select from    I_SalesOrderItem as _salesItem
    inner join      I_SalesOrder     as _sales     on _sales.SalesOrder = _salesItem.SalesOrder
    left outer join a817             as _a817      on  _a817.kschl =  'ZPR0'
                                                   and _a817.vtweg =  _sales.DistributionChannel
                                                   and _a817.pltyp =  _sales.PriceListType
                                                   and _a817.werks =  _salesItem.Plant
                                                   and _a817.matnr =  _salesItem.Material
                                                   and _a817.datbi >= _salesItem.PricingDate
                                                   and _a817.datab <= _salesItem.PricingDate

    left outer join a816             as _a816      on  _a816.kschl =  'ZPR0'
                                                   and _a816.vtweg =  _sales.DistributionChannel
                                                   and _a816.werks =  _salesItem.Plant
                                                   and _a816.matnr =  _salesItem.Material
                                                   and _a816.datbi >= _salesItem.PricingDate
                                                   and _a816.datab <= _salesItem.PricingDate

    left outer join konp             as _Cond_a817 on  _Cond_a817.knumh    = _a817.knumh
                                                   and _Cond_a817.loevm_ko = ''

    left outer join konp             as _Cond_a816 on  _Cond_a816.knumh    = _a816.knumh
                                                   and _Cond_a816.loevm_ko = ''


{
  key _salesItem.SalesOrder,
  key _salesItem.SalesOrderItem,

      case
      when _Cond_a817.knumh is not initial
      then cast( _Cond_a817.mxwrt as abap.dec( 11, 2 ) )
      else cast( _Cond_a816.mxwrt as abap.dec( 11, 2 ) )
      end as ValorMin,

      case
      when _Cond_a817.knumh is not initial
      then cast( _Cond_a817.gkwrt as abap.dec( 11, 2 ) )
      else cast( _Cond_a816.gkwrt as abap.dec( 11, 2 ) )
      end as ValorMax

}
