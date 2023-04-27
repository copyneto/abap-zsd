CLASS lcl_invasao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR invasao RESULT result.

    METHODS determinarcriticalidade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR invasao~determinarcriticalidade.

ENDCLASS.

CLASS lcl_invasao IMPLEMENTATION.

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

                      %update                   = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-invasion
                                                           AND ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-reprovado
                                                           OR ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-erro
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %delete                   = COND #( WHEN ls_cockpit-PresentationType EQ zclsd_gestao_preco_events=>gc_presentation_type-invasion
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

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_invasao).

* ---------------------------------------------------------------------------
* Aplica validação dos campos
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).
    lo_events->gs_modify = abap_true.
    lo_events->validate_request( EXPORTING iv_level        = zclsd_gestao_preco_events=>gc_level-invasion
                                           is_header_cds   = CORRESPONDING #( ls_cockpit )
                                           it_invasion_cds = CORRESPONDING #( lt_invasao )
                                 IMPORTING es_header_cds   = DATA(ls_cockpit_new)
                                           et_invasion_cds = DATA(lt_invasao_new)
                                           et_return       = DATA(lt_return) ).
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
* Atualiza campos do relatório - Invasão
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY invasao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_invasao.

    LOOP AT lt_invasao_new INTO DATA(ls_invasao_new). "#EC CI_LOOP_INTO_WA


      MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY invasao
           UPDATE FIELDS ( line
                           linecriticality
                           status
                           statuscriticality
                           operationtype
                           operationtypecriticality
                           "PriceListCriticality
                           minvaluecriticality
                           currencycriticality
                           datefromcriticality
                           datetocriticality
                           conditionrecord
                           KunnrCriticality )
           WITH VALUE #( ( %key-guid                = ls_invasao_new-guid
                           %key-guidline            = ls_invasao_new-guidline
                           line                     = ls_invasao_new-line
                           linecriticality          = ls_invasao_new-linecriticality
                           status                   = ls_invasao_new-status
                           statuscriticality        = ls_invasao_new-statuscriticality
                           operationtype            = ls_invasao_new-operationtype
                           operationtypecriticality = ls_invasao_new-operationtypecriticality
                           "PriceListCriticality     = ls_invasao_new-PriceListCriticality
                           minvaluecriticality      = ls_invasao_new-minvaluecriticality
                           currencycriticality      = ls_invasao_new-currencycriticality
                           datefromcriticality      = ls_invasao_new-datefromcriticality
                           datetocriticality        = ls_invasao_new-datetocriticality
                           conditionrecord          = ls_invasao_new-conditionrecord
                           KunnrCriticality         = ls_invasao_new-KunnrCriticality ) )
           REPORTED DATA(lt_reported_inv)
           FAILED DATA(lt_failed_inv).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      READ TABLE lt_invasao INTO DATA(ls_invasao) WITH KEY guid     = ls_invasao_new-guid
                                                           guidline = ls_invasao_new-guidline. "#EC CI_STDSEQ

      IF sy-subrc EQ 0.

        reported-invasao = VALUE #( BASE reported-invasao FOR ls_return IN lt_return WHERE ( row = ls_invasao-line ) (
                          %tky = ls_invasao-%tky
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


ENDCLASS.
