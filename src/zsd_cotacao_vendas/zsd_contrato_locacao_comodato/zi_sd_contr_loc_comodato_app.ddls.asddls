@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'App Contratos Locação de Comodato'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_SD_CONTR_LOC_COMODATO_APP
  as select from    I_SalesDocumentItem                                    as _ItemsDoc

    left outer join I_SalesContractItem                                    as _Items      on  _ItemsDoc.SalesDocument     = _Items.SalesContract
                                                                                          and _ItemsDoc.SalesDocumentItem = _Items.SalesContractItem

    left outer join ZI_SD_CONTR_LOC_COM_PARTNERS(p_PartnerFunction : 'AG') as _Partners   on _Partners.SDDocument = _ItemsDoc.SalesDocument


  //left outer join ZI_SD_CONTR_LOC_COM_PARTNERS(p_PartnerFunction : 'ZE') as _Supplier   on _Supplier.SDDocument = _ItemsDoc.SalesDocument
    left outer join ZI_SD_STATUS_VENDEDOR_EXT                              as _Supplier   on _Supplier.vbeln = _ItemsDoc.SalesDocument

  //RP
  //left outer join ZI_SD_CONTR_LOC_COM_PARTNERS(p_PartnerFunction : 'ZE') as _Personnel  on _Personnel.SDDocument = _ItemsDoc.SalesDocument

    left outer join ZI_SD_STATUS_VENDEDOR_EXT                              as _Personnel  on _Personnel.vbeln = _ItemsDoc.SalesDocument

    left outer join ZI_SD_CONTR_LOC_COM_PARTNERS(p_PartnerFunction : 'WE') as _Receiver   on _Receiver.SDDocument = _ItemsDoc.SalesDocument

    left outer join ZI_SD_CONTR_LOC_COM_FLOW(p_tipo : 'C')                 as _Ordem      on  _Ordem.SalesContract = _ItemsDoc.SalesDocument
                                                                                          and _Ordem.Item          = _ItemsDoc.SalesDocumentItem

    left outer join ZI_SD_CONTR_LOC_COM_FLOW(p_tipo : 'O')                 as _FatEntrega on  _FatEntrega.SalesContract = _Ordem.Document
                                                                                          and _FatEntrega.Item          = _ItemsDoc.SalesDocumentItem

    left outer join ZI_SD_CONTR_LOC_COM_FLOW(p_tipo : 'M')                 as _Fatura     on  _Fatura.SalesContract = _Ordem.Document
                                                                                          and _Fatura.Item          = _ItemsDoc.SalesDocumentItem

  //    left outer join prcd_elements                                           as _Preco      on _Preco.knumv = _ItemsDoc.SalesDocumentCondition and
  //                                                                                              _Preco.kposn = _ItemsDoc.SalesDocumentItem and
  //                                                                                              _Preco.kschl = 'ZTOT'

  association to ZI_SD_CONTR_LOC_COM_NFE_ENT as _NfeEntrada on  _NfeEntrada.Invoice = _FatEntrega.Document

  association to ZI_SD_CONTR_LOC_COM_NFE     as _Nfe        on  _Nfe.Invoice = _Fatura.Document

  association to I_Plant                     as _Plant      on  _Plant.Plant = $projection.Plant

  association to ZI_SD_CONTR_LOC_COM_NUMSER  as _NUMSER     on  _NUMSER.SalesContract     = $projection.SalesContract
                                                            and _NUMSER.SalesContractItem = $projection.SalesContractItem

  association to ZI_SD_CONTR_LOC_COM_COND    as _cond       on  _cond.SalesDocument = $projection.SalesContract

  association to I_SalesDocument             as _HeaderDoc  on  _HeaderDoc.SalesDocument = $projection.SalesContract


{

  key       _ItemsDoc.SalesDocument           as SalesContract,
  key       _ItemsDoc.SalesDocumentItem       as SalesContractItem,
  key       _Ordem.Document                   as SalesOrder,
            _ItemsDoc.Plant,
            _Plant.PlantName,
            _HeaderDoc.SalesDocumentType      as SalesContractType,
            _HeaderDoc.SalesDocumentDate      as SalesContractDate,
            _Partners.Partner                 as Customer,
            _Partners.PartnerName             as CustomerName,
            _Personnel.lifnr                  as Personnel,
            _Personnel.VendedorExt            as PersonnelName,
            _Supplier.lifnr                   as Supplier,
            _Supplier.VendedorExt             as SupplierName,
            _Receiver.Partner                 as Receiver,
            _Receiver.PartnerName             as ReceiverName,
            @ObjectModel.virtualElement: true
            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_PARVW'
            @ObjectModel.filter.transformedBy: 'ABAP:ZCLSD_CONVERSION_PARVW'
            cast( '' as abap.char( 2 ) )      as PartnerFunction,
            @ObjectModel.virtualElement: true
            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_PARVW'
            cast( '' as abap.char( 20 ) )     as PartnerFunctionName,
            _Fatura.Document                  as Invoice,
            _NfeEntrada.NotaFiscal            as NotaFiscalEntrada,
            _NfeEntrada.CreationDate          as CreationDateEntrada,
            _Nfe.NotaFiscal,
            _Nfe.CreationDate,
            //I_BR_NFDocument- BR_NFNumber,
            //I_BR_NFDocument- CreationDate,
            //            @ObjectModel.virtualElement: true
            //            @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCLSD_CONVERSION_GERNR'
            //            @ObjectModel.filter.transformedBy:'ABAP:ZCLSD_CONVERSION_GERNR'
            _NUMSER.serie                     as Serie,
            _ItemsDoc.Material,
            _ItemsDoc.SalesDocumentItemText   as SalesContractItemText,
            _Items.OrderQuantityUnit,
            @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
            _Items.OrderQuantity,
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            //_ItemsDoc.NetAmount,
            //_Ordem.ValorAluguel           as NetAmount,
            //_Preco.kwert as NetAmount,
            _Ordem.NetAmount,

            _Items.TransactionCurrency,
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            _cond.ConditionAmount,
            @Semantics.amount.currencyCode: 'TransactionCurrency'
            //            _Ordem.ValorAluguel,
            _Items.NetPriceAmount             as ValorAluguel,


            case
            when _NfeEntrada.NotaFiscal != ' '
             then 'Inativo'
            when _Items.SalesDocumentRjcnReason = ' '
             then 'Ativo'
               else 'Inativo'
            end                               as Status,

            case
              when _NfeEntrada.NotaFiscal != ' '
               then 1 --Vermelho
              when _Items.SalesDocumentRjcnReason = ' '
               then 3 --Verde
                 else 1 --Vermelho
            end                               as ColorStatus,

            _ItemsDoc.PurchaseOrderByCustomer as PurchaseOrderByCustomer





}
