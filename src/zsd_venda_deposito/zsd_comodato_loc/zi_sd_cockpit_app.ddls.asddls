@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface para o APP do Cockpit'
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #L,
    dataClass: #MIXED
}
define root view entity ZI_SD_COCKPIT_APP
  as select from    ZI_SD_COCKPIT_CTR         as Cockpit

  ////    left outer join ZI_SD_COCKPIT_NFDoc       as _DocEntr       on _DocEntr.vbelv = Cockpit.DocFatura
  //    //left outer join ZI_SD_QTD_ITENS_DOCNUM    as _QtdDocNum     on _QtdDocNum.BR_NotaFiscal = _NfeEntrada.Docnum
  //>>ajuste
  //    left outer join ZI_SD_COCKPIT_NFE_ENTRADA as _NfeEntrada    on _NfeEntrada.Nfenum = Cockpit.NfeSaida
  //    left outer join ZI_SD_COMODATO_REINSCID   as _Reinsc        on _Reinsc.Contrato = Cockpit.Contrato
  //    left outer join t001w                     as _WerksOrig     on  _WerksOrig.werks = Cockpit.CentroOrigem
  //                                                                and _WerksOrig.spras = $session.system_language
  //<<ajuste
  ////    left outer join I_Customer                as _CustomerEmiss on _CustomerEmiss.Customer = _WerksOrig.kunnr

  //>>ajuste
    left outer join ZI_SD_COCKPIT_NFE_ENTRADA as _NfeEntrada on _NfeEntrada.Nfenum = Cockpit.NfeSaida
  association [0..1] to ZI_SD_COMODATO_REINSCID as _Reinsc    on  _Reinsc.Contrato = Cockpit.Contrato
  association [0..1] to t001w                   as _WerksOrig on  _WerksOrig.werks = Cockpit.CentroOrigem
  //<<ajuste


  association [0..1] to ZI_SD_VALOR_LOCACAO     as _valorLoc  on  _valorLoc.knumv = Cockpit.Knumv
  association [0..1] to t001w                   as _WerksDest on  _WerksDest.werks = _NfeEntrada.Werks
                                                              and _WerksDest.spras = $session.system_language
  association [0..1] to tvakt                   as _Auart     on  _Auart.spras = $session.system_language
                                                              and _Auart.auart = $projection.TipoOrdemVenda

  association [0..1] to vbuv                    as _Vbuv      on  _Vbuv.vbeln = Cockpit.OrdemVenda

