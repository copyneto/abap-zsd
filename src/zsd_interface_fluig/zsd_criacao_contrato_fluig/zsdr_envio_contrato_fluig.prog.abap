***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: SD - Envio Contrato para Fluig                         *
*** AUTOR :    Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Cleverson Faria - META                                 *
*** DATA : 25.07.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 25.07.2023 | Luís Gustavo Schepp   | Desenvolvimento inicial      *
***********************************************************************
REPORT zsdr_envio_contrato_fluig.

************************************************************************
* Declarações
************************************************************************

*-----------------------------------------------------------------------*
* Classe do Report
*-----------------------------------------------------------------------*
CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      main.

  PRIVATE SECTION.

    CLASS-METHODS:
      interface_fluig.

ENDCLASS.

*-Screen parameters----------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_vbeln TYPE vbeln OBLIGATORY,
              p_bstkd TYPE bstkd OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  lcl_report=>main( ).

*-----------------------------------------------------------------------*
* Classe do report
*-----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.

  METHOD main.

    interface_fluig( ).

  ENDMETHOD.

  METHOD interface_fluig.

    DATA ls_output TYPE zclsd_mt_status_contrato.

    ls_output-mt_status_contrato-assignee  = p_bstkd.
    ls_output-mt_status_contrato-comment   = TEXT-002.
    ls_output-mt_status_contrato-ped_fluig = p_bstkd.
    APPEND VALUE #( processado      = TEXT-003 && p_vbeln
                    desc_processado = TEXT-004 && p_vbeln ) TO ls_output-mt_status_contrato-form_fields-lista.

    TRY.
        NEW zclsd_co_si_status_contrato_ou( )->si_status_contrato_out( output = ls_output ).
      CATCH cx_ai_system_fault.
    ENDTRY.

    COMMIT WORK.

  ENDMETHOD.

ENDCLASS.
