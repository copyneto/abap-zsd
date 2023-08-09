CLASS lcl_substprd DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ substprd RESULT result.

    METHODS substituirproduto FOR MODIFY
      IMPORTING keys FOR ACTION substprd~substituirproduto.
*    METHODS substituirprodutoteste FOR MODIFY
*      IMPORTING keys FOR ACTION substprd~substituirprodutoteste.

ENDCLASS.

CLASS lcl_substprd IMPLEMENTATION.

  METHOD read.


*  salesorder
*salesorderitem
*classedoc       = _TipoOrdem.kalvg
*materialatual   = _verif.Material
*material        = _mean.matnr
*umpreco         = regra CASE
*preco   = regra CASE
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
          INTO CORRESPONDING FIELDS OF TABLE @lt_sub.
        CATCH cx_root.
      ENDTRY.

      SORT lt_sub BY salesorder salesorderitem material materialatual.
      DELETE ADJACENT DUPLICATES FROM lt_sub COMPARING salesorder salesorderitem material materialatual.

      result = CORRESPONDING #( lt_sub ).
    ENDIF.
  ENDMETHOD.

  METHOD substituirproduto.
* ---------------------------------------------------------------------------
* Verificando a Autorização do User!
* ---------------------------------------------------------------------------
    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc NE 0.
      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #('I' ) ) ) TO reported-substprd.
      RETURN.
    ENDIF.
**********************************************************************
    DATA(lt_return_msg) = NEW zclsd_submit_subst_prod( )->submit( it_keys = CORRESPONDING #( keys )  ). "#EC CI_CONV_OK
* ---------------------------------------------------------------------------
* Para cada ordem de venda, realiza a operação de subsituição
* ---------------------------------------------------------------------------
    reported-substprd = VALUE #(
      FOR ls_ordem IN lt_return_msg
      FOR ls_mensagem IN ls_ordem-messages
      ( %tky-salesorder     = ls_ordem-salesorder
        %tky-salesorderitem = ls_ordem-salesorderitem
        %tky-material       = ls_ordem-material
        %tky-materialatual  = ls_ordem-materialatual
        %msg                = new_message(
          id       = ls_mensagem-id
          number   = ls_mensagem-number
          severity = COND #(
            WHEN ls_mensagem-type = 'E'
            THEN CONV #( 'I' )
            ELSE CONV #( ls_mensagem-type ) )
          v1       = ls_mensagem-message_v1
          v2       = ls_mensagem-message_v2
          v3       = ls_mensagem-message_v3
          v4       = ls_mensagem-message_v4 )
     ) ).


