@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface para o APP do Cockpit'
@ObjectModel.usageType:{
    serviceQuality: #D,
    sizeCategory: #L,
    dataClass: #MIXED
}
define root view entity ZI_SD_COCKPIT_APP
  as select from    ZI_SD_COCKPIT_CTR         as Cockpit

  left outer join   ZI_SD_COCKPIT_APP_STATUS as CockpitStatus on Cockpit.Contrato = CockpitStatus.Contrato 
                                                             and Cockpit.Solicitacao = CockpitStatus.Solicitacao
                                                             
  left outer join ZI_SD_CR_CP_CTR_PG as _Pag on Cockpit.Contrato = _Pag.Contrato                                                             
                                                                          
  left outer join ZI_SD_COCKPIT_NFE_ENTRADA as _NfeEntrada on _NfeEntrada.Nfenum = Cockpit.NfeSaida
    
  
  association [0..1] to t001w                   as _WerksOrig on  _WerksOrig.werks = Cockpit.CentroOrigem  


  association [0..1] to ZI_SD_VALOR_LOCACAO     as _valorLoc  on  _valorLoc.knumv = Cockpit.Knumv
  
  association [0..1] to t001w                   as _WerksDest on  _WerksDest.werks = _NfeEntrada.Werks
                                                              and _WerksDest.spras = $session.system_language

  association [0..1] to tvakt                   as _Auart     on  _Auart.spras = $session.system_language
                                                              and _Auart.auart = $projection.TipoOrdemVenda  

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
      
      case
        when Cockpit.TpOperacao = 'Micro' then 'N/A'                 
        else Cockpit.CrCp end as CrCp,        
        
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
      
      CockpitStatus.Status,
      CockpitStatus.StatusTxt,
      CockpitStatus.StatusContratoCriticality,

      Cockpit.DocnumNfeSaida,
      _NfeEntrada.Docnum                                   as DocnumEntrada,
      //      Cockpit.DocnumReins,      
     
     case
        when Cockpit.TpOperacao = 'Micro' then 'N/A'                 
        else Cockpit.StatusCP end as StatusCP,   
              
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

      
      case
        when Cockpit.TpOperacao = 'Micro' then 'N/A'                 
        else 
        (
            case when _NfeEntrada.Docnum <> '0000000000' then 'Ok' else 'Pendente' end        
        ) end as DocnumEntradaStatus, 
                   

      case when _NfeEntrada.Docnum <> '0000000000' then 3 -- Verde
                                             else 1 -- Vermelho
      end                                                  as DocnumEntradaCriticality,
      
      case
        when Cockpit.TpOperacao = 'Micro' then 'N/A'   
        when Cockpit.TpOperacao = 'Macro' and ( _Pag.Contrato is not null or _Pag.Contrato is not initial ) then 'Ok'               
        else 
        (
          case when Cockpit.StatusCP = 'Ok' then 'Ok' else 'Pendente' end         
        ) end as StatusCPStatus,       

      case when Cockpit.StatusCP = 'Ok'        then 3 -- Verde 
                                               else 1 -- Vermelho
      end                                                  as StatusCPCriticality,

      Cockpit.Contrato                                     as ContratoLog,
      Cockpit.Solicitacao                                  as SolicitacaoLog,
      Cockpit.DocnumNfeSaida                               as DocnumNfeSaidaLog,
      Cockpit.NfeSaida                                     as NfeSaidaLog,
      Cockpit.OrdemFrete                                   as OrdemFreteLog,
      
    case
        when Cockpit.TpOperacao = 'Micro' and CockpitStatus.StatusTxt = 'Concluído' then 'Contrato Concluído'
        when Cockpit.TpOperacao = 'Micro' and CockpitStatus.StatusTxt = 'Reinscidido' then 'Contrato Rescindido'
        when Cockpit.TpOperacao = 'Micro' and CockpitStatus.StatusTxt = 'Em Andamento' and Cockpit.StatusNfe = '2' then 'Contrato com NF-e Recusada'
        when Cockpit.TpOperacao = 'Macro' and CockpitStatus.StatusTxt = 'Concluído' and Cockpit.TipoOperacao = 'CARG' then 'Contrato Concluído'
        else 
        (        
          case
          when ( Cockpit.OrdemVenda     is initial or Cockpit.OrdemVenda is null ) then 'Ordem de venda pendente'
          when ( Cockpit.Remessa        is initial or Cockpit.Remessa is null ) then 'Remessa pendente'
          when ( Cockpit.OrdemFrete     is initial or Cockpit.OrdemFrete is null ) then 'Ordem de frete pendente'
          when ( Cockpit.DocFatura      is initial or Cockpit.DocFatura is null ) then 'Documento de faturamento pendente'
          when ( Cockpit.DocnumNfeSaida is initial or Cockpit.DocnumNfeSaida is null ) then 'NF-e Saída pendente'
          when ( _NfeEntrada.Docnum = '0000000000' or _NfeEntrada.Docnum is null ) then 'Documento de entrada pendente'
          when ( Cockpit.StatusCP       is initial or Cockpit.StatusCP is null ) then 'Etapa Financeira pendente'
            else 'Contrato Concluído'
          end                
        ) end as StatusLog,          

      @EndUserText.label: 'Centro Destino'
      cast('' as werks_d )                                 as werks_dest,
      Cockpit.TipoOperacao

}
    
