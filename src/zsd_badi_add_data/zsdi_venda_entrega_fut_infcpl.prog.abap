*&---------------------------------------------------------------------*
*& Include ZSDI_VENDA_ENTREGA_FUT_INFCPL
*&---------------------------------------------------------------------*

REFRESH lt_docflow.
CLEAR lv_vbeln.


READ TABLE it_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>) INDEX 1.
IF sy-subrc EQ 0 AND
   <fs_nflin>-itmtyp EQ '42'.

  READ TABLE it_vbrp ASSIGNING <fs_vbrp> INDEX 1.
  IF sy-subrc EQ 0.
    lv_vbeln = <fs_vbrp>-aubel.

    CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
      EXPORTING
        iv_docnum  = lv_vbeln
      IMPORTING
        et_docflow = lt_docflow.

    SORT lt_docflow BY vbtyp_n vbtyp_v.

    READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY vbtyp_n = 'C'
                                                          vbtyp_v = 'M'
                                                          BINARY SEARCH.
    IF sy-subrc EQ 0.

      DATA(lv_refkey) = CONV j_1brefkey( <fs_docflow>-vbelv ).

      SELECT SINGLE a~docnum, a~nfenum, a~series
        FROM j_1bnfdoc AS a
        INNER JOIN j_1bnflin AS b ON a~docnum = b~docnum
        INTO @DATA(ls_nfdoc)
        WHERE b~refkey = @lv_refkey.

      IF sy-subrc EQ 0.

        IF NOT ls_nfdoc-series IS INITIAL.
          DATA(lv_dados_ef) = CONV char200( |{ ls_nfdoc-nfenum }-{ ls_nfdoc-series }| ).
        ELSE.
          lv_dados_ef = ls_nfdoc-nfenum.
        ENDIF.

        lv_dados_ef = |{ TEXT-t07 } { lv_dados_ef }| .

        IF <fs_nfetx_tab> IS ASSIGNED.

          lt_nfetx = <fs_nfetx_tab>.

          SORT lt_nfetx BY seqnum DESCENDING.

          lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
          lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

          ADD 1 TO lv_seq.
          APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = lv_dados_ef ) TO <fs_nfetx_tab>.

        ENDIF.

        SEARCH es_header-infcpl FOR lv_dados_ef.
        IF sy-subrc NE 0.
          es_header-infcpl = |{ es_header-infcpl } { lv_dados_ef }|.
        ENDIF.

        CLEAR lv_dados_ef.

      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
