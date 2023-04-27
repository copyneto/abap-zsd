@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Simulador de corretagem'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define root view entity ZC_SD_COMISSAO_COMEX_PROV
  as projection on ZI_SD_COMISSAO_COMEX_PROV
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
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_COMEX_MES', element: 'Mes' } } ]
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
      @ObjectModel.text.element: ['StatusText']
      //@Consumption.valueHelpDefinition: [{entity: {name: 'ZI_SD_VH_STATUS_AP', element: 'DomvalueL' }}]
      Zstatus,
      StatusCriticality,
      StatusText,
      Prov,
      Zobs,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      DataEmbarque
}
