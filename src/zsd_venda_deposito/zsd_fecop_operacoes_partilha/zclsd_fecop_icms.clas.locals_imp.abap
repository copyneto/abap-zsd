CLASS lcl_fecop_icms DEFINITION INHERITING FROM cl_abap_behavior_handler. "#autoformat

  PRIVATE SECTION.

    CONSTANTS: gc_msg_class TYPE symsgid VALUE 'ZSD_FECOP_ICMS'.

    METHODS checkSalesOrg FOR VALIDATE ON SAVE
      IMPORTING keys FOR FecopICMS~checkSalesOrg.

    METHODS checkBusinessPlace FOR VALIDATE ON SAVE
      IMPORTING keys FOR FecopICMS~checkBusinessPlace.

    METHODS getSalesOrg IMPORTING iv_SalesOrgID    TYPE vkorg
                        RETURNING VALUE(rs_result) TYPE zi_sd_sales_org_text.

    METHODS getBusinessPlace IMPORTING iv_BusinessPlaceID TYPE j_1bbranc_
                             RETURNING VALUE(rs_result)   TYPE zi_sd_branch_text.

    METHODS checkKeyCombination FOR VALIDATE ON SAVE
      IMPORTING keys FOR FecopICMS~checkKeyCombination.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR FecopICMS RESULT result.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR FecopICMS~authorityCreate.

ENDCLASS.

CLASS lcl_fecop_icms IMPLEMENTATION.

  METHOD getbusinessplace.

    SELECT
        Company,
        BusinessPlace,
        BusinessPlaceType
        FROM zi_sd_branch_text
        WHERE BusinessPlace EQ @iv_businessplaceid
        INTO @rs_result
        UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc NE 0.
      CLEAR rs_result.
    ENDIF.

  ENDMETHOD.

  METHOD getsalesorg.

    SELECT SINGLE
        SalesOrgID,
        Text
    FROM zi_sd_sales_org_text
    WHERE SalesOrgID EQ @iv_salesorgid
    INTO @rs_result.

    IF sy-subrc NE 0.
      CLEAR rs_result.
    ENDIF.

  ENDMETHOD.

  METHOD checksalesorg.

    READ ENTITIES OF zi_sd_fecop_icms IN LOCAL MODE
        ENTITY FecopICMS
            FIELDS ( SalesOrgID ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_fecop_icms).

    READ TABLE lt_fecop_icms ASSIGNING FIELD-SYMBOL(<fs_fecop_icms>) INDEX 1.
    IF sy-subrc EQ 0.

      DATA(ls_salesorg) = me->getsalesorg( <fs_fecop_icms>-salesorgid ).

      " Valida se a Organização de Vendas inserida existe
      IF ls_salesorg IS INITIAL.

        APPEND VALUE #( %tky = <fs_fecop_icms>-%tky ) TO failed-fecopicms.

        APPEND VALUE #( %tky        = <fs_fecop_icms>-%tky
                        %msg        = new_message(
                                        id       = gc_msg_class
                                        number   = '001'
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = |{ TEXT-001 }| && | | && |{ <fs_fecop_icms>-salesorgid }|
                                      )

                        %element-SalesOrgID = if_abap_behv=>mk-on ) TO reported-fecopicms.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD checkbusinessplace.

    READ ENTITIES OF zi_sd_fecop_icms IN LOCAL MODE
        ENTITY FecopICMS
            FIELDS ( BusinessPlaceID ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_fecop_icms).

    " Valida se o Local de Negócios existe
    READ TABLE lt_fecop_icms ASSIGNING FIELD-SYMBOL(<fs_fecop_icms>) INDEX 1.
    IF sy-subrc EQ 0.

      IF me->getbusinessplace( <fs_fecop_icms>-businessplaceid ) IS INITIAL.

        APPEND VALUE #( %tky = <fs_fecop_icms>-%tky ) TO failed-fecopicms.

        APPEND VALUE #( %tky        = <fs_fecop_icms>-%tky
                        %msg        = new_message(
                                        id       = gc_msg_class
                                        number   = '001'
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = |{ TEXT-002 }| && | | && |{ <fs_fecop_icms>-BusinessPlaceID }|
                                      )

                        %element-BusinessPlaceID = if_abap_behv=>mk-on ) TO reported-fecopicms.

      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD checkkeycombination.

    READ ENTITIES OF zi_sd_fecop_icms IN LOCAL MODE
        ENTITY FecopICMS
            FIELDS ( BusinessPlaceID ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_fecop_icms).

    " Valida combinação Organização de Vendas x Local de Negócios
    READ TABLE lt_fecop_icms ASSIGNING FIELD-SYMBOL(<fs_fecop_icms>) INDEX 1.
    IF sy-subrc EQ 0.

      DATA(ls_salesorg) = me->getsalesorg( <fs_fecop_icms>-salesorgid ).
      IF ls_salesorg IS INITIAL.
        RETURN.
      ENDIF.

      DATA(ls_businessplace) = me->getbusinessplace( <fs_fecop_icms>-businessplaceid ).
      IF ls_businessplace IS INITIAL.
        RETURN.
      ENDIF.

      IF ls_salesorg-salesorgid NE ls_businessplace-company.

        APPEND VALUE #( %tky = <fs_fecop_icms>-%tky ) TO failed-fecopicms.

        APPEND VALUE #( %tky        = <fs_fecop_icms>-%tky
                        %msg        = new_message(
                                        id       = gc_msg_class
                                        number   = '002'
                                        severity = if_abap_behv_message=>severity-error
                                        v1       = |{ <fs_fecop_icms>-BusinessPlaceID }|
                                        v2       = |{ <fs_fecop_icms>-SalesOrgID }|
                                      )

                        %element = VALUE #( BusinessPlaceID = if_abap_behv=>mk-on
                                            SalesOrgID      = if_abap_behv=>mk-on
                                   )
                        ) TO reported-fecopicms.
      ENDIF.
    ENDIF.


  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_fecop_icms IN LOCAL MODE
        ENTITY FecopICMS
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdvkorg=>vkorg_delete( <fs_data>-SalesOrgId ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %delete = lv_delete )
             TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_sd_fecop_icms IN LOCAL MODE
        ENTITY FecopICMS
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdvkorg=>vkorg_delete( <fs_data>-SalesOrgId ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-fecopicms.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-fecopicms.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-SalesOrgId = if_abap_behv=>mk-on )
          TO reported-fecopicms.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
