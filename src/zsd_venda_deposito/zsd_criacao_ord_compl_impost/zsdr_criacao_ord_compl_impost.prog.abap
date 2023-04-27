***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO:Chamada de BAPI para criar ordem complementar de imposto*
*** AUTOR    : ZENILDA LIMA   –[META]                                 *
*** FUNCIONAL: JANA CASTILHOS –[META]                                 *
*** DATA     : 21.10.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
REPORT zsdr_criacao_ord_compl_impost.
TABLES vbak.

*----------------------------------------------------------------------*
* TELA DE SELEÇÃO
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS: s_erdat  FOR sy-datum   OBLIGATORY,
                  s_auart  FOR vbak-auart OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b1.
*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.

  DATA lo_cl_bol TYPE REF TO zclsd_criacao_ord_compl_impost.

  CREATE OBJECT lo_cl_bol.
*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  DATA: lt_return TYPE  bapiret2_tab.
  CLEAR: lt_return.
  lo_cl_bol->process( EXPORTING iv_erdat = s_erdat[]
                                iv_auart = s_auart[]
                      IMPORTING et_return = lt_return ).

  lo_cl_bol->log_process( it_return = lt_return[] ).
