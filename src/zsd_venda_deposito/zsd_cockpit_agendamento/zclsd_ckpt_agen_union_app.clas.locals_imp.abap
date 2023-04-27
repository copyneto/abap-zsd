CLASS lcl_agendamento DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK agendamento.

    METHODS read FOR READ
      IMPORTING keys FOR READ agendamento RESULT result.

    METHODS criaragendamento FOR MODIFY
      IMPORTING keys FOR ACTION agendamento~criaragendamento.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR agendamento RESULT result.

ENDCLASS.

CLASS lcl_agendamento IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_ckpt_agend_union_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-chaveordemremessa(10)
*      AND salesorderitem = '000010'
*      AND remessa = @keys-chaveordemremessa+16(10)
      INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

  METHOD criaragendamento.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZAGEN_CRIA' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      " Recupera todas as linhas selecionadas
      READ ENTITIES OF zi_sd_ckpt_agend_union_app IN LOCAL MODE ENTITY agendamento
          FIELDS ( salesorder  )
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_agendamento)
          FAILED failed.

      " Recupera a primeira chave
      TRY.
          DATA(ls_keys) = keys[ 1 ].
        CATCH cx_root.
      ENDTRY.

*    IF ls_keys-%param-dataagendada >= sy-datum.
      DATA(lo_actions) = NEW zclsd_agendamento_actions( ).


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

*    ELSE.
*      APPEND VALUE #(  %tky = ls_keys-%tky ) TO failed-agendamento.
*      FREE reported-agendamento.
*      APPEND VALUE #( %tky     = ls_keys-%tky
*                      %msg     = new_message( id  = 'ZSD_CKPT_AGENDAMENTO'
*                                         number   = '016'
*                                         severity =  CONV #( 'E' ) ) ) TO reported-agendamento.
*
*    ENDIF.

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
    READ ENTITIES OF zi_sd_ckpt_agend_union_app IN LOCAL MODE ENTITY agendamento
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.



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
