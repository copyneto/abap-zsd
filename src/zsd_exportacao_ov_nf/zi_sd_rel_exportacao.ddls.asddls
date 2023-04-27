@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Interface relatório de exportação OV/NF'
@VDM.viewType: #COMPOSITE

define root view entity ZI_SD_REL_EXPORTACAO
  as select from    I_SalesOrderItem               as _SalesOrderItem
    inner join      I_SalesOrder                   as _SalesOrder                    on _SalesOrderItem.SalesOrder = _SalesOrder.SalesOrder
    left outer join I_Customer                     as _Customer                      on _SalesOrder.SoldToParty = _Customer.Customer

    left outer join ZI_SD_FATURAMENTO_E_ITEM       as _fatEItem                      on(
                           _SalesOrderItem.SalesOrder         = _fatEItem.SalesDocument
                           and _SalesOrderItem.SalesOrderItem = _fatEItem.SalesDocumentItem
                         )
    left outer join I_BR_NFItem                    as _BR_NFItem                     on(

                          _fatEItem.DocFaturamento         = _BR_NFItem.BR_NFSourceDocumentNumber
                          and _fatEItem.DocFaturamentoItem = _BR_NFItem.BR_NFSourceDocumentItem
                        )

    left outer join I_BR_NFDocument                as _BR_NFDocument                 on _BR_NFItem.BR_NotaFiscal = _BR_NFDocument.BR_NotaFiscal
    left outer join I_SalesOrderItemPricingElement as _SalesOrderItemPricingElement  on(
       _SalesOrderItem.SalesOrder                      = _SalesOrderItemPricingElement.SalesOrder
       and _SalesOrderItem.SalesOrderItem              = _SalesOrderItemPricingElement.SalesOrderItem
       and _SalesOrderItemPricingElement.ConditionType = 'ZCOR'
     )
    left outer join I_SalesOrderItemPricingElement as _SalesOrderItemPricingElement2 on(
      _SalesOrderItem.SalesOrder                      = _SalesOrderItemPricingElement2.SalesOrder
      and _SalesOrderItem.SalesOrderItem              = _SalesOrderItemPricingElement2.SalesOrderItem
      and _SalesOrderItemPricingElement2.ConditionType = 'ZPR0'
    )
    left outer join I_SalesDocumentPartner         as _SalesDocumentPartner          on(
               _SalesOrder.SalesOrder                    = _SalesDocumentPartner.SalesDocument
               and _SalesDocumentPartner.PartnerFunction = 'ZX'
             )
    left outer join I_Supplier                     as _Supplier                      on _SalesDocumentPartner.Supplier = _Supplier.Supplier
    left outer join I_AdditionalMaterialGroup1Text as _AdditionalMaterialGroup1Text  on  _SalesOrderItem.AdditionalMaterialGroup1 = _AdditionalMaterialGroup1Text.AdditionalMaterialGroup1
                                                                                     and _AdditionalMaterialGroup1Text.Language   = $session.system_language
    left outer join I_SalesDocument                as _SalesDocument                 on _SalesOrder.SalesOrder = _SalesDocument.SalesDocument

    left outer join ZI_EGT_EMB_DUE                 as _ZI_EGT_EMB_DUE                on  _fatEItem.DocFaturamento     = _ZI_EGT_EMB_DUE.DocFaturamento
                                                                                     and _fatEItem.DocFaturamentoItem = _ZI_EGT_EMB_DUE.ItemDocFaturamento
    left outer join vbak                           as _VBAK                          on _SalesOrder.SalesOrder = _VBAK.vbeln

    left outer join I_ExchangeRate                 as _ExchangeRate                  on(
                       _ExchangeRate.ExchangeRateType              = 'G'
                       and(
                         _ExchangeRate.SourceCurrency              = 'USD'
                         or _ExchangeRate.SourceCurrency           = 'USD4'
                       )
                       and _ExchangeRate.TargetCurrency            = 'BRL'
                       and _ExchangeRate.ExchangeRateEffectiveDate = _SalesDocument.ZZ1_DATAEM_SDH // _VBAK.zdataem
                     )
   // left outer join ZI_SD_QUALITY_VE     on  ZI_SD_QUALITY_VE.SalesOrder     = right(_SalesOrderItem.SalesOrder, 10)
   //                                      and ZI_SD_QUALITY_VE.SalesOrderItem = right(_SalesOrderItem.SalesOrderItem, 6)
  association [0..1] to I_DeliveryStatusText as _DeliveryStatusText on  _SalesOrderItem.DeliveryStatus = _DeliveryStatusText.DeliveryStatus
                                                                    and _DeliveryStatusText.Language   = $session.system_language

