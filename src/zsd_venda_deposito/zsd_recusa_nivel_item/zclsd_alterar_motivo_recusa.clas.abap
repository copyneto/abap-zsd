"! <p>Alterar Motivo de Recusa a nível de Item OV</p>
CLASS zclsd_alterar_motivo_recusa DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_item_motivo_recusa,
        salesorder     TYPE vdm_sales_order,
        salesorderitem TYPE sales_order_item,
        reasonreject   TYPE zc_sd_motivo_recusa,
        updateflag     TYPE updkz_d,
      END OF ty_item_motivo_recusa,

      ty_t_item_motivo_recusa TYPE TABLE OF ty_item_motivo_recusa
      WITH KEY salesorder salesorderitem.

    METHODS:
      "! Executar a alteração do motivo de recusa na OV
      "! @parameter it_order_items  | Tabela de itens com motivo de rejeição
      "! @parameter rt_mensagens      | Retorno de mensagens da BAPI
      executar
        IMPORTING
          it_order_items      TYPE ty_t_item_motivo_recusa
*          iv_salesorder       TYPE vdm_sales_order
*          iv_salesorderitem   TYPE sales_order_item
*          iv_reasonreject     TYPE zc_sd_motivo_recusa
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab,

      get_log
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab,

      "! Método executado após chamada da função background
      "! @parameter p_task | Parametro obrigatório do método
      task_finish
        IMPORTING
          p_task TYPE clike.

    METHODS format_return
      IMPORTING
        !iv_change_error_type   TYPE flag OPTIONAL
        !iv_change_warning_type TYPE flag OPTIONAL
      CHANGING
        !ct_return              TYPE bapiret2_t .

  PRIVATE SECTION.
    METHODS:
      "! Método para filtrar mensagens de retorno
      "! @parameter rt_mensagens | Mensagens válidas para retornar
      get_async_messages
        RETURNING
          VALUE(rt_mensagens) TYPE bapiret2_tab.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        gbs    TYPE ztca_param_par-chave2 VALUE 'STATUS_GLOBAL_OV',
        gbsta  TYPE ztca_param_par-chave3 VALUE '',
      END OF gc_parametros.

    DATA gs_gbsta TYPE RANGE OF gbsta.

    DATA:
      gt_return_async TYPE STANDARD TABLE OF bapiret2,
      gt_return       TYPE STANDARD TABLE OF bapiret2.
    METHODS get_gbsta RETURNING VALUE(rv_gbsta) TYPE gbsta.

ENDCLASS.



CLASS zclsd_alterar_motivo_recusa IMPLEMENTATION.


  METHOD executar.
    DATA lt_return         TYPE STANDARD TABLE OF bapiret2.
    DATA lt_order_item_in  TYPE STANDARD TABLE OF bapisditm.
    DATA lt_order_item_inx TYPE STANDARD TABLE OF bapisditmx.
    DATA: ls_msg       TYPE bapiret2.


    DATA(lt_keys) = it_order_items.
    SORT lt_keys BY salesorder.
    DELETE ADJACENT DUPLICATES FROM lt_keys COMPARING salesorder.


    IF lt_keys[] IS NOT INITIAL.

      SELECT salesorder, statusdeliveryblockreason
      FROM zc_sd_ckpt_fat_app
      FOR ALL ENTRIES IN @lt_keys
      WHERE salesorder = @lt_keys-salesorder
        INTO TABLE @DATA(lt_fat).

      IF sy-subrc IS INITIAL.
        SORT lt_fat BY salesorder.
      ENDIF.
    ENDIF.


    SELECT salesorder, salesorderitem, sdprocessstatus, salesdocumentrjcnreason
    FROM i_salesorderitem
    FOR ALL ENTRIES IN @it_order_items
    WHERE salesorder = @it_order_items-salesorder
      AND salesorderitem = @it_order_items-salesorderitem
      INTO TABLE @DATA(lt_item).

    IF sy-subrc IS INITIAL.
      SORT lt_item BY salesorder salesorderitem.
    ENDIF.

    DATA(lt_item_aux) = lt_item.
    DELETE lt_item_aux WHERE sdprocessstatus NE 'C'.
    DELETE lt_item_aux WHERE salesdocumentrjcnreason NE space.
    IF NOT lt_item_aux IS INITIAL.
      LOOP AT lt_item_aux ASSIGNING FIELD-SYMBOL(<fs_item_aux>).
        ls_msg-id          = 'ZSD'.
        ls_msg-number      = '011'.
        ls_msg-type        = 'E'.
        ls_msg-log_no      = <fs_item_aux>-salesorder.
        ls_msg-log_msg_no  = <fs_item_aux>-salesorderitem.
        APPEND ls_msg TO rt_mensagens.
        CLEAR  ls_msg.
        me->format_return( CHANGING ct_return = rt_mensagens[] ).
      ENDLOOP.
      RETURN.
    ENDIF.

    LOOP AT it_order_items ASSIGNING FIELD-SYMBOL(<fs_order_item>).

      READ TABLE lt_fat INTO DATA(ls_data) WITH KEY salesorder = <fs_order_item>-salesorder
      BINARY SEARCH.

      IF sy-subrc IS INITIAL AND ls_data-statusdeliveryblockreason = 'Pendente'.

        ls_msg-id         = 'ZSD_CKPT_FATURAMENTO'.
        ls_msg-number     = '014'.
        ls_msg-type       = 'I'.
        ls_msg-log_no     = <fs_order_item>-salesorder.
        ls_msg-log_msg_no = <fs_order_item>-salesorderitem.
        APPEND ls_msg TO rt_mensagens.
        CLEAR  ls_msg.


      ELSE.

        READ TABLE lt_item INTO DATA(ls_item) WITH KEY salesorder = <fs_order_item>-salesorder
                                                       salesorderitem = <fs_order_item>-salesorderitem
                                                       BINARY SEARCH.

        IF sy-subrc IS INITIAL.

