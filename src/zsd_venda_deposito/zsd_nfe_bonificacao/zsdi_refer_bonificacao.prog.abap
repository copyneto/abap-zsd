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

        SELECT COUNT(*) FROM vbfa
        WHERE vbelv = @lv_vbelv
        AND vbtyp_n = 'M'.
        IF sy-subrc <> 0.
          MESSAGE e007(zsd) WITH vbkd-ihrez. "Faturar OV & antes de faturar a bonificação
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
