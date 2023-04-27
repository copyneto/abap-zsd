CLASS lcl_minimo DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR minimo RESULT result.

    METHODS determinarcriticalidade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR minimo~determinarcriticalidade.

*    METHODS determinarStatusRascunho FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR Minimo~determinarStatusRascunho.

ENDCLASS.

CLASS lcl_minimo IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit)
        FAILED failed.

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys

                    ( %tky                      = ls_keys-%tky

                      %update                   = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-minimum
                                                           AND ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-reprovado
                                                            OR ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-erro
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %delete                   = COND #( WHEN ls_cockpit-PresentationType EQ zclsd_gestao_preco_events=>gc_presentation_type-minimum
*                                                           AND ls_cockpit-Status NE zclsd_gestao_preco_events=>gc_status-finalizado
*                                                          THEN if_abap_behv=>fc-o-enabled
*                                                          ELSE if_abap_behv=>fc-o-disabled )

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

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_minimo).

* ---------------------------------------------------------------------------
* Aplica validação dos campos
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).
    lo_events->gs_modify = abap_true.
    lo_events->validate_request( EXPORTING iv_level       = zclsd_gestao_preco_events=>gc_level-minimum
                                           is_header_cds  = CORRESPONDING #( ls_cockpit )
                                           it_minimum_cds = CORRESPONDING #( lt_minimo )
                                 IMPORTING es_header_cds  = DATA(ls_cockpit_new)
                                           et_minimum_cds = DATA(lt_minimo_new)
                                           et_return      = DATA(lt_return) ).
    CLEAR lo_events->gs_modify.
* ---------------------------------------------------------------------------
* Atualiza campos do relatório
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit
         UPDATE FIELDS ( status
                         statuscriticality
*                         ApproveUserCriticality
                         plantcriticality )
         WITH VALUE #( ( %key-guid              = ls_cockpit-guid
                         status                 = ls_cockpit_new-status
                         statuscriticality      = ls_cockpit_new-statuscriticality
*                         ApproveUserCriticality = ls_cockpit_new-ApproveUserCriticality
                         plantcriticality       = ls_cockpit_new-plantcriticality ) )
         REPORTED DATA(lt_reported)
         FAILED DATA(lt_failed).

* ---------------------------------------------------------------------------
* Atualiza campos do relatório - Mínimo
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY minimo
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_minimo.

    LOOP AT lt_minimo_new INTO DATA(ls_minimo_new). "#EC CI_LOOP_INTO_WA


      MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY minimo
           UPDATE FIELDS ( line
                           linecriticality
                           status
                           statuscriticality
                           operationtype
                           operationtypecriticality
                           materialcriticality
                           minvaluecriticality
                           currencycriticality
                           datefromcriticality
                           conditionrecord )
           WITH VALUE #( ( %key-guid                = ls_minimo_new-guid
                           %key-guidline            = ls_minimo_new-guidline
                           line                     = ls_minimo_new-line
                           linecriticality          = ls_minimo_new-linecriticality
                           status                   = ls_minimo_new-status
                           statuscriticality        = ls_minimo_new-statuscriticality
                           operationtype            = ls_minimo_new-operationtype
                           operationtypecriticality = ls_minimo_new-operationtypecriticality
                           materialcriticality      = ls_minimo_new-materialcriticality
                           minvaluecriticality      = ls_minimo_new-minvaluecriticality
                           currencycriticality      = ls_minimo_new-currencycriticality
                           datefromcriticality      = ls_minimo_new-datefromcriticality
                           conditionrecord          = ls_minimo_new-conditionrecord ) )
           REPORTED DATA(lt_reported_min)
           FAILED DATA(lt_failed_min).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      READ TABLE lt_minimo INTO DATA(ls_minimo) WITH KEY guid     = ls_minimo_new-guid
                                                         guidline = ls_minimo_new-guidline. "#EC CI_STDSEQ

      IF sy-subrc EQ 0.

        reported-minimo = VALUE #( BASE reported-minimo FOR ls_return IN lt_return WHERE ( row = ls_minimo-line ) (
                          %tky = ls_minimo-%tky
                          %msg = new_message( id       = ls_return-id
                                              number   = ls_return-number
                                              v1       = ls_return-message_v1
                                              v2       = ls_return-message_v2
                                              v3       = ls_return-message_v3
                                              v4       = ls_return-message_v4
                                              severity = CONV #( ls_return-type ) ) ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

*  METHOD determinarStatusRascunho.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_cockpit).
*
*    TRY.
*        DATA(ls_cockpit) = lt_cockpit[ 1 ].
*      CATCH cx_root.
*    ENDTRY.
*
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit BY \_Minimo
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_minimo).
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
** ---------------------------------------------------------------------------
** Atualiza campos do relatório - Mínimo
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Minimo
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT lt_minimo.
*
*    LOOP AT lt_minimo INTO DATA(ls_minimo). "#EC CI_LOOP_INTO_WA
*
*      MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Minimo
*           UPDATE FIELDS ( Status )
*           WITH VALUE #( ( %key-Guid                = ls_minimo-Guid
*                           %key-GuidLine            = ls_minimo-GuidLine
*                           Status                   = zclsd_gestao_preco_events=>gc_status-em_aberto ) )
*           REPORTED DATA(lt_reported_min)
*           FAILED DATA(lt_failed_min).
*
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.
