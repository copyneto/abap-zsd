@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Itens Parcelas'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COMODATO_ITENS
  as select from fpla

    inner join   fplt on fplt.fplnr = fpla.fplnr
    inner join   vbap on  vbap.fplnr_ana = fplt.fplnr
                      and vbap.abgru     is initial

{
  key fpla.vbeln      as Contrato,
//  key fpla.fplnr      as Fplnr,
  key fplt.fpltr      as Parcela,
      fplt.waers      as Waers,
      @Semantics.amount.currencyCode: 'Waers'
      @EndUserText.label: 'Valor'
      sum(fplt.fakwr) as Fakwr
}
group by
//  fpla.fplnr,
  fpla.vbeln,
  fplt.fpltr,
  fplt.waers
