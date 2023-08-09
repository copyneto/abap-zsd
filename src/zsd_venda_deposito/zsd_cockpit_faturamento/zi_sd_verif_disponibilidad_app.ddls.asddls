@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Verifica Disponibilidade'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #C,
  sizeCategory: #L,
  dataClass: #MIXED
}
define view entity zi_sd_verif_disponibilidad_app
  as select from zi_sd_verif_disponibilidade
  association [1] to mara            as _mara   on  _mara.matnr = $projection.Material
  association [1] to makt            as _makt   on  _makt.matnr = $projection.Material
                                                and _makt.spras = $session.system_language
  association [1] to ZI_SD_VH_MOTIVO as _motivo on  _motivo.Movito = $projection.motivoIndisp
  association [1] to ZI_SD_VH_ACAO   as _acao   on  _acao.Acao = $projection.acaoNecessaria

{
  key Material,
  key Plant,
  key Deposito,
      CentroDepFechado,
      motivoIndisp,
      acaoNecessaria,

      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdEstoqueLivre             as QtdEstoqueLivre,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdDepositoFechado          as QtdDepositoFechado,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdRemessa                  as QtdRemessa,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      QtdOrdem                    as QtdOrdem,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      Saldo                       as Saldo,

      _mara.meins                 as OrderQuantityUnit,
      _makt.maktx                 as Descricao,

      _motivo.MotivoText          as MotivoText,
      _acao.AcaoText              as AcaoText,

      _solicLog.acaoLogistica     as acaoLogistica,
      _solicLog.data_solic_logist as data_solic_logist,
      _solicLog.data_solic        as dataSolic,

      case
      when Saldo > 0
      then cast( '0' as ze_status_estoque ) //Disponível
      else cast( '1' as ze_status_estoque ) //Indisponível
      end                         as Status,

      case
      when Saldo > 0
      then 'Disponível'
      else 'Indisponível'
      end                         as StatusDesc,

      case
      when Saldo > 0
      then 3
      else 1
      end                         as ColorStatus,

      case
      when _solicLog.acaoLogistica = 'X'
      then 3 --Verde
      else 1 --Vermelho
      end                         as ColorAcaoLogistica

}
