CLASS lcl_agendamento_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK agendamento_item.

    METHODS read FOR READ
      IMPORTING keys FOR READ agendamento_item RESULT result.

*    METHODS criaragendamento FOR MODIFY
*      IMPORTING keys FOR ACTION agendamento_item~criaragendamento.

*    METHODS get_features FOR FEATURES
*      IMPORTING keys REQUEST requested_features FOR agendamento_item RESULT result.

ENDCLASS.

CLASS lcl_agendamento_item IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_ckpt_agen_item_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-chaveordemremessa(10)
      AND salesorderitem = @keys-salesorderitem
      AND remessa = @keys-chaveordemremessa+16(10)
      INTO CORRESPONDING FIELDS OF TABLE @result.

    CHECK result IS INITIAL.
    SELECT * FROM zi_sd_ckpt_agen_item_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-chaveordemremessa(10)
      AND salesorderitem = @keys-salesorderitem
      AND remessa IS NULL
    INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

*  METHOD criaragendamento.
*
*    READ ENTITIES OF zi_sd_ckpt_agen_item_app IN LOCAL MODE
*    ENTITY agendamento_item
*      FIELDS ( salesorder remessa docnum notafiscal ) WITH CORRESPONDING #( keys )
*    RESULT DATA(lt_agendamento)
*    FAILED failed.
*
*
*
*    DATA(lo_actions) = NEW zclsd_agendamento_actions( ).
*
*
*    reported-agendamento_item = VALUE #( FOR ls_key IN keys
*
*
*
*    FOR ls_agenda IN  lt_agendamento WHERE ( salesorder        = ls_key-chaveordemremessa(10)
*                                         AND salesorderitem    = ls_key-salesorderitem
*                                         AND remessa           = ls_key-chaveordemremessa+16(10)  )
*
*
*      FOR ls_mensagem IN lo_actions->criaragendamento(  EXPORTING: iv_ordem = ls_agenda-salesorder
*                                                                   iv_item = ls_key-salesorderitem
*                                                                   iv_remessa = ls_agenda-remessa
*                                                                   iv_nfe = ls_agenda-notafiscal
*                                                                   iv_grp = ls_agenda-kvgr5
*                                                                   iv_app_item = abap_true
*                                                                  iv_dataagendada =  ls_key-%param-dataagendada
*                                                                  iv_horaagendada =  ls_key-%param-horaagendada
*                                                                  iv_motivo       =  ls_key-%param-motivoagenda
*                                                                  iv_senha        =  ls_key-%param-senha )
*      ( %tky = ls_key-%tky
*        %msg        =
*          new_message(
*            id       = ls_mensagem-id
*            number   = ls_mensagem-number
*            severity = CONV #( ls_mensagem-type )
*            v1       = ls_mensagem-message_v1
*            v2       = ls_mensagem-message_v2
*            v3       = ls_mensagem-message_v3
*            v4       = ls_mensagem-message_v4 )
*    )
*
*    ).
*
*    IF lt_agendamento IS NOT INITIAL.
*      SELECT *
*       FROM likp
*       FOR ALL ENTRIES IN @lt_agendamento
*       WHERE vbeln = @lt_agendamento-remessa
*       INTO TABLE @DATA(lt_likp).
*
*      IF lt_likp IS NOT INITIAL.
*
*        SORT lt_likp BY vbeln.
*        DELETE ADJACENT DUPLICATES FROM lt_likp[] COMPARING vbeln.
*
*        LOOP AT lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>).
*
*          lo_actions->chama_proxy( is_likp = <fs_likp> ).
*
*        ENDLOOP.
*
*      ENDIF.
*    ENDIF.
*
*  ENDMETHOD.

*  METHOD get_features.
*    RETURN.
*  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_ckpt_agen_item_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_ckpt_agen_item_app IMPLEMENTATION.

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
