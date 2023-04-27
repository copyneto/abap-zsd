@AbapCatalog.sqlViewName: 'ZISD_MOTIVOORD'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Motivo da ordem'
@Search.searchable: true
define view ZI_SD_VH_MotivoOrdem as select from tvau as MotivoOrdem 
inner join ztca_param_val as _Parametro on augru = _Parametro.low 
association to tvaut as _Text on  $projection.Augru = _Text.augru
                                        and _Text.spras = $session.system_language
//association to ztca_param_val as _Parametro on $projection.Augru = _Parametro.low                                        
                                             
{
      @ObjectModel.text.element: ['Text']
      @Search.defaultSearchElement: true
    key augru as Augru,
    @Search.defaultSearchElement: true
       _Text.bezei as Text,
      @Search.defaultSearchElement: true
      _Parametro.chave1 as SalesDocumentType   
       
} where
        _Parametro.modulo = 'SD'
    and _Parametro.chave2 = 'X'

