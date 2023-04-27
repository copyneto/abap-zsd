@EndUserText.label: 'Cockpit de Devolução - Ordens'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZI_SD_COCKPIT_DEVOLUCAO_EXT
  as select from    I_SalesDocument              as _Ordem
    inner join      ZI_SD_COCKPIT_DEV_ITEM_ORDEM as _ItemOrdem  on _ItemOrdem.SalesDocument = _Ordem.SalesDocument
    inner join      ZI_SD_PARAM_TP_OV_DEV        as _TipoOrdem  on _TipoOrdem.TpOrdem = _Ordem.SalesDocumentType
    left outer join I_Customer                   as _Cliente    on _Cliente.Customer = _Ordem.SoldToParty
    left outer join ZI_SD_COCKPIT_DEVOLUCAO_REM  as _Remessa    on  _Remessa.DocumentoVendas = _Ordem.SalesDocument
                                                                and _Remessa.ItemRemessa     = _ItemOrdem.Item
    left outer join ZI_SD_NFE_3C_STATUS_CANCEL   as _Nfe3C      on _Nfe3C.DocOrigem = _Remessa.Fatura
    left outer join ZI_SD_NFE_IN_STATUS_CANCEL   as _NfeCliente on  _NfeCliente.nnf       = _Remessa.NfeComp
                                                                and _NfeCliente.cnpj_emit = _Cliente.TaxNumber1
  association        to t001w                  as _LocalNegocio   on  _LocalNegocio.werks = $projection.Centro
  association        to tvakt                  as _TextoTipoOrdem on  _TextoTipoOrdem.spras = $session.system_language
                                                                  and _TextoTipoOrdem.auart = $projection.TipoOrdem
  association [1..1] to t042zt                 as _FormPagText    on  $projection.MeioPagamento = _FormPagText.zlsch
                                                                  and 'BR'                      = _FormPagText.land1
                                                                  and _FormPagText.spras        = $session.system_language
  association [1..1] to I_SDDocumentReasonText as _MotivoText     on  $projection.MotivoOrdem = _MotivoText.SDDocumentReason
                                                                  and _MotivoText.Language    = $session.system_language
{
  key   _Ordem.SalesDocument                                 as Ordem,
  key   _ItemOrdem.Item,
  key   _Remessa.Remessa,
        _Ordem.SalesDocumentType                             as TipoOrdem,
        _TextoTipoOrdem.bezei                                as TextoTipoOrdem,
        _Ordem.SoldToParty                                   as Cliente,
        _Cliente.CustomerName                                as NomeCliente,

        case
        when _Cliente.TaxNumber1 <> ''
        then _Cliente.TaxNumber1
        else _Cliente.TaxNumber2
        end                                                  as CnpjCpf,


        _Remessa.BloqueioRemessa,

        case
        when _Remessa.StatusMovMercadorias = 'C'
        then cast( 'X' as flag )
        else cast( ' ' as flag )
        end                                                  as EM,

        case
        when _Remessa.Cancelado = ' '
        then _Remessa.Fatura
        else cast( ' ' as vbeln_vf)
        end                                                  as Fatura,

        _Remessa.DocNf                                       as Docnum,
        lpad( cast( _Remessa.Nfe as abap.char(9) ), 9, '0' ) as Nfenum,


        _Remessa.DocNfStatus                                 as NfStatus,

        case _Remessa.DocNfStatus
        when ' ' then '1ª tela'
        when '1' then 'Autorizado'
        when '2' then 'Recusado'
        when '3' then 'Rejeitado'
        else ' '
        end                                                  as TextoNfStatus,

        case _Remessa.DocNfStatus
        when ' ' then 2 //Amarelo
        when '1' then 3 //Verde
        when '2' then 1 //Vermelho
        when '3' then 1 //Vermelho
        else 0          //Cinza
        end                                                  as NfStatusColor,

        @Semantics.amount.currencyCode: 'MoedaSD'
        _Remessa.NfTotal,
        _Remessa.MoedaSD,

        _Ordem.SDDocumentReason                              as MotivoOrdem,
        _MotivoText.SDDocumentReasonText                     as MotivoOrdemText,
        case
        when _Nfe3C.code <> ''
        then cast( '3' as ze_situacao_dev_ord )
        when _NfeCliente.statcod <> ''
        then cast( '3' as ze_situacao_dev_ord )
        when _Remessa.Cancelado = ' '
        then cast( '2' as ze_situacao_dev_ord )
        when _Remessa.Fatura is initial or _Remessa.Cancelado = 'X'
        then cast( '1' as ze_situacao_dev_ord )
        else cast( '1' as ze_situacao_dev_ord )
        end                                                  as Situacao,

        case
        when _Nfe3C.code <> ''
        then  1 //Vermelho
        when _NfeCliente.statcod <> ''
        then  1 //Vermelho
        when _Remessa.Cancelado = ' '
        then  3 //Verde
        when _Remessa.Fatura is initial or _Remessa.Cancelado = 'X'
        then  3 //Verde
        else  3 //Verde
        end                                                  as SituacaoColor,

        case
        when _Nfe3C.code <> ''
        then 'Cancelada'
        when _NfeCliente.statcod <> ''
        then 'Cancelada'
        when _Remessa.Cancelado = ' '
        then 'Lançada'
        when _Remessa.Fatura is initial or _Remessa.Cancelado = 'X'
        then 'Em Ordem'
        else 'Em Ordem'
        end                                                  as StatusText,
        _ItemOrdem.Plant                                     as Centro,

        _LocalNegocio.j_1bbranch                             as LocalNegocio,

        _Ordem.CustomerPurchaseOrderType                     as TipoPedido,
        _Ordem.PurchaseOrderByCustomer                       as ProtocoloOcorrencia,
        _Ordem.CreationDate                                  as DataOcorrencia,
        _Ordem.CreationTime                                  as HoraOcorrencia,
        _Ordem.CreatedByUser                                 as CriadoPor,
        _Ordem.PaymentMethod                                 as MeioPagamento,
        _FormPagText.text2                                   as FormPagText




}
