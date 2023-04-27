@AbapCatalog.sqlViewName: 'ZVSDCOND'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Consulta Condição'
define view ZI_SD_CONTR_LOC_COM_COND as select from I_SalesDocumentPricingElement as _Cond
 inner join   ZI_SD_CKPT_CLICO_PEDIDO_PARAM(p_chave1 : 'CONTRATO_LOCACAO', p_chave2 : 'TIPO_COND') as _param on _param.parametro = _Cond.ConditionType
 {
    key _Cond.SalesDocument,
    _Cond.ConditionType,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
    _Cond.ConditionAmount,
    _Cond.TransactionCurrency
}
