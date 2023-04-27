@EndUserText.label: 'Projection seleção coligados'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@Search.searchable: true
define root view entity ZC_SD_01_COCKPIT
  as projection on zi_sd_01_cockpit
{
          @EndUserText: {label: 'Guid', quickInfo: 'Chave única gerada automaticamente'}
  key     Guid,
          @Consumption.valueHelpDefinition:
            [{ entity:{ name: 'ZI_SD_VH_PROCESSO', element : 'Processo' },
               additionalBinding: [{ element: 'Ekorg',   localElement: 'ekorg',   usage: #RESULT },
                                   { element: 'Ekgrp',   localElement: 'ekgrp',   usage: #RESULT }]}]
          @EndUserText: {label: 'Processo', quickInfo: 'Processo'}
          @ObjectModel.text.element: ['ProcessoName']
          @UI.textArrangement: #TEXT_LAST
          Processo,
          @Consumption.valueHelpDefinition:
            [{ entity:{ name: 'ZI_SD_VH_PROCESSO_TPOPER', element : 'TpOper' },
               additionalBinding: [{ element: 'Processo', localElement: 'Processo', usage: #FILTER_AND_RESULT },
                                   { element: 'CondExp',  localElement: 'CondExp',  usage: #RESULT }]}]
          @EndUserText: {label: 'Tipo Operação', quickInfo: 'Tipo de Operação'}
          @ObjectModel.text.element: ['TpOperName']
          @UI.textArrangement: #TEXT_LAST
          TipoOperacao,
          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
          @EndUserText: {label: 'Centro Origem', quickInfo: 'Centro de Origem'}
          @ObjectModel.text.element: ['WerksOrigemName']
          @UI.textArrangement: #TEXT_LAST
          Werks_Origem,
          @Consumption.valueHelpDefinition:
            [{ entity:{ name: 'ZI_CA_VH_LGORT', element : 'StorageLocation' },
               additionalBinding: [{ element: 'Plant', localElement: 'Werks_Origem', usage: #FILTER_AND_RESULT }]}]
          @EndUserText: {label: 'Dep.Origem', quickInfo: 'Depósito de Origem'}
          @ObjectModel.text.element: ['LgortOrigemName']
          @UI.textArrangement: #TEXT_LAST
          Lgort_Origem,
          @Search.defaultSearchElement: true
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
          @EndUserText: {label: 'Centro Destino', quickInfo: 'Centro de Destino'}
          @ObjectModel.text.element: ['WerksDestinoName']
          @UI.textArrangement: #TEXT_LAST
          Werks_Destino,
          @Consumption.valueHelpDefinition:
            [{ entity:{ name: 'ZI_CA_VH_LGORT', element : 'StorageLocation' },
               additionalBinding: [{ element: 'Plant', localElement: 'Werks_Destino', usage: #FILTER_AND_RESULT }]}]
          @EndUserText: {label: 'Dep.Destino', quickInfo: 'Depósito de Destino'}
          @ObjectModel.text.element: ['LgortDestinoName']
          @UI.textArrangement: #TEXT_LAST
          Lgort_Destino,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'Zi_ca_vh_werks', element : 'WerksCode' }}]
          @EndUserText: {label: 'Centro Receptor', quickInfo: 'Centro Receptor'}
          @ObjectModel.text.element: ['WerksReceptorName']
          @UI.textArrangement: #TEXT_LAST
          Werks_Receptor,
          @Search.defaultSearchElement: true
          @EndUserText: {label: 'Ordem Venda', quickInfo: 'Ordem de Venda'}
          SalesOrder,
          @Search.defaultSearchElement: true
          @EndUserText: {label: 'Pedido Compra', quickInfo: 'Pedido de Compra'}
          PurchaseOrder,
          @EndUserText: {label: 'Docnum Saída', quickInfo: 'NF DOCNUM'}
          br_notafiscal,
          @EndUserText: {label: 'NFe Saída', quickInfo: 'Nota Fiscal Eletrônica'}
          BR_NFeNumber,
          @Search.defaultSearchElement: true
          @EndUserText: {label: 'Dt. Documento', quickInfo: 'Data do Documento'}
          Creationdate,
          @EndUserText: {label: 'Remessa', quickInfo: 'Documento de Remessa'}
          Remessa,
          @EndUserText: {label: 'Placa', quickInfo: 'Placa Principal'}
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_PLACAS', element : 'Placa' }}]
          Ztraid,
          @EndUserText: {label: 'Placa Semireb.1', quickInfo: 'Placa do semireboque 1'}
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_PLACAS', element : 'Placa' }}]
          Ztrai1,
          @EndUserText: {label: 'Placa Semireb.2', quickInfo: 'Placa do semireboque 2'}
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_PLACAS', element : 'Placa' }}]
          Ztrai2,
          @EndUserText: {label: 'Placa Semireb.3', quickInfo: 'Placa do semireboque 3'}
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_PLACAS', element : 'Placa' }}]
          Ztrai3,
          @EndUserText: {label: 'Ord. Frete', quickInfo: 'Ordem de Frete'}
          Docnuv,
          @EndUserText: {label: 'Bloqueio Remessa', quickInfo: 'Bloqueio de Remessa'}
          @ObjectModel.text.element: ['DeliveryBlockReasonText']
          DeliveryBlockReason,
          @EndUserText: {label: 'Stat.Pick.', quickInfo: 'Status global do picking'}
          @ObjectModel.text.element: ['OverallSDProcessStatusDesc']
          OverallPickingStatus,
          @EndUserText: {label: 'Stat.Pick.', quickInfo: 'Status Remessa'}
          OverallGoodsMovementStatus,
          @EndUserText: {label: 'Fatura', quickInfo: 'Documento de Fatura'}
          Docfat,
          @EndUserText: {label: 'Pedido Etapa 2', quickInfo: 'Pedido da Segunda Etapa'}
          Correspncexternalreference,
          @EndUserText: {label: 'Ord. Vend. Etapa 2', quickInfo: 'Ordem de Venda Segunda Etapa'}
          SalesOrder2,
          @EndUserText: {label: 'St.NFe', quickInfo: 'Status NF-e'}
          @ObjectModel.text.element: ['BR_NFeDocumentStatusDesc']
          @UI.textArrangement: #TEXT_FIRST
          br_nfedocumentstatus,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_MDFRETE', element : 'mdFrete' }}]
          @EndUserText: {label: 'Incoterms', quickInfo: 'Incoterms'}
          @ObjectModel.text.element: ['TpFreteDesc']
          @UI.textArrangement: #TEXT_FIRST
          Tpfrete,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_LIFNR', element : 'LifnrCode' }}]
          @ObjectModel.text.element: ['AgfreteName']
          @EndUserText: {label: 'Agente Frete', quickInfo: 'Agente de Frete'}
          Agfrete,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_KUNNR', element : 'Kunnr' }}]
          @EndUserText: {label: 'Motorista', quickInfo: 'Motorista do Frete'}
          @ObjectModel.text.element: ['MotoristaName']
          Motora,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_VSART', element : 'TipoExpedicao' }}]
          @ObjectModel.text.element: ['TpexpText']
          @EndUserText: {label: 'Tipo Expedição', quickInfo: 'Tipo de Expedição'}
          Tpexp,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_CA_VH_VSBED', element : 'CondicaoExpedicao' }}]
          @ObjectModel.text.element: ['CondExpText']
          @EndUserText: {label: 'Condição Expedição', quickInfo: 'Condição de Expedição'}
          CondExp,
          @EndUserText: {label: 'Textos para NF-e', quickInfo: 'Textos para NF-e'}
          Txtnf,
          @EndUserText: {label: 'Textos Gerais', quickInfo: 'Textos Gerais'}
          Txtgeral,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_SD_VH_FRACIONADO', element : 'Fracionado' }}]
          @EndUserText: {label: 'Fracionado', quickInfo: 'Fracionado'}
          @ObjectModel.text.element: ['FracionadoText']
          @UI.textArrangement: #TEXT_FIRST
          Fracionado,
          @EndUserText: {label: 'ID 3Cargo', quickInfo: 'ID 3Cargo'}
          IdSaga,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_PurchaseOrgVH', element : 'ResponsiblePurchaseOrg' }}]
          @EndUserText: {label: 'Organização de Compras', quickInfo: 'Organização de Compras'}
          @ObjectModel.text.element: ['PurchOrgName']
          //          @UI.textArrangement: #TEXT_LAST
          ekorg,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_PurchasingGroup', element : 'PurchasingGroup' }}]
          @EndUserText: {label: 'Grupo de Compradores', quickInfo: 'Grupo de Compradores'}
          @ObjectModel.text.element: ['PurchGrpName']
          //          @UI.textArrangement: #TEXT_LAST
          ekgrp,
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_MatlUsageIndicator', element : 'MatlUsageIndicator' }}]
          @EndUserText: {label: 'Utilização (Grão Verde)', quickInfo: 'Código de Utilização (Grão verde)'}
          @ObjectModel.text.element: ['UtilizacaoText']
          abrvw,
          @EndUserText: {label: 'Docnum Entrada', quickInfo: 'Nota Fiscal de Entrada'}
          nfentrada,
          @EndUserText: {label: 'NFe Entrada', quickInfo: 'Nota Fiscal Eletrônica de Entrada'}
          BR_NFeNumberEntrada,
          @EndUserText: {label: 'Remessa de Transferência - Devolução', quickInfo: 'Remessa de Origem'}
          RemessaOrigem,
          @EndUserText: {label: 'Desc. Processo', quickInfo: 'Descrição do Processo'}
          @Semantics.text: true
          _Processo.Text                       as ProcessoName,
          @EndUserText: {label: 'Desc. Tipo Operação', quickInfo: 'Descrição do Tipo de Operação'}
          @Semantics.text: true
          _TipoOperacao.Nome                   as TpOperName,
          @EndUserText: {label: 'Nome Centro Origem', quickInfo: 'Nome do Centro de Origem'}
          @Semantics.text: true
          _WerksOrigem.PlantName               as WerksOrigemName,
          @EndUserText: {label: 'Nome Depósito Origem', quickInfo: 'Nome do Depósito de Origem'}
          @Semantics.text: true
          _LgortOrigem.StorageLocationName     as LgortOrigemName,
          @EndUserText: {label: 'Nome Centro Destino', quickInfo: 'Nome do Centro de Destino'}
          @Semantics.text: true
          _WerksDestino.PlantName              as WerksDestinoName,
          @EndUserText: {label: 'Nome Depósito Destino', quickInfo: 'Nome do Depósito de Destino'}
          @Semantics.text: true
          _LgortOrigem.StorageLocationName     as LgortDestinoName,
          @EndUserText: {label: 'Nome Centro Receptor', quickInfo: 'Nome do Centro de Receptor'}
          @Semantics.text: true
          _WerksReceptor.PlantName             as WerksReceptorName,
          @EndUserText: {label: 'Nome Org. Compras', quickInfo: 'Nome da Organização de Compras'}
          _PurchOrg.PurchasingOrganizationName as PurchOrgName,
          @EndUserText: {label: 'Nome Grp. Compradores', quickInfo: 'Nome do Grupo de Compradores'}
          _PurchGrp.PurchasingGroupName        as PurchGrpName,
          @EndUserText: {label: 'Desc. Utilização (Grão Verde)', quickInfo: 'Descrição da Utilização (Grão Verde)'}
          _Utilizacao.MatlUsageIndicatorText   as UtilizacaoText,
          @EndUserText: {label: 'Desc. Tipo Exped.', quickInfo: 'Descrição do Tipo de Expedição'}
          _TipoExped.bezei                     as TpexpText,
          @EndUserText: {label: 'Desc. Cond. Exped.', quickInfo: 'Descrição da Condição de Expedição'}
          _CondExped.CondicaoExpedicaoText     as CondExpText,
          @EndUserText: {label: 'Nome Agente Frete', quickInfo: 'Nome do Agente de Frete'}
          _AgenteFrete.name1                   as AgfreteName,
          @EndUserText: {label: 'Nome Motorista', quickInfo: 'Nome do Motorista'}
          _Motorista.KunnrName                 as MotoristaName,
          @EndUserText: {label: 'Desc. Bloqueio Remessa', quickInfo: 'Descrição do Bloqueio de Remessa'}
          _DeliveryBlockReason.DeliveryBlockReasonText,
          @EndUserText: {label: 'Desc. Status NFe', quickInfo: 'Descrição do Status da NFe'}
          BR_NFeDocumentStatusDesc,
          @EndUserText: {label: 'Desc. Incoterms', quickInfo: 'Descrição do Incoterms'}
          _TpFreteText.Nome                    as TpFreteDesc,
          @EndUserText: {label: 'Desc. Status Picking', quickInfo: 'Descrição do Status de Picking'}
          _StatusPickingText.OverallSDProcessStatusDesc,
          @EndUserText: {label: 'Texto Fracionado', quickInfo: 'Texto do Fracionado'}
          _Fracionado.Text                     as FracionadoText,
          @EndUserText: {label: 'Nome Usuário Criador', quickInfo: 'Nome do Usuário Criador'}
          _CreatedByUser.FullName              as CreatedByName,
          @EndUserText: {label: 'Nome Último Modificador', quickInfo: 'Nome do Último Usuário Modificador'}
          _ChangedByUser.FullName              as ChangedByName,
          @EndUserText: {label: 'Criticidade Documento Principal', quickInfo: 'Criticidade do documento Principal'}
          DocPrinCritic,

          @EndUserText: {label: 'Código Bloqueio', quickInfo: 'Código do Bloqueio de Remessa'}
          @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_MM_VH_MOTIVO_BLOQ_REMESSA', element : 'DeliveryBlockReason' }}]
          DelivBlockReason,

          @EndUserText: {label: 'Criado por', quickInfo: 'Criado por'}
          @ObjectModel.text.element: ['CreatedByName']
          CreatedBy,
          @EndUserText: {label: 'Criado em', quickInfo: 'Criado em'}
          @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
          CreatedAtDate,
          @EndUserText: {label: 'Modificado por', quickInfo: 'Modificado por'}
          @ObjectModel.text.element: ['ChangedByName']
          LastChangedBy,
          @EndUserText: {label: 'Modificado em', quickInfo: 'Modificado em'}
          @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
          LastChangedAtDate,
          @EndUserText: {label: 'Última Modificação', quickInfo: 'Última Modificação'}
          @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
          LocalLastChangedAt,
          @EndUserText: {label: 'Ocultar PO', quickInfo: 'Ocultar Pedido de Compras'}
          HiddenPO,
          @EndUserText: {label: 'Ocultar SO', quickInfo: 'Ocultar Ordem de Venda'}
          HiddenSO,
          @EndUserText: {label: 'Ocultar Remessa', quickInfo: 'Ocultar Remessa'}
          HiddenRemessa,
          @EndUserText: {label: 'Ocultar Fatura', quickInfo: 'Ocultar Fatura'}
          HiddenFatura,
          @EndUserText: {label: 'Ocultar NF Saída', quickInfo: 'Ocultar NF Saída'}
          HiddenNFOut,
          @EndUserText: {label: 'Ocultar Ordem Frete', quickInfo: 'Ocultar Ordem de Frete'}
          HiddenOF,
          @EndUserText: {label: 'Ocultar NF Entrada', quickInfo: 'Ocultar NF de Entrada'}
          HiddenNFInb,

          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_me23n        : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_va03         : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_vl03n        : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_vf03         : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_J1B3N        : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_me23_2       : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_VL03N_INB    : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_J1B3N_INB    : eso_longtext,
          @ObjectModel: { virtualElement: true,
                          virtualElementCalculatedBy: 'ABAP:ZCLSD_CREATE_URL' }
  virtual URL_FreightOrder : eso_longtext,


          _Material : redirected to composition child ZC_SD_02_ITEM,
          _Log      : redirected to composition child ZC_SD_05_LOG
}
