@AbapCatalog.sqlViewName: 'ZVSD_UNION_COCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'view - Cockipit'
define view ZI_SD_03_UNION_COCKPIT

  as select from    ztsd_intercompan                      as Cockpit
    inner join      ZI_SD_PO_ATIVA                        as _ValidPO    on _ValidPO.PurchaseOrder = Cockpit.purchaseorder
    left outer join ZI_SD_BR_GET_NF_BY_PO                 as _NFDocPO    on  _NFDocPO.PurchaseOrder = Cockpit.purchaseorder
                                                                         and _NFDocPO.Direction     = '2'
    left outer join ZI_SD_BR_GET_NF_BY_PO                 as _NFDocPOInb on  _NFDocPOInb.PurchaseOrder = Cockpit.purchaseorder
                                                                         and _NFDocPOInb.Direction     = '1'
                                                                         and ( _NFDocPOInb.BR_NFType     = 'YE' or _NFDocPOInb.BR_NFType     = 'IL' )
    left outer join ZI_SD_ORDEM_FRETE( p_tipo_doc : '73',
                                       p_catg_doc : 'TO') as _OrdemFrete on _OrdemFrete.Remessa = Cockpit.remessa
    left outer join I_BR_NFeActive                        as _NFeActive  on _NFeActive.BR_NotaFiscal = _NFDocPO.BR_NotaFiscal

{
  key Cockpit.guid                                                                     as Guid,
      Cockpit.salesorder                                                               as SalesOrder,
      substring(Cockpit.purchaseorder,1,10)                                            as PurchaseOrder,
      ltrim(cast(_NFDocPO.BR_NotaFiscal as abap.char(10)),'0')                         as br_notafiscal,
      ltrim(cast(_NFDocPO.BR_NFeNumber as abap.char(9)),'0')                           as BR_NFeNumber,
      Cockpit.werks_origem                                                             as Werks_Origem,
      Cockpit.werks_destino                                                            as Werks_Destino,
      Cockpit.lgort_destino                                                            as Lgort_Destino,
      Cockpit.lgort_origem                                                             as Lgort_Origem,
      Cockpit.werks_receptor                                                           as Werks_Receptor,
      Cockpit.remessa                                                                  as Remessa,
      Cockpit.ztraid                                                                   as Ztraid,
      Cockpit.ztrai1                                                                   as Ztrai1,
      Cockpit.ztrai2                                                                   as Ztrai2,
      Cockpit.ztrai3                                                                   as Ztrai3,
      cast('' as vbeln_vf)                                                             as Docfat,
      Cockpit.purchaseorder2                                                           as PurchaseOrder2,
      Cockpit.salesorder2                                                              as SalesOrder2,
      Cockpit.tipooperacao                                                             as TipoOperacao,
      _NFDocPO.BR_NFeDocumentStatus                                                    as br_nfedocumentstatus,
      _NFDocPO.BR_NFeDocumentStatusDesc                                                as BR_NFeDocumentStatusDesc,
      Cockpit.tpfrete                                                                  as Tpfrete,
      Cockpit.agfrete                                                                  as Agfrete,
      Cockpit.motora                                                                   as Motora,
      Cockpit.tpexp                                                                    as Tpexp,
      Cockpit.condexp                                                                  as CondExp,
      Cockpit.txtnf                                                                    as Txtnf,
      Cockpit.txtgeral                                                                 as Txtgeral,
      _OrdemFrete.DocumentoFrete                                                       as FreightOrder,
      concat(_NFeActive.Region,
      concat(_NFeActive.BR_NFeIssueYear,
      concat(_NFeActive.BR_NFeIssueMonth,
      concat(_NFeActive.BR_NFeAccessKeyCNPJOrCPF,
      concat(_NFeActive.BR_NFeModel,
      concat(_NFeActive.BR_NFeSeries,
      concat(_NFeActive.BR_NFeNumber,
      concat(_NFeActive.BR_NFeRandomNumber, _NFeActive.BR_NFeCheckDigit) ) ) ) ) ) ) ) as ChaveAcesso,
      Cockpit.processo                                                                 as Processo,
      Cockpit.fracionado                                                               as Fracionado,
      Cockpit.idsaga                                                                   as IdSaga,
      Cockpit.ekorg,
      Cockpit.ekgrp,
      Cockpit.abrvw,
      ltrim(cast(_NFDocPOInb.BR_NotaFiscal as abap.char(10)),'0')                      as nfentrada,
      ltrim(cast(_NFDocPOInb.BR_NFeNumber as abap.char(9)),'0')                        as BR_NFeNumberEntrada,
      Cockpit.remessa_origem                                                           as RemessaOrigem,
      Cockpit.created_by                                                               as CreatedBy,
      Cockpit.created_at                                                               as CreatedAt,
      Cockpit.last_changed_by                                                          as LastChangedBy,
      Cockpit.last_changed_at                                                          as LastChangedAt,
      Cockpit.local_last_changed_at                                                    as LocalLastChangedAt
}
where
      Cockpit.processo      = '1'
  and Cockpit.purchaseorder is not initial

