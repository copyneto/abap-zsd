CLASS lcl_verifutil DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK verifutil.

    METHODS read FOR READ
      IMPORTING keys FOR READ verifutil RESULT result.

*    METHODS substituirproduto FOR MODIFY
*      IMPORTING keys FOR ACTION verifutil~substituirproduto.

    METHODS eliminarproduto FOR MODIFY
      IMPORTING keys FOR ACTION verifutil~eliminarproduto.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR verifutil RESULT result.

ENDCLASS.

CLASS lcl_verifutil IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_verif_util_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-salesorder
      AND salesorderitem = @keys-salesorderitem
    INTO CORRESPONDING FIELDS OF TABLE @result.

  ENDMETHOD.

*  METHOD substituirproduto.
*
** Verificando a Autorização do User!
*    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
*      ID 'ACTVT' FIELD '01'.    "Criar
*
*    IF sy-subrc IS INITIAL.
*
*      READ ENTITIES OF zi_sd_verif_util_app IN LOCAL MODE
*      ENTITY verifutil
*        FIELDS ( salesorder salesorderitem Material ) WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_verifutil)
*      FAILED failed.
*
*    DATA(lo_substituirproduto) = NEW zclsd_verif_util_actions( ).
*    reported-verifutil = VALUE #( FOR ls_keys IN keys
*      FOR ls_mensagem IN lo_substituirproduto->substituir_produto(   iv_order        =  ls_keys-salesorder
*                                                                     iv_item         =  ls_keys-salesorderitem
*                                                                     iv_new_material =  ls_keys-%param-material )
*        ( %tky = VALUE #( salesorder = ls_keys-salesorder salesorderitem = ls_keys-salesorderitem )
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
*
*    ELSE.
*
*      APPEND VALUE #(  %msg     = new_message(
*                       id       = 'ZSD_CKPT_FATURAMENTO'
*                       number   = '001'
*                       severity = CONV #( 'E' ) ) ) TO reported-verifutil.
*
*    ENDIF.
*  ENDMETHOD.
*
  METHOD eliminarproduto.
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZELIM_PROD' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_verif_util_app IN LOCAL MODE
      ENTITY verifutil
        FIELDS ( salesorder salesorderitem  ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifutil)
      FAILED failed.
*      SORT lt_verifutil BY salesorder salesorderitem.
*
*      DATA(lo_verifutil) = NEW zclsd_verif_util_actions( ).
*      lo_verifutil->get_parametro( ).
*      reported-verifutil = VALUE #( FOR ls_verifutil IN lt_verifutil
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
                       severity = CONV #( 'E' ) ) ) TO reported-verifutil.

    ENDIF.
  ENDMETHOD.

  METHOD get_features.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_verif_util_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_verif_util_app IMPLEMENTATION.

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
