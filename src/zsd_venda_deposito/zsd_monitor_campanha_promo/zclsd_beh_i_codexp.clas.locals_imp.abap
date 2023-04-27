CLASS lcl_sintproc DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTSD_SINT_PROCES'.

    "! Metodo de tratamento campo Status
    METHODS status FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _sintproc~status .

    "! Metodo complemento de tratamento campo Status
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _sintproc RESULT result.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _Sintproc~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _Sintproc RESULT result.

ENDCLASS.

CLASS lcl_sintproc IMPLEMENTATION.

  METHOD status.


    READ ENTITIES OF zi_sd_sint_proces IN LOCAL MODE
         ENTITY _sintproc
         FIELDS (  status  ) WITH CORRESPONDING #( keys )
         RESULT DATA(lt_dados).

    MODIFY ENTITIES OF zi_sd_sint_proces IN LOCAL MODE
    ENTITY _sintproc
    UPDATE FIELDS (  status )
    WITH VALUE #( FOR ls_dados IN lt_dados WHERE ( status IS INITIAL ) ( "#EC CI_STDSEQ
                    %key      =  ls_dados-%key
                     status = '1'
                    ) )
    REPORTED DATA(lt_reported).


  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_sd_sint_proces IN LOCAL MODE
       ENTITY _sintproc
         ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(lt_dados)
       FAILED failed.

    result =
      VALUE #(
      FOR ls_dados IN lt_dados
        ( %tky              = ls_dados-%tky  ) ).


  ENDMETHOD.


  METHOD authorityCreate.

    CONSTANTS: lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_sd_sint_proces IN LOCAL MODE
        ENTITY  _Sintproc
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclsd_auth_zsdmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-_Sintproc.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_Sintproc.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-_Sintproc.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_sd_sint_proces IN LOCAL MODE
         ENTITY _Sintproc
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_data)
         FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>update( gc_table ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclsd_auth_zsdmtable=>delete( gc_table ).
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

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
