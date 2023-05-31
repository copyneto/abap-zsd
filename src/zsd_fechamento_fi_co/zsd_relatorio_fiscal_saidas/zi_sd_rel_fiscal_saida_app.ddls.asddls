@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório Fiscal de Saída'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@VDM.viewType: #CONSUMPTION

define root view entity ZI_SD_REL_FISCAL_SAIDA_APP
  as select from           I_BR_NFItem                                     as _Lin
    inner join             I_BR_NFDocument                                 as _Doc               on _Doc.BR_NotaFiscal = _Lin.BR_NotaFiscal
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPI0' )  as _TaxIPI0           on  _TaxIPI0.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPI0.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPI3' )  as _TaxIPI3           on  _TaxIPI3.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPI3.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPI2' )  as _TaxIPI2           on  _TaxIPI2.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPI2.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICM3' )  as _TaxICM3           on  _TaxICM3.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICM3.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICM2' )  as _TaxICM2           on  _TaxICM2.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICM2.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICM1' )  as _TaxICM1           on  _TaxICM1.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICM1.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICS3' )  as _TaxICS3           on  _TaxICS3.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICS3.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICS2' )  as _TaxICS2           on  _TaxICS2.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICS2.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICS1' )  as _TaxICS1           on  _TaxICS1.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICS1.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPSN' )  as _TaxIPSN           on  _TaxIPSN.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPSN.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICON' )  as _TaxICON           on  _TaxICON.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICON.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICEP' )  as _TaxICEP           on  _TaxICEP.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICEP.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICAP' )  as _TaxICAP           on  _TaxICAP.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICAP.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICSP' )  as _TaxICSP           on  _TaxICSP.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICSP.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICOP' )  as _TaxICOP           on  _TaxICOP.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICOP.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICOV' )  as _TaxICOV           on  _TaxICOV.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICOV.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICOF' )  as _TaxICOF           on  _TaxICOF.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICOF.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICSC' )  as _TaxICSC           on  _TaxICSC.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICSC.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ICFP' )  as _TaxICFP           on  _TaxICFP.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxICFP.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'ZIC3' )  as _TaxZIC3           on  _TaxZIC3.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxZIC3.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPI1' )  as _TaxIPI1           on  _TaxIPI1.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPI1.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPIS' )  as _TaxIPIS           on  _TaxIPIS.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPIS.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'IPSV' )  as _TaxIPSV           on  _TaxIPSV.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxIPSV.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_TAX(  chave3 : 'FPS2' )  as _TaxFPS2           on  _TaxFPS2.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxFPS2.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_ZONA_FRANCA                    as _TaxZF             on  _TaxZF.BR_NotaFiscal     = _Lin.BR_NotaFiscal
                                                                                                 and _TaxZF.BR_NotaFiscalItem = _Lin.BR_NotaFiscalItem
    left outer join        ZI_SD_REL_FISCAL_SAIDA_PARTNER                  as _Partner           on _Partner.BR_NotaFiscal = _Lin.BR_NotaFiscal

    left outer join        ZI_SD_REL_FISCAL_SAIDA_VOLUMES                  as _VolumesTransporte on _VolumesTransporte.docnum = _Lin.BR_NotaFiscal
  //                                                                                               and _Partner.parid         = _Doc.BR_NFPartner

    left outer join        matdoc                                          as _mseg              on  _mseg.mblnr   = substring(
      _Lin.BR_NFSourceDocumentNumber, 1, 10
    )
                                                                                                 and _mseg.mjahr   = substring(
      _Lin.BR_NFSourceDocumentNumber, 11, 14
    )
                                                                                                 and _mseg.line_id = _Lin.BR_NFSourceDocumentItem

    left outer join        ZI_SD_REL_FISCAL_SAIDA_MBEW                     as _mbew              on  _mbew.matnr = _Lin.Material
                                                                                                 and _mbew.bwkey = _Lin.ValuationArea
                                                                                                 and _mbew.bwtar = _Lin.ValuationType
                                                                                                 and _mbew.lfgja = substring(
      _Doc.CreationDate, 1, 4
    )
                                                                                                 and _mbew.lfmon = substring(
      _Doc.CreationDate, 5, 2
    )




    left outer join        ZI_SD_REL_FISCAL_SAIDA_CONTA                    as _CONTA             on  _CONTA.vbelv   = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _CONTA.posnv   = _Lin.BR_NotaFiscalItem
                                                                                                 and _CONTA.Plant   = _Lin.Plant
                                                                                                 and _CONTA.vbtyp_n = 'R'
  //                                                                                                 and _CONTA.MaterialDocumentYear = substring(
  //      _Doc.CreationDate, 1, 4
  //    )


    inner join             j_1bnfe_active                                  as _Active            on _Active.docnum = _Doc.BR_NotaFiscal
    left outer to one join ZI_SD_REL_FISCAL_CHAVE                          as _Chave             on _Chave.BR_NotaFiscal = _Lin.BR_NotaFiscal

    left outer join        Zi_Sd_Rel_Fiscal_Saida_Ov                       as _SalesOrder        on  _SalesOrder.BillingDocument     = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _SalesOrder.BillingDocumentItem = _Lin.BR_NFSourceDocumentItem

  //    left outer join        I_OutboundDeliveryItem                          as _OutboundDelivery  on  _OutboundDelivery.ReferenceSDDocument  = _SalesOrder.SalesDocument
  //                                                                                                 and _OutboundDelivery.OutboundDeliveryItem = _SalesOrder.SalesDocumentItem

    left outer join        vbrp                                            as _OutboundDelivery  on  _OutboundDelivery.vbeln = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _OutboundDelivery.posnr = _Lin.BR_NotaFiscalItem

  //    left outer join        ZI_SD_REL_FISCAL_SAIDA_CONTA_1                  as _CONTA_1           on  _CONTA_1.MaterialDocument     = _OutboundDelivery.vbeln
  //                                                                                                 and _CONTA_1.MaterialDocumentItem = substring(
  //      _OutboundDelivery.posnr, 3, 4
  //    )
  //                                                                                                 and _CONTA_1.MaterialDocumentYear = substring(
  //      _Doc.CreationDate, 1, 4
  //    )

    left outer join        j_1bnfstx                                       as _J1BNFSTX_ICS3     on  _J1BNFSTX_ICS3.docnum = _Lin.BR_NotaFiscal
                                                                                                 and _J1BNFSTX_ICS3.itmnum = _Lin.BR_NotaFiscalItem
                                                                                                 and _J1BNFSTX_ICS3.taxtyp = 'ICS3'
  //and _J1BNFSTX_ICS3.taxtyp = 'ICFP'

    left outer join        j_1bnfstx                                       as _J1BNFSTX_ICFP     on  _J1BNFSTX_ICFP.docnum = _Lin.BR_NotaFiscal
                                                                                                 and _J1BNFSTX_ICFP.itmnum = _Lin.BR_NotaFiscalItem
                                                                                                 and _J1BNFSTX_ICFP.taxtyp = 'ICFP'

    left outer join        j_1bnfstx                                       as _J1BNFSTX_ICSC     on  _J1BNFSTX_ICSC.docnum = _Lin.BR_NotaFiscal
                                                                                                 and _J1BNFSTX_ICSC.itmnum = _Lin.BR_NotaFiscalItem
                                                                                                 and _J1BNFSTX_ICSC.taxtyp = 'ICSC'

    left outer join        j_1bnfstx                                       as _TaxZCS1           on  _TaxZCS1.docnum = _Lin.BR_NotaFiscal
                                                                                                 and _TaxZCS1.itmnum = _Lin.BR_NotaFiscalItem
                                                                                                 and _TaxZCS1.taxtyp = 'ZCS1'

    left outer join        j_1bnfstx                                       as _TaxZPS2           on  _TaxZPS2.docnum = _Lin.BR_NotaFiscal
                                                                                                 and _TaxZPS2.itmnum = _Lin.BR_NotaFiscalItem
                                                                                                 and _TaxZPS2.taxtyp = 'ZPS2'


  //    left outer to one join        t001w                                          as _RegioOrigem       on _RegioOrigem.werks = _doc.ShippingPoint
    left outer to one join t001w                                           as _RegioOrigem       on _RegioOrigem.werks = _Lin.Plant


    left outer join        ZI_SD_REL_FISCAL_SAIDA_VPRS                     as _ValorVPRS         on  _ValorVPRS.vbeln = _OutboundDelivery.vbeln
                                                                                                 and _ValorVPRS.posnr = _OutboundDelivery.posnr


    left outer join        ztsd_gp_mercador                                as _regra_gp_mercador on  _regra_gp_mercador.centro        = _Lin.Plant
                                                                                                 and _regra_gp_mercador.uf            = 'CE'
                                                                                                 and _regra_gp_mercador.grpmercadoria = _Lin.MaterialGroup

    left outer join        ztsd_material                                   as _regra_material    on  _regra_material.centro   = _Lin.Plant
                                                                                                 and _regra_material.uf       = 'CE'
                                                                                                 and _regra_material.material = _Lin.Material

    left outer join        ZI_SD_REL_FISCAL_SAIDA_INCOD( p_cond : 'ZBON' ) as _CondZBON          on  _CondZBON.vbeln = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _CondZBON.Kposn = _Lin.BR_NFSourceDocumentItem

    left outer join        ZI_SD_REL_FISCAL_SAIDA_INCOD( p_cond : 'ZBOS' ) as _CondZBOS          on  _CondZBOS.vbeln = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _CondZBOS.Kposn = _Lin.BR_NFSourceDocumentItem


    left outer join        vbrk                                            as _vbrk              on _vbrk.vbeln = _Lin.BR_NFSourceDocumentNumber
    left outer join        vbrp                                            as _Vbrp              on  _Vbrp.vbeln = _Lin.BR_NFSourceDocumentNumber
                                                                                                 and _Vbrp.posnr = _Lin.BR_NFSourceDocumentItem
    left outer join        I_Customer                                      as _Cust              on _Cust.Customer = _Doc.BR_NFPartner
  //    left outer join mseg                                                                                                               as _MSEG


  //      on  _MSEG.mblnr = _CONTA.VBELN2
  //      and _MSEG.mjahr = substring(
  //        _Doc.CreationDate, 1, 4
  //      )
  //      and _MSEG.zeile = substring(
  //        _CONTA.posnn, 2, 6
  //      )
  //    left outer join skat                                                                                                               as _SKAT
  //      on  _SKAT.saknr = _MSEG.sakto
  //      and _SKAT.spras = $session.system_language
  association to I_BR_NFeActive                 as _NFeACtive      on  _NFeACtive.BR_NotaFiscal = _Lin.BR_NotaFiscal
  //  association to I_BR_NFMessage                 as _NFemsg
  //    on _NFemsg.BR_NotaFiscal = _Lin.BR_NotaFiscal
  association to ZI_SD_REL_FISCAL_SAIDA_ICMSTXT as _ICMSText       on  _ICMSText.BR_ICMSTaxLaw = _Lin.BR_ICMSTaxLaw
                                                                   and _ICMSText.Language      = $session.system_language

  association to ZI_SD_REL_FISCAL_SAIDA_IPITXT  as _IPIText        on  _IPIText.BR_IPITaxLaw = _Lin.BR_IPITaxLaw
                                                                   and _IPIText.Language     = $session.system_language

  //  association to I_SalesOrder                   as _SalesOrder
  //    on _SalesOrder.SalesOrder = _Lin.BR_NotaFiscal

  //  association to I_PurchaseOrderItemAPI01       as _OrderItemAPI01
  //    on _OrderItemAPI01.Material = _Lin.Material
  association to ZI_SD_REL_FISCAL_SAIDA_SEG     as _Segment        on  _Segment.matnr = _Lin.Material
                                                                   and _Segment.werks = _Lin.Plant

  association to ZI_SD_REL_FISCAL_SAIDA_J1BLPP  as _J1BLPP         on  _J1BLPP.matnr = _Lin.Material
                                                                   and _J1BLPP.bwkey = _Lin.ValuationArea
                                                                   and _J1BLPP.bwtar = _Lin.ValuationType

  //association to ZI_SD_REL_FISCAL_SAIDA_TJ1BLPP  as _TOT_J1BLPP_S on  _TOT_J1BLPP_S.NotaFiscal = _Lin.BR_NotaFiscal and _TOT_J1BLPP_S.lppid = 'S'
  //association to ZI_SD_REL_FISCAL_SAIDA_TJ1BLPP  as _TOT_J1BLPP_DIF on  _TOT_J1BLPP_DIF.NotaFiscal = _Lin.BR_NotaFiscal and _TOT_J1BLPP_DIF.lppid <> 'S'

  association to ZI_SD_REL_FISCAL_SAIDA_PRD_NF  as _VL_PRD_CONF_NF on  _SalesOrder.SalesDocument = _VL_PRD_CONF_NF.SalesOrder
                                                                   and _Lin.Material             = _VL_PRD_CONF_NF.Material

  association to ZI_SD_REL_FISCAL_SAIDA_DescTip as _DescTip        on  _DescTip.kunnr = _Doc.BR_NFPartner
  //  association to ZI_SD_REL_FISCAL_SAIDA_IMP_SD  as _CodImpSD         on  _CodImpSD.vbeln = _Lin.BR_NotaFiscal
  association to ZI_SD_REL_FISCAL_SAIDA_IMP_SD  as _CodImpSD       on  _CodImpSD.vbeln = _Lin.BR_NFSourceDocumentNumber
                                                                   and _CodImpSD.posnr = _Lin.BR_NFSourceDocumentItem
  association to ZI_SD_REL_FISCAL_SAIDA_DOCMIGO as _DocMigo        on  _DocMigo.BR_ReferenceNFNumber    = _Lin.BR_NotaFiscal
                                                                   and _DocMigo.BR_NFSourceDocumentItem = _Lin.BR_NFSourceDocumentItem
  association to ZI_SD_REL_FISCAL_SAIDA_DOCFAT  as _DocFat         on  _DocFat.BR_NotaFiscal           = _Lin.BR_NotaFiscal
                                                                   and _DocFat.BR_NFSourceDocumentItem = _Lin.BR_NFSourceDocumentItem
  //  association to ZI_SD_REL_FISCAL_SAIDA_DESCFAR as _DescFar     on  _DescFar.BR_ReferenceNFNumber    = _Lin.BR_NotaFiscal
  //                                                                and _DescFar.BR_NFSourceDocumentItem = _Lin.BR_NFSourceDocumentItem


  association to I_Material                     as _Material       on  _Material.Material = _Lin.Material
  association to marm                           as _ConversaoKG    on  _ConversaoKG.matnr = _Lin.Material
                                                                   and _ConversaoKG.meinh = 'KG'
  association to marm                           as _ConversaoUN    on  _ConversaoUN.matnr = _Lin.Material
                                                                   and _ConversaoUN.meinh = _Lin.BaseUnit
  association to I_Plant                        as _Plant          on  _Plant.Plant = _Lin.Plant

  association to ZI_CA_VH_NFCODSIT              as _DocSit         on  _DocSit.NFCodSit = _Doc.BR_NFSituationCode

  association to I_Customer                     as _Customer       on  _Customer.Customer = _Doc.BR_NFPartner

