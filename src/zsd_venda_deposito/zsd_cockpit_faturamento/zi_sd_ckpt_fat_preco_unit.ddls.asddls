@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor mínimo OV'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PRECO_UNIT
  as select from ZI_SD_CKPT_FAT_OV_PRECO as _SalesOrder
  //  as select from I_SalesOrder     as _SalesOrder
  //    inner join   I_SalesOrderItem as _Item  on _Item.SalesOrder       =  _SalesOrder.SalesOrder
  //                                            and(
  //                                              _Item.OrderQuantity     is not null
  //                                              and _Item.OrderQuantity <> 0
  //                                            )

    inner join   ZI_SD_CKPT_FAT_PRECO    as _Preco on  _Preco.knumv = _SalesOrder.SalesOrderCondition
                                                   and _Preco.kposn = _SalesOrder.SalesOrderItem

  //    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO',
  //                                            p_chave2 : 'KSCHL_MINIMO_COMPARA') as _Param on  _Param.modulo = 'SD'
  //                                                                                         and _Param.chave1 = 'ADM_FATURAMENTO'
  //                                                                                         and _Param.chave2 = 'KSCHL_MINIMO_COMPARA'
  //                                                                                         and _Param.chave3 = ''
  //
  //    inner join   prcd_elements                                                 as _Preco on  _Preco.knumv = _SalesOrder.SalesOrderCondition
  //                                                                                         and _Preco.kposn = _Item.SalesOrderItem
  //                                                                                         and _Preco.kschl = _Param.parametro
{

       //  key  _Item.SalesOrder,
       //  key  _Item.SalesOrderItem,
  key  _SalesOrder.SalesOrder,
  key  _SalesOrder.SalesOrderItem,
       _Preco.knumv                                                                                                  as SalesOrderCondition,
       _Preco.waerk,
       //       @Semantics.amount.currencyCode : 'waerk'

       //       case when _Item.OrderQuantity is not null and _Item.OrderQuantity <> 0 then
       //       div( cast(_Preco.kwert as abap.dec( 15, 2 )), cast( _Item.OrderQuantity as abap.dec( 15, 3 )) ) as PrecoUnit
       //       else 0
       //       end          as PrecoUnit


       //cast( cast(_Preco.kwert as abap.dec( 15, 2 )) / cast( _SalesOrder.OrderQuantity as abap.dec( 15, 3 )) as abap.dec( 15, 2 )) as teste,
       DIVISION( cast(_Preco.kwert as abap.dec( 15, 2 )), cast( _SalesOrder.OrderQuantity as abap.dec( 15, 3 )), 3 ) as PrecoUnit
       

}
