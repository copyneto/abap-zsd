@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório de Imobilizados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SD_RELATORIO_IMOBILIZADOS
  as select from           j_1bnflin                  as _NfSaidaIT

    inner join             j_1bnfdoc                  as _NfDocSaida   on  _NfDocSaida.docnum = _NfSaidaIT.docnum
                                                                       and _NfDocSaida.direct = '2'
                                                                       and _NfDocSaida.code   = '100'




  //    left outer join        j_1bnflin                  as _NfItem       on  _NfItem.docref = _NfSaidaIT.docnum
  //                                                                       and _NfItem.itmref = _NfSaidaIT.itmnum
  //
  //    left outer join        j_1bnfdoc                  as _NfDoc        on  _NfDoc.docnum = _NfItem.docnum
  //                                                                       and _NfDoc.direct = '1'
  //                                                                       and _NfDoc.code   = '100'
    left outer join        ZI_SD_RELAT_DOC_ENTRADA    as _NfItem       on  _NfItem.DocRef = _NfSaidaIT.docnum
                                                                       and _NfItem.ItmRef = _NfSaidaIT.itmnum
  //                                                                       and _NfItem.itmref = _NfSaidaIT.itmnum
    left outer join        j_1bnfdoc                  as _NfDoc        on _NfDoc.docnum = _NfItem.Docnum
  //  as select from           j_1bnflin                  as _NfItem
  //
  //    inner join             j_1bnfdoc                  as _NfDoc         on  _NfDoc.docnum = _NfItem.docnum
  //                                                                        and _NfDoc.direct = '1'
  //                                                                        and _NfDoc.code   = '100'
  //    left outer join        j_1bnfdoc                  as _NfDocSaida    on _NfDocSaida.docnum = _NfDoc.docref
  //
  //
  //    left outer join        j_1bnflin                  as _NfSaidaIT     on  _NfSaidaIT.docnum = _NfItem.docref
  //                                                                        and _NfSaidaIT.itmnum = _NfItem.itmref

  //    left outer join        j_1bnfdoc                  as _NFStatusSaida on  _NFStatusSaida.docnum = _NfDocSaida.docnum
  //                                                                        and _NFStatusSaida.code   = '100'

    left outer join        I_BR_NFTax                 as _NfTaxEntrada on  _NfTaxEntrada.BR_NotaFiscal     = _NfItem.Docnum
                                                                       and _NfTaxEntrada.BR_NotaFiscalItem = _NfItem.Itmnum
                                                                       and _NfTaxEntrada.TaxGroup          = 'ICMS'

    left outer join        I_BR_NFTax                 as _NfTaxSaida   on  _NfTaxSaida.BR_NotaFiscal     = _NfSaidaIT.docnum
                                                                       and _NfTaxSaida.BR_NotaFiscalItem = _NfSaidaIT.itmnum
                                                                       and _NfTaxSaida.TaxGroup          = 'ICMS'

    inner join             I_BillingDocument          as _BillingDoc   on _BillingDoc.BillingDocument = _NfSaidaIT.refkey

    left outer join        tvfkt                      as _BillingText  on  _BillingText.fkart = _BillingDoc.BillingDocumentType
                                                                       and _BillingText.spras = $session.system_language

    left outer to one join ZI_SD_STATUS_ATIVO_ENTRADA as _Status       on  _Status.BR_NotaFiscal     = _NfSaidaIT.docnum
                                                                       and _Status.BR_NotaFiscalItem = _NfSaidaIT.itmnum
                                                                       and (
                                                                          _Status.DocnumEntrada      = _NfDoc.docnum
                                                                          or _Status.DocnumEntrada   = '0000000000'
                                                                        )
                                                                       and _Status.RegiaoDestino     = _NfDocSaida.regio

    left outer join        vbrp                       as _Vbrp         on  _Vbrp.vbeln = _NfSaidaIT.refkey
                                                                       and _Vbrp.posnr = _NfSaidaIT.itmnum

    left outer join        ser02                      as _Ser02        on  _Ser02.sdaufnr = _Vbrp.aubel
                                                                       and _Ser02.posnr   = _Vbrp.posnr

    left outer join        objk                       as _Objk         on _Objk.obknr = _Ser02.obknr

    left outer join        ZI_SD_RELAT_BUSCA_IMOB     as _FixedAsset   on _FixedAsset.Inventario = ltrim(
      _Objk.sernr, '0'
    )

    inner join             ZI_SD_PARAM_IMOB           as _param        on _param.fkart = _BillingDoc.BillingDocumentType

    left outer join        j_1babt                    as _J1BABT       on  _J1BABT.spras  = $session.system_language
                                                                       and _J1BABT.reftyp = _NfSaidaIT.reftyp

