*&---------------------------------------------------------------------*
*& Include ZSDI_DATA_HORA_SAIDA
*&---------------------------------------------------------------------*
***  CONSTANTS: lc_add_time    TYPE t VALUE '004000',
***             lc_add_time_30 TYPE t VALUE '003000'.
***
***  DATA: lv_data TYPE j_1b_dep_arr_date,
***        lv_hora TYPE j_1b_dep_arr_time.
***
***
***  CALL FUNCTION 'EWU_ADD_TIME'
***    EXPORTING
***      i_starttime = sy-uzeit
***      i_startdate = sy-datum
***      i_addtime   = lc_add_time_30
***    IMPORTING
***      e_endtime   = lv_hora
***      e_enddate   = lv_data.
***
***  es_header-dsaient = lv_data.
***  es_header-hsaient = lv_hora.

  CLEAR: es_header-dsaient,
         es_header-hsaient.
