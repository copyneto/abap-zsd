CLASS lcl_zc_sd_recusa_nivel_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS motivorecusa FOR MODIFY
      IMPORTING keys FOR ACTION _header~motivorecusa.

    METHODS read FOR READ
      IMPORTING keys FOR READ _header RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _header RESULT result.

ENDCLASS.

CLASS lcl_zc_sd_recusa_nivel_item IMPLEMENTATION.

  METHOD read.
    RETURN.
  ENDMETHOD.

  METHOD motivorecusa.

    DATA lt_mensagens TYPE bapiret2_tab.

    DATA(lo_executar) = NEW zclsd_alterar_motivo_recusa( ).
*    DATA(lt_return) = VALUE bapiret2_t( FOR ls_key IN keys
*      FOR ls_mensagem IN NEW zclsd_alterar_motivo_recusa( )->executar(
*         iv_salesorder     = ls_key-salesorder
*         iv_salesorderitem = ls_key-salesorderitem
*         iv_reasonreject   = ls_key-%param
*      )
*      ( ls_mensagem ) ).

    DATA(lt_order_items) = VALUE zclsd_alterar_motivo_recusa=>ty_t_item_motivo_recusa( FOR ls_key IN keys
       (
         salesorder     = ls_key-salesorder
         salesorderitem = ls_key-salesorderitem
         reasonreject   = ls_key-%param
     ) ).

*    DELETE ADJACENT DUPLICATES FROM lt_return COMPARING message.


    APPEND LINES OF lo_executar->executar( it_order_items = lt_order_items ) TO lt_mensagens.


*    reported-_header = VALUE #( FOR ls_mensagem IN NEW zclsd_alterar_motivo_recusa( )->executar( lt_order_items )
*     ( "%tky = VALUE #( salesorder = ls_key-salesorder salesorderitem = ls_key-salesorderitem )
*       %msg        =
*         new_message(
*           id       = ls_mensagem-id
*           number   = ls_mensagem-number
*           severity = CONV #( 'I' )
*           v1       = ls_mensagem-message_v1
*           v2       = ls_mensagem-message_v2
*           v3       = ls_mensagem-message_v3
*           v4       = ls_mensagem-message_v4 )
*   ) ).

    LOOP AT lt_order_items INTO DATA(ls_itens).

      READ TABLE lt_mensagens INTO DATA(ls_message) WITH KEY log_no     = ls_itens-salesorder
                                                             log_msg_no = ls_itens-salesorderitem.
      IF sy-subrc IS INITIAL.

        APPEND VALUE #( %tky = VALUE #( salesorder = ls_itens-salesorder salesorderitem = ls_itens-salesorderitem )
                       %msg        = new_message( id       = ls_message-id
                                                  number   = ls_message-number
                                                  v1       = ls_message-message_v1
                                                  v2       = ls_message-message_v2
                                                  v3       = ls_message-message_v3
                                                  v4       = ls_message-message_v4
                                                  severity = CONV #( ls_message-type ) )
                        )
         TO reported-_header.



      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

    "Authorization Check
    AUTHORITY-CHECK OBJECT 'ZAOSD_REC'
      ID 'ACTVT' FIELD '02'.

    IF sy-subrc NE 0.
      DATA(lv_permissao) = if_abap_behv=>fc-o-disabled.
    ELSE.
      lv_permissao = if_abap_behv=>fc-o-enabled.
    ENDIF.

    result = VALUE #( FOR ls_key IN keys
    ( %tky =  ls_key-%tky
    %action-motivorecusa = lv_permissao
    ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_zc_sd_recusa_nivel_item_sa DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zc_sd_recusa_nivel_item_sa IMPLEMENTATION.

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
