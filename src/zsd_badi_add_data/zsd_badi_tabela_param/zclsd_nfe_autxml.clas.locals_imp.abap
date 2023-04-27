CLASS lcl_zi_sd_nfe_autxml DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sd_nfe_autxml~authoritycreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_sd_nfe_autxml RESULT result.

    CONSTANTS gc_tabela TYPE tabname_auth VALUE 'ZTSD_NFE_AUTXML'.

ENDCLASS.

CLASS lcl_zi_sd_nfe_autxml IMPLEMENTATION.

  METHOD authoritycreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.


    READ ENTITIES OF zi_sd_nfe_autxml IN LOCAL MODE
        ENTITY zi_sd_nfe_autxml
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdmtable=>create( gc_tabela ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-zi_sd_nfe_autxml.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-zi_sd_nfe_autxml.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-localnegocios = if_abap_behv=>mk-on )
          TO reported-zi_sd_nfe_autxml.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF zi_sd_nfe_autxml IN LOCAL MODE
        ENTITY zi_sd_nfe_autxml
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>update( gc_tabela ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>delete( gc_tabela ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
