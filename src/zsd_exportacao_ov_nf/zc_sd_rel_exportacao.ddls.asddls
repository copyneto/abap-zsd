@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consumo relatório de exportação OV/NF'
@VDM.viewType: #CONSUMPTION
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

//@OData: { publish: true }

define root view entity ZC_SD_REL_EXPORTACAO
  as projection on ZI_SD_REL_EXPORTACAO
{
  key SalesOrder,
  key SalesOrderItem,
      @Consumption.hidden: true
      SalesOrderItemUUID,
      SalesOrderItemCategory,
      DataDocumentoVendas,
      Material,
      DescMaterial,
      Centro,
      Peneira,
      DescPeneira,
      Quantidade,
      UnidadeMedida,
      ValorLiquidoDolar,
      @Consumption.hidden: true
      TransactionCurrency,
      DolarFixado,
      //ValorUnitUSD,
      DataDocumento,
      OrganizacaoVendas,
      OrdemVendas,
      TipoOrdem,
      Pedido,
      DataFixacaoPreco,
      CodigoCliente,
      DataDesejadaRemessa,
      MoedaDocumento,

      NomeCliente,
      DiferencaCambio,
      StatusRemessa,
      DocFaturamento,
      DolarFaturamento,
      Moeda as MoedaFaturamento,
      DataFaturamento,
      Periodo,
      FaturaEstornada,
      CFOP,
      NotaFiscal,
      
      ValorComissaoUSD,
      TipoComissao,
      ValorUnitComissaoUSD,
      PrecoUnitario, //4 digitos
      
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ZCLSD_QUALITY_VE'
      virtual quality:abap.char(255),
      
//      @ObjectModel.virtualElement: true
//      @ObjectModel.virtualElementCalculatedBy: 'ZCLSD_QUALITY_VE'
//      virtual quality:abap.char( 255 ),
    
      CodigoCorretor,
      DescricaoCorretor,
      Paladar,
      Safra,
      RefBroker,
      MesPrevistoEmbarque,
      Diff,
      @Consumption.hidden: true
      ZZ1_DIF_SDHC,
      MesBolsa,
      ValorBolsa,
      PrecoFinalCTSLB,
      @Consumption.hidden: true
      ZZ1_PRICE_LB_SDHC,
      OpcaoFixacao,
      LotesFixados,
      QuantidadeLoteAFixar,
      AmostraRef,
      CourrierAWB_Nr,
      DataEnvioAmostra,
      DataAprovacao,
      TaxaDolarEmbarque,

      //VBAK
      DataEmbarque,
      Price50Kg,
      MoedaPriceKG,
      
      @Consumption.hidden: true
      MoedaWaerk,

      //EGT
      NumEmbarque,
      NumeroDUE,
      ChvAcessoDUE,
      DataRegistro,
      DataAverbacao,
      
      @ObjectModel.text.element: ['DescPstAlfanOrig']
      PstAlfanOrig,
      //@Consumption.hidden: true
      DescPstAlfanOrig,
      
      @ObjectModel.text.element: ['DescPstAlfanDest']
      PstAlfanDest,
      DescPstAlfanDest,
      PaisDestino,
      
      @ObjectModel.text.element: ['DescArmadorBLNum']
      ArmadorBLNum,
      DescArmadorBLNum,
      BLN,

      //CALC
      ValorLiquidoReais,
      ValorDiaEmbarque

      //MoedaReais
      //MoedaReais2
}
