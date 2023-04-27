@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca dos valores cód. controle(STEUC)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_STEUC as select from t604f
    association [1..1] to t604n as _Text on $projection.Steuc = _Text.steuc
                                         and _Text.spras = $session.system_language {
    key steuc as Steuc,
    _Text.text1 as Text
}
where land1 = 'BR'
