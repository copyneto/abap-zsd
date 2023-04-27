@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Relatório analítico de Notas Fiscais de Devolução'

define root view entity ZI_SD_BR_REL_ANALITICO_DEVOLUC
  //Item da nota de devolução
  as select from    I_BR_NFItem_C                 as NFItemDev
  //NF de faturamento da NF de devolução
    left outer join C_BR_VerifyNotaFiscal         as _NFVerifDev          on NFItemDev.BR_NotaFiscal = _NFVerifDev.BR_NotaFiscal

  //FlowDoc Dev para referência da saída(Inv)
    left outer join I_BR_NFDocumentFlow_C         as _NFFlowDev           on  NFItemDev.BR_NotaFiscal     = _NFFlowDev.BR_NotaFiscal
                                                                          and NFItemDev.BR_NotaFiscalItem = _NFFlowDev.BR_NotaFiscalItem

  //Item da nota fiscal de Saída
    left outer join I_BR_NFItem_C                 as _NFItemInv           on  _NFFlowDev.BR_ReferenceNFNumber = _NFItemInv.BR_NotaFiscal
                                                                          and NFItemDev.BR_NotaFiscalItem     = _NFItemInv.BR_NotaFiscalItem
                                                                          and NFItemDev.Material              = _NFItemInv.Material
  //Conversões de quantidades
    left outer join ZI_SD_CONVERT_QUANTITY_TO_UMB as _ConvertDev          on  NFItemDev.BR_NotaFiscal     = _ConvertDev.NumeroDocumento
                                                                          and NFItemDev.BR_NotaFiscalItem = _ConvertDev.NumeroDocumentoItem

    left outer join ZI_SD_CONVERT_QUANTITY_TO_UMB as _ConvertInv          on  _NFItemInv.BR_NotaFiscal     = _ConvertInv.NumeroDocumento
                                                                          and _NFItemInv.BR_NotaFiscalItem = _ConvertInv.NumeroDocumentoItem

  //NF de faturamento da NF de Saída
    left outer join C_BR_VerifyNotaFiscal         as _NFVerifInv          on _NFItemInv.BR_NotaFiscal = _NFVerifInv.BR_NotaFiscal
  //ItemFrete Inv
    left outer join ZI_SD_NF_ITEMS                as _TransportItemInv    on _NFFlowDev.BR_ReferenceNFNumber = _TransportItemInv.Docnum
  //Detalhes frete
  //  left outer join I_TransportationOrder         as _TransportInv        on _TransportItemInv.Tor_id = _TransportInv.TransportationOrder
  //Motorista Inv
    left outer join ZI_TM_GESTAO_FROTA_DRIVER     as _DriverInv           on _DriverInv.FreightOrder = concat(
      '0000000000', _TransportItemInv.Tor_id
    )

  //Vendedor
    left outer join I_SalesDocumentPartner        as _SupplierInvOvInv    on  _NFItemInv.OriginReferenceDocument = _SupplierInvOvInv.SalesDocument
                                                                          and _SupplierInvOvInv.PartnerFunction  = 'ZE'
  //Detalhes Vendedor
    left outer join I_Supplier                    as _SupplierInv         on _SupplierInvOvInv.Supplier = _SupplierInv.Supplier

  //Item do Faturamento da NF de faturamento da NF de Dev
    left outer join I_BillingDocumentItem         as _NFBillingDocItemDev on  _NFVerifDev.ReferenceDocument = _NFBillingDocItemDev.BillingDocument
                                                                          and NFItemDev.BR_NotaFiscalItem   = _NFBillingDocItemDev.BillingDocumentItem

  //Item do Faturamento da NF de faturamento da NF de saída
    left outer join I_BillingDocumentItem         as _NFBillingDocItemInv on  _NFVerifInv.ReferenceDocument = _NFBillingDocItemInv.BillingDocument
                                                                          and _NFItemInv.BR_NotaFiscalItem  = _NFBillingDocItemInv.BillingDocumentItem

  //Ordem Dev
    left outer join I_CustomerReturn              as _CustomerReturnDev   on _NFBillingDocItemDev.SalesDocument = _CustomerReturnDev.CustomerReturn

    left outer join ZI_SD_MOTIVOS_RESPONSAVEIS    as _MotivosOrdemDev     on _CustomerReturnDev.SDDocumentReason = _MotivosOrdemDev.Augru

    left outer join ZI_CA_VH_HIERARQUIA_PROD      as _HierarquiaProd      on _HierarquiaProd.HierProd = left(
      _NFBillingDocItemDev.ProductHierarchyNode, 5
    )

  //Descrição Direção
  association [0..1] to ZI_CA_VH_DIRECAO_NF    as _NFDirectionDev       on $projection.DirectionDev = _NFDirectionDev.BR_NFDirection

  //Cabeçalho Dev
  association [1..1] to I_BR_NFDocument        as _NFDev                on $projection.BR_NotaFiscal = _NFDev.BR_NotaFiscal

  association [1..1] to I_BR_BusinessPlace_C   as _BusinessPlaceDev     on (
         _BusinessPlaceDev.Branch          = $projection.BusinessPlaceDev
         and _BusinessPlaceDev.CompanyCode = _NFVerifDev.CompanyCode
       )


  //Cabeçalho Inv
  association [1..1] to I_BR_NFDocument        as _NFInv                on $projection.NFInv = _NFInv.BR_NotaFiscal

  //Ordem de Saída
  association [1..1] to I_SalesOrder           as _SalesOrderInv        on _NFItemInv.OriginReferenceDocument = _SalesOrderInv.SalesOrder

  //Ordem de Saída Item
  association [0..1] to I_SalesDocumentItem    as _SalesDocumentItemInv on (
     _NFItemInv.OriginReferenceDocument     = _SalesDocumentItemInv.SalesDocument
     and $projection.NFItemDev              = _SalesDocumentItemInv.SalesDocumentItem
   )

  //Vendedor Saída
  association [0..1] to I_BuPaIdentification   as _BPVendedorIdentInv   on (
       $projection.SupplierInv                      = _BPVendedorIdentInv.BusinessPartner
       and _BPVendedorIdentInv.BPIdentificationType = 'MATRIC'
     )

  //Motorista Saída
  association [0..1] to I_BuPaIdentification   as _BPMotoristaInv       on (
           $projection.DriverInv                    = _BPMotoristaInv.BusinessPartner
           and _BPMotoristaInv.BPIdentificationType = 'MATRIC'
         )

  //Detalhes material Dev
  association [1..1] to I_Material             as _MaterialDev          on $projection.MaterialDev = _MaterialDev.Material

  //Detalhes material Dev
  association [1..1] to I_Material             as _MaterialInv          on $projection.MaterialInv = _MaterialInv.Material

  //Impostos Dev
  association [0..1] to I_BR_NFItemTaxByItem_C as _ICMSDev              on (
                  $projection.BR_NotaFiscal = _ICMSDev.BR_NotaFiscal
                  and $projection.NFItemDev = _ICMSDev.BR_NotaFiscalItem
                  and _ICMSDev.TaxGroup     = 'ICMS'
                )

  association [0..1] to I_BR_NFItemTaxByItem_C as _IPIDev               on (
                   $projection.BR_NotaFiscal = _IPIDev.BR_NotaFiscal
                   and $projection.NFItemDev = _IPIDev.BR_NotaFiscalItem
                   and _IPIDev.TaxGroup      = 'IPI'
                 )

  association [0..1] to I_BR_NFItemTaxByItem_C as _ICSTDev              on (
                  $projection.BR_NotaFiscal = _ICSTDev.BR_NotaFiscal
                  and $projection.NFItemDev = _ICSTDev.BR_NotaFiscalItem
                  and _ICSTDev.TaxGroup     = 'ICST'
                )

  association [0..1] to I_BR_NFItemTaxByItem_C as _PISDev               on (
                   $projection.BR_NotaFiscal = _PISDev.BR_NotaFiscal
                   and $projection.NFItemDev = _PISDev.BR_NotaFiscalItem
                   and _PISDev.TaxGroup      = 'PIS'
                 )

  association [0..1] to I_BR_NFItemTaxByItem_C as _COFIDev              on (
                  $projection.BR_NotaFiscal = _COFIDev.BR_NotaFiscal
                  and $projection.NFItemDev = _COFIDev.BR_NotaFiscalItem
                  and _COFIDev.TaxGroup     = 'COFI'
                )

  //Impostos Inv
  association [0..1] to I_BR_NFItemTaxByItem_C as _ICMSInv              on (
                  $projection.NFInv         = _ICMSInv.BR_NotaFiscal
                  and $projection.NFItemInv = _ICMSInv.BR_NotaFiscalItem
                  and _ICMSInv.TaxGroup     = 'ICMS'
                )

  association [0..1] to I_BR_NFItemTaxByItem_C as _IPIInv               on (
                   $projection.NFInv         = _IPIInv.BR_NotaFiscal
                   and $projection.NFItemInv = _IPIInv.BR_NotaFiscalItem
                   and _IPIInv.TaxGroup      = 'IPI'
                 )

  association [0..1] to I_BR_NFItemTaxByItem_C as _ICSTInv              on (
                  $projection.NFInv         = _ICSTInv.BR_NotaFiscal
                  and $projection.NFItemInv = _ICSTInv.BR_NotaFiscalItem
                  and _ICSTInv.TaxGroup     = 'ICST'
                )

  association [0..1] to I_BR_NFItemTaxByItem_C as _PISInv               on (
                   $projection.NFInv         = _PISInv.BR_NotaFiscal
                   and $projection.NFItemInv = _PISInv.BR_NotaFiscalItem
                   and _PISInv.TaxGroup      = 'PIS'
                 )

  association [0..1] to I_BR_NFItemTaxByItem_C as _COFIInv              on (
                  $projection.NFInv         = _COFIInv.BR_NotaFiscal
                  and $projection.NFItemInv = _COFIInv.BR_NotaFiscalItem
                  and _COFIInv.TaxGroup     = 'COFI'
                )

  association [1..1] to I_BR_NFItem            as _NFItemNFDev          on (
              $projection.NFDev         = _NFItemNFDev.BR_NotaFiscal
              and $projection.NFItemDev = _NFItemNFDev.BR_NotaFiscalItem
            )

  association [1..1] to I_BR_NFItem            as _NFItemNFInv          on (
              $projection.NFInv         = _NFItemNFInv.BR_NotaFiscal
              and $projection.NFItemInv = _NFItemNFInv.BR_NotaFiscalItem
            )

