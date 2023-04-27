*&---------------------------------------------------------------------*
*& Include          ZSDI_SUFRAMA
*&---------------------------------------------------------------------*
***********************************************************************
*** © 3corações ***
***********************************************************************
*** *
*** DESCRIÇÃO: Venda Zona Franca de Manaus *
*** AUTOR : Gustavo Santos – Meta *
*** FUNCIONAL: Sandro Seixas  – Meta *
*** DATA : 21/09/2021 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO *
***-------------------------------------------------------------------*
*** | | *
***********************************************************************
DATA lv_suframa TYPE kna1-suframa.

IF vbak-kunnr IS NOT INITIAL.

  SELECT SINGLE suframa
    INTO lv_suframa
    FROM kna1
    WHERE kunnr = vbak-kunnr.
  IF sy-subrc IS INITIAL.
    tkomk-zzsuframa = lv_suframa.
  ENDIF.

ENDIF.
