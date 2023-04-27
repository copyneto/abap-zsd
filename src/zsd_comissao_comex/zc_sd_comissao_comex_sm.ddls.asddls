@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Simulador de corretagem'
@Metadata.allowExtensions: true
@VDM.viewType: #CONSUMPTION

define root view entity ZC_SD_COMISSAO_COMEX_SM
  as select from ZI_SD_COMISSAO_COMEX_PROV
{
  key Werks,
  key Docdat,
      //@Consumption.groupWithElement: 'Nfenum'
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
      @Semantics.amount.currencyCode:'Netwrt_cur'
      @Aggregation.default: #SUM
      Netwrt,
      Netwrt_cur,
      Zdatabl,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_SD_VH_COMEX_MES', element: 'Mes' } } ]
      Zperiodo,
      Zparid,
      Zname1,
      Xped,
      Kondm,
      @Aggregation.default: #SUM
      kwert,
      Zdataptax,
      Zptax,
      @Aggregation.default: #SUM
      Zajuste,
      @Aggregation.default: #SUM
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
