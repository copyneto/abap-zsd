CLASS zclsd_cockpit_remessa_events DEFINITION
  PUBLIC
  INHERITING FROM cl_abap_behv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_sd_cockpit_remessa .
    TYPES:
      ty_cockpit TYPE TABLE OF zi_sd_cockpit_remessa .
    TYPES:
      BEGIN OF ty_parameter,
        lifsk_gr      TYPE likp-lifsk,           " Gerar remessa (RICEFW BD9-154F11)
        lifsk_lr      TYPE likp-lifsk,           " Liberar para roteirização
        lifsk_er      TYPE likp-lifsk,           " Enviar para roteirização
        lifsk_el      TYPE likp-lifsk,           " Eliminar Remessa
        dlv_block     TYPE likp-lifsk,
        block_rm72    TYPE likp-lifsk,
        block_rm74    TYPE likp-lifsk,

        exit_mv50afz3 TYPE flag,                 " Exit - Controle ativo/desativo
        r_vstel       TYPE RANGE OF likp-vstel,  " Exit - Local expedição
        r_lprio       TYPE RANGE OF likp-lprio,  " Exit - Prioridade de remessa
        r_lifsk_el    TYPE RANGE OF likp-lifsk,
      END OF ty_parameter .

    CONSTANTS:
      BEGIN OF gc_cds,
        cockpit TYPE string VALUE 'COCKPIT',              " Cockpit
      END OF gc_cds .
    DATA gs_parameter TYPE ty_parameter .

    "! Valida bloqueio de remessa
    "! @parameter iv_lifsk | Bloqueio de remessa
    "! @parameter et_return | Mensages de retorno
    METHODS check_delivery_block
      IMPORTING
        !iv_lifsk  TYPE likp-lifsk
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Gerencia ação para bloqueio de remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter iv_lifsk | Bloqueio de remessa
    "! @parameter et_return | Mensages de retorno
    METHODS set_delivery_block
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
        !iv_lifsk  TYPE likp-lifsk
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Gerencia ação para remoção de bloqueio de remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS rmv_delivery_block
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Gerencia ação para liberação de roteirização
    "! @parameter iv_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS release_to_routing
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Gerencia ação para envio de roteirização
    "! @parameter it_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS send_to_routing
      IMPORTING
        !it_vbeln  TYPE vbeln_vl_t
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Gerencia ação para eliminar remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS delete_delivery
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Realiza chamada para fazer o bloqueio de remessa
    "! @parameter iv_vbeln | Remessa
    "! @parameter iv_lifsk | Bloqueio de remessa
    "! @parameter et_return | Mensages de retorno
    METHODS call_delivery_block
      IMPORTING
        !iv_vbeln      TYPE likp-vbeln
        !iv_lifsk      TYPE likp-lifsk OPTIONAL
        !iv_delete     TYPE likp_del OPTIONAL
        !iv_background TYPE abap_bool OPTIONAL
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Realiza chamada para fazer o bloqueio de remessa (commit)
    "! @parameter iv_vbeln | Remessa
    "! @parameter iv_lifsk | Bloqueio de remessa
    "! @parameter iv_delete | Flag: eliminar fornecimento
    "! @parameter et_return | Mensages de retorno
    METHODS delivery_block
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
        !iv_lifsk  TYPE likp-lifsk OPTIONAL
        !iv_delete TYPE likp_del OPTIONAL
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Realiza chamada da sessão Roadnet
    "! @parameter it_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS call_roadnet_session
      IMPORTING
        !it_vbeln  TYPE vbeln_vl_t
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Realiza chamada da sessão Roadnet (commit)
    "! @parameter it_vbeln | Remessa
    "! @parameter et_return | Mensages de retorno
    METHODS roadnet_session
      IMPORTING
        !it_vbeln  TYPE vbeln_vl_t
      EXPORTING
        !et_return TYPE bapiret2_t .
    "! Ler as mensagens geradas pelo processamento
    "! @parameter p_task |Noma da task executada
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike.
*        VALUE(it_vbeln) TYPE vbeln_vl_t OPTIONAL .
    "! Constrói mensagens retorno do aplicativo
    "! @parameter it_return | Mensagens de retorno
    "! @parameter es_reported | Retorno do aplicativo
    METHODS build_reported
      IMPORTING
        !it_return   TYPE bapiret2_t
      EXPORTING
        !es_reported TYPE ty_reported .
    "! Formata as mensages de retorno
    "! @parameter iv_change_error_type | Muda o Tipo de mensagem 'E' para 'I'.
    "! @parameter iv_change_warning_type | Muda o Tipo de mensagem 'W' para 'I'.
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      IMPORTING
        !iv_change_error_type   TYPE flag OPTIONAL
        !iv_change_warning_type TYPE flag OPTIONAL
      CHANGING
        !ct_return              TYPE bapiret2_t .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t .
    "! Verifica permissões de usuário
    "! @parameter iv_actvt | Atividade
    "! @parameter ev_ok | Mensagem de sucesso
    "! @parameter et_return | Mensagens de retorno
    METHODS check_permission
      IMPORTING
        !iv_actvt    TYPE activ_auth
      EXPORTING
        !ev_ok       TYPE flag
        !et_return   TYPE bapiret2_t
      RETURNING
        VALUE(rv_ok) TYPE flag .

    METHODS check_delivery_block_rem
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
      EXPORTING
        !et_return TYPE bapiret2_t .

    METHODS send_to_monitor
      IMPORTING
        !it_cockpit TYPE ty_cockpit
      EXPORTING
        !et_return  TYPE bapiret2_t .

    METHODS save_delivery_log
      IMPORTING
        !iv_vbeln  TYPE likp-vbeln
        !it_return TYPE bapiret2_t .
  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA:
      "!Armazenamento das mensagens de processamento
      gt_return     TYPE STANDARD TABLE OF bapiret2,
      "!Flag para sincronizar o processamento da função de criação de ordens de produção
      gv_wait_async TYPE abap_bool.

    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter ev_value | Valor cadastrado
    "! @parameter et_value | Valor cadastrado (Range)
    METHODS get_parameter
      IMPORTING is_param TYPE ztca_param_val
      EXPORTING ev_value TYPE any
                et_value TYPE any.


    DATA gt_messages       TYPE STANDARD TABLE OF bapiret2.
    DATA gv_wait     TYPE abap_bool.

