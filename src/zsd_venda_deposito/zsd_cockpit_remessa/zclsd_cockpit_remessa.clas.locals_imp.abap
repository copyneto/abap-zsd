CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK cockpit.

    METHODS read FOR READ
      IMPORTING keys FOR READ cockpit RESULT result.

    METHODS setdeliveryblock FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~setdeliveryblock.

    METHODS rmvdeliveryblock FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~rmvdeliveryblock.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.

    METHODS releasetorouting FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~releasetorouting.

    METHODS sendtorouting FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~sendtorouting.

    METHODS deletedelivery FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~deletedelivery.

    METHODS checkparam FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~checkparam.

    METHODS rba_log FOR READ
      IMPORTING keys_rba FOR READ cockpit\_cockpitlog FULL result_requested RESULT result LINK association_links.

*    METHODS returnsymbol FOR MODIFY
*      IMPORTING keys FOR ACTION cockpit~returnsymbol.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.


  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_cockpit)
*      FAILED failed.

    SELECT
    _deliverydocumentitem~referencesddocument AS salesdocument,
    _deliverydocumentitem~deliverydocument AS outbounddelivery,
    MIN( _deliverydocumentitem~referencesddocumentitem ) AS salesdocumentfirstitem,
    _deliverydocument~deliveryblockreason
    FROM i_deliverydocumentitem AS _deliverydocumentitem
    INNER JOIN @keys AS _keys
    ON _deliverydocumentitem~referencesddocument = _keys~salesdocument
    AND _deliverydocumentitem~deliverydocument   = _keys~outbounddelivery
    INNER JOIN i_salesdocumentbasic AS _salesdocumentbasic
    ON _salesdocumentbasic~salesdocument = _deliverydocumentitem~referencesddocument
    INNER JOIN ztca_param_val AS _param_val
    ON  _param_val~modulo = 'SD'
    AND _param_val~chave1 = 'ADM_FATURAMENTO'
    AND _param_val~chave2 = 'TIPOS_OV'
    AND _param_val~low    = _salesdocumentbasic~salesdocumenttype
    LEFT OUTER JOIN i_deliverydocument AS _deliverydocument
    ON _deliverydocument~deliverydocument = _deliverydocumentitem~deliverydocument
    GROUP BY
    _deliverydocumentitem~referencesddocument,
    _deliverydocumentitem~deliverydocument,
    _deliverydocument~deliveryblockreason
    INTO TABLE @DATA(lt_cockpit).

* ---------------------------------------------------------------------------
* Recupera parâmetros
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                            et_return    = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    TRY.

        result = VALUE #( FOR ls_cockpit IN lt_cockpit

                        ( %tky                        = VALUE #( salesdocument = ls_cockpit-salesdocument
                                                                 outbounddelivery = ls_cockpit-outbounddelivery ) "ls_cockpit-%tky

                          %action-checkparam          = COND #( WHEN lt_return IS NOT INITIAL
                                                                THEN if_abap_behv=>fc-o-enabled
                                                                ELSE if_abap_behv=>fc-o-disabled )

                          %action-releasetorouting    = COND #( WHEN ls_cockpit-deliveryblockreason EQ ls_parameter-lifsk_gr        " Status anterior - Enviar para Liberação (BD9-154F11)
                                                                 AND ls_parameter-lifsk_gr IS NOT INITIAL
                                                                THEN if_abap_behv=>fc-o-enabled
                                                                ELSE if_abap_behv=>fc-o-disabled )

                          %action-sendtorouting       = COND #( WHEN ls_cockpit-deliveryblockreason EQ ls_parameter-lifsk_lr        " Status anterior - Liberar para roteirização
                                                                 AND ls_parameter-lifsk_lr IS NOT INITIAL
                                                                THEN if_abap_behv=>fc-o-enabled
                                                                ELSE if_abap_behv=>fc-o-disabled )

*                          %action-setdeliveryblock    = COND #( WHEN ls_cockpit-deliveryblockreason NE ls_parameter-lifsk_er        " Último status - Enviar para roteirização
*                                                                 AND ls_parameter-lifsk_er IS NOT INITIAL
*                                                                THEN if_abap_behv=>fc-o-enabled
*                                                                ELSE if_abap_behv=>fc-o-disabled )
                          %action-setdeliveryblock    = if_abap_behv=>fc-o-enabled

                          %action-rmvdeliveryblock    = COND #( WHEN ls_cockpit-deliveryblockreason NE ls_parameter-lifsk_er        " Último status - Enviar para roteirização
                                                                 AND ls_parameter-lifsk_er IS NOT INITIAL
                                                                THEN if_abap_behv=>fc-o-enabled
                                                                ELSE if_abap_behv=>fc-o-disabled )

