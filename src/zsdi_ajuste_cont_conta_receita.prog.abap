***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: SD - Ajuste na contabilização da conta receita         *
*** AUTOR    : Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Cleverson Faria - META                                 *
*** DATA     : 05.04.2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 05.04.2022 | Luís Gustavo Schepp   | Desenvolvimento inicial      *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_AJUSTE_CONT_CONTA_RECEITA
*&--------------------------------------------------------------------*

  CONSTANTS: BEGIN OF lc_param,
               modulo TYPE ztca_param_par-modulo VALUE 'SD',
               vkoa   TYPE ztca_param_par-chave1 VALUE 'VKOA',
               ex     TYPE ztca_param_par-chave2 VALUE 'EX',
               in     TYPE ztca_param_par-chave2 VALUE 'IN',
               cod3   TYPE char01 VALUE '3',
               erl    TYPE kvsl1 VALUE 'ERL',
             END OF lc_param.

  DATA: lt_ex    TYPE RANGE OF ktgrm,
        lt_in    TYPE RANGE OF ktgrm,
        lt_ktgrm TYPE RANGE OF ktgrm.

  DATA(lo_param) = NEW zclca_tabela_parametros( ).

  TRY.
      lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                       iv_chave1 = lc_param-vkoa
                                       iv_chave2 = lc_param-ex
                             IMPORTING et_range  = lt_ex ).
      APPEND LINES OF lt_ex TO lt_ktgrm.
    CATCH zcxca_tabela_parametros.
  ENDTRY.

  TRY.
      lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                       iv_chave1 = lc_param-vkoa
                                       iv_chave2 = lc_param-in
                             IMPORTING et_range  = lt_in ).
      APPEND LINES OF lt_in TO lt_ktgrm.
    CATCH zcxca_tabela_parametros.
  ENDTRY.

  DATA(lt_vbrp_aux) = it_vbrp.
  DELETE lt_vbrp_aux WHERE ktgrm NOT IN lt_ktgrm.

  IF NOT lt_vbrp_aux IS INITIAL.

    SELECT pstyv, ktgrm, sakn1
      FROM c615
      INTO TABLE @DATA(lt_c615)
      FOR ALL ENTRIES IN @lt_vbrp_aux
      WHERE pstyv EQ @lt_vbrp_aux-pstyv
        AND ktgrm EQ @lt_vbrp_aux-ktgrm
        AND kvsl1 EQ @lc_param-erl.

    SELECT ktgrm, sakn1
      FROM c620
      INTO TABLE @DATA(lt_c620)
      FOR ALL ENTRIES IN @lt_vbrp_aux
      WHERE ktgrm EQ @lt_vbrp_aux-ktgrm
        AND kvsl1 EQ @lc_param-erl.

    LOOP AT et_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-cod_cta(1) EQ lc_param-cod3.
        TRY.
            DATA(ls_vbrp) = lt_vbrp_aux[ posnr = <fs_item>-itmnum ].
            IF ls_vbrp-bwtar IS INITIAL OR
               ( NOT ls_vbrp-bwtar IS INITIAL AND ls_vbrp-bwtar+8(2) EQ 'EX' ).
              ls_vbrp-ktgrm = '03'.
            ELSEIF ls_vbrp-bwtar+8(2) EQ 'IN'.
              ls_vbrp-ktgrm = '01'.
            ENDIF.
            TRY.
                <fs_item>-cod_cta = lt_c615[ pstyv = ls_vbrp-pstyv
                                             ktgrm = ls_vbrp-ktgrm ]-sakn1.
              CATCH cx_sy_itab_line_not_found.
                <fs_item>-cod_cta = lt_c620[ ktgrm = ls_vbrp-ktgrm ]-sakn1.
            ENDTRY.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDIF.