ENDCLASS.



CLASS zclsd_cockpit_remessa_events IMPLEMENTATION.


  METHOD check_delivery_block.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica se bloqueio existe
* ---------------------------------------------------------------------------
    SELECT SINGLE lifsp
        FROM tvls
        INTO @DATA(lv_lifsp)
        WHERE lifsp = @iv_lifsk.

    IF sy-subrc NE 0.
      " Bloqueio '&1' não encontrado.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '004' message_v1 = iv_lifsk ) ).
      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.

  ENDMETHOD.


  METHOD set_delivery_block.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-set_delivery_block
                          IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Verifica se bloqueio existe
* ---------------------------------------------------------------------------
    me->check_delivery_block( EXPORTING iv_lifsk  = iv_lifsk
                              IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Verifica se o doc. da remessa já possui fatura
* ---------------------------------------------------------------------------
    me->check_delivery_block_rem( EXPORTING iv_vbeln  = iv_vbeln
                                  IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    me->call_delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_lifsk  = iv_lifsk
                                       iv_background = abap_true
                             IMPORTING et_return = et_return ).

  ENDMETHOD.


  METHOD rmv_delivery_block.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-rmv_delivery_block
                          IMPORTING et_return = et_return ).


    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    me->call_delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_lifsk  = space
                             IMPORTING et_return = et_return ).

  ENDMETHOD.


  METHOD release_to_routing.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-release_to_routing
                          IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera parâmetros de configuração
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

    DATA(lv_lifsk) = ls_parameter-lifsk_lr.

    IF lv_lifsk IS INITIAL.
      et_return = lt_return[].
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    me->call_delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_lifsk  = lv_lifsk
                             IMPORTING et_return = et_return ).

  ENDMETHOD.


  METHOD send_to_routing.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-send_to_routing
                          IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera parâmetros de configuração
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = DATA(lt_return) ).

    DATA(lv_lifsk) = ls_parameter-lifsk_er.

    IF lv_lifsk IS INITIAL.
      et_return = lt_return[].
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Chama processo ROADNET
* ---------------------------------------------------------------------------
    FREE lt_return.

    me->call_roadnet_session( EXPORTING it_vbeln  = it_vbeln
                              IMPORTING et_return = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
*    IF NOT line_exists( lt_return[ type = 'E' ] ).
*      LOOP AT it_vbeln REFERENCE INTO DATA(lv_vbeln).
*
*        me->call_delivery_block( EXPORTING iv_vbeln  = lv_vbeln->*
*                                           iv_lifsk  = lv_lifsk
*                                 IMPORTING et_return = DATA(lt_return_b) ).
*
*        INSERT LINES OF lt_return_b INTO TABLE et_return[].
*      ENDLOOP.
*    ENDIF.

* ---------------------------------------------------------------------------
* Modifica mensagem de retorno
* ---------------------------------------------------------------------------


    IF line_exists( lt_return[ type = 'E' ] )
    OR line_exists( lt_return[ type = 'W' ] ).
    lt_return[] = et_return[].
    FREE et_return.
      " Problemas encontrados durante envio. Favor verificar log.
      et_return[] = VALUE #( ( type   = 'I' id = 'ZTM_ROADNET_SESSION' number = '013' ) ).
    ELSE.
     IF lt_return IS INITIAL.
    lt_return[] = et_return[].
    FREE et_return.
      " Remessas enviadas com sucesso.
      et_return[] = VALUE #( ( type   = 'I' id = 'ZTM_ROADNET_SESSION' number = '014' ) ).
     ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD roadnet_session.

    DATA: lt_return TYPE bapiret2_t.

    DATA(lo_roadnet) = NEW zcltm_raoadnet_session( ).

    et_return[] = lo_roadnet->processa( it_remessa = it_vbeln ).

* ---------------------------------------------------------------------------
* Separa as mensagens
* ---------------------------------------------------------------------------
    LOOP AT it_vbeln INTO DATA(lv_vbeln).

      FREE lt_return.

      " Separa mensagem específica pra remessa
      LOOP AT et_return REFERENCE INTO DATA(ls_return) WHERE message_v1 EQ lv_vbeln.
        lt_return = VALUE #( BASE lt_return ( ls_return->* ) ).
      ENDLOOP.

      IF sy-subrc NE 0.
        " Separa mensagem geral
        LOOP AT et_return REFERENCE INTO ls_return WHERE number     NE '004'
                                                     AND message_v1 NE lv_vbeln.
          lt_return = VALUE #( BASE lt_return ( ls_return->* ) ).
        ENDLOOP.
      ENDIF.

      " Formata mensagens
      me->format_return( CHANGING ct_return = lt_return ).

      " Salva mensagens
      me->save_delivery_log( EXPORTING iv_vbeln  = lv_vbeln
                                       it_return = lt_return ).
    ENDLOOP.

  ENDMETHOD.


  METHOD delete_delivery.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-delete_delivery
                          IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    me->call_delivery_block( EXPORTING iv_vbeln  = iv_vbeln
                                       iv_delete = abap_true
                             IMPORTING et_return = et_return ).

  ENDMETHOD.


  METHOD call_delivery_block.

    FREE et_return.

* ---------------------------------------------------------------------------
* Chama evento para Bloqueio de remessa
* ---------------------------------------------------------------------------
    FREE: gv_wait_async, gt_return.



    IF iv_background = abap_true.
      CALL FUNCTION 'ZFMSD_COCKPIT_REMESSA_BLQ_REM'
        STARTING NEW TASK 'COCKPIT_REMESSA_BLQ_REM'
        EXPORTING
          iv_vbeln      = iv_vbeln
          iv_lifsk      = iv_lifsk
          iv_delete     = iv_delete
          iv_background = iv_background.

      APPEND VALUE #(
        type   = 'S'
        id     = 'ZSD_COCKPIT_REMESSA'
        number = '017'
        message_v1 = iv_vbeln
      ) TO et_return.
    ELSE.
      CALL FUNCTION 'ZFMSD_COCKPIT_REMESSA_BLQ_REM'
        STARTING NEW TASK 'COCKPIT_REMESSA_BLQ_REM'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          iv_vbeln      = iv_vbeln
          iv_lifsk      = iv_lifsk
          iv_delete     = iv_delete
          iv_background = iv_background.
      WAIT UNTIL gv_wait_async = abap_true.
      et_return = gt_return.
    ENDIF.
  ENDMETHOD.


  METHOD call_roadnet_session.

    CALL FUNCTION 'ZFMSD_COCKPIT_REMESSA_ROADNET'
      STARTING NEW TASK 'COCKPIT_REMESSA_ROADNET'
      EXPORTING
        it_vbeln = it_vbeln.
    et_return = VALUE #( (
      type   = 'S'
      id     = 'ZSD_COCKPIT_REMESSA'
      number = '018'
    ) ).
