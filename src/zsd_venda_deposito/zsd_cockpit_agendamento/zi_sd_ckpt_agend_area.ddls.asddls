@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS VALIDA AREA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEND_AREA
  //  as select from I_CustomerSalesArea                                     as _Cust
  as select from I_SalesOrder                                         as _Cust
    inner join   ZI_SD_CKPT_AGEN_PARAM (  p_modulo: 'SD',
                                          p_chave1 : 'ADM_AGENDAMENTO',
                                          p_chave2 : 'TIPO_DE_CARGA') as _Param on _Param.parametro = _Cust.AdditionalCustomerGroup1
{
  key _Cust.SalesOrder,
      _Cust.AdditionalCustomerGroup1
}