union select from ztsd_intercompan as Cockpit
{
  key Cockpit.guid                          as Guid,
      Cockpit.salesorder                    as SalesOrder,
      substring(Cockpit.purchaseorder,1,10) as PurchaseOrder,
      cast('' as abap.char(10))             as br_notafiscal,
      cast('' as abap.char(9))              as BR_NFeNumber,
      Cockpit.werks_origem                  as Werks_Origem,
      Cockpit.werks_destino                 as Werks_Destino,
      Cockpit.lgort_destino                 as Lgort_Destino,
      Cockpit.lgort_origem                  as Lgort_Origem,
      Cockpit.werks_receptor                as Werks_Receptor,
      Cockpit.remessa                       as Remessa,
      Cockpit.ztraid                        as Ztraid,
      Cockpit.ztrai1                        as Ztrai1,
      Cockpit.ztrai2                        as Ztrai2,
      Cockpit.ztrai3                        as Ztrai3,
      cast('' as vbeln_vf)                  as Docfat,
      Cockpit.purchaseorder2                as PurchaseOrder2,
      Cockpit.salesorder2                   as SalesOrder2,
      Cockpit.tipooperacao                  as TipoOperacao,
      cast('' as j_1bnfedocstatus)          as br_nfedocumentstatus,
      cast('' as val_text)                  as BR_NFeDocumentStatusDesc,
      Cockpit.tpfrete                       as Tpfrete,
      Cockpit.agfrete                       as Agfrete,
      Cockpit.motora                        as Motora,
      Cockpit.tpexp                         as Tpexp,
      Cockpit.condexp                       as CondExp,
      Cockpit.txtnf                         as Txtnf,
      Cockpit.txtgeral                      as Txtgeral,
      cast('' as abap.char(10))             as FreightOrder,
      cast('' as /xnfe/id)                  as ChaveAcesso,
      Cockpit.processo                      as Processo,
      Cockpit.fracionado                    as Fracionado,
      Cockpit.idsaga                        as IdSaga,
      Cockpit.ekorg,
      Cockpit.ekgrp,
      Cockpit.abrvw,
      cast('' as abap.char(10))             as nfentrada,
      cast('' as abap.char(9))              as BR_NFeNumberEntrada,
      Cockpit.remessa_origem                as RemessaOrigem,
      Cockpit.created_by                    as CreatedBy,
      Cockpit.created_at                    as CreatedAt,
      Cockpit.last_changed_by               as LastChangedBy,
      Cockpit.last_changed_at               as LastChangedAt,
      Cockpit.local_last_changed_at         as LocalLastChangedAt
}
where
      processo      = '1'
  and purchaseorder is initial



union

select from       ztsd_intercompan                          as Cockpit
  left outer join ZI_SD_CKPT_CICLO_PED_FLOW( p_tipo : 'J' ) as _Fornecimento on _Fornecimento.SalesOrder = Cockpit.salesorder
