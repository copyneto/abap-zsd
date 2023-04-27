CLASS zclsd_app_ordem_intercompany DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_t_cockpit TYPE TABLE FOR CREATE zi_sd_01_cockpit\\cockpit .
    TYPES:
      ty_cockpit TYPE LINE OF ty_t_cockpit .

    METHODS valida_criacao
      IMPORTING
        !is_cockpit TYPE ty_cockpit
      EXPORTING
        !et_message TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS gc_msgid TYPE syst_msgid VALUE 'ZSD_INTERCOMPANY' ##NO_TEXT.
    CONSTANTS gc_typ_error TYPE syst_msgty VALUE 'E' ##NO_TEXT.
    CONSTANTS gc_typ_sucess TYPE syst_msgty VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_msg_04 TYPE syst_msgno VALUE '004' ##NO_TEXT.
    CONSTANTS gc_msg_05 TYPE syst_msgno VALUE '005' ##NO_TEXT.
    CONSTANTS gc_msg_06 TYPE syst_msgno VALUE '006' ##NO_TEXT.
    CONSTANTS gc_msg_07 TYPE syst_msgno VALUE '007' ##NO_TEXT.
    CONSTANTS gc_param_mod TYPE ze_param_modulo VALUE 'SD' ##NO_TEXT.
    CONSTANTS gc_chave1 TYPE ze_param_chave VALUE 'ADM_INTER' ##NO_TEXT.
    CONSTANTS gc_chave2_exped TYPE ze_param_chave VALUE 'TP_EXPED' ##NO_TEXT.
    CONSTANTS gc_chave3_frota_prop TYPE ze_param_chave_3 VALUE 'FRT_PROP' ##NO_TEXT.
    CONSTANTS gc_msg_08 TYPE syst_msgno VALUE '008' ##NO_TEXT.
    CONSTANTS gc_msg_09 TYPE syst_msgno VALUE '009' ##NO_TEXT.
ENDCLASS.



CLASS zclsd_app_ordem_intercompany IMPLEMENTATION.


  METHOD valida_criacao.

    DATA: lr_tpexp TYPE RANGE OF vsarttr.

    DATA: lv_ok TYPE char1.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    IF is_cockpit-tpfrete EQ '001' " CIF
    OR is_cockpit-tpfrete EQ '002'. " FOB

      IF is_cockpit-ztraid  IS INITIAL
      OR is_cockpit-agfrete IS INITIAL
      OR is_cockpit-motora  IS INITIAL
      OR is_cockpit-tpexp   IS INITIAL
      OR is_cockpit-condexp IS INITIAL.
        et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                id     = gc_msgid
                                                number = gc_msg_08 ) ).
      ENDIF.
    ELSE.
      IF is_cockpit-ztraid  IS NOT INITIAL
      OR is_cockpit-agfrete IS NOT INITIAL
      OR is_cockpit-motora  IS NOT INITIAL
      OR is_cockpit-tpexp   IS NOT INITIAL
      OR is_cockpit-condexp IS NOT INITIAL.
        et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                id     = gc_msgid
                                                number = gc_msg_09 ) ).
      ENDIF.
    ENDIF.

    CASE is_cockpit-tpfrete.
      WHEN '001'. " CIF

        TRY.
            lo_param->m_get_range(
              EXPORTING
                iv_modulo = gc_param_mod
                iv_chave1 = gc_chave1
                iv_chave2 = gc_chave2_exped
                iv_chave3 = gc_chave3_frota_prop
              IMPORTING
                et_range  = lr_tpexp ).
          CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
        ENDTRY.

        SELECT SINGLE lifnr,
                      stcd1
          FROM lfa1
         WHERE lifnr = @is_cockpit-agfrete
          INTO @DATA(ls_lfa1).

        SELECT a~werks,
               a~j1bbranch AS j_1bbranch,
               b~stcd1
          FROM zi_sd_intercmpny_t001w AS a
         INNER JOIN p_businessplace AS b ON b~branch = a~j1bbranch
         WHERE werks = @is_cockpit-werks_receptor
          INTO TABLE @DATA(lt_t001w).

        IF sy-subrc IS INITIAL.
          SORT lt_t001w BY j_1bbranch.
        ENDIF.

        CLEAR lv_ok.
        LOOP AT lt_t001w ASSIGNING FIELD-SYMBOL(<fs_t001w>).

          IF <fs_t001w>-stcd1 = ls_lfa1-stcd1.
            lv_ok = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

        IF is_cockpit-tpexp IN lr_tpexp.
          IF lv_ok IS INITIAL.
            et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                    id     = gc_msgid
                                                    number = gc_msg_04 ) ).
          ENDIF.
        ELSE.
          IF lv_ok IS NOT INITIAL.
            et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                    id     = gc_msgid
                                                    number = gc_msg_05 ) ).
          ENDIF.
        ENDIF.

      WHEN '002'. " FOB
        TRY.
            lo_param->m_get_range(
              EXPORTING
                iv_modulo = gc_param_mod
                iv_chave1 = gc_chave1
                iv_chave2 = gc_chave2_exped
                iv_chave3 = gc_chave3_frota_prop
              IMPORTING
                et_range  = lr_tpexp ).
          CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros
        ENDTRY.

        SELECT SINGLE lifnr,
                      stcd1
          FROM lfa1
         WHERE lifnr = @is_cockpit-agfrete
          INTO @ls_lfa1.

        SELECT a~werks,
               a~j1bbranch AS j_1bbranch,
               b~stcd1
          FROM zi_sd_intercmpny_t001w AS a
         INNER JOIN p_businessplace AS b ON b~branch = a~j1bbranch
         WHERE werks = @is_cockpit-werks_destino
          INTO TABLE @lt_t001w.

        IF sy-subrc IS INITIAL.
          SORT lt_t001w BY j_1bbranch.
        ENDIF.

        CLEAR lv_ok.
        LOOP AT lt_t001w ASSIGNING <fs_t001w>.

          IF <fs_t001w>-stcd1 = ls_lfa1-stcd1.
            lv_ok = abap_true.
            EXIT.
          ENDIF.

        ENDLOOP.

        IF is_cockpit-tpexp IN lr_tpexp.
          IF lv_ok IS INITIAL.
            et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                    id     = gc_msgid
                                                    number = gc_msg_06 ) ).
          ENDIF.
        ELSE.
          IF lv_ok IS NOT INITIAL.
            et_message = VALUE #( BASE et_message ( type   = gc_typ_error
                                                    id     = gc_msgid
                                                    number = gc_msg_07 ) ).
          ENDIF.
        ENDIF.

*      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
