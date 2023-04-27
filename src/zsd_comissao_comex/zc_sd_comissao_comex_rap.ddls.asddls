@EndUserText.label: 'Controle comissão para COMEX'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define root view entity ZC_SD_COMISSAO_COMEX_RAP
  as projection on ZI_SD_COMISSAO_COMEX
{
  key Werks,
  key Docdat,
  key Nfenum,
  key Itmnum,
  key Posneg,
      Matnr,
      Aubel,
      Refkey,
      Parid,
      Name1,
      Regio,
      Ntgew,
      Gewei,
      Netwrt,
      Netwrt_cur,
      Zdatabl,
      Zperiodo,
      Zparid,
      Zname1,
      Xped,
      Kondm,
      kwert,
      Zdataptax,
      Zptax,
      Zajuste,
      Zvalor,
      Zstatus,
      Prov,
      Zobs,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt
}
