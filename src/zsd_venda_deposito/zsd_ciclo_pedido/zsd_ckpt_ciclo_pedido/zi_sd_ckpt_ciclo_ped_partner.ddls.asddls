@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Parceiro'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_CICLO_PED_PARTNER
  as select from I_SalesOrderPartner                                                                  as _partner
    inner join   ZI_SD_CKPT_CLICO_PEDIDO_PARAM(p_chave1 : 'ADM_faturamento', p_chave2 : 'PARVW_VEND') as _param on _param.parametro = _partner.PartnerFunction
{
  key _partner.SalesOrder,
  key cast(  _partner.PartnerFunction as abap.char(2) ) as PartnerFunction,
      _partner.Personnel

}
