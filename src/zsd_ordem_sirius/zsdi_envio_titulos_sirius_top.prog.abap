***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: SD-164 - Envio de títulos do cliente para SIRIUS       *
*** AUTOR : Anderson Miazato - META                                   *
*** FUNCIONAL: Cleverson Faria - META                                 *
*** DATA : 05.11.2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 05.11.2021 | Anderson Miazato   | Desenvolvimento inicial         *
***********************************************************************

*&---------------------------------------------------------------------*
*& Include zsdi_envio_titulos_sirius_top
*&---------------------------------------------------------------------*

TYPES:
  BEGIN OF ty_selscreen,
    s_perio TYPE RANGE OF sy-datum,
  END OF ty_selscreen.

DATA:
  gs_selscreen TYPE ty_selscreen.
