*&---------------------------------------------------------------------*
*& Include          ZSDI_APM_IGNORE
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
*** 16/02/2022 | Breno Rocha/Alexsander Haas | Código inicial         *
***********************************************************************

    CONSTANTS: lc_modulo  TYPE ze_param_modulo VALUE 'SD',
               lc_chvave1 TYPE ze_param_chave  VALUE 'WORKFLOW',
               lc_chvave2 TYPE ze_param_chave  VALUE 'TEAMNAME',
               lc_tcode   TYPE ze_param_chave  VALUE 'TCODE'.

    DATA lv_tcode TYPE sy-tcode.
    DATA(lo_param) = NEW zclca_tabela_parametros(  ).

    TRY.
        lo_param->m_get_single(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chvave1
            iv_chave2 = lc_tcode
          IMPORTING
            ev_param  = lv_tcode
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    CHECK sy-tcode EQ lv_tcode.

    DATA lr_team TYPE RANGE OF hr_mcstext.

    TRY.
        lo_param->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chvave1
            iv_chave2 = lc_chvave2
          IMPORTING
            et_range  = lr_team
        ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    SELECT SINGLE usrid
    FROM zi_sd_workflow_aprv
    WHERE TeamName IN @lr_team
      AND usrid EQ @sy-uname
    INTO @DATA(lv_name).

    IF sy-subrc IS INITIAL.
      rv_ignore_apm = abap_true.
    ENDIF.

* - Fim GAP 507 -------------------------------------------------------------------------------
