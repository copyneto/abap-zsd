***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Referência de Bonificação                              *
*** AUTOR : Victor Silva – META                                      *
*** FUNCIONAL: Cleverson Faria – META                                  *
*** DATA : 04/03/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&---------------------------------------------------------------------*
*& Include          ZSDI_REFER_BONIFICACAO
*&---------------------------------------------------------------------*
  CONSTANTS: lc_param_modulo TYPE ze_param_modulo VALUE 'SD',
             lc_param_chave1 TYPE ze_param_chave VALUE 'BONIFICACAO',
             lc_param_chave2 TYPE ze_param_chave VALUE 'TIPOS_OV'.

  IF vbkd-ihrez IS NOT INITIAL.
    DATA(lv_vbelv) = |{ vbkd-ihrez(10) ALPHA = IN }|.

    SELECT SINGLE low
      INTO @DATA(lv_low)
      FROM ztca_param_val
      WHERE modulo = @lc_param_modulo
        AND chave1 = @lc_param_chave1
        AND chave2 = @lc_param_chave2
        AND low = @vbrk-fkart.
    IF sy-subrc IS INITIAL.

      SELECT COUNT(*) FROM vbak
        WHERE
        vbeln = @lv_vbelv.

      IF sy-subrc = 0.

* LSCHEPP - SD - 8000006867 - Número NF de referência - 16.05.2023 Início
*        SELECT COUNT(*) FROM vbfa
*        WHERE vbelv = @lv_vbelv
*        AND vbtyp_n = 'M'.
*        IF sy-subrc <> 0.
*          MESSAGE e007(zsd) WITH vbkd-ihrez. "Faturar OV & antes de faturar a bonificação
*        ENDIF.
*        SELECT SINGLE vbeln
*          FROM vbfa
*          INTO @DATA(lv_vbeln)
*          WHERE vbelv   = @lv_vbelv
*            AND vbtyp_n = 'M'.
*        IF sy-subrc NE 0.
*          MESSAGE e007(zsd) WITH vbkd-ihrez. "Faturar OV & antes de faturar a bonificação
*        ELSE.
*          SELECT SINGLE docnum
*            FROM j_1bnflin
*            INTO @DATA(lv_docnum)
*            WHERE refkey = @lv_vbeln.
*          IF sy-subrc EQ 0.
*            SELECT SINGLE code
*              FROM j_1bnfe_active
*              INTO @DATA(lv_status)
*              WHERE docnum = @lv_docnum.
*            IF sy-subrc EQ 0.
*              DO 90 TIMES.
*                CASE lv_status.
*                  WHEN '100'.
*                    EXIT.
*                  WHEN ' '.
*                  WHEN OTHERS.
*                    MESSAGE e012(zsd) WITH vbkd-ihrez. "Ordem de referência &1 não faturada na SEFAZ.
*                ENDCASE.
*                WAIT UP TO 1 SECONDS.
*              ENDDO.
*              IF lv_status IS INITIAL.
*                MESSAGE e013(zsd) WITH lv_docnum. "Docnum de referência & sem retorno da SEFAZ.
*              ENDIF.
*            ENDIF.
*          ENDIF.
*        ENDIF.
* LSCHEPP - SD - 8000007698 - REF DA BONIFICAÇÃO GAP175 - 22.05.2023 Início
        SELECT vbeln
          FROM vbfa
          INTO TABLE @DATA(lt_vbeln)
          WHERE vbelv   = @lv_vbelv
            AND vbtyp_n = 'M'.
        IF sy-subrc NE 0.
          MESSAGE e007(zsd) WITH vbkd-ihrez. "Faturar OV & antes de faturar a bonificação
        ELSE.
          "Verifica se ocorreu estorno de fatura
          SELECT vbelv
            FROM vbfa
            INTO TABLE @DATA(lt_estorno)
            FOR ALL ENTRIES IN @lt_vbeln
            WHERE vbelv   = @lt_vbeln-vbeln
              AND vbtyp_n = 'N'.
          IF sy-subrc EQ 0.
            LOOP AT lt_vbeln  ASSIGNING FIELD-SYMBOL(<fs_vbeln>).
              DATA(lv_tabix) = sy-tabix.
              IF line_exists( lt_estorno[ vbelv = <fs_vbeln>-vbeln ] ).
                DELETE lt_vbeln INDEX lv_tabix.
              ENDIF.
            ENDLOOP.
            TRY.
                DATA(lv_vbeln) = lt_vbeln[ 1 ]-vbeln.
                SELECT SINGLE docnum
                  FROM j_1bnflin
                  INTO @DATA(lv_docnum)
                  WHERE refkey = @lv_vbeln.
                IF sy-subrc EQ 0.
                  SELECT SINGLE code
                    FROM j_1bnfe_active
                    INTO @DATA(lv_status)
                    WHERE docnum EQ @lv_docnum
                      AND nfnum9 NE @space.
                  IF sy-subrc EQ 0.
                    DO 90 TIMES.
                      CASE lv_status.
                        WHEN '100'.
                          EXIT.
                        WHEN ' '.
                        WHEN OTHERS.
                          MESSAGE e012(zsd) WITH vbkd-ihrez. "Ordem de referência &1 não faturada na SEFAZ.
                      ENDCASE.
                      WAIT UP TO 1 SECONDS.
                    ENDDO.
                    IF lv_status IS INITIAL.
                      MESSAGE e013(zsd) WITH lv_docnum. "Docnum de referência & sem retorno da SEFAZ.
                    ENDIF.
                  ENDIF.
                ENDIF.
              CATCH cx_sy_itab_line_not_found.
                MESSAGE e012(zsd) WITH vbkd-ihrez. "Ordem de referência &1 não faturada na SEFAZ.
            ENDTRY.
          ENDIF.
        ENDIF.
* LSCHEPP - SD - 8000007698 - REF DA BONIFICAÇÃO GAP175 - 22.05.2023 Fim
* LSCHEPP - SD - 8000006867 - Número NF de referência - 16.05.2023 Fim
      ENDIF.
    ENDIF.
  ENDIF.
