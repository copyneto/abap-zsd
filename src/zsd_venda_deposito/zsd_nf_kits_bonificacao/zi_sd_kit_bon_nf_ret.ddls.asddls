@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Notas Fiscais de Retorno'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_NF_RET as select from I_BR_NFDocument 
    //association [0..1] to I_BR_NFeDocumentStatus      as _BR_NFeDocumentStatus         on  _BR_NFeDocumentStatus.BR_NFeDocumentStatus = $projection.NfRetorno_Status
{
    key BR_NFReferenceDocument,    
    key BR_NotaFiscal as NfRetorno,
    //@ObjectModel.foreignKey.association: '_BR_NFeDocumentStatus'
    BR_NFeDocumentStatus as NfRetorno_Status,
    case
        when BR_NFeDocumentStatus = '1' then 3 //Vermelho
        when BR_NFeDocumentStatus = '2' then 1 //Vermelho
        when BR_NFeDocumentStatus = '3' then 1 //Vermelho
    else 0 end as NfRetorno_StatusColor
    //_BR_NFeDocumentStatus 
}
where 
    BR_NFType = 'IL' and
    BR_NFIsCanceled is initial
