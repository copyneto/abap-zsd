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
*& Report zsdi_envio_titulos_sirius
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdi_envio_titulos_sirius MESSAGE-ID zsd_ordem_sirius.

INCLUDE zsdi_envio_titulos_sirius_top.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_perio FOR sy-datum.
SELECTION-SCREEN END OF BLOCK b1.



START-OF-SELECTION.

  gs_selscreen-s_perio = s_perio[].

  NEW zclsd_envio_titulos_sirius( gs_selscreen )->main( ).