{

  key    NFItemDev.BR_NotaFiscal                                                                                                           as BR_NotaFiscal, //    N° NF
  key    NFItemDev.BR_NotaFiscalItem                                                                                                       as NFItemDev, //    Nº Item
  key    NFItemDev.BR_NotaFiscal                                                                                                           as NFDev, //    N° NF

         //*Cabeçalho Dev

         _NFDev.BR_NFPartner                                                                                                               as PartnerDev,                 //    Cliente
         _NFDev.BR_NFPartnerName1                                                                                                          as PartnerNameDev,             //    Nome Cliente
         _NFDev.BR_NFPartnerCNPJ                                                                                                           as PartnerCNPJDev,             //    CNPJ Cliente
         _NFDev.BR_NFPartnerRegionCode                                                                                                     as PartnerRegionDev,           //    UF
         _NFDev.BR_NFPartnerCityName                                                                                                       as PartnerCityDev,             //    Município
         _NFDev.CreationDate                                                                                                               as CreationDateDev,            //    Data de Emissão Dev.
         _NFDev.CreatedByUser                                                                                                              as CreatedByUserDev,           //    Criado Por
         lpad( _NFDev.BR_NFeNumber, 9, '0' )                                                                                               as NFeNumberDev,               //    N° NFe Dev
         _NFDev.CreationDate                                                                                                               as CreationDataDev,            //    Data de Emissão Dev
         _NFDev.BR_NFPostingDate                                                                                                           as NFPostingDateDev,           //    Data de Lançamento Dev
         _NFDev.BR_NFType                                                                                                                  as NFTypeDev,                  //    Categ NF  Dev
         _NFVerifDev.CompanyCode                                                                                                           as CompanyCodeDev,             //    Empresa
         _NFVerifDev.CompanyCodeName                                                                                                       as CompanyCodeNameDev,         //    Nome da empresa
         _NFVerifDev.BusinessPlace                                                                                                         as BusinessPlaceDev,           //    Local de Negócio
         _BusinessPlaceDev.BusinessPlaceName                                                                                               as BusinessPlaceNameDev,
         _NFVerifDev.ReferenceDocument                                                                                                     as ReferenceDocumentVerifDev,  //    Documento Faturamento
         _NFVerifDev.BR_NFDirection                                                                                                        as DirectionDev,               //    Direção do Movimento
         _NFDirectionDev.BR_NFDirectionDesc                                                                                                as DirectionDesc,              //    Descrição da direção
         _NFVerifDev.BR_NFIsCreatedManually                                                                                                as CreatedManuallyDev,         //    Criado manualmente
         _CustomerReturnDev.CustomerReturnType                                                                                             as SalesOrderTypeDev,          //    Tipo de Doc de Vendas
         _CustomerReturnDev._CustomerReturnType._Text[1: Language = $session.system_language ].SalesDocumentTypeName                       as DocumentTypeNameDev,        //    Descr.Tipo OV Dev
         _CustomerReturnDev.SDDocumentReason                                                                                               as SDDocumentReasonDev,        //    Razão da devolução
         _CustomerReturnDev._SDDocumentReason._Text[1:Language = $session.system_language].SDDocumentReasonText                            as SDDocumentReasonTextDev,    //    Descrição do Motivo
         _CustomerReturnDev.SalesOrganization                                                                                              as SalesOrganizationDev,       //    Organização de vendas
         //*Item Devolução
         NFItemDev.Plant                                                                                                                   as PlantDev,                   //    Centro
         substring( NFItemDev.BR_PlantNameFrmtdDesc, 7, 20 )                                                                               as BR_PlantNameDev,
         NFItemDev.Material                                                                                                                as MaterialDev,                //    Código  Material
         NFItemDev.MaterialName                                                                                                            as MaterialNameDev,            //    Descr.Material
         NFItemDev.BR_NFItemTitle                                                                                                          as NFItemTitleDev,             //    Descrição do Material:
         NFItemDev.QuantityInBaseUnit                                                                                                      as QuantityDev,                //    Quantidade
         NFItemDev.BaseUnit                                                                                                                as BaseUnitDev,                //    Unidade de Medida   
         cast(NFItemDev.BR_NFTotalAmountWithTaxes  as abap.dec( 15, 2 ) )
                  + coalesce( _ICSTDev.BR_NFItemTaxAmount , 0 )
                  + coalesce( _IPIDev.BR_NFItemTaxAmount , 0 )                                                                             as NFeTotalDev,                //    Valor NFe Dev
         cast(NFItemDev.BR_NFTotalAmountWithTaxes as abap.dec( 15, 2 ) )                                                                   as NetValueDev,                //    Valor Produto Dev
         cast(_NFDev.HeaderGrossWeight as abap.dec( 15, 3 ) )                                                                              as HeaderGrossWeightDev,       //    Peso NFE
         NFItemDev.NCMFrmtdCode                                                                                                            as NCMDev,                     //    NCM
         _NFItemNFDev.BR_CFOPCode                                                                                                          as CFOPDev,                    //    CFOP
         @Semantics.amount.currencyCode:'SalesDocumentCurrencyDev'
         NFItemDev.NetValueAmount                                                                                                          as NetValueAmountDev,          //    Valor Total Produto

         NFItemDev.BR_NFValueAmountWithTaxes                                                                                               as NFValueAmountWithTaxesDev,  //    Valor Total Nfe
         NFItemDev.ReferenceDocument                                                                                                       as ReferenceDocumentDev,       //    Documento Faturamento
         NFItemDev.SalesDocumentCurrency                                                                                                   as SalesDocumentCurrencyDev,   //    Referência para Moeda X
         _ConvertDev.ValorConvUMB                                                                                                          as QuantityUMBDev,             //    Qde Dev UMB
         _MaterialDev.MaterialBaseUnit                                                                                                     as MaterialBaseUnitDev,        //    UMB Saida
         _ConvertDev.ValorConvKg                                                                                                           as QuantityKgDev,              //    Qde Conversão em Kg
         'KG'                                                                                                                              as UnidKgDev,                  //    Unidade de medida Fixa

         //*Billing Dev//
         left( _NFBillingDocItemDev.ProductHierarchyNode, 5 )                                                                              as ProductHierarchyNodeDev,    //    Familia do Material
         _HierarquiaProd.Text                                                                                                              as ProductHierarchyTextDev,    //    Texto Familia do Material
         _NFBillingDocItemDev._BillingDocument.BillingDocumentDate                                                                         as BillingDateDev,             //    Data do Faturamento
         _NFBillingDocItemDev._BillingDocument.DistributionChannel                                                                         as DistributionChannelDev,     //    Canal de distribuição
         _NFBillingDocItemDev._BillingDocument._DistributionChannel._Text[1: Language = $session.system_language ].DistributionChannelName as DistributionChannelTextDev, //    Nome Canal de Distribuição
         _NFBillingDocItemDev._BillingDocument.BillingDocumentType                                                                         as BillingDocTypeDev,          //    Tipo Doc Faturamento Saida
         _NFBillingDocItemDev.SalesDocument                                                                                                as SalesDocumentDev,           //    Ordem de venda
         _NFBillingDocItemDev._BillingDocument.Division                                                                                    as DivisionDev,                //    Setor de Atividade

         //*Motivos Dev//
         _MotivosOrdemDev.Arearesp                                                                                                         as AreaRespDev,                //     Área Responsável-Dev
         _MotivosOrdemDev.Impacto                                                                                                          as ImpactoDev,                 //     Impacto Indicador
         _MotivosOrdemDev.Embarque                                                                                                         as EmbarqueDev,                //     Com Embarque
         _MotivosOrdemDev.Qualidade                                                                                                        as QualidadeDev,               //     Indicador Avarias

         //*ICMS Dev*//
         _ICMSDev.BR_NFItemBaseAmount                                                                                                      as ICMSItemBaseAmountDev,      //    BC ICMS Dev
         _ICMSDev.BR_NFItemTaxAmount                                                                                                       as ICMSItemTaxAmountDev,       //    ICMS Dev

         //*IPI Dev*//
         _IPIDev.BR_NFItemBaseAmount                                                                                                       as IPIItemBaseAmountDev,       //    BC IPI Dev
         _IPIDev.BR_NFItemTaxAmount                                                                                                        as IPIItemTaxAmountDev,        //    IPI Dev

         //*ICMS ST Dev*//
         _ICSTDev.BR_NFItemBaseAmount                                                                                                      as ICSTItemBaseAmountDev,      //    BC ICST Dev
         _ICSTDev.BR_NFItemTaxAmount                                                                                                       as ICSTItemTaxAmountDev,       //    ICST Dev

         //*PIS ST Dev*//
         _PISDev.BR_NFItemBaseAmount                                                                                                       as PISItemBaseAmountDev,       //    BC PIS Dev
         _PISDev.BR_NFItemTaxAmount                                                                                                        as PISItemTaxAmountDev,        //    PIS Dev

         //*COFI ST Dev*//
         _COFIDev.BR_NFItemBaseAmount                                                                                                      as COFIItemBaseAmountDev,      //    BC COFI Dev
         _COFIDev.BR_NFItemTaxAmount                                                                                                       as COFIItemTaxAmountDev,       //    COFI Dev

         //*Cabeçalho Saída*//
         lpad( _NFInv.BR_NFeNumber, 9, '0' )                                                                                               as NFeNumberInv,               //    Docnum Nfe
         _NFInv.BR_NFType                                                                                                                  as NFTypeInv,                  //    Categ NF  Saída
         _NFInv.BR_NFPostingDate                                                                                                           as NFPostingDateInv,           //    Data de Lançamento Saida
         _NFInv.CreationDate                                                                                                               as CreationDateInv,            //    Data de Emissão Saida.

         //*Item Saída*//
         _NFItemInv.BR_NotaFiscal                                                                                                          as NFInv,                      //    Numero NFE Inv
         _NFItemInv.BR_NotaFiscalItem                                                                                                      as NFItemInv,                  //    Item NFE Inv
         _NFItemInv.Material                                                                                                               as MaterialInv,                //    Material Saída
         ltrim(_NFItemInv.OriginReferenceDocument, '0')                                                                                    as OriginReferenceDocumentInv, //    ORDEM DE Vendas Saída
         _NFItemInv.ReferenceDocument                                                                                                      as ReferenceDocumentInv,       //    Documento Faturamento Saída
         _NFItemNFInv.BR_CFOPCode                                                                                                          as CFOPInv,                    //    CFOP Inv
         _NFItemInv.QuantityInBaseUnit                                                                                                     as QuantityInv,                //    Quantidade
         _NFItemInv.BaseUnit                                                                                                               as BaseUnitInv,                //    Unidade de Medida
         _NFItemInv.NCMFrmtdCode                                                                                                           as NCMFrmtdCodeInv,            //    NCM
         _NFItemInv.BR_NFTotalAmountWithTaxes                                                                                              as NetValueAmountInv,          //    Valor Total Produto
         _NFItemInv.BR_NFTotalAmountWithTaxes                                                                                              as NFeTotalInv,                //    Valor Total Nfe
         //_NFItemInv.PredecessorReferenceDocument                                                                                           as PredecessorReferDocumentInv, //    Remessa Saída
         _ConvertInv.ValorConvUMB                                                                                                          as QuantityUMBInv,             //    Qde Dev UMB
         _MaterialInv.MaterialBaseUnit                                                                                                     as MaterialBaseUnitInv,        //    UMB Entrada
         _ConvertInv.ValorConvKg                                                                                                           as QuantityKgInv,              //    Qde Conversão em Kg
         'KG'                                                                                                                              as UnidKgInv,                  //    UM KG Dev. Fixo
         _SalesOrderInv.SalesOrderType                                                                                                     as SalesOrderTypeInv,          //    Tipo de Doc de Vendas Saída
         _SalesOrderInv._SalesOrderType._Text[1: Language = $session.system_language ].SalesDocumentTypeName                               as DocumentTypeNameInv,        //    Descr.Tipo OV Inv

         //*Billing Saída//
         _NFBillingDocItemInv._BillingDocument.BillingDocumentType                                                                         as BillingDocTypeInv, // Tipo Doc Faturamento Saida

         //*ICMS Inv*//
         _ICMSInv.BR_NFItemBaseAmount                                                                                                      as ICMSItemBaseAmountInv,      //    BC ICMS Dev
         _ICMSInv.BR_NFItemTaxAmount                                                                                                       as ICMSItemTaxAmountInv,       //    ICMS Dev

         //*IPI Inv*//
         _IPIInv.BR_NFItemBaseAmount                                                                                                       as IPIItemBaseAmountInv,       //    BC IPI Dev
         _IPIInv.BR_NFItemTaxAmount                                                                                                        as IPIItemTaxAmountInv,        //    IPI Dev

         //*ICMS ST Inv*//
         _ICSTInv.BR_NFItemBaseAmount                                                                                                      as ICSTItemBaseAmountInv,      //    BC ICST Dev
         _ICSTInv.BR_NFItemTaxAmount                                                                                                       as ICSTItemTaxAmountInv,       //    ICST Dev

         //*PIS ST Inv*//
         _PISInv.BR_NFItemBaseAmount                                                                                                       as PISItemBaseAmountInv,       //    BC PIS Dev
         _PISInv.BR_NFItemTaxAmount                                                                                                        as PISItemTaxAmountInv,        //    PIS Dev

         //*COFI ST Inv*//
         _COFIInv.BR_NFItemBaseAmount                                                                                                      as COFIItemBaseAmountInv,      //    BC COFI Dev
         _COFIInv.BR_NFItemTaxAmount                                                                                                       as COFIItemTaxAmountInv,       //    COFI Dev

         //*Vendedor Saída//
         _SupplierInvOvInv.Supplier                                                                                                        as SupplierInv,                //     Cód Vendedor
         _SupplierInv.SupplierFullName                                                                                                     as SupplierNameInv,            //     Nome Vendedor
         _BPVendedorIdentInv.BPIdentificationNumber                                                                                        as SupplierId,                 //     Matrícula do vendedor

         //*Motorista Saída//
         _DriverInv.Driver                                                                                                                 as DriverInv,                  //     Cód do motorista
         _DriverInv.DriverName                                                                                                             as DriverNameInv,              //     Nomo do motorista
         _BPMotoristaInv.BPIdentificationNumber                                                                                            as DriverId,                   //     Matrícula do Motorista

         //*FreteInv//
         _TransportItemInv.Tor_id                                                                                                          as OrdemFreteInv,              //     Ordem de frete
         @Semantics.quantity.unitOfMeasure: 'GrossWeightUnitInv'
         cast(_NFInv.HeaderGrossWeight as abap.dec( 15, 3 ) )                                                                              as GrossWeightInv,             //    Peso Bruto


         _NFInv.HeaderWeightUnit                                                                                                           as GrossWeightUnitInv,         //    Unidade

         //*Ov*//
         _SalesDocumentItemInv._Route.Route                                                                                                as RouteInv,                   //    Itinerário
         _SalesDocumentItemInv._Route._Text[1:Language = $session.system_language].RouteName                                               as RouteTextInv,               //    Descrição Itinerário
         _SalesDocumentItemInv._SalesDocument.SalesDistrict                                                                                as SalesDistrictInv,           //    Cod região de Vendas
         _SalesDocumentItemInv._SalesDocument._SalesDistrict._Text[1:Language = $session.system_language].SalesDistrictName                as SalesDistrictNameInv,       //    Descrição região de Vendas
         _SalesDocumentItemInv._SalesDocument.SalesOffice                                                                                  as SalesOfficeInv              //    Escritório de Vendas

}
where
      _NFDev.BR_NFDirection       = '1'
  and _NFDev.BR_NFDocumentType    = '6'
  and _NFDev.BR_NFIsCanceled      = ' '
  and _NFDev.BR_NFeDocumentStatus = '1'
  and _NFDev.BR_NFDirection       = '1';
