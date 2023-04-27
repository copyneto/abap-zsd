CLASS lcl_item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR item RESULT result.

    METHODS determinarcriticalidade FOR DETERMINE ON MODIFY
      IMPORTING keys FOR item~determinarcriticalidade.

*    METHODS determinarStatusRascunho FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR item~determinarStatusRascunho.

ENDCLASS.

CLASS lcl_item IMPLEMENTATION.

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

                      %update                   = COND #( WHEN ls_cockpit-presentationtype EQ zclsd_gestao_preco_events=>gc_presentation_type-item
                                                           AND ( ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-reprovado
                                                           OR ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-erro
                                                           OR ls_cockpit-status EQ zclsd_gestao_preco_events=>gc_status-alertaexp )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %delete                   = COND #( WHEN ls_cockpit-PresentationType EQ zclsd_gestao_preco_events=>gc_presentation_type-item
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

    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY cockpit BY \_item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).

* ---------------------------------------------------------------------------
* Aplica validação dos campos
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).
    lo_events->gs_modify = abap_true.
    lo_events->validate_request( EXPORTING iv_level      = zclsd_gestao_preco_events=>gc_level-item
                                           is_header_cds = CORRESPONDING #( ls_cockpit )
                                           it_item_cds   = CORRESPONDING #( lt_item )
                                 IMPORTING es_header_cds = DATA(ls_cockpit_new)
                                           et_item_cds   = DATA(lt_item_new)
                                           et_return     = DATA(lt_return) ).
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
* Atualiza campos do relatório - Item
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY item
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT lt_item.

*    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA
**
*      READ TABLE lt_item_new INTO DATA(ls_item_new) WITH KEY guid     = ls_item-guid
*                                                             guidline = ls_item-guidline. "#EC CI_STDSEQ
    LOOP AT lt_item_new INTO DATA(ls_item_new).

      MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY item
           UPDATE FIELDS ( line
                           linecriticality
                           status
                           statuscriticality
                           operationtype
                           operationtypecriticality
                           distchannelcriticality
                           pricelistcriticality
                           materialcriticality
                           scalecriticality
                           baseunitcriticality
                           minvaluecriticality
                           sugvaluecriticality
                           maxvaluecriticality
                           currencycriticality
                           conditionrecord
                           datefromcriticality
                           datetocriticality
                           minimum
                           minimumcriticality
                           minimumperc
                           minimumperccriticality
                           activeminvalue
                           activesugvalue
                           activemaxvalue
                           activecurrency
                           activeconditionrecord )
           WITH VALUE #( ( %key-guid                = ls_item_new-guid
                           %key-guidline            = ls_item_new-guidline
                           line                     = ls_item_new-line
                           linecriticality          = ls_item_new-linecriticality
                           status                   = ls_item_new-status
                           statuscriticality        = ls_item_new-statuscriticality
                           operationtype            = ls_item_new-operationtype
                           operationtypecriticality = ls_item_new-operationtypecriticality
                           distchannelcriticality   = ls_item_new-distchannelcriticality
                           pricelistcriticality     = ls_item_new-pricelistcriticality
                           materialcriticality      = ls_item_new-materialcriticality
                           scalecriticality         = ls_item_new-scalecriticality
                           baseunitcriticality      = ls_item_new-baseunitcriticality
                           minvaluecriticality      = ls_item_new-minvaluecriticality
                           sugvaluecriticality      = ls_item_new-sugvaluecriticality
                           maxvaluecriticality      = ls_item_new-maxvaluecriticality
                           currencycriticality      = ls_item_new-currencycriticality
                           conditionrecord          = ls_item_new-conditionrecord
                           datefromcriticality      = ls_item_new-datefromcriticality
                           datetocriticality        = ls_item_new-datetocriticality
                           minimum                  = ls_item_new-minimum
                           minimumcriticality       = ls_item_new-minimumcriticality
                           minimumperc              = ls_item_new-minimumperc
                           minimumperccriticality   = ls_item_new-minimumperccriticality
                           activeminvalue           = ls_item_new-activeminvalue
                           activesugvalue           = ls_item_new-activesugvalue
                           activemaxvalue           = ls_item_new-activemaxvalue
                           activecurrency           = ls_item_new-activecurrency
                           activeconditionrecord    = ls_item_new-activeconditionrecord ) )
           REPORTED DATA(lt_reported_itm)
           FAILED DATA(lt_failed_itm).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
      READ TABLE lt_item INTO DATA(ls_item) WITH KEY guid     = ls_item_new-guid
                                                     guidline = ls_item_new-guidline. "#EC CI_STDSEQ
      IF sy-subrc EQ 0.
        reported-item = VALUE #( BASE reported-item FOR ls_return IN lt_return WHERE ( row = ls_item-line ) (
                  %tky = ls_item-%tky
                  %msg = new_message( id       = ls_return-id
                                        number   = ls_return-number
                                        v1       = ls_return-message_v1
                                        v2       = ls_return-message_v2
                                        v3       = ls_return-message_v3
                                        v4       = ls_return-message_v4
                                        severity = CONV #( ls_return-type ) ) ) ). "#EC CI_STDSEQ
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
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Cockpit BY \_Item
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_item).
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
** Atualiza campos do relatório - Item
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Item
*        ALL FIELDS
*        WITH CORRESPONDING #( keys )
*        RESULT lt_item.
*
*     LOOP AT lt_item INTO DATA(ls_item). "#EC CI_LOOP_INTO_WA
*
*      MODIFY ENTITIES OF zi_sd_cockpit_gestao_preco IN LOCAL MODE ENTITY Item
*           UPDATE FIELDS ( Status )
*           WITH VALUE #( ( %key-Guid                = ls_item-Guid
*                           %key-GuidLine            = ls_item-GuidLine
*                           Status                   = zclsd_gestao_preco_events=>gc_status-em_aberto ) )
*           REPORTED DATA(lt_reported_itm)
*           FAILED DATA(lt_failed_itm).
*
*    ENDLOOP.
*
*  ENDMETHOD.

ENDCLASS.
