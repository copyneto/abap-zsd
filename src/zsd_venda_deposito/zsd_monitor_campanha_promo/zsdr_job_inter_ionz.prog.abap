***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Processa interface com a tabela ZIONZ                  *
*** AUTOR    : WIllian Hazor   – META                                 *
*** FUNCIONAL: Cleverson Faria – META                                 *
*** DATA     : 24.02.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR                 | DESCRIÇÃO                     *
***-------------------------------------------------------------------*
*** 24.02.22  | Willian Hazor         | Criação do programa           *
***********************************************************************
REPORT zsdr_job_inter_ionz.
*********************************************************************
* TABLES                                                            *
*********************************************************************
TABLES: ztsd_ionz.
*********************************************************************
* TELA DE SELEÇÃO                                                   *
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS:
    p_lote   TYPE i.

SELECTION-SCREEN END OF BLOCK b1.
**********************************************************************
* EVENTOS                                                            *
**********************************************************************

INITIALIZATION.
  "Cria instancia
  DATA(lo_interface) = new zclsd_interface_ionz( ).

**********************************************************************
* LOGICA PRINCIPAL
**********************************************************************
START-OF-SELECTION.

  lo_interface->processo_ionz( iv_lote = p_lote ).
