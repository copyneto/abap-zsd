@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Documentos estornados não faturados'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SD_KIT_BON_ESTORNO_FAT
  as select from    ZI_SD_KIT_BON_NOTAITEM   as _sd_kit

    inner join      ZI_SD_KIT_BON_TP_MOV     as _TpMov      on  _TpMov.TpMov  = _sd_kit.GoodsMovementType
                                                            and _TpMov.chave3 = ' '

    left outer join ZI_SD_KIT_BON_DOCESTORNO as _DocEstorno on  _DocEstorno.smbln = _sd_kit.DocKit
                                                            and _DocEstorno.matnr = _sd_kit.MatnrFree
{
  key _sd_kit.competencia,
  key _sd_kit.Plant,
  key _sd_kit.DocKit,
  key _sd_kit.MatnrKit,
  key _sd_kit.MatnrFree,
  key _sd_kit.kunnr,
  key cast(_sd_kit.Posnr as abap.char( 4 ) ) as Posnr,
      _DocEstorno.DocEstorno,

      case
      when  _DocEstorno.DocEstorno  is not initial
      then ' '
      else 'X'
      end                                    as SemEstorno



}
where
  _sd_kit.PostingDate != '00000000'
group by
  _sd_kit.competencia,
  _sd_kit.Plant,
  _sd_kit.DocKit,
  _sd_kit.MatnrKit,
  _sd_kit.MatnrFree,
  _sd_kit.kunnr,
  _sd_kit.Posnr,
  _DocEstorno.DocEstorno    
