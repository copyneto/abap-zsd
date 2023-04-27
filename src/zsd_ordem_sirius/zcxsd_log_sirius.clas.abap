"!<p><h2>Exceções para a geração de log de envio de OV p/ Sirius</h2></p>
"!<p><strong>Autor:</strong>Anderson Miazato</p>
"!<p><strong>Data:</strong>9 de nov de 2021</p>
CLASS zcxsd_log_sirius DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    METHODS constructor
      IMPORTING
        is_textid   LIKE if_t100_message=>t100key OPTIONAL
        is_previous LIKE previous OPTIONAL .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcxsd_log_sirius IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    CALL METHOD super->constructor
      EXPORTING
        previous = is_previous.
    CLEAR me->textid.
    IF is_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = is_textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
