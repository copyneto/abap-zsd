@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Status do Contrato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_APP_STATUS as 
    
    select from ZI_SD_COCKPIT_CTR as Cockpit 

    left outer join ZI_SD_COCKPIT_NFE_ENTRADA as _NfeEntrada on _NfeEntrada.Nfenum = Cockpit.NfeSaida
    
    association [0..1] to ZI_SD_COMODATO_REINSCID as _Reinsc    on  _Reinsc.Contrato = Cockpit.Contrato
{
  key Cockpit.Contrato,
  key Cockpit.Solicitacao,      
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
        end                                            as StatusContratoCriticality    
}
