@AbapCatalog.sqlViewName: 'ZSD_EGTEMB'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Interface EGT'
define view ZI_EGT_EMB_DUE
  as select from    /xeit/tgteshpfat
    left outer join /xeit/tgteshk_n on /xeit/tgteshpfat.sbeln = /xeit/tgteshk_n.sbeln
    left outer join /xeit/tgteduek  on /xeit/tgteshk_n.sbeln = /xeit/tgteduek.sbeln
    left outer join /xeit/tgteduep  on /xeit/tgteduek.dueid = /xeit/tgteduep.dueid
    left outer join /xeit/tgteprd   on  /xeit/tgteshk_n.sbeln = /xeit/tgteprd.sbeln
                                    and /xeit/tgteprd.parvw   = 'AR'
    left outer join /xeit/tgteshp_n on /xeit/tgteshpfat.sbeln = /xeit/tgteshp_n.sbeln
                                    and /xeit/tgteshpfat.sbelp = /xeit/tgteshp_n.sbelp                                    
  association [0..1] to ZI_SD_PORTO_TEXT_VH as _Embarque on  /xeit/tgteshk_n.zollao = _Embarque.Zolla
                                                         and _Embarque.Land1        = 'BR'
                                                         and _Embarque.Spras        = $session.system_language
  association [0..1] to ZI_SD_PORTO_TEXT_VH as _Destino  on  /xeit/tgteshk_n.zollad = _Destino.Zolla
                                                         and _Destino.Land1       = /xeit/tgteshk_n.zlandd
                                                         and _Destino.Spras       = $session.system_language
  association [1] to I_BusinessPartner as _BusinessPartner on /xeit/tgteprd.parid = _BusinessPartner.BusinessPartner                                                       
{
  key /xeit/tgteduep.dueid      as Dueid,
      /xeit/tgteshpfat.vbeln_vf as DocFaturamento,
      /xeit/tgteshpfat.posnr_vf as ItemDocFaturamento,
      /xeit/tgteshk_n.sbeln     as DocEmbExportacao,
      /xeit/tgteshp_n.dtaverb   as DataAverbacao,
      
      //@ObjectModel.text.association: '_Embarque'
      /xeit/tgteshk_n.zollao    as PstAlfanOrig,
      _Embarque.Bezei           as DescPstAlfanOrig,
            
      /xeit/tgteshk_n.zollad    as PstAlfanDest,
      _Destino.Bezei            as DescPstAlfanDest,
      
      /xeit/tgteshk_n.zlandd    as PaisDestino,
      /xeit/tgteshk_n.blnmb     as BLN,
            
      /xeit/tgteprd.parid       as ArmadorBLNum, 
      _BusinessPartner.BusinessPartnerFullName as DescArmadorBLNum,
      
      /xeit/tgteduep.duenum     as NumeroDUE,
      /xeit/tgteduep.duekey     as ChvAcessoDUE,
      /xeit/tgteduep.dtreg      as DataRegistro    
}
group by
  /xeit/tgteduep.dueid,
  /xeit/tgteshpfat.vbeln_vf,
  /xeit/tgteshpfat.posnr_vf,
  /xeit/tgteshk_n.sbeln,
  /xeit/tgteshp_n.dtaverb,
  /xeit/tgteshk_n.zollao,
  /xeit/tgteshk_n.zollad,
  /xeit/tgteshk_n.zlandd,
  /xeit/tgteshk_n.blnmb,
  /xeit/tgteprd.parid,
  _BusinessPartner.BusinessPartnerFullName,
  /xeit/tgteduep.duenum,
  /xeit/tgteduep.duekey,
  /xeit/tgteduep.dtreg,
  _Embarque.Bezei,
  _Destino.Bezei
