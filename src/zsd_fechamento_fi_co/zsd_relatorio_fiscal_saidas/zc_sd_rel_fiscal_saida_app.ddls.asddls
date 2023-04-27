@EndUserText.label: 'CDS de projeção - Relatório Fiscal Saída'
@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true

//@UI.presentationVariant: [{
//     groupBy: [ 'NotaFiscal', 'ItemNF' ],
//     includeGrandTotal: true }]


define root view entity ZC_SD_REL_FISCAL_SAIDA_APP
  as projection on ZI_SD_REL_FISCAL_SAIDA_APP
{
          @EndUserText.label:'Nº Documento'
  key     NotaFiscal,
          @EndUserText.label:'Item NF'
  key     ItemNF,
          //     NumDocumento,
          @EndUserText.label:'Categ. NF'
          CategNF,
          @EndUserText.label:'Tipo documento (NF)'
          NFIsCreatedManually,
          @EndUserText.label:'N°Nota Fiscal'
          NumNF,
          //      NotaFiscal,
          @EndUserText.label:'Dt. Lançamento NF'
          DtLancamentoNF,
          @EndUserText.label:'Local de Negócios'
          LocalNegocios,
          @EndUserText.label:'Cliente'
          Cliente,
          @EndUserText.label:'Nome do Cliente'
          NomeCliente,
          @EndUserText.label:'UF Destino'
          UFDestino,
          @EndUserText.label:'Domicilio Fiscal'
          DomicilioFiscal,
          @EndUserText.label:'Escritorio de Vendas'
          EscritorioVendas,
          @EndUserText.label:'Grupo de Mercadorias'
          GrupoMercadorias,
          @EndUserText.label:'Valor IPI'
          ValorIPI,
          @EndUserText.label:'MVA'
          MVA,
          @EndUserText.label:'Contribuinte ICMS'
          ContribuinteICMS,
          j_1bicmstaxpayx,
          @EndUserText.label:'Material'
          Material,
          @EndUserText.label:'Descrição'
          Descricao,
          @EndUserText.label:'Peso bruto do material'
          MaterialGrossWeight,
          @EndUserText.label:'Peso unitário do material'
          MaterialWeightUnit,
          @EndUserText.label:'Frete'
          Frete,
          @EndUserText.label:'Município'
          Municipio,
          @EndUserText.label:'Qtd. Conf. NF Emitida'
          QtdConfNFEmitida,
          @EndUserText.label:'Un. Conf. NF Emitida'
          BaseUnit,
          @EndUserText.label:'Quantidade em KG'
          QuantityInBaseUnitKG,
          @EndUserText.label:'Unidade em KG'
          BaseUnitKG,
          @EndUserText.label:'Preço Unit. NF'
          PrecoUnitNF,
          @EndUserText.label:'Qtd. Un. Vda. Básica'
          QtdUnVdaBasica,
          @EndUserText.label:'CFOP'
          CFOP,
          @EndUserText.label:'Valor Total'
          //      @Aggregation.default  :#SUM
          Valor,
          @EndUserText.label:'Valor Produtos'
          ValorProdutos,
          @EndUserText.label:'ICMS IPI1'
          NFItemTaxAmountIPI1,
          @EndUserText.label:'Desc. Farelo'
          DescFarelo,
          @EndUserText.label:'Base ICMS'
          BaseICMS,
          @EndUserText.label:'Valor ICMS'
          ValorICMS,
          @EndUserText.label:'Base Substituição Tributária'
          BaseST,
          @EndUserText.label:'Valor Substituição Tributária'
          ValorST,
          @EndUserText.label:'Base IPI'
          BaseIPI,
          @EndUserText.label:'PIS'
          PIS,
          @EndUserText.label:'COFINS'
          COFINS,
          @EndUserText.label:'ICMS ICEP'
          ICMS_ICEP,
          @EndUserText.label:'ICMS ICAP'
          ICMS_ICAP,
          @EndUserText.label:'ICMS ICSP'
          ICMS_ICSP,
          @EndUserText.label:'Cod. Benef.'
          CodBenef,
          @EndUserText.label:'ICMS Deson'
          ICMSDeson,
          @EndUserText.label:'Situação Tributária ICMS'
          ST_ICMS,
          @EndUserText.label:'Lei Fiscal ICMS'
          LF_ICMS,
          @EndUserText.label:'Tipo Principal de Setor Ind'
          SetorIndustrial,
          @EndUserText.label:'Desc. Setor Ind.'
          DescTipPrinInd,
          @EndUserText.label:'Insc. Estadual'
          InscEstadual,
          @EndUserText.label:'Segmento'
          Segmento,
          @EndUserText.label:'Criador por'
          UserCriador,
          //      @ObjectModel.text.element: ['DescSitDoc']
          @EndUserText.label:'Cód. Sit. Doc'
          CodSitDoc,
          DescSitDoc,
          @EndUserText.label:'Base Dif. Alíquotas'
          BaseDifAliquotas,
          @EndUserText.label:'Valor Dif. Alíquotas'
          ValorDifAliquotas,
          //      @ObjectModel.text.element: ['AreaName']
          @EndUserText.label:'Centro'
          Area,
          AreaName,
          @EndUserText.label:'IVA'
          IVA,
          @EndUserText.label:'Lei Fiscal IPI'
          LF_IPI,
          @EndUserText.label:'Situação Tributária IPI'
          ST_IPI,
          @EndUserText.label:'Lei Fiscal COF'
          LF_COF,
          @EndUserText.label:'Situação Tributária COF'
          ST_COF,
          @EndUserText.label:'Lei Fiscal PIS'
          LF_PIS,
          @EndUserText.label:'Situação Tributária PIS'
          ST_PIS,
          @EndUserText.label:'Centro de Custos'
          CentroCustos,
          @EndUserText.label:'Lote'
          Lote,
          @EndUserText.label:'CPF'
          CPF,
          @EndUserText.label:'Preço Custo Unit.'
          PrecoCustoUnitario,
          @EndUserText.label:'Preço Custo Total'
          PrecoCustoTotal,
          @EndUserText.label:'Vl. Un. Prd. Conf. NF'
          VlUnPrdConfNF,
          @EndUserText.label:'Vl. Tot. Prd. Conf. NF'
          VlTotalUnPrdConfNF,
          @EndUserText.label:'Conta'
          Conta,
          @EndUserText.label:'Desc. Conta'
          DescConta,
          @EndUserText.label:'NCM'
          NCM,
          @EndUserText.label:'Tipo de Avaliação'
          TipoAvaliacao,
          @EndUserText.label:'Ordem de Venda'
          OrdemVenda,
          @EndUserText.label:'Org. Vendas'
          OrgVendas,
          @EndUserText.label:'Canal Distrib.'
          CanalDistrib,
          @EndUserText.label:'Empresa'
          Empresa,
          @EndUserText.label:'Setor de Atividade'
          SetorAtividade,
          @EndUserText.label:'Motivo da Ordem'
          MotivoOrdem,
          @EndUserText.label:'Isentos ICMS'
          IsentosICMS,
          @EndUserText.label:'Outras ICMS'
          OutrasICMS,
          @EndUserText.label:'Isentos IPI'
          IsentosIPI,
          @EndUserText.label:'Outras IPI'
          OutrasIPI,
          @EndUserText.label:'Origem Material'
          OrigemMaterial,
          @EndUserText.label:'Tipo de Doc. de Vendas'
          TipoDocVendas,
          @EndUserText.label:'Num. Doc. Original NF'
          NumdocOriginalNF,
          @EndUserText.label:'Num. Doc. Original Item'
          NumdocOriginalItem,
          @EndUserText.label:'Região Emissor'
          RegiaoEmissor,
          @EndUserText.label:'Ano NFe'
          BR_NFeIssueYear,
          @EndUserText.label:'Mês doc. NFe'
          BR_NFeIssueMonth,
          @EndUserText.label:'Nº CNPJ/CPF emissor'
          BR_NFeAccessKeyCNPJOrCPF,
          @EndUserText.label:'Modelo da NFe'
          BR_NFeModel,
          @EndUserText.label:'Série NFe'
          BR_NFeSeries,
          @EndUserText.label:'Número NFe'
          BR_NFeNumber,
          @EndUserText.label:'Num. Aleatório NFe'
          BR_NFeRandomNumber,
          @EndUserText.label:'Dígito de controle NFe'
          BR_NFeCheckDigit,
          @EndUserText.label:'Data Saída NF'
          DataSaidaNF,
          @EndUserText.label:'Cód. SUFRAMA'
          CodSuframa,
          @EndUserText.label:'Tipo de Declaração de Imposto'
          TipoDeclaracaoImposto,
          @EndUserText.label:'Base ICMS FCP'
          BaseICMS_FCP,
          @EndUserText.label:'Valor ICMS FCP'
          ValorICMS_FCP,
          @EndUserText.label:'Base ST FCP'
          BaseST_FCP,
          @EndUserText.label:'Valor ST FCP'
          ValorST_FCP,
          @EndUserText.label:'Texto D.F. ICMS 1'
          TextoDFICMS1,
          @EndUserText.label:'Texto D.F. ICMS 2'
          TextoDFICMS2,
          @EndUserText.label:'Texto D.F. ICMS 3'
          TextoDFICMS3,
          @EndUserText.label:'Texto D.F. IPI'
          TextoDFIPI,
          @EndUserText.label:'Base ICMS ST b.'
          BaseICMS_STReemb,
          @EndUserText.label:'Valor ICMS ST bolso'
          IcmsStReembolso,
          @EndUserText.label:'ST Entrada'
          StEntrada,
          @EndUserText.label:'Un. Vda. Básica'
          UnVdaBasica,
          @EndUserText.label:'Peso Bruto NF'
          PesoBrutoNF,
          @EndUserText.label:'Modelo NF'
          ModeloNF,
          @EndUserText.label:'Desc. Tip. Prin. Ind.'
          DescSetorInd,
          @EndUserText.label:'Valor ICMS sem Benef.'
          ValorICMSsemBenef,
          @EndUserText.label:'Gtin'
          Gtin,
          @EndUserText.label:'Doc. Rem.'
          DocRem,
          @EndUserText.label:'Doc. Migo'
          DocMigo,
          @EndUserText.label:'Doc. Faturamento'
          DocFaturamento,
          @EndUserText.label:'Cód. Imp. SD'
          CodImpSD,
          @EndUserText.label:'CNPJ'
          CNPJ,
          @EndUserText.label:'Valor Base Cal. sem Benef.'
          ValorBaseCalsemBenef,
          @EndUserText.label:'Ano Migo'
          AnoMigo,
          @EndUserText.label:'Aliq. IPI'
          AliqIPI,
          @EndUserText.label:'Emissor Ordem'
          EmissorOrdem,
          @EndUserText.label:'Valor sem frete'
          ValorsemFrete,
          @EndUserText.label:'Cod. Reg. Trib. Num.'
          CodRegTribNum,
          @EndUserText.label:'Moeda do documento SD'
          SalesDocumentCurrency,
          @EndUserText.label:'Desc. Incond'
          DescIncond,
          @EndUserText.label:'ICMS Zona Franca'
          ICMS_ZN,
          @EndUserText.label:'Chave de Acesso'
          ChaveAcesso,
          @EndUserText.label:'Tipo Setor ind.'
          DescontoInd,
          @EndUserText.label:'Valor ICMS ST FCP Reembolso'
          IcmsStFCPReembolso,
          @EndUserText.label:'Base ICMS ST FCP Reembolso'
          BaseICMS_STFCPReemb,
          @EndUserText.label:'Despesas'
          despesa,
          @EndUserText.label:'Aliq. ICMS'
          AliqICMS
}
