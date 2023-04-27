"!<p><h2>zclsd_i_sd_kit_bon_app</h2></p>
"! Classe que contrato o comportamento do aplicativo  <br/>
"! <br/>
"!<p><strong>Autor:</strong> Willian Hazor</p>
"!<p><strong>Data:</strong> 02 de Fev de 2022</p>
CLASS lcl_KitProcessor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.


  PRIVATE SECTION.

    CONSTANTS: gc_classe_message TYPE symsgid VALUE 'ZSD_KIT_BONIFICACAO',
               gc_typemessa_erro VALUE 'E',
               gc_msg_10         TYPE symsgno VALUE '010',
               gc_msg_11         TYPE symsgno VALUE '011'.

    METHODS:
      "! Ler CDS
      "! @parameter keys |Chaves de busca
      read FOR READ
        IMPORTING keys FOR READ KitProcessor RESULT result.
*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE KitProcessor.
    METHODS:
      "! Action criarOrdem
      "! @parameter keys |Chaves de busca
      criarOrdem FOR MODIFY
        IMPORTING keys FOR ACTION KitProcessor~criarOrdem.
    METHODS:
      "! Action cancelOrdem
      "! @parameter keys |Chaves de busca
      cancelOrdem FOR MODIFY
        IMPORTING keys FOR ACTION KitProcessor~cancelOrdem.
    DATA gv_wait_async     TYPE abap_bool.


ENDCLASS.

CLASS lcl_KitProcessor IMPLEMENTATION.

  METHOD read.
*
    IF  keys IS NOT INITIAL.
      SELECT *
       FROM zi_sd_kit_bon_app
        FOR ALL ENTRIES IN @keys
           WHERE competencia = @keys-competencia
             AND plant        = @keys-plant
             AND dockit       = @keys-dockit
             AND matnrkit     = @keys-matnrkit
             AND matnrfree    = @keys-matnrfree
             AND kunnr        = @keys-kunnr
             AND Posnr        = @keys-Posnr
             INTO CORRESPONDING FIELDS OF TABLE @result.
    ENDIF.

  ENDMETHOD.

  METHOD criarOrdem.

    DATA: Lt_data   TYPE zctgsd_kit_bon_app,
          ls_data   TYPE zssd_sd_kit_bon,
          Lt_return TYPE bapiret2_t.


    READ ENTITIES OF zi_sd_kit_bon_app IN LOCAL MODE
      ENTITY KitProcessor
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_KitProcessor).

    DATA(lv_error) = abap_false.
    LOOP AT lt_KitProcessor ASSIGNING FIELD-SYMBOL(<fs_KitProcessor>).
      IF <fs_KitProcessor>-Vbeln IS NOT INITIAL.
        APPEND VALUE #( %tky = <fs_kitprocessor>-%tky
                        %msg = new_message( id       = gc_classe_message
                                            number   = gc_msg_10
                                            severity = CONV #( gc_typemessa_erro ) ) )  TO reported-kitprocessor.
        lv_error = abap_true.

      ENDIF.

      ls_data = CORRESPONDING #( <fs_kitprocessor>-%data ).
      APPEND ls_data TO lt_data.
    ENDLOOP.

    CHECK lv_error = abap_false.

    NEW zclsd_kits_bonificacao_ordem( )->create_order(
      EXPORTING
        it_data          = lt_data
      IMPORTING
        et_return        = Lt_return ).


    LOOP AT Lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( %msg = new_message( id       = <fs_return>-id
                                          number   = <fs_return>-number
                                          severity = CONV #( <fs_return>-type )
                                          v1       = <fs_return>-message_v1
                                          v2       = <fs_return>-message_v2
                                          v3       = <fs_return>-message_v3
                                          v4       = <fs_return>-message_v4 ) )  TO reported-kitprocessor.
    ENDLOOP.

  ENDMETHOD.


  METHOD cancelordem.


    TYPES: BEGIN OF ty_salesodcument,
             salesodcument TYPE vbeln_va,
           END OF ty_salesodcument.


    DATA: lv_salesodcument TYPE vbeln_va,
          lt_salesodcument TYPE TABLE OF ty_salesodcument,
          lt_return        TYPE bapiret2_t,
          lt_return_all    TYPE bapiret2_t.

    READ ENTITIES OF zi_sd_kit_bon_app IN LOCAL MODE
      ENTITY KitProcessor
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_KitProcessor).

    DATA(lv_error) = abap_false.
    LOOP AT lt_KitProcessor ASSIGNING FIELD-SYMBOL(<fs_KitProcessor>).
      IF <fs_KitProcessor>-Vbeln IS INITIAL.
        APPEND VALUE #( %tky = <fs_kitprocessor>-%tky
                        %msg = new_message( id       = gc_classe_message
                                            number   = gc_msg_11
                                            severity = CONV #( gc_typemessa_erro ) ) )  TO reported-kitprocessor.

        lv_error = abap_true.

      ENDIF.
      APPEND <fs_KitProcessor>-Vbeln TO lt_salesodcument.
    ENDLOOP.

    CHECK lv_error = abap_false.

    SORT lt_salesodcument. DELETE ADJACENT DUPLICATES FROM lt_salesodcument.

    LOOP AT lt_salesodcument ASSIGNING FIELD-SYMBOL(<fs_salesodcument>).

      NEW zclsd_kits_bonificacao_ordem( )->recusar_order(
        EXPORTING
          iv_salesodcument = <fs_salesodcument>-salesodcument
        IMPORTING
          et_return        = lt_return ).

      APPEND LINES OF lt_return TO lt_return_all.
    ENDLOOP.


    LOOP AT lt_return_all ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( %msg = new_message( id       = <fs_return>-id
                                          number   = <fs_return>-number
                                          severity = CONV #( <fs_return>-type )
                                          v1       = <fs_return>-message_v1
                                          v2       = <fs_return>-message_v2
                                          v3       = <fs_return>-message_v3
                                          v4       = <fs_return>-message_v4 ) )  TO reported-kitprocessor.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_KitProcessor_saver DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_KitProcessor_saver IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
*    DATA(lo_contab) = zclfi_contabilizacao=>get_instance(  ).
*    lo_contab->save(  ).
    RETURN.
  ENDMETHOD.

ENDCLASS.
