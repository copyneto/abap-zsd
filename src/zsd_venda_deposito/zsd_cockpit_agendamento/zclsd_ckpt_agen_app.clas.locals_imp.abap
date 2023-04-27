CLASS lcl_agendamento DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK agendamento.

    METHODS read FOR READ
      IMPORTING keys FOR READ agendamento RESULT result.

    METHODS criaragendamento FOR MODIFY
      IMPORTING keys FOR ACTION agendamento~criaragendamento.

*    METHODS exibirhistorico FOR MODIFY
*      IMPORTING keys FOR ACTION agendamento~exibirhistorico.
*
*    METHODS exibirocorrencia FOR MODIFY
*      IMPORTING keys FOR ACTION agendamento~exibirocorrencia.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR agendamento RESULT result.
ENDCLASS.

CLASS lcl_agendamento IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_ckpt_agen_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-chaveordemremessa(10)
*      AND salesorderitem = '000010'
      AND remessa = @keys-chaveordemremessa+16(10)
      INTO CORRESPONDING FIELDS OF TABLE @result.

*    CHECK result IS INITIAL.
    SELECT * FROM zi_sd_ckpt_agen_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-chaveordemremessa(10)
*      AND salesorderitem = '000010'
      AND remessa IS NULL
   APPENDING CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD criaragendamento.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZAGEN_CRIA' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.
      " Recupera todas as linhas selecionadas
      READ ENTITIES OF zi_sd_ckpt_agen_app IN LOCAL MODE ENTITY agendamento
          FIELDS ( salesorder remessa docnum notafiscal )
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_agendamento)
          FAILED failed.

      " Recupera a primeira chave
      TRY.
          DATA(ls_keys) = keys[ 1 ].
        CATCH cx_root.
      ENDTRY.

      IF ls_keys-%param-dataagendada >= sy-datum.
        DATA(lo_actions) = NEW zclsd_agendamento_actions( ).

