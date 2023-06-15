@AbapCatalog.sqlViewName: 'ZV_SD_COCKPIT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Cockpit Contratos'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view ZI_SD_COCKPIT_CTR
  as select distinct from I_SalesContract as Contrato  
  
  left outer join ZI_SD_CR_CP_CTR_PG as _Pag on Contrato.SalesContract = _Pag.Contrato    
  
  left outer join ZI_SD_CR_CP_OK as _CrCPExiste on Contrato.SalesContract = _CrCPExiste.Contrato  
  
  left outer join ZI_SD_COCKPIT_CTR_PEDIDO_WF( p_tipo : 'H') as _Reins on Contrato.SalesContract = _Reins.SalesOrder
  
  association [0..1] to ZI_SD_COCKPIT_CONTPAG_CLI    as _PagCli         on  Contrato.SalesContract = _PagCli.Contrato
  association [0..1] to ZI_SD_COCKPIT_CONTPAG_FOR    as _PagFor         on  Contrato.SalesContract = _PagFor.Contrato    
  //>>ajuste
//  association [0..1] to tvakt                    as _CtrItem     on  _CtrItem.auart = Contrato.SalesContractType //#
//                                                                 and _CtrItem.spras = $session.system_language   //#
                                                                 
  association [0..1] to I_SalesDocumentTypeText    as _SalesDocumentTypeText  on  _SalesDocumentTypeText.SalesDocumentType = $projection.TipoContrato
                                                                              and _SalesDocumentTypeText.Language          = $session.system_language                                                                 
                                                                 
  association [0..1] to ZI_SD_CENTRO_ITEM        as _Item        on  Contrato.SalesContract = _Item.vbeln
//  left outer join       tvakt             as _CtrItem on  _CtrItem.auart = Contrato.SalesContractType
//                                                          and _CtrItem.spras = $session.system_language
//  left outer join       ZI_SD_CENTRO_ITEM as _Item    on Contrato.SalesContract = _Item.vbeln
  //<<ajuste

  association [1..1] to vbkd                     as _Ctr         on  $projection.Contrato = _Ctr.vbeln //#
  //association [0..1] to I_SalesDocument          as _Ctr         on  $projection.Contrato = _Ctr.SalesDocument
  
  //  association [0..1] to tvakt                 as _CtrItem on $projection.TipoContrato = _CtrItem.auart
  //  association [0..1] to vbap                     as _Item        on  $projection.Contrato = _Item.vbeln
  //  association [0..1] to ZI_SD_CENTRO_ITEM        as _Item        on  $projection.Contrato = _Item.vbeln
  //  association [0..1] to t001w                    as _Dest        on  $projection.EmissorOrdem = _Dest.kunnr
  association [0..1] to knvv                     as _Dest        on  $projection.EmissorOrdem         = _Dest.kunnr
                                                                 and $projection.SalesOrganization    = _Dest.vkorg
                                                                 and $projection.DistributionChannel  = _Dest.vtweg
                                                                 and $projection.OrganizationDivision = _Dest.spart
  
  association [0..1] to ZI_SD_COCKPIT_ORD        as _Ordem       on  $projection.Contrato = _Ordem.Contrato
  //  association [0..1] to ZI_SD_COCKPIT_VALLOC     as _Loc         on  $projection.Contrato = _Loc.Contrato
  //  association [0..1] to ZI_SD_COCKPIT_QTY        as _Qty         on  $projection.Contrato = _Qty.Contrato
  //  association [0..1] to ZI_SD_COCKPIT_TOT        as _Tot         on  $projection.Contrato = _Tot.Contrato
  //association [0..1] to ZI_SD_COCKPIT_CONTPAG    as _Pag         on  $projection.Contrato = _Pag.Contrato
  

  

  //  association [0..1] to ZI_SD_VH_TIPO_MICRO      as _Micro       on  SalesContractType = _Micro.Id
  //
  //  association [0..1] to ZI_SD_VH_TIPO_MACRO      as _Macro       on  SalesContractType = _Macro.Id

//  association [1..1] to vbfa                     as _Reins       on  $projection.Contrato = _Reins.vbelv
//                                                                 and _Reins.vbtyp_n       = 'H'
                                                                   
                                                                 

  //  association [0..1] to ZI_SD_COCKPIT_NFDoc      as _DocEntr     on  $projection.DocFatura = _DocEntr.vbelv

  association [0..1] to ZI_SD_QTD_ITENS_CONTRATO as _QtdContrato on  _QtdContrato.Contrato = $projection.Contrato
  association [0..1] to ZI_SD_QTD_ITENS_VBAP     as _QtdItem     on  _QtdItem.vbeln = $projection.Contrato

  association [0..1] to I_Customer               as _Customer    on  _Customer.Customer = SoldToParty

