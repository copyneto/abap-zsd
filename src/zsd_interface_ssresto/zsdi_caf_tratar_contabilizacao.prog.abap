*&---------------------------------------------------------------------*
*& Include          ZSDI_CAF_TRATAR_CONTABILIZACAO
*&---------------------------------------------------------------------*
***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Include Tratar Contabilização                          *
*** AUTOR    : VICTOR ARAÚJO –[META]                                  *
*** FUNCIONAL: [CLEVERSON FARIA] –[META]                              *
*** DATA     : [28/12/21]                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
***           |              |                                        *
***********************************************************************

DATA(lo_tratar_contabilizacao) = NEW zclsd_caftratar_contabilizacao( ).
lo_tratar_contabilizacao->executar( EXPORTING
                                         is_cvbrk  = cvbrk
                                         is_cvbrp  = cvbrp
                                    CHANGING
                                         ct_xaccit = xaccit[]
                                         ct_xaccfi = xaccfi[]
                                         ct_xacccr = xacccr[] ).