{
  key     case
             when cast( coalesce( _NfItem.Docnum, '0' ) as abap.char(10) ) = '0'  //Docnum Entrada
             then concat(_NfDocSaida.docnum, _NfSaidaIT.itmnum )
             else concat(concat(_NfDocSaida.docnum, _NfItem.Docnum), _NfSaidaIT.itmnum )
          end                                                               as ChaveConacatena,
          @EndUserText.label: 'Docnum Saída'
  key     _NfDocSaida.docnum                                                as Docnum_Saida,
          @EndUserText.label: 'Item Docnum Saída'
  key     _NfSaidaIT.itmnum                                                 as Item_Saida,
          cast( coalesce( _NfItem.Docnum, ' ' ) as abap.numc(10) )          as Docnum,
          _NfItem.Itmnum                                                    as Item,

          @EndUserText.label: 'Tipo de Ativo'
          _BillingDoc.BillingDocumentType                                   as TipoAtivo,
          _BillingText.vtext                                                as TipoAtivoTexto,
          _NfDocSaida.branch                                                as LocalNegocios,
          _NfSaidaIT.werks                                                  as Centro,

          ltrim(  _Objk.sernr, '0')                                         as sernr,
          _FixedAsset.Imobilizado,

          cast (_Objk.sernr as abap.char( 18 ))                             as Plaqueta,

          @EndUserText.label: 'Código NCM'
          _NfSaidaIT.nbm                                                    as NCM,
          _NfDocSaida.parid                                                 as Cliente,

          @EndUserText.label: 'Nome do Cliente'
          _NfDocSaida.name1                                                 as NomeCliente,
          _NfDocSaida.regio                                                 as UFDestino,

          cast(_NfSaidaIT.menge   as abap.char(20) )                        as Quantidade,

          _NfSaidaIT.meins                                                  as Unidade,
          _NfSaidaIT.matnr                                                  as Material,
          _NfSaidaIT.maktx                                                  as DescricaoMaterial,
          @EndUserText.label: 'CFOP de Saída'
          cast(_NfSaidaIT.cfop as logbr_cfopcode preserving type)           as CFOPSaida,
          _NfSaidaIT.reftyp                                                 as DocFaturamentoTipo,
          _J1BABT.rfttxt                                                    as DescrDocFaturamentoTipo,

          @EndUserText.label: 'Doc. Faturamento Saida'
          _NfSaidaIT.refkey                                                 as DocFaturamentoSaida,

          @EndUserText.label: 'Data de Saída'
          cast( coalesce( _NfDocSaida.pstdat, '00000000' ) as j_1bpstdat  ) as DataSaida,

          @EndUserText.label: 'Nº NFE Saída'
          _NfDocSaida.nfenum                                                as NFESaida,

          cast(_NfSaidaIT.netwr as abap.dec(15,2))                          as ValorSaida,

          @EndUserText.label: 'Montante Basico de Saída'

          cast(_NfTaxSaida.BR_NFItemBaseAmount as abap.dec(15,2))           as MontanteBasico,

          _NfTaxSaida.BR_NFItemTaxRate                                      as TaxaSaida,

          cast(_NfTaxSaida.BR_NFItemTaxAmount  as abap.dec(15,2))           as ValorICMSSaida,

          @EndUserText.label: 'Base de Cálculo Saída'
          cast(_NfTaxSaida.BR_NFItemBaseAmount as abap.dec(15,2))           as BaseCalcSaida,

          cast(_NfTaxSaida.BR_NFItemOtherBaseAmount  as abap.dec(15,2))     as OutraBaseSaida,

          _Status.nodias                                                    as dias,
          dats_add_days(_NfDocSaida.pstdat, _Status.nodias, 'INITIAL')      as DataFinal,
          
          
          case 
            when _Status.nodias  > 0 and _Status.nodias < _Status.DiasAtraso1
                then 'Dentro do Prazo'
            when _Status.nodias > 0 and _Status.nodias >= _Status.DiasAtraso1 and _Status.nodias <= _Status.DiasAtraso2
                then 'Prazo Mínimo Expirado'
            when _Status.nodias > 0 and  _Status.nodias > _Status.DiasAtraso2
                then 'Prazo Máximo Expirado'
            else 'Dentro do Prazo' 
          end as Status,
          
          case 
            when _Status.nodias  > 0 and _Status.nodias < _Status.DiasAtraso1
                then 3
            when _Status.nodias > 0 and _Status.nodias >= _Status.DiasAtraso1 and _Status.nodias <= _Status.DiasAtraso2
                then 2
            when _Status.nodias > 0 and  _Status.nodias > _Status.DiasAtraso2
                then 1
            else 3 
          end as StatusCriticality,

      
          

//          @ObjectModel.virtualElement: true
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
//          cast( '' as abap.char( 25 ) )                                     as Status,
//
//          @ObjectModel.virtualElement: true
//          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
//          cast( 0 as abap.int1 )                                            as StatusCriticality,

          @EndUserText.label: 'Dias Atrasados'
          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
          cast( '' as abap.char( 3 ) )                                      as DiasAtrasados,
          //      case
          //      when  _NfDocSaida.docnum is not null and _Status.DiasAtraso2 is not null
          //      then dats_days_between( dats_add_days(_NfDocSaida.pstdat, _Status.DiasAtraso2 , 'INITIAL'), $session.user_date )
          //      else dats_days_between( _NfDoc.pstdat, $session.user_date )
          //      end                                                               as DiasAtrasados,

          @EndUserText.label: 'Dias Pendentes'
          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_RELATORIO_IMOBILIZADOS'
          cast( '' as abap.char( 3 ) )                                      as DiasPendentes,
          //      case
          //      when  _NfDocSaida.docnum is not null
          //      then dats_days_between( _NfDocSaida.pstdat, $session.user_date )
          //      else
          //      dats_days_between( _NfDoc.pstdat, $session.user_date ) end        as DiasPendentes,
          @EndUserText.label: 'CFOP de Entrada'
          cast(_NfItem.Cfop as logbr_cfopcode preserving type)              as CFOPEntrada,
          @EndUserText.label: 'Doc. Faturamento Entrada'
          _NfItem.Refkey                                                    as DocFaturamentoEntrada,
          @EndUserText.label: 'Data de Entrada'
          _NfDoc.docdat                                                     as DataEntrada,
          cast( coalesce( _NfDoc.credat, '00000000' ) as j_1bpstdat  )      as DataLancEntrada,
          @EndUserText.label: 'Nº NFE Entrada'
          _NfDoc.nfenum                                                     as NFEEntrada,
          cast(_NfItem.Netwr          as abap.dec(15,2))                    as ValorEntrada,
          @EndUserText.label: 'Montante Basico de Entrada'
          cast(_NfTaxEntrada.BR_NFItemBaseAmount as abap.dec(15,2))         as MontanteBasicoEntrada,
          _NfTaxEntrada.BR_NFItemTaxRate                                    as TaxaEntrada,
          cast(_NfTaxEntrada.BR_NFItemTaxAmount as abap.dec(15,2))          as ValorICMSEntrada,
          @EndUserText.label: 'Base de Cálculo Entrada'
          cast(_NfTaxEntrada.BR_NFItemBaseAmount as abap.dec(15,2))         as BaseCalcEntrada,
          cast(_NfTaxEntrada.BR_NFItemOtherBaseAmount   as abap.dec(15,2))  as OutraBaseEntrada,
          _NfDoc.waerk                                                      as SalesDocumentCurrency,
          _BillingDoc.SalesOrganization                                     as OrgVendas,
          _BillingDoc.DistributionChannel                                   as CanalDistribuicao,
          _BillingDoc.Division                                              as SetorAtividades,
          _NfDocSaida.txjcd                                                 as DomicilioFiscal,
          _NfDoc.regio

}
//group by
//_NfDocSaida.docnum,
//_NfSaidaIT.itmnum,
//_NfItem.docnum,
//_NfItem.itmnum,
//_BillingDoc.BillingDocumentType,
//_BillingText.vtext,
//_NfDoc.branch,
//_NfItem.werks,
//_Objk.sernr,
//_FixedAsset.Imobilizado,
//_NfItem.nbm,
//_NfDoc.parid,
//_NfDoc.name1,
//_NfDoc.regio,
//_NfItem.menge,
//_NfItem.meins,
//_NfItem.matnr,
//_NfItem.maktx,
//_NfSaidaIT.cfop,
//_NfSaidaIT.reftyp,
//_J1BABT.rfttxt,
//_NfSaidaIT.refkey,
//_NfDocSaida.pstdat,
//_NfDocSaida.nfenum,
//_NfSaidaIT.netwr,
//_NfTaxSaida.BR_NFItemBaseAmount,
//_NfTaxSaida.BR_NFItemTaxRate,
//_NfTaxSaida.BR_NFItemTaxAmount,
//_NfTaxSaida.BR_NFItemBaseAmount,
//_NfTaxSaida.BR_NFItemOtherBaseAmount,
//_NfItem.cfop,
//_NfItem.refkey,
//_NfDoc.docdat,
//_NfDoc.nfenum,
//_NfItem.netwr,
//_NfTaxEntrada.BR_NFItemBaseAmount,
//_NfTaxEntrada.BR_NFItemTaxRate,
//_NfTaxEntrada.BR_NFItemTaxAmount,
//_NfTaxEntrada.BR_NFItemBaseAmount,
//_NfTaxEntrada.BR_NFItemOtherBaseAmount,
//_NfDoc.waerk,
//_BillingDoc.SalesOrganization,
//_BillingDoc.DistributionChannel,
//_BillingDoc.Division,
//_NfDoc.txjcd,
//_NfDoc.regio,
//_Status.nodias,
//_Status2.nodias