{

      //  key _Lin.BR_NotaFiscal                                                                                           as NumDocumento,
  key _Lin.BR_NotaFiscal                                                                                               as NotaFiscal,
  key _Lin.BR_NotaFiscalItem                                                                                           as ItemNF,
      //  _Lin.BR_NotaFiscal                                                                                           as NumDocumento,
      _Doc.BR_NFType                                                                                                   as CategNF,
      _Doc.BR_NFIsCreatedManually                                                                                      as NFIsCreatedManually,
      //      _Doc.BR_NFNumber                                                                                       as NumNF,
      _NFeACtive.BR_NFeNumber                                                                                          as NumNF,
      //      _NFeACtive.BR_NFeNumber                                                                                      as NotaFiscal,
      _Doc.BR_NFPostingDate                                                                                            as DtLancamentoNF,
      _Doc.BusinessPlace                                                                                               as LocalNegocios,
      _Doc.BR_NFPartner                                                                                                as Cliente,
      //_Partner.parid                                                                                               as Cliente,
      case when length(_Doc.BR_NFPartnerName1) > 0 then _Doc.BR_NFPartnerName1 else _Customer.CustomerName end         as NomeCliente,
      //_Doc.BR_NFPartnerRegionCode                                                                                                                                      as UFDestino,
      //_Cust.Region                                                                                                                                                     as UFDestino,
      case when _Cust.Region is initial or _Cust.Region is null then _Doc.BR_NFPartnerRegionCode else _Cust.Region end as UFDestino,
      _Doc.BR_NFPartnerTaxJurisdiction                                                                                 as DomicilioFiscal,
      _SalesOrder.SalesOffice                                                                                          as EscritorioVendas,
      _Lin.MaterialGroup                                                                                               as GrupoMercadorias,
      //@Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      cast(_TaxIPI3.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                                                                      as ValorIPI,
      case
        when _TaxIPI3.BR_NFItemTaxAmount is initial or _TaxIPI3.BR_NFItemTaxAmount is null
            then 0
             when not _TaxIPI3.BR_NFItemIsStatisticalTax is initial
                 then 0
            else cast(_TaxIPI3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
             + case
             when not _TaxIPI2.BR_NFItemIsStatisticalTax is initial
                 then 0
                    when _TaxIPI2.BR_NFItemTaxAmount is initial or _TaxIPI2.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
             + case
                    when not _TaxIPI1.BR_NFItemIsStatisticalTax is initial
                      then 0
                    when _TaxIPI1.BR_NFItemTaxAmount is initial or _TaxIPI1.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end                                 as ValorIPI,
      //_Lin.BR_ICMSSTMarginAddedPercent                                                                                 as MVA,
      case
              when not _TaxICM3.BR_NFItemIsStatisticalTax is initial
                  then 0
              else
                  _Lin.BR_ICMSSTMarginAddedPercent
            end                                                                                                        as MVA,
      //      _DescTip.icmstaxpay                                                                                          as ContribuinteICMS,
      _Partner.icmstaxpay                                                                                              as ContribuinteICMS,
      _Partner.j_1bicmstaxpayx,
      _Lin.Material                                                                                                    as Material,
      _Lin.MaterialName                                                                                                as Descricao,
      //      @Semantics.quantity.unitOfMeasure: 'MaterialWeightUnit'
      cast (_Material.MaterialGrossWeight as logbr_nfe_tax_base_quantity )                                             as MaterialGrossWeight,
      _Material.MaterialWeightUnit,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast (_Lin.BR_NFFreightAmountWithTaxes as logbr_invoicenetamount)                                                as Frete,
      _Doc.BR_NFPartnerCityName                                                                                        as Municipio,
      //      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      //@Aggregation.default:#SUM
      cast (_Lin.QuantityInBaseUnit as  logbr_nfe_tax_base_quantity )                                                  as QtdConfNFEmitida,
      _Lin.BaseUnit,

      //      @Semantics.quantity.unitOfMeasure:'BaseUnitKG'
      //      //@Aggregation.default:#SUM
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_KG'
      cast( 0  as logbr_nfe_tax_base_quantity )                                                                        as QuantityInBaseUnitKG,
      // @Semantics.quantity.unitOfMeasure: 'BaseUnitKG'
      //      _ConversaoUN.umren                                                                                           as QuantityInBaseUnitKG,

      //      cast( 0 as abap.quan(13,3) )                                                                           as QuantityInBaseUnitKG,
      _ConversaoKG.meinh                                                                                               as BaseUnitKG,

      _Lin.NetPriceAmount                                                                                              as PrecoUnitNF,
      //@Semantics.quantity.unitOfMeasure:'BaseUnit'
      //      //@Aggregation.default:#SUM
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_UN'
      cast( 0  as logbr_nfe_tax_base_quantity )                                                                        as QtdUnVdaBasica,
      _Lin.BR_CFOPCode                                                                                                 as CFOP,
      //      _Doc.BR_NFNetAmount                                                                                          as Valor,
      //            @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      @DefaultAggregation: #SUM
      //            //@Aggregation.default:#SUM
      //      cast( _Doc.BR_NFTotalAmount  as logbr_invoicenetamount )                                                                                                         as Valor,
      //      cast( _Doc.BR_NFTotalAmount  as logbr_invoicenetamount )                                                                                                         as Valor,
      //      cast(_Lin.NetValueAmount as abap.dec( 15, 2 ) )
      //            + cast(_TaxIPI3.BR_NFItemBaseAmount as abap.dec( 15, 2 ) )
      //            + cast(_TaxICS3.BR_NFItemBaseAmount as abap.dec( 15, 2 ) )
      //            + cast(_Lin.BR_NFNetFreightAmount as abap.dec( 15, 2 ) )
      //            - _Lin.BR_NFNetDiscountAmount                                                                                                                              as Valor,
      case
      // when _Lin.NetValueAmount is initial or _Lin.NetValueAmount is null
        when _Lin.BR_NFValueAmountWithTaxes is initial or _Lin.BR_NFValueAmountWithTaxes is null
          then 0
      //else cast(_Lin.NetValueAmount as abap.dec( 15, 2 ) ) end
                else cast(_Lin.BR_NFValueAmountWithTaxes as abap.dec( 15, 2 ) ) end

      // ICFP
               + case
                      when not _TaxICFP.BR_NFItemIsStatisticalTax is initial
                      then 0
                      when _TaxICFP.BR_NFItemTaxAmount is initial or _TaxICFP.BR_NFItemTaxAmount is null
                        then 0
                        else cast(_TaxICFP.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end

      // IPI 0
             + case               when not _TaxIPI0.BR_NFItemIsStatisticalTax is initial
                  then 0
                      when _TaxIPI0.BR_NFItemTaxAmount is initial or _TaxIPI0.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI0.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // IPI 3
             + case              when not _TaxIPI3.BR_NFItemIsStatisticalTax is initial
                  then 0
                    when _TaxIPI3.BR_NFItemTaxAmount is initial or _TaxIPI3.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // IPI 2
             + case              when not _TaxIPI2.BR_NFItemIsStatisticalTax is initial
                  then 0
                    when _TaxIPI2.BR_NFItemTaxAmount is initial or _TaxIPI2.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // IPI 1
             + case
                                  when not _TaxIPI1.BR_NFItemIsStatisticalTax is initial
                  then 0
                    when _TaxIPI1.BR_NFItemTaxAmount is initial or _TaxIPI1.BR_NFItemTaxAmount is null
                      then 0
                      else cast(_TaxIPI1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) )  end
      //       ICM1
      //             + case
      //                    when _TaxICM1.BR_NFItemTaxAmount is initial or _TaxICM1.BR_NFItemTaxAmount is null
      //                      then 0
      //                      else cast(_TaxICM1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //       ICM2
      //             + case
      //                   when _TaxICM2.BR_NFItemTaxAmount is initial or _TaxICM2.BR_NFItemTaxAmount is null
      //                      then 0
      //                      else cast(_TaxICM2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      ICM3
      //             + case
      //                    when _TaxICM3.BR_NFItemTaxAmount is initial or _TaxICM3.BR_NFItemTaxAmount is null
      //                      then 0
      //                      else cast(_TaxICM3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // ICS3
               + case
                                    when not _TaxICS3.BR_NFItemIsStatisticalTax is initial
                  then 0
                      when _TaxICS3.BR_NFItemTaxAmount is initial or _TaxICS3.BR_NFItemTaxAmount is null
                        then 0
                        else cast(_TaxICS3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // ICS2
                   + case
                                 when not _TaxICS2.BR_NFItemIsStatisticalTax is initial
                  then 0
                          when _TaxICS2.BR_NFItemTaxAmount is initial or _TaxICS2.BR_NFItemTaxAmount is null
                            then 0
                            else cast(_TaxICS2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // ICS1
                   + case
                                        when not _TaxICS1.BR_NFItemIsStatisticalTax is initial
                  then 0
                          when _TaxICS1.BR_NFItemTaxAmount is initial or _TaxICS1.BR_NFItemTaxAmount is null
                            then 0
                            else cast(_TaxICS1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      // ZCS1
             + case
                    when _TaxZCS1.taxval is initial or _TaxZCS1.taxval is null
                      then 0
                      else cast(_TaxZCS1.taxval as abap.dec( 15, 2 ) ) end
      // ZPS2
             + case
                    when _TaxZPS2.taxval is initial or _TaxZPS2.taxval is null
                      then 0
                      else cast(_TaxZPS2.taxval as abap.dec( 15, 2 ) ) end
       + case
              when _Lin.BR_NFNetFreightAmount is initial or _Lin.BR_NFNetFreightAmount is null
                then 0
                else cast(_Lin.BR_NFNetFreightAmount as abap.dec( 15, 2 ) ) end
       + case
              when _Lin.BR_NFNetInsuranceAmount is initial or _Lin.BR_NFNetInsuranceAmount is null
                then 0
                else cast(_Lin.BR_NFNetInsuranceAmount as abap.dec( 15, 2 ) ) end
       + case
              when _Lin.BR_NFNetOtherExpensesAmount is initial or _Lin.BR_NFNetOtherExpensesAmount is null
                then 0
                else cast(_Lin.BR_NFNetOtherExpensesAmount as abap.dec( 15, 2 ) ) end
       + case
              when _Lin.BR_ExemptedICMSAmount is initial or _Lin.BR_ExemptedICMSAmount is null
                then 0
                else cast(_Lin.BR_ExemptedICMSAmount as abap.dec( 15, 2 ) ) end
       + case
              when _Lin.BR_NFNetDiscountAmount is initial or _Lin.BR_NFNetDiscountAmount is null
                then 0
                else _Lin.BR_NFNetDiscountAmount end                                                                   as Valor,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      // cast( _Lin.NetValueAmount as logbr_invoicenetamount)
      cast( _Lin.BR_NFValueAmountWithTaxes as logbr_invoicenetamount)                                                  as ValorProdutos,

      //      // ICM2
      //      + case
      //          when _TaxICMSGroup.BR_NFItemTaxAmount is initial or _TaxICMSGroup.BR_NFItemTaxAmount is null
      //            then 0
      //            else cast(_TaxICMSGroup.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end                                                                                           as ValorProdutos,
      //      cast( _Lin.BR_NFValueAmountWithTaxes as logbr_invoicenetamount)                                                                                                  as ValorProdutos,
      //      case
      //         when _Lin.NetValueAmount is initial or _Lin.NetValueAmount is null
      //                then 0
      //                else cast(_Lin.NetValueAmount as abap.dec( 15, 2 ) ) end
      //       + case
      //              when _TaxICM3.BR_NFItemTaxAmount is initial or _TaxICM3.BR_NFItemTaxAmount is null
      //                then 0
      //                else cast(_TaxICM3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //       + case
      //              when _TaxICM2.BR_NFItemTaxAmount is initial or _TaxICM2.BR_NFItemTaxAmount is null
      //                then 0
      //                else cast(_TaxICM2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //       + case
      //              when _TaxICM1.BR_NFItemTaxAmount is initial or _TaxICM1.BR_NFItemTaxAmount is null
      //                then 0
      //                else cast(_TaxICM1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end                                                                                       as ValorProdutos,
      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast( _TaxIPI1.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                     as NFItemTaxAmountIPI1,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //      _Lin.BR_NFDiscountAmountWithTaxes                                                                      as DescFarelo,
      //I_BR_NFTax- BR_NFItemTaxAmount com
      //I_BR_NFTax- BR_TaxType = “ICZF/ICZG/ICZT e ZZFD”

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      case
      //        when _Lin.MaterialGroup = 'FAR' and cast( abs(_Lin.BR_NFDiscountAmountWithTaxes) as abap.dec(15,2) ) = 0
      //            then cast( _Lin.BR_NFNetDiscountAmount  * -1 as logbr_nfnetdiscountamount )
      //        else
      //            case
      //                when _Lin.MaterialGroup = 'FAR'
      //                    then cast( abs(_Lin.BR_NFDiscountAmountWithTaxes) as abap.dec(15,2) )
      //            else
      //      //                cast(0 as abap.dec(15,2) )
      //                cast( _Lin.BR_NFNetDiscountAmount  * -1 as logbr_nfnetdiscountamount )
      //        end
      //      end

      case
        when _Lin.MaterialGroup != 'FAR' and cast( abs(_Lin.BR_NFDiscountAmountWithTaxes) as abap.dec(15,2) ) = 0
            then cast( _Lin.BR_NFNetDiscountAmount  * -1 as logbr_nfnetdiscountamount )
        else
            case
                when _Lin.MaterialGroup != 'FAR'
                    then cast( abs(_Lin.BR_NFDiscountAmountWithTaxes) as abap.dec(15,2) )
        end
      end                                                                                                              as DescIncond,

      //      fltp_to_dec(
      //
      //        case
      //          when _CondZBON.valorCond < 0 then cast(_CondZBON.valorCond * -1 as abap.fltp )
      //          else cast(_CondZBON.valorCond as abap.fltp )
      //          end + case
      //                 when _CondZBOS.valorCond < 0 then cast(_CondZBOS.valorCond * -1 as abap.fltp )
      //                 else cast(_CondZBOS.valorCond as abap.fltp )  end as abap.dec(15,2) )                                                                                 as DescIncond,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      case
        when _TaxICM3.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxICM3.BR_NFItemBaseAmount as logbr_invoicenetamount)
        else
            cast(_TaxICM2.BR_NFItemBaseAmount as logbr_invoicenetamount)
      end                                                                                                              as BaseICMS,


      //@Aggregation.default:#SUM
      case
        when not _TaxICM3.BR_NFItemIsStatisticalTax is initial
            then 0
        when _TaxICM3.BR_NotaFiscal = _Lin.BR_NotaFiscal and ( _TaxZF.BR_NFItemTaxAmount is initial or _TaxZF.BR_NFItemTaxAmount is null )
            then cast(_TaxICM3.BR_NFItemTaxAmount as logbr_invoicenetamount)
        when _TaxICM3.BR_NotaFiscal = _Lin.BR_NotaFiscal and not _TaxZF.BR_NFItemTaxAmount is initial
            then 0
        else
            cast(_TaxICM2.BR_NFItemTaxAmount as logbr_invoicenetamount)
      end                                                                                                              as ValorICMS,



      //      cast(_TaxICM3.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                 as BaseICMS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //      cast(_TaxICM3.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                  as ValorICMS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      cast(_TaxICS3.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                                                                     as BaseST,
      case
        when _TaxICS3.BR_NFItemBaseAmount is initial or _TaxICS3.BR_NFItemBaseAmount is null
            then 0
            else cast(_TaxICS3.BR_NFItemBaseAmount as abap.dec( 15, 2 ) ) end
            + case
               when _TaxICS2.BR_NFItemBaseAmount is initial or _TaxICS2.BR_NFItemBaseAmount is null
                  then 0
                  else cast(_TaxICS2.BR_NFItemBaseAmount as abap.dec( 15, 2 ) ) end
            + case
               when _TaxICS1.BR_NFItemBaseAmount is initial or _TaxICS1.BR_NFItemBaseAmount is null
                  then 0
                  else cast(_TaxICS1.BR_NFItemBaseAmount as abap.dec( 15, 2 ) ) end                                    as BaseST,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      cast(_TaxICS3.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                                                                      as ValorST,
      case
               when not _TaxICS3.BR_NFItemIsStatisticalTax is initial
                  then 0
        when _TaxICS3.BR_NFItemTaxAmount is initial or _TaxICS3.BR_NFItemTaxAmount is null
            then 0
            else cast(_TaxICS3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
            + case
               when not _TaxICS2.BR_NFItemIsStatisticalTax is initial
                  then 0
               when _TaxICS2.BR_NFItemTaxAmount is initial or _TaxICS2.BR_NFItemTaxAmount is null
                  then 0
                  else cast(_TaxICS2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
            + case
               when not _TaxICS1.BR_NFItemIsStatisticalTax is initial
                  then 0
               when _TaxICS1.BR_NFItemTaxAmount is initial or _TaxICS1.BR_NFItemTaxAmount is null
                  then 0
                  else cast(_TaxICS1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end                                     as ValorST,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'

      //@Aggregation.default:#SUM
      case
        when _TaxIPI1.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxIPI1.BR_NFItemBaseAmount as logbr_invoicenetamount)
              when _TaxIPI2.BR_NotaFiscal = _Lin.BR_NotaFiscal
                  then cast(_TaxIPI2.BR_NFItemBaseAmount as logbr_invoicenetamount)
        else
            cast(_TaxIPI3.BR_NFItemBaseAmount as logbr_invoicenetamount)
      end                                                                                                              as BaseIPI,


      //@Aggregation.default:#SUM
      case
        when _TaxIPSN.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxIPSN.BR_NFItemTaxAmount as logbr_invoicenetamount)
              when _TaxIPSV.BR_NotaFiscal = _Lin.BR_NotaFiscal
                  then cast(_TaxIPSV.BR_NFItemTaxAmount as logbr_invoicenetamount)
        else
            cast(_TaxIPIS.BR_NFItemTaxAmount as logbr_invoicenetamount)
      end                                                                                                              as PIS,

      //@Aggregation.default:#SUM
      case
        when _TaxICON.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxICON.BR_NFItemTaxAmount as logbr_invoicenetamount)
              when _TaxICOF.BR_NotaFiscal = _Lin.BR_NotaFiscal
                  then cast(_TaxICOF.BR_NFItemTaxAmount as logbr_invoicenetamount)
        else
            cast(_TaxICOV.BR_NFItemTaxAmount as logbr_invoicenetamount)
      end                                                                                                              as COFINS,


      //      //@Aggregation.default:#SUM
      //      cast(_TaxIPI3.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                 as BaseIPI,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //      cast(_TaxIPSN.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                  as PIS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //      cast(_TaxICON.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                  as COFINS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICEP.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ICMS_ICEP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICAP.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ICMS_ICAP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICSP.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ICMS_ICSP,
      //@Aggregation.default:#SUM
      cast( ABS(_TaxZF.BR_NFItemTaxAmount) as logbr_invoicenetamount)                                                  as ICMS_ZN,
      //      _Lin.BR_ISSBenefitCode                                                                                 as CodBenef,
      _Lin.TaxIncentiveCode                                                                                            as CodBenef,
      _Lin.BR_ICMSStatisticalExemptionAmt                                                                              as ICMSDeson,
      _Lin.BR_ICMSTaxSituation                                                                                         as ST_ICMS,
      _Lin.BR_ICMSTaxLaw                                                                                               as LF_ICMS,
      _Partner.Industry                                                                                                as SetorIndustrial,
      //      _DescTip.j_1bindtypx                                                                                         as DescTipPrinInd,
      _Partner.j_1bindtypx                                                                                             as DescTipPrinInd,
      _Partner.TaxNumber3                                                                                              as InscEstadual,
      _Segment.segment                                                                                                 as Segmento,
      _Doc.CreatedByUser                                                                                               as UserCriador,
      _Doc.BR_NFSituationCode                                                                                          as CodSitDoc,
      _DocSit.Text                                                                                                     as DescSitDoc,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICOP.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                     as BaseDifAliquotas,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICOP.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ValorDifAliquotas,
      _Lin.Plant                                                                                                       as Area,
      _Plant.PlantName                                                                                                 as AreaName,
      //      _OrderItemAPI01.TaxCode                                                                                as IVA,
      _Lin.BR_TaxCode                                                                                                  as IVA,
      _Lin.BR_IPITaxLaw                                                                                                as LF_IPI,
      _Lin.BR_IPITaxSituation                                                                                          as ST_IPI,
      _Lin.BR_COFINSTaxLaw                                                                                             as LF_COF,
      _Lin.BR_COFINSTaxSituation                                                                                       as ST_COF,
      _Lin.BR_PISTaxLaw                                                                                                as LF_PIS,
      _Lin.BR_PISTaxSituation                                                                                          as ST_PIS,
      //      _Lin.CostCenter                                                                                        as CentroCustos,
      _SalesOrder.CostCenter                                                                                           as CentroCustos,


      case
        when  _Lin.Batch is not initial
            then _Lin.Batch
        else _mseg.charg
      end                                                                                                              as Lote,


      //      _Lin.Batch                                                                                                   as Lote,
      _Partner.TaxNumber2                                                                                              as CPF,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      cast(_mbew.verpr as logbr_invoicenetamount)                                                                                                                      as PrecoCustoUnitario,
      //      case when _mbew.verpr = 0 or _mbew.verpr is null
      //            then cast( _mbew.stprs as logbr_invoicenetamount)
      //            else cast( _mbew.verpr as logbr_invoicenetamount) end                                                                                                      as PrecoCustoUnitario,
      //fltp_to_dec(cast(_Lin.NetValueAmount as abap.fltp ) * cast(_mbew.verpr as abap.fltp ) as abap.dec(15,2))     as PrecoCustoTotal,
      //      fltp_to_dec(cast(_Lin.QuantityInBaseUnit as abap.fltp ) * cast(_mbew.verpr as abap.fltp ) as abap.dec(15,2))                                                     as PrecoCustoTotal,
      //      case when _mbew.verpr = 0 or _mbew.verpr is null
      //         then fltp_to_dec(cast(_Lin.QuantityInBaseUnit as abap.fltp ) * cast(_mbew.stprs as abap.fltp ) as abap.dec(15,2))
      //         else fltp_to_dec(cast(_Lin.QuantityInBaseUnit as abap.fltp ) * cast(_mbew.verpr as abap.fltp ) as abap.dec(15,2)) end                                         as PrecoCustoTotal,
      fltp_to_dec(cast(_mbew.PrecoCustoUnitario as abap.fltp) as abap.dec(15,2))                                       as PrecoCustoUnitario,

      //      fltp_to_dec(cast( _Lin.QuantityInBaseUnit as abap.fltp)  * cast(_mbew.PrecoCustoUnitario as abap.fltp ) as abap.dec(15,2))                       as PrecoCustoTotal,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_UN'
      fltp_to_dec(cast(cast( 0  as logbr_nfe_tax_base_quantity ) as abap.fltp) as abap.dec(15,2))                      as PrecoCustoTotal,

      //            case
      //                when _J1BLPP.lppid = 'S' then
      //                  fltp_to_dec(_J1BLPP.VlUnPrdConfS as abap.dec(16,2))
      //                else
      //                  fltp_to_dec(_J1BLPP.VlUnPrdConfI as abap.dec(16,2))
      //            end                                                                                                          as VlUnPrdConfNF,
      //
      //            case
      //                when _TOT_J1BLPP_S.lppid = 'S' then
      //                  fltp_to_dec(_TOT_J1BLPP_S.VlTotalUnPrdConfS as abap.dec(16,2))
      //                else
      //                  fltp_to_dec(_TOT_J1BLPP_DIF.VlTotalUnPrdConfI as abap.dec(16,2))
      //            end                                                                                                          as VlTotalUnPrdConfNF,
      //

      case
          when _J1BLPP.VlUnPrdConfI > 0
               then fltp_to_dec(_J1BLPP.VlUnPrdConfI as logbr_invoicenetamount)
          else
            cast(_ValorVPRS.VlUnitario as logbr_invoicenetamount)
      end                                                                                                              as VlUnPrdConfNF,

      case
          when _J1BLPP.VlTotalUnPrdConfS > 0
              then  fltp_to_dec(cast(_Lin.QuantityInBaseUnit as abap.fltp ) * cast(_J1BLPP.VlTotalUnPrdConfS  as abap.fltp ) as abap.dec(15,2))
      //              fltp_to_dec(_J1BLPP.VlTotalUnPrdConfS as logbr_invoicenetamount)
          else
          fltp_to_dec(cast(_Lin.QuantityInBaseUnit as abap.fltp ) * cast(_ValorVPRS.VlTotal as abap.fltp ) as abap.dec(15,2))
      //            cast(_ValorVPRS.VlTotal as logbr_invoicenetamount)
      end                                                                                                              as VlTotalUnPrdConfNF,


      //      cast( _VL_PRD_CONF_NF.VlUnitario as  logbr_invoicenetamount )                                                                                                    as VlUnPrdConfNF,
      //      cast( _VL_PRD_CONF_NF.VlTotal as  logbr_invoicenetamount )                                                                                                       as VlTotalUnPrdConfNF,


      //      _MSEG.sakto                                                                                            as Conta,
      //      _SKAT.txt20                                                                                            as DescConta,
      _CONTA.GLAccount                                                                                                 as Conta,
      _CONTA.GLAccountText                                                                                             as DescConta,
      _Lin.NCMCode                                                                                                     as NCM,
      _Lin.ValuationType                                                                                               as TipoAvaliacao,
      //      _SalesOrder.SalesOrder                                                                                 as OrdemVenda,
      _SalesOrder.SalesDocument                                                                                        as OrdemVenda,
      _SalesOrder.SalesOrganization                                                                                    as OrgVendas,
      _SalesOrder.DistributionChannel                                                                                  as CanalDistrib,
      //            _SalesOrder.BillingCompanyCode                                                                         as Empresa,
      //      cast ( '' as bukrs )                                                                                   as Empresa,
      //      _SalesOrder.CompanyCode                                                                                as Empresa,
      _Doc.CompanyCode                                                                                                 as Empresa,
      _SalesOrder.OrganizationDivision                                                                                 as SetorAtividade,
      _SalesOrder.SDDocumentReason                                                                                     as MotivoOrdem,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICM3.BR_NFItemExcludedBaseAmount as logbr_invoicenetamount preserving type )                            as IsentosICMS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'


      //@Aggregation.default:#SUM
      case
        when _TaxICM3.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxICM3.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
        else
            cast(_TaxICM2.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
      end                                                                                                              as OutrasICMS,

      //      //@Aggregation.default:#SUM
      //      cast(_TaxICM3.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)                                            as OutrasICMS,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxIPI3.BR_NFItemExcludedBaseAmount as logbr_invoicenetamount preserving type )                            as IsentosIPI,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'


      //@Aggregation.default:#SUM
      case
        when _TaxIPI1.BR_NotaFiscal = _Lin.BR_NotaFiscal
            then cast(_TaxIPI1.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
              when _TaxIPI2.BR_NotaFiscal = _Lin.BR_NotaFiscal
                  then cast(_TaxIPI2.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
              when _TaxIPI0.BR_NotaFiscal = _Lin.BR_NotaFiscal
                  then cast(_TaxIPI0.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
         else
            cast(_TaxIPI3.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)
      end                                                                                                              as OutrasIPI,


      //      cast(_TaxIPI3.BR_NFItemOtherBaseAmount as logbr_invoicenetamount)                                            as OutrasIPI,
      _Lin.BR_MaterialOrigin                                                                                           as OrigemMaterial,
      //      _SalesOrder.SalesOrderType                                                                             as TipoDocVendas,
      _SalesOrder.SalesDocumentItemCategory                                                                            as TipoDocVendas,
      _Lin.BR_ReferenceNFNumber                                                                                        as NumdocOriginalNF,
      _Lin.BR_ReferenceNFItem                                                                                          as NumdocOriginalItem,
      _NFeACtive.Region                                                                                                as RegiaoEmissor,
      _NFeACtive.BR_NFeIssueYear,
      _NFeACtive.BR_NFeIssueMonth,
      _NFeACtive.BR_NFeAccessKeyCNPJOrCPF,
      _NFeACtive.BR_NFeModel,
      _NFeACtive.BR_NFeSeries,
      _NFeACtive.BR_NFeNumber,
      _NFeACtive.BR_NFeRandomNumber,
      _NFeACtive.BR_NFeCheckDigit,
      _Doc.BR_NFArrivalOrDepartureDate                                                                                 as DataSaidaNF,
      _Doc.BR_SUFRAMACode                                                                                              as CodSuframa,
      _DescTip.tdt                                                                                                     as TipoDeclaracaoImposto,

      cast(_Lin.BR_NFNetOtherExpensesAmount as logbr_invoicenetamount)                                                 as despesa,

      //      cast(_Lin.BR_NFExpensesAmountWithTaxes    as logbr_invoicenetamount)                                                                                             as despesa,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICSC.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                     as BaseICMS_FCP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICSC.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ValorICMS_FCP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICFP.BR_NFItemBaseAmount as logbr_invoicenetamount)                                                     as BaseST_FCP,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      cast(_TaxICFP.BR_NFItemTaxAmount as logbr_invoicenetamount)                                                      as ValorST_FCP,
      //      _NFemsg.BR_NFMessageText                                                                               as TextoDFICMS1,
      //      _NFemsg.BR_NFMessageText                                                                               as TextoDFICMS2,
      //      _NFemsg.BR_NFMessageText                                                                               as TextoDFICMS3,
      //      _NFemsg.BR_NFMessageText                                                                               as TextoDFIPI,
      _ICMSText.BR_ICMSTaxLawLine1                                                                                     as TextoDFICMS1,
      _ICMSText.BR_ICMSTaxLawLine2                                                                                     as TextoDFICMS2,
      _ICMSText.BR_ICMSTaxLawLine3                                                                                     as TextoDFICMS3,
      _IPIText.BR_IPITaxLawLine1                                                                                       as TextoDFIPI,
      //      _Lin.BR_ICMSSTBaseDetermination                                                                        as BaseICMS_STReemb,
      //      cast(_Lin.BR_WithholdingICMSSTBaseAmount    as abap.dec(15,2))                                               as BaseICMS_STReemb,

      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //      _Lin.BR_ICMSStatisticalExemptionAmt                                                                          as IcmsStReembolso,

      //cast(_J1BNFSTX_ICSC.base    as abap.dec(15,2))                                                               as BaseICMS_STFCPReemb,
      //cast(_J1BNFSTX_ICSC.taxval    as abap.dec(15,2))                                                             as IcmsStFCPReembolso,

      //novo - ok
      //      cast(_J1BNFSTX_ICS3.base as abap.dec(15,2))                                                                                                                      as BaseICMS_STReemb,
      //      cast(_J1BNFSTX_ICS3.taxval  as abap.dec(15,2))                                                                                                                   as IcmsStReembolso,
      //      cast(_J1BNFSTX_ICFP.base    as abap.dec(15,2))                                                                                                                   as BaseICMS_STFCPReemb,
      //      cast(_J1BNFSTX_ICFP.taxval  as abap.dec(15,2))                                                                                                                   as IcmsStFCPReembolso,

      _Lin.BR_ICMSSTRateIncludingFCP                                                                                   as pst,
      _Lin.BR_FCPonICMSSTWithheldRate                                                                                  as pfcpstret,
      _Lin.BR_EffectiveICMSRate                                                                                        as picmsefet,
      _Lin.Plant,
      cast(_Lin.BR_EffctvCalcBasisAmount as abap.dec(15,2))                                                            as vbcefet,
      cast(_Lin.BR_WithholdingICMSSTAmount  as abap.dec(15,2))                                                         as BR_WithholdingICMSSTAmount,


      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB'
      //      cast(_Lin.BR_WithholdingICMSSTBaseAmount as abap.dec(15,2))                                                                                                      as BaseICMS_STReemb,
      cast(0 as abap.dec(15,2))                                                                                        as BaseICMS_STReemb,

      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB'
      cast(_Lin.BR_WithholdingICMSSTAmount  as abap.dec(15,2))                                                         as IcmsStReembolso,


      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB'
      //      cast(_Lin.BR_FCPOnICMSSTWithheldBaseAmt    as abap.dec(15,2))                                                                                                    as BaseICMS_STFCPReemb,
      cast(0    as abap.dec(15,2))                                                                                     as BaseICMS_STFCPReemb,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CALC_REEMB'
      //      cast(_Lin.BR_FCPOnICMSSTWithheldAmount  as abap.dec(15,2))                                                                                                       as IcmsStFCPReembolso,
      cast(0  as abap.dec(15,2))                                                                                       as IcmsStFCPReembolso,

      case
       when _regra_gp_mercador.grpmercadoria is not initial or _regra_material.material is not initial
            then
               case
                when _RegioOrigem.regio = 'CE' and _Doc.BR_NFPartnerRegionCode <> 'CE'
                    then 'X'
                else    ''
                end
       else ''
      end                                                                                                              as StEntrada,



      //      case
      //      when _TaxZIC3.BR_NFItemTaxAmount  <> 0 then 'X'
      //      else ''
      //      end                                                                                                                                                              as StEntrada,

      case
              when not _TaxZF.BR_NFItemTaxAmount is initial
                  then 0
              when not _TaxICM3.BR_NFItemIsStatisticalTax is initial
                  then 0
              else
                  _TaxICM3.BR_NFItemTaxRate
            end                                                                                                        as AliqICMS,
      //      _TaxICM3.BR_NFItemTaxRate                                                                                                                                        as AliqICMS,

      //      _Lin.BR_NFTributaryUnit                                                                                as UnVdaBasica,
      _Material.MaterialBaseUnit                                                                                       as UnVdaBasica,
      //      @Semantics.quantity.unitOfMeasure:'BaseUnit'
      //@Aggregation.default:#SUM
      //      cast(_Doc.HeaderGrossWeight  as logbr_nfe_tax_base_quantity )                                                                                                    as PesoBrutoNF,
      //      fltp_to_dec( (cast( _Material.MaterialGrossWeight as abap.fltp ) * cast( _Lin.QuantityInBaseUnit as abap.fltp )) as abap.dec(15,2))                              as PesoBrutoNF,
      case
        when _Vbrp.brgew is initial or _Vbrp.brgew is null
        then _VolumesTransporte.PesoBrutoVolumes
        else cast(_Vbrp.brgew as abap.dec(15,3) )
      end                                                                                                              as PesoBrutoNF,
      _Doc.BR_NFModel                                                                                                  as ModeloNF,
      _DescTip.brtxt                                                                                                   as DescSetorInd,

      //cast( _Lin.BR_NFValueAmountWithTaxes as abap.fltp ) * cast( _TaxICOP.BR_NFItemTaxAmount as abap.fltp )       as ValorICMSsemBenef,
      //fltp_to_dec( (cast( _Lin.BR_NFValueAmountWithTaxes as abap.fltp ) * cast( _TaxICM3.BR_NFItemTaxRate as abap.fltp ) / cast(100 as abap.fltp) ) as abap.dec(15,2)) as ValorICMSsemBenef,
      case
         when not _TaxICM3.BR_NFItemIsStatisticalTax is initial
             then 0
         else
             fltp_to_dec( (cast( _Lin.BR_NFValueAmountWithTaxes as abap.fltp ) * cast( _TaxICM3.BR_NFItemTaxRate as abap.fltp ) / cast(100 as abap.fltp) ) as abap.dec(15,2))
       end                                                                                                             as ValorICMSsemBenef,
      _Lin.InternationalArticleNumber                                                                                  as Gtin,
      _OutboundDelivery.vgbel                                                                                          as DocRem,
      //      _DocMigo.DocMigo

      case
      when _Lin.BR_NFSourceDocumentType  = 'MD'
        then substring( _Lin.BR_NFSourceDocumentNumber, 1, 10 )
        else ''
      end                                                                                                              as DocMigo,
      //      _DocFat.DocFaturamento                                                                                                                                           as DocFaturamento,
      substring( _Lin.BR_NFSourceDocumentNumber, 1, 10 )                                                               as DocFaturamento,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //      //@Aggregation.default:#SUM
      //_DescFar.BR_NFNetDiscountAmount                                                                              as DescFarelo,
      case
        when _Lin.MaterialGroup = 'FAR'
            then cast( abs(_Lin.BR_NFDiscountAmountWithTaxes) as abap.dec(15,2) )
        else
            cast(0 as abap.dec(15,2) )
      end                                                                                                              as DescFarelo,

      _CodImpSD.j_1btxsdc                                                                                              as CodImpSD,
      case
        when _Doc.BR_NFPartnerCNPJ is initial
            then ''
        else
            concat( substring(_Doc.BR_NFPartnerCNPJ, 1, 2),
            concat( '.',
            concat( substring(_Doc.BR_NFPartnerCNPJ, 3, 3),
            concat( '.',
            concat( substring(_Doc.BR_NFPartnerCNPJ, 6, 3),
            concat( '/',
            concat( substring(_Doc.BR_NFPartnerCNPJ, 9, 4),
            concat( '-',  substring(_Doc.BR_NFPartnerCNPJ, 13, 2) ) ) ) ) ) ) ) )
        end                                                                                                            as CNPJ,
      //cast( _Lin.BR_NFValueAmountWithTaxes as abap.fltp ) * cast( _TaxIPI3.BR_NFItemTaxAmount as abap.fltp )       as ValorBaseCalsemBenef,

      //      cast(_TaxIPI3.BR_NFItemBaseAmount as abap.dec(15,2) )                                                                                                            as ValorBaseCalsemBenef,
      //      cast(_TaxICM3.BR_NFItemBaseAmount as abap.dec(15,2) )                                                                                                            as ValorBaseCalsemBenef,
      //      cast(_Lin.NetValueAmount as abap.dec(15,2) )                                                                                                                     as ValorBaseCalsemBenef,
      cast(  case
          when not _TaxICM3.BR_NFItemIsStatisticalTax is initial
            then 0
          when _TaxICM3.BR_NFItemTaxRate <> 0
            then cast(_Lin.NetValueAmount as abap.dec(15,2) )
            else cast(0  as abap.dec(15,2) )
          end  as abap.dec(15,2) )                                                                                     as ValorBaseCalsemBenef,


      //      _DocMigo.AnoMigo

      case
        when _Lin.BR_NFSourceDocumentType  = 'MD'
            then   substring(_Lin.BR_NFSourceDocumentNumber, 11, 4 )
        else ''
       end                                                                                                             as AnoMigo,
      //_TaxIPI3.BR_NFItemTaxRate                                                                                                                                        as AliqIPI,
      case
         when not _TaxIPI3.BR_NFItemIsStatisticalTax is initial
             then 0
         else
             _TaxIPI3.BR_NFItemTaxRate
       end                                                                                                             as AliqIPI,
      _Doc.BR_NFPartner                                                                                                as EmissorOrdem,
      //      @Semantics.amount.currencyCode:'SalesDocumentCurrency'
      //@Aggregation.default:#SUM
      //      cast( _Lin.BR_NFTotalAmount as abap.dec(15,2) ) - cast( _Lin.BR_NFFreightAmountWithTaxes as abap.dec(15,2) )                                                     as ValorsemFrete,
      case
      when _Lin.NetValueAmount is initial or _Lin.NetValueAmount is null
        then 0
      else cast(_Lin.NetValueAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxIPI3.BR_NFItemTaxAmount is initial or _TaxIPI3.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxIPI3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxIPI2.BR_NFItemTaxAmount is initial or _TaxIPI2.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxIPI2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxIPI1.BR_NFItemTaxAmount is initial or _TaxIPI1.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxIPI1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxICS3.BR_NFItemTaxAmount is initial or _TaxICS3.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxICS3.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxICS2.BR_NFItemTaxAmount is initial or _TaxICS2.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxICS2.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //      + case
      //        when _TaxICS1.BR_NFItemTaxAmount is initial or _TaxICS1.BR_NFItemTaxAmount is null
      //          then 0
      //          else cast(_TaxICS1.BR_NFItemTaxAmount as abap.dec( 15, 2 ) ) end
      //       + case
      //          when _TaxZCS1.taxval is initial or _TaxZCS1.taxval is null
      //            then 0
      //            else cast(_TaxZCS1.taxval as abap.dec( 15, 2 ) ) end
      //       + case
      //          when _TaxZPS2.taxval is initial or _TaxZPS2.taxval is null
      //            then 0
      //            else cast(_TaxZPS2.taxval as abap.dec( 15, 2 ) ) end
      + case
        when _Lin.BR_NFNetFreightAmount is initial or _Lin.BR_NFNetFreightAmount is null
          then 0
          else cast(_Lin.BR_NFNetFreightAmount as abap.dec( 15, 2 ) ) end
      + case
        when _Lin.BR_NFNetInsuranceAmount is initial or _Lin.BR_NFNetInsuranceAmount is null
          then 0
          else cast(_Lin.BR_NFNetInsuranceAmount as abap.dec( 15, 2 ) ) end
      + case
        when _Lin.BR_NFNetOtherExpensesAmount is initial or _Lin.BR_NFNetOtherExpensesAmount is null
          then 0
          else cast(_Lin.BR_NFNetOtherExpensesAmount as abap.dec( 15, 2 ) ) end
      + case
        when _Lin.BR_NFNetDiscountAmount is initial or _Lin.BR_NFNetDiscountAmount is null
          then 0
          else _Lin.BR_NFNetDiscountAmount end
      - case
        when _Lin.BR_NFFreightAmountWithTaxes is initial or _Lin.BR_NFFreightAmountWithTaxes is null
          then 0
          else cast( _Lin.BR_NFFreightAmountWithTaxes as abap.dec(15,2) ) end                                          as ValorsemFrete,

      _Doc.BR_NFPartnerTaxRegimenCode                                                                                  as CodRegTribNum,


      //Referencias
      _Doc.SalesDocumentCurrency                                                                                       as SalesDocumentCurrency,
      _Chave.chaveAcesso                                                                                               as ChaveAcesso,
      _Partner.Industry                                                                                                as DescontoInd

}

where
          _Doc.BR_NFDirection = '2' //NF Saída
  and(
    (
          _vbrk.fkart         = 'Z005'
      and _Active.docsta      = '1'
    )
    or    _Active.code        = '100'
  )
//group by
//  _Lin.BR_NotaFiscal,
//  _Lin.BR_NotaFiscalItem,
//  _Doc.BR_NFType,
//  _Doc.BR_NFIsCreatedManually,
//  _NFeACtive.BR_NFeNumber,
//  _Doc.BR_NFPostingDate,
//  _Doc.BusinessPlace,
//  _Doc.BR_NFPartner,
//  _Customer.CustomerName,
//  _Doc.BR_NFPartnerName1,
//  _Doc.BR_NFPartnerRegionCode,
//  _Doc.BR_NFPartnerTaxJurisdiction,
//  _SalesOrder.SalesOffice,
//  _Lin.MaterialGroup,
//  _TaxIPI3.BR_NFItemTaxAmount,
//  _Lin.BR_ICMSSTMarginAddedPercent,
//  _Partner.icmstaxpay,
//  _Partner.j_1bicmstaxpayx,
//  _Lin.Material,
//  _Lin.MaterialName,
//  _Material.MaterialGrossWeight,
//  _Material.MaterialWeightUnit,
//  _Lin.BR_NFFreightAmountWithTaxes,
//  _Doc.BR_NFPartnerCityName,
//  _Lin.QuantityInBaseUnit,
//  _Lin.BaseUnit,
//  _ConversaoKG.meinh,
//  _Lin.NetPriceAmount,
//  _Lin.BR_CFOPCode,
//  _Lin.BR_NFTotalAmount,
//  _TaxIPI1.BR_NFItemTaxAmount,
//  _Lin.BR_NFDiscountAmountWithTaxes,
//  _TaxICM2.BR_NFItemBaseAmount,
//  _TaxICM3.BR_NotaFiscal,
//  _TaxICM3.BR_NFItemBaseAmount,
//  _TaxICM2.BR_NFItemTaxAmount,
//  _TaxICM3.BR_NFItemTaxAmount,
//  _TaxICS3.BR_NFItemBaseAmount,
//  _TaxICS3.BR_NFItemTaxAmount,
//  _TaxIPI3.BR_NFItemBaseAmount,
//  _TaxIPI1.BR_NotaFiscal,
//  _TaxIPI1.BR_NFItemBaseAmount,
//  _TaxIPI2.BR_NotaFiscal,
//  _TaxIPI2.BR_NFItemBaseAmount,
//  _TaxIPIS.BR_NFItemTaxAmount,
//  _TaxIPSN.BR_NotaFiscal,
//  _TaxIPSN.BR_NFItemTaxAmount,
//  _TaxIPSV.BR_NotaFiscal,
//  _TaxIPSV.BR_NFItemTaxAmount,
//  _TaxICOV.BR_NFItemTaxAmount,
//  _TaxICON.BR_NotaFiscal,
//  _TaxICON.BR_NFItemTaxAmount,
//  _TaxICOF.BR_NotaFiscal,
//  _TaxICOF.BR_NFItemTaxAmount,
//  _TaxICEP.BR_NFItemTaxAmount,
//  _TaxICAP.BR_NFItemTaxAmount,
//  _TaxICSP.BR_NFItemTaxAmount,
//  _TaxZF.BR_NFItemTaxAmount,
//  _Lin.TaxIncentiveCode,
//  _Lin.BR_ICMSStatisticalExemptionAmt,
//  _Lin.BR_ICMSTaxSituation,
//  _Lin.BR_ICMSTaxLaw,
//  _Partner.Industry,
//  _Partner.j_1bindtypx,
//  _Partner.TaxNumber3,
//  _Segment.segment,
//  _Doc.CreatedByUser,
//  _Doc.BR_NFSituationCode,
//  _DocSit.Text,
//  _TaxICOP.BR_NFItemBaseAmount,
//  _TaxICOP.BR_NFItemTaxAmount,
//  _Lin.Plant,
//  _Plant.PlantName,
//  _Lin.BR_TaxCode,
//  _Lin.BR_IPITaxLaw,
//  _Lin.BR_IPITaxSituation,
//  _Lin.BR_COFINSTaxLaw,
//  _Lin.BR_COFINSTaxSituation,
//  _Lin.BR_PISTaxLaw,
//  _Lin.BR_PISTaxSituation,
//  _SalesOrder.CostCenter,
//  _mseg.charg,
//  _Lin.Batch,
//  _Partner.TaxNumber2,
//  _mbew.verpr,
//  _VL_PRD_CONF_NF.VlUnitario,
//  _VL_PRD_CONF_NF.VlTotal,
//  _CONTA.GLAccount,
//  _CONTA.GLAccountText,
//  _Lin.NCMCode,
//  _Lin.ValuationType,
//  _SalesOrder.SalesDocument,
//  _SalesOrder.SalesOrganization,
//  _SalesOrder.DistributionChannel,
//  _Doc.CompanyCode,
//  _SalesOrder.OrganizationDivision,
//  _SalesOrder.SDDocumentReason,
//  _TaxICM3.BR_NFItemExcludedBaseAmount,
//  _TaxICM2.BR_NFItemOtherBaseAmount,
//  _TaxICM3.BR_NFItemOtherBaseAmount,
//  _TaxIPI3.BR_NFItemExcludedBaseAmount,
//  _TaxIPI3.BR_NFItemOtherBaseAmount,
//  _TaxIPI1.BR_NFItemOtherBaseAmount,
//  _TaxIPI2.BR_NFItemOtherBaseAmount,
//  _Lin.BR_MaterialOrigin,
//  _SalesOrder.SalesDocumentItemCategory,
//  _Lin.BR_ReferenceNFNumber,
//  _Lin.BR_ReferenceNFItem,
//  _NFeACtive.Region,
//  _NFeACtive.BR_NFeIssueYear,
//  _NFeACtive.BR_NFeIssueMonth,
//  _NFeACtive.BR_NFeAccessKeyCNPJOrCPF,
//  _NFeACtive.BR_NFeModel,
//  _NFeACtive.BR_NFeSeries,
//  _NFeACtive.BR_NFeRandomNumber,
//  _NFeACtive.BR_NFeCheckDigit,
//  _Doc.BR_NFArrivalOrDepartureDate,
//  _Doc.BR_SUFRAMACode,
//  _DescTip.tdt,
//  _TaxICSC.BR_NFItemBaseAmount,
//  _TaxICSC.BR_NFItemTaxAmount,
//  _TaxICFP.BR_NFItemBaseAmount,
//  _TaxICFP.BR_NFItemTaxAmount,
//  _ICMSText.BR_ICMSTaxLawLine1,
//  _ICMSText.BR_ICMSTaxLawLine2,
//  _ICMSText.BR_ICMSTaxLawLine3,
//  _IPIText.BR_IPITaxLawLine1,
//  _J1BNFSTX_ICS3.base,
//  _J1BNFSTX_ICS3.taxval,
//  _J1BNFSTX_ICFP.base,
//  _J1BNFSTX_ICFP.taxval,
//  _TaxZIC3.BR_NFItemTaxAmount,
//  _TaxICM3.BR_NFItemTaxRate,
//  _Material.MaterialBaseUnit,
//  _Doc.HeaderGrossWeight,
//  _Doc.BR_NFModel,
//  _DescTip.brtxt,
//  _Lin.BR_NFValueAmountWithTaxes,
//  _Lin.InternationalArticleNumber,
//  _OutboundDelivery.OutboundDelivery,
//  _DocMigo.DocMigo,
//  _DocFat.DocFaturamento,
//  _CodImpSD.j_1btxsdc,
//  _Doc.BR_NFPartnerCNPJ,
//  _DocMigo.AnoMigo,
//  _TaxIPI3.BR_NFItemTaxRate,
//  _Doc.BR_NFPartnerTaxRegimenCode,
//  _Doc.SalesDocumentCurrency,
//  _Chave.chaveAcesso,
//  _Doc.BR_NFTotalAmount
