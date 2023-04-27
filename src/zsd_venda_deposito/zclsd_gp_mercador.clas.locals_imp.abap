CLASS lcl_grp_mercadorias DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setdescriptiongrpmerc FOR DETERMINE ON SAVE
      IMPORTING keys FOR grp_mercadorias~setdescriptiongrpmerc.

    METHODS getdescription
      IMPORTING iv_grpmercadoria    TYPE matkl
      RETURNING VALUE(rv_descricao) TYPE wgbez.

 METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Grp_Mercadorias RESULT result.

 METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Grp_Mercadorias~authoritycreate.

ENDCLASS.

CLASS lcl_grp_mercadorias IMPLEMENTATION.

METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF ZI_SD_GP_MERCADOR IN LOCAL MODE
        ENTITY Grp_Mercadorias
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdwerks=>werks_create( <fs_data>-Centro ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-Grp_Mercadorias.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-Grp_Mercadorias.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-Centro = if_abap_behv=>mk-on )
          TO reported-Grp_Mercadorias.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD get_authorizations.

    READ ENTITIES OF ZI_SD_GP_MERCADOR IN LOCAL MODE
        ENTITY Grp_Mercadorias
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

  METHOD setdescriptiongrpmerc.

    READ ENTITIES OF zi_sd_gp_mercador IN LOCAL MODE
        ENTITY grp_mercadorias
          FIELDS ( grpmercadoria ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_grpmercadoria)
        FAILED DATA(lt_failed).

    READ TABLE lt_grpmercadoria ASSIGNING FIELD-SYMBOL(<fs_grpmercadoria>) INDEX 1.
    IF <fs_grpmercadoria> IS ASSIGNED.
      DATA(lv_descricao) = getdescription( iv_grpmercadoria = <fs_grpmercadoria>-grpmercadoria ).
    ENDIF.

    MODIFY ENTITIES OF zi_sd_gp_mercador IN LOCAL MODE
    ENTITY grp_mercadorias
       UPDATE
       FIELDS ( descricao ) WITH VALUE #(  FOR ls_key IN keys
                                        (  %tky     = ls_key-%tky
                                          descricao = lv_descricao ) ).
  ENDMETHOD.

  METHOD getdescription.

    SELECT SINGLE descricao
    FROM zi_sd_product_group
    WHERE grpmercadorias = @iv_grpmercadoria
    INTO @rv_descricao.


  ENDMETHOD.

ENDCLASS.
