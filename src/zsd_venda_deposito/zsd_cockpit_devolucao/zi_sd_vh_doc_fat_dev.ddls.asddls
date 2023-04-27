@AbapCatalog.sqlViewName: 'ZISD_DOCFATDEV'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help Documento Faturamento'
@Search.searchable: true
define view ZI_SD_VH_DOC_FAT_DEV
  as select from ZI_SD_COCKPIT_DEVOLUCAO_DOCFAT as _DocFat
{
       @Search.defaultSearchElement: true
       @Search.ranking: #HIGH
  key  _DocFat.DocFaturamento           as DocFaturamento,
       @Search.defaultSearchElement: true
       @Search.ranking: #HIGH
  key  _DocFat.Item                     as ItemFatura,
       //       @Consumption.valueHelpDefinition: [{entity: {name: 'ZI_CA_VH_FKART', element: 'BillingDocumentType' }}]
       @EndUserText.label: 'Tipo Documento de Faturamento'
       //       @ObjectModel.text.association: 'TipoDocNome'
       TipoDoc,
       @EndUserText.label: 'Motivo Fatura'
       MotivoFatura,
       @Consumption.filter.hidden: true
       @EndUserText.label: 'Motivo Fatura Desc.'
       MotivoFaturaText,
       @Consumption.filter.hidden: true
       @EndUserText.label: 'Descrição Tipo Doc. de Faturamento'
       TipoDocNome,
       @Consumption.filter: { selectionType: #INTERVAL,
                              multipleSelections: false }

       @EndUserText.label: 'Data da criação da fatura'
       _DocFat.DataDoc                  as DataFatura,
       @EndUserText.label: 'Nº da NF-e Venda'
       @Search.defaultSearchElement: true
       _DocFat.Nfe,
       @EndUserText.label: 'Cliente'
       _DocFat.Cliente,
       @EndUserText.label: 'Centro'
       _DocFat.Centro,
       _DocFat.Ean,
       _DocFat.Material,
       @EndUserText.label: 'Material'
       @Consumption.filter.hidden: true
       _DocFat.Material                 as MaterialFat,
       _DocFat.TextoMat,
       @EndUserText.label: 'Quantidade Pendente'
       _DocFat.QuantidadePendente,
       _DocFat.Quantidade,
       //       @Consumption.filter.hidden: true
       //       _DocFat.Quantidade     as QuantidadeFat,
       _DocFat.UnMedida,

       _DocFat.UnVenda,
       //       @EndUserText.label: 'Valor un. cliente'
       //       _DocFat.UnitCliente,
       @EndUserText.label: 'Valor Total'
       _DocFat.ValorTotal,
       @EndUserText.label: 'Valor Unitário'
       _DocFat.ValorUnit                as ValorUnitFatura,
       _DocFat.MoedaSd,
       @EndUserText.label: 'Valor Bruto'
       _DocFat.TotalBruto,
       //       @EndUserText.label: 'Período Desde'
       //       @Consumption.filter: { selectionType:      #SINGLE,
       //                              multipleSelections: false }
       //       @Search.defaultSearchElement: true
       //       _DocFat.PeriodoDesde,
       //       @EndUserText.label: 'Período Até'
       //       @Consumption.filter: { selectionType:      #SINGLE,
       //                              multipleSelections: false }
       //       @Search.defaultSearchElement: true
       //       _DocFat.PeriodoAte
       @UI.hidden: true
       cast( ' ' as flag )              as AceitaVal,
       @UI.hidden: true
       cast( '0' as abap.dec( 15,2 )  ) as SugestaoVal
}
where
  FaturaDev = ''
