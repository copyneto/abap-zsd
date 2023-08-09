***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: SD - Reenvio de Fatura do SAP para Fluig               *
*** AUTOR :    Luís Gustavo Schepp - META                             *
*** FUNCIONAL: Cleverson Faria - META                                 *
*** DATA : 24.07.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 24.07.2023 | Luís Gustavo Schepp   | Desenvolvimento inicial      *
***********************************************************************
REPORT zsdr_reenvio_fatura_sap_fluig.

************************************************************************
* Declarações
************************************************************************

TABLES j_1bnfdoc.

*-Constants------------------------------------------------------*
CONSTANTS gc_form_nf_eletronica TYPE j_1bnfdoc-form VALUE 'NF55'.

*-----------------------------------------------------------------------*
* Classe do Report
*-----------------------------------------------------------------------*
CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      main.

  PRIVATE SECTION.

    CLASS-METHODS:
      interface_fluig IMPORTING is_dados_nota TYPE zclsd_mt_dados_fatura_fluig,
      get_vbelv IMPORTING iv_document      TYPE vbeln_va
                RETURNING VALUE(rv_result) TYPE vbeln_va.

ENDCLASS.

*-Screen parameters----------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_docnum FOR j_1bnfdoc-docnum.
SELECTION-SCREEN END OF BLOCK b1.

*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  lcl_report=>main( ).

