@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Nota Fiscal'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CONTR_LOC_COM_NFE
  as select from vbrk as _vbrk
  //inner join   ZI_SD_CKPT_CLICO_PEDIDO_PARAM(p_chave1 : 'CONTRATO_LOCACAO', p_chave2 : 'TIPO_FAT') as _param on _param.parametro = _vbrk.fkart
  association to ZI_SD_CONTR_LOC_COM_NFE_AUX as _nfe_aux on _nfe_aux.refkey = _vbrk.vbeln

{
  key _vbrk.vbeln     as Invoice,
      _vbrk.fkart     as InvoiceType,
      _nfe_aux.docnum as Docnum,
      _nfe_aux.NotaFiscal,
      _nfe_aux.CreationDate

}
