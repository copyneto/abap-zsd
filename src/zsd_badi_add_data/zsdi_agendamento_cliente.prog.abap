***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Preenchimento da agenda do cliente                     *
*** AUTOR    : Alysson Anjos – META                                   *
*** FUNCIONAL: Sandro Seixas – META                                   *
*** DATA     : 13/07/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_AGENDAMENTO_CLIENTE
*&---------------------------------------------------------------------*

IF is_header-parid IS NOT INITIAL.

  DATA(lo_agd_client) = NEW zclsd_agendamt_cliente( ).

  lo_agd_client->monta_horarios( EXPORTING iv_kunnr   = is_header-parid
                                 IMPORTING ev_segunda = DATA(lv_segunda)
                                           ev_terca   = DATA(lv_terca)
                                           ev_quarta  = DATA(lv_quarta)
                                           ev_quinta  = DATA(lv_quinta)
                                           ev_sexta   = DATA(lv_sexta)
                                           ev_ntfound = DATA(lv_ntfound) ).
  IF lv_ntfound IS INITIAL.

    cs_header-infcpl = |{ cs_header-infcpl } { TEXT-t01 }|.

    IF lv_segunda IS NOT INITIAL.
      cs_header-infcpl = |{ cs_header-infcpl } { lv_segunda }|.
    ENDIF.
    IF lv_terca IS NOT INITIAL.
      cs_header-infcpl = |{ cs_header-infcpl } { lv_terca }|.
    ENDIF.
    IF lv_quarta IS NOT INITIAL.
      cs_header-infcpl = |{ cs_header-infcpl } { lv_quarta }|.
    ENDIF.
    IF lv_quinta IS NOT INITIAL.
      cs_header-infcpl = |{ cs_header-infcpl } { lv_quinta }|.
    ENDIF.
    IF lv_sexta IS NOT INITIAL.
      cs_header-infcpl = |{ cs_header-infcpl } { lv_sexta }|.
    ENDIF.
  ENDIF.

ENDIF.
