CLASS zclsd_imprimir_nfe DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    "! Executa a Impressão da nota
    "! @parameter iv_docnum |Nº documento da nota fiscal
    "! @parameter rt_return |Log de mensagem do processamento
    METHODS executar
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    "!Tabela de retorno de mensagens
    DATA gt_return TYPE bapiret2_t .
ENDCLASS.



CLASS ZCLSD_IMPRIMIR_NFE IMPLEMENTATION.


  METHOD executar.

    DATA:
      lt_return    TYPE STANDARD TABLE OF bapiret2.

    CALL FUNCTION 'ZFMSD_IMPRIMIR_NFE'
      STARTING NEW TASK 'IMPRIMIR_NFE' CALLING task_finish ON END OF TASK
      EXPORTING
        iv_docnum = iv_docnum
      TABLES
        et_return = lt_return.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

*    SORT lt_return[] BY type.
*    READ TABLE lt_return[] TRANSPORTING NO FIELDS WITH KEY type = 'S' BINARY SEARCH.
*
*    IF sy-subrc = 0.
*      COMMIT WORK.
*    ENDIF.

    rt_return = gt_return.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_IMPRIMIR_NFE'
      TABLES
        et_return  = gt_return.

*
*    IF line_exists( gt_return[ type = 'S' ] ) .
*      COMMIT WORK.
*    ENDIF.

    RETURN.

  ENDMETHOD.
ENDCLASS.
