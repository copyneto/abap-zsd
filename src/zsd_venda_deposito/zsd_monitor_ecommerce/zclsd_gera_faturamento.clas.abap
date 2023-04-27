CLASS zclsd_gera_faturamento DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "!Categoria de documento SD precedente
    CONSTANTS gc_ref_doc_ca TYPE string VALUE 'J' ##NO_TEXT.

    "! Executa a geração do faturamento
    "! @parameter iv_ref_doc |Nº documento do documento de referência
    METHODS executar IMPORTING iv_ref_doc          TYPE vgbel
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



CLASS ZCLSD_GERA_FATURAMENTO IMPLEMENTATION.


  METHOD executar.

    DATA:
      lt_return    TYPE STANDARD TABLE OF bapireturn1,
      lt_billing   TYPE STANDARD TABLE OF bapivbrk,
      lt_condition TYPE STANDARD TABLE OF bapikomv,
      lt_ccard     TYPE STANDARD TABLE OF bapiccard_vf.

    APPEND VALUE #( ref_doc    = iv_ref_doc
                    ref_doc_ca = gc_ref_doc_ca ) TO lt_billing.

    CALL FUNCTION 'ZFMSD_GERA_FATURAMENTO'
      STARTING NEW TASK 'GERA_FATURAMENTO' CALLING task_finish ON END OF TASK
      TABLES
        et_billing_data_in   = lt_billing
        et_condition_data_in = lt_condition
        et_return            = lt_return
        et_ccard_data_in     = lt_ccard.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

    rt_mensagens = mensagens( ).

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_GERA_FATURAMENTO'
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
