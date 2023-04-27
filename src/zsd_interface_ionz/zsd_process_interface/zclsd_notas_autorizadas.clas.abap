CLASS zclsd_notas_autorizadas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! Campos da nota que serão enviados
      BEGIN OF ty_dados_nota,
        id     TYPE ze_id_cadastro,
        nr_nfe TYPE j_1bnfdoc-nfenum,
      END OF ty_dados_nota.

    DATA: gs_dados_nota TYPE ty_dados_nota.

    METHODS:
      main
        IMPORTING
          is_header TYPE j_1bnfdoc
        RAISING
          zcxca_erro_interface.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_erros,
                 interface TYPE string VALUE 'SI_ENVIAR_NOTA_FISCAL_OUT',
                 metodo    TYPE string VALUE 'interface_ionz',
                 classe    TYPE string VALUE 'ZCLSD_NOTAS_AUTORIZADAS',
               END OF gc_erros.
    TYPES:
      ty_lr_ref TYPE RANGE OF vbeln_vf.

    METHODS: interface_ionz
      RAISING
        zcxca_erro_interface,


      "! Return error raising
      error_raise
        IMPORTING
          is_ret TYPE scx_t100key
        RAISING
          zcxca_erro_interface.


ENDCLASS.



CLASS ZCLSD_NOTAS_AUTORIZADAS IMPLEMENTATION.


  METHOD main.
    DATA: lr_valid_code TYPE RANGE OF j_1bnfdoc-code,
          lt_ionz       TYPE TABLE OF ztsd_sint_proces,
          lr_ref        TYPE RANGE OF vbeln_vf,
          ls_ref        LIKE LINE OF lr_ref.

    lr_valid_code = VALUE #(  sign = 'I' option = 'EQ' ( low = '100' ) ).

    IF is_header-code IN lr_valid_code.

      SELECT refkey
        INTO TABLE @DATA(lt_lin)
        FROM j_1bnflin
        WHERE docnum = @is_header-docnum.
      IF sy-subrc = 0.
        DATA lv_doc_fat TYPE vbeln_vf.

        LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).
          lv_doc_fat = <fs_lin>-refkey.
          lr_ref = VALUE #(  sign = 'I' option = 'EQ' ( low = lv_doc_fat(10) ) ).
        ENDLOOP.


*        SELECT *
*          INTO TABLE lt_ionz
*          FROM ztsd_ionz
*          WHERE referencia IN lr_ref.
        SELECT *
          INTO TABLE @lt_ionz
          FROM ztsd_sint_proces
          WHERE doc_fat IN @lr_ref .

        IF sy-subrc = 0.
          LOOP AT lt_ionz ASSIGNING FIELD-SYMBOL(<fs_ionz>).

            <fs_ionz>-nr_nfe     = is_header-nfenum.
            gs_dados_nota-id     = <fs_ionz>-id.
            gs_dados_nota-nr_nfe = <fs_ionz>-nr_nfe.

            MODIFY ztsd_sint_proces FROM <fs_ionz>.

            CHECK sy-subrc = 0.
            interface_ionz( ).

          ENDLOOP.
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD interface_ionz.

    TRY.

        NEW zclsd_co_si_enviar_nota_fiscal(  )->si_enviar_nota_fiscal_out(
            EXPORTING
               output = VALUE zclsd_mt_fiscal_nota( mt_fiscal_nota-id     = gs_dados_nota-id
                                                    mt_fiscal_nota-nr_nfe = gs_dados_nota-nr_nfe

                                                    )
         ).

      CATCH cx_ai_system_fault.
        error_raise( is_ret = VALUE scx_t100key(  attr1 = gc_erros-classe attr2 = gc_erros-interface attr3 = gc_erros-metodo ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD error_raise.
    RAISE EXCEPTION TYPE zcxca_erro_interface
      EXPORTING
        textid = VALUE #(
                          attr1 = is_ret-attr1
                          attr2 = is_ret-attr2
                          attr3 = is_ret-attr3
                          msgid = is_ret-msgid
                          msgno = is_ret-msgno
                          ).
  ENDMETHOD.
ENDCLASS.