//  left outer join ZI_SD_CKPT_CICLO_PED_FLOW( p_tipo : 'M' ) as _Fatura       on _Fatura.SalesOrder = Cockpit.salesorder
  left outer join ZI_SD_OV_FATURA                           as _Fatura       on  _Fatura.OrdemVenda = Cockpit.salesorder
                                                                             and _Fatura.Estornado  = ''
  left outer join ZI_SD_ORDEM_FRETE( p_tipo_doc : '73',
                                     p_catg_doc : 'TO')     as _OrdemFrete   on _OrdemFrete.Remessa = _Fornecimento.Document
  left outer join ZI_SD_BR_GET_NF_BY_SO                     as _NFDocSO      on  _NFDocSO.SalesOrder = Cockpit.salesorder
                                                                             and _NFDocSO.Direction  = '2'
  left outer join I_BR_NFeActive                            as _NFeActive    on _NFeActive.BR_NotaFiscal = _NFDocSO.BR_NotaFiscal

   left outer join ZI_SD_BR_GET_NF_BY_PO                 as _NFDocPOInb on  _NFDocPOInb.PurchaseOrder = Cockpit.purchaseorder
                                                                         and _NFDocPOInb.Direction     = '1'
                                                                         and _NFDocPOInb.BR_NFType     = 'IC'


{
  key Cockpit.guid                                                                     as Guid,
      Cockpit.salesorder                                                               as SalesOrder,
      substring(Cockpit.purchaseorder,1,10)                                            as PurchaseOrder,
      ltrim(cast(_NFDocSO.BR_NotaFiscal as abap.char(10)),'0')                         as br_notafiscal,
      ltrim(cast(_NFDocSO.BR_NFeNumber as abap.char(9)),'0')                           as BR_NFeNumber,
      Cockpit.werks_origem                                                             as Werks_Origem,
      Cockpit.werks_destino                                                            as Werks_Destino,
      Cockpit.lgort_destino                                                            as Lgort_Destino,
      Cockpit.lgort_origem                                                             as Lgort_Origem,
      Cockpit.werks_receptor                                                           as Werks_Receptor,
      _Fornecimento.Document                                                           as Remessa,
      Cockpit.ztraid                                                                   as Ztraid,
      Cockpit.ztrai1                                                                   as Ztrai1,
      Cockpit.ztrai2                                                                   as Ztrai2,
      Cockpit.ztrai3                                                                   as Ztrai3,
      _Fatura.Fatura                                                                   as Docfat,
      Cockpit.purchaseorder2                                                           as PurchaseOrder2,
      Cockpit.salesorder2                                                              as SalesOrder2,
      Cockpit.tipooperacao                                                             as TipoOperacao,
      _NFDocSO.BR_NFeDocumentStatus                                                    as br_nfedocumentstatus,
      _NFDocSO.BR_NFeDocumentStatusDesc                                                as BR_NFeDocumentStatusDesc,
      Cockpit.tpfrete                                                                  as Tpfrete,
      Cockpit.agfrete                                                                  as Agfrete,
      Cockpit.motora                                                                   as Motora,
      Cockpit.tpexp                                                                    as Tpexp,
      Cockpit.condexp                                                                  as CondExp,
      Cockpit.txtnf                                                                    as Txtnf,
      Cockpit.txtgeral                                                                 as Txtgeral,
      _OrdemFrete.DocumentoFrete                                                       as FreightOrder,
      concat(_NFeActive.Region,
      concat(_NFeActive.BR_NFeIssueYear,
      concat(_NFeActive.BR_NFeIssueMonth,
      concat(_NFeActive.BR_NFeAccessKeyCNPJOrCPF,
      concat(_NFeActive.BR_NFeModel,
      concat(_NFeActive.BR_NFeSeries,
      concat(_NFeActive.BR_NFeNumber,
      concat(_NFeActive.BR_NFeRandomNumber, _NFeActive.BR_NFeCheckDigit) ) ) ) ) ) ) ) as ChaveAcesso,
      Cockpit.processo                                                                 as Processo,
      Cockpit.fracionado                                                               as Fracionado,
      Cockpit.idsaga                                                                   as IdSaga,
      Cockpit.ekorg,
      Cockpit.ekgrp,
      Cockpit.abrvw,
      ltrim(cast(_NFDocPOInb.BR_NotaFiscal as abap.char(10)),'0')                      as nfentrada,
      ltrim(cast(_NFDocPOInb.BR_NFeNumber as abap.char(9)),'0')                        as BR_NFeNumberEntrada,
      Cockpit.remessa_origem                                                           as RemessaOrigem,
      Cockpit.created_by                                                               as CreatedBy,
      Cockpit.created_at                                                               as CreatedAt,
      Cockpit.last_changed_by                                                          as LastChangedBy,
      Cockpit.last_changed_at                                                          as LastChangedAt,
      Cockpit.local_last_changed_at                                                    as LocalLastChangedAt
}
where
  processo = '2'