*    FREE et_return.
*
** ---------------------------------------------------------------------------
** Chama evento para Bloqueio de remessa
** ---------------------------------------------------------------------------
*    FREE: gv_wait_async, gt_return.
*
*    CALL FUNCTION 'ZFMSD_COCKPIT_REMESSA_ROADNET'
*      STARTING NEW TASK 'COCKPIT_REMESSA_ROADNET'
*      CALLING setup_messages ON END OF TASK
*      EXPORTING
*        it_vbeln = it_vbeln.
*
*    WAIT UNTIL gv_wait_async = abap_true.
*    et_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN 'COCKPIT_REMESSA_BLQ_REM'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_COCKPIT_REMESSA_BLQ_REM'
            IMPORTING
                et_return = gt_return.

      WHEN 'COCKPIT_REMESSA_ROADNET'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_COCKPIT_REMESSA_ROADNET'
            IMPORTING
                et_return = gt_return
            .

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD delivery_block.

    DATA: ls_header_data    TYPE bapiobdlvhdrchg,
          ls_header_control TYPE bapiobdlvhdrctrlchg,
          lv_delivery       TYPE vbeln_vl,
          lt_return         TYPE bapiret2_t.

* ---------------------------------------------------------------------------
* Preenche informação
* ---------------------------------------------------------------------------
    IF iv_delete IS NOT INITIAL.

      ls_header_data    = VALUE #( deliv_numb    = iv_vbeln ).

      ls_header_control = VALUE #( deliv_numb    = iv_vbeln
                                   dlv_del       = abap_true ).
    ELSE.

      ls_header_data    = VALUE #( deliv_numb    = iv_vbeln
                                   dlv_block     = iv_lifsk ).

      ls_header_control = VALUE #( deliv_numb    = iv_vbeln
                                   dlv_block_flg = abap_true ).
    ENDIF.

    lv_delivery       = iv_vbeln.

