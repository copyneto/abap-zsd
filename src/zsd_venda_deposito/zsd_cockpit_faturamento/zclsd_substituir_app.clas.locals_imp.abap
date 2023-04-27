CLASS lcl_substprd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK substprd.

    METHODS read FOR READ
      IMPORTING keys FOR READ substprd RESULT result.

    METHODS substituirproduto FOR MODIFY
      IMPORTING keys FOR ACTION substprd~substituirproduto.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR substprd RESULT result.

ENDCLASS.

CLASS lcl_substprd IMPLEMENTATION.

  METHOD lock.
  if sy-subrc is initial.
  endif.
  ENDMETHOD.

  METHOD read.

    IF keys IS NOT INITIAL.

      TRY.
          SELECT * FROM zc_sd_substituir_app
          FOR ALL ENTRIES IN @keys
          WHERE salesorder     = @keys-salesorder
            AND salesorderitem = @keys-salesorderitem
            AND material       = @keys-material
*      AND SalesOrder = @keys-SalesOrder
          INTO CORRESPONDING FIELDS OF TABLE @result.
        CATCH cx_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.

  METHOD substituirproduto.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_substituir_app IN LOCAL MODE
      ENTITY substprd
        FIELDS ( salesorder salesorderitem material ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifutil)
      FAILED failed.

      LOOP AT lt_verifutil ASSIGNING FIELD-SYMBOL(<fs_veriutil>).

        DATA(lo_substituirproduto) = NEW zclsd_verif_util_actions( ).
        reported-substprd = VALUE #( FOR ls_keys IN keys
*        FOR ls_mensagem IN lo_substituirproduto->substituir_produto(   iv_order        =  ls_keys-salesorder
*                                                                       iv_item         =  ls_keys-salesorderitem
           FOR ls_mensagem IN lo_substituirproduto->substituir_produto(  iv_order        =  <fs_veriutil>-salesorder
                                                                         iv_item         =  <fs_veriutil>-salesorderitem
                                                                         iv_new_material =  <fs_veriutil>-material )
            ( %tky = VALUE #( salesorder = ls_keys-salesorder salesorderitem = ls_keys-salesorderitem )
              %msg        =
                new_message(
                  id       = ls_mensagem-id
                  number   = ls_mensagem-number
                  severity = CONV #( ls_mensagem-type )
                  v1       = ls_mensagem-message_v1
                  v2       = ls_mensagem-message_v2
                  v3       = ls_mensagem-message_v3
                  v4       = ls_mensagem-message_v4 )
          ) ).

      ENDLOOP.

    ELSE.

      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #( 'E' ) ) ) TO reported-substprd.
    ENDIF.
    .
  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_sd_substituir_app IN LOCAL MODE
      ENTITY substprd
      FIELDS ( salesorder salesorderitem  )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_substprd)
      FAILED failed.

  ENDMETHOD.

ENDCLASS.
