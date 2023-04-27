@AbapCatalog.sqlViewName: 'ZVSD_VALLOC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Valor Locação para CDS Cockpit'
define view ZI_SD_COCKPIT_VALLOC as select from fpla as a 
inner join fplt as t on a.fplnr = t.fplnr{

    a.vbeln as Contrato,
    left ( cast( t.afdat as char8 ), 6) as Periodo,  
    left ( cast( $session.system_date as char8 ), 6) as PerAtual,    
    @Semantics.amount.currencyCode: 'waers'              
    sum( t.fakwr ) as ValLoc, 
    t.waers as waers
    
} group by vbeln, afdat, t.waers
 
