*&---------------------------------------------------------------------*
*& Include ZSDI_CKPT_FAT_VALIDA_REMESSA
*&---------------------------------------------------------------------*

"Verifica se a chamada faz parte do app de Faturamento.
FIELD-SYMBOLS <fs_app_fat> TYPE abap_bool.
ASSIGN ('(SAPLZFGSD_COCKPIT_FATURAMENTO)GV_APP_FAT') TO <fs_app_fat>.

IF <fs_app_fat> IS ASSIGNED.
*Validação de mensagem Documentos Incompletos
  CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
             lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
             lc_chave2 TYPE ztca_param_par-chave2 VALUE 'TIPOS_DE_DOCUMENTO',
             lc_chave3 TYPE ztca_param_par-chave3 VALUE 'LOG_INC.'.

** Seleçao dos parametros
  DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023
  DATA: lr_auart  TYPE RANGE OF vbak-auart.
  CLEAR: lr_auart .

*Buscar TIPO OV
  TRY.
      lo_parametros->m_get_range(
        EXPORTING
          iv_modulo = lc_modulo
          iv_chave1 = lc_chave1
          iv_chave2 = lc_chave2
          iv_chave3 = lc_chave3
        IMPORTING
          et_range  = lr_auart ).
    CATCH zcxca_tabela_parametros.
      "handle exception
  ENDTRY.

  IF  iv_msgid = 'VU' AND
      iv_msgvs <> 'E'  AND
    ( lf_msgno = '013' OR
      lf_msgno = '014' OR
      lf_msgno = '019' OR
      lf_msgno = '020' ).

    IF cvbak-auart IN lr_auart.

      ev_msgty = 'E'.

    ENDIF.
  ENDIF.

ENDIF.
