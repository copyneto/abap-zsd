CLASS lcl_verifdisp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK verifdisp.

    METHODS read FOR READ
      IMPORTING keys FOR READ verifdisp RESULT result.

*    METHODS verificadisponibilidade FOR MODIFY
*      IMPORTING keys FOR ACTION verifdisp~verificadisponibilidade.

    METHODS acionalogistica FOR MODIFY
      IMPORTING keys FOR ACTION verifdisp~acionalogistica.

    METHODS atribuimoticoacao FOR MODIFY
      IMPORTING keys FOR ACTION verifdisp~atribuimoticoacao.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR verifdisp RESULT result.

ENDCLASS.

CLASS lcl_verifdisp IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

    IF keys IS NOT INITIAL.

      TRY.
          SELECT * FROM zi_sd_verif_disp_app
          FOR ALL ENTRIES IN @keys
          WHERE material = @keys-material
            AND plant    = @keys-plant
            AND deposito = @keys-deposito
*      AND SalesOrder = @keys-SalesOrder
          INTO CORRESPONDING FIELDS OF TABLE @result.
        CATCH cx_root.
      ENDTRY.
    ENDIF.
  ENDMETHOD.

*  METHOD verificadisponibilidade.
*    RETURN.
*  ENDMETHOD.

  METHOD acionalogistica.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZACION_LOG' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS  INITIAL.

      READ ENTITIES OF zi_sd_verif_disp_app IN LOCAL MODE
      ENTITY verifdisp
*        FIELDS ( Material Plant SalesOrder ) WITH CORRESPONDING #( keys )
        FIELDS ( material plant deposito ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifdisp)
      FAILED failed.

      DATA(lo_actions) = NEW zclsd_verif_disp_actions( ).
      reported-verifdisp = VALUE #( FOR ls_verifdisp IN lt_verifdisp
        FOR ls_mensagem IN lo_actions->acionar_logistica(  EXPORTING:
                                                                      iv_material  =  ls_verifdisp-material
                                                                      iv_centro    =  ls_verifdisp-plant
                                                                      iv_deposito  =  ls_verifdisp-deposito
                                                                      iv_status    =  ls_verifdisp-status  )
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
                       severity = CONV #( 'E' ) ) ) TO reported-verifdisp.

    ENDIF.

  ENDMETHOD.

  METHOD atribuimoticoacao.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZATRIB_MOT' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_verif_disp_app IN LOCAL MODE
      ENTITY verifdisp
*        FIELDS ( Material Plant SalesOrder ) WITH CORRESPONDING #( keys )
        FIELDS ( material plant deposito ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_verifdisp)
      FAILED failed.

      DATA(lo_actions) = NEW zclsd_verif_disp_actions( ).
*        reported-verifdisp = VALUE #( FOR ls_VerifDisp IN lt_VerifDisp
*          FOR ls_mensagem IN lo_actions->ATRIBUIR_MOTIVO(  EXPORTING: iv_material = ls_VerifDisp-Material
*                                                                      iv_centro =  ls_VerifDisp-Plant
*                                                                      iv_motivo =  ls_VerifDisp-motivoIndisp
*                                                                      iv_acao =  ls_VerifDisp-acaoNecessaria
*                                                                      iv_data_solic =  ls_VerifDisp-DataSolic )
      reported-verifdisp = VALUE #( FOR ls_key IN keys
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
                       severity = CONV #( 'E' ) ) ) TO reported-verifdisp.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.


    SELECT
      _mard~matnr,
      _mard~werks,
      _mard~lgort,
      _soliclog~acaolog,
      _soliclog~data_solic
      FROM mard AS _mard
      INNER JOIN @keys AS _keys
      ON  _keys~material = _mard~matnr
      AND _keys~plant    = _mard~werks
      AND _keys~deposito = _mard~lgort
      LEFT OUTER JOIN zi_sd_tf_verif_disp AS _soliclog
      ON  _soliclog~material = _mard~matnr
      AND _soliclog~centro   = _mard~werks
    WHERE
      _mard~lgort IS NOT NULL
      GROUP BY
      _mard~matnr,
      _mard~werks,
      _mard~lgort,
      _soliclog~acaolog,
      _soliclog~data_solic
    INTO TABLE @DATA(lt_verifdisp).

*    READ ENTITIES OF zi_sd_verif_disp_app IN LOCAL MODE
*        ENTITY verifdisp
**        FIELDS ( Material Plant SalesOrder )
*        FIELDS ( Material Plant Deposito  )
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_verifdisp)
*        FAILED failed.


    result = VALUE #( FOR ls_verifdisp IN lt_verifdisp
*      ( %tky = ls_verifdisp-%tky
      ( %tky = VALUE #(
          material = ls_verifdisp-matnr
          plant = ls_verifdisp-werks
          deposito = ls_verifdisp-lgort
      )
*        %features-%action-AcionaLogistica = COND #(
*        WHEN ls_verifdisp-Status = 'Indisponível'
*        THEN if_abap_behv=>fc-o-enabled
*        ELSE if_abap_behv=>fc-o-disabled )
*
      %features-%action-atribuimoticoacao = COND #(
*        WHEN ls_verifdisp-acaologistica = 'X'
        WHEN ls_verifdisp-acaolog = 'X' AND ls_verifdisp-data_solic = sy-datum
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

   ) ).


  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_verif_disp_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_verif_disp_app IMPLEMENTATION.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD finalize.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

ENDCLASS.
