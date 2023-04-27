CLASS lcl_monitor DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS: gc_msg_id   TYPE symsgid VALUE 'ZSD_INTERFACE_IONZ',
               gc_msg_nr   TYPE symsgno VALUE '008',
               gc_msgtpe_s VALUE 'S',
               gc_zcriarov TYPE tobj-objct VALUE 'ZCRIAROV' ##NO_TEXT,
               gc_zcriarbp TYPE tobj-objct VALUE 'ZCRIARBP' ##NO_TEXT,
               gc_zlib_id  TYPE tobj-objct VALUE 'ZLIB_ID' ##NO_TEXT,
               gc_actvt    TYPE authx-fieldname VALUE 'ACTVT' ##NO_TEXT,
               gc_01       TYPE char2 VALUE '01'.


    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK monitor.

    METHODS read FOR READ
      IMPORTING keys FOR READ monitor RESULT result.

    METHODS criarov FOR MODIFY
      IMPORTING keys FOR ACTION monitor~criarov.

    METHODS liberacaoid FOR MODIFY
      IMPORTING keys FOR ACTION monitor~liberacaoid.

    METHODS interfacezionz FOR MODIFY
      IMPORTING keys FOR ACTION monitor~interfacezionz.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR monitor RESULT result.

    METHODS criarbp FOR MODIFY
      IMPORTING keys FOR ACTION monitor~criarbp.

ENDCLASS.

CLASS lcl_monitor IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_monitor_campanha
    FOR ALL ENTRIES IN @keys
    WHERE id       = @keys-id
*      AND Promocao = @keys-promocao
    INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.


  METHOD criarov.

* verificando a autorização do user!
    AUTHORITY-CHECK OBJECT gc_zcriarov FOR USER sy-uname
      ID gc_actvt FIELD gc_01.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_campanha IN LOCAL MODE
    ENTITY monitor
      FIELDS ( id ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_monitor)
    FAILED failed.

      DATA(lo_cria_ov) = NEW zclsd_ionz_criar_ov_app( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN lo_cria_ov->executar( iv_id = ls_monitor-id )
        ( %tky = VALUE #( id = ls_monitor-id )
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

    ENDIF.
  ENDMETHOD.

  METHOD liberacaoid.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT gc_zlib_id FOR USER sy-uname
      ID gc_actvt FIELD gc_01.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_campanha IN LOCAL MODE
  ENTITY monitor
    FIELDS ( id promocao ) WITH CORRESPONDING #( keys )
  RESULT DATA(lt_monitor)
  FAILED failed.

      DATA(lo_liberacao_id) = NEW zclsd_liberacao_id( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
           FOR ls_mensagem IN lo_liberacao_id->executar( iv_id       = ls_monitor-id
                                                         iv_promocao = ls_monitor-promocao )
           ( %tky = VALUE #( id = ls_monitor-id
*           promocao = ls_monitor-promocao
           )
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

    ENDIF.
  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_sd_monitor_campanha IN LOCAL MODE
     ENTITY monitor
     FIELDS ( id promocao )
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_monitor)
     FAILED failed.

    result = VALUE #( FOR ls_monitor IN lt_monitor
   ( %tky-id = ls_monitor-id
     %features-%action-criarov = COND #(
     WHEN ls_monitor-id IS NOT INITIAL
     THEN if_abap_behv=>fc-o-enabled
     ELSE if_abap_behv=>fc-o-disabled )

     %features-%action-liberacaoid = COND #(
     WHEN ls_monitor-id IS NOT INITIAL
     THEN if_abap_behv=>fc-o-enabled
     ELSE if_abap_behv=>fc-o-disabled )

       ) ).

  ENDMETHOD.

  METHOD interfacezionz.

    CALL FUNCTION 'ZFMSD_INTERFACE_IONZ'
      STARTING NEW TASK 'INTER_IONZ'.

    APPEND VALUE #(
        %msg        =
          new_message(
            id       = gc_msg_id
            number   = gc_msg_nr
            severity = CONV #( gc_msgtpe_s ) )
    ) TO reported-monitor.

  ENDMETHOD.

  METHOD criarbp.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT gc_zcriarbp FOR USER sy-uname
      ID gc_actvt FIELD gc_01.    "Criar

    IF sy-subrc IS INITIAL.
      READ ENTITIES OF zi_sd_monitor_campanha IN LOCAL MODE
      ENTITY monitor
      FIELDS ( id promocao ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor).

      DATA(lo_bp) = NEW zclbp_criar_bp_app( ).

      reported-monitor = VALUE #(
               FOR ls_monitor  IN lt_monitor
               FOR ls_mensagem IN lo_bp->executar( iv_id       = ls_monitor-id
                                                   iv_promocao = ls_monitor-promocao )
           ( %tky         = VALUE #( id = ls_monitor-id
*           promocao = ls_monitor-promocao
           )
             %msg         =
               new_message(
                 id       = ls_mensagem-id
                 number   = ls_mensagem-number
                 severity = CONV #( ls_mensagem-type )
                 v1       = ls_mensagem-message_v1
                 v2       = ls_mensagem-message_v2
                 v3       = ls_mensagem-message_v3
                 v4       = ls_mensagem-message_v4 )
         ) ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
*
*CLASS lcl_zi_sd_monitor_campanha DEFINITION INHERITING FROM cl_abap_behavior_saver.
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
*CLASS lcl_zi_sd_monitor_campanha IMPLEMENTATION.
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
