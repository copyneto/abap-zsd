@AbapCatalog.sqlViewName: 'ZSD_ORDERTYPE'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Help Search: Tipo da Ordem DIFAL'
define view ZI_SD_VH_ORDERTYPE as select from ZI_CA_VH_ORDERTYPE {
    key Auart,
    Text,
    Block
} where Block = ' ';