*                          %action-deleteDelivery      = if_abap_behv=>fc-o-enabled
*                           %action-deletedelivery = COND #( WHEN ls_cockpit-deliveryblockreason  NE 60
                          %action-deletedelivery = COND #( WHEN ls_cockpit-deliveryblockreason  IN  ls_parameter-r_lifsk_el  OR
                          ls_cockpit-deliveryblockreason IS INITIAL  " Último status - Eliminar Remessa
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled )

                        ) ).

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados do cockpit
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
          FROM zi_sd_cockpit_remessa
          FOR ALL ENTRIES IN @keys
          WHERE salesdocument    = @keys-salesdocument
            AND outbounddelivery = @keys-outbounddelivery
          INTO CORRESPONDING FIELDS OF TABLE @result.   "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD setdeliveryblock.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza bloqueio de Remessa
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->set_delivery_block( EXPORTING iv_vbeln  = ls_cockpit-outbounddelivery
                                             iv_lifsk  = ls_keys-%param-deliveryblockreasonnew
                                   IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD rmvdeliveryblock.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza bloqueio de Remessa
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->rmv_delivery_block( EXPORTING iv_vbeln  = ls_cockpit-outbounddelivery
                                   IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD releasetorouting.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_cockpit)
*      FAILED failed.

    TRY.
*        DATA(ls_cockpit) = lt_cockpit[ 1 ].
        DATA(ls_cockpit) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza bloqueio de Remessa
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->release_to_routing( EXPORTING iv_vbeln  = ls_cockpit-outbounddelivery
                                   IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD sendtorouting.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    DATA(lt_vbeln) = VALUE vbeln_vl_t( FOR ls_cockpit IN lt_cockpit ( ls_cockpit-outbounddelivery ) ).

* ---------------------------------------------------------------------------
* Realiza bloqueio de Remessa
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->send_to_routing( EXPORTING it_vbeln  = lt_vbeln
                                IMPORTING et_return = DATA(lt_return) ).

*    IF lines( keys ) > 1.
*      lo_events->format_return( EXPORTING iv_change_error_type   = abap_true
*                                          iv_change_warning_type = abap_true
*                                CHANGING  ct_return              = lt_return ).
*    ENDIF.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD deletedelivery.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Realiza bloqueio de Remessa
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->delete_delivery( EXPORTING iv_vbeln  = ls_cockpit-outbounddelivery
                                IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD checkparam.

* ---------------------------------------------------------------------------
* Verifica parâmetros
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).

    lo_events->get_configuration( IMPORTING et_return    = DATA(lt_return) ).

    lo_events->format_return( EXPORTING iv_change_error_type   = abap_true
                                        iv_change_warning_type = abap_true
                              CHANGING  ct_return              = lt_return ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

*  METHOD returnsymbol.
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_sd_cockpit_remessa IN LOCAL MODE ENTITY cockpit
*      ALL FIELDS
*      WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_cockpit)
*      FAILED failed.
*
** ---------------------------------------------------------------------------
** Realiza bloqueio de Remessa
** ---------------------------------------------------------------------------
*    DATA(lo_events) = NEW zclsd_cockpit_remessa_events( ).
*
*    lo_events->send_to_monitor( EXPORTING it_cockpit  = lt_cockpit
*                               IMPORTING et_return = DATA(lt_return) ).
*
*    lo_events->format_return( EXPORTING iv_change_error_type   = abap_false
*                                        iv_change_warning_type = abap_false
*                              CHANGING  ct_return              = lt_return ).
*
**    lo_events->build_reported( EXPORTING it_return   = lt_return
**                           IMPORTING es_reported = DATA(lt_reported) ).
**
**    reported = CORRESPONDING #( DEEP lt_reported ).
*    LOOP AT lt_return INTO DATA(ls_return).              "#EC CI_NESTED
*
**      APPEND VALUE #(
**      %msg        = new_message( id       = ls_return-id
**                                                 number   = ls_return-number
**                                                 v1       = ls_return-message_v1
**                                                 v2       = ls_return-message_v2
**                                                 v3       = ls_return-message_v3
**                                                 v4       = ls_return-message_v4
**                                                 severity = CONV #( ls_return-type ) )
**                       )
**        TO reported-cockpit.
*      READ TABLE lt_cockpit INTO DATA(ls_cockpit) WITH KEY outbounddelivery = ls_return-message_v1.
*      APPEND VALUE #( %key = ls_cockpit-%key
*              %msg =  new_message( id       = ls_return-id
*                                       number   = ls_return-number
*                                       v1       = ls_return-message_v1
*                                       v2       = ls_return-message_v2
*                                       v3       = ls_return-message_v3
*                                       v4       = ls_return-message_v4
*                                       severity = CONV #( ls_return-type ) ) ) TO reported-cockpit.
*
*    ENDLOOP.
*  ENDMETHOD.

  METHOD rba_log.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_sd_cockpit_remessa DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_sd_cockpit_remessa IMPLEMENTATION.

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
