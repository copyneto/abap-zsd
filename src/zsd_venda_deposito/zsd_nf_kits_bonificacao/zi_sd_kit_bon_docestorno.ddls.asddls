@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Seleciona documento Estorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_DOCESTORNO
  as select from matdoc               as _DocEstorno
    inner join   ZI_SD_KIT_BON_TP_MOV as _TpMov on  _TpMov.TpMov  = _DocEstorno.bwart
                                                and _TpMov.chave3 = 'ESTORNO'
{
  key _DocEstorno.mblnr as DocEstorno,
  key _DocEstorno.zeile,
      _DocEstorno.smbln,
      _DocEstorno.matnr
}
  // Foi solicitado selecionar a tabela mseg, mas com o HANA 
  //algumas tabelas são combinadas em novas tabelas, nesse caso a matdoc 
