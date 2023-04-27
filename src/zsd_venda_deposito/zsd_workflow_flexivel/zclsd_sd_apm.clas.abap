CLASS zclsd_sd_apm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_badi_sd_apm .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_SD_APM IMPLEMENTATION.


  METHOD if_badi_sd_apm~get_sdoc_rejection_reason.
***********************************************************************
*** © 3corações                                                     ***
***********************************************************************
*** DESCRIÇÃO: GAP BD9 507 - Workflow Flexível                        *
*** AUTOR : Breno Rocha – Meta                                        *
*** FUNCIONAL: Jana Toledo – Meta                                     *
*** DATA : 16/02/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** 16/02/2022 | Breno Rocha | Codigo inicial                         *
***********************************************************************

    INCLUDE zsdi_badi_sd_apm  IF FOUND.

*  - Fim GAP 507 -----------------------------------------------------
  ENDMETHOD.
ENDCLASS.
