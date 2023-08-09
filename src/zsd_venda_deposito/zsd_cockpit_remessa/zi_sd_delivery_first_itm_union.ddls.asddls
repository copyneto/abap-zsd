@AbapCatalog.sqlViewName: 'ZVSD_DLVIUNION'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zi_sd_delivery_first_itm_union'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #L,
    dataClass: #MIXED
}
define view zi_sd_delivery_first_itm_union
  as select from vbak                   as _SalesDocument
    inner join   ZI_SD_CKPT_FAT_PARAMETROS(
                 p_chave1 : 'ADM_FATURAMENTO',
                 p_chave2 : 'TIPOS_OV') as _Param                on  _Param.parametro = _SalesDocument.auart
                                                                 and _Param.chave3    = ''
    inner join   lips                   as _DeliveryDocumentItem on  _DeliveryDocumentItem.vgbel =  _SalesDocument.vbeln
                                                                 and _DeliveryDocumentItem.lfimg <> 0
                                                                 and _DeliveryDocumentItem.uecha is initial
{
  key _DeliveryDocumentItem.vgbel        as SalesDocument,
  key _DeliveryDocumentItem.vbeln        as DeliveryDocument,
      min( _DeliveryDocumentItem.vgpos ) as SalesDocumentFirstItem,
      min( _DeliveryDocumentItem.posnr ) as DeliveryDocumentFirstItem
}
where
  _SalesDocument.vbtyp = 'C'
group by
  _DeliveryDocumentItem.vbeln,
  _DeliveryDocumentItem.vgbel,
  _SalesDocument.auart

union all select from vbak                   as _SalesDocument
  inner join          ZI_SD_CKPT_FAT_PARAMETROS(
                      p_chave1 : 'ADM_FATURAMENTO',
                      p_chave2 : 'TIPOS_OV') as _Param                on  _Param.parametro = _SalesDocument.auart
                                                                      and _Param.chave3    = ''
  inner join          lips                   as _DeliveryDocumentItem on  _DeliveryDocumentItem.vgbel =  _SalesDocument.vbeln
                                                                      and _DeliveryDocumentItem.lfimg <> 0
                                                                      and _DeliveryDocumentItem.uecha is not initial
{
  key _DeliveryDocumentItem.vgbel        as SalesDocument,
  key _DeliveryDocumentItem.vbeln        as DeliveryDocument,
      min( _DeliveryDocumentItem.vgpos ) as SalesDocumentFirstItem,
      min( _DeliveryDocumentItem.posnr ) as DeliveryDocumentFirstItem
}
where
  _SalesDocument.vbtyp = 'C'
group by
  _DeliveryDocumentItem.vbeln,
  _DeliveryDocumentItem.vgbel,
  _SalesDocument.auart
