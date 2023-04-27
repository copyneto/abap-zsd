@AbapCatalog.sqlViewName: 'ZVSDITINERARIO'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Itinerário'
define view ZI_SD_JUSTIF_ATRASO_ITI as select distinct from vbap {

key vbeln as SalesOrder,
    route as Itinerario
}
