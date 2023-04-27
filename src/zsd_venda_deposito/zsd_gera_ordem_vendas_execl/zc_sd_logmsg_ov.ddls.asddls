@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumo log criação Ordem de Vendas'
define root view entity ZC_SD_LOGMSG_OV as projection on ZI_SD_LOGMSG_OV
{
    key Guid,
    Msgty,
    Msgid,
    Msgno,
    Msgv1,
    Msgv2, 
    Msgv3,
    Msgv4,
    Message

}
