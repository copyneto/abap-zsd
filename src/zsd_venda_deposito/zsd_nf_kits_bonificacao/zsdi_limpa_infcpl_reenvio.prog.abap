*&---------------------------------------------------------------------*
*& Include          ZSDI_LIMPA_INFCPL_REENVIO
*&---------------------------------------------------------------------*
IF sy-ucomm = 'SEND_NFE'.

  CONSTANTS: lc_add_time    TYPE t VALUE '004000',
             lc_add_time_30 TYPE t VALUE '003000'.

  DATA: lv_data TYPE j_1b_dep_arr_date,
        lv_hora TYPE j_1b_dep_arr_time.

  FIELD-SYMBOLS <fs_header_text> TYPE j_1bnfdoc_text_tab.

  ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER_TEXT') TO <fs_header_text>.

  IF <fs_header_text> IS ASSIGNED.
    CLEAR <fs_header_text>.
  ENDIF.

  UNASSIGN <fs_header>.
  ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER') TO <fs_header>.

  IF <fs_header> IS ASSIGNED.

    lv_data = sy-datum.
    lv_hora = sy-uzeit.

    CALL FUNCTION 'EWU_ADD_TIME'
      EXPORTING
        i_starttime = lv_hora
        i_startdate = lv_data
* LSCHEPP - Alteração Data/Hora Saída - Nova Definição - 09.01.2023 Início
*        i_addtime   = lc_add_time
        i_addtime   = lc_add_time_30
* LSCHEPP - Alteração Data/Hora Saída - Nova Definição - 09.01.2023 Fim
      IMPORTING
        e_endtime   = lv_hora
        e_enddate   = lv_data.

    <fs_header>-dsaient = lv_data.
    <fs_header>-hsaient = lv_hora.

  ENDIF.

ENDIF.
