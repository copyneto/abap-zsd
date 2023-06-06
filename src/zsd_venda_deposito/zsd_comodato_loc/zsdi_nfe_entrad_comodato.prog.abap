*&---------------------------------------------------------------------*
*& Include ZSDI_NFE_ENTRAD_COMODATO
*&---------------------------------------------------------------------*

  DATA: ls_active_edit TYPE j_1bnfe_active.

  FIELD-SYMBOLS: <fs_wa_nf_doc> TYPE j_1bnfdoc.
  FIELD-SYMBOLS: <fs_imseg> TYPE ty_t_imseg.

  IF is_header-nftype EQ 'Y6'.

    ASSIGN ('(SAPLJ1BF)WA_NF_DOC') TO <fs_wa_nf_doc>.
    IF <fs_wa_nf_doc> IS ASSIGNED.

      IF <fs_wa_nf_doc>-authcod  IS INITIAL
      OR <fs_wa_nf_doc>-authdate IS INITIAL
      OR <fs_wa_nf_doc>-authtime IS INITIAL.

        SELECT docnum,
               refkey,
               refitm
          FROM j_1bnflin
         WHERE refkey = @is_mkpf-xblnr
          INTO @DATA(ls_lin)
          UP TO 1 ROWS.
        ENDSELECT.

        IF sy-subrc EQ 0.

          DATA(lv_docnum_aux) = ls_lin-docnum.

        ELSE.

          SELECT SINGLE a~docnum, a~nfenum
            FROM j_1bnfdoc AS a
            INNER JOIN j_1bnflin AS b ON a~docnum = b~docnum
            INTO @DATA(ls_nfdoc_aux)
            WHERE b~refkey = @is_mkpf-xabln.
          IF sy-subrc EQ 0 AND
             ls_nfdoc_aux-nfenum EQ is_mkpf-xblnr.
            lv_docnum_aux = ls_nfdoc_aux-docnum.
          ENDIF.

        ENDIF.

        IF NOT lv_docnum_aux IS INITIAL.

          SELECT SINGLE docnum,
                        authcod,
                        docnum9,
                        tpemis
            FROM j_1bnfe_active
           WHERE docnum = @lv_docnum_aux
            INTO @DATA(ls_active).

          IF sy-subrc IS INITIAL.
            <fs_wa_nf_doc>-authcod  = ls_active-authcod.
            <fs_wa_nf_doc>-authdate = sy-datum.
            <fs_wa_nf_doc>-authtime = sy-uzeit.
          ENDIF.

        ENDIF.

        CALL FUNCTION 'J_1B_NFE_DATA_READ'
          IMPORTING
            es_active = ls_active_edit.

        ls_active_edit-docnum9 = ls_active-docnum9.

        IF ls_active-tpemis <> ls_active_edit-tpemis.

          ASSIGN ('(SAPLMBWL)IMSEG[]') TO <fs_imseg>.
          IF <fs_imseg> IS ASSIGNED.
            IF <fs_imseg>[] IS NOT INITIAL AND
              ( <fs_imseg>[ 1 ]-bwart EQ 'YG5' OR <fs_imseg>[ 1 ]-bwart EQ 'YG7' ).
              ls_active_edit-tpemis = ls_active-tpemis.
            ENDIF.
          ENDIF.

        ENDIF.

        CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
          EXPORTING
            is_active = ls_active_edit.

      ENDIF.

    ENDIF.

  ELSEIF is_header-nftype EQ 'IK'.

    ASSIGN ('(SAPLJ1BG)WNFDOC') TO <fs_wa_nf_doc>.
    IF <fs_wa_nf_doc> IS ASSIGNED.

      SELECT SINGLE
             docnum,
             nfenum
        FROM j_1bnfdoc
       WHERE nfenum = @is_header-nfenum
         AND nftype = 'IG'
         AND docdat = @sy-datum
        INTO @DATA(ls_doc_ik).

      IF sy-subrc IS NOT INITIAL.

        SELECT SINGLE
            _doc~docnum,
            _doc~nfenum,
            _doc~docdat,
            _lin~refkey
          FROM j_1bnfdoc AS _doc
          JOIN j_1bnflin AS _lin ON _doc~docnum = _lin~docnum
         WHERE nfenum = @is_header-nfenum
           AND nftype = 'IG'
          INTO @DATA(ls_ref).

        IF ls_ref IS NOT INITIAL.

          SELECT SINGLE bwart
          FROM mseg
          WHERE mblnr EQ @ls_ref-refkey(10)
            AND mjahr EQ @ls_ref-refkey+10(4)
            AND xblnr_mkpf EQ @is_header-nfenum
            AND bwart IN ( 'YG6', 'YG8' )
          INTO @DATA(lv_bwart).

          IF sy-subrc IS INITIAL.
            ls_doc_ik-docnum = ls_ref-docnum.
            ls_doc_ik-nfenum = ls_ref-nfenum.

            IF <fs_wa_nf_doc>-docdat <> ls_ref-docdat.
              <fs_wa_nf_doc>-docdat = ls_ref-docdat.
            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

      IF ls_doc_ik IS NOT INITIAL.

        SELECT SINGLE docnum,
                      authcod,
                      authdate,
                      authtime,
                      docnum9
          FROM j_1bnfe_active
         WHERE docnum = @ls_doc_ik-docnum
          INTO @DATA(ls_active_ik).

        IF sy-subrc IS INITIAL.
          <fs_wa_nf_doc>-authcod  = ls_active_ik-authcod.
          <fs_wa_nf_doc>-authdate = ls_active_ik-authdate.
          <fs_wa_nf_doc>-authtime = ls_active_ik-authtime.
        ENDIF.

        CALL FUNCTION 'J_1B_NFE_DATA_READ'
          IMPORTING
            es_active = ls_active_edit.

        ls_active_edit-docnum9 = ls_active_ik-docnum9.

        CALL FUNCTION 'J_1B_NFE_DATA_TRANSFER'
          EXPORTING
            is_active = ls_active_edit.
      ENDIF.
    ENDIF.
  ENDIF.