* ---------------------------------------------------------------------------
* Chama BAPI para alteração da remessa
* ---------------------------------------------------------------------------
    CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
      EXPORTING
        header_data    = ls_header_data
        header_control = ls_header_control
        delivery       = lv_delivery
      TABLES
        return         = lt_return.

    IF lt_return IS INITIAL.
      IF iv_delete IS INITIAL.
        " Remessa &1 atualizada com sucesso.
        lt_return = VALUE #( BASE lt_return ( type = 'S' id = 'ZSD_COCKPIT_REMESSA' number = '001' message_v1 = |{ iv_vbeln ALPHA = OUT }| ) ).
      ELSE.
        " Remessa &1 eliminada com sucesso.
        lt_return = VALUE #( BASE lt_return ( type = 'S' id = 'ZSD_COCKPIT_REMESSA' number = '005' message_v1 = |{ iv_vbeln ALPHA = OUT }| ) ).
      ENDIF.
    ENDIF.

    IF NOT line_exists( lt_return[ type = 'E' ] ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

    ENDIF.

    INSERT LINES OF lt_return INTO TABLE et_return[].
    me->format_return( CHANGING ct_return = et_return ).

*    " Salva mensagens
*    me->save_delivery_log( EXPORTING iv_vbeln  = iv_vbeln
*                                     it_return = et_return ).

  ENDMETHOD.


  METHOD build_reported.

    DATA: lo_dataref            TYPE REF TO data.

    FIELD-SYMBOLS: <fs_cds>  TYPE any.

    FREE: es_reported.

    LOOP AT it_return INTO DATA(ls_return).

* ---------------------------------------------------------------------------
* Determina tipo de estrutura CDS
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-cockpit.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
        WHEN OTHERS.
          CREATE DATA lo_dataref TYPE LINE OF ty_reported-cockpit.
      ENDCASE.

      ASSIGN lo_dataref->* TO <fs_cds>.

* ---------------------------------------------------------------------------
* Converte mensagem
* ---------------------------------------------------------------------------
      ASSIGN COMPONENT '%msg' OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_msg>).

      IF sy-subrc EQ 0.
        TRY.
            <fs_msg>  = new_message( id       = ls_return-id
                                     number   = ls_return-number
                                     v1       = ls_return-message_v1
                                     v2       = ls_return-message_v2
                                     v3       = ls_return-message_v3
                                     v4       = ls_return-message_v4
                                     severity = CONV #( ls_return-type ) ).
          CATCH cx_root.
        ENDTRY.
      ENDIF.

* ---------------------------------------------------------------------------
* Marca o campo com erro
* ---------------------------------------------------------------------------
      IF ls_return-field IS NOT INITIAL.
        ASSIGN COMPONENT |%element-{ ls_return-field }| OF STRUCTURE <fs_cds> TO FIELD-SYMBOL(<fs_field>).

        IF sy-subrc EQ 0.
          TRY.
              <fs_field> = if_abap_behv=>mk-on.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
      ENDIF.

* ---------------------------------------------------------------------------
* Adiciona o erro na CDS correspondente
* ---------------------------------------------------------------------------
      CASE ls_return-parameter.
        WHEN gc_cds-cockpit.
          es_reported-cockpit[]         = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
        WHEN OTHERS.
          es_reported-cockpit[]         = VALUE #( BASE es_reported-cockpit[] ( CORRESPONDING #( <fs_cds> ) ) ).
      ENDCASE.

    ENDLOOP.

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
      ls_return->type = COND #( WHEN ls_return->type EQ 'E' AND iv_change_error_type IS NOT INITIAL
                                THEN 'I'
                                WHEN ls_return->type EQ 'W' AND iv_change_warning_type IS NOT INITIAL
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


  METHOD get_parameter.

    FREE: et_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        " Recupera valor único
        IF ev_value IS SUPPLIED.
          lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                            iv_chave1 = is_param-chave1
                                            iv_chave2 = is_param-chave2
                                            iv_chave3 = is_param-chave3
                                  IMPORTING ev_param  = ev_value ).
        ENDIF.

        " Recupera lista de valores
        IF et_value IS SUPPLIED.
          lo_param->m_get_range( EXPORTING iv_modulo = is_param-modulo
                                           iv_chave1 = is_param-chave1
                                           iv_chave2 = is_param-chave2
                                           iv_chave3 = is_param-chave3
                                 IMPORTING et_range  = et_value ).
        ENDIF.

      CATCH zcxca_tabela_parametros.
        FREE et_value.
    ENDTRY.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
    me->check_permission( EXPORTING iv_actvt  = gc_authority-delete_delivery
                          IMPORTING et_return = et_return ).

    CHECK et_return IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de bloqueio 'Enviar para Liberação'. (RICEFW BD9-154F11)