{
  key        SalesContract           as Contrato,
  key        PurchaseOrderByCustomer as Solicitacao,
  key        _Ordem.OrdemVenda       as OrdemVenda,
  key        _Ordem.DocFatura        as DocFatura,
             //key  _Dest.werks             as CentroDestino,
             //  key  case when _Ordem.TipoOrdemVenda = 'Y075' or
             //                 _Ordem.TipoOrdemVenda = 'Y074' or
             //                 _Ordem.TipoOrdemVenda = 'Y076' or
             //                 _Ordem.TipoOrdemVenda = 'Y077'
             //            then _Item.werks
             //       else _Dest.werks end    as CentroDestino,
  key        case when DistributionChannel = '10' then  _Dest.vwerk
              else _Item.werks
              end                    as CentroDestino,

  key        _Ordem.Remessa          as Remessa,

             
//             case when _Ordem.TipoOrdemVenda = 'Z011'
//             then 'S'
//             else 'N' end            as CrCp,
             
             case when ( _CrCPExiste.Contrato is not initial or _CrCPExiste.Contrato is not null)
             then 'Concluído'
             else 'Pendente' end            as CrCp,             
             
             
             CreationDate            as DataCriacaoContrato,
             SalesContractType       as TipoContrato,
             SalesContractCondition  as Knumv,
             _SalesDocumentTypeText.SalesDocumentTypeName as TipoContratoTexto,
             _Item.werks             as CentroOrigem,
             SoldToParty             as EmissorOrdem,
             _Customer.CustomerName  as EmissorName,
             //       _Dest.werks             as CentroDestino,
             //      _Ordem.OrdemVenda       as OrdemVenda,
             _Ordem.TipoOrdemVenda   as TipoOrdemVenda,
             //       _Ordem.Remessa          as Remessa,
             _Ordem.OrdemFrete       as OrdemFrete,
             //      _Ordem.DocFatura        as DocFatura,
             _Ordem.StatusNfe        as StatusNfe,
             _Ordem.NfeSaida         as NfeSaida,

             //SalesContractType       as TpOperacao,
             //       case when _Ordem.TipoOrdemVenda = 'Y074' or _Ordem.TipoOrdemVenda = 'Y075' then 'Micro'
             //            when _Ordem.TipoOrdemVenda = 'Y076' or _Ordem.TipoOrdemVenda = 'Y077' then 'Macro'
             //            else ''
             //            end                as TpOperacao,

             case when DistributionChannel = '10' then 'Macro'
                  else 'Micro'
                  end                as TpOperacao,


             case
                  when _Reins.SalesOrder    is not initial then 'R'


                  when SalesContract is not initial and _Ordem.NfeSaida is initial then 'A'

             //            when _Ordem.NfeSaida is not initial then 'C'
                  when _Ordem.DocnumNfeSaida is not initial or
                       _Ordem.DocnumEntrada is not initial then 'C'
                  else ''
             end                     as Status,
             _Ordem.DocnumNfeSaida   as DocnumNfeSaida,
             //_Ordem.DocnumEntrada    as DocnumEntrada,
             case when _Ordem.TipoOrdemVenda = 'Y076' or _Ordem.TipoOrdemVenda = 'Y077' then _Ordem.DocnumEntrada
                  else ''
                  end                as DocnumEntrada,
             //             _Reins.vbeln            as DocnumReins,
             //      _Loc.ValLoc             as ValLoc,
             //             _Qty.QtdItens           as QtdItens,
             //             _Tot.QtdTotal           as QtdTotal,
             _Ctr.bsark              as TipoOperacao,
             
//             case when _Ctr.bsark = 'Z001' and _PagCli.DocCliente is not initial and _PagFor.DocForn is not initial then 'Completo'
//                  when _Ctr.bsark = 'Z001' and _PagCli.DocCliente is initial or _PagFor.DocForn is initial then 'Pendente'
//                  else ''
//             end                     as StatusCP,
             
             case 
                  when ( _Pag.Contrato is not null or _Pag.Contrato is not initial ) then 'Ok'                    
                  else 'Pendente'
             end                     as StatusCP,     
                          
             //'Pendente' as StatusCP,
             case
               when  _QtdContrato.QtdContrato >= 1 then  _QtdContrato.QtdContrato
               else 0
             end                     as QtdTotalContrato,

             case
               when _QtdItem.QtdItem >= 1 then _QtdItem.QtdItem
               else 0
             end                     as QtdContrato,
             SalesOrganization,
             DistributionChannel,
             OrganizationDivision,
             // Associations
             //      _CtrItem,
             _Item,
             _Ordem,
             //             _Loc,
             //             _Qty,
             //             _Tot,
             //_Pag,
             //             _Reins,
             //             _Micro,
             //             _Macro,
             _Dest,
             _QtdContrato,
             _Customer,
             _QtdItem
             //       _DocEntr

}
//where
//  (
//       _Ordem.TipoOrdemVenda =  'Y075'
//    or _Ordem.TipoOrdemVenda =  'Y074'
//    or _Ordem.TipoOrdemVenda =  'Y076'
//    or _Ordem.TipoOrdemVenda =  'Y077'
//    or _Ordem.TipoOrdemVenda =  'YR75'
//    or _Ordem.TipoOrdemVenda =  'YD75'
//    or _Ordem.TipoOrdemVenda =  'YR76'
//    or _Ordem.TipoOrdemVenda =  'YD76'
//    or _Ordem.TipoOrdemVenda =  'YR74'
//    or _Ordem.TipoOrdemVenda =  'YD74'
//    or _Ordem.TipoOrdemVenda =  'YR77'
//    or _Ordem.TipoOrdemVenda =  'YD77'
//  )
//  and  _Ordem.TipoOrdemVenda <> 'Z011'
//  _CtrItem.spras = $session.system_language
//  and _Loc.Periodo = _Ordem.PerAtual
