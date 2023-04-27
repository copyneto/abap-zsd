CLASS zclsd_interface_ionz DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      "! Processa interface
      "! @parameter iv_lote  |Tamanho do lote
      processo_ionz
        IMPORTING
          iv_lote TYPE i.

  PROTECTED SECTION.
private section.


  constants GC_MSG_CLASSE type CHAR30 value 'ZSD_INTERFACE_IONZ' ##NO_TEXT.
  constants GC_MSG_001 type CHAR03 value '001' ##NO_TEXT.
  constants GC_MSG_002 type CHAR03 value '002' ##NO_TEXT.
  constants GC_MSG_003 type CHAR03 value '003' ##NO_TEXT.
  constants GC_MSG_004 type CHAR03 value '004' ##NO_TEXT.
  constants GC_MSG_005 type CHAR03 value '005' ##NO_TEXT.
  constants GC_MSG_006 type CHAR03 value '006' ##NO_TEXT.
  constants GC_MSG_007 type CHAR03 value '007' ##NO_TEXT.
  constants GC_MSGTY_E type C value 'E' ##NO_TEXT.
  constants GC_MSGTY_S type C value 'S' ##NO_TEXT.
  constants GC_MSGTY_W type C value 'W' ##NO_TEXT.
  constants GC_OBJECT type BALOBJ_D value 'ZSD_INTERFACE_IONZ' ##NO_TEXT.
  constants GC_SUBOBJECT type BALSUBOBJ value 'ZSD_INTERFACE_IONZ' ##NO_TEXT.
  data:
    gt_ztsd_sint_proces TYPE TABLE OF ztsd_sint_proces .
  data GT_MSG_TAB type BAL_T_MSG .

      "! Salva execução da Ballog
  methods SAVE_LOG .
ENDCLASS.



CLASS ZCLSD_INTERFACE_IONZ IMPLEMENTATION.


  METHOD processo_ionz.
    DATA: ls_busca_output  TYPE zsdmt_cadastros_buscar,
          ls_busca_input   TYPE zsdmt_cadastros_buscar_resp,
          ls_status_output TYPE zsdmt_enviar_status_cadastro,
          ls_status_input  TYPE zsdmt_enviar_status_cadastro_r.

    DATA: lt_ztsd_sint_proces TYPE TABLE OF ztsd_sint_proces,
          lv_char(10)         TYPE c,
          lv_data1            TYPE datum,
          lv_data2            TYPE datum,
          lv_hora             TYPE tims.

    IF iv_lote IS NOT INITIAL.
      ls_busca_output-mt_cadastros_buscar-quantidade = iv_lote.
    ENDIF.

    APPEND VALUE #(
      msgty     = gc_msgty_s
      msgid     = gc_msg_classe
      msgno     = gc_msg_002
      msgv1     = CONV symsgv( iv_lote ) ) TO gt_msg_tab.

    TRY.
        DATA(lo_zionz) = NEW zclsdco_si_buscar_cadast_out( ).

        lo_zionz->si_buscar_cadastros_out_sync(
          EXPORTING
            output = ls_busca_output
          IMPORTING
             input  = ls_busca_input ).
      CATCH cx_ai_system_fault.
        APPEND VALUE #(
            msgty     = gc_msgty_e
            msgid     = gc_msg_classe
            msgno     = gc_msg_001
            msgv1     = CONV symsgv( iv_lote ) ) TO gt_msg_tab.
        save_log( ).
        EXIT.
      CATCH zsdcx_fmt_cadastros.
        APPEND VALUE #(
         msgty     = gc_msgty_e
         msgid     = gc_msg_classe
         msgno     = gc_msg_001
         msgv1     = CONV symsgv( iv_lote ) ) TO gt_msg_tab.
        save_log( ).
        EXIT.
    ENDTRY.

    APPEND VALUE #(
        msgty     = gc_msgty_s
        msgid     = gc_msg_classe
        msgno     = gc_msg_003
        msgv1     = CONV symsgv( lines( ls_busca_input-mt_cadastros_buscar_resp-list-itens ) ) ) TO gt_msg_tab.

    LOOP AT ls_busca_input-mt_cadastros_buscar_resp-list-itens ASSIGNING FIELD-SYMBOL(<fs_itens>).

      lv_char = <fs_itens>-dt_cad_web(10).

      REPLACE ALL OCCURRENCES OF '-' IN lv_char WITH space.
      CONDENSE lv_char NO-GAPS.
      lv_data1 = lv_char.

      lv_char = <fs_itens>-dt_compra(10).

      REPLACE ALL OCCURRENCES OF '-' IN lv_char WITH space.
      CONDENSE lv_char NO-GAPS.
      lv_data2 = lv_char.

      lv_char = <fs_itens>-dt_cad_web+11(8).

      REPLACE ALL OCCURRENCES OF ':' IN lv_char WITH space.
      CONDENSE lv_char NO-GAPS.
      lv_hora = lv_char.

      APPEND VALUE #( id = <fs_itens>-id
                        promocao        = <fs_itens>-promocao
                        cpf             = <fs_itens>-cpf
                        nome            = <fs_itens>-nome
                        endereco        = <fs_itens>-endereco
                        numero          = <fs_itens>-numero
                        complemento     = <fs_itens>-complem
                        referencia      = <fs_itens>-referencia
                        cep             = <fs_itens>-cep
                        bairro          = <fs_itens>-bairro
                        cidade          = <fs_itens>-cidade
                        estado          = <fs_itens>-estado
                        email           = <fs_itens>-email
                        ddd             = <fs_itens>-ddd
                        telefone        = <fs_itens>-telef
                        codigo          = <fs_itens>-codigo
                        cod_maq_sap     = <fs_itens>-codigo
                        nr_serie        = <fs_itens>-nr_serie
                        dt_criacao      = lv_data1
                        hr_criacao      = lv_hora
                        status_bp       = '1'
                        status_ov       = '1'
                        status_fat      = '1'
                        dt_registro     = sy-datum
                        hr_objto_criado = sy-uzeit
                        nome_resp_objto = sy-uname
                        dt_compra       = lv_data2
                        local_compra    = <fs_itens>-local_compra
                        end_loja        = <fs_itens>-end_loja ) TO lt_ztsd_sint_proces.

      CLEAR: lv_char,lv_data1,lv_data2,lv_hora.

    ENDLOOP.

    IF lt_ztsd_sint_proces IS NOT INITIAL.
