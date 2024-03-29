class ZCLSD_SD_APM_APPROVAL definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_SD_APM_SET_APPROVAL_REASON .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_SD_APM_APPROVAL IMPLEMENTATION.


  METHOD if_sd_apm_set_approval_reason~set_approval_reason.


    CONSTANTS: lc_modulo TYPE ztca_param_par-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'WORKFLOW',
               lc_auart  TYPE ztca_param_par-chave2 VALUE 'AUART',
               lc_vtweg  TYPE ztca_param_par-chave2 VALUE 'VTWEG',
               lc_lifsk  TYPE ztca_param_par-chave2 VALUE 'LIFSK',
               lc_cmgst  TYPE ztca_param_par-chave2 VALUE 'CMGST',
               lc_spart  TYPE ztca_param_par-chave2 VALUE 'SPART',
               lc_reason TYPE sd_apm_approval_reason VALUE '0001'.


    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023
    DATA: ls_vbak  TYPE vbak,
          lt_xvbak TYPE STANDARD TABLE OF vbakvb,
          ls_xvbak TYPE vbakvb,
          ls_xvbuk TYPE vbukvb.


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



        ASSIGN ('(SAPMV45A)XVBAK') TO FIELD-SYMBOL(<fs_xvbak>).
        IF <fs_xvbak> IS ASSIGNED.
          ls_xvbak =  <fs_xvbak>.
        ENDIF.

        ASSIGN ('(SAPMV45A)XVBUK') TO FIELD-SYMBOL(<fs_xvbuk>).
        IF <fs_xvbuk> IS ASSIGNED.
          ls_xvbuk =  <fs_xvbuk>.
        ENDIF.

        IF salesdocument-distributionchannel  = ls_vbak-vtweg
       AND salesdocument-salesdocumenttype    = ls_vbak-auart
       AND salesdocument-organizationdivision = ls_vbak-spart
       AND salesdocument-salesdocument IS INITIAL.
* LSCHEPP - 8000006769 - Workflow liberação PO exportação SIRIUS - 27.04.2023 Início
***       AND ls_xvbak-lifsk IS INITIAL.
* LSCHEPP - 8000006769 - Workflow liberação PO exportação SIRIUS - 27.04.2023 Fim
*       AND ( ls_xvbuk-cmgst = 'A' OR
*             ls_xvbuk-cmgst = 'D' ).
          salesdocapprovalreason = lc_reason.
* LSCHEPP - 8000006769 - Workflow liberação PO exportação SIRIUS - 03.05.2023 Início
        ELSEIF salesdocument-distributionchannel  = ls_vbak-vtweg
           AND salesdocument-salesdocumenttype    = ls_vbak-auart
           AND salesdocument-organizationdivision = ls_vbak-spart
           AND salesdocument-salesdocument IS NOT INITIAL.
          SELECT SINGLE apm_approval_reason
            FROM vbak
            INTO @salesdocapprovalreason
            WHERE vbeln EQ @salesdocument-salesdocument.
* LSCHEPP - 8000006769 - Workflow liberação PO exportação SIRIUS - 03.05.2023 Fim
        ENDIF.

      CATCH zcxca_tabela_parametros INTO DATA(lo_catch).
*     Os parametros do WF podem não ser utilizados,
*     Badi segue com implementação padrão.

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
