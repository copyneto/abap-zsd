@AbapCatalog.sqlViewName: 'ZVSDCICLO2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS para App Agend'
define view ZI_SD_CKPT_AGEND_CICLO
  with parameters
    p_tipo : vbtyp_n
  as select distinct from vbfa            as _flow

    left outer join       I_BR_NFItem     as _NFITEM     on  _NFITEM.BR_NFSourceDocumentType   = 'BI'
                                                         and _NFITEM.BR_NFSourceDocumentNumber = _flow.vbeln
                                                         and _NFITEM.BR_NotaFiscalItem         = _flow.posnn

  //    left outer join       I_BR_NFDocument as _NFDOCUMENT on  _NFDOCUMENT.BR_NotaFiscal   =  _NFITEM.BR_NotaFiscal
  //                                                         and _NFDOCUMENT.BR_NFIsCanceled <> 'X'
    inner join            I_BR_NFDocument as _NFDOCUMENT on  _NFDOCUMENT.BR_NotaFiscal   =  _NFITEM.BR_NotaFiscal
                                                         and _NFDOCUMENT.BR_NFIsCanceled <> 'X'

  //    left outer join       I_BR_NFTax                      as _NFTAX      on  _NFTAX.BR_NotaFiscal     = _NFITEM.BR_NotaFiscal
  //                                                                         and _NFTAX.BR_NotaFiscalItem = _NFITEM.BR_NotaFiscalItem
  //    inner join            ZI_SD_CKPT_FAT_PARAMETROS( p_chave1 : 'ADM_AGENDAMENTO',
  //                          p_chave2 : 'IMPOSTO_TOTAL_NFE') as _Param      on _Param.parametro = _NFTAX.TaxGroup
{

  key _flow.vbelv                   as SalesOrder,
      _flow.vbeln                   as Document,
      case
      when _flow.posnn >= '900000'
      then _flow.posnv
      else _flow.posnn
      end                           as Item,
      _NFITEM.BR_NotaFiscal         as DocNum,
      _NFITEM.BR_NotaFiscalItem     as DocNumItm,
      _NFITEM.BR_NFTotalAmount      as Total_Nfe,
      _NFITEM.SalesDocumentCurrency as Currency,
      _NFDOCUMENT.BR_NFeNumber      as NotaFiscal,
      _NFDOCUMENT.BR_NFTotalAmount  as Total_Nfe_Header
      //      _NFTAX.BR_NFItemTaxAmount     as ValorTax
}
where
  vbtyp_n = $parameters.p_tipo
