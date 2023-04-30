*&---------------------------------------------------------------------*
*& Include ZSDI_NFE_ENTRAD_COMODATO
*&---------------------------------------------------------------------*

  DATA: ls_active_edit TYPE j_1bnfe_active.

  FIELD-SYMBOLS: <fs_wa_nf_doc> TYPE j_1bnfdoc.

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
                        docnum9
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

      IF sy-subrc IS INITIAL.
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