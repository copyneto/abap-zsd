*&---------------------------------------------------------------------*
*& Include ZSDE_SALESORDER
*&---------------------------------------------------------------------*

DATA: lt_xvbap TYPE TABLE OF vbap.

IF vbak-bsark NE 'SIRI'.

  lt_xvbap[] = CORRESPONDING #( xvbap[] ).

  CALL FUNCTION 'ZFMSD_SALESORDER'
    STARTING NEW TASK 'UPDATE'
    EXPORTING
      is_vbak = vbak
      is_vbkd = vbkd
    TABLES
      it_vbap = lt_xvbap.

ENDIF.