{
  key _SalesOrderItem.SalesOrder,
  key _SalesOrderItem.SalesOrderItem,
      _SalesOrderItem.SalesOrderItemUUID,
      _SalesOrderItem.SalesOrderItemCategory,

      _SalesOrderItem.CreationDate                                                                                                                      as DataDocumentoVendas,
      _SalesOrderItem.Material                                                                                                                          as Material,
      _SalesOrderItem.SalesOrderItemText                                                                                                                as DescMaterial,
      _SalesOrderItem.Plant                                                                                                                             as Centro,
      _SalesOrderItem.AdditionalMaterialGroup1                                                                                                          as Peneira,
      _AdditionalMaterialGroup1Text.AdditionalMaterialGroup1Name                                                                                        as DescPeneira,
      _SalesOrderItem.OrderQuantity                                                                                                                     as Quantidade,
      _SalesOrderItem.OrderQuantityUnit                                                                                                                 as UnidadeMedida,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _SalesOrderItem.NetAmount                                                                                                                         as ValorLiquidoDolar,
      @ObjectModel.foreignKey.association: '_TransactionCurrency'
      _SalesOrderItem.TransactionCurrency,
      _SalesOrderItem.PriceDetnExchangeRate                                                                                                             as DolarFixado,
      _SalesOrderItem.NetPriceAmount                                                                                                                    as ValorUnitUSD,

      _SalesOrder.SalesOrderDate                                                                                                                        as DataDocumento,

      @Consumption.valueHelpDefinition: [
      { entity:  { name:    'I_CompanyCodeStdVH',
                   element: 'CompanyCode' }
      }]
      _SalesOrder.SalesOrganization                                                                                                                     as OrganizacaoVendas,
      _SalesOrder.SalesOrder                                                                                                                            as OrdemVendas,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_SalesOrderType',
                     element: 'SalesOrderType' }
        }]
      _SalesOrder.SalesOrderType                                                                                                                        as TipoOrdem,
      _SalesOrder.PurchaseOrderByCustomer                                                                                                               as Pedido,
      _SalesOrder.PricingDate                                                                                                                           as DataFixacaoPreco,
      _SalesOrder.SoldToParty                                                                                                                           as CodigoCliente,
      _SalesOrder.RequestedDeliveryDate                                                                                                                 as DataDesejadaRemessa,

      @Consumption.valueHelpDefinition: [
      { entity: { name: 'I_CurrencyText',
                  element: 'Currency' }
      }]
      _SalesOrder.TransactionCurrency                                                                                                                   as MoedaDocumento,

      _Customer.CustomerName                                                                                                                            as NomeCliente,

      _DeliveryStatusText.DeliveryStatusDescription                                                                                                     as StatusRemessa,

      _fatEItem.DolarFaturamento                                                                                                                        as DolarFaturamento,
      _fatEItem.Moeda                                                                                                                                   as Moeda,

      _fatEItem.DocFaturamento                                                                                                                          as DocFaturamento,
      _fatEItem.DataFaturamento                                                                                                                         as DataFaturamento,
      _fatEItem.Periodo                                                                                                                                 as Periodo,
      _fatEItem.FaturaEstornada                                                                                                                         as FaturaEstornada,
      _fatEItem.CancelledBillingDocument                                                                                                                as CancelledBillingDocument,

      @Consumption.valueHelpDefinition: [
      { entity: { name: 'ZI_TM_VH_CFOP',
                  element: 'cfop' }
      }]
      _BR_NFItem.BR_CFOPCode                                                                                                                            as CFOP,
      _BR_NFDocument.BR_NFeNumber                                                                                                                       as NotaFiscal,

      _SalesOrderItemPricingElement.ConditionAmount                                                                                                     as ValorComissaoUSD,
      _SalesOrderItemPricingElement.ConditionRateValue                                                                                                  as ValorUnitComissaoUSD,
      _SalesOrderItemPricingElement.ConditionQuantityUnit                                                                                               as TipoComissao,

      //Valor comissão 4 digitos
      _SalesOrderItemPricingElement2.ConditionRateValue                                                                                                 as PrecoUnitario,

      //ZI_SD_QUALITY_VE.Quality                                                                                                                          as Quality,

      _SalesDocumentPartner.Supplier                                                                                                                    as CodigoCorretor,
      _Supplier.SupplierName                                                                                                                            as DescricaoCorretor,

      _SalesDocument.CorrespncExternalReference                                                                                                         as Paladar,
      _SalesDocument.ZZ1_MES_EMB_SDH                                                                                                                    as MesPrevistoEmbarque,
      _SalesDocument.ZZ1_DIF_SDH                                                                                                                        as Diff,
      _SalesDocument.ZZ1_DIF_SDHC                                                                                                                       as ZZ1_DIF_SDHC,
      _SalesDocument.ZZ1_NIVEBOLSA_SDH                                                                                                                  as MesBolsa,
      _SalesDocument.ZZ1_VALBOLSA_SDH                                                                                                                   as ValorBolsa,
      _SalesDocument.ZZ1_PRICE_LB_SDH                                                                                                                   as PrecoFinalCTSLB,
      _SalesDocument.ZZ1_PRICE_LB_SDHC                                                                                                                  as ZZ1_PRICE_LB_SDHC,
      _SalesDocument.ZZ1_OPFIXACAO_SDH                                                                                                                  as OpcaoFixacao,
      _SalesDocument.ZZ1_LOTE_FIX_SDH                                                                                                                   as LotesFixados,
      _SalesDocument.ZZ1_LOTE_AFI_SDH                                                                                                                   as QuantidadeLoteAFixar,
      _SalesDocument.ZZ1_AMOS_REF_SDH                                                                                                                   as AmostraRef,
      _SalesDocument.ZZ1_COURRIER_SDH                                                                                                                   as CourrierAWB_Nr,
      _SalesDocument.ZZ1_DTENVIO_A_SDH                                                                                                                  as DataEnvioAmostra,
      _SalesDocument.ZZ1_DTAPROV_A_SDH                                                                                                                  as DataAprovacao,

      _ZI_EGT_EMB_DUE.DocEmbExportacao                                                                                                                  as NumEmbarque,
      _ZI_EGT_EMB_DUE.NumeroDUE                                                                                                                         as NumeroDUE,
      _ZI_EGT_EMB_DUE.ChvAcessoDUE                                                                                                                      as ChvAcessoDUE,
      _ZI_EGT_EMB_DUE.DataRegistro                                                                                                                      as DataRegistro,
      _ZI_EGT_EMB_DUE.DataAverbacao                                                                                                                     as DataAverbacao,

      //@ObjectModel.text.element: ['DescPstAlfanOrig']
      _ZI_EGT_EMB_DUE.PstAlfanOrig                                                                                                                      as PstAlfanOrig,
      _ZI_EGT_EMB_DUE.DescPstAlfanOrig                                                                                                                  as DescPstAlfanOrig,
      _ZI_EGT_EMB_DUE.PstAlfanDest                                                                                                                      as PstAlfanDest,
      _ZI_EGT_EMB_DUE.DescPstAlfanDest                                                                                                                  as DescPstAlfanDest,
      _ZI_EGT_EMB_DUE.PaisDestino                                                                                                                       as PaisDestino,
      _ZI_EGT_EMB_DUE.ArmadorBLNum                                                                                                                      as ArmadorBLNum,
      _ZI_EGT_EMB_DUE.DescArmadorBLNum                                                                                                                  as DescArmadorBLNum,
      _ZI_EGT_EMB_DUE.BLN                                                                                                                               as BLN,

      _SalesDocument.ZZ1_SAFRA_SDH                                                                                                                      as Safra,
      _SalesDocument.ZZ1_REF_BROKER_SDH                                                                                                                 as RefBroker,

      _SalesDocument.ZZ1_DATAEM_SDH                                                                                                                     as DataEmbarque,

      _VBAK.zz1_pricekg_sdh                                                                                                                             as Price50Kg,
      _VBAK.zz1_pricekg_sdhc                                                                                                                            as MoedaPriceKG,

      _VBAK.waerk                                                                                                                                       as MoedaWaerk,

      _ExchangeRate.AbsoluteExchangeRate                                                                                                                as TaxaDolarEmbarque,

      //
      cast( cast(_SalesOrderItem.NetAmount as abap.dec( 15, 5)) * cast(_SalesOrderItem.PriceDetnExchangeRate as abap.dec( 15, 5)) as abap.dec( 15, 2 )) as ValorLiquidoReais,
      cast( cast(_SalesOrderItem.NetAmount as abap.dec( 15, 4)) * cast(_ExchangeRate.AbsoluteExchangeRate as abap.dec( 15, 4))    as abap.dec( 15, 4 )) as ValorDiaEmbarque,
      //(ValorDiaEmbarque - ValorLiquidoReais)
      cast(
      (cast(_SalesOrderItem.NetAmount as abap.dec( 15, 5)) * cast(_ExchangeRate.AbsoluteExchangeRate as abap.dec( 15, 5)))
      - (cast(_SalesOrderItem.NetAmount as abap.dec( 15, 5)) * cast(_SalesOrderItem.PriceDetnExchangeRate as abap.dec( 15, 5)))
      as abap.dec( 15, 2))                                                                                                                              as DiferencaCambio,
      //'BRL'                                                                                                       as MoedaReais,
      //'BRL'                                                                                                       as MoedaReais2,

      /* Associations */
      _SalesOrderItem._TransactionCurrency

}