* ---------------------------------------------------------------------------
    IF me->gs_parameter-lifsk_gr IS INITIAL.

      DATA(ls_parameter) = VALUE ztca_param_val( modulo = gc_param_lifsk_gr-modulo
                                                 chave1 = gc_param_lifsk_gr-chave1
                                                 chave2 = gc_param_lifsk_gr-chave2
                                                 chave3 = gc_param_lifsk_gr-chave3 ).

      me->get_parameter( EXPORTING is_param  = ls_parameter
                         IMPORTING ev_value  = me->gs_parameter-lifsk_gr ).

    ENDIF.

    IF me->gs_parameter-lifsk_gr IS INITIAL.
      " Param. 'Enviar para Liberação' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '006'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de bloqueio 'Liberar para Roteirização'.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-lifsk_lr IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_lifsk_lr-modulo
                                           chave1 = gc_param_lifsk_lr-chave1
                                           chave2 = gc_param_lifsk_lr-chave2
                                           chave3 = gc_param_lifsk_lr-chave3 ).

      me->get_parameter( EXPORTING is_param  = ls_parameter
                         IMPORTING ev_value  = me->gs_parameter-lifsk_lr ).

    ENDIF.

    IF me->gs_parameter-lifsk_lr IS INITIAL.
      " Param. 'Liberar para Roteirização' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '002'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de bloqueio 'Enviar para Roteirização'.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-lifsk_er IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_lifsk_er-modulo
                                           chave1 = gc_param_lifsk_er-chave1
                                           chave2 = gc_param_lifsk_er-chave2
                                           chave3 = gc_param_lifsk_er-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parameter
                         IMPORTING ev_value = me->gs_parameter-lifsk_er ).

    ENDIF.

    IF me->gs_parameter-lifsk_er IS INITIAL.
      " Param. 'Enviar para Roteirização' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '003'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.
