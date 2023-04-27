CLASS lcl_justifatraso DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR justifatraso RESULT result.

ENDCLASS.

CLASS lcl_justifatraso IMPLEMENTATION.

  METHOD get_authorizations.

    READ ENTITIES OF ZI_SD_JUSTIF_ATRASO_APP IN LOCAL MODE
        ENTITY JustifAtraso
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA lv_update TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-Centro ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update )
             TO result.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
