*&---------------------------------------------------------------------*
*& Include          ZSDI_INFADFISCO_INFCPL
*&---------------------------------------------------------------------*
  CONSTANTS lc_mvgr3 TYPE ztca_param_par-chave1 VALUE 'MVGR3'.

  DATA: lt_batch       TYPE clbatch_t,
        lt_out_lines_t TYPE TABLE OF j_1bmessag.

  DATA lr_mvgr3 TYPE RANGE OF mvgr3.

  DATA lv_dados_cert TYPE char950.


  IF NOT cs_header-infcpl IS INITIAL AND
     NOT it_nflin IS INITIAL.

    LOOP AT it_nflin ASSIGNING <fs_nflin>.

      TRY.
          DATA(lv_mvgr3) = it_vbrp[ posnr = <fs_nflin>-itmnum ]-mvgr3.
          TRY.
              lo_parametros->m_get_range(
                EXPORTING
                  iv_modulo = lc_sd
                  iv_chave1 = lc_mvgr3
                IMPORTING
                  et_range  = lr_mvgr3 ).

              IF lv_mvgr3 IN lr_mvgr3.

                CALL FUNCTION 'VB_BATCH_GET_DETAIL'
                  EXPORTING
                    matnr              = <fs_nflin>-matnr
                    charg              = <fs_nflin>-charg
                    werks              = <fs_nflin>-werks
                    get_classification = abap_true
                  TABLES
                    char_of_batch      = lt_batch
                  EXCEPTIONS
                    no_material        = 1
                    no_batch           = 2
                    no_plant           = 3
                    material_not_found = 4
                    plant_not_found    = 5
                    no_authority       = 6
                    batch_not_exist    = 7
                    lock_on_batch      = 8
                    OTHERS             = 9.

                IF sy-subrc <> 0.
                  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO lv_message.
                ENDIF.

                CLEAR: lv_dados_cert,
                       lv_material.
                lv_material = |{ <fs_nflin>-matnr ALPHA = OUT }|.
                CONDENSE lv_material NO-GAPS.

                TRY.
                    DATA(lv_lote) = lt_batch[ atnam = 'LOTE_MAPA' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_certif) = lt_batch[ atnam = 'CERT_MAPA' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_data_val) = lt_batch[ atnam = 'DATA_EMIS_CERT' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.

                IF NOT lv_certif IS INITIAL AND
                   NOT lv_data_val IS INITIAL.
                  lv_dados_cert = |LOTE { lv_lote } CERT. { lv_certif } DATA { lv_data_val } PROD. { lv_material }|.
                ENDIF.

                TRY.
                    DATA(lv_lote_1) = lt_batch[ atnam = 'LOTE_MAPA_1' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_certif_1) = lt_batch[ atnam = 'CERT_MAPA_1' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_data_val_1) = lt_batch[ atnam = 'DATA_EMIS_CERT_1' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.

                IF NOT lv_certif_1 IS INITIAL AND
                   NOT lv_data_val_1 IS INITIAL.
                  lv_dados_cert = |{ lv_dados_cert } LOTE { lv_lote_1 } CERT. { lv_certif_1 } DATA { lv_data_val_1 } PROD. { lv_material }|.
                ENDIF.

                TRY.
                    DATA(lv_lote_2) = lt_batch[ atnam = 'LOTE_MAPA_2' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_certif_2) = lt_batch[ atnam = 'CERT_MAPA_2' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
                TRY.
                    DATA(lv_data_val_2) = lt_batch[ atnam = 'DATA_EMIS_CERT_2' ]-atwtb.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.

                IF NOT lv_certif_2 IS INITIAL AND
                   NOT lv_data_val_2 IS INITIAL.
                  lv_dados_cert = |{ lv_dados_cert } LOTE { lv_lote_2 } CERT. { lv_certif_2 } DATA { lv_data_val_2 } PROD. { lv_material }|.
                ENDIF.

                IF NOT lv_dados_cert IS INITIAL.

                  IF <fs_nfetx_tab> IS ASSIGNED.

                    REFRESH lt_out_lines_t.
                    CALL FUNCTION 'RKD_WORD_WRAP'
                      EXPORTING
                        textline            = lv_dados_cert
                        outputlen           = 72
                      TABLES
                        out_lines           = lt_out_lines_t
                      EXCEPTIONS
                        outputlen_too_large = 1
                        OTHERS              = 2.

                    lt_nfetx = <fs_nfetx_tab>.

                    SORT lt_nfetx BY seqnum DESCENDING.

                    lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
                    lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).
                    LOOP AT lt_out_lines_t ASSIGNING FIELD-SYMBOL(<fs_out_lines_t>).
                      ADD 1 TO lv_seq.
                      IF <fs_nfetx_tab> IS ASSIGNED.
                        APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_out_lines_t> ) TO <fs_nfetx_tab>.
                      ENDIF.
                    ENDLOOP.

                  ENDIF.

                  SEARCH cs_header-infcpl FOR lv_dados_cert.
                  IF sy-subrc NE 0.
                    cs_header-infcpl = |{ cs_header-infcpl } { lv_dados_cert }|.
                  ENDIF.

                ENDIF.

                CLEAR: lv_certif,
                       lv_certif_1,
                       lv_certif_2,
                       lv_data_val,
                       lv_data_val_1,
                       lv_data_val_2,
                       lv_dados_cert.

              ENDIF.

            CATCH zcxca_tabela_parametros.
          ENDTRY.
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

    ENDLOOP.

  ENDIF.
