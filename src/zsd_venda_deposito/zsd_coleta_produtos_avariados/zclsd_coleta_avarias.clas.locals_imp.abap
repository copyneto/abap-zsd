CLASS lcl_sd_coleta_avarias  DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK  zc_sd_coleta_avarias .

    METHODS read FOR READ
      IMPORTING keys FOR READ  zc_sd_coleta_avarias  RESULT result.

    METHODS imprimeform FOR MODIFY
      IMPORTING keys FOR ACTION  zc_sd_coleta_avarias~imprimeform.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR  zc_sd_coleta_avarias  RESULT result.

ENDCLASS.

CLASS lcl_sd_coleta_avarias  IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.
    SELECT * FROM  zc_sd_coleta_avarias
    FOR ALL ENTRIES IN @keys
    WHERE salesorder        = @keys-salesorder
    INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD imprimeform.

READ ENTITIES OF zc_sd_coleta_avarias IN LOCAL MODE
ENTITY zc_sd_coleta_avarias
FIELDS ( salesorder ) WITH CORRESPONDING #( keys )
RESULT DATA(lt_coleta_avarias)
FAILED failed.

    DATA(lo_coleta_avarias) = NEW zclsd_form_coleta_avaria( ).
    reported-zc_sd_coleta_avarias = VALUE #( FOR ls_coleta_avarias IN lt_coleta_avarias
         FOR ls_mensagem IN lo_coleta_avarias->execute( ls_coleta_avarias-salesorder )
         ( %tky = VALUE #( salesorder = ls_coleta_avarias-salesorder )
           %msg        =
             new_message(
               id       = ls_mensagem-id
               number   = ls_mensagem-number
               severity = CONV #( ls_mensagem-type )
               v1       = ls_mensagem-message_v1
               v2       = ls_mensagem-message_v2
               v3       = ls_mensagem-message_v3
               v4       = ls_mensagem-message_v4 )
       ) ).

  ENDMETHOD.

  METHOD get_features.
    RETURN.
  ENDMETHOD.

ENDCLASS.

*CLASS lcl_ zc_sd_coleta_avarias  DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.
*
*    METHODS check_before_save REDEFINITION.
*
*    METHODS finalize          REDEFINITION.
*
*    METHODS save              REDEFINITION.
*
*ENDCLASS.
*
*CLASS lcl_ zc_sd_coleta_avarias  IMPLEMENTATION.
*
*  METHOD check_before_save.
*  ENDMETHOD.
*
*  METHOD finalize.
*  ENDMETHOD.
*
*  METHOD save.
*  ENDMETHOD.
*
*ENDCLASS.
