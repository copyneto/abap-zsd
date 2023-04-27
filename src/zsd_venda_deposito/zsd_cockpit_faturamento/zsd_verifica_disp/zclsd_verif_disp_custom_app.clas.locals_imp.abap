CLASS lcl_verifdisp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK _verifdisp.

    METHODS read FOR READ
      IMPORTING keys FOR READ _verifdisp RESULT result.

    METHODS acionalogistica FOR MODIFY
      IMPORTING keys FOR ACTION _verifdisp~acionalogistica.

    METHODS atribuimoticoacao FOR MODIFY
      IMPORTING keys FOR ACTION _verifdisp~atribuimoticoacao.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _verifdisp RESULT result.

ENDCLASS.

CLASS lcl_verifdisp IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    DATA lt_result TYPE TABLE FOR READ RESULT zc_sd_verif_disp_custom_app\\_verifdisp.

    DATA(lo_select) = NEW zclsd_verif_disp_custom(  ).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      APPEND VALUE #( sign = 'I'
                      option = 'EQ'
                      low = <fs_keys>-material ) TO lo_select->gs_filtros-material. "#EC CI_STDSEQ

      APPEND VALUE #( sign = 'I'
                       option = 'EQ'
                       low = <fs_keys>-plant ) TO lo_select->gs_filtros-plant.

      APPEND VALUE #( sign = 'I'
                       option = 'EQ'
                       low = <fs_keys>-deposito ) TO lo_select->gs_filtros-deposito.

    ENDLOOP.

    lo_select->build( IMPORTING et_verif_disp = DATA(lt_verif_disp)  ).

    lt_result = CORRESPONDING #( lt_verif_disp ).

    result = CORRESPONDING #( lt_result ).

  ENDMETHOD.

  METHOD acionalogistica.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZACION_LOG' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS  INITIAL.

      READ ENTITIES OF zc_sd_verif_disp_custom_app IN LOCAL MODE
      ENTITY _verifdisp
        FIELDS ( material plant deposito ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifdisp)
      FAILED failed.

      DATA(lo_actions) = NEW zclsd_verif_disp_actions( ).
      reported-_verifdisp = VALUE #( FOR ls_verifdisp IN lt_verifdisp
        FOR ls_mensagem IN lo_actions->acionar_logistica(  EXPORTING:
                                                                      iv_material  = ls_verifdisp-material
                                                                      iv_centro    = ls_verifdisp-plant
                                                                      iv_deposito  = ls_verifdisp-deposito
                                                                      iv_status    = ls_verifdisp-status )
        ( %tky = ls_verifdisp-%tky
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


    ELSE.

      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #( 'E' ) ) ) TO reported-_verifdisp.

    ENDIF.

  ENDMETHOD.

  METHOD atribuimoticoacao.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZATRIB_MOT' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zc_sd_verif_disp_custom_app IN LOCAL MODE
      ENTITY _verifdisp
        FIELDS ( material plant deposito ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt__verifdisp)
      FAILED failed.

      DATA(lo_actions) = NEW zclsd_verif_disp_actions( ).

      reported-_verifdisp = VALUE #( FOR ls_key IN keys
        FOR ls_mensagem IN lo_actions->atribuir_motivo(  EXPORTING: iv_material = ls_key-material
                                                                    iv_centro =  ls_key-plant
                                                                    iv_motivo =  ls_key-%param-motivo
                                                                    iv_acao =  ls_key-%param-acao )
        ( %tky = ls_key-%tky
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


    ELSE.

      APPEND VALUE #(  %msg     = new_message(
                       id       = 'ZSD_CKPT_FATURAMENTO'
                       number   = '001'
                       severity = CONV #( 'E' ) ) ) TO reported-_verifdisp.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    IF keys IS NOT INITIAL.

      SELECT material, plant, deposito, acaologistica
      FROM zi_sd_verif_disp_app
      FOR ALL ENTRIES IN @keys
      WHERE material = @keys-material
      AND plant = @keys-plant
      AND deposito = @keys-deposito
          INTO TABLE @DATA(lt_verifdisp).

      result  = VALUE #( FOR ls_verifdisp IN lt_verifdisp
        ( %key-material  = ls_verifdisp-material
          %key-plant     = ls_verifdisp-plant
          %key-deposito  = ls_verifdisp-deposito

          %features-%action-atribuimoticoacao = COND #(
          WHEN ls_verifdisp-acaologistica = 'X'
          THEN if_abap_behv=>fc-o-enabled
          ELSE if_abap_behv=>fc-o-disabled )


          %features-%action-acionalogistica =  if_abap_behv=>fc-o-enabled

     ) ).
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_sd_verif_disp_custom_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_sd_verif_disp_custom_app IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
