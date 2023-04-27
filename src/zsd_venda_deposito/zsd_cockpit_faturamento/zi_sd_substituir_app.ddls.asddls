@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Substituir Produto'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_SUBSTITUIR_APP
  as select from    ZI_SD_VERIF_UTIL_APP     as _verif
    inner join      I_SalesOrder             as _sales           on _sales.SalesOrder = _verif.SalesOrder
    inner join      I_SalesOrderItem         as _salesI          on  _salesI.SalesOrder              =  _verif.SalesOrder
                                                                 and _salesI.SalesOrderItem          =  _verif.SalesOrderItem
                                                                 and _salesI.SalesDocumentRjcnReason =  ' '
                                                                 and (
                                                                    _salesI.SDProcessStatus          <> 'B'
                                                                    and _salesI.SDProcessStatus      <> 'C'
                                                                  )
    inner join      mara                     as _mara            on _mara.matnr = _verif.Material
    inner join      ZI_SD_EAN_MATERIAL       as _mean            on  _mean.ean11 =  _mara.ean11
                                                                 and _mean.werks =  _verif.Plant
                                                                 and _mean.matnr <> _mara.matnr

    left outer join mara                     as _mara_new        on _mara_new.matnr = _mean.matnr

    left outer join ZI_SD_CENTRO_FAT_DF      as _Centro_Fat_DF   on _Centro_Fat_DF.CentroFaturamento = _verif.Plant

    left outer join nsdm_e_mard              as _MaterialStock   on  _MaterialStock.matnr = _mean.matnr
                                                                 and _MaterialStock.werks = _mean.werks
                                                                 and _MaterialStock.lgort = _salesI.StorageLocation

    left outer join nsdm_e_mard              as _MaterialStockDf on  _MaterialStockDf.matnr = _mean.matnr
                                                                 and _MaterialStockDf.werks = _Centro_Fat_DF.CentroDepFechado
                                                                 and _MaterialStockDf.lgort = _salesI.StorageLocation

    left outer join ZI_SD_VERIF_DISP_ESTOQUE as _CheckStock      on  _CheckStock.Material        = _mean.matnr
                                                                 and _CheckStock.Plant           = _mean.werks
                                                                 and _CheckStock.StorageLocation = _salesI.StorageLocation

    left outer join a817                     as _a817            on  _a817.kschl =  'ZPR0'
                                                                 and _a817.vtweg =  _sales.DistributionChannel
                                                                 and _a817.pltyp =  _sales.PriceListType
                                                                 and _a817.werks =  _salesI.Plant
                                                                 and _a817.matnr =  _mean.matnr
                                                                 and _a817.datbi >= _sales.PricingDate
                                                                 and _a817.datab <= _sales.PricingDate

    left outer join a816                     as _a816            on  _a816.kschl =  'ZPR0'
                                                                 and _a816.vtweg =  _sales.DistributionChannel
                                                                 and _a816.werks =  _salesI.Plant
                                                                 and _a816.matnr =  _mean.matnr
                                                                 and _a816.datbi >= _sales.PricingDate
                                                                 and _a816.datab <= _sales.PricingDate

    left outer join konp                     as _Cond_a817       on  _Cond_a817.knumh    = _a817.knumh
                                                                 and _Cond_a817.loevm_ko = ''

    left outer join konp                     as _Cond_a816       on  _Cond_a816.knumh    = _a816.knumh
                                                                 and _Cond_a816.loevm_ko = ''

    left outer join tvak                     as _TipoOrdem       on _TipoOrdem.auart = _sales.SalesOrderType

  association to makt as _matx2 on  _matx2.matnr = $projection.MaterialAtual
                                and _matx2.spras = $session.system_language
  association to makt as _matx  on  _matx.matnr = $projection.Material
                                and _matx.spras = $session.system_language
  //  association to I_SalesOrderItem as _salesIt on  _salesIt.SalesOrder     = $projection.SalesOrder
  //                                              and _salesIt.SalesOrderItem = $projection.SalesOrderItem
{
  key   _verif.SalesOrder                 as SalesOrder,
  key   _verif.SalesOrderItem             as SalesOrderItem,
        @ObjectModel.text.element: ['DescriptionMaterial']
  key   _verif.Material                   as MaterialAtual,
        @ObjectModel.text.element: ['DescriptionMaterial']
  key   _mean.matnr                       as Material,
        @Semantics.quantity.unitOfMeasure : 'OrderUnit'
        _salesI.OrderQuantity             as OrderQuantity,
        _salesI.OrderQuantityUnit         as OrderUnit,
        _salesI.BaseUnit                  as OrderQuantityUnit,
        //        _salesI.OrderQuantityUnit         as OrderQuantityUnit,
        //        _salesIt.OrderQuantityUnit        as OrderQuantityUnit,
        _salesI.TargetToBaseQuantityNmrtr as Fator,
        _mara_new.meins                   as Unit,
        _mara.ean11                       as EAN,
        _verif.Plant                      as Plant,
        _matx.maktx                       as DescriptionMaterial,
        _matx2.maktx                      as DescriptionMaterial2,

        //        @Semantics.quantity.unitOfMeasure : 'Unit'
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_ESTOQUE_SUBSTITUIR'
        //        cast( 0 as mengv13 )              as EstoqueLivre,
        @Semantics.quantity.unitOfMeasure: 'Unit'
        _MaterialStock.labst              as EstoqueLivre,
        //        @Semantics.quantity.unitOfMeasure : 'Unit'
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_ESTOQUE_SUBSTITUIR'
        //        cast( 0 as mengv13 )              as EstoqueRemessa
        @Semantics.quantity.unitOfMeasure: 'Unit'
        _CheckStock.QtdRemessa            as EstoqueRemessa,
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_PRECO_SUBSTITUIR'
        //        cast( '' as konwa )               as Moeda,
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_PRECO_SUBSTITUIR'
        //        cast( 0 as kpein )                as UnitPreco,
        //        @Semantics.amount.currencyCode : 'Moeda'
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_PRECO_SUBSTITUIR'
        //        cast( 0 as kbetr_kond )           as Preco,
        //        @ObjectModel.virtualElement: true
        //        @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_PRECO_SUBSTITUIR'
        //        cast( '' as kmein )               as UmPreco
        _TipoOrdem.kalvg                  as ClasseDoc,

        case
        when _TipoOrdem.kalvg = 'M'
        then ''
        else
        case
        when _Cond_a817.knumh is not initial
        then _Cond_a817.konwa
        else _Cond_a816.konwa
        end
        end                               as Moeda,

        case
        when _TipoOrdem.kalvg = 'M'
        then 0
        else
        case
        when _Cond_a817.knumh is not initial
        then _Cond_a817.kpein
        else _Cond_a816.kpein
        end
        end                               as UnitPreco,

        case
        when _TipoOrdem.kalvg = 'M'
        then cast( 0 as abap.dec( 11, 2 ) )
        else
        case
        when _Cond_a817.knumh is not initial
        then cast( _Cond_a817.kbetr as abap.dec( 11, 2 ) )
        else cast( _Cond_a816.kbetr as abap.dec( 11, 2 ) )
        end
        end                               as Preco,

        case
        when _TipoOrdem.kalvg = 'M'
        then ''
        else
        case
        when _Cond_a817.knumh is not initial
        then _Cond_a817.kmein
        else _Cond_a816.kmein
        end
        end                               as UmPreco

}
where
  _MaterialStock.labst is not initial
