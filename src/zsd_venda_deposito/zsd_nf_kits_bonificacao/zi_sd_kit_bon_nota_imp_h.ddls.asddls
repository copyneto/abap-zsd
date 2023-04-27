@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Imposto NF Header'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NOTA_IMP_H as select from I_BR_NFDocument as _head 
    association to ZI_SD_KIT_BON_NOTA_IMPOSTO as _impICM3 on _head.BR_NotaFiscal = _impICM3.BR_NotaFiscal and _impICM3.TaxType = 'ICM3' 
    association to ZI_SD_KIT_BON_NOTA_IMPOSTO as _impICS3 on _head.BR_NotaFiscal = _impICS3.BR_NotaFiscal and _impICS3.TaxType = 'ICS3'
    association to ZI_SD_KIT_BON_NOTA_IMPOSTO as _impIPI3 on _head.BR_NotaFiscal = _impIPI3.BR_NotaFiscal and _impIPI3.TaxType = 'IPI3'
{
    key BR_NotaFiscal,
    _impICM3.TaxAmount as TaxAmountICM3,
    _impICM3.BaseAmount as BaseAmountICM3,
    
    _impICS3.TaxAmount as TaxAmountICS3,
    _impICS3.BaseAmount as BaseAmountICS3,
    
    _impIPI3.TaxAmount as TaxAmountIPI3,
    _impIPI3.BaseAmount as BaseAmountIPI3
}