*
*    DATA: lt_return    TYPE TABLE OF bapiret2,
*          lt_mensagens TYPE bapiret2_tab,
*          lt_keys      TYPE STANDARD TABLE OF zi_sd_substituir_app.
**          lt_verifutil TYPE STANDARD TABLE OF zc_sd_substituir_custom_app.
*
** ---------------------------------------------------------------------------
** Verificando a Autorização do User!
** ---------------------------------------------------------------------------
*    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
*      ID 'ACTVT' FIELD '01'.    "Criar
*
*    IF sy-subrc NE 0.
*      APPEND VALUE #(  %msg     = new_message(
*                       id       = 'ZSD_CKPT_FATURAMENTO'
*                       number   = '001'
*                       severity = CONV #('I' ) ) ) TO reported-substprd.
*      RETURN.
*    ENDIF.
*
** BEGIN OF CHANGE - JWSILVA - 19.07.2023
*** ---------------------------------------------------------------------------
*** Busca os dados da linha selecionada
*** ---------------------------------------------------------------------------
*    READ ENTITIES OF zc_sd_substituir_custom_app IN LOCAL MODE
*        ENTITY substprd
*        FIELDS ( salesorder salesorderitem material ) WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_verifutil)
*        FAILED failed.
** ---------------------------------------------------------------------------
** Busca os dados da linha selecionada (otimizada, usando apenas os campos chave)
** ---------------------------------------------------------------------------
**    lt_verifutil = VALUE #( FOR ls_keys IN keys ( salesorder     = ls_keys-salesorder
**                                                  salesorderitem = ls_keys-salesorderitem
**                                                  materialatual  = ls_keys-materialatual
**                                                  material       = ls_keys-material ) ).
** END OF CHANGE - JWSILVA - 19.07.2023
*
** ---------------------------------------------------------------------------
** Prepara os dados para operação de subsituição
** ---------------------------------------------------------------------------
*    DATA(lo_substituirproduto) = NEW zclsd_verif_util_sub( ).
*    lo_substituirproduto->selection_data(  it_sub_prod = lt_verifutil ).
*
*    DATA(lt_ordem) = lt_verifutil[].
*    SORT lt_ordem BY salesorder.
*    DELETE ADJACENT DUPLICATES FROM lt_ordem COMPARING salesorder.
*
** ---------------------------------------------------------------------------
** Para cada ordem de venda, realiza a operação de subsituição
** ---------------------------------------------------------------------------
*    reported-substprd = VALUE #( FOR ls_ordem IN lt_ordem
*                                 FOR ls_mensagem IN lo_substituirproduto->substituir_produto( iv_order     = ls_ordem-salesorder
*                                                                                              it_sub_prod  = lt_verifutil )
*                                 ( %tky-salesorder     = ls_ordem-salesorder
*                                   %tky-salesorderitem = ls_ordem-salesorderitem
*                                   %tky-material       = ls_ordem-material
*                                   %tky-materialatual  = ls_ordem-materialatual
*                                   %msg                = new_message( id       = ls_mensagem-id
*                                                                      number   = ls_mensagem-number
*                                                                      severity = CONV #( ls_mensagem-type )
*                                                                      v1       = ls_mensagem-message_v1
*                                                                      v2       = ls_mensagem-message_v2
*                                                                      v3       = ls_mensagem-message_v3
*                                                                      v4       = ls_mensagem-message_v4 )
*                                 ) ).

  ENDMETHOD.

*  METHOD substituirprodutoteste.
** ---------------------------------------------------------------------------
** Verificando a Autorização do User!
** ---------------------------------------------------------------------------
*    AUTHORITY-CHECK OBJECT 'ZSUBS_PROD' FOR USER sy-uname
*      ID 'ACTVT' FIELD '01'.    "Criar
*
*    IF sy-subrc NE 0.
*      APPEND VALUE #(  %msg     = new_message(
*                       id       = 'ZSD_CKPT_FATURAMENTO'
*                       number   = '001'
*                       severity = CONV #('I' ) ) ) TO reported-substprd.
*      RETURN.
*    ENDIF.
***********************************************************************
*    DATA(lt_return_msg) = NEW zclsd_submit_subst_prod( )->submit( it_keys = CORRESPONDING #( keys ) ).
** ---------------------------------------------------------------------------
** Para cada ordem de venda, realiza a operação de subsituição
** ---------------------------------------------------------------------------
*    reported-substprd = VALUE #(
*      FOR ls_ordem IN lt_return_msg
*      FOR ls_mensagem IN ls_ordem-messages
*      ( %tky-salesorder     = ls_ordem-salesorder
*        %tky-salesorderitem = ls_ordem-salesorderitem
*        %tky-material       = ls_ordem-material
*        %tky-materialatual  = ls_ordem-materialatual
*        %msg                = new_message(
*          id       = ls_mensagem-id
*          number   = ls_mensagem-number
*          severity = COND #(
*            WHEN ls_mensagem-type = 'E'
*            THEN CONV #( 'I' )
*            ELSE CONV #( ls_mensagem-type ) )
*          v1       = ls_mensagem-message_v1
*          v2       = ls_mensagem-message_v2
*          v3       = ls_mensagem-message_v3
*          v4       = ls_mensagem-message_v4 )
*     ) ).
*
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