* ---------------------------------------------------------------------------
* Recupera Parâmetro de bloqueio 'Eliminar Remessa'.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_lifsk_el IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_lifsk_el-modulo
                                           chave1 = gc_param_lifsk_el-chave1
                                           chave2 = gc_param_lifsk_el-chave2
                                           chave3 = gc_param_lifsk_el-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parameter
                         IMPORTING et_value = me->gs_parameter-r_lifsk_el ).

    ENDIF.

    IF me->gs_parameter-lifsk_el IS INITIAL.
      " Param. 'Enviar para Roteirização' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '003'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.
* ---------------------------------------------------------------------------
* Recupera Parâmetro de ativação para lógica da EXIT.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-exit_mv50afz3 IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_exit_mv50afz3-modulo
                                           chave1 = gc_param_exit_mv50afz3-chave1
                                           chave2 = gc_param_exit_mv50afz3-chave2
                                           chave3 = gc_param_exit_mv50afz3-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parameter
                         IMPORTING ev_value = me->gs_parameter-exit_mv50afz3 ).

    ENDIF.

    IF me->gs_parameter-exit_mv50afz3 IS INITIAL.
      " Param. de ativação da lógica da EXIT não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '011'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro 'Local expedição' para lógica da EXIT.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_vstel IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_vstel-modulo
                                           chave1 = gc_param_vstel-chave1
                                           chave2 = gc_param_vstel-chave2
                                           chave3 = gc_param_vstel-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parameter
                         IMPORTING et_value = me->gs_parameter-r_vstel ).

    ENDIF.

    IF me->gs_parameter-r_vstel[] IS INITIAL.
      " Param. 'Local expedição' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '008'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro 'Prioridade de remessa' para lógica da EXIT.
* ---------------------------------------------------------------------------
    IF me->gs_parameter-r_lprio IS INITIAL.

      ls_parameter = VALUE ztca_param_val( modulo = gc_param_lprio-modulo
                                           chave1 = gc_param_lprio-chave1
                                           chave2 = gc_param_lprio-chave2
                                           chave3 = gc_param_lprio-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parameter
                         IMPORTING et_value = me->gs_parameter-r_lprio ).

    ENDIF.

    IF me->gs_parameter-r_lprio[] IS INITIAL.
      " Param. 'Prioridade de remessa' não cadastrado: [&1/&2/&3/&4].
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '009'
                                            message_v1 = ls_parameter-modulo
                                            message_v2 = ls_parameter-chave1
                                            message_v3 = ls_parameter-chave2
                                            message_v4 = ls_parameter-chave3 ) ).
    ENDIF.

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD check_permission.

    FREE: et_return, ev_ok.