{

  key Cockpit.Contrato                                     as SalesContract,
  key Cockpit.Solicitacao,
      Cockpit.OrdemVenda,
      Cockpit.DocFatura,
      //      Cockpit.CentroDestino,
      //      _NfeEntrada.Werks        as CentroDestino,
      //      _WerksDest.name1         as CentroDestinoName,
      case
        when Cockpit.TpOperacao = 'Macro'
            then cast(_NfeEntrada.Werks as werks_d)
            else cast(Cockpit.CentroOrigem as werks_d) end as CentroDestino,
      case
        when Cockpit.TpOperacao = 'Macro'
            then case
                   when _NfeEntrada.Werks is not initial
                     then _WerksDest.name1
                     else cast('' as char30) end
        else _WerksOrig.name1 end                          as CentroDestinoName,

      Cockpit.Remessa,
      Cockpit.CrCp,
      Cockpit.DataCriacaoContrato,
      Cockpit.TipoContrato,
      Cockpit.TipoContratoTexto,
      Cockpit.CentroOrigem,
      _WerksOrig.name1                                     as CentroOrigemName,
      @EndUserText.label: 'Emissor da ordem'
      Cockpit.EmissorOrdem,
      Cockpit.EmissorName,
      Cockpit.TipoOrdemVenda,
      _Auart.bezei                                         as TpOrdemVendaText,
      Cockpit.OrdemFrete,
      _valorLoc.kbetr                                      as ValorLoc,
      Cockpit.QtdContrato                                  as QtdeAtual,
      Cockpit.QtdTotalContrato                             as QtdeTotal,


      case
      when Cockpit.StatusNfe = '1' then 'Autorizado'
      when Cockpit.StatusNfe = '2' then 'Recusado'
      when Cockpit.StatusNfe = '3' then 'Rejeitado'
      else '' end                                          as StatusNfe,

      Cockpit.NfeSaida,
      Cockpit.TpOperacao,
      _valorLoc.waerk,
      case
        when _Reinsc.Reinscidido = 'X'
           then 'R' //'Reinscidido' //'R'

       when Cockpit.Contrato is not initial and Cockpit.NfeSaida is initial
           then 'A' //'Em andamento' //'A'

       when (Cockpit.TipoOperacao = 'CARG')
             or ( Cockpit.TpOperacao = 'Macro'
                and ( _NfeEntrada.Docnum is not initial or _NfeEntrada.Docnum <> '0000000000')
                and ( Cockpit.OrdemFrete is not initial ) )
             or ( Cockpit.TpOperacao = 'Micro'
                and ( Cockpit.NfeSaida is not initial or Cockpit.NfeSaida is not null)
                and Cockpit.StatusNfe = '1'
                and (Cockpit.OrdemFrete is not initial ) )
           then 'C'//'Concluído' //'C'

       else 'A'//'Em andamento'
      end                                                  as Status,
      case
                 when _Reinsc.Reinscidido = 'X'
                   then 'Reinscidido' //'R'
                 when Cockpit.Contrato is not initial and Cockpit.NfeSaida is initial
                     then 'Em Andamento' //'Em andamento' //'A'
                 when (Cockpit.TipoOperacao = 'CARG')
                   or ( Cockpit.TpOperacao = 'Macro' and ( _NfeEntrada.Docnum is not initial or _NfeEntrada.Docnum <> '0000000000'
                                                          ) and ( Cockpit.OrdemVenda is not initial ) and ( Cockpit.OrdemFrete is not initial ))
                   or ( Cockpit.TpOperacao = 'Micro' and ( Cockpit.NfeSaida is not initial or Cockpit.NfeSaida is not null
                                                          ) and Cockpit.StatusNfe = '1' and ( Cockpit.OrdemFrete is not initial ) )
                     then 'Concluído'//'Concluído' //'C'

                 else 'Em Andamento'//'Em andamento'
            end                                            as StatusTxt,
      case
            when _Reinsc.Reinscidido = 'X'
                   then 1
            when Cockpit.Contrato is not initial and Cockpit.NfeSaida is initial
               then 2  //'Em andamento' //'A'
            when (Cockpit.TipoOperacao = 'CARG')
              or( Cockpit.TpOperacao = 'Macro' and ( _NfeEntrada.Docnum is not initial or _NfeEntrada.Docnum <> '0000000000'
                                                    ) and ( Cockpit.OrdemFrete is not initial ))
             or ( Cockpit.TpOperacao = 'Micro' and ( Cockpit.NfeSaida is not initial or Cockpit.NfeSaida is not null
                                                    ) and Cockpit.StatusNfe = '1' and ( Cockpit.OrdemFrete is not initial ) )
               then 3 //'Concluído' //'C'

            else 2 //'Em andamento'
            end                                            as StatusContratoCriticality,

      Cockpit.DocnumNfeSaida,
      _NfeEntrada.Docnum                                   as DocnumEntrada,
      //      Cockpit.DocnumReins,
      Cockpit.StatusCP,
      cast ( 'X' as xfeld )                                as EntradaMercadorias,

      case when Cockpit.OrdemVenda is not initial then 'Ok'
                                          else 'Pendente'
      end                                                  as OrdemVendaStatus,

      case when Cockpit.OrdemVenda is not initial then 3 -- Verde
                                          else 1 -- Vermelho
      end                                                  as OrdemVendaCriticality,

      case when Cockpit.Remessa is not initial then 'Ok'
                                       else 'Pendente'
      end                                                  as RemessaStatus,

      case when Cockpit.Remessa is not initial then 3 -- Verde
                                       else 1 -- Vermelho
      end                                                  as RemessaCriticality,

      case when Cockpit.OrdemFrete is not initial then 'Ok'
                                          else 'Pendente'
      end                                                  as OrdemFreteStatus,

      case when Cockpit.OrdemFrete is not initial then 3 -- Verde
                                          else 1 -- Vermelho
      end                                                  as OrdemFreteCriticality,

      case when Cockpit.DocFatura is not initial then 'Ok'
                                         else 'Pendente'
      end                                                  as DocFaturaStatus,

      case when Cockpit.DocFatura is not initial then 3 -- Verde
                                         else 1 -- Vermelho
      end                                                  as DocFaturaCriticality,

      case when Cockpit.DocnumNfeSaida is not initial then 'Ok'
                                              else 'Pendente'
      end                                                  as DocnumNfeSaidaStatus,

      case when Cockpit.DocnumNfeSaida is not initial then 3 -- Verde
                                              else 1 -- Vermelho
      end                                                  as DocnumNfeSaidaCriticality,

      case when _NfeEntrada.Docnum <> '0000000000' then 'Ok'
                                                   else 'Pendente'
      end                                                  as DocnumEntradaStatus,

      case when _NfeEntrada.Docnum <> '0000000000' then 3 -- Verde
                                             else 1 -- Vermelho
      end                                                  as DocnumEntradaCriticality,

      case when Cockpit.StatusCP is not initial then 'Ok'
                                        else 'Pendente'
      end                                                  as StatusCPStatus,

      case when Cockpit.StatusCP is not initial then 3 -- Verde
                                        else 1 -- Vermelho
      end                                                  as StatusCPCriticality,

      Cockpit.Contrato                                     as ContratoLog,
      Cockpit.Solicitacao                                  as SolicitacaoLog,
      Cockpit.DocnumNfeSaida                               as DocnumNfeSaidaLog,
      Cockpit.NfeSaida                                     as NfeSaidaLog,
      Cockpit.OrdemFrete                                   as OrdemFreteLog,

      case
      when ( Cockpit.OrdemVenda     is initial or Cockpit.OrdemVenda is null ) then 'Ordem de venda pendente'
      when ( Cockpit.Remessa        is initial or Cockpit.Remessa is null ) then 'Remessa pendente'
      when ( Cockpit.OrdemFrete     is initial or Cockpit.OrdemFrete is null ) then 'Ordem de frete pendente'
      when ( Cockpit.DocFatura      is initial or Cockpit.DocFatura is null ) then 'Documento de faturamento pendente'
      when ( Cockpit.DocnumNfeSaida is initial or Cockpit.DocnumNfeSaida is null ) then 'NF-e Saída pendente'
      when ( _NfeEntrada.Docnum = '0000000000' or _NfeEntrada.Docnum is null ) then 'Documento de entrada pendente'
      when ( Cockpit.StatusCP       is initial or Cockpit.StatusCP is null ) then 'Etapa Financeira pendente'
        else 'Status do Contrato: Concluído!'
      end                                                  as StatusLog,

      @EndUserText.label: 'Centro Destino'
      cast('' as werks_d )                                 as werks_dest,
      Cockpit.TipoOperacao

}
