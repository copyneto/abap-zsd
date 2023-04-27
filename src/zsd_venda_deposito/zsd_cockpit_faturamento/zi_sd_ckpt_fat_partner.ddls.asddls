@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emissor da ordem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_FAT_PARTNER
  as select from    I_SDDocumentCompletePartners as SDDocument
    inner join      kna1                         as _Partner         on _Partner.kunnr = SDDocument.Customer
    left outer join ZI_SD_VH_CUSTOMER_SERVICE    as _CustomerService on _CustomerService.ServicoCliente = _Partner.katr1
    left outer join ZI_SD_VH_AREA_ATENDIMENTO    as _AreaAtendimento on _AreaAtendimento.AreaAtendimento = _Partner.katr9
{
  key SDDocument.SDDocument,
  key SDDocument.SDDocumentItem,
  key SDDocument.PartnerFunction,

      SDDocument.Customer,
      SDDocument.Supplier,
      SDDocument.Personnel,
      _Partner.name1                        as CustomerName,
      _Partner.regio                        as Regio,
      _Partner.katr1                        as CodigoServico,
      _CustomerService.ServicoClienteTexto  as CodigoServicoTexto,
      _Partner.katr9                        as AreaAtendimento,
      _AreaAtendimento.AreaAtendimentoTexto as AreaAtendimentoTexto
}
where
  SDDocument.PartnerFunction = 'AG'
