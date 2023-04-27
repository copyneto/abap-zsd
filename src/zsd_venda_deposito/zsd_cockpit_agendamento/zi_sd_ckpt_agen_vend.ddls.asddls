@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Busca Vendedor'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_CKPT_AGEN_VEND
  as select from I_SDDocumentCompletePartners                                                                      as _Partner
    inner join   ZI_SD_CKPT_AGEN_PARAM( p_modulo : 'SD', p_chave1 : 'ADM_AGENDAMENTO', p_chave2 : 'VENDEDOR_EXT' ) as _Param on _Param.parametro = _Partner.PartnerFunction
{

  key _Partner.SDDocument,
  key _Partner.SDDocumentItem,
      _Partner.Supplier
}