*    " Tratamento para mais de uma linha selecionada
*    IF lines( lt_agendamento[] ) > 1.
*
*      SELECT COUNT(*)
*        FROM @lt_agendamento AS lt_agen
*        WHERE dataagendada IS NOT INITIAL
*           OR horaagendada IS NOT INITIAL.
*
*      " Verifica se existe alguma linha com data de agendamento preenchido.
*      IF sy-dbcnt >= 1 .
*
*        " Realizar reagendamento individual.
*        reported-agendamento = VALUE #( BASE reported-agendamento (
*                                        %tky        = ls_keys-%tky
*                                        %msg        = new_message(
*                                        id          = 'ZSD_CKPT_AGENDAMENTO'
*                                        number      = '007'
*                                        severity    = if_abap_behv_message=>severity-information ) ) ).
*
*        " &1 ordem selecionada já possui agendamento.
*        reported-agendamento = VALUE #( BASE reported-agendamento (
*                                        %tky        = ls_keys-%tky
*                                        %msg        = new_message(
*                                        id          = 'ZSD_CKPT_AGENDAMENTO'
*                                        number      = COND #( WHEN sy-dbcnt = 1
*                                                              THEN '005'
*                                                              ELSE '006' )
*                                        v1          = sy-dbcnt
*                                        severity    = if_abap_behv_message=>severity-information ) ) ).
*
*        RETURN.
*      ENDIF.
*    ENDIF.
*    DATA(lt_agend) = lt_agendamento[].
*    SORT lt_agend BY salesorder remessa.
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*
*      READ TABLE lt_agend INTO DATA(ls_agend) WITH KEY salesorder = <fs_keys>-chaveordemremessa(10)
*                                                             remessa    = <fs_keys>-chaveordemremessa+16(10)
*                                                             BINARY SEARCH.
*      IF sy-subrc IS INITIAL.
*
*        DATA(lt_msg) = lo_actions->criaragendamento(  EXPORTING: iv_ordem = ls_agend-salesorder
*                                                                        iv_remessa = ls_agend-remessa
*                                                                        iv_nfe = ls_agend-notafiscal
*                                                                        iv_grp = ls_agend-kvgr5
*                                                                       iv_dataagendada =  <fs_keys>-%param-dataagendada
*                                                                       iv_horaagendada =  <fs_keys>-%param-horaagendada
*                                                                       iv_motivo       =  <fs_keys>-%param-motivoagenda
*                                                                       iv_senha        =  <fs_keys>-%param-senha
*                                                                       iv_obs          =  <fs_keys>-%param-observacoes ).
*        DATA(ls_msg) = lt_msg[ 1 ].
*
*        IF line_exists( lt_msg[ type = 'E' ] ).
**          APPEND VALUE #(  %tky = <fs_keys>-%tky ) TO failed-agendamento.
*          FREE reported-agendamento.
*          ls_msg = lt_msg[ type = 'E' ].
*          APPEND VALUE #( %tky     = <fs_keys>-%tky
*                          %msg     = new_message( id       = ls_msg-id
*                                             number   = ls_msg-number
*                                             severity =  CONV #( ls_msg-type )
*                                             v1       = ls_agend-salesorder+6(4)
*                                             v2       = ls_msg-message_v2
*                                             v3       = ls_msg-message_v3
*                                             v4       = ls_msg-message_v4 ) ) TO reported-agendamento.
*
*        ELSE.
*
*          APPEND VALUE #(    %tky     = <fs_keys>-%tky
*                             %msg     = new_message( id       = ls_msg-id
*                                                     number   = ls_msg-number
*                                                     severity =  CONV #( ls_msg-type )
*                                                     v1       = ls_msg-message_v1
*                                                     v2       = ls_msg-message_v2
*                                                     v3       = ls_msg-message_v3
*                                                     v4       = ls_msg-message_v4 ) ) TO reported-agendamento.
*        ENDIF.
*      ENDIF.
*
*      CLEAR lt_msg[].
*    ENDLOOP.

        reported-agendamento = VALUE #( FOR ls_key IN keys

        FOR ls_agenda IN  lt_agendamento WHERE ( salesorder = ls_key-chaveordemremessa(10) AND remessa = ls_key-chaveordemremessa+16(10) )
          FOR ls_mensagem IN lo_actions->criaragendamento(  EXPORTING: iv_ordem = ls_agenda-salesorder
                                                                       iv_remessa = ls_agenda-remessa
                                                                       iv_nfe = ls_agenda-notafiscal
                                                                       iv_grp = ls_agenda-kvgr5
                                                                      iv_dataagendada =  ls_key-%param-dataagendada
                                                                      iv_horaagendada =  ls_key-%param-horaagendada
                                                                      iv_motivo       =  ls_key-%param-motivoagenda
                                                                      iv_senha        =  ls_key-%param-senha
                                                                      iv_obs          =  ls_key-%param-observacoes )
          ( %tky    = ls_key-%tky
            %msg    = new_message( id       = ls_mensagem-id
                                   number   = ls_mensagem-number
                                   severity = COND #(  WHEN ls_mensagem-type = 'E' OR
                                                            ls_mensagem-type = 'W' THEN CONV #( 'I' )
                                                            ELSE CONV #( ls_mensagem-type ) )
                                   v1       = ls_mensagem-message_v1
                                   v2       = ls_mensagem-message_v2
                                   v3       = ls_mensagem-message_v3
                                   v4       = ls_mensagem-message_v4 )

          )
        ).



        IF lt_agendamento IS NOT INITIAL.

          SELECT *
               FROM likp
               FOR ALL ENTRIES IN @lt_agendamento
               WHERE vbeln = @lt_agendamento-remessa
               INTO TABLE @DATA(lt_likp).

          IF lt_likp IS NOT INITIAL.

            SORT lt_likp BY vbeln.
            DELETE ADJACENT DUPLICATES FROM lt_likp[] COMPARING vbeln.

            LOOP AT lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>).

              lo_actions->chama_proxy( is_likp = <fs_likp> ).

            ENDLOOP.

          ENDIF.
        ENDIF.

      ELSE.
        APPEND VALUE #(  %tky = ls_keys-%tky ) TO failed-agendamento.
        FREE reported-agendamento.
        APPEND VALUE #( %tky     = ls_keys-%tky
                        %msg     = new_message( id  = 'ZSD_CKPT_AGENDAMENTO'
                                           number   = '016'
                                           severity =  CONV #( 'E' ) ) ) TO reported-agendamento.

      ENDIF.

    ELSE.
      "Usuário não autorizado!
      APPEND VALUE #( %tky     = ls_keys-%tky
                      %msg     = new_message( id  = 'ZSD_CKPT_AGENDAMENTO'
                                         number   = '017'
                                         severity =  CONV #( 'E' ) ) ) TO reported-agendamento.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_ckpt_agen_app IN LOCAL MODE ENTITY agendamento
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
*    TRY.
*
*        result = VALUE #( FOR ls_cockpit IN lt_cockpit
*
*                        ( %tky                        = ls_cockpit-%tky
*
*                          %action-CriarAgendamento         = COND #( WHEN ls_cockpit-DataAgendada = '20220707'
*                                                                THEN if_abap_behv=>fc-o-enabled
*                                                                ELSE if_abap_behv=>fc-o-disabled )
*                                                                  ) ).
*
*      CATCH cx_root.
*    ENDTRY.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_sd_ckpt_agen_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_sd_ckpt_agen_app IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
