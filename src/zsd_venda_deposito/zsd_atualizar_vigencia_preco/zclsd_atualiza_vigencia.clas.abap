CLASS zclsd_atualiza_vigencia DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS execute
      IMPORTING
        !iv_data_in      TYPE dats
        !iv_data_fim     TYPE dats
        !is_record       TYPE zssd_atual_vig
      RETURNING
        VALUE(rt_return) TYPE tt_bapiret2 .
    CLASS-METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA: gt_return TYPE STANDARD TABLE OF bapiret2.
    CLASS-DATA gv_wait_async TYPE abap_bool .
ENDCLASS.



CLASS zclsd_atualiza_vigencia IMPLEMENTATION.


  METHOD execute.

      CALL FUNCTION 'ZFMSD_ATUALIZAR_VIG'
        STARTING NEW TASK 'ATUAL_VIG'
        CALLING setup_messages ON END OF TASK
        EXPORTING
          iv_data_in  = iv_data_in
          iv_data_fim = iv_data_fim
          is_record   = is_record.

      WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async = abap_true.

      CLEAR gv_wait_async.

      rt_return = gt_return.

  ENDMETHOD.


  METHOD setup_messages.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_ATUALIZAR_VIG'
          IMPORTING
            et_return = gt_return.

    IF NOT gt_return IS INITIAL.
      gv_wait_async = abap_true.
    ENDIF.

    IF NOT line_exists( gt_return[ type = 'E' ] ).
      REFRESH gt_return.
      " Condição criada com sucesso.
      gt_return = VALUE #( BASE gt_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '063' ) ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
