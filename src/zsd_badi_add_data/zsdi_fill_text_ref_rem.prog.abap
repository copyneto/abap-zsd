*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_TEXT_REF_REM
*&---------------------------------------------------------------------*

    CONSTANTS: lc_direct  TYPE char1 VALUE '2',
               lc_reftyp  TYPE char2 VALUE 'MD',
               lc_itmtypa TYPE char2 VALUE 'ZA',
               lc_itmtypb TYPE char2 VALUE 'ZB'.

    TYPES ty_t_nfe_tx TYPE TABLE OF j_1bnfftx.

    DATA lv_linha TYPE char950.

    DATA lt_out_lines TYPE TABLE OF j_1bmessag.

    FIELD-SYMBOLS <fs_nf_ftx_tab> TYPE ty_t_nfe_tx.


* Texto para remessa simbólica (triangulação na subcontratação)
    DATA: lv_text  TYPE char60,
          lv_text1 TYPE char60,
          lv_text2 TYPE char60,
          lv_text3 TYPE char60.

    CLEAR lv_linha.

    IF is_header-direct EQ lc_direct AND
       is_header-cancel EQ space.

      READ TABLE it_nflin INTO DATA(ls_lin) INDEX 1.
      IF ls_lin-reftyp = lc_reftyp AND
         ( ls_lin-itmtyp EQ lc_itmtypa OR "Componente de armazenagem item de transporte (cockpit)
           ls_lin-itmtyp EQ lc_itmtypb ). "Componente de subcontratação item de transporte (cockpit)

*        SELECT SINGLE * INTO @DATA(ls_mseg)
*        FROM mseg WHERE mblnr = @ls_lin-refkey(10) AND
*                        mjahr = @ls_lin-refkey+10(4) AND
*                        matnr = @ls_lin-matnr.

        SELECT SINGLE
          belnr, bukrs, gjahr, vbeln_im
        INTO @DATA(ls_mseg)
        FROM mseg
        WHERE mblnr = @ls_lin-refkey(10)
          AND mjahr = @ls_lin-refkey+10(4)
          AND matnr = @ls_lin-matnr.

        IF sy-subrc NE 0.

          SELECT DISTINCT ebeln, CAST( substring( concat( '000', ebelp ), 3, 6 ) AS NUMC ) AS ebelp
            FROM ekbe
           WHERE ekbe~ebeln EQ @ls_lin-xped
             AND ekbe~vgabe = '8'
            INTO TABLE @DATA(lt_ekbe).

          SELECT lips~vbeln
            FROM lips
             FOR ALL ENTRIES IN @lt_ekbe
           WHERE lips~vgbel EQ @lt_ekbe-ebeln
             AND lips~vgpos EQ @lt_ekbe-ebelp
             AND lips~matnr EQ @ls_lin-matnr
            INTO @ls_mseg-vbeln_im
           UP TO 1 ROWS.
          ENDSELECT.

        ENDIF.


        IF ls_mseg-vbeln_im IS NOT INITIAL.

*          SELECT SINGLE * INTO @DATA(ls_likp)
*          FROM likp WHERE vbeln = @ls_mseg-vbeln_im.

          SELECT SINGLE
            vbeln, inco3_l
          INTO @DATA(ls_likp)
          FROM likp
          WHERE vbeln = @ls_mseg-vbeln_im.

          IF ls_likp-inco3_l IS NOT INITIAL.

*            SELECT SINGLE * INTO @DATA(ls_innfehd)
*            FROM /xnfe/innfehd WHERE nfeid = @ls_likp-inco3_l(44).

            SELECT SINGLE
              nnf, serie, demi, cnpj_emit
            INTO @DATA(ls_innfehd)
            FROM /xnfe/innfehd
            WHERE nfeid = @ls_likp-inco3_l(44).
            IF sy-subrc EQ 0.

              DESCRIBE TABLE ct_add_info LINES DATA(lv_lines).
              lv_lines = lv_lines + 1.

              CONCATENATE TEXT-f19
                          ls_innfehd-nnf '-' ls_innfehd-serie INTO lv_text.

              SELECT SINGLE kunnr, name1
                FROM kna1
                INTO @DATA(ls_kna1)
                WHERE stcd1 = @ls_innfehd-cnpj_emit.

              DATA(lv_data) = CONV char10( |{ ls_innfehd-demi+6(2) }.{ ls_innfehd-demi+4(2) }.{ ls_innfehd-demi(4) }| ).
              lv_text1 = |{ TEXT-f89 } { lv_data }|.
              lv_text2 = |{ TEXT-f90 } { ls_kna1-kunnr }-{ ls_kna1-name1 }|.
              lv_text3 = |{ TEXT-f91 } { ls_innfehd-cnpj_emit }|.

              lv_linha = |{ TEXT-f18 } { lv_text }, { lv_text1 }, { lv_text2 } { lv_text3 } |.

              APPEND VALUE j_1bnfadd_info(
              docnum  = is_header-docnum
              xcampo  = lv_lines
              xtexto  = TEXT-f18
              xtexto2 = lv_text
              xtexto3 = lv_text1
              xtexto4 = lv_text2
              xtexto5 = lv_text3 )
              TO ct_add_info.

              lv_text = |{ TEXT-f18 } { lv_text }|.

              FIND lv_text IN cs_header-infcpl.
              IF sy-subrc NE 0.
                cs_header-infcpl = |{ cs_header-infcpl } { lv_linha }|.
              ENDIF.

              ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nf_ftx_tab>.

              IF <fs_nf_ftx_tab> IS ASSIGNED.

                REFRESH lt_out_lines.
                CALL FUNCTION 'RKD_WORD_WRAP'
                  EXPORTING
                    textline            = lv_linha
                    outputlen           = 72
                  TABLES
                    out_lines           = lt_out_lines
                  EXCEPTIONS
                    outputlen_too_large = 1
                    OTHERS              = 2.

                DATA(lt_nf_ftx) = <fs_nf_ftx_tab>.

                SORT lt_nf_ftx BY seqnum DESCENDING.

                DATA(lv_seq) = VALUE #( lt_nf_ftx[ 1 ]-seqnum DEFAULT 0 ).
                DATA(lv_linnum) = VALUE #( lt_nf_ftx[ 1 ]-linnum DEFAULT 0 ).
                LOOP AT lt_out_lines ASSIGNING FIELD-SYMBOL(<fs_out_lines>).
                  ADD 1 TO lv_seq.
                  IF <fs_nf_ftx_tab> IS ASSIGNED.
                    APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_out_lines> ) TO <fs_nf_ftx_tab>.
                  ENDIF.
                ENDLOOP.

              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    SORT ct_add_info.
    DELETE ADJACENT DUPLICATES FROM ct_add_info COMPARING ALL FIELDS.
    DELETE ct_add_info WHERE xcampo IS NOT INITIAL AND xtexto IS INITIAL.
