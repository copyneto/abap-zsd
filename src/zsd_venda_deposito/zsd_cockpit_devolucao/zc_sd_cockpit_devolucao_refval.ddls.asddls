@EndUserText.label: 'Projection Cockpit Devolução Referenciar e Validar'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
define view entity ZC_SD_COCKPIT_DEVOLUCAO_REFVAL
  as projection on ZI_SD_COCKPIT_DEVOLUCAO_REFVAL
{
      @UI.hidden: true
  key Guid,
  key Item,
      LocalNegocio,
      @ObjectModel.text.element:['TipoDevText']
      TpDevolucao as TipoDevolucao,
      @UI.hidden: true
      TipoDevText,
      Regiao,
      Ano,
      Mes,
      @EndUserText.label: 'CNPJ/CPF'
      Cnpj,
      Modelo,
      Serie,
      @EndUserText.label: 'Nf-e'
      NumNFe,
      @EndUserText.label: 'Dígito verificador'
      DigitoVerific,
      Material,
      @EndUserText.label: 'Chave de Acesso'
      ChaveAcesso,
      UnMedida,
      TextoMaterial,
      CodEan,
      Quantidade,
      ValorUnit,
      CodMoeda,
      @UI.hidden: true
      @EndUserText.label: 'Data Lançamento'
      DtLancamento,
      Cliente,
      Centro,
      @EndUserText.label: 'Transportadora'
      Transportadora,
      @EndUserText.label: 'Motorista'
      Motorista,
      @ObjectModel.text.element: ['SDDocumentReasonText']
      Motivo,
      @EndUserText.label: 'Meio de pagamento'
      MeioPagamento,
      @UI.hidden: true
      Situacao,
      @Consumption.valueHelpDefinition: [{
      entity: { name: 'ZI_SD_VH_DOC_FAT_DEV',
      element: 'DocFaturamento' },
      additionalBinding: [ //{element: 'Moeda',            localElement: 'CodMoeda',            usage: #RESULT },
                           {element: 'SugestaoVal',        localElement: 'SugestaoValor',       usage: #RESULT },
                           {element: 'AceitaVal',          localElement: 'AceitaValores',       usage: #RESULT },
                           {element: 'ValorTotal',         localElement: 'TotalFatura',         usage: #RESULT },
                           {element: 'TotalBruto',         localElement: 'BrutoFatura',         usage: #RESULT },
                           {element: 'ValorUnitFatura',    localElement: 'ValorUnitFatura',     usage: #RESULT },
                           {element: 'UnVenda',            localElement: 'UnMedidaFatura',      usage: #RESULT },
      //                           {element: 'Quantidade',         localElement: 'Quantidade',          usage: #FILTER  },
                           {element: 'QuantidadePendente', localElement: 'QuantidadeFatura',    usage: #RESULT },
                           {element: 'Material',           localElement: 'Material',            usage: #FILTER },
                           {element: 'Centro',             localElement: 'Centro',              usage: #FILTER },
                           {element: 'Cliente',            localElement: 'Cliente',             usage: #FILTER },
                           {element: 'Nfe',                localElement: 'NFe',                 usage: #RESULT },
                           {element: 'DataFatura',         localElement: 'DataFatura',          usage: #RESULT },
                           {element: 'TipoDocNome',        localElement: 'BillingDocumentTypeName', usage: #RESULT },
                           {element: 'TipoDoc',            localElement: 'BillingDocumentType', usage: #RESULT },
                           {element: 'MotivoFatura',       localElement: 'SDDocumentReason',    usage: #RESULT },
                           {element: 'ItemFatura',         localElement: 'ItemFatura',          usage: #RESULT } ] }]
      Fatura,
      ItemFatura,
      @EndUserText.label: 'Nº da NF-e Venda'
      NFe,
      @EndUserText.label: 'Data da criação da fatura'
      DataFatura,
      UnMedidaFatura,
      @UI.hidden: true
      @EndUserText.label: 'Denominação de Item Fatura'
      TextoMaterialFatura,
      QuantidadeFatura,
      ValorUnitFatura,
      TotalFatura,
      BrutoFatura,
      AceitaValores,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,
      @UI.hidden: true
      SDDocumentReasonText,
      @ObjectModel.text.element:['BillingDocumentTypeName']
      BillingDocumentType,
      @UI.hidden: true
      BillingDocumentTypeName,
      @EndUserText.label: 'Motivo Fatura'
      @ObjectModel.text.element:['MotivoFaturaText']
      SDDocumentReason,
      @UI.hidden: true
      MotivoFaturaText,
      @EndUserText.label: 'Valor Sugerido'
      SugestaoValor,
      //      PeriodoDesde,
      //      PeriodoAte,

      /* Associations */
      _GeracaoDev : redirected to parent ZC_SD_COCKPIT_DEVOLUCAO_GERDEV
}