*          IF ls_item-sdprocessstatus NE get_gbsta(  ). " Removido no chamado 8000004679
          AT NEW salesorder.
            CLEAR: lt_return, lt_order_item_in, lt_order_item_inx.
          ENDAT.

          APPEND VALUE #(
            itm_number = <fs_order_item>-salesorderitem
            reason_rej = <fs_order_item>-reasonreject
          ) TO lt_order_item_in.

          APPEND VALUE #(
            itm_number = <fs_order_item>-salesorderitem
            updateflag = 'I'
            reason_rej = 'X'
          ) TO lt_order_item_inx.

          AT END OF salesorder.
            CALL FUNCTION 'ZFMSD_ALTERA_MOTIVO_RECUSA'
              STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
              EXPORTING
                iv_salesdocument    = <fs_order_item>-salesorder
                is_order_header_inx = VALUE bapisdh1x( updateflag = 'U' )
              TABLES
                et_return           = lt_return
                et_order_item_in    = lt_order_item_in
                et_order_item_inx   = lt_order_item_inx.

            WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.
            APPEND LINES OF me->get_async_messages( ) TO lt_return.
            LOOP AT lt_order_item_in ASSIGNING FIELD-SYMBOL(<fs_item>).
              LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_mensagens>).
                IF <fs_mensagens>-type EQ 'S'.
                  APPEND VALUE #(
                             id          = <fs_mensagens>-id
                             number      = <fs_mensagens>-number
                             type        = <fs_mensagens>-type
                             log_no      = <fs_order_item>-salesorder
                             log_msg_no  = <fs_item>-itm_number
                             message_v1  = <fs_mensagens>-message_v1
                             message_v2  = <fs_mensagens>-message_v2
                             message_v3  = <fs_mensagens>-message_v3
                             message_v4  = <fs_mensagens>-message_v4
                                ) TO rt_mensagens.
                ELSEIF <fs_mensagens>-type EQ 'E'.
                  APPEND VALUE #(
                             id          = <fs_mensagens>-id
                             number      = <fs_mensagens>-number
                             type        = <fs_mensagens>-type
                             log_no      = <fs_order_item>-salesorder
                             log_msg_no  = <fs_item>-itm_number
                             message_v1  = <fs_mensagens>-message_v1
                             message_v2  = <fs_mensagens>-message_v2
                             message_v3  = <fs_mensagens>-message_v3
                             message_v4  = <fs_mensagens>-message_v4
                                ) TO rt_mensagens.
                ENDIF.
              ENDLOOP.
            ENDLOOP.

            CLEAR: lt_order_item_in[], lt_order_item_inx[], lt_return[].

          ENDAT.

*          ELSE.
*
*            ls_msg-id     = 'ZSD_CKPT_FATURAMENTO'.
*            ls_msg-number = '016'.
*            ls_msg-type   = 'I'.
*            ls_msg-message_v1     = <fs_order_item>-salesorder.
*            ls_msg-message_v2     = <fs_order_item>-salesorderitem.
*            APPEND ls_msg TO rt_mensagens.
*            CLEAR  ls_msg.
*
*
*          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    me->format_return( CHANGING ct_return = rt_mensagens[] ).

  ENDMETHOD.


  METHOD task_finish.
    CLEAR me->gt_return_async.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_ALTERA_MOTIVO_RECUSA'
      TABLES
        et_return = me->gt_return_async.
    RETURN.
  ENDMETHOD.


  METHOD get_async_messages.
    IF NOT line_exists( me->gt_return_async[ type = 'E' ] ). "#EC CI_STDSEQ
      DELETE me->gt_return_async WHERE message_v1 = 'VBAKKOM' OR message_v1 = 'VBAPKOM'. "#EC CI_STDSEQ
    ENDIF.

    rt_mensagens = me->gt_return_async.

*    LOOP AT me->gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
*      IF NOT ( ( <fs_return>-type = 'S' AND ( <fs_return>-id <> 'V1' AND <fs_return>-number <> '311' ) )
*              OR <fs_return>-type = 'W' ).
*        APPEND <fs_return> TO rt_mensagens.
*      ENDIF.
*    ENDLOOP.
  ENDMETHOD.


  METHOD get_gbsta.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_gbsta.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-gbs
      iv_chave3 = gc_parametros-gbsta
          IMPORTING
            et_range  = gs_gbsta
        ).

        READ TABLE gs_gbsta ASSIGNING FIELD-SYMBOL(<fs_gbsta>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_gbsta = <fs_gbsta>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_log.
    SORT me->gt_return BY message.
    DELETE ADJACENT DUPLICATES FROM me->gt_return COMPARING message.
    rt_mensagens = me->gt_return.
  ENDMETHOD.


  METHOD format_return.
    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------
      ls_return->type = COND #( WHEN ls_return->type EQ 'E'
                                THEN 'I'
                                WHEN ls_return->type EQ 'W'
                                THEN 'I'
                                ELSE ls_return->type ).

      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
