@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Doc fat. search help Cockpit Devolução'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_COCKPIT_DEVOLUCAO_DOCFAT
  as select from    vbrk                           as _DocFat
    inner join      ZI_SD_PARAM_TP_DOC_DEV         as _Param       on _Param.TpDoc = _DocFat.fkart
    inner join      vbrp                           as _DocFatItem  on _DocFatItem.vbeln = _DocFat.vbeln

    left outer join ZI_SD_COCKPIT_DEVOL_FAT_RET    as _DocFatDev   on  _DocFatDev.vbeln = _DocFatItem.vbeln
                                                                   and _DocFatDev.posnr = _DocFatItem.posnr

    left outer join ZI_SD_COCKPIT_DEV_ESQUEMA_CALC as _EsquemaCalc on  _EsquemaCalc.DocFaturamento = _DocFatItem.vbeln
                                                                   and _EsquemaCalc.Item           = _DocFatItem.posnr

    left outer join prcd_elements                  as _Preco       on  _Preco.knumv = _DocFat.knumv
                                                                   and _Preco.kposn = _DocFatItem.posnr
                                                                   and _Preco.kschl = 'ZPR0'

    left outer join prcd_elements                  as _PrecoBruto  on  _PrecoBruto.knumv = _DocFat.knumv
                                                                   and _PrecoBruto.kposn = _DocFatItem.posnr
                                                                   and _PrecoBruto.kschl = 'ZTOT'

  association        to ZI_SD_NFE_DEVOLUCAO       as _NfItem    on  _NfItem.DocReferencia  = $projection.DocFaturamento
                                                                and _NfItem.NotaFiscalItem = $projection.Item
  association [0..1] to I_BillingDocumentTypeText as _Text      on  $projection.TipoDoc = _Text.BillingDocumentType
                                                                and _Text.Language      = $session.system_language

  association [0..1] to I_SDDocumentReason        as _ReasonFat on  _ReasonFat.SDDocumentReason = _DocFatItem.augru_auft

{
  key _DocFat.vbeln                                    as DocFaturamento,
  key _DocFatItem.posnr                                as Item,
      _DocFat.fkart                                    as TipoDoc,
      _Text.BillingDocumentTypeName                    as TipoDocNome,
      _DocFat.erdat                                    as DataDoc,
      _DocFat.xblnr                                    as DocReferencia,
      _DocFat.kunag                                    as Cliente,
      _NfItem.Nfe                                      as Nfe,
      cast( _NfItem.UnitCliente  as  abap.dec( 15,2 )) as UnitCliente,
      _DocFatItem.werks                                as Centro,
      _DocFatItem.ean11                                as Ean,
      _DocFatItem.vrkme                                as UnMedida,
      _DocFatItem.matnr                                as Material,
      _DocFatItem.matkl                                as GrupoMat,
      _DocFatItem.arktx                                as TextoMat,
      @Semantics.quantity.unitOfMeasure : 'UnVenda'
      _DocFatItem.fkimg                                as Quantidade,
      _DocFatItem.vrkme                                as UnVenda,
      @Semantics.amount.currencyCode : 'MoedaSd'
      //      _DocFatItem.netwr                                                                                                       as ValorTotal,
      cast(  _DocFatItem.kzwi1 as abap.dec( 13, 2 ) )  as ValorTotal,
      //      case
      //       when _DocFatItem.fkimg = 0
      //        then 0
      //       else
      //      fltp_to_dec( ( cast( _DocFatItem.netwr as abap.fltp ) /  cast( _DocFatItem.fkimg as abap.fltp ) ) as abap.dec( 15, 2 ) )
      //      end                                                                                                                     as ValorUnit,
      case
      when _EsquemaCalc.kbetr = 0
      then cast(  _Preco.kbetr as abap.dec( 24, 2 ) )
      else cast(  _EsquemaCalc.kbetr as abap.dec( 24, 2 ) )
      end                                              as ValorUnit,

      _DocFatItem.waerk                                as MoedaSd,
      //      fltp_to_dec( ( cast( _DocFatItem.netwr as abap.fltp ) + cast( _DocFatItem.mwsbp as abap.fltp ) ) as abap.dec( 15, 2 ) ) as TotalBruto,
      cast( _PrecoBruto.kwert as abap.dec( 24, 2 ) )   as TotalBruto,

      case
      when _DocFat.erdat <= cast( DATS_ADD_MONTHS ($session.system_date,-12,'UNCHANGED') as abap.dats(8))
      then _DocFat.erdat
      else cast( DATS_ADD_MONTHS ($session.system_date,-12,'UNCHANGED') as abap.dats(8))
      end                                              as PeriodoDesde,

      case
      when _DocFat.erdat >= $session.system_date
      then $session.system_date
      else _DocFat.erdat
      end                                              as PeriodoAte,

      case
      when _DocFatDev.vbeln = ''
      then ' '
      when _DocFatDev.vbeln <> ''   and _DocFatDev.absta <> 'C' and _DocFatDev.Quantidade <= 0
      then 'X'
      when _DocFatDev.vbeln <> ''   and  _DocFatDev.absta <> 'C' and _DocFatDev.Quantidade > 0
      then ' '
      when _DocFatDev.absta = 'C'
      then ' '
      else ''
      end                                              as FaturaDev,

      case
      when _DocFatDev.QuantidadePendente is null
      then cast( _DocFatItem.fkimg as abap.dec( 13, 3 ))
      else cast( _DocFatDev.QuantidadePendente as abap.dec( 13, 3 ))
      end                                              as QuantidadePendente,

      _DocFatItem.augru_auft                           as MotivoFatura,
      _ReasonFat._Text.SDDocumentReasonText            as MotivoFaturaText
}
where
  _DocFat.fksto = ''
