CLASS zclsd_retorno_fatura_fluig DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      "! NFE Saída
      gc_nfe_saida          TYPE j_1bnfdoc-direct VALUE '2',
      "! Formato NF Eletrônica
      gc_form_nf_eletronica TYPE j_1bnfdoc-form VALUE 'NF55'.

    METHODS:
      main
        IMPORTING
          is_header TYPE j_1bnfdoc
        RAISING
          zcxca_erro_interface.
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_erros,
                 interface TYPE string VALUE 'SIENVIADADOSFATURAFLUIGOUT',
                 metodo    TYPE string VALUE 'interface_fluig',
                 classe    TYPE string VALUE 'ZCLSD_RETORNO_FATURA_FLUIG',
               END OF gc_erros.
    TYPES:
      ty_lr_ref TYPE RANGE OF vbeln_vf.

    DATA: gs_dados_nota TYPE zclsd_mt_dados_fatura_fluig.

    METHODS: interface_fluig
      RAISING
        zcxca_erro_interface,

      "! Return error raising
      error_raise
        IMPORTING
          is_ret TYPE scx_t100key
        RAISING
          zcxca_erro_interface,
      get_vbelv
        IMPORTING
          iv_document      TYPE vbeln_va
        RETURNING
          VALUE(rv_result) TYPE vbeln_va.
ENDCLASS.



CLASS ZCLSD_RETORNO_FATURA_FLUIG IMPLEMENTATION.


  METHOD main.

    DATA: lr_valid_code    TYPE RANGE OF j_1bnfdoc-code,
          lt_ionz          TYPE TABLE OF ztsd_sint_proces,
          lr_ref           TYPE RANGE OF vbeln_vf,
          ls_ref           LIKE LINE OF lr_ref,
          lr_salesdocument TYPE RANGE OF vbeln_va,
          lv_doc_fat       TYPE vbeln_vf,
          lv_salesdocument TYPE vbeln_va,
          lt_docflow       TYPE tdt_docflow,
          lv_docnum        TYPE vbeln.

    FIELD-SYMBOLS: <fs_docflow> TYPE tds_docflow.

    lr_valid_code = VALUE #(  sign = 'I' option = 'EQ'
                        ( low = '100' )
                        ( low = '101' )
                        ( low = '102' )
                        ( low = '103' )
                    ).

    IF is_header-code IN lr_valid_code


*        AND is_header-direct EQ gc_nfe_saida
        AND is_header-form   EQ gc_form_nf_eletronica.

      SELECT SINGLE refkey
        INTO @DATA(lv_refkey)
        FROM j_1bnflin
        WHERE docnum = @is_header-docnum AND
              reftyp = 'BI'. "Faturamento.
      IF sy-subrc = 0.

        SELECT salesdocument,
               billingdocument
            INTO TABLE @DATA(lt_billingdocumentitembasic)
            FROM i_billingdocumentitembasic
            WHERE billingdocument = @lv_refkey.
        IF lt_billingdocumentitembasic IS NOT INITIAL.

          LOOP AT lt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>).
            lv_salesdocument = <fs_billingdocumentitembasic>-salesdocument.
            lr_salesdocument = VALUE #(  sign = 'I' option = 'EQ' ( low = lv_salesdocument ) ).
          ENDLOOP.

          SELECT purchaseorderbycustomer,
                 customerpurchaseordertype,
                 salesdocument
            INTO TABLE @DATA(lt_salesdocument)
            FROM i_salesdocument
            WHERE salesdocument IN @lr_salesdocument.
        ENDIF.
        SORT lt_docflow BY posnn vbtyp_v.
        LOOP AT lt_salesdocument ASSIGNING FIELD-SYMBOL(<fs_salesdocument>).

          IF <fs_salesdocument>-customerpurchaseordertype = 'FLUI'.

            lv_docnum = lv_refkey.
            CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
              EXPORTING
                iv_docnum  = lv_docnum
              IMPORTING
                et_docflow = lt_docflow.
            IF lt_docflow IS NOT INITIAL.

              READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn = '0000' vbtyp_v = 'J' BINARY SEARCH.
              IF sy-subrc = 0.

                lv_docnum =   <fs_docflow>-docnuv.
                REFRESH lt_docflow.
                CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
                  EXPORTING
                    iv_docnum  = lv_docnum
                  IMPORTING
                    et_docflow = lt_docflow.
                IF lt_docflow IS NOT INITIAL.
                  SORT lt_docflow BY posnn vbtyp_n.
                  READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn = '0000' vbtyp_n = 'TMFO' BINARY SEARCH.
                  IF sy-subrc = 0.
                    gs_dados_nota-mt_dados_fatura_fluig-ordemfrete    = <fs_docflow>-docnum.

                  ENDIF.

                ENDIF.

                DATA(lv_sldocument) = get_vbelv( <fs_salesdocument>-salesdocument ).

                gs_dados_nota-mt_dados_fatura_fluig-salesdocument = COND #( WHEN lv_sldocument IS NOT INITIAL THEN lv_sldocument ELSE <fs_salesdocument>-salesdocument ).
                gs_dados_nota-mt_dados_fatura_fluig-nfenum        = is_header-nfenum.
                gs_dados_nota-mt_dados_fatura_fluig-code          = is_header-code.
                gs_dados_nota-mt_dados_fatura_fluig-id            = <fs_salesdocument>-purchaseorderbycustomer.
                interface_fluig( ).

              ENDIF.

            ENDIF.

          ENDIF.

        ENDLOOP.

      ENDIF.

    ENDIF.

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


  METHOD interface_fluig.

    TRY.

        NEW zclsd_co_si_envia_dados_fatur1(  )->si_envia_dados_fatura_fluig_ou(
            EXPORTING
               output = VALUE zclsd_mt_dados_fatura_fluig( mt_dados_fatura_fluig-salesdocument = gs_dados_nota-mt_dados_fatura_fluig-salesdocument
                                                           mt_dados_fatura_fluig-nfenum        = gs_dados_nota-mt_dados_fatura_fluig-nfenum
                                                           mt_dados_fatura_fluig-code          = gs_dados_nota-mt_dados_fatura_fluig-code
                                                           mt_dados_fatura_fluig-ordemfrete    = gs_dados_nota-mt_dados_fatura_fluig-ordemfrete
                                                           mt_dados_fatura_fluig-id            = gs_dados_nota-mt_dados_fatura_fluig-id )
         ).

      CATCH cx_ai_system_fault INTO DATA(lo_fault).
*        error_raise( is_ret = VALUE scx_t100key(  attr1 = gc_erros-classe attr2 = gc_erros-interface attr3 = gc_erros-metodo ) ).
        DATA(lv_msg) = lo_fault->get_text( ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_vbelv.

    SELECT SINGLE vbelv FROM vbfa
    WHERE vbeln   = @iv_document
      AND vbtyp_v = 'G'
    INTO @rv_result.

  ENDMETHOD.
ENDCLASS.
