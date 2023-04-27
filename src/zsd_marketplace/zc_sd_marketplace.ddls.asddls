@EndUserText.label: 'CDS Consumo Marketplace'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SD_MARKETPLACE as projection on ZI_SD_MARKETPLACE {
    @EndUserText.label: 'Fornecedor'
    key Lifnr,
    @EndUserText.label: 'Razão Social'
    Idcadinttran,
    @EndUserText.label: 'CNPJ'
    Cnpjintermed,
    @EndUserText.label: 'Inscrição Estadual'
    Indintermed,
    @EndUserText.label: 'Presença Consumidor final'
    IndPres,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt
}
