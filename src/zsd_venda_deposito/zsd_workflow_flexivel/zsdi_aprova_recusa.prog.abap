*&---------------------------------------------------------------------*
*& Include          ZSDI_APROVA_RECUSA
*&---------------------------------------------------------------------*

 CONSTANTS: lc_modulo   TYPE ztca_param_par-modulo VALUE 'SD',
            lc_chave1   TYPE ztca_param_par-chave1 VALUE 'WORKFLOW',
            lc_auart    TYPE ztca_param_par-chave2 VALUE 'AUART',
            lc_vtweg    TYPE ztca_param_par-chave2 VALUE 'VTWEG',
            lc_lifsk    TYPE ztca_param_par-chave2 VALUE 'LIFSK',
            lc_cmgst    TYPE ztca_param_par-chave2 VALUE 'CMGST',
            lc_spart    TYPE ztca_param_par-chave2 VALUE 'SPART',
            lc_reason   TYPE sd_apm_approval_reason VALUE '0001',
            lc_status_a TYPE cmgst VALUE 'A',
            lc_status_d TYPE cmgst VALUE 'D'.


 DATA(lo_param) = NEW zclca_tabela_parametros( ).
 DATA: ls_vbak  TYPE vbak.


 TRY.

     lo_param->m_get_single( EXPORTING iv_modulo = lc_modulo
                                       iv_chave1 = lc_chave1
                                       iv_chave2 = lc_auart
                             IMPORTING ev_param = ls_vbak-auart ).

     lo_param->m_get_single( EXPORTING iv_modulo = lc_modulo
                                       iv_chave1 = lc_chave1
                                       iv_chave2 = lc_vtweg
                             IMPORTING ev_param = ls_vbak-vtweg ).

     lo_param->m_get_single( EXPORTING iv_modulo = lc_modulo
                                       iv_chave1 = lc_chave1
                                       iv_chave2 = lc_spart
                             IMPORTING ev_param = ls_vbak-spart ).

     IF us_vbak-vtweg = ls_vbak-vtweg
    AND us_vbak-auart = ls_vbak-auart
    AND us_vbak-spart = ls_vbak-spart
    AND us_vbak-lifsk IS INITIAL
    AND ( us_vbuk-cmgst = lc_status_a OR
          us_vbuk-cmgst = lc_status_d ).
       us_vbak-apm_approval_reason = lc_reason.
       us_vbak-apm_approval_status = lc_status_a. "Em aprovação
     ENDIF.

   CATCH zcxca_tabela_parametros INTO DATA(lo_catch).
*     Os parametros do WF podem não ser utilizados,
*     Badi segue com implementação padrão.

 ENDTRY.
