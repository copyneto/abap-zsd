CLASS lcl_informacoes DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS verificasituacao FOR DETERMINE ON MODIFY
      IMPORTING keys FOR informacoes~verificasituacao.
*
*    METHODS get_authorizations FOR AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR informacoes RESULT result.

ENDCLASS.

CLASS lcl_informacoes IMPLEMENTATION.

  METHOD verificasituacao.
* ---------------------------------------------------------------------------
* Recupera informações do cabeçalho
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_sd_cockpit_devolucao IN LOCAL MODE ENTITY informacoes
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_cockpit).

    TRY.
        DATA(ls_cockpit) = lt_cockpit[ 1 ].

        IF ls_cockpit-situacao EQ '0'.

          TRY.
              DATA(ls_keys) = keys[ 1 ].

              SELECT SINGLE situacao
              FROM zi_sd_cockpit_devolucao
              WHERE guid EQ @ls_keys-guid
              INTO @DATA(lv_situacao).

            CATCH cx_root.
          ENDTRY.
        ENDIF.

        IF lv_situacao IS NOT INITIAL AND lv_situacao NE '3' AND lv_situacao NE '4' AND lv_situacao NE '5' AND lv_situacao NE '6'.

          APPEND VALUE #(

                         %msg       = new_message(
                           id       = 'ZSD_COCKPIT_DEVOL'
                           number   = '018'
                           severity = CONV #( 'E' ) ) ) TO reported-cockpit.


        ELSEIF lv_situacao IS INITIAL.
          IF ls_cockpit-situacao NE '3' AND ls_cockpit-situacao NE '4' AND ls_cockpit-situacao NE '5' AND ls_cockpit-situacao NE '6'.

            APPEND VALUE #(

                           %msg       = new_message(
                             id       = 'ZSD_COCKPIT_DEVOL'
                             number   = '018'
                             severity = CONV #( 'E' ) ) ) TO reported-cockpit.

          ENDIF.
        ENDIF.

      CATCH cx_root.
    ENDTRY.




  ENDMETHOD.

*  METHOD get_authorizations.
*  ENDMETHOD.

ENDCLASS.
