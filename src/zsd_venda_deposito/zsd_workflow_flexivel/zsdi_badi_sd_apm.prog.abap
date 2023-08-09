*&---------------------------------------------------------------------*
*& Include          ZSDI_BADI_SD_APM
*&---------------------------------------------------------------------*
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
    CONSTANTS: lc_modulo TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'WORKFLOW',
               lc_reject TYPE ztca_param_par-chave1 VALUE 'REJECT'.


    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023


    TRY.

        lo_param->m_get_single( EXPORTING iv_modulo = lc_modulo
                                          iv_chave1 = lc_chave1
                                          iv_chave2 = lc_reject
                                IMPORTING ev_param = cv_sdoc_rejection_reason ).


      CATCH zcxca_tabela_parametros INTO DATA(lo_catch).
*     Os parametros do WF podem não ser utilizados,
*     Badi segue com implementação padrão.

    ENDTRY.
* - Fim GAP 507 --------------------------------------------------------
