@AbapCatalog.sqlViewName: 'ZVSD_INF_DIST'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Contratos - Informações Distrato'
define view ZI_SD_INF_DISTRATO_CTR
  as select from           I_SalesContractItem       as Contrato

    join                   I_SalesContract           as ContratoHeader on Contrato.SalesContract = ContratoHeader.SalesContract

    left outer to one join I_SalesDocumentItem       as Ordem          on  Ordem.ReferenceSDDocument     = Contrato.SalesContract
                                                                       and Ordem.ReferenceSDDocumentItem = Contrato.SalesContractItem

    left outer to one join I_BillingDocumentItem     as Fatura         on  Fatura.SalesDocument     = Ordem.SalesDocument
                                                                       and Fatura.SalesDocumentItem = Ordem.SalesDocumentItem

    left outer join        I_BR_NFItem               as NFItem         on  NFItem.BR_NFSourceDocumentType   = 'BI'
                                                                       and NFItem.BR_NFSourceDocumentNumber = Fatura.BillingDocument
                                                                       and NFItem.BR_NFSourceDocumentItem   = Fatura.BillingDocumentItem

    left outer join        I_BR_NFDocument           as NF             on NF.BR_NotaFiscal = NFItem.BR_NotaFiscal


    left outer join        vbfa                      as _FlowDoc       on  Contrato.SalesContract     = _FlowDoc.vbelv
                                                                       and Contrato.SalesContractItem = _FlowDoc.posnv
                                                                       and _FlowDoc.vbtyp_n           = 'T'

    left outer join        vbfa                      as _FlowDocFat    on  Contrato.SalesContract     = _FlowDocFat.vbelv
                                                                       and Contrato.SalesContractItem = _FlowDocFat.posnv
                                                                       and _FlowDocFat.vbtyp_n        = 'O'

  //left outer join        ZI_SD_COCKPIT_FRE     as Frete     on Frete.Remessa = Fatura.ReferenceSDDocument
    left outer join        ZI_SD_COCKPIT_FRE         as Frete          on Frete.Remessa = _FlowDoc.vbeln

  //left outer to one join ser01                           on ser01.lief_nr = Contrato.ReferenceSDDocument

  //left outer to one join objk                            on objk.obknr = ser01.obknr

    left outer join        vbfa                      as _DistrC        on  _DistrC.vbelv   = Contrato.SalesContract
                                                                       and _DistrC.posnv   = Contrato.SalesContractItem
                                                                       and _DistrC.vbtyp_n = 'C'

    left outer join        vbap                      as _VbapC         on  _VbapC.vbeln = _DistrC.vbeln
                                                                       and _VbapC.posnr = Contrato.SalesContractItem

  //    left outer join        vbfa                  as _DistrH   on  _DistrH.vbelv   = _DistrC.vbeln
  //                                                              and _DistrH.posnv   = _DistrC.posnn
  //                                                              and _DistrH.vbtyp_n = 'H'

  //    left outer to one join vbfa                  as _DistrHCarg   on  _DistrHCarg.vbelv   = Contrato.SalesContract
  //                                                                  and _DistrHCarg.posnv   = Contrato.SalesContractItem
  //                                                                  and _DistrHCarg.vbtyp_n = 'H'

    left outer join        vbfa                      as _Remes         on  _Remes.vbelv   = _DistrC.vbeln
                                                                       and _Remes.posnv   = _DistrC.posnn
                                                                       and _Remes.vbtyp_n = 'T'

  //    left outer join        vbak                  as _Vbak     on _Vbak.vbeln = _DistrH.vbeln

  //    left outer join        vbkd                  as _Vbkd     on  _Vbkd.vbeln = _DistrH.vbeln
  //                                                              and _Vbkd.posnr = _DistrH.posnn

  //    left outer join        vbkd                  as _VbkdCarg on  _VbkdCarg.vbeln = _DistrHCarg.vbelv
  //                                                              and _VbkdCarg.posnr = _DistrHCarg.posnv

    left outer join        ser02                     as _Ser02         on  _Ser02.sdaufnr = Contrato.SalesContract
                                                                       and _Ser02.posnr   = Contrato.SalesContractItem

    left outer join        objk                      as _Objk          on _Objk.obknr = _Ser02.obknr
    left outer join        eqkt                      as _Eqkt          on  _Eqkt.equnr = _Objk.equnr
                                                                       and _Eqkt.spras = 'P'

    left outer join        ZI_SD_INF_DISTRATO_CTR_NF as _objnf         on _Objk.sernr = _objnf.Serie

  //    left outer join        ser01                 as _Ser01    on  _Ser01.lief_nr = _Remes.vbeln
  //                                                              and _Ser01.posnr   = _Remes.posnn

  //    left outer join        objk                  as _Objk     on _Objk.obknr = _Ser01.obknr

  //    left outer join        vbfa                  as _NFRet    on  _NFRet.vbelv   = _DistrC.vbeln
  //                                                              and _NFRet.vbtyp_n = 'O'

    left outer join        vbfa                      as _VBFARetH      on  _VBFARetH.vbelv   = Contrato.SalesContract
                                                                       and _VBFARetH.posnv   = Contrato.SalesContractItem
                                                                       and _VBFARetH.vbtyp_n = 'H'

    left outer join        vbfa                      as _VBFARetM      on  _VBFARetM.vbelv   = Contrato.SalesContract
                                                                       and _VBFARetM.posnv   = Contrato.SalesContractItem
                                                                       and _VBFARetM.vbtyp_n = 'O'

    left outer join        j_1bnflin                 as _NFLin         on _NFLin.refkey = _VBFARetM.vbeln

    left outer join        j_1bnfdoc                 as _NFDoc         on _NFDoc.docnum = _NFLin.docnum

    left outer join        vbkd                      as _Vbkd          on  _Vbkd.vbeln = Contrato.SalesContract
                                                                       and _Vbkd.posnr = Contrato.SalesContractItem

