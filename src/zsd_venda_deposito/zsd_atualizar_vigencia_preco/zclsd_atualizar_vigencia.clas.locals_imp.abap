CLASS lcl_atualvig DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    "! Recebe tabela de mensagens que retorna da função
    "! @parameter p_task |Identificador da task
    METHODS setup_messages IMPORTING p_task TYPE clike.

  PRIVATE SECTION.
    "! Ler CDS
    "! @parameter keys |Chaves de busca
    METHODS read FOR READ
      IMPORTING keys FOR READ atualvig RESULT result.

    "! Action Atualizar Vigência
    "! @parameter keys |Chaves de busca
    METHODS atualizar FOR MODIFY
      IMPORTING keys FOR ACTION atualvig~atualizar.

    DATA gt_messages       TYPE STANDARD TABLE OF bapiret2.
    DATA gv_wait_async     TYPE abap_bool.
    DATA: gv_record        TYPE zssd_atual_vig.

ENDCLASS.

CLASS lcl_atualvig IMPLEMENTATION.

  METHOD read.
    SELECT  *
      FROM zi_sd_atual_vig
      FOR ALL ENTRIES IN @keys
         WHERE vtweg    = @keys-vtweg
           AND pltyp    = @keys-pltyp
           AND werks    = @keys-werks
           AND matnr    = @keys-matnr
           AND datbi    = @keys-datbi
           INTO TABLE @DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      CHECK line_exists( keys[ vtweg = <fs_data>-vtweg
                               pltyp = <fs_data>-pltyp
                               werks = <fs_data>-werks
                               matnr = <fs_data>-matnr
                               datbi = <fs_data>-datbi
                           ] ).

      APPEND CORRESPONDING #( <fs_data> ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD atualizar.

    AUTHORITY-CHECK OBJECT 'ZSD_AVP_01' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_atual_vig IN LOCAL MODE
      ENTITY atualvig
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_linhas)
      FAILED failed.

      READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
      IF sy-subrc IS INITIAL.

        IF <fs_key>-%param-kodatab > <fs_key>-%param-kodatbi.
          APPEND VALUE #(    %msg     = new_message(
                             id       = CONV symsgid( 'ZSD_COCKPIT_DEVOL' )
                             number   = CONV symsgno( '000' )
                             severity = CONV #( 'I' )
                             v1       = TEXT-001 )   ) TO   reported-atualvig .
        ELSE.

          DATA(lo_atualiza_vigencia) = NEW zclsd_atualiza_vigencia( ).
          reported-atualvig = VALUE #( FOR ls_linhas IN lt_linhas
            FOR ls_mensagem IN lo_atualiza_vigencia->execute(
               EXPORTING
                  iv_data_in  = <fs_key>-%param-kodatab
                  iv_data_fim = <fs_key>-%param-kodatbi
                  is_record   = CORRESPONDING #( ls_linhas ) )
                  (  %tky = ls_linhas-%tky
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
        ENDIF.
      ENDIF.

    ELSE.

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_GESTAO_PRECOS'
                                 number   = '071'
                                 severity = CONV #( 'E' ) ) ) TO reported-atualvig.

    ENDIF.

*    LOOP AT lt_linhas ASSIGNING FIELD-SYMBOL(<fs_linha>).
*    APPEND VALUE #(  %tky = <fs_linha>-%tky ) TO mapped-atualvig.
*    endloop.

*    "Mapear os dados da linha selecionado no app para enviar na função.
**    READ TABLE lt_linhas ASSIGNING FIELD-SYMBOL(<fs_linha>) INDEX 1.
*    LOOP AT lt_linhas ASSIGNING FIELD-SYMBOL(<fs_linha>).
*      IF sy-subrc IS INITIAL.
*        FREE gt_messages[].
*        CLEAR gv_record.
*        DATA(lv_tabix) = sy-tabix.
*        gv_record-vtweg = <fs_linha>-vtweg.
*        gv_record-pltyp = <fs_linha>-pltyp.
*        gv_record-werks = <fs_linha>-werks.
*        gv_record-matnr = <fs_linha>-matnr.
*        gv_record-datbi = <fs_linha>-datbi.
*        gv_record-datab = <fs_linha>-datab.
*        gv_record-knumh = <fs_linha>-knumh.
*        gv_record-kbetr = <fs_linha>-kbetr.
*        gv_record-konwa = <fs_linha>-konwa.
*        gv_record-mxwrt = <fs_linha>-mxwrt.
*        gv_record-gkwrt = <fs_linha>-gkwrt.
*
*        READ TABLE keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX lv_tabix.
*        IF sy-subrc IS INITIAL.
*
*          DATA(lo_atualiza_vigencia) = NEW zclsd_atualiza_vigencia( ).
*          gt_messages = lo_atualiza_vigencia->execute(
*            EXPORTING
*              iv_data_in  = <fs_key>-%param-kodatab
*              iv_data_fim = <fs_key>-%param-kodatbi
*              is_record   = gv_record
*          ).
*
**          "Executar a BAPI numa função NEW TASK para evitar erros no Fiori.
**          CALL FUNCTION 'ZFMSD_ATUALIZAR_VIG'
**            STARTING NEW TASK 'ATUAL_VIG'
**            CALLING setup_messages ON END OF TASK
**            EXPORTING
**              iv_data_in  = <fs_key>-%param-kodatab
**              iv_data_fim = <fs_key>-%param-kodatbi
**              is_record   = gv_record.
**
**          WAIT UNTIL gv_wait_async = abap_true.
*        ENDIF.
*
*        IF line_exists( gt_messages[ type = 'E' ] ).
*          APPEND VALUE #(  %tky = <fs_linha>-%tky ) TO failed-atualvig.
*
*        ELSE.
*          FREE gt_messages[].
*          " Condição criada com sucesso.
*          gt_messages = VALUE #( BASE gt_messages ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '039' ) ).
*
*        ENDIF.
*
*        LOOP AT gt_messages INTO DATA(ls_message).
*
**         APPEND VALUE #( %tky        = <fs_linha>-%tky
*                          %msg        = new_message( id       = ls_message-id
*                                                     number   = ls_message-number
*                                                     v1       = ls_message-message_v1
*                                                     v2       = ls_message-message_v2
*                                                     v3       = ls_message-message_v3
*                                                     v4       = ls_message-message_v4
*                                                     severity = CONV #( ls_message-type ) )
*                           )
*            TO reported-atualvig.
*
*        ENDLOOP.
*
*        READ ENTITIES OF zi_sd_atual_vig IN LOCAL MODE
*        ENTITY atualvig
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_atual)
*        FAILED failed.
*
*        result = VALUE #(  FOR ls_int IN lt_atual
*                               ( %tky   = ls_int-%tky
*                                 %param = ls_int ) ).
*
*      ENDIF.
*    ENDLOOP.
*

  ENDMETHOD.


  METHOD setup_messages.
    " Obter as mensagens de retorno da função que executa a Bapi.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_ATUALIZAR_VIG'
          IMPORTING
            et_return = gt_messages.

    gv_wait_async = abap_true.
  ENDMETHOD.

ENDCLASS.
