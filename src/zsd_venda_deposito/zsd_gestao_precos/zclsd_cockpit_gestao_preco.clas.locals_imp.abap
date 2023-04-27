CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.

    METHODS determinarcriticalidade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR cockpit~determinarcriticalidade.

    METHODS validar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~validar.

    METHODS aprovar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~aprovar.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR cockpit RESULT result.

*    METHODS cancelRequest FOR DETERMINE ON SAVE
*      IMPORTING keys FOR cockpit~cancelRequest.

    METHODS reprovar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~reprovar.

    METHODS eliminar FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~eliminar.



*    METHODS determinarStatusRascunho FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR cockpit~determinarStatusRascunho.

*    CONSTANTS gc_status_finalizado TYPE ZE_PRECO_STATUS VALUE '04'.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE
        ENTITY cockpit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-plant ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_03' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0 AND
        <fs_data>-hiddenitm EQ abap_false AND
        <fs_data>-createdby NE sy-uname.
        lv_update = if_abap_behv=>auth-unauthorized.
      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_09' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0 AND
        <fs_data>-hiddenmin EQ abap_false AND
        <fs_data>-createdby NE sy-uname.
          lv_update = if_abap_behv=>auth-unauthorized.
      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_15' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0 AND
         <fs_data>-hiddeninv EQ abap_false AND
        <fs_data>-createdby NE sy-uname.
          lv_update = if_abap_behv=>auth-unauthorized.
      ENDIF.

*      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

*        IF zclsd_auth_zsdwerks=>werks_delete( <fs_data>-Plant ).
*          lv_delete = if_abap_behv=>auth-allowed.
*        ELSE.
*          lv_delete = if_abap_behv=>auth-unauthorized.
*        ENDIF.

*      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
*                      %delete = lv_delete
                      %assoc-_item    = lv_update
                      %assoc-_minimo  = lv_update
                      %assoc-_invasao = lv_update )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_cockpit IN lt_cockpit

                    ( %tky                      = ls_cockpit-%tky

                      %update                   = COND #( WHEN ls_cockpit-status EQ gc_status-reprovado OR ls_cockpit-status EQ gc_status-erro OR ls_cockpit-status EQ gc_status-alertaexp
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %delete                    = if_abap_behv=>fc-o-enabled
                      "%delete                   = COND #( WHEN ls_cockpit-Status NE gc_status-finalizado
                                                          "THEN if_abap_behv=>fc-o-enabled
                                                          "ELSE if_abap_behv=>fc-o-disabled )

                      %action-validar           = COND #( WHEN ls_cockpit-status EQ gc_status-pendente OR ls_cockpit-status EQ gc_status-alertaexp
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-aprovar           = COND #( WHEN ls_cockpit-status EQ gc_status-alerta OR ls_cockpit-status EQ gc_status-validado
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %assoc-_item              = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-item
                                                           AND ls_cockpit-status NE zclsd_gestao_preco_events=>gc_status-aprovado
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %assoc-_minimo             = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-minimum
                                                           AND ls_cockpit-status NE zclsd_gestao_preco_events=>gc_status-aprovado
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %assoc-_invasao            = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-invasion
                                                           AND ls_cockpit-status NE zclsd_gestao_preco_events=>gc_status-aprovado
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-reprovar           = COND #( WHEN ls_cockpit-status EQ gc_status-alerta OR ls_cockpit-status EQ gc_status-validado
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-eliminar           = COND #( WHEN ls_cockpit-status EQ gc_status-alerta OR ls_cockpit-status EQ gc_status-validado
                                                             OR ls_cockpit-status EQ gc_status-reprovado OR ls_cockpit-status EQ gc_status-erro
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                    ) ).


  ENDMETHOD.

  METHOD determinarcriticalidade.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

* ---------------------------------------------------------------------------
* Aplica validação dos campos
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).
    lo_events->gs_modify = abap_true.
    lo_events->validate_request( EXPORTING iv_level        = zclsd_gestao_preco_events=>gc_level-header
                                           is_header_cds   = CORRESPONDING #( ls_cockpit )
                                           it_item_cds     = CORRESPONDING #( lt_item )
                                           it_minimum_cds  = CORRESPONDING #( lt_minimo )
                                           it_invasion_cds = CORRESPONDING #( lt_invasao )
                                 IMPORTING es_header_cds   = DATA(ls_header_new)
                                           et_return       = DATA(lt_return) ).
    CLEAR lo_events->gs_modify.
    SORT lt_return BY row.
* ---------------------------------------------------------------------------
* Atualiza campos do relatório
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
         UPDATE FIELDS ( status
                         statuscriticality
*                         approveusercriticality
                         plantcriticality )
         WITH VALUE #( ( %key-guid              = ls_cockpit-guid
                         status                 = ls_header_new-status
                         statuscriticality      = ls_header_new-statuscriticality
*                         approveusercriticality = ls_header_new-approveusercriticality
                         plantcriticality       = ls_header_new-plantcriticality ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
    IF lt_return IS NOT INITIAL AND NOT line_exists( lt_return[ row = 0 ] ). "#EC CI_STDSEQ
      " Erros encontrados a nível de item.
      lt_return = VALUE #( BASE lt_return ( type = 'I' id = 'ZSD_GESTAO_PRECOS' number = '038' row = 0 ) ).
    ENDIF.

    reported-cockpit = VALUE #( FOR ls_return IN lt_return WHERE ( row = 0 ) (
                       %tky = ls_cockpit-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

  ENDMETHOD.


  METHOD validar.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    IF NOT lt_item IS INITIAL.

      "Verifica a Autorização do User - Validar - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_03' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_03' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0.
        IF NOT line_exists( lt_item[ createdby = sy-uname ] ).
          APPEND VALUE #(

                                   %msg       = new_message(
                                     id       = 'ZSD_GESTAO_PRECOS'
                                     number   = '071'
                                     severity = CONV #( 'E' ) ) ) TO reported-cockpit.
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

    IF NOT lt_minimo IS INITIAL.

      "Verifica a Autorização do User - Validar - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_09' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_09' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0.
        IF NOT line_exists( lt_minimo[ createdby = sy-uname ] ).
          APPEND VALUE #(

                                   %msg       = new_message(
                                     id       = 'ZSD_GESTAO_PRECOS'
                                     number   = '071'
                                     severity = CONV #( 'E' ) ) ) TO reported-cockpit.
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

    IF NOT lt_invasao IS INITIAL.

      "Verifica a Autorização do User - Validar - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_15' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.

      "Verifica a Autorização do User - Validar somente quem criou - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_15' FOR USER sy-uname
        ID 'ACTVT' FIELD 'F1'.
      IF sy-subrc NE 0.
        IF NOT line_exists( lt_invasao[ createdby = sy-uname ] ).
          APPEND VALUE #(

                                   %msg       = new_message(
                                     id       = 'ZSD_GESTAO_PRECOS'
                                     number   = '071'
                                     severity = CONV #( 'E' ) ) ) TO reported-cockpit.
          RETURN.
        ENDIF.
      ENDIF.

    ENDIF.

* ---------------------------------------------------------------------------
* Aplica validação dos campos
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

    lo_events->validate_request( EXPORTING iv_level        = space
                                           is_header_cds   = CORRESPONDING #( ls_cockpit )
                                           it_item_cds     = CORRESPONDING #( lt_item )
                                           it_minimum_cds  = CORRESPONDING #( lt_minimo )
                                           it_invasion_cds = CORRESPONDING #( lt_invasao )
                                 IMPORTING es_header_cds   = DATA(ls_header_new)
                                           et_item_cds     = DATA(lt_item_new)
                                           et_minimum_cds  = DATA(lt_minimo_new)
                                           et_invasion_cds = DATA(lt_invasao_new)
                                           et_return       = DATA(lt_return) ).

** ---------------------------------------------------------------------------
** Atualiza campos do relatório - Cabeçalho
** ---------------------------------------------------------------------------
*    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit
*         UPDATE FIELDS ( Status
*                         StatusCriticality
*                         ApproveUserCriticality
*                         PlantCriticality )
*         WITH VALUE #( ( %key-Guid              = ls_cockpit-Guid
*                         Status                 = ls_header_new-Status
*                         StatusCriticality      = ls_header_new-StatusCriticality
*                         ApproveUserCriticality = ls_header_new-ApproveUserCriticality
*                         PlantCriticality       = ls_header_new-PlantCriticality ) )
*         REPORTED DATA(lt_reported)
*         FAILED DATA(lt_failed).
    SORT lt_return  DESCENDING BY row . "id number.
    reported-cockpit = VALUE #( FOR ls_return IN lt_return WHERE ( row = 0 ) (
                       %tky = ls_cockpit-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

** ---------------------------------------------------------------------------
** Atualiza campos do relatório - Item
** ---------------------------------------------------------------------------

    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA

      READ TABLE lt_item_new INTO DATA(ls_item_new) WITH KEY guid     = ls_item-guid
                                                             guidline = ls_item-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-item = VALUE #( BASE reported-item FOR ls_return IN lt_return WHERE ( row = ls_item-line ) (
                      %tky = ls_item-%tky
                      %msg = new_message( id       = ls_return-id
                                          number   = ls_return-number
                                          v1       = ls_item-line
                                          v2       = ls_return-message_v2
                                          v3       = ls_return-message_v3
                                          v4       = ls_return-message_v4
                                          severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Alerta mínimo
* ---------------------------------------------------------------------------
    LOOP AT lt_minimo INTO DATA(ls_minimo).        "#EC CI_LOOP_INTO_WA

      READ TABLE lt_minimo_new INTO DATA(ls_minimo_new) WITH KEY guid     = ls_minimo-guid
                                                                 guidline = ls_minimo-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-minimo = VALUE #( BASE reported-minimo FOR ls_return IN lt_return WHERE ( row = ls_minimo-line ) (
                        %tky = ls_minimo-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Invasão
* ---------------------------------------------------------------------------
    LOOP AT lt_invasao INTO DATA(ls_invasao).      "#EC CI_LOOP_INTO_WA

      READ TABLE lt_invasao_new INTO DATA(ls_invasao_new) WITH KEY guid     = ls_invasao-guid
                                                                   guidline = ls_invasao-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      reported-invasao = VALUE #( BASE reported-invasao FOR ls_return IN lt_return WHERE ( row = ls_invasao-line ) (
                        %tky = ls_invasao-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

  ENDMETHOD.

  METHOD aprovar.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    IF NOT lt_item IS INITIAL.
      "Verifica a Autorização do User - Aprovar - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_04' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

    IF NOT lt_minimo IS INITIAL.
      "Verifica a Autorização do User - Aprovar - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_10' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

    IF NOT lt_invasao IS INITIAL.
      "Verifica a Autorização do User - Aprovar - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_16' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Aprovar solicitação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

    lo_events->approve_request( EXPORTING iv_level        = space
                                          is_header_cds   = CORRESPONDING #( ls_cockpit )
                                          it_item_cds     = CORRESPONDING #( lt_item )
                                          it_minimum_cds  = CORRESPONDING #( lt_minimo )
                                          it_invasion_cds = CORRESPONDING #( lt_invasao )
                                IMPORTING es_header_cds   = DATA(ls_header_new)
                                          et_item_cds     = DATA(lt_item_new)
                                          et_minimum_cds  = DATA(lt_minimo_new)
                                          et_invasion_cds = DATA(lt_invasao_new)
                                          et_return       = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Cabeçalho
* ---------------------------------------------------------------------------
    SORT lt_return ASCENDING BY row .
    reported-cockpit = VALUE #( FOR ls_return IN lt_return WHERE ( row = 0 ) (
                       %tky = ls_cockpit-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Item
* ---------------------------------------------------------------------------
    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA

      READ TABLE lt_item_new INTO DATA(ls_item_new) WITH KEY guid     = ls_item-guid
                                                             guidline = ls_item-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-item = VALUE #( BASE reported-item FOR ls_return IN lt_return WHERE ( row = ls_item-line ) (
                       %tky = ls_item-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Alerta mínimo
* ---------------------------------------------------------------------------
    LOOP AT lt_minimo INTO DATA(ls_minimo).        "#EC CI_LOOP_INTO_WA

      READ TABLE lt_minimo_new INTO DATA(ls_minimo_new) WITH KEY guid     = ls_minimo-guid
                                                                 guidline = ls_minimo-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-minimo = VALUE #( BASE reported-minimo FOR ls_return IN lt_return WHERE ( row = ls_minimo-line ) (
                        %tky = ls_minimo-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Invasão
* ---------------------------------------------------------------------------
    LOOP AT lt_invasao INTO DATA(ls_invasao).      "#EC CI_LOOP_INTO_WA

      READ TABLE lt_invasao_new INTO DATA(ls_invasao_new) WITH KEY guid     = ls_invasao-guid
                                                                   guidline = ls_invasao-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      reported-invasao = VALUE #( BASE reported-invasao FOR ls_return IN lt_return WHERE ( row = ls_invasao-line ) (
                        %tky = ls_invasao-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

  ENDMETHOD.

*  METHOD cancelRequest.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------

*    SELECT *
*    FROM ZTSD_PRECO_H
*    FOR ALL ENTRIES IN @keys
*    WHERE guid = @keys-Guid
*    AND status = @gc_status_finalizado
*    INTO TABLE @DATA(lt_cockpit).

*    TRY.
*        IF lt_cockpit[] IS NOT INITIAL.
*            DATA(ls_cockpit) = lt_cockpit[ 1 ].
*        ENDIF.

*      CATCH cx_root.
*    ENDTRY.

*    SELECT *
*    FROM ZTSD_PRECO_I
*    FOR ALL ENTRIES IN @keys
*    WHERE guid = @keys-Guid
*    AND status = @gc_status_finalizado
*    INTO TABLE @DATA(lt_item).

*    SELECT *
*    FROM ZTSD_PRECO_M
*    FOR ALL ENTRIES IN @keys
*    WHERE guid = @keys-Guid
*    AND status = @gc_status_finalizado
*    INTO TABLE @DATA(lt_minimo).

*    SELECT *
*    FROM ZTSD_PRECO_INV
*    FOR ALL ENTRIES IN @keys
*    WHERE guid = @keys-Guid
*    AND status = @gc_status_finalizado
*    INTO TABLE @DATA(lt_invasao).

* ---------------------------------------------------------------------------
* Cancela/Exclui o registro da VK11
* ---------------------------------------------------------------------------

*    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

*    IF
*        ls_cockpit IS NOT INITIAL AND
*        (
*            lt_item[] IS NOT INITIAL OR
*            lt_minimo[] IS NOT INITIAL OR
*            lt_invasao[] IS NOT INITIAL
*        ).

*        lo_events->cancel_request( EXPORTING  is_header   = ls_cockpit
*                                              it_item     = lt_item
*                                              it_minimum  = lt_minimo
*                                              it_invasion = lt_invasao
*                                    IMPORTING et_return   = DATA(lt_return) ).
* ---------------------------------------------------------------------------
* Em caso de erro ou sucesso poderá utilizar a lt_return para exibir a mensagem. Porém o consultor (Sandro) solicitou para não exibir!
* ---------------------------------------------------------------------------

*    ENDIF.


*  ENDMETHOD.

  METHOD reprovar.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    IF NOT lt_item IS INITIAL.
      "Verifica a Autorização do User - Reprovar - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_05' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

    IF NOT lt_minimo IS INITIAL.
      "Verifica a Autorização do User - Reprovar - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_11' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

    IF NOT lt_invasao IS INITIAL.
      "Verifica a Autorização do User - Reprovar - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_17' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Reprovar solicitação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

    lo_events->status_request( EXPORTING  iv_status       = zclsd_gestao_preco_events=>gc_status-reprovado
                                          is_header_cds   = CORRESPONDING #( ls_cockpit )
                                          it_item_cds     = CORRESPONDING #( lt_item )
                                          it_minimum_cds  = CORRESPONDING #( lt_minimo )
                                          it_invasion_cds = CORRESPONDING #( lt_invasao )
                                          iv_level        = space
                                IMPORTING es_header_cds   = DATA(ls_header_new)
                                          et_item_cds     = DATA(lt_item_new)
                                          et_minimum_cds  = DATA(lt_minimo_new)
                                          et_invasion_cds = DATA(lt_invasao_new)
                                          et_return       = DATA(lt_return) ).
    SORT lt_return  DESCENDING BY row .
* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Cabeçalho
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
         UPDATE FIELDS ( status
                         statuscriticality )
         WITH VALUE #( ( %key-guid              = ls_cockpit-guid
                         status                 = ls_header_new-status
                         statuscriticality      = ls_header_new-statuscriticality ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

    reported-cockpit = VALUE #( FOR ls_return IN lt_return WHERE ( row = 0 ) (
                       %tky = ls_cockpit-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Item
* ---------------------------------------------------------------------------
    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA

      READ TABLE lt_item_new INTO DATA(ls_item_new) WITH KEY guid     = ls_item-guid
                                                             guidline = ls_item-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-item = VALUE #( BASE reported-item FOR ls_return IN lt_return WHERE ( row = ls_item-line ) (
                       %tky = ls_item-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Alerta mínimo
* ---------------------------------------------------------------------------
    LOOP AT lt_minimo INTO DATA(ls_minimo).        "#EC CI_LOOP_INTO_WA

      READ TABLE lt_minimo_new INTO DATA(ls_minimo_new) WITH KEY guid     = ls_minimo-guid
                                                                 guidline = ls_minimo-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-minimo = VALUE #( BASE reported-minimo FOR ls_return IN lt_return WHERE ( row = ls_minimo-line ) (
                        %tky = ls_minimo-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Invasão
* ---------------------------------------------------------------------------
    LOOP AT lt_invasao INTO DATA(ls_invasao).      "#EC CI_LOOP_INTO_WA

      READ TABLE lt_invasao_new INTO DATA(ls_invasao_new) WITH KEY guid     = ls_invasao-guid
                                                                   guidline = ls_invasao-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      reported-invasao = VALUE #( BASE reported-invasao FOR ls_return IN lt_return WHERE ( row = ls_invasao-line ) (
                        %tky = ls_invasao-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

  ENDMETHOD.

  METHOD eliminar.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    IF NOT lt_item IS INITIAL.
      "Verifica a Autorização do User - Eliminar - Preço
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_06' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

    IF NOT lt_minimo IS INITIAL.
      "Verifica a Autorização do User - Eliminar - Alerta mínimo
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_12' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

    IF NOT lt_invasao IS INITIAL.
      "Verifica a Autorização do User - Eliminar - Invasão
      AUTHORITY-CHECK OBJECT 'ZSD_CGP_18' FOR USER sy-uname
        ID 'ACTVT' FIELD '01'.
      IF sy-subrc NE 0.
        APPEND VALUE #(

                                 %msg       = new_message(
                                   id       = 'ZSD_GESTAO_PRECOS'
                                   number   = '071'
                                   severity = CONV #( 'E' ) ) ) TO reported-cockpit.
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Eliminar solicitação
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

    lo_events->status_request( EXPORTING  iv_status       = zclsd_gestao_preco_events=>gc_status-eliminado
                                          is_header_cds   = CORRESPONDING #( ls_cockpit )
                                          it_item_cds     = CORRESPONDING #( lt_item )
                                          it_minimum_cds  = CORRESPONDING #( lt_minimo )
                                          it_invasion_cds = CORRESPONDING #( lt_invasao )
                                          iv_level        = space
                                IMPORTING es_header_cds   = DATA(ls_header_new)
                                          et_item_cds     = DATA(lt_item_new)
                                          et_minimum_cds  = DATA(lt_minimo_new)
                                          et_invasion_cds = DATA(lt_invasao_new)
                                          et_return       = DATA(lt_return) ).
    SORT lt_return  DESCENDING BY row .
* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Cabeçalho
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
         UPDATE FIELDS ( status
                         statuscriticality )
         WITH VALUE #( ( %key-guid              = ls_cockpit-guid
                         status                 = ls_header_new-status
                         statuscriticality      = ls_header_new-statuscriticality ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

    reported-cockpit = VALUE #( FOR ls_return IN lt_return WHERE ( row = 0 ) (
                       %tky = ls_cockpit-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Item
* ---------------------------------------------------------------------------
    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA

      READ TABLE lt_item_new INTO DATA(ls_item_new) WITH KEY guid     = ls_item-guid
                                                             guidline = ls_item-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-item = VALUE #( BASE reported-item FOR ls_return IN lt_return WHERE ( row = ls_item-line ) (
                       %tky = ls_item-%tky
                       %msg = new_message( id       = ls_return-id
                                           number   = ls_return-number
                                           v1       = ls_return-message_v1
                                           v2       = ls_return-message_v2
                                           v3       = ls_return-message_v3
                                           v4       = ls_return-message_v4
                                           severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Alerta mínimo
* ---------------------------------------------------------------------------
    LOOP AT lt_minimo INTO DATA(ls_minimo).        "#EC CI_LOOP_INTO_WA

      READ TABLE lt_minimo_new INTO DATA(ls_minimo_new) WITH KEY guid     = ls_minimo-guid
                                                                 guidline = ls_minimo-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      reported-minimo = VALUE #( BASE reported-minimo FOR ls_return IN lt_return WHERE ( row = ls_minimo-line ) (
                        %tky = ls_minimo-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Invasão
* ---------------------------------------------------------------------------
    LOOP AT lt_invasao INTO DATA(ls_invasao).      "#EC CI_LOOP_INTO_WA

      READ TABLE lt_invasao_new INTO DATA(ls_invasao_new) WITH KEY guid     = ls_invasao-guid
                                                                   guidline = ls_invasao-guidline. "#EC CI_STDSEQ

      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      reported-invasao = VALUE #( BASE reported-invasao FOR ls_return IN lt_return WHERE ( row = ls_invasao-line ) (
                        %tky = ls_invasao-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ

    ENDLOOP.

  ENDMETHOD.

*  METHOD determinarStatusRascunho.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_cockpit).
*
*    TRY.
*        DATA(ls_cockpit) = lt_cockpit[ 1 ].
*      CATCH cx_root.
*    ENDTRY.
*
** ---------------------------------------------------------------------------
** Atualiza campos do relatório
** ---------------------------------------------------------------------------
*    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit
*         UPDATE FIELDS ( Status )
*         WITH VALUE #( ( %key-Guid              = ls_cockpit-Guid
*                         Status                 = zclsd_gestao_preco_events=>gc_status-em_aberto ) )
*         REPORTED DATA(lt_reported)
*         FAILED DATA(lt_failed).
*
*  ENDMETHOD.
*


ENDCLASS.
