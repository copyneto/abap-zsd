*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_TEXT_FATURA
*&---------------------------------------------------------------------*
    DATA: lv_refer  TYPE thead-tdname,
          lt_txtfat TYPE TABLE OF tline.


    READ TABLE it_vbrp ASSIGNING FIELD-SYMBOL(<fs_refer>) INDEX 1.
    IF <fs_refer> IS ASSIGNED.
      lv_refer = <fs_refer>-aubel.
    ENDIF.

    DESCRIBE TABLE ct_add_info LINES DATA(lv_lines).

    IF lv_refer IS NOT INITIAL.

      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          id                      = 'Z001'
          language                = sy-langu
          name                    = lv_refer
          object                  = 'VBBK'
        TABLES
          lines                   = lt_txtfat
        EXCEPTIONS
          id                      = 1
          language                = 2
          name                    = 3
          not_found               = 4
          object                  = 5
          reference_check         = 6
          wrong_access_to_archive = 7
          OTHERS                  = 8.

      IF sy-subrc <> 0.
        FREE lt_txtfat.
      ENDIF.

      LOOP AT lt_txtfat ASSIGNING FIELD-SYMBOL(<fs_txt>).
        DATA(lv_tabix) = sy-tabix.

        lv_lines = lv_lines + 1.

        APPEND VALUE j_1bnfadd_info(
        docnum  = is_header-docnum
        xcampo  = lv_lines
        xtexto  = <fs_txt>-tdline+00(60)
        xtexto2 = <fs_txt>-tdline+60     )
        TO ct_add_info.

        lt_nfetx = <fs_nfetx_tab>.

        SORT lt_nfetx BY seqnum DESCENDING.

        IF lv_tabix = 1.
          lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
          lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

          ADD 1 TO lv_seq.
        ELSE.
          ADD 1 TO lv_linnum.
        ENDIF.

        IF <fs_nfetx_tab> IS ASSIGNED.
          APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_txt>-tdline+00(60) ) TO <fs_nfetx_tab>.

          IF <fs_txt>-tdline+60 IS NOT INITIAL.
            ADD 1 TO lv_linnum.
            APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_txt>-tdline+60 ) TO <fs_nfetx_tab>.
          ENDIF.

          cs_header-infcpl = |{ cs_header-infcpl }  { <fs_txt>-tdline }|.
        ENDIF.

      ENDLOOP.

    ELSE.

      READ TABLE it_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin_aux_typ>) INDEX 1.
      IF sy-subrc = 0.
        DATA(lv_reftyp) = <fs_nflin_aux_typ>-reftyp.
      ENDIF.

      FIELD-SYMBOLS <fs_delivery> TYPE vbeln_vl.
      ASSIGN ('(SAPLV50L)DELIVERY') TO <fs_delivery>.
      IF <fs_delivery> IS ASSIGNED AND <fs_delivery> IS NOT INITIAL.
        LOOP AT ct_add_info ASSIGNING FIELD-SYMBOL(<fs_add_info>).
          IF <fs_add_info>-xcampo = 'REMESSA'.
            <fs_add_info>-xtexto = <fs_delivery>.
          ENDIF.
        ENDLOOP.
        IF lv_reftyp = 'MD'.
          DELETE ADJACENT DUPLICATES FROM ct_add_info COMPARING docnum.
        ENDIF.
      ENDIF.
    ENDIF.

    SORT ct_add_info.
    DELETE ADJACENT DUPLICATES FROM ct_add_info COMPARING ALL FIELDS.
    DELETE ct_add_info WHERE xcampo IS NOT INITIAL AND xtexto IS INITIAL.
