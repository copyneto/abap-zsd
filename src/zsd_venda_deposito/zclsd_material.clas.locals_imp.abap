CLASS lcl_material DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setdescriptionmaterial FOR DETERMINE ON SAVE
      IMPORTING keys FOR material~setdescriptionmaterial.


    METHODS getdescription
      IMPORTING iv_material         TYPE matnr
      RETURNING VALUE(rv_descricao) TYPE maktx.

 METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Material RESULT result.

 METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Material~authoritycreate.


ENDCLASS.

CLASS lcl_material IMPLEMENTATION.

METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF ZI_SD_MATERIAL IN LOCAL MODE
        ENTITY Material
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdwerks=>werks_create( <fs_data>-Centro ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-Material.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-Material.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-Centro = if_abap_behv=>mk-on )
          TO reported-Material.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD get_authorizations.

    READ ENTITIES OF ZI_SD_MATERIAL IN LOCAL MODE
        ENTITY Material
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_update( <fs_data>-Centro ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdwerks=>werks_delete( <fs_data>-Centro ).
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

  METHOD setdescriptionmaterial.

    READ ENTITIES OF zi_sd_material IN LOCAL MODE
          ENTITY material
            FIELDS ( material ) WITH CORRESPONDING #( keys )
          RESULT DATA(lt_material)
          FAILED DATA(lt_failed).

    READ TABLE lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) INDEX 1.
    IF <fs_material> IS ASSIGNED.
      DATA(lv_descricao) = getdescription( iv_material = <fs_material>-material ).
    ENDIF.

    MODIFY ENTITIES OF zi_sd_material IN LOCAL MODE
    ENTITY material
       UPDATE
       FIELDS ( descricao ) WITH VALUE #(  FOR ls_key IN keys
                                        (  %tky     = ls_key-%tky
                                          descricao = lv_descricao ) ).
  ENDMETHOD.

  METHOD getdescription.

    SELECT SINGLE descricao
    FROM zi_sd_product
    WHERE material = @iv_material
    INTO @rv_descricao.


  ENDMETHOD.

ENDCLASS.
