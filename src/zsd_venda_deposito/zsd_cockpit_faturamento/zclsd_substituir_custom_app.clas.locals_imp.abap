CLASS lcl_substprd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS lock FOR LOCK
*      IMPORTING keys FOR LOCK substprd.

    METHODS read FOR READ
      IMPORTING keys FOR READ substprd RESULT result.

    METHODS substituirproduto FOR MODIFY
      IMPORTING keys FOR ACTION substprd~substituirproduto.

*    METHODS get_features FOR FEATURES
*      IMPORTING keys REQUEST requested_features FOR substprd RESULT result.

ENDCLASS.

CLASS lcl_substprd IMPLEMENTATION.

*  METHOD lock.
*    IF sy-subrc IS INITIAL.
*    ENDIF.
*  ENDMETHOD.

  METHOD read.
    TYPES:  ty_sub        TYPE STANDARD TABLE OF zc_sd_substituir_custom_app WITH EMPTY KEY.
    DATA: lt_sub TYPE ty_sub .
    IF keys IS NOT INITIAL.

      TRY.
          SELECT * FROM zi_sd_substituir_app
          FOR ALL ENTRIES IN @keys
          WHERE salesorder     = @keys-salesorder
            AND salesorderitem = @keys-salesorderitem
            AND material       = @keys-material
            AND materialatual  = @keys-materialatual
*      AND SalesOrder = @keys-SalesOrder
          INTO CORRESPONDING FIELDS OF TABLE @lt_sub.
        CATCH cx_root.
      ENDTRY.

      SORT lt_sub BY salesorder salesorderitem material materialatual.
      DELETE ADJACENT DUPLICATES FROM lt_sub COMPARING salesorder salesorderitem material materialatual.

      result = CORRESPONDING #( lt_sub ).
    ENDIF.
*RETURN.
  ENDMETHOD.

  METHOD substituirproduto.
    DATA: lt_return TYPE TABLE OF bapiret2.
    DATA: lt_mensagens TYPE bapiret2_tab.
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zc_sd_substituir_custom_app IN LOCAL MODE
      ENTITY substprd
        FIELDS ( salesorder salesorderitem material ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifutil)
      FAILED failed.
      SORT lt_verifutil[] BY salesorder salesorderitem.

      DATA(lo_substituirproduto) = NEW zclsd_verif_util_sub( ).
      lo_substituirproduto->selection_data(  it_sub_prod = lt_verifutil ).

      DATA(lt_ordem) = lt_verifutil[].
      SORT lt_ordem BY salesorder.
      DELETE ADJACENT DUPLICATES FROM lt_ordem COMPARING salesorder.

      reported-substprd = VALUE #( FOR ls_ordem IN lt_ordem

   FOR ls_mensagem IN lo_substituirproduto->substituir_produto( iv_order     =  ls_ordem-salesorder
                                                                it_sub_prod  = lt_verifutil )
                 ( %tky-salesorder     =  ls_ordem-salesorder
                   %tky-salesorderitem =  ls_ordem-salesorderitem
                   %tky-material       =  ls_ordem-material
                   %tky-materialatual  =  ls_ordem-materialatual
                             %msg        =
                               new_message(
                                 id       = ls_mensagem-id
                                 number   = ls_mensagem-number
                                 severity = CONV  #( ls_mensagem-type  )
                                 v1       = ls_mensagem-message_v1
                                 v2       = ls_mensagem-message_v2
                                 v3       = ls_mensagem-message_v3
                                 v4       = ls_mensagem-message_v4 )
                          ) ).



*
*      DATA(lo_substituirproduto) = NEW zclsd_verif_util_actions( ).
*      reported-substprd = VALUE #( FOR ls_keys IN keys
*
*         FOR ls_mensagem IN lo_substituirproduto->substituir_produto(  iv_order        =  ls_keys-salesorder
*                                                                       iv_item         =  ls_keys-salesorderitem
*                                                                       iv_new_material =  ls_keys-material )
*( %tky = ls_keys-%tky
*            %msg        =
*              new_message(
*                id       = ls_mensagem-id
*                number   = ls_mensagem-number
*                severity = CONV  #( ls_mensagem-type  )
*                v1       = ls_mensagem-message_v1
*                v2       = ls_mensagem-message_v2
*                v3       = ls_mensagem-message_v3
*                v4       = ls_mensagem-message_v4 )
*        ) ).



    ELSE.

      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #('I' ) ) ) TO reported-substprd.
    ENDIF.

  ENDMETHOD.

*  METHOD get_features.
**    READ ENTITIES OF zc_sd_substituir_custom_app IN LOCAL MODE
**     ENTITY substprd
**     FIELDS ( salesorder salesorderitem  )
**     WITH CORRESPONDING #( keys )
**     RESULT DATA(lt_substprd)
**     FAILED failed.
*    LOOP AT keys REFERENCE INTO DATA(ls_keys).
*      DATA(lv_permissao) = if_abap_behv=>fc-o-enabled.
*
*
*      result = VALUE #( BASE result (   %tky  = ls_keys->%tky
*      %action-substituirproduto = lv_permissao
*      ) ).
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.

CLASS lcl_zc_sd_substituir_custom_ap DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zc_sd_substituir_custom_ap IMPLEMENTATION.

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
