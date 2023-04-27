@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Imposto NF'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NOTA_IMPOSTO as select from I_BR_NFTax {
    key BR_NotaFiscal,
    key BR_TaxType as TaxType,
    sum(cast(BR_NFItemTaxAmount as abap.dec(13,2))) as TaxAmount,  
    sum(cast(BR_NFItemBaseAmount as abap.dec(13,2))) as BaseAmount 
}
where
    BR_TaxType = 'ICM3' or BR_TaxType = 'ICS3' or BR_TaxType = 'IPI3'
group by
    BR_NotaFiscal,
    BR_TaxType
