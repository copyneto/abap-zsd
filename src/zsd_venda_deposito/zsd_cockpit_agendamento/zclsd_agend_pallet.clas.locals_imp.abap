CLASS lcl_pallet DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validarcampos FOR VALIDATE ON SAVE
      IMPORTING keys FOR pallet~validarcampos.

ENDCLASS.

CLASS lcl_pallet IMPLEMENTATION.

  METHOD validarcampos.

    READ ENTITIES OF zi_sd_ckpt_agend_pallet IN LOCAL MODE
        ENTITY pallet
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    TRY.
        DATA(ls_key) = keys[ 1 ].
        DELETE lt_data WHERE guid <> ls_key-guid.        "#EC CI_STDSEQ

        DATA(ls_data) = lt_data[ 1 ].

        IF ( ls_data-material  IS INITIAL AND ls_data-cliente  IS INITIAL ) OR
           ls_data-lastro    IS INITIAL OR
           ls_data-altura    IS INITIAL OR
           ls_data-unidadedemedidapallet IS INITIAL OR
           ls_data-qtdtotal IS INITIAL.

          APPEND VALUE #(  %tky        = ls_data-%tky
                           %msg        = new_message( id       = 'ZSD_CKPT_AGENDAMENTO'
                                                      number   = '013'
                                                      severity = CONV #( 'E')
                        ) ) TO reported-pallet.

        ELSE.

          SELECT COUNT(*)
           FROM ztsd_agenda001
           WHERE guid NE ls_data-guid
           AND material EQ ls_data-material
           AND cliente  EQ ls_data-cliente.

          IF sy-subrc IS INITIAL.

            APPEND VALUE #(  %tky        = ls_data-%tky
                             %msg        = new_message( id       = 'ZSD_CKPT_AGENDAMENTO'
                                                        number   = '014'
                                                        severity = CONV #( 'E')
                          ) ) TO reported-pallet.


          ENDIF.


        ENDIF.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
