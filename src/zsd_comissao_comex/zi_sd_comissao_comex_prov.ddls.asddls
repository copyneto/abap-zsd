@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interace Simulador corretagem'

define root view entity ZI_SD_COMISSAO_COMEX_PROV
  as select from ztsd_comiss_cmx

  //left outer join I_BR_NFItemDocumentFlowFirst_C as _NFDocumentFlow on _NFDocumentFlow.ReferenceDocument = Comex.refkey

  association [0..1] to vbak as _OrdemVenda on _OrdemVenda.vbeln = $projection.Aubel

{
  key werks                      as Werks,
  key docdat                     as Docdat,
  key nfenum                     as Nfenum,
  key itmnum                     as Itmnum,
  key posneg                     as Posneg,
      matnr                      as Matnr,
      aubel                      as Aubel,
      refkey                     as Refkey,
      parid                      as Parid,
      name1                      as Name1,
      regio                      as Regio,
      @Semantics.quantity.unitOfMeasure:'gewei'
      ntgew                      as Ntgew,
      gewei                      as Gewei,
      @Semantics.amount.currencyCode:'netwrt_cur'
      //@DefaultAggregation: #SUM
      netwrt                     as Netwrt,
      netwrt_cur                 as Netwrt_cur,
      zdatabl                    as Zdatabl,
      zperiodo                   as Zperiodo,
      zparid                     as Zparid,
      zname1                     as Zname1,
      xped                       as Xped,
      kondm                      as Kondm,
      @Semantics.amount.currencyCode:'netwrt_cur'
      kwert,
      zdataptax                  as Zdataptax,
      zptax                      as Zptax,
      @Semantics.amount.currencyCode:'netwrt_cur'
      zajuste                    as Zajuste,
      @Semantics.amount.currencyCode:'netwrt_cur'
      zvalor                     as Zvalor,
      zstatus                    as Zstatus,

      case when zstatus is initial
      then 0 -- Apurar
      else 3 -- Apurado
      end                        as StatusCriticality,

      case when zstatus is initial
      then 'Apurar'
      else 'Apurado'
      end                        as StatusText,

      prov                       as Prov,

      zobs                       as Zobs,

      @Semantics.user.createdBy: true
      created_by                 as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_at                 as CreatedAt,
      @Semantics.user.lastChangedBy: true
      last_changed_by            as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at            as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at      as LocalLastChangedAt,

      _OrdemVenda.zz1_dataem_sdh as DataEmbarque

}
