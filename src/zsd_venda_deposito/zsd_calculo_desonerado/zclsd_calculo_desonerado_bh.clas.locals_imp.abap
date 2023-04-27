CLASS lc_calculo_desonerado DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
  PRIVATE SECTION.
    TYPES: BEGIN OF ty_msg,
             severity TYPE char01,
             text     TYPE string,
           END OF ty_msg.
    DATA:  gt_msg TYPE TABLE OF ty_msg.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTSD_CBENEF'.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR calculo_desonerado RESULT result.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR calculo_desonerado~authorityCreate.

    METHODS validecampos FOR VALIDATE ON SAVE
      IMPORTING keys FOR calculo_desonerado~validecampos.

    METHODS verifica_id
      IMPORTING is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_01
      IMPORTING is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS mensagem_id_01
      IMPORTING iv_id TYPE ze_id_cbenef.
    METHODS mensagem_id_02
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_03
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_04
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_05
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_06
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_07
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_08
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS mensagem_id_09
      IMPORTING
        iv_id TYPE zi_sd_calculo_desonerado-id.
    METHODS verifica_campos_02
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_03
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_04
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_05
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_06
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_07
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_08
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
    METHODS verifica_campos_09
      IMPORTING
        is_calculo_desonerado TYPE zi_sd_calculo_desonerado.
ENDCLASS.

CLASS lc_calculo_desonerado IMPLEMENTATION.

  METHOD validecampos.

    READ ENTITIES OF zi_sd_calculo_desonerado
     IN LOCAL MODE ENTITY calculo_desonerado
     ALL FIELDS WITH CORRESPONDING #( keys )
     RESULT DATA(lt_calculo_desonerado) .

    DATA(ls_calc_desonerado) = lt_calculo_desonerado[ 1 ].
    verifica_id( is_calculo_desonerado = ls_calc_desonerado ).
    reported-calculo_desonerado = VALUE #( FOR ls_msg IN gt_msg

    (  %tky        = ls_calc_desonerado-%tky
                        %msg        = new_message_with_text(
                        severity    = if_abap_behv_message=>severity-error
                        text        = ls_msg-text )
                       )

      ).

  ENDMETHOD.

  METHOD verifica_id.

    CASE is_calculo_desonerado-id.
      WHEN 01.
        verifica_campos_01( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 02.
        verifica_campos_02( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 03.
        verifica_campos_03( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 04.
        verifica_campos_04( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 05.
        verifica_campos_05( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 06.
        verifica_campos_06( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 07.
        verifica_campos_07( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 08.
        verifica_campos_08( is_calculo_desonerado = is_calculo_desonerado ).
      WHEN 09.
        verifica_campos_09( is_calculo_desonerado = is_calculo_desonerado ).
    ENDCASE.

  ENDMETHOD.

  METHOD mensagem_id_01.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                   )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c02 } { TEXT-003 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c03 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c08 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_02.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c03 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c05 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.

  ENDMETHOD.


  METHOD mensagem_id_03.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c03 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c04 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_04.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c02 } { TEXT-003 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c03 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_05.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c03 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_06.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c03 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c05 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_07.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c03 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c07 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_08.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                   )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c03 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c06 } { TEXT-002 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.
  ENDMETHOD.


  METHOD mensagem_id_09.
    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c01 } { TEXT-002 } { iv_id } | "Campo Mandatório deve ser preenchido para ID.
                   )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                      text        = | { TEXT-c02 } { TEXT-002 } { iv_id } | "Campo não pode ser preenchido para ID.
                  )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c03 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c04 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c05 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c06 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c07 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-error
                      text        = | { TEXT-c08 } { TEXT-003 } { iv_id } |
                     )  TO gt_msg.

    APPEND VALUE #(   severity    = if_abap_behv_message=>severity-information
                       text        = | { TEXT-c09 } { TEXT-002 } { iv_id } |
                      )  TO gt_msg.

  ENDMETHOD.

  METHOD verifica_campos_01.
    IF is_calculo_desonerado-shipfrom       IS NOT INITIAL AND
       is_calculo_desonerado-shipto         IS INITIAL AND
       is_calculo_desonerado-documenttype   IS INITIAL AND
       is_calculo_desonerado-orderreason    IS INITIAL AND
       is_calculo_desonerado-materialnumber IS INITIAL AND
       is_calculo_desonerado-materialgroup  IS INITIAL AND
       is_calculo_desonerado-movementtype   IS INITIAL AND
       is_calculo_desonerado-cfopexternal   IS NOT INITIAL AND
       is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_01( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_02.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS NOT INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS NOT INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_02( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_03.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS NOT INITIAL AND
    is_calculo_desonerado-orderreason    IS NOT INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_03( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_04.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS INITIAL AND
    is_calculo_desonerado-documenttype   IS NOT INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_04( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_05.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS NOT INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_05( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_06.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS NOT INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_06( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_07.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS NOT INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_07( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_08.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS NOT INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_08( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.


  METHOD verifica_campos_09.
    IF is_calculo_desonerado-shipfrom    IS NOT INITIAL AND
    is_calculo_desonerado-shipto         IS NOT INITIAL AND
    is_calculo_desonerado-documenttype   IS INITIAL AND
    is_calculo_desonerado-orderreason    IS INITIAL AND
    is_calculo_desonerado-materialnumber IS INITIAL AND
    is_calculo_desonerado-materialgroup  IS INITIAL AND
    is_calculo_desonerado-movementtype   IS INITIAL AND
    is_calculo_desonerado-cfopexternal   IS INITIAL AND
    is_calculo_desonerado-taxsituation   IS NOT INITIAL.
    ELSE.

      mensagem_id_09( iv_id = is_calculo_desonerado-id ).

    ENDIF.
  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_sd_calculo_desonerado IN LOCAL MODE
        ENTITY calculo_desonerado
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-calculo_desonerado.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-calculo_desonerado.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-calculo_desonerado.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_calculo_desonerado IN LOCAL MODE
        ENTITY calculo_desonerado
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>update( gc_table ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>delete( gc_table ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
