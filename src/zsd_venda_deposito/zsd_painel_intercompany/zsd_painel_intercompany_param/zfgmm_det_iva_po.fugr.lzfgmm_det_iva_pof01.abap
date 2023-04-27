*----------------------------------------------------------------------*
***INCLUDE LZFGMM_DET_IVA_POF01.
*----------------------------------------------------------------------*

DATA: ls_det_iva TYPE ztmm_det_iva_po.

*&---------------------------------------------------------------------*
*& Form F_DATA_HORA
*&---------------------------------------------------------------------*
FORM f_data_hora.

  ls_det_iva = <table1>.

  IF  ls_det_iva-matkl IS INITIAL
  AND ls_det_iva-matnr IS INITIAL.
    MESSAGE e033(zsd_intercompany).
  ENDIF.

  IF  ls_det_iva-matkl IS NOT INITIAL
  AND ls_det_iva-matnr IS NOT INITIAL.
    MESSAGE e034(zsd_intercompany).
  ENDIF.

  IF ls_det_iva-created_by IS INITIAL.
    ls_det_iva-created_by    = sy-uname.
    ls_det_iva-created_at_dt = sy-datum.
    ls_det_iva-created_at_hr = sy-uzeit.
  ENDIF.

  ls_det_iva-last_changed_by    = sy-uname.
  ls_det_iva-last_changed_at_dt = sy-datum.
  ls_det_iva-last_changed_at_hr = sy-uzeit.

  <table1> = ls_det_iva.

ENDFORM.