{

  key Contrato.SalesContract as Contrato,
  key SalesContractItem      as ContratoItem,
      //Contrato.PurchaseOrderByCustomer as Solicitacao,
      //      case when
      //        ContratoHeader.CustomerPurchaseOrderType = 'CARG'
      //        then _VbkdCarg.ihrez
      //        else _Vbkd.bstkd end     as Solicitacao,
      _Vbkd.ihrez            as Solicitacao,

      //Ordem.ReferenceSDDocument        as Ordem,
      _DistrC.vbeln          as Ordem,
      //Fatura.ReferenceSDDocument as Remessa,
      _FlowDoc.vbeln         as Remessa,
      //Fatura.BillingDocument     as Fatura,
      _FlowDocFat.vbeln      as Fatura,
      //max(objk.sernr)                  as Serie,
      _Objk.sernr            as Serie,
      case _Vbkd.bsark
      when 'CARG'
      then _Objk.equnr
      //      _VbapC.matnr               as CodigoEquip,
      else
      _VbapC.matnr
      end                    as CodigoEquip,
      case _Vbkd.bsark
      when 'CARG'
      then _Eqkt.eqktx
      //      _VbapC.arktx           as DescricaoEquip,
      else
      _VbapC.arktx
      end                    as DescricaoEquip,

      NF.BR_NFeNumber        as NFeNumber,
      Frete.OrdemFrete       as OrdemFrete,
      Contrato.Plant         as Centro,
      _Remes.vbeln           as RemessaRetorno,
      //_NFDoc.nfenum              as NFRetorno
      case when ContratoHeader.DistributionChannel = '10'
      then _objnf.DocReferencia
      else _NFDoc.nfenum end as NFRetorno
}
where
  Contrato.SalesDocumentRjcnReason <> ''
group by
  Contrato.SalesContract,
  SalesContractItem,
  //Contrato.PurchaseOrderByCustomer,
  //_Vbkd.bstkd,
  //Ordem.ReferenceSDDocument,
  _DistrC.vbeln,
  //Fatura.ReferenceSDDocument,
  _FlowDoc.vbeln,
  //Fatura.BillingDocument,
  _FlowDocFat.vbeln,
  _Objk.sernr,
  _VbapC.matnr,
  _VbapC.arktx,
  NF.BR_NFeNumber,
  Frete.OrdemFrete,
  Contrato.Plant,
  _Remes.vbeln,
  _objnf.DocReferencia,
  _NFDoc.nfenum,
  ContratoHeader.DistributionChannel,
  //ContratoHeader.CustomerPurchaseOrderType,
  _Vbkd.ihrez,
  _Vbkd.bsark,
  _Objk.equnr,
  _Eqkt.eqktx
//  ,_VbkdCarg.ihrez,
//  _Vbkd.bstkd
