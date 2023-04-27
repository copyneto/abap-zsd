CLASS lhc_ZI_SD_CTR_DET_DEP DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_sd_ctr_det_dep~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_sd_ctr_det_dep RESULT result.

ENDCLASS.

CLASS lhc_ZI_SD_CTR_DET_DEP IMPLEMENTATION.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_ctr_det_dep IN LOCAL MODE
        ENTITY zi_sd_ctr_det_dep
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-Werks ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-Werks ).
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

  METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_sd_ctr_det_dep IN LOCAL MODE
        ENTITY zi_sd_ctr_det_dep
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-Werks ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-zi_sd_ctr_det_dep.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-zi_sd_ctr_det_dep.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-Werks = if_abap_behv=>mk-on )
          TO reported-zi_sd_ctr_det_dep.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
