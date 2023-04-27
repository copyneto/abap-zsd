@EndUserText.label: 'CDS de Progecao - Ato Concessório'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_SD_NFE_TPATO as projection on ZI_SD_NFE_TPATO {
    key Branch,
    key Opint,
    key Matkl,
    key Matnr,
    BranchtDesc,
    GrpMercDesc,
    MaterialDesc,
    TpAtoDesc,
    TpAto,
    Atcon,
    Text1,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt 
}
