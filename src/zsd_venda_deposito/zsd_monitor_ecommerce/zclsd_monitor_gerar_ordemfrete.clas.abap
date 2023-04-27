"!<p><h2>Criação de Ordem de Frete no Monitor E-Commerce SD</h2></p>
"!<p><strong>Autor: </strong>Enio Rafael de Jesus</p>
"!<p><strong>Data: </strong>01 de junho de 2022</p>
CLASS zclsd_monitor_gerar_ordemfrete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "!Tipo da ordem de frete a ser gerada
    CONSTANTS gc_DOCTYPE_OF TYPE /scmtms/tor_type VALUE 'F006' ##NO_TEXT.

    "! Executa a geração da ordem de frete
    "! @parameter iv_unidade_frete | Nº unidade de frete
    "! @parameter iv_remessa       | Nº remessa
    "! @parameter rt_messages      | Mensagens de retorno do processamento
    METHODS executar
      IMPORTING
        iv_remessa         TYPE likp-vbeln
        iv_unidade_frete   TYPE /scmtms/tor_id
      RETURNING
        VALUE(rt_messages) TYPE bal_t_msgr.

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        p_task TYPE clike.

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
    "!Tabela de mensagens
    gt_return TYPE STANDARD TABLE OF bal_s_msgr.

    METHODS:
      "! Retornar mensagens de processamento
      "! @parameter rt_messages | Mensagens retorno
      get_return_messages
        RETURNING
          VALUE(rt_messages) TYPE  bal_t_msgr.

    METHODS:
      "! Inserir mensagem nas mensagens de processamento
      "! @parameter iv_id     | Id mensagem
      "! @parameter iv_number | Nº mensagem
      "! @parameter iv_type   | Tipo mensagem
      "! @parameter iv_v1     | Variável 1
      "! @parameter iv_v2     | Variável 2
      "! @parameter iv_v3     | Variável 3
      "! @parameter iv_v4     | Variável 4
      set_return_message
        IMPORTING
          iv_id     TYPE bal_s_msgr-msgid
          iv_number TYPE bal_s_msgr-msgno
          iv_type   TYPE bal_s_msgr-msgty
          iv_v1     TYPE bal_s_msgr-msgv1 OPTIONAL
          iv_v2     TYPE bal_s_msgr-msgv2 OPTIONAL
          iv_v3     TYPE bal_s_msgr-msgv3 OPTIONAL
          iv_v4     TYPE bal_s_msgr-msgv4 OPTIONAL.
ENDCLASS.



CLASS zclsd_monitor_gerar_ordemfrete IMPLEMENTATION.
  METHOD executar.
    IF iv_unidade_frete IS INITIAL.
      me->set_return_message(
        EXPORTING
          iv_id     = 'ZSD_MONITOR_ECOMM'
          iv_number = 008
          iv_type   = 'E'
          iv_v1     = |{ iv_remessa ALPHA = OUT }|
      ).
    ELSE.
      CALL FUNCTION 'ZFMSD_MONITOR_GERAR_ORDEMFRETE'
        STARTING NEW TASK 'GERA_OF_BACKGROUND' CALLING task_finish ON END OF TASK
        EXPORTING
          iv_remessa       = iv_remessa
          iv_unidade_frete = iv_unidade_frete.

      WAIT FOR ASYNCHRONOUS TASKS UNTIL me->get_return_messages( ) IS NOT INITIAL."#EC CI_CONV_OK
    ENDIF.

    rt_messages = me->get_return_messages( )."#EC CI_CONV_OK
  ENDMETHOD.

  METHOD task_finish.
    CLEAR me->gt_return.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_MONITOR_GERAR_ORDEMFRETE'
      IMPORTING
        et_return  = me->gt_return.
  ENDMETHOD.

  METHOD get_return_messages.
    rt_messages = me->gt_return.
  ENDMETHOD.

  METHOD set_return_message.
    APPEND VALUE #(
      msgid = iv_id
      msgno = iv_number
      msgty = iv_type
      msgv1 = iv_v1
      msgv2 = iv_v2
      msgv3 = iv_v3
      msgv4 = iv_v4
    ) TO me->gt_return.
  ENDMETHOD.

ENDCLASS.
