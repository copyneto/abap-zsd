@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS de interface - Busca endereço'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_FI_STATUS_CUST_ADDR
  //  as select from vbak
  //    inner join   ZI_SD_STATUS_CUST as _StatusCust on _StatusCust.SDDocument = vbak.vbeln

  as select from kna1 //  as _CustMaster on _CustMaster.kunnr = _StatusCust.Customer

  association to adrc as _AddressMaster on _AddressMaster.addrnumber = kna1.adrnr

{

  key kunnr,
      //  key vbak.vbeln,
      _AddressMaster.post_code1 as CEP,
      _AddressMaster.taxjurcode as DomFiscal

}
