@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Gestão das devoluções e-commerce'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_SD_ECOMMERCE
  as select from    I_SalesOrder          as SalesOrder
    inner join      ZI_SD_TIPOS_ECOMMERCE as _Param
      on _Param.OrderType = SalesOrder.SalesOrderType
    
    inner join ZI_SD_ECOMMERCE_DEV as _Dev on SalesOrder.SalesOrder = _Dev.SalesOrder  
    
    left outer join ZI_SD_ORDEM_DEV_V2    as _OrdemDev
      on _OrdemDev.PrecedingDocument = _Dev.Fatura
    
    //left outer join ZI_SD_ORDEM_DEV       as _OrdemDev
      //on _OrdemDev.PrecedingDocument = SalesOrder.SalesOrder
  
  association to ZI_SD_REMESSA_VEN as _RemessaVen
    on _RemessaVen.PrecedingDocument = $projection.SalesOrder and _Dev.Fatura = _RemessaVen.FaturaVend
  
  association to ZI_SD_PARTNER_DEV as _Partner
    on _Partner.SDDocument = $projection.SalesOrder
    
    
  association [0..1] to I_Plant as _Plant on _Plant.Plant = $projection.ShippingPoint

{
  key SalesOrder.SalesOrder                as SalesOrder,
  key _OrdemDev.SubsequentDocument         as Ordem,
  key _OrdemDev.RemessaDev                 as Remessa,
  key _OrdemDev.FaturaDev                  as FaturaDev,
  key _RemessaVen.SubsequentDocument       as RemVend,
  key _RemessaVen.FaturaVend               as FaturaVend,
      _OrdemDev.BR_NFeNumber               as NFDevolucao,
      SalesOrder.PurchaseOrderByCustomer   as PurchaseOrderByCustomer,
      SalesOrder.DistributionChannel       as DistributionChannel,
      _RemessaVen.BR_NFeNumber             as BR_NFeNumber,
      _RemessaVen.ShippingPoint            as ShippingPoint,

      case
        when ( _OrdemDev.BR_NFeNumber is not null and _OrdemDev.BR_NFeNumber <> '000000000' and _OrdemDev.BR_NFeNumber <> '' )
            then 'Nota Fiscal devolução criada'
        when _OrdemDev.FaturaDev <>  '0000000000'
            then 'Fatura criada '
        when ( _OrdemDev.RemessaDev is null or _OrdemDev.RemessaDev = '0000000000' ) or ( _OrdemDev.SubsequentDocument <> '0000000000' and SalesOrder.DeliveryBlockReason <> '' )
            then 'Em pré registro '
        when _RemessaVen.Remessa <>  '0000000000' and _RemessaVen.OverallGoodsMovementStatus = 'C'
            then 'Remessa e Entrada de mercadoria criada'
        else ' '
      end                                  as Processo,

      case
        when ( _OrdemDev.BR_NFeNumber is not null and _OrdemDev.BR_NFeNumber <> '000000000' and _OrdemDev.BR_NFeNumber <> '' )
            then '4'
        when _OrdemDev.FaturaDev <>  '0000000000'
            then '3'
        when ( _OrdemDev.RemessaDev is null or _OrdemDev.RemessaDev = '0000000000' ) or ( _OrdemDev.SubsequentDocument <> '0000000000' and SalesOrder.DeliveryBlockReason <> '' )
            then '1'
        when _RemessaVen.Remessa <>  '0000000000' and _RemessaVen.OverallGoodsMovementStatus = 'C'
            then '2'
        else '0'
      end                                  as EtapaProcesso,

      case
             when ( _OrdemDev.BR_NFeNumber is not null and _OrdemDev.BR_NFeNumber <> '000000000' and _OrdemDev.BR_NFeNumber <> '' )  then 3
             when  _OrdemDev.FaturaDev <>  '0000000000' then 3
             when ( _OrdemDev.RemessaDev is null or _OrdemDev.RemessaDev = '0000000000' ) or ( _OrdemDev.SubsequentDocument <> '0000000000' and SalesOrder.DeliveryBlockReason <> '' )  then 2
             when _RemessaVen.Remessa <>  '0000000000' and _RemessaVen.OverallGoodsMovementStatus = 'C' then 3
             else 0
        end                                as StatusColor,


      _OrdemDev.CorrespncExternalReference as CorrespncExternalReference,
      

      concat(   concat(   concat(   concat(substring( _RemessaVen.CreationDate, 7, 2 ), '.'),
                concat(   substring( _RemessaVen.CreationDate, 5, 2 ), concat('.', substring( _RemessaVen.CreationDate, 1, 4 )))),

                concat('/', concat(   concat(substring( _RemessaVen.CreationTime, 1, 2 ), ':'),
                          concat(substring( _RemessaVen.CreationTime, 3, 2 ), ':')) ) ),

                substring( _RemessaVen.CreationTime, 5, 2 )
                )                          as DateTimeCreate,      
      _Partner.Customer                    as Customer,
      _Partner.name1                       as Name1,
      _RemessaVen.BR_NFPartnerRegionCode   as BR_NFPartnerRegionCode,
      _RemessaVen.SalesDocumentCurrency    as SalesDocumentCurrency,
      @Semantics.amount.currencyCode: 'SalesDocumentCurrency'
      _RemessaVen.BR_NFTotalAmount         as BR_NFTotalAmount,
      _RemessaVen.BR_NFeDocumentStatus     as BR_NFeDocumentStatus,
      _OrdemDev.BR_NFeDocumentStatus       as NFDevolucaoStatus,
      case _OrdemDev.BR_NFeDocumentStatus
      when '1' then 'Autorizado'
      when '2' then 'Recusado'
      when '3' then 'Rejeitado'
      else '1ª tela'
      end                                  as StatusNfeDevolucao,

      case _OrdemDev.BR_NFeDocumentStatus
           when '1' then 3 --Verde
           when '2' then 1 --Vermelho
           when '3' then 1 --Vermelho
           else 2 --Amarelo
      end                                  as StatusNfeDevolucaoColor,

      _OrdemDev.CreationDate               as CreationDate,
      _OrdemDev.CreationTime               as CreationTime,
      SalesOrder.CreationDate              as CreationDateCli,
      _Plant
}
where
  _OrdemDev.SubsequentDocument <> ' '
