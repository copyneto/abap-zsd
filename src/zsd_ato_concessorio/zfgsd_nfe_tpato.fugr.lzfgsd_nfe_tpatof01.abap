*----------------------------------------------------------------------*
***INCLUDE LZFGSD_NFE_TPATOF01.
*----------------------------------------------------------------------*
FORM F_ATUALIZA_LOG.

  DATA: lv_timestamp1 TYPE timestampl.

  GET TIME STAMP FIELD lv_timestamp1.

  ztsd_nfe_tpato-created_by = sy-uname.
  ztsd_nfe_tpato-last_changed_by = sy-uname.
  ztsd_nfe_tpato-created_at = lv_timestamp1.
  ztsd_nfe_tpato-last_changed_at = lv_timestamp1.
  ztsd_nfe_tpato-local_last_changed_at = lv_timestamp1.


ENDFORM.

FORM F_ATUALIZA_LOG_UPDATE.

  DATA: lv_timestamp1 TYPE timestampl.

  GET TIME STAMP FIELD lv_timestamp1.

  ztsd_nfe_tpato-last_changed_by = sy-uname.
  ztsd_nfe_tpato-last_changed_at = lv_timestamp1.
  ztsd_nfe_tpato-last_changed_at = lv_timestamp1.

ENDFORM.
