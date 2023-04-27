***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Criar Ordem de Vendas                                  *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: CLEVERSON FARIA –[META]                                *
*** DATA     : 05.11.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
REPORT zsdr_ionz_criar_ov.

TABLES ztsd_sint_proces.

*----------------------------------------------------------------------*
* TELA DE SELEÇÃO
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_id FOR ztsd_sint_proces-id.
SELECTION-SCREEN END OF BLOCK b1.
*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  DATA(go_cria_ov) = NEW zclsd_ionz_criar_ov( ).
  GET REFERENCE OF s_id[] INTO go_cria_ov->gs_refdata-id.
*----------------------------------------------------------------------*
* AT SELECTION-SCREEN.
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  go_cria_ov->seleciona_dados( ).
*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  go_cria_ov->executar( ).
