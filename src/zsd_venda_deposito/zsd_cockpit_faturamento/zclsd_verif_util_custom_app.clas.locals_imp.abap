CLASS lcl_zc_sd_verif_util_custom_ap DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _custom.

    METHODS read FOR READ
      IMPORTING keys FOR READ _custom RESULT result.

*    METHODS substituirproduto FOR MODIFY
*      IMPORTING keys FOR ACTION _custom~substituirproduto.

    METHODS eliminarproduto FOR MODIFY
      IMPORTING keys FOR ACTION _custom~eliminarproduto.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _custom RESULT result.

ENDCLASS.

CLASS lcl_zc_sd_verif_util_custom_ap IMPLEMENTATION.


  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    DATA lt_result TYPE STANDARD TABLE OF zc_sd_verif_util_custom_app WITH EMPTY KEY.
*    DATA(lo_select) = NEW zclsd_verif_util_custom(  ).
*
*    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*      APPEND VALUE #( sign = 'I'
*                      option = 'EQ'
*                      low = <fs_keys>-salesorder ) TO lo_select->gs_filtros-salesorder. "#EC CI_STDSEQ
*
*      APPEND VALUE #( sign = 'I'
*                       option = 'EQ'
*                       low = <fs_keys>-salesorderitem ) TO lo_select->gs_filtros-salesorderitem.
*
*
*    ENDLOOP.
*
*    lo_select->build( IMPORTING et_verif_util = DATA(lt_result)  ).
    CHECK keys IS NOT INITIAL.

    SELECT *
    FROM zi_sd_verif_util_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder        EQ @keys-salesorder
      AND salesorderitem    EQ @keys-salesorderitem
    INTO CORRESPONDING FIELDS OF TABLE @lt_result.

    DELETE ADJACENT DUPLICATES FROM lt_result COMPARING salesorder  salesorderitem material  plant.

    result = CORRESPONDING #( lt_result ).

  ENDMETHOD.

