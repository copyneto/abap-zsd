@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Motivos de ordem x Responsabilidade'
define root view entity ZI_SD_MOTIVOS_RESPONSAVEIS
  as select from ztsd_motivo_resp
  association [0..1] to I_SDDocumentReason     as _SDDocumentReason     on  $projection.Augru = _SDDocumentReason.SDDocumentReason
  association [1..1] to I_SDDocumentReasonText as _SDDocumentReasonText on  _SDDocumentReasonText.SDDocumentReason = $projection.Augru
                                                                        and _SDDocumentReasonText.Language         = $session.system_language
{

      @ObjectModel.foreignKey.association: '_SDDocumentReason'
  key ztsd_motivo_resp.augru                     as Augru,
      ztsd_motivo_resp.embarque                  as Embarque,
      ztsd_motivo_resp.qualidade                 as Qualidade,
      ztsd_motivo_resp.arearesp                  as Arearesp,
      ztsd_motivo_resp.impacto                   as Impacto,
      ztsd_motivo_resp.detalhamento              as Detalhamento,
      _SDDocumentReasonText,
      _SDDocumentReason
}
