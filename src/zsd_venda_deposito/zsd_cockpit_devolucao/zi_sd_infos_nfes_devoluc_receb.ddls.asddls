@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Informações NF-e de devolução recebida'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZI_SD_INFOS_NFES_DEVOLUC_RECEB 
as select from ZI_SD_NOTA
{
key GuiOperacao   as GuiOperacao,
key ChaveAcesso   as ChaveAcesso,
key Item          as Item,
    CodMoeda      as CodMoeda,
    @Semantics.amount.currencyCode: 'CodMoeda'
    ValorNota     as ValorNota,
    NaturOperacao as NaturOperacao, 
    IdItem        as IdItem,
    Material      as Material,
    CodEan        as CodEan,
    Quantidade    as Quantidade,
    UnidMedida    as UnidMedida,
    @Semantics.amount.currencyCode: 'CodMoeda'
    ValorUnit    as ValorUnit
}