*  METHOD substituirproduto.
*
** Verificando a Autorização do User!
*    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
*      ID 'ACTVT' FIELD '01'.    "Criar
*
*    IF sy-subrc IS INITIAL.
*
*      READ ENTITIES OF zc_sd_verif_util_custom_app IN LOCAL MODE
*      ENTITY _custom
*        FIELDS ( salesorder salesorderitem material ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_verifutil)
*      FAILED failed.
*
*      DATA(lo_substituirproduto) = NEW zclsd_verif_util_actions( ).
*      reported-_custom = VALUE #( FOR ls_keys IN keys
*        FOR ls_mensagem IN lo_substituirproduto->substituir_produto(   iv_order        =  ls_keys-salesorder
*                                                                       iv_item         =  ls_keys-salesorderitem
*                                                                       iv_new_material =  ls_keys-%param-material )
*          ( %tky = VALUE #( salesorder = ls_keys-salesorder salesorderitem = ls_keys-salesorderitem )
*            %msg        =
*              new_message(
*                id       = ls_mensagem-id
*                number   = ls_mensagem-number
*                severity = CONV #( ls_mensagem-type )
*                v1       = ls_mensagem-message_v1
*                v2       = ls_mensagem-message_v2
*                v3       = ls_mensagem-message_v3
*                v4       = ls_mensagem-message_v4 )
*        ) ).
*
*    ELSE.
*
*      APPEND VALUE #(  %msg     = new_message(
*                       id       = 'ZSD_CKPT_FATURAMENTO'
*                       number   = '001'
*                       severity = CONV #( 'E' ) ) ) TO reported-_custom.
*
*    ENDIF.
*  ENDMETHOD.

  METHOD eliminarproduto.
    DATA: ls_orderx TYPE bapisdh1x.
    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA: lt_item   TYPE TABLE OF bapisditm.
    DATA: lt_itemx  TYPE TABLE OF bapisditmx.
    DATA: lt_mensagens TYPE bapiret2_tab.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZELIM_PROD' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zc_sd_verif_util_custom_app IN LOCAL MODE
      ENTITY _custom
        FIELDS ( salesorder salesorderitem  ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifutil)
      FAILED failed.
      SORT lt_verifutil BY salesorder salesorderitem.

      DATA(lo_verifutil) = NEW zclsd_verif_util_actions( ).
      DATA(lv_param) = lo_verifutil->get_parametro( ).

      DATA(lt_ordem) = lt_verifutil[].
      SORT lt_ordem BY salesorder.
      DELETE ADJACENT DUPLICATES FROM lt_ordem COMPARING salesorder.

      LOOP AT lt_ordem ASSIGNING FIELD-SYMBOL(<fs_ordem>).
        READ TABLE lt_verifutil TRANSPORTING NO FIELDS WITH KEY salesorder = <fs_ordem>-salesorder BINARY SEARCH.
        IF sy-subrc EQ 0.

          LOOP AT lt_verifutil ASSIGNING FIELD-SYMBOL(<fs_verifutil>) FROM sy-tabix.
            IF <fs_verifutil>-salesorder = <fs_ordem>-salesorder.

              ls_orderx-updateflag = 'U'.
              ls_orderx-dlv_block = abap_true.

              APPEND VALUE #( itm_number = <fs_verifutil>-salesorderitem
                              reason_rej = lv_param ) TO lt_item.

              APPEND VALUE #( itm_number = <fs_verifutil>-salesorderitem
                              updateflag = 'U'
                              reason_rej = abap_true ) TO lt_itemx.

            ELSE.


              lt_return = lo_verifutil->eliminar_produto( iv_order  = <fs_ordem>-salesorder
                                                             is_orderx =  ls_orderx
                                                             it_item   =  lt_item
                                                             it_itemx  =  lt_itemx ).

              APPEND LINES OF lt_return TO lt_mensagens.

              CLEAR: ls_orderx, lt_item, lt_itemx, lt_return.

              EXIT.

            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDLOOP.

      IF lt_item[] IS NOT INITIAL.

        lt_return = lo_verifutil->eliminar_produto( iv_order  = <fs_ordem>-salesorder
                                                    is_orderx =  ls_orderx
                                                    it_item   =  lt_item
                                                    it_itemx  =  lt_itemx ).

        APPEND LINES OF lt_return TO lt_mensagens.
        CLEAR: ls_orderx, lt_item, lt_itemx, lt_return.

      ENDIF.


      reported-_custom = VALUE #( FOR ls_mensagem IN lt_mensagens
              ( %tky = VALUE #( salesorder = <fs_ordem>-salesorder salesorderitem = <fs_ordem>-salesorderitem )
                %msg        =
                  new_message(
                    id       = ls_mensagem-id
                    number   = ls_mensagem-number
                    severity = CONV #( ls_mensagem-type )
                    v1       = ls_mensagem-message_v1
                    v2       = ls_mensagem-message_v2
                    v3       = ls_mensagem-message_v3
                    v4       = ls_mensagem-message_v4 ) )
             ) .



*      reported-_custom = VALUE #( FOR ls_verifutil IN lt_verifutil
*        FOR ls_mensagem IN lo_verifutil->eliminar_produto( iv_order = ls_verifutil-salesorder
*                                                           iv_item =  ls_verifutil-salesorderitem )
*        ( %tky = VALUE #( salesorder = ls_verifutil-salesorder salesorderitem = ls_verifutil-salesorderitem )
*          %msg        =
*            new_message(
*              id       = ls_mensagem-id
*              number   = ls_mensagem-number
*              severity = CONV #( ls_mensagem-type )
*              v1       = ls_mensagem-message_v1
*              v2       = ls_mensagem-message_v2
*              v3       = ls_mensagem-message_v3
*              v4       = ls_mensagem-message_v4 )
*      ) ).

    ELSE.

      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #( 'E' ) ) ) TO reported-_custom.

    ENDIF.
  ENDMETHOD.

  METHOD get_features.
    RETURN.
  ENDMETHOD.


ENDCLASS.

CLASS lcl_sd_verif_util_custom_ap DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_sd_verif_util_custom_ap IMPLEMENTATION.

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