*-----------------------------------------------------------------------*
* Classe do report
*-----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.

  METHOD main.

    DATA: lv_salesdocument TYPE vbeln_va,
          lv_docnum        TYPE vbeln.

    DATA: lr_valid_code    TYPE RANGE OF j_1bnfdoc-code,
          lr_salesdocument TYPE RANGE OF vbeln_va,
          ls_dados_nota    TYPE zclsd_mt_dados_fatura_fluig.

    DATA lt_docflow TYPE tdt_docflow.


    lr_valid_code = VALUE #( sign = 'I'
                             option = 'EQ'
                           ( low = '100' )
                           ( low = '101' )
                           ( low = '102' )
                           ( low = '103' ) ).

    SELECT docnum, nfenum, code, form
      FROM j_1bnfdoc
      INTO TABLE @DATA(lt_nfdoc)
      WHERE docnum IN @s_docnum.
    IF sy-subrc EQ 0.

      SORT lt_nfdoc BY docnum.

      SELECT docnum, refkey
        FROM j_1bnflin
        INTO TABLE @DATA(lt_nflin)
        FOR ALL ENTRIES IN @lt_nfdoc
        WHERE docnum = @lt_nfdoc-docnum
          AND reftyp = 'BI'. "Faturamento.
      IF sy-subrc EQ 0.

        SORT lt_nflin BY docnum.

        SELECT salesdocument, billingdocument
          FROM i_billingdocumentitembasic
          INTO TABLE @DATA(lt_billingdocumentitembasic)
          FOR ALL ENTRIES IN @lt_nflin
          WHERE billingdocument = @lt_nflin-refkey(10).
        IF sy-subrc EQ 0.

          SORT lt_billingdocumentitembasic BY salesdocument.

          SELECT purchaseorderbycustomer,
                 customerpurchaseordertype,
                 salesdocument
            FROM i_salesdocument
            INTO TABLE @DATA(lt_salesdocument)
            FOR ALL ENTRIES IN @lt_billingdocumentitembasic
            WHERE salesdocument EQ @lt_billingdocumentitembasic-salesdocument.
          IF sy-subrc EQ 0.
            SORT lt_salesdocument BY salesdocument.
          ENDIF.

        ENDIF.

      ENDIF.

      LOOP AT lt_nfdoc ASSIGNING FIELD-SYMBOL(<fs_nfdoc>).

        REFRESH lr_salesdocument.

        IF <fs_nfdoc>-code IN lr_valid_code AND
           <fs_nfdoc>-form EQ gc_form_nf_eletronica.

          READ TABLE lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>) WITH KEY docnum = <fs_nfdoc>-docnum BINARY SEARCH.
          IF sy-subrc = 0.
            READ TABLE lt_billingdocumentitembasic
            ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>) WITH KEY billingdocument = <fs_nflin>-refkey(10) BINARY SEARCH.
            IF sy-subrc EQ 0.
              READ TABLE lt_salesdocument
              ASSIGNING FIELD-SYMBOL(<fs_salesdocument>) WITH KEY salesdocument = <fs_billingdocumentitembasic>-salesdocument BINARY SEARCH.
              IF sy-subrc EQ 0.
                CLEAR ls_dados_nota.

                IF <fs_salesdocument>-customerpurchaseordertype = 'FLUI'.

                  lv_docnum = <fs_nflin>-refkey(10).
                  CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
                    EXPORTING
                      iv_docnum  = lv_docnum
                    IMPORTING
                      et_docflow = lt_docflow.

                  IF lt_docflow IS NOT INITIAL.

                    SORT lt_docflow BY posnn
                                       vbtyp_v.

                    READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow>) WITH KEY posnn   = '0000'
                                                                                        vbtyp_v = 'J'
                                                                                        BINARY SEARCH.
                    IF sy-subrc = 0.

                      lv_docnum =   <fs_docflow>-docnuv.
                      REFRESH lt_docflow.
                      CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
                        EXPORTING
                          iv_docnum  = lv_docnum
                        IMPORTING
                          et_docflow = lt_docflow.

                      IF lt_docflow IS NOT INITIAL.

                        SORT lt_docflow BY posnn
                                           vbtyp_n.

                        READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn   = '0000'
                                                                              vbtyp_n = 'TMFO'
                                                                              BINARY SEARCH.
                        IF sy-subrc = 0.
                          ls_dados_nota-mt_dados_fatura_fluig-ordemfrete = <fs_docflow>-docnum.
                        ENDIF.

                      ENDIF.

                      DATA(lv_sldocument) = get_vbelv( <fs_salesdocument>-salesdocument ).

                      ls_dados_nota-mt_dados_fatura_fluig-salesdocument = COND #( WHEN lv_sldocument IS NOT INITIAL THEN lv_sldocument ELSE <fs_salesdocument>-salesdocument ).
                      ls_dados_nota-mt_dados_fatura_fluig-nfenum        = <fs_nfdoc>-nfenum.
                      ls_dados_nota-mt_dados_fatura_fluig-code          = <fs_nfdoc>-code.
                      ls_dados_nota-mt_dados_fatura_fluig-id            = <fs_salesdocument>-purchaseorderbycustomer.
                      interface_fluig( ls_dados_nota ).

                    ELSE.

                      READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn   = '000000'
                                                                            vbtyp_v = 'T'
                                                                            BINARY SEARCH.
                      IF sy-subrc = 0.

                        lv_docnum =   <fs_docflow>-docnuv.
                        REFRESH lt_docflow.
                        CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
                          EXPORTING
                            iv_docnum  = lv_docnum
                          IMPORTING
                            et_docflow = lt_docflow.

                        IF lt_docflow IS NOT INITIAL.

                          SORT lt_docflow BY posnn
                                             vbtyp_n.

                          READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn   = '0000'
                                                                                vbtyp_n = 'TMFO'
                                                                                BINARY SEARCH.
                          IF sy-subrc = 0.
                            ls_dados_nota-mt_dados_fatura_fluig-ordemfrete = <fs_docflow>-docnum.
                          ENDIF.

                        ENDIF.

                        lv_sldocument = get_vbelv( <fs_salesdocument>-salesdocument ).

                        ls_dados_nota-mt_dados_fatura_fluig-salesdocument = COND #( WHEN lv_sldocument IS NOT INITIAL THEN lv_sldocument ELSE <fs_salesdocument>-salesdocument ).
                        ls_dados_nota-mt_dados_fatura_fluig-nfenum        = <fs_nfdoc>-nfenum.
                        ls_dados_nota-mt_dados_fatura_fluig-code          = <fs_nfdoc>-code.
                        ls_dados_nota-mt_dados_fatura_fluig-id            = <fs_salesdocument>-purchaseorderbycustomer.
                        interface_fluig( ls_dados_nota ).

                      ENDIF.

                    ENDIF.

                  ENDIF.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD get_vbelv.

    SELECT SINGLE vbelv FROM vbfa
    WHERE vbeln   = @iv_document
      AND vbtyp_v = 'G'
    INTO @rv_result.

  ENDMETHOD.

  METHOD interface_fluig.

    TRY.
        NEW zclsd_co_si_envia_dados_fatur1(  )->si_envia_dados_fatura_fluig_ou(
            EXPORTING
               output = VALUE zclsd_mt_dados_fatura_fluig( mt_dados_fatura_fluig-salesdocument = is_dados_nota-mt_dados_fatura_fluig-salesdocument
                                                           mt_dados_fatura_fluig-nfenum        = is_dados_nota-mt_dados_fatura_fluig-nfenum
                                                           mt_dados_fatura_fluig-code          = is_dados_nota-mt_dados_fatura_fluig-code
                                                           mt_dados_fatura_fluig-ordemfrete    = is_dados_nota-mt_dados_fatura_fluig-ordemfrete
                                                           mt_dados_fatura_fluig-id            = is_dados_nota-mt_dados_fatura_fluig-id )
         ).

      CATCH cx_ai_system_fault INTO DATA(lo_fault).
        DATA(lv_msg) = lo_fault->get_text( ).
    ENDTRY.

    COMMIT WORK.

  ENDMETHOD.

ENDCLASS.