* ---------------------------------------------------------------------------
* Botões mapeados no objeto de autorização
* ---------------------------------------------------------------------------
* 01 - Liberar para Roteirização
* 02 - Enviar para Roteirização
* 03 - Definir bloqueio de Remessa
* 04 - Retirar bloqueio de Remessa
* 05 - Eliminar Remessa
* 06 - Verificar Parâmetros
* ---------------------------------------------------------------------------
    AUTHORITY-CHECK OBJECT 'ZSD154F13'
     ID 'ACTVT' FIELD iv_actvt.

    IF sy-subrc NE 0.
      " Sem autorização para acessar esta funcionalidade.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '010' ) ).
    ELSE.
    rv_ok = ev_ok = abap_true.
    ENDIF.

    "et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '010' ) ).

    me->format_return( CHANGING ct_return = et_return[] ).

  ENDMETHOD.


  METHOD check_delivery_block_rem.

    SELECT SINGLE overalldelivreltdbillgstatus
        FROM i_outbounddelivery
        INTO @DATA(lv_lifsp)
        WHERE outbounddelivery = @iv_vbeln
        AND overalldelivreltdbillgstatus IN ( 'B', 'C' ).

    IF sy-subrc EQ 0.
      et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_COCKPIT_REMESSA' number = '013' message_v1 = iv_vbeln ) ).
      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.

  ENDMETHOD.


  METHOD send_to_monitor.

    TYPES: BEGIN OF ty_lips,
             vbeln TYPE vbeln_vl,
             matnr TYPE matnr,
             werks TYPE werks_d,
             lgort TYPE lgort_d,
             lfimg TYPE lfimg,
             vrkme TYPE vrkme,
           END OF ty_lips,
           ty_t_lips TYPE STANDARD TABLE OF ty_lips WITH EMPTY KEY.

    DATA lt_simbol TYPE TABLE OF ztsd_retorn_simb.
    DATA ls_simbol TYPE ztsd_retorn_simb.

    DATA(ls_parameter72) = VALUE ztca_param_val( modulo = gc_param_block_rm72-modulo
                                                 chave1 = gc_param_block_rm72-chave1
                                                 chave2 = gc_param_block_rm72-chave2
                                                 chave3 = space ).

    me->get_parameter( EXPORTING is_param  = ls_parameter72
                       IMPORTING ev_value  = me->gs_parameter-block_rm72 ).

    DATA(ls_parameter74) = VALUE ztca_param_val( modulo = gc_param_block_rm74-modulo
                                                 chave1 = gc_param_block_rm74-chave1
                                                 chave2 = gc_param_block_rm74-chave2
                                                 chave3 = space ).

    me->get_parameter( EXPORTING is_param  = ls_parameter74
                       IMPORTING ev_value  = me->gs_parameter-block_rm74 ).


    IF it_cockpit IS NOT INITIAL.
      SELECT vbeln, matnr, werks, lgort, lfimg, vrkme
      FROM lips
      INTO TABLE @DATA(lt_lips)
      FOR ALL ENTRIES IN @it_cockpit
      WHERE vbeln = @it_cockpit-outbounddelivery.
    ENDIF.

    IF sy-subrc IS INITIAL.

      DATA(lt_lips_colect) = VALUE ty_t_lips(
               FOR GROUPS <fs_group_key> OF <fs_g> IN lt_lips GROUP BY ( vbeln = <fs_g>-vbeln matnr = <fs_g>-matnr )
               LET lv_coll_line = REDUCE #( INIT ls_line TYPE ty_lips FOR <fs_m> IN GROUP <fs_group_key>
                                         NEXT ls_line-vbeln = <fs_m>-vbeln
                                              ls_line-matnr = <fs_m>-matnr
                                              ls_line-werks = <fs_m>-werks
                                              ls_line-lgort = <fs_m>-lgort
                                              ls_line-lfimg = ls_line-lfimg + <fs_m>-lfimg
                                              ls_line-vrkme = <fs_m>-vrkme )
                               IN ( lv_coll_line ) ) .

      LOOP AT lt_lips_colect ASSIGNING FIELD-SYMBOL(<fs_lips>).

        READ TABLE it_cockpit INTO DATA(ls_cockpit) WITH KEY outbounddelivery = <fs_lips>-vbeln.
        IF sy-subrc IS INITIAL.
          IF ls_cockpit-deliveryblockreason EQ me->gs_parameter-block_rm72.
            ls_simbol-material = <fs_lips>-matnr.
            ls_simbol-quantidade = <fs_lips>-lfimg.
            ls_simbol-unidade_medida_vd = <fs_lips>-vrkme.
            ls_simbol-centro = <fs_lips>-werks.
            ls_simbol-deposito = <fs_lips>-lgort.
            ls_simbol-ordem_frete = ls_cockpit-freightorder.
            ls_simbol-remessa = <fs_lips>-vbeln.

            APPEND ls_simbol TO lt_simbol.
            CLEAR ls_simbol.


            CALL FUNCTION 'ZFMSD_RETORNO_SIMBOLICO'
              STARTING NEW TASK 'RETURNSIMBOL'
              EXPORTING
                iv_remessa = <fs_lips>-vbeln.
          ENDIF.
        ENDIF.
      ENDLOOP.

      LOOP AT it_cockpit  ASSIGNING FIELD-SYMBOL(<fs_cockpit>).
        IF <fs_cockpit>-deliveryblockreason EQ me->gs_parameter-block_rm74.

          et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZSD_COCKPIT_REMESSA' number = '016' message_v1 = <fs_cockpit>-outbounddelivery ) ).

        ELSEIF <fs_cockpit>-deliveryblockreason NE me->gs_parameter-block_rm72.

          et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZSD_COCKPIT_REMESSA' number = '015' message_v1 = <fs_cockpit>-outbounddelivery ) ).

        ENDIF.
      ENDLOOP.

      MODIFY ztsd_retorn_simb FROM TABLE lt_simbol.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_simbol ASSIGNING FIELD-SYMBOL(<fs_symbol>) .
          et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_COCKPIT_REMESSA' number = '014' message_v1 = <fs_symbol>-remessa ) ).
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD save_delivery_log.

    DATA: lt_log TYPE STANDARD TABLE OF ztsd_cp_rem_log,
          ls_log TYPE ztsd_cp_rem_log.

    CHECK iv_vbeln IS NOT INITIAL AND it_return IS NOT INITIAL.

* ---------------------------------------------------------------------------
* Recupera a última linha do log
* ---------------------------------------------------------------------------
    SELECT MAX( line )
        FROM ztsd_cp_rem_log
        WHERE vbeln_vl = @iv_vbeln
        INTO @DATA(lv_line).

    LOOP AT it_return REFERENCE INTO DATA(ls_return).
      ls_log-vbeln_vl                 = iv_vbeln.
      ls_log-line                     = lv_line = lv_line + 1.
      ls_log-msgty                    = ls_return->type.
      ls_log-msgid                    = ls_return->id.
      ls_log-msgno                    = ls_return->number.
      ls_log-msgv1                    = ls_return->message_v1.
      ls_log-msgv2                    = ls_return->message_v2.
      ls_log-msgv3                    = ls_return->message_v3.
      ls_log-msgv4                    = ls_return->message_v4.
      ls_log-message                  = ls_return->message.
      ls_log-created_by               = sy-uname.
      GET TIME STAMP FIELD ls_log-created_at.
      ls_log-local_last_changed_at   = ls_log-created_at.
      APPEND ls_log TO lt_log[].
    ENDLOOP.

    IF lt_log[] IS NOT INITIAL.
      MODIFY ztsd_cp_rem_log FROM TABLE lt_log.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
