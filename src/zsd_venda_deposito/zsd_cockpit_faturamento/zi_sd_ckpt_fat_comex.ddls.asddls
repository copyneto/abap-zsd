@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status de liberação da área de comércio exterior'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_COMEX
  as select from I_SalesOrder                                                                      as _salesorder
    inner join   ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_FATURAMENTO', p_chave2 : 'BLOQ_COMEX') as _param on _param.parametro = _salesorder.SalesOrderApprovalReason

  association to dd07t as _StatusLiberacaoOV on  _StatusLiberacaoOV.domvalue_l = _salesorder.SalesDocApprovalStatus
                                             and _StatusLiberacaoOV.ddlanguage = $session.system_language
                                             and _StatusLiberacaoOV.domname    = 'SD_APM_APPROVAL_STATUS'
{

  key _salesorder.SalesOrder,
      _salesorder.DeliveryBlockReason,

      case
        when _salesorder.SalesDocApprovalStatus = 'A' then 2 --Yellow
        when _salesorder.SalesDocApprovalStatus = 'B' then 3 --Green
        when _salesorder.SalesDocApprovalStatus = 'C' then 1 --Red
        else 0
      end                           as ColorStatusDeliveryBlockReason,

      case
       when _StatusLiberacaoOV.domvalue_l <> ''
       then _StatusLiberacaoOV.ddtext
       else ''
      end                           as StatusDeliveryBlockReasonText,

      _StatusLiberacaoOV.domvalue_l as StatusDeliveryBlockReasonCode
}
