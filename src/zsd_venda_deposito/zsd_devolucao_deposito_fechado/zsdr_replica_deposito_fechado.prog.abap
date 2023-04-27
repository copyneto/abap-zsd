***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Replicação das notas de devolução depósito fechado     *
*** AUTOR    : FLÁVIA LEITE –[META]                                   *
*** FUNCIONAL: JANA CASTILHOS –[META]                                 *
*** DATA     : 21.10.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************
REPORT zsdr_replica_deposito_fechado.

TABLES j_1bnfdoc.

*----------------------------------------------------------------------*
* TELA DE SELEÇÃO
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN COMMENT 1(31) TEXT-p01 FOR FIELD p_data1.
    PARAMETERS: p_data1 LIKE j_1bnfdoc-docdat.
    SELECTION-SCREEN COMMENT 52(5) TEXT-p02 FOR FIELD p_data2.
    PARAMETERS: p_data2 LIKE j_1bnfdoc-docdat DEFAULT sy-datum.
  SELECTION-SCREEN END OF LINE.

  SELECT-OPTIONS: s_docnum FOR j_1bnfdoc-docnum.

SELECTION-SCREEN END OF BLOCK b1.
*----------------------------------------------------------------------*
* INITIALIZATION
*----------------------------------------------------------------------*
INITIALIZATION.
  DATA(go_replica_deposito_fechado) = NEW zclsd_replica_deposito_fechado( ).
  GET REFERENCE OF s_docnum[] INTO go_replica_deposito_fechado->gs_refdata-docnum.
*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  go_replica_deposito_fechado->executar( iv_data1 = p_data1 iv_data2 = p_data2 ).
