@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS Nota de devoluçao cancelada'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_NFE_DEVOLUCAO_CANCEL as select from /xnfe/events as _NotaCancelada
{
    key _NotaCancelada.guid  as ChavePrimaria,
        _NotaCancelada.chnfe as ChaveAcesso,
        cast( 'X' as abap.char( 1 ) ) as Cancelada
}    
where _NotaCancelada.tpevento = '110111'
