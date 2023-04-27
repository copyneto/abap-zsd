*&---------------------------------------------------------------------*
*& Include          ZSDI_CONTROLE_REMESSA
*&---------------------------------------------------------------------*

*Validação de mensagem Documentos Incompletos
    CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'TIPOS_DE_DOCUMENTO',
               lc_chave3 TYPE ztca_param_par-chave3 VALUE 'LOG_INC.'.

** Seleçao dos parametros
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).
    DATA: lr_lfart   TYPE RANGE OF lfart.
    CLEAR: lr_lfart .

*Buscar TIPO OV
    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
            iv_chave3 = lc_chave3
          IMPORTING
            et_range  = lr_lfart ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

    IF  sy-msgid = 'VU' AND
        sy-msgty = 'W'  AND
      ( sy-msgno = '013' OR
        sy-msgno = '014' OR
        sy-msgno = '019' OR
        sy-msgno = '020' ).

      IF xlikp-lfart IN lr_lfart
        AND line_exists( xlikp[ zz1_matricula_dlh = abap_false ] ).

        MESSAGE e013(vu).

      ENDIF.
    ENDIF.

*Validação de mensagem Documentos Incompletos quando vem do APP Fiori
*Memória EXIT 'FV50XF0M' INCLUDE 'ZSDI_VALIDA_REMESSA'
    DATA lv_msgid_i TYPE syst_msgid.
    DATA lv_msgty_i TYPE syst_msgty.
    DATA lv_msgno_i TYPE syst_msgno.

    IMPORT  lv_msgid  TO lv_msgid_i
            lv_msgty  TO lv_msgty_i
            lv_msgno  TO lv_msgno_i     FROM MEMORY ID 'ZD_DOC_INC'.

    IF lv_msgid_i   = 'VU'    AND
       lv_msgty_i   = 'W'     AND
     ( lv_msgno_i   = '013'   OR
       lv_msgno_i   = '014'   OR
       lv_msgno_i   = '019'   OR
       lv_msgno_i   = '020' ) AND
       sy-tcode     = 'VL01N' .


      IF xlikp-lfart IN lr_lfart
        AND line_exists( xlikp[ zz1_matricula_dlh = abap_false ] ).

        MESSAGE e013(vu).

      ENDIF.

      FREE MEMORY ID 'ZD_DOC_INC'.

    ENDIF.

*Bloquei para eliminação
    CONSTANTS: lc_modulo_del TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_del TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chave2_del TYPE ztca_param_par-chave2 VALUE 'TIPOS_OV',
               lc_chave3_del TYPE ztca_param_par-chave3 VALUE ''.

    CONSTANTS: lc_modulo_del2 TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1_del2 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
               lc_chave2_del2 TYPE ztca_param_par-chave2 VALUE 'BLOQ_REMESSA',
               lc_chave3_del2 TYPE ztca_param_par-chave3 VALUE 'ELIM_REM'.

    IF xlikp-updkz = 'D'
      AND v50agl-new_del_mode NE space
      AND t180-bldgr(1) = 'E'.

** Seleçao dos parametros
      DATA:  lr_lfart_del   TYPE RANGE OF lfart.
      DATA:  lr_lifsk_del   TYPE RANGE OF lifsk.
      CLEAR: lr_lfart_del, lr_lifsk_del.

*Buscar TIPO OV
      TRY.
          lo_parametros->m_get_range(
            EXPORTING
              iv_modulo = lc_modulo_del
              iv_chave1 = lc_chave1_del
              iv_chave2 = lc_chave2_del
              iv_chave3 = lc_chave3_del
            IMPORTING
              et_range  = lr_lfart_del ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

*Buscar Motivo Bloqueio
      TRY.
          lo_parametros->m_get_range(
            EXPORTING
              iv_modulo = lc_modulo_del2
              iv_chave1 = lc_chave1_del2
              iv_chave2 = lc_chave2_del2
              iv_chave3 = lc_chave3_del2
            IMPORTING
              et_range  = lr_lifsk_del ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.

      IF  xlikp-lfart IN lr_lfart_del
          AND ( NOT xlikp-lifsk IN lr_lifsk_del )
          AND xlikp-lifsk IS NOT INITIAL.

        MESSAGE i017(zsd_ckpt_faturamento) DISPLAY LIKE 'E'.
        CALL SCREEN '4004'.

      ENDIF.
    ENDIF.
