*&---------------------------------------------------------------------*
*& Include ZSDI_DADOS_ADICIONAIS_DISTRATO
*&---------------------------------------------------------------------*
    TYPES: BEGIN OF ty_eqp,
             invnr TYPE anla-invnr,
           END OF ty_eqp.

    CONSTANTS:
      lc_z010    TYPE tdid VALUE 'Z010',
      lc_ob_vbbp TYPE tdobject VALUE 'VBBP'.

    DATA lt_eqp TYPE STANDARD TABLE OF ty_eqp.

    DATA: lv_sernr       TYPE objk-sernr,
          lv_anln1       TYPE anla-anln1,
          lv_pla_imo_nfe TYPE string,
          lv_plaqueta    TYPE string,
          lv_imobilizado TYPE string,
          lv_aditivo     TYPE string,
          lv_docdate     TYPE char10,
          lv_nfe         TYPE char100,
          lv_linha       TYPE char950,
          lt_out_lines   TYPE TABLE OF j_1bmessag,
          lv_xabln       TYPE xabln,
          lv_mblnr       TYPE mblnr.

    DATA: lv_name_read  TYPE thead-tdname,
          lt_lines_read TYPE tline_tab.

    ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER') TO <fs_wk_header>.
    ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER_TEXT') TO <fs_header_text>.
    IF <fs_wk_header> IS ASSIGNED AND
      <fs_header_text> IS ASSIGNED.

      IF it_doc-direct EQ '2' AND "Saída
         it_lin-reftyp EQ 'MD'.   "Doc.material

        SELECT SINGLE a~xabln, a~mblnr
          FROM mkpf AS a
          INNER JOIN mseg AS b ON a~mblnr = b~mblnr
                              AND a~mjahr = b~mjahr
          INTO ( @lv_xabln, @lv_mblnr )
          WHERE a~mblnr = @it_lin-refkey(10)
            AND a~mjahr = @it_lin-refkey+10(4)
            AND b~bwart IN ( 'YG6', 'YG8' ).
        IF sy-subrc EQ 0.

