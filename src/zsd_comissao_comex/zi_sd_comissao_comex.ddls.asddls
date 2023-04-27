@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interace controle de comissão COMEX'
@VDM.viewType: #BASIC

define root view entity ZI_SD_COMISSAO_COMEX
  as select from ztsd_comiss_cmx
{

  key werks         as Werks,
  key docdat        as Docdat,
  key nfenum        as Nfenum,
  key itmnum        as Itmnum,
  key posneg        as Posneg,
      matnr         as Matnr,
      aubel         as Aubel,
      refkey        as Refkey,
      parid         as Parid,
      name1         as Name1,
      regio         as Regio,
      @Semantics.quantity.unitOfMeasure:'gewei'
      ntgew         as Ntgew,
      gewei         as Gewei,
      @Semantics.amount.currencyCode:'netwrt_cur'
      netwrt        as Netwrt, 
      netwrt_cur    as Netwrt_cur,
      zdatabl       as Zdatabl,
      zperiodo      as Zperiodo,
      zparid        as Zparid,
      zname1        as Zname1,
      xped          as Xped,
      kondm         as Kondm,
      @Semantics.amount.currencyCode:'netwrt_cur'
      kwert,
      zdataptax     as Zdataptax,
      zptax         as Zptax,
      @Semantics.amount.currencyCode:'netwrt_cur'
      zajuste       as Zajuste,
      @Semantics.amount.currencyCode:'netwrt_cur'
      zvalor        as Zvalor,
      zstatus       as Zstatus,
      prov          as Prov,
      zobs          as Zobs,
      
      @Semantics.user.createdBy: true
      created_by            as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at            as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by       as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt

}
