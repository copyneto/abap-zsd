CLASS zclsd_desbloquea_ordem DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Executa a geração do faturamento
    "! @parameter iv_ordem |Nº documento do documento de referência
    METHODS executar IMPORTING iv_ordem            TYPE vbeln_va
                     RETURNING
                               VALUE(rt_mensagens) TYPE bapiret2_tab.

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish IMPORTING p_task TYPE clike.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
    "!Tabela de retorno de mensagens
    gt_return TYPE STANDARD TABLE OF bapiret2 .

    METHODS:
      "! Método para filtrar mensagens de retorno
      "! @parameter rt_mensagens | Mensagens retornO
      mensagens
        RETURNING
          VALUE(rt_mensagens) TYPE  bapiret2_tab.
ENDCLASS.



CLASS zclsd_desbloquea_ordem IMPLEMENTATION.


  METHOD executar.

    DATA lt_return TYPE bapiret2_tab.
*
*    DATA(ls_order_header) = VALUE bapisdh1x( updateflag = 'U'
*                                             dlv_block  = 'X' ).

    CALL FUNCTION 'ZFMSD_MONITOR_DESBLOQUEA_OV'
      STARTING NEW TASK 'DESBLOQUEAR_ORDEM' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_ordem  = iv_ordem
*       salesdocument    = iv_ordem
*       order_header_inx = ls_order_header
      TABLES
*       return    = lt_return.
        et_return = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.


    rt_mensagens = mensagens( ).


  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_MONITOR_DESBLOQUEA_OV'
      TABLES
        et_return  = gt_return.
    RETURN.
  ENDMETHOD.


  METHOD mensagens.

    LOOP AT me->gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND <fs_return> TO rt_mensagens.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
