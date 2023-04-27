***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: GNRE: Job para a geração dos documentos                *
*** AUTOR : Everthon Costa – Meta                                     *
*** FUNCIONAL: Sandro – Meta                                          *
*** DATA : 08/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR          | DESCRIÇÃO                            *
***-------------------------------------------------------------------*
*** 25/04/22  | ECOSTA         | Cópia ECC to S4                      *
***********************************************************************
REPORT zsdr_gnre004 MESSAGE-ID zsd_gnre.

* Includes
*-----------------------------------------------------------------------
INCLUDE: zsdi_gnre004_top,   "Variáveis globais
         zsdi_gnre004_sc01,  "Telas de seleção
         zsdi_gnre004_cd01,  "Definição de classes locais
         zsdi_gnre004_ci01.  "Implementação de classes locais

START-OF-SELECTION.
  lcl_gnre_report=>create_instance( )->main( ).
