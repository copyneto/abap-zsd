***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Exportação de arquivos bancários para VAN              *
*** AUTOR : Everthon Costa – Meta                                     *
*** FUNCIONAL: Sandro – Meta                                          *
*** DATA : 27/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR          | DESCRIÇÃO                            *
***-------------------------------------------------------------------*
*** 27/04/22  | ECOSTA         | Cópia ECC to S4                      *
***********************************************************************
REPORT ZFIR_BANCARIO002 MESSAGE-ID zfi_bancario.

INCLUDE zfii_bancario_002cx1.  "Include classes de exceção
INCLUDE zfii_bancario_002cl1.  "Include de classes

START-OF-SELECTION.
  "Lógica do processamento de arquivos bancários.
  lcl_main_report=>create_instance( )->main( ).
