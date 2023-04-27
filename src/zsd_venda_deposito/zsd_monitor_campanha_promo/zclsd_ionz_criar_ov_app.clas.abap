CLASS zclsd_ionz_criar_ov_app DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Executa a geração do faturamento
    "! @parameter iv_id |ID de cadastro
    METHODS executar
      IMPORTING
        !iv_id              TYPE ztsd_sint_proces-id
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
    "!Tabela de retorno de mensagens
    gt_return TYPE STANDARD TABLE OF bapiret2 .

    METHODS:
      "! Método para filtrar mensagens de retorno
      "! @parameter rt_mensagens | Mensagens retorno
      mensagens
        RETURNING
          VALUE(rt_mensagens) TYPE  bapiret2_tab.

ENDCLASS.



CLASS ZCLSD_IONZ_CRIAR_OV_APP IMPLEMENTATION.


  METHOD executar.

    DATA:
      lt_return    TYPE STANDARD TABLE OF bapireturn1.

    CALL FUNCTION 'ZFMSD_IONZ_CRIAR_OV'
      STARTING NEW TASK 'CRIAR_OV' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_id        = iv_id
      TABLES
        et_return = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    rt_mensagens = mensagens( ).

  ENDMETHOD.


  METHOD mensagens.

    LOOP AT me->gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      IF NOT ( <fs_return>-type = 'W' ).
        APPEND <fs_return> TO rt_mensagens.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_IONZ_CRIAR_OV'
      TABLES
        et_return  = gt_return.
    RETURN.
  ENDMETHOD.
ENDCLASS.
