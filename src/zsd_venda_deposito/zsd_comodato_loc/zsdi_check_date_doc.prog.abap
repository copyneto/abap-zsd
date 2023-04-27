*&---------------------------------------------------------------------*
*& Include          ZSDI_CHECK_DATE_DOC
*&---------------------------------------------------------------------*
DATA: lv_check TYPE abap_bool.
IMPORT lv_check TO lv_check FROM MEMORY ID 'ZMVT_CMM'.

IF sy-subrc IS INITIAL.
  IF gbobj_header[] IS NOT INITIAL.
    IF gbobj_header[ 1 ]-docdat IS INITIAL.
      gbobj_header[ 1 ]-docdat = sy-datum.
    ENDIF.
  ENDIF.
  FREE MEMORY ID 'ZMVT_CMM'.
ENDIF.
