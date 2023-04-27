@AbapCatalog.sqlViewName: 'ZVSD_MAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Material'
define view ZI_SD_VERIF_DISP_MATERIAL2
  //  as select distinct from vbap                 as _vbap

  //  left outer join mard as _mard    on  _mard.matnr = _vbap.matnr
  //                                   and _mard.werks   = _vbap.werks
  

  as select distinct from mard                as _mard

    left outer join       vbap                as _vbap     on  _mard.matnr = _vbap.matnr
                                                           and _mard.werks = _vbap.werks
  //                                                      and _solicLog.ordem    = _vbap.vbeln

  //    inner join            ZI_SD_VERIF_DISP_LOG as _solicLog  on  _solicLog.Material = _vbap.matnr
  //                                                             and _solicLog.Centro   = _vbap.werks
  //    inner join            ztsd_solic_log       as _solicLog2 on  _solicLog.DataSolic = _solicLog2.data_solic
  //                                                             and _solicLog.Material  = _solicLog2.material
  //                                                             and _solicLog.Centro    = _solicLog2.centro
  //                                                             and _solicLog.Acaolog   = _solicLog2.acaolog
    left outer join       ZI_SD_TF_VERIF_DISP as _solicLog on  _solicLog.material = _mard.matnr
                                                           and _solicLog.centro   = _mard.werks



    inner join            marc                as _marc     on  _marc.matnr = _mard.matnr
                                                           and _marc.werks = _mard.werks
  association to makt as _makt on  _makt.matnr = _mard.matnr
                               and _makt.spras = $session.system_language
  association to mara as _mara on  _mara.matnr = _mard.matnr
  //  association [0..*] to ztmm_prm_dep_fec as _DepFec on  origin_plant_type  = '01'
  //                                                    and destiny_plant      = _mard.werks
  //                                                    and destiny_plant_type = '02'

  //  association to ztsd_solic_log   as _solicLog on  _solicLog.material = $projection.Material
  //                                               and _solicLog.centro   = $projection.Plant
  //                                               and _solicLog.ordem    = _vbap.vbeln
  //  association to ZC_SD_VERIF_DISP_FIELDS as _fields   on  _fields.SalesOrder = $projection.SalesOrder
{
       //  key _vbap.vbeln as SalesOrder,
       //  key vbap.matnr  as Material,
       //  key _vbap.werks  as Plant,
  key  _mard.matnr                   as Material,
  key  _mard.werks                   as Plant,

  key  case
    when _mard.lgort is null
    then  _vbap.lgort
    else _mard.lgort
    end                              as Deposito,
       //      _vbap.vbeln,
       _makt.maktx                   as Descricao,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01 )            as QtdOrdem,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01  )           as QtdRemessa,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01  )           as QtdEstoqueLivre,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01  )           as Saldo,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01  )           as QtdDepositoFechado,

       @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
       cast( 0 as mng01  )           as CalcDisponibilidade,

       _mara.meins                   as OrderQuantityUnit,
       //      cast( ''  as vrkme )          as OrderQuantityUnit,

       //      cast( '' as abap.char(4) )    as StorageLocation,
       //       _DepFec.origin_plant          as StorageLocation,

       cast( '' as abap.char( 12 ) ) as Status,

       _solicLog.acao                as acaoNecessaria,
       _solicLog.motivo_indisp,
       _solicLog.data_solic_logist   as data_solic_logist,
       //      _solicLog.data_solic,

       max(_solicLog.data_solic)     as data_solic,
       //      case _solicLog.acaolog
       //         when 'X' then 'Sim'
       //         else 'Não'
       //      end                           as acaoLogistica
       case
          when (_solicLog.acaolog = 'X' and _solicLog.data_solic = $session.system_date ) then 'Sim'
          else 'Não'
       end                           as acaoLogistica


}
where
  _mard.lgort is not null
group by
//_vbap.vbeln,
  _mard.matnr,
  _mard.werks,
  _mard.lgort,
  _vbap.matnr,
  _vbap.werks,
  _vbap.lgort,
  //  _vbap.vrkme,
  //  _vbap.lgort,
  _makt.maktx,
  _mara.meins,
  //  _DepFec.origin_plant,
  _solicLog.acao,
  _solicLog.motivo_indisp,
  _solicLog.data_solic,
  _solicLog.data_solic_logist,
  _solicLog.acaolog
