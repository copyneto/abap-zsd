*&---------------------------------------------------------------------*
*& Include          ZSDI_INFADFISCO_INFCPL
*&---------------------------------------------------------------------*

REFRESH lt_out_lines.
CLEAR lv_linha.

ASSIGN ('(SAPLJ1BG)WNFFTX[]') TO <fs_nfetx_tab>.
IF NOT <fs_nfetx_tab> IS ASSIGNED.
  ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.
ENDIF.

IF NOT cs_header-infadfisco IS INITIAL.

  IF <fs_nfetx_tab> IS ASSIGNED.

    lv_linha = cs_header-infadfisco.

    CALL FUNCTION 'RKD_WORD_WRAP'
      EXPORTING
        textline            = lv_linha
        outputlen           = 72
      TABLES
        out_lines           = lt_out_lines
      EXCEPTIONS
        outputlen_too_large = 1
        OTHERS              = 2.

    lt_nfetx = <fs_nfetx_tab>.

    SORT lt_nfetx BY seqnum DESCENDING.

    lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
    lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

    LOOP AT lt_out_lines ASSIGNING <fs_out_lines>.
      ADD 1 TO lv_seq.
      IF <fs_nfetx_tab> IS ASSIGNED.
        APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_out_lines> ) TO <fs_nfetx_tab>.
      ENDIF.
    ENDLOOP.

    SEARCH cs_header-infcpl FOR cs_header-infadfisco.
    IF sy-subrc NE 0.
      cs_header-infcpl = |{ cs_header-infcpl } { cs_header-infadfisco }|.
    ENDIF.

  ENDIF.

ENDIF.
