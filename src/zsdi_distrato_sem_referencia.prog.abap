*&---------------------------------------------------------------------*
*& Include          ZSDI_DISTRATO_SEM_REFERENCIA
*&---------------------------------------------------------------------*
CONSTANTS: BEGIN OF lc_param,
             modulo TYPE ztca_param_par-modulo VALUE 'SD',
             chave1 TYPE ztca_param_par-chave1 VALUE 'DISTRATO_SEM_REF',
             chave2 TYPE ztca_param_par-chave2 VALUE 'TIPO_DOC',
             chave3 TYPE ztca_param_par-chave3 VALUE 'FKART',
           END OF lc_param.

DATA lt_fkart TYPE RANGE OF vbrk-fkart.


DATA(lo_param) = NEW zclca_tabela_parametros( ).
TRY.
    lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                     iv_chave1 = lc_param-chave1
                                     iv_chave2 = lc_param-chave2
                                     iv_chave3 = lc_param-chave3
                           IMPORTING et_range  = lt_fkart ).
    DATA(lt_xaccit_aux) = xaccit[].
    DELETE lt_xaccit_aux WHERE posnr GE '0000001000'.
    DELETE lt_xaccit_aux WHERE rebzg EQ space.
    SELECT vbeln
      FROM vbrk
      INTO TABLE @DATA(lt_vbrk)
      FOR ALL ENTRIES IN @lt_xaccit_aux
      WHERE vbeln EQ @lt_xaccit_aux-rebzg
        AND fkart IN @lt_fkart.
  CATCH cx_sy_itab_line_not_found zcxca_tabela_parametros.
ENDTRY.

* LSCHEPP - SD - 8000007176 - Erro docto contábil - Devoluções - 11.05.2023 Início
IF NOT lt_vbrk IS INITIAL.
* LSCHEPP - SD - 8000007176 - Erro docto contábil - Devoluções - 11.05.2023 Fim

  LOOP AT xaccit ASSIGNING FIELD-SYMBOL(<fs_xaccit2>) WHERE posnr LT '0000001000'.
    IF NOT <fs_xaccit2>-rebzg IS INITIAL.
      READ TABLE lt_vbrk TRANSPORTING NO FIELDS WITH KEY vbeln = <fs_xaccit2>-rebzg.
      IF sy-subrc NE 0.
        CLEAR <fs_xaccit2>-rebzg.
      ENDIF.
    ENDIF.
  ENDLOOP.

* LSCHEPP - SD - 8000007176 - Erro docto contábil - Devoluções - 11.05.2023 Início
ENDIF.
* LSCHEPP - SD - 8000007176 - Erro docto contábil - Devoluções - 11.05.2023 Fim
