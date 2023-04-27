CLASS lcl_monitorapp DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK monitor.

    METHODS read FOR READ
      IMPORTING keys FOR READ monitor RESULT result.

    METHODS saidamercadoria FOR MODIFY
      IMPORTING keys FOR ACTION monitor~saidamercadoria.

    METHODS gerarfaturamento FOR MODIFY
      IMPORTING keys FOR ACTION monitor~gerarfaturamento.

    METHODS gerarordemfrete FOR MODIFY
      IMPORTING keys FOR ACTION monitor~gerarordemfrete.

    METHODS imprimirnfe FOR MODIFY
      IMPORTING keys FOR ACTION monitor~imprimirnfe.

    METHODS desbloquearordem FOR MODIFY
      IMPORTING keys FOR ACTION monitor~desbloquearordem.

*    METHODS get_features FOR FEATURES
*      IMPORTING keys REQUEST requested_features FOR monitor RESULT result.

    METHODS feature_ctrl_method FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR monitor RESULT result.

ENDCLASS.

CLASS lcl_monitorapp IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.
    CHECK keys IS NOT INITIAL.
    SELECT * FROM zi_sd_monitor_app
    FOR ALL ENTRIES IN @keys
    WHERE salesorder = @keys-salesorder
*    AND SalesOrderItem = @Keys-SalesOrderItem
    AND Remessa = @keys-Remessa
    AND Fatura = @keys-Fatura
    AND NfeNum = @keys-NfeNum
    INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD saidamercadoria.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZMONECOMM' FOR USER sy-uname
      ID 'ACTVT' FIELD 'F1'.    "Autorizar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
        FIELDS ( salesorder remessa ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

      DATA(lo_saida_mercadoria) = NEW zclsd_saida_mercadoria( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN lo_saida_mercadoria->executar( iv_delivery = ls_monitor-remessa )
        ( %tky = VALUE #( salesorder = ls_monitor-salesorder
*                          SalesOrderItem = ls_monitor-salesorderitem
                          Remessa  = ls_monitor-Remessa
                          Fatura  = ls_monitor-Fatura
                          NfeNum  = ls_monitor-nfenum )
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

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_MONITOR_ECOMM'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-monitor.

    ENDIF.

  ENDMETHOD.

  METHOD gerarfaturamento.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'Z_ECOM_FAT' FOR USER sy-uname
      ID 'ACTVT' FIELD 'F1'.    "Autorizar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
        FIELDS ( salesorder  remessa ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

      DATA(lo_gera_faturamento) = NEW zclsd_gera_faturamento( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN lo_gera_faturamento->executar( iv_ref_doc = ls_monitor-remessa )
        ( %tky = VALUE #( salesorder = ls_monitor-salesorder
*                          SalesOrderItem = ls_monitor-salesorderitem
                          Remessa  = ls_monitor-Remessa
                          Fatura  = ls_monitor-Fatura
                          NfeNum  = ls_monitor-nfenum )
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

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_MONITOR_ECOMM'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-monitor.

    ENDIF.

  ENDMETHOD.

  METHOD gerarordemfrete.

    "Verificando a Autorização do User
    AUTHORITY-CHECK OBJECT 'Z_ECOM_OF' FOR USER sy-uname
      ID 'ACTVT' FIELD 'F1'.    "Autorizar

    IF sy-subrc IS INITIAL.
      READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
        FIELDS ( UnidadeFrete Remessa ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN NEW zclsd_monitor_gerar_ordemfrete( )->executar( iv_remessa = ls_monitor-remessa iv_unidade_frete = ls_monitor-unidadefrete )

        ( %tky = VALUE #( salesorder = ls_monitor-salesorder
*                          salesorderitem = ls_monitor-salesorderitem
                          Remessa  = ls_monitor-Remessa
                          Fatura  = ls_monitor-Fatura
                          NfeNum  = ls_monitor-nfenum )

          %msg = new_message(
                   id       = ls_mensagem-msgid
                   number   = ls_mensagem-msgno
                   severity = CONV #( lS_mensagem-msgty     )
                   v1       = ls_mensagem-msgv1
                   v2       = ls_mensagem-msgv2
                   v3       = ls_mensagem-msgv3
                   v4       = ls_mensagem-msgv4
                 )
        )
      ).                                                "#EC CI_CONV_OK
    ELSE.
      APPEND VALUE #(
        %msg = new_message(
         id       = 'ZSD_MONITOR_ECOMM'
         number   = '001'
         severity = CONV #( 'E' )
        )
      ) TO reported-monitor.
    ENDIF.

  ENDMETHOD.

  METHOD imprimirnfe.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'Z_ECOM_NF' FOR USER sy-uname
      ID 'ACTVT' FIELD 'F1'.    "Autorizar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
        FIELDS ( salesorder remessa ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

      DATA(lo_imprimir_nfe) = NEW zclsd_imprimir_nfe( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN lo_imprimir_nfe->executar( iv_docnum = ls_monitor-NFDocnum )
        ( %tky = VALUE #( salesorder = ls_monitor-salesorder
*                          salesorderitem = ls_monitor-salesorderitem
                          Remessa  = ls_monitor-Remessa
                          Fatura  = ls_monitor-Fatura
                          NfeNum  = ls_monitor-nfenum )
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

      APPEND VALUE #(

                               %msg       = new_message(
                                 id       = 'ZSD_MONITOR_ECOMM'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-monitor.

    ENDIF.

  ENDMETHOD.

  METHOD desbloquearordem.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'Z_ECOM_OV' FOR USER sy-uname
      ID 'ACTVT' FIELD 'F1'.    "Autorizar

    IF sy-subrc IS INITIAL.

      READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
        FIELDS ( salesorder remessa ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

      DATA(lo_desbloquea_ordem) = NEW zclsd_desbloquea_ordem( ).
      reported-monitor = VALUE #( FOR ls_monitor IN lt_monitor
        FOR ls_mensagem IN lo_desbloquea_ordem->executar( iv_ordem = ls_monitor-salesorder )
        ( %tky = VALUE #( salesorder = ls_monitor-salesorder
*                          salesorderitem = ls_monitor-salesorderitem
                          Remessa  = ls_monitor-Remessa
                          Fatura  = ls_monitor-Fatura
                          NfeNum  = ls_monitor-nfenum )
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

      APPEND VALUE #(
       %msg       = new_message(
         id       = 'ZSD_MONITOR_ECOMM'
         number   = '001'
         severity = CONV #( 'E' ) ) ) TO reported-monitor.

    ENDIF.

  ENDMETHOD.

  METHOD feature_ctrl_method.

    READ ENTITIES OF zi_sd_monitor_app IN LOCAL MODE
      ENTITY monitor
      FIELDS ( salesorder remessa nfenum UnidadeFrete OrdemFrete )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

    result = VALUE #( FOR ls_monitor IN lt_monitor
      ( %tky-salesorder = ls_monitor-salesorder
*        %tky-salesorderitem = ls_monitor-salesorderitem
                          %tky-Remessa  = ls_monitor-Remessa
                          %tky-Fatura  = ls_monitor-Fatura
                          %tky-NfeNum  = ls_monitor-nfenum

      %features-%action-saidamercadoria = COND #(
        WHEN ls_monitor-remessa IS NOT INITIAL
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %features-%action-gerarfaturamento = COND #(
        WHEN ls_monitor-remessa IS NOT INITIAL
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %features-%action-gerarOrdemFrete = COND #(
        WHEN ls_monitor-Remessa IS NOT INITIAL AND ls_monitor-OrdemFrete IS INITIAL
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %features-%action-imprimirnfe = COND #(
        WHEN ls_monitor-nfenum IS NOT INITIAL
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

      %features-%action-desbloquearordem = COND #(
        WHEN ls_monitor-salesorder IS NOT INITIAL
        THEN if_abap_behv=>fc-o-enabled
        ELSE if_abap_behv=>fc-o-disabled )

    ) ).

  ENDMETHOD.

ENDCLASS.

*CLASS lcl_zi_sd_monitor_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
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
*CLASS lcl_zi_sd_monitor_app IMPLEMENTATION.
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