*      MODIFY ztsd_ionz FROM TABLE gt_ztsd_sint_proces.
      MODIFY ztsd_sint_proces FROM TABLE lt_ztsd_sint_proces.
      COMMIT WORK.
    ENDIF.

    TRY.
        DATA(lo_zionz_status) = NEW zclsdco_si_enviar_status_cada( ).
      CATCH cx_ai_system_fault INTO DATA(lo_ai_system_fault).
        APPEND VALUE #(
            msgty     = gc_msgty_e
            msgid     = gc_msg_classe
            msgno     = gc_msg_001 ) TO gt_msg_tab.
        APPEND VALUE #(
            msgty     = gc_msgty_e
            msgid     = gc_msg_classe
            msgno     = gc_msg_004 ) TO gt_msg_tab.
        save_log( ).
        EXIT.
    ENDTRY.

    LOOP AT lt_ztsd_sint_proces ASSIGNING FIELD-SYMBOL(<fs_ztsd_ionz>).
      CLEAR: ls_status_output, ls_status_input.

      ls_status_output-mt_enviar_status_cadastro-id = <fs_ztsd_ionz>-id.
      ls_status_output-mt_enviar_status_cadastro-status = abap_true.

      TRY.
          lo_zionz_status->si_enviar_status_cadastro_out(
            EXPORTING
              output = ls_status_output
            IMPORTING
              input  = ls_status_input ).
        CATCH cx_ai_system_fault.
          APPEND VALUE #(
              msgty     = gc_msgty_e
              msgid     = gc_msg_classe
              msgno     = gc_msg_006
              msgv1     = CONV symsgv( <fs_ztsd_ionz>-id ) ) TO gt_msg_tab.
      ENDTRY.
    ENDLOOP.


    save_log( ).
    EXIT.

  ENDMETHOD.


  METHOD save_log.

    DATA: lt_log_handle TYPE bal_t_logh,
          ls_log        TYPE bal_s_log,
          ls_log_handle TYPE balloghndl.

    sort gt_MSG_TAB by msgty.
    READ TABLE gt_MSG_TAB TRANSPORTING NO FIELDS with key msgty = gc_msgty_e BINARY SEARCH.

    IF sy-subrc = 0.
      APPEND VALUE #(
          msgty     = gc_msgty_E
          msgid     = gc_msg_classe
          msgno     = gc_msg_007 ) TO gt_MSG_TAB.
    ELSE.
      APPEND VALUE #(
          msgty     = gc_msgty_S
          msgid     = gc_msg_classe
          msgno     = gc_msg_005 ) TO gt_MSG_TAB.
    ENDIF.

    ls_log-object = gc_object.
    ls_log-subobject = gc_subobject.
    ls_log-alprog = sy-repid.
    ls_log-aluser = sy-uname.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = ls_log
      IMPORTING
        e_log_handle            = ls_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    LOOP AT gt_msg_tab ASSIGNING FIELD-SYMBOL(<fs_msg>).
      CALL FUNCTION 'BAL_LOG_MSG_ADD'
        EXPORTING
          i_log_handle     = ls_log_handle
          i_s_msg          = <fs_msg>
        EXCEPTIONS
          log_not_found    = 1
          msg_inconsistent = 2
          log_is_full      = 3
          OTHERS           = 4.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
    ENDLOOP.

    APPEND ls_log_handle TO lt_log_handle.

    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = lt_log_handle[]
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
