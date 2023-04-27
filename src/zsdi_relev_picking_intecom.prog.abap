***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Relevância Picking Intercompany                        *
*** AUTOR    : Luís Gustavo Schepp – META                             *
*** FUNCIONAL: Volnei André Noetzold – META                           *
*** DATA     : 20/12/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_RELEV_PICKING_INTECOM
*&---------------------------------------------------------------------*

IF likp-lfart EQ 'Z004'. "Remessa de intercompany
  IF  lips-vgbel IS NOT INITIAL.
    SELECT COUNT( * )
      FROM ztsd_intercompan
      WHERE processo     EQ '2' "Intercompany
        AND tipooperacao EQ 'INT4'
        AND salesorder   EQ lips-vgbel.
    IF sy-subrc = 0.
      "Primeira etapa de operação triangular não é relevante para picking.
      CLEAR lips-komkz.
    ENDIF.
  ENDIF.
ENDIF.