*          DATA: lv_break TYPE c VALUE 'X'.
*          DO.
*            IF lv_break = ''.
*              EXIT.
*            ENDIF.
*          ENDDO.

          SELECT SINGLE vbelv
            FROM vbfa
            INTO @DATA(lv_vbelv)
            WHERE vbeln   = @lv_xabln
              AND vbtyp_v = 'G'. "Contrato

          "não achou o contrato então vamos tentar encontrar o contrato via NF que está sendo gerada
          IF NOT sy-subrc IS INITIAL AND
            lv_vbelv IS INITIAL.

            SELECT _sd_infdis~contrato,
                   _sd_infdis~contratoitem,
                   _sd_infdis~solicitacao AS aditivo,
                   _sd_infdis~serie
            FROM zi_sd_inf_distrato_nf as _sd_infdis
            JOIN vbkd as _vbkd on _sd_infdis~contrato = _vbkd~vbeln and
                                  _sd_infdis~contratoitem = _vbkd~posnr
            WHERE _sd_infdis~nfretorno EQ @<fs_wk_header>-nfenum
            AND   _sd_infdis~docnum EQ @<fs_wk_header>-docnum
            AND   _sd_infdis~distributionchannel EQ '10'
            INTO TABLE @DATA(lt_contrato).

            IF NOT sy-subrc IS INITIAL.

              SELECT SINGLE VKORG
              FROM t001w
              WHERE j_1bbranch EQ @<fs_wk_header>-branch
              INTO @DATA(lv_orgven).

              SELECT _sd_infdis~contrato,
                     _sd_infdis~contratoitem,
                     _sd_infdis~solicitacao AS aditivo,
                     _sd_infdis~serie
              FROM zi_sd_inf_distrato_nf as _sd_infdis
              JOIN vbkd as _vbkd on _sd_infdis~contrato = _vbkd~vbeln and
                                    _sd_infdis~contratoitem = _vbkd~posnr
              WHERE _sd_infdis~nfretorno EQ @<fs_wk_header>-nfenum
              AND   _sd_infdis~docnum EQ @<fs_wk_header>-docnum
              AND   _sd_infdis~SalesOrganization EQ @lv_orgven
              INTO TABLE @lt_contrato.

              IF NOT sy-subrc IS INITIAL.
                SELECT _sd_infdis~contrato,
                       _sd_infdis~contratoitem,
                       _sd_infdis~solicitacao AS aditivo,
                       _sd_infdis~serie
                FROM zi_sd_inf_distrato_nf as _sd_infdis
                JOIN vbkd as _vbkd on _sd_infdis~contrato = _vbkd~vbeln and
                                      _sd_infdis~contratoitem = _vbkd~posnr
                WHERE _sd_infdis~nfretorno EQ @<fs_wk_header>-nfenum
                AND   _sd_infdis~docnum EQ @<fs_wk_header>-docnum
                INTO TABLE @lt_contrato.
              ENDIF.

            ENDIF.

            IF NOT lt_contrato[] IS INITIAL.

              SORT lt_contrato BY contrato contratoitem ASCENDING.

              READ TABLE lt_contrato ASSIGNING FIELD-SYMBOL(<fs_contrato>) INDEX 1.

              SELECT SINGLE ihrez
              FROM vbak
              WHERE vbeln EQ @<fs_contrato>-contrato
              INTO @DATA(lv_contrato_new).

              IF lv_contrato_new IS INITIAL.
                SELECT SINGLE ihrez
                FROM vbkd
                WHERE vbeln EQ @<fs_contrato>-contrato
                AND posnr IS INITIAL
                INTO @lv_contrato_new.

              ENDIF.


              READ TABLE <fs_header_text> ASSIGNING FIELD-SYMBOL(<fs_header_text_lines_new>) INDEX 1.
              SEARCH <fs_header_text_lines_new>-text FOR TEXT-f80.

              "Aditivo
              IF sy-subrc NE 0.
                lv_aditivo = |{ TEXT-f80 }: { <fs_contrato>-aditivo }|.
                <fs_header_text_lines_new>-text = |{ <fs_header_text_lines_new>-text } { lv_aditivo }|.
              ENDIF.

              "Contrato
              SEARCH <fs_header_text_lines_new>-text FOR TEXT-f92.
              IF sy-subrc NE 0.
                <fs_header_text_lines_new>-text = |{ <fs_header_text_lines_new>-text } { TEXT-f92 } { lv_contrato_new }|.
              ENDIF.

              "NF e Data
              lv_name_read = |{ <fs_contrato>-contrato }{ <fs_contrato>-contratoitem }|.

              CALL FUNCTION 'READ_TEXT'
                EXPORTING
                  id                      = lc_z010
                  language                = sy-langu
                  name                    = lv_name_read
                  object                  = lc_ob_vbbp
                TABLES
                  lines                   = lt_lines_read
                EXCEPTIONS
                  id                      = 1
                  language                = 2
                  name                    = 3
                  not_found               = 4
                  object                  = 5
                  reference_check         = 6
                  wrong_access_to_archive = 7
                  OTHERS                  = 8.

              IF sy-subrc IS INITIAL.
                LOOP AT lt_lines_read ASSIGNING FIELD-SYMBOL(<fs_lines_read>).
                  DATA(lv_num_nfe) = <fs_lines_read>-tdline+26(8).
                  DATA(lv_date_nfe) = |{ <fs_lines_read>-tdline+4(2) }/{ <fs_lines_read>-tdline+2(2) }|.
                ENDLOOP.
              ENDIF.

              IF NOT lv_num_nfe IS INITIAL AND
                NOT lv_date_nfe IS INITIAL.

                lv_nfe = TEXT-f58.
                REPLACE '&1' IN lv_nfe WITH lv_num_nfe.
                REPLACE '&2' IN lv_nfe WITH lv_date_nfe.
              ENDIF.

              "mapear serie p equipamento
              LOOP AT lt_contrato ASSIGNING FIELD-SYMBOL(<fs_serie>).

                CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                  EXPORTING
                    input  = <fs_serie>-serie
                  IMPORTING
                    output = lv_sernr.

                lt_eqp = VALUE #( BASE lt_eqp ( invnr = lv_sernr ) ).

              ENDLOOP.

              "Plaqueta/Imobilizado
              IF NOT lt_eqp[] IS INITIAL.

                SELECT invnr,
                       anln1
                  FROM anla
                   FOR ALL ENTRIES IN @lt_eqp
                 WHERE invnr EQ @lt_eqp-invnr
                  INTO TABLE @DATA(lt_anla_new).
                IF sy-subrc EQ 0.
                  SORT lt_anla_new BY invnr.
                ENDIF.
              ENDIF.

              CLEAR: lv_pla_imo_nfe.

              LOOP AT lt_contrato ASSIGNING <fs_serie>.

                CLEAR: lv_plaqueta,
                       lv_imobilizado.

                " Plaqueta
                IF NOT <fs_serie>-serie IS INITIAL.

                  lv_sernr = <fs_serie>-serie.

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = lv_sernr
                    IMPORTING
                      output = lv_sernr.

                  lv_plaqueta = |{ TEXT-f52 }: { lv_sernr }|.

                ENDIF.

                " Imobilizado
                IF NOT lv_sernr IS INITIAL.

                  READ TABLE lt_anla_new ASSIGNING FIELD-SYMBOL(<fs_anla_new>)
                                                   WITH KEY invnr = lv_sernr
                                                   BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lv_anln1 = <fs_anla_new>-anln1.

                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                      EXPORTING
                        input  = lv_anln1
                      IMPORTING
                        output = lv_anln1.

                    lv_imobilizado = |{ TEXT-f53 }: { lv_anln1 }|.

                  ENDIF.
                ENDIF.

                CLEAR: lv_sernr,
                       lv_anln1.

                lv_pla_imo_nfe = |{ lv_pla_imo_nfe } { lv_plaqueta } { lv_imobilizado } { lv_nfe }|.

              ENDLOOP.

              IF NOT lv_pla_imo_nfe IS INITIAL.
                SEARCH <fs_header_text_lines_new>-text FOR TEXT-f52.

                IF sy-subrc NE 0.
                  <fs_header_text_lines_new>-text = |{ <fs_header_text_lines_new>-text } { lv_pla_imo_nfe }|.
                ENDIF.

                SEARCH <fs_header_text_lines_new>-text FOR TEXT-f53.
                IF sy-subrc NE 0.
                  <fs_header_text_lines_new>-text = |{ <fs_header_text_lines_new>-text } { lv_pla_imo_nfe }|.
                ENDIF.

                SEARCH <fs_header_text_lines_new>-text FOR 'Referencia NFe'.
                IF sy-subrc NE 0.
                  <fs_header_text_lines_new>-text = |{ <fs_header_text_lines_new>-text } { lv_pla_imo_nfe }|.
                ENDIF.

              ENDIF.

              SELECT *
                FROM j_1bnfftx
                INTO TABLE @DATA(lt_nfftx_new)
                WHERE docnum EQ @<fs_wk_header>-docnum.
              IF sy-subrc EQ 0.

                REFRESH lt_out_lines.
                lv_linha = <fs_header_text_lines_new>-text.
                CALL FUNCTION 'RKD_WORD_WRAP'
                  EXPORTING
                    textline            = lv_linha
                    outputlen           = 72
                  TABLES
                    out_lines           = lt_out_lines
                  EXCEPTIONS
                    outputlen_too_large = 1
                    OTHERS              = 2.

                SORT lt_nfftx_new BY seqnum DESCENDING.

                DATA(lv_seq_n) = VALUE #( lt_nfftx_new[ 1 ]-seqnum DEFAULT 0 ).
                DATA(lv_linnum_n) = VALUE #( lt_nfftx_new[ 1 ]-linnum DEFAULT 0 ).

                LOOP AT lt_out_lines ASSIGNING FIELD-SYMBOL(<fs_out_lines_new>).
                  ADD 1 TO lv_seq_n.
                  APPEND VALUE j_1bnfftx( mandt  = sy-mandt
                                          docnum = <fs_wk_header>-docnum
                                          seqnum = lv_seq_n
                                          linnum = lv_linnum_n
                                          message = <fs_out_lines_new> ) TO lt_nfftx_new.
                ENDLOOP.

                SORT lt_nfftx_new BY message.
                DELETE ADJACENT DUPLICATES FROM lt_nfftx_new COMPARING message.

                IF NOT lt_nfftx_new IS INITIAL.
                  MODIFY j_1bnfftx FROM TABLE lt_nfftx_new[].
                  IF sy-subrc EQ 0.
                    CALL FUNCTION 'DB_COMMIT'.
                  ENDIF.
                ENDIF.

              ENDIF.

            ENDIF.

          ELSEIF sy-subrc EQ 0.

            SELECT SINGLE vbeln
              FROM vbfa
              INTO @DATA(lv_remessa)
              WHERE vbelv   = @lv_vbelv
                AND vbtyp_n = 'J'. "Fornecimento
            IF sy-subrc EQ 0.

              SELECT serialnumber
              FROM i_serialnumbermaterialdocument
              WHERE materialdocument = @lv_mblnr
              INTO TABLE @DATA(lt_serialnumber).

              SELECT a~obknr,
                     a~lief_nr,
                     a~posnr,
                     b~sernr
                FROM ser01 AS a
               INNER JOIN objk AS b ON b~obknr = a~obknr
                FOR ALL ENTRIES IN @lt_serialnumber
               WHERE a~lief_nr EQ @lv_remessa
               AND b~sernr EQ @lt_serialnumber-serialnumber
                INTO TABLE @DATA(lt_obknr).

              CLEAR: lv_aditivo.

              SELECT posnr, ihrez
                FROM vbkd
                FOR ALL ENTRIES IN @lt_obknr
              WHERE vbkd~vbeln = @lv_vbelv
              AND vbkd~posnr = @lt_obknr-posnr
                INTO TABLE @DATA(lt_vbkd).

              IF sy-subrc EQ 0.
                SORT lt_vbkd BY ihrez.
                DELETE ADJACENT DUPLICATES FROM lt_vbkd COMPARING ihrez.
              ENDIF.

              IF NOT lt_obknr[] IS INITIAL.

                LOOP AT lt_obknr ASSIGNING FIELD-SYMBOL(<fs_obknr>).

                  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                    EXPORTING
                      input  = <fs_obknr>-sernr
                    IMPORTING
                      output = lv_sernr.

                  lt_eqp = VALUE #( BASE lt_eqp ( invnr = lv_sernr ) ).

                ENDLOOP.

                READ TABLE <fs_header_text> ASSIGNING FIELD-SYMBOL(<fs_header_text_lines>) INDEX 1.
                SEARCH <fs_header_text_lines>-text FOR TEXT-f80.

                IF sy-subrc NE 0 AND NOT lt_vbkd[] IS INITIAL.

                  READ TABLE lt_vbkd ASSIGNING FIELD-SYMBOL(<fs_vbkd>) INDEX 1.
                  lv_aditivo = |{ TEXT-f80 }: { <fs_vbkd>-ihrez }|.
                  <fs_header_text_lines>-text = |{ <fs_header_text_lines>-text } { lv_aditivo }|.
                ENDIF.

                SELECT SINGLE ihrez
                FROM vbak
                WHERE vbeln = @lv_vbelv
                INTO @DATA(lv_contrato).

                SEARCH <fs_header_text_lines>-text FOR TEXT-f92.
                IF sy-subrc NE 0.
                  <fs_header_text_lines>-text = |{ <fs_header_text_lines>-text } { TEXT-f92 } { lv_contrato }|.
                ENDIF.

                IF NOT lt_eqp[] IS INITIAL.

                  SELECT invnr,
                         anln1
                    FROM anla
                     FOR ALL ENTRIES IN @lt_eqp
                   WHERE invnr EQ @lt_eqp-invnr
                    INTO TABLE @DATA(lt_anla).
                  IF sy-subrc EQ 0.
                    SORT lt_anla BY invnr.
                  ENDIF.
                ENDIF.

                CLEAR: lv_pla_imo_nfe.

                SELECT SINGLE
                  j_1bnfdoc~nfenum,
                  j_1bnfdoc~docdat
                FROM j_1bnflin
                JOIN j_1bnfdoc ON j_1bnflin~docnum = j_1bnfdoc~docnum
                WHERE refkey = @lv_xabln
                INTO @DATA(ls_doc).

                IF sy-subrc IS INITIAL.

                  CALL FUNCTION 'CONVERSION_EXIT_PDATE_OUTPUT'
                    EXPORTING
                      input        = ls_doc-docdat
                    IMPORTING
                      output       = lv_docdate
                    EXCEPTIONS
                      invalid_date = 1
                      OTHERS       = 2.
                  IF sy-subrc <> 0.
                    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
                  ENDIF.

                  lv_nfe = TEXT-f58.
                  REPLACE '&1' IN lv_nfe WITH ls_doc-nfenum.
                  REPLACE '&2' IN lv_nfe WITH lv_docdate.

                ENDIF.

                LOOP AT lt_obknr ASSIGNING <fs_obknr>.

                  CLEAR: lv_plaqueta,
                         lv_imobilizado.

                  " Plaqueta
                  IF NOT <fs_obknr>-sernr IS INITIAL.

                    lv_sernr = <fs_obknr>-sernr.

                    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                      EXPORTING
                        input  = lv_sernr
                      IMPORTING
                        output = lv_sernr.

                    lv_plaqueta = |{ TEXT-f52 }: { lv_sernr }|.

                  ENDIF.

                  " Imobilizado
                  IF NOT lv_sernr IS INITIAL.
                    READ TABLE lt_anla ASSIGNING FIELD-SYMBOL(<fs_anla>)
                                                     WITH KEY invnr = lv_sernr
                                                     BINARY SEARCH.
                    IF sy-subrc EQ 0.
                      lv_anln1 = <fs_anla>-anln1.

                      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
                        EXPORTING
                          input  = lv_anln1
                        IMPORTING
                          output = lv_anln1.

                      lv_imobilizado = |{ TEXT-f53 }: { lv_anln1 }|.

                    ENDIF.
                  ENDIF.

                  CLEAR: lv_sernr,
                         lv_anln1.

                  lv_pla_imo_nfe = |{ lv_pla_imo_nfe } { lv_plaqueta } { lv_imobilizado } { lv_nfe }|.

                ENDLOOP.

                IF NOT lv_pla_imo_nfe IS INITIAL.
                  SEARCH <fs_header_text_lines>-text FOR TEXT-f52.

                  IF sy-subrc NE 0.
                    <fs_header_text_lines>-text = |{ <fs_header_text_lines>-text } { lv_pla_imo_nfe }|.
                  ENDIF.

                  SEARCH <fs_header_text_lines>-text FOR TEXT-f53.
                  IF sy-subrc NE 0.
                    <fs_header_text_lines>-text = |{ <fs_header_text_lines>-text } { lv_pla_imo_nfe }|.
                  ENDIF.

                  SEARCH <fs_header_text_lines>-text FOR 'Referencia NFe'.
                  IF sy-subrc NE 0.
                    <fs_header_text_lines>-text = |{ <fs_header_text_lines>-text } { lv_pla_imo_nfe }|.
                  ENDIF.

                ENDIF.

              ENDIF.
            ENDIF.

            SELECT *
              FROM j_1bnfftx
              INTO TABLE @DATA(lt_nfftx)
              WHERE docnum EQ @<fs_wk_header>-docnum.
            IF sy-subrc EQ 0.

              REFRESH lt_out_lines.
              lv_linha = <fs_header_text_lines>-text.
              CALL FUNCTION 'RKD_WORD_WRAP'
                EXPORTING
                  textline            = lv_linha
                  outputlen           = 72
                TABLES
                  out_lines           = lt_out_lines
                EXCEPTIONS
                  outputlen_too_large = 1
                  OTHERS              = 2.

              SORT lt_nfftx BY seqnum DESCENDING.

              DATA(lv_seq) = VALUE #( lt_nfftx[ 1 ]-seqnum DEFAULT 0 ).
              DATA(lv_linnum) = VALUE #( lt_nfftx[ 1 ]-linnum DEFAULT 0 ).
              LOOP AT lt_out_lines ASSIGNING FIELD-SYMBOL(<fs_out_lines>).
                ADD 1 TO lv_seq.
                APPEND VALUE j_1bnfftx( mandt  = sy-mandt
                                        docnum = <fs_wk_header>-docnum
                                        seqnum = lv_seq
                                        linnum = lv_linnum
                                        message = <fs_out_lines> ) TO lt_nfftx.
              ENDLOOP.

              SORT lt_nfftx BY message.
              DELETE ADJACENT DUPLICATES FROM lt_nfftx COMPARING message.

              IF NOT lt_nfftx IS INITIAL.
                MODIFY j_1bnfftx FROM TABLE lt_nfftx[].
                IF sy-subrc EQ 0.
                  CALL FUNCTION 'DB_COMMIT'.
                ENDIF.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
