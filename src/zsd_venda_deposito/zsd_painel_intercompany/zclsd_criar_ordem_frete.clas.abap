"!<p><h2>Criação de Ordem de Frete </h2></p>
"!<p><strong>Data: </strong>19 de outubro de 2022</p>
CLASS zclsd_criar_ordem_frete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_remessa TYPE STANDARD TABLE OF zi_sd_01_cockpit.

    "! Executa a geração da ordem de frete
    "! @parameter rt_messages      | Mensagens de retorno do processamento
    METHODS executar
      IMPORTING
        !it_remessa        TYPE ty_remessa OPTIONAL
      RETURNING
        VALUE(rt_messages) TYPE bal_t_msgr .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Retorna Ordem de Frete
    "! @parameter rv_return | Retornar Ordem de Frete
    METHODS get_ordemfrete
      RETURNING
        VALUE(rv_return) TYPE /scmtms/tor_id .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      "!Tabela de mensagens
      gt_return      TYPE STANDARD TABLE OF bal_s_msgr,
      "! Ordem Frete
      gv_ordem_frete TYPE  /scmtms/tor_id.

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



CLASS zclsd_criar_ordem_frete IMPLEMENTATION.


  METHOD executar.

*    DATA(lt_remessa) = VALUE zctgmm_vbeln(
*    FOR ls_remessa IN it_remessa
*     ( vbeln = ls_remessa-remessa )
*    ).

    DATA(lt_cockpit) = VALUE zctgsd_cockpit(
    FOR ls_remessa IN it_remessa WHERE ( tipooperacao NE 'INT4' )
     ( remessa = ls_remessa-remessa
       ztraid  = ls_remessa-ztraid
       ztrai1  = ls_remessa-ztrai1
       ztrai2  = ls_remessa-ztrai2
       ztrai3  = ls_remessa-ztrai3
       agfrete = ls_remessa-agfrete
       motora  = ls_remessa-motora )
    ).

*    CALL FUNCTION 'ZFMMM_CRIAR_ORDEM_FRETE'
*      STARTING NEW TASK 'SD_GERA_OF_BACKGROUND' CALLING task_finish ON END OF TASK
*      TABLES
*        t_vbeln = lt_remessa.
    CALL FUNCTION 'ZFMSD_CRIAR_ORDEM_FRETE_INTER'
      STARTING NEW TASK 'SD_GERA_OF_BACKGROUND' CALLING task_finish ON END OF TASK
      TABLES
        t_cockpit = lt_cockpit.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL me->get_return_messages( ) IS NOT INITIAL. "#EC CI_CONV_OK

    rt_messages = me->get_return_messages( ).           "#EC CI_CONV_OK
  ENDMETHOD.


  METHOD get_ordemfrete.
    rv_return = me->gv_ordem_frete.
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


  METHOD task_finish.
    CLEAR me->gt_return.
*    RECEIVE RESULTS FROM FUNCTION 'ZFMMM_CRIAR_ORDEM_FRETE'
*      IMPORTING
*        ev_ordem_frete = me->gv_ordem_frete
*        et_return  = me->gt_return.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_CRIAR_ORDEM_FRETE_INTER'
      IMPORTING
        ev_ordem_frete = me->gv_ordem_frete
        et_return  = me->gt_return.
  ENDMETHOD.
ENDCLASS.
