@AbapCatalog.sqlViewName: 'ZVSDGETCTRWF'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Fluxo de documentos'
define view ZI_SD_COCKPIT_CTR_PEDIDO_WF
    with parameters p_tipo : vbtyp_n
as select distinct from vbfa as _flow    
{

  key _flow.vbelv as SalesOrder,
      _flow.vbeln as Document       
} where vbtyp_n = $parameters.p_tipo
