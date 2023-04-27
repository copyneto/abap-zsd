@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Status document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STATUS_DOCUMENT 
 as select from   I_BR_NFItem                     as _NfItem     
                                                                   
    inner join       j_1bnfdoc                  as _jfDoc        on  _NfItem.BR_NotaFiscal = _jfDoc.docnum
                                                                       and _jfDoc.direct = '1'
                                                                       and _jfDoc.code   = '100'
{

key _NfItem.BR_NotaFiscal,
key _NfItem.BR_NotaFiscalItem,
   _jfDoc.docref as BR_NFReferenceDocument
}
