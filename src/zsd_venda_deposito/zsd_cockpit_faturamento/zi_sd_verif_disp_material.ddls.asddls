@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Material'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_VERIF_DISP_MATERIAL
//  as select from I_SalesOrderItem as _SalesOrderItem
//  as select from vbap as _vbap
  as select from vbap as _vbap
    inner join   marc             as _marc on  _marc.matnr = _vbap.matnr
                                           and _marc.werks = _vbap.werks
  association to makt                    as _makt     on  _makt.matnr = $projection.Material
                                                      and _makt.spras = $session.system_language
  association to ztsd_solic_log          as _solicLog on  _solicLog.material = $projection.Material
                                                      and _solicLog.centro   = $projection.Plant
//  association to ZC_SD_VERIF_DISP_FIELDS as _fields   on  _fields.SalesOrder = $projection.SalesOrder
{
  key _vbap.vbeln as SalesOrder,
  key _vbap.matnr as Material,
  key _vbap.werks as Plant,
  

      _makt.maktx    as Descricao,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01 )      as QtdOrdem,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdRemessa,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdEstoqueLivre,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as Saldo,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as QtdDepositoFechado,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      cast( 0 as mng01  )     as CalcDisponibilidade,

      cast( ''  as vrkme ) as OrderQuantityUnit,

      _vbap.lgort as StorageLocation,

      _solicLog.acao as acaoNecessaria,
      _solicLog.motivo_indisp,
      _solicLog.data_solic,

      case _solicLog.acaolog
         when 'X' then 'Sim'
         else 'Não'
      end            as acaoLogistica


}
group by
_vbap.vbeln,
_vbap.matnr,
_vbap.werks,
_vbap.vrkme,
_vbap.lgort,
  _makt.maktx,
  _solicLog.acao,
  _solicLog.motivo_indisp,
  _solicLog.data_solic,
  _solicLog.acaolog
