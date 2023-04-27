CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ cockpit RESULT result.
    METHODS desbloquearremessa FOR MODIFY
      IMPORTING keys FOR ACTION cockpit~desbloquearremessa.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR cockpit RESULT result.
ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD read.

    SELECT  *
    FROM zi_sd_cockpit_devolucao_ext
    FOR ALL ENTRIES IN @keys
       WHERE ordem   = @keys-ordem
         AND item    = @keys-item
         INTO TABLE  @DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      APPEND CORRESPONDING #( <fs_data> ) TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD desbloquearremessa.
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_DESBL' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.

* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
      READ ENTITIES OF zi_sd_cockpit_devolucao_ext IN LOCAL MODE ENTITY cockpit
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_cockpit).


* ---------------------------------------------------------------------------
* Desbloqueia OV Devolução
* ---------------------------------------------------------------------------

      DATA(lo_desbloqueio_remessa) = NEW zclsd_desbloqueia_ov_devolucao( ).
      reported-cockpit = VALUE #( FOR ls_cockpit IN lt_cockpit
        FOR ls_mensagem IN lo_desbloqueio_remessa->rmv_delivery_block( iv_vbeln = ls_cockpit-remessa )
        ( %tky = VALUE #( ordem = ls_cockpit-ordem item = ls_cockpit-item )
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
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'
                                 severity = CONV #( 'E' ) ) ) TO reported-cockpit.

    ENDIF.
  ENDMETHOD.

  METHOD get_features.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_devolucao_ext IN LOCAL MODE ENTITY cockpit
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_cockpit)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_cockpit IN lt_cockpit

                    ( %tky                      = ls_cockpit-%tky

                      %action-desbloquearremessa = COND #( WHEN ls_cockpit-remessa IS NOT INITIAL
                                                           THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled )

                      ) ).

  ENDMETHOD.

ENDCLASS.
