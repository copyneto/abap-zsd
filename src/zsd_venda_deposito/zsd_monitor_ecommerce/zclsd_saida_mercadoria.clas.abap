CLASS zclsd_saida_mercadoria DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "!Categoria de documento SD precedente
    CONSTANTS gc_abaptrue TYPE string VALUE 'X' ##NO_TEXT.

    "! Executa a geração do faturamento
    "! @parameter iv_delivery | Remessa
    METHODS executar
      IMPORTING
        iv_delivery         TYPE vbeln_vl
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
    "!Tabela de retorno de mensagens
    gt_return TYPE STANDARD TABLE OF prott .

    METHODS:
      "! Método para filtrar mensagens de retorno
      "! @parameter rt_mensagens | Mensagens retornO
      mensagens
        RETURNING
          VALUE(rt_mensagens) TYPE  bapiret2_tab.

ENDCLASS.



CLASS ZCLSD_SAIDA_MERCADORIA IMPLEMENTATION.


  METHOD executar.

    DATA: lt_return TYPE STANDARD TABLE OF prott.

    DATA(ls_vbkok) = VALUE vbkok( vbeln_vl = iv_delivery
                                  vbeln = iv_delivery
                                  wabuc = gc_abaptrue ).

    CALL FUNCTION 'WS_DELIVERY_UPDATE_2'
      STARTING NEW TASK 'SAIDA_MERCADORIA' CALLING task_finish ON END OF TASK
      EXPORTING
        vbkok_wa        = ls_vbkok
        synchron        = gc_abaptrue
        commit          = gc_abaptrue
        delivery        = iv_delivery
        nicht_sperren_1 = gc_abaptrue
      TABLES
        prot            = lt_return
      EXCEPTIONS
        error_message   = 1
        OTHERS          = 2.


    IF sy-subrc NE 0 OR sy-subrc EQ 0.
      CLEAR ls_vbkok.
    ENDIF.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    rt_mensagens = mensagens( ).

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'WS_DELIVERY_UPDATE_2'
      TABLES
        prot  = gt_return.
    RETURN.
  ENDMETHOD.


  METHOD mensagens.

    IF gt_return IS INITIAL.
      APPEND VALUE #( type        = 'S'
                      id          = 'ZSD_MONITOR_ECOMM'
                      number      = '006') TO  rt_mensagens.
    ELSE.
      LOOP AT me->gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
        APPEND VALUE #( type        = <fs_return>-msgty
                        id          = <fs_return>-msgid
                        number      = <fs_return>-msgno
                        message_v1  = <fs_return>-msgv1
                        message_v2  = <fs_return>-msgv2
                        message_v3  = <fs_return>-msgv3
                        message_v4  = <fs_return>-msgv4 ) TO  rt_mensagens.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
