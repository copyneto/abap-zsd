CLASS zcxsd_ciclo_pedido DEFINITION PUBLIC INHERITING FROM cx_static_check FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .

    METHODS constructor
      IMPORTING
        is_textid   LIKE if_t100_message=>t100key OPTIONAL
        io_previous LIKE previous OPTIONAL
        is_message  TYPE symsg.

    DATA gs_message TYPE symsg READ-ONLY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcxsd_ciclo_pedido IMPLEMENTATION.
  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = io_previous ).
    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = is_textid.
    ENDIF.
    gs_message = is_message.
  ENDMETHOD.
ENDCLASS.
