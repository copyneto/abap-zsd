@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Dados faturamento para interface de ativos fluig'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_SD_INVOICEINFO_ATIVO_FLUIG
  as select from ser02          as OVSerie
    inner join   objk           as Obj_Manutencao on Obj_Manutencao.obknr = OVSerie.obknr
    inner join   vbfa           as FluxoDocSD     on  FluxoDocSD.vbelv   = OVSerie.sdaufnr
                                                  and FluxoDocSD.posnv   = OVSerie.posnr
                                                  and FluxoDocSD.vbtyp_n = 'M'
    inner join   vbrk           as Invoice        on Invoice.vbeln = FluxoDocSD.vbeln
    inner join   j_1bnflin      as NFItem         on  NFItem.refkey = Invoice.vbeln
    inner join   j_1bnfdoc      as NFHeader       on NFHeader.docnum = NFItem.docnum
    inner join   j_1bnfe_active as NFActive       on NFActive.docnum = NFHeader.docnum
{
  FluxoDocSD.vbelv     as OrdemVenda,
  FluxoDocSD.posnv     as OrdemVendaItem,
  NFHeader.nfenum      as Numero_NF,
  Obj_Manutencao.sernr as Numero_Serie,
  NFItem.matnr         as Material,
  NFItem.werks         as Centro,
  NFHeader.waerk       as Moeda,
  @Semantics.amount.currencyCode: 'Moeda'
  NFItem.netwr         as Valor_Liquido


}
where
      Invoice.fksto      = ''
  and FluxoDocSD.vbtyp_v = 'G'
//  and NFItem.itmnum      = '000010'
