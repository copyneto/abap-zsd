@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Monta Chave de Acesso das Nfs dos Clientes'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CHAVE_ACESSO_NF_CLIENTE
  as select from t001w                        as _Centros
    inner join   ZI_SD_PARAM_CNPJ_LOC_NEGOCIO as _CnpjCliente on _CnpjCliente.LocalNegocio = _Centros.j_1bbranch
    inner join   /xnfe/innfehd                as _NfeInbound  on  _NfeInbound.type      = '1'
                                                              and _NfeInbound.cnpj_dest = _CnpjCliente.Cnpj
                                                              and (
                                                                 _NfeInbound.finnfe     = '1'
                                                                 or _NfeInbound.finnfe  = '4'
                                                               )

  association to /xnfe/innfeit              as _NfeItem       on _NfeItem.guid_header = _NfeInbound.guid_header
  association to kna1                       as _Cliente1      on _Cliente1.stcd1 = _NfeInbound.cnpj_emit
  association to kna1                       as _Cliente2      on _Cliente2.stcd2 = _NfeInbound.cnpj_emit
  association to ZI_SD_NFE_DEVOLUCAO_CANCEL as _NotaCancelada on _NotaCancelada.ChaveAcesso = _NfeInbound.nfeid

{
  key   'SH'                                     as SearchHelp,
  key   _NfeInbound.nnf                          as Nfe,
        _NfeInbound.serie                        as Serie,
        min(_NfeItem.nitem)                      as Item,
        _Centros.werks                           as Centro,
        _NfeInbound.cnpj_emit                    as Cnpj,
        _NfeInbound.waers                        as Moeda,
        @Semantics.amount.currencyCode: 'Moeda'
        _NfeInbound.s1_vnf                       as ValorTotal,
        substring( max(_NfeInbound.dhemi ),1,8 ) as DataEmissao,

        case
        when _Cliente1.kunnr <> ''
        then _Cliente1.kunnr
        else _Cliente2.kunnr
        end                                      as Cliente,

        case
        when _Cliente1.name1 <> ''
        then _Cliente1.name1
        else _Cliente2.name1
        end                                      as NomeCliente,

        cast ( '1' as ze_tipo_devolucao )        as TpDevolucao,

        ' '                                      as CodFiscal,
        ' '                                      as CodMunicipal,
        cast( '0000000000' as abap.numc(10) )    as Docnum,
//        _NfeItem.cean                            as Cnae,
        _NfeInbound.nfeid                        as ChaveAcesso,

        _NotaCancelada.Cancelada

}
//where
//  _NotaCancelada.Cancelada <> 'X'
group by
  _NfeInbound.nnf,
  _NfeInbound.serie,
  _Centros.werks,
  _NfeInbound.cnpj_emit,
  _NfeInbound.waers,
  _NfeInbound.s1_vnf,
  _Cliente1.kunnr,
  _Cliente2.kunnr,
  _Cliente1.name1,
  _Cliente2.name1,
  //      _NfDoc.BusinessPlaceStateTaxNumber                                                           as CodFiscal,
  //      _NfDoc.BusPlaceMunicipalTaxNumber                                                            as CodMunicipal,
  _NfeInbound.nfeid,
//  _NfeItem.cean,
  _NotaCancelada.Cancelada
