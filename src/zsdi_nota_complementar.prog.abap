*&---------------------------------------------------------------------*
*& Include          ZSDI_NOTA_COMPLEMENTAR
*&---------------------------------------------------------------------*

DATA: lv_ref      TYPE char10,
      lv_data     TYPE char10,
      lv_msg_comp TYPE char100.

FIELD-SYMBOLS <fs_wnfdoc> TYPE j_1bnfdoc.

* Rejeição 435: NF-e não pode ter o indicativo do intermediador
IF  is_header-doctyp = '2' OR  is_header-doctyp = '3' OR  is_header-doctyp = '4'.
  cs_header-indintermed = abap_false.
ENDIF.


IF is_header-observat IS INITIAL AND is_header-doctyp = '2'." OR  is_header-doctyp = '3' OR  is_header-doctyp = '4' OR  is_header-doctyp = '6' ).
  ASSIGN ('(SAPLJ1BG)WNFDOC') TO <fs_wnfdoc>.
  IF <fs_wnfdoc> IS ASSIGNED.
    IF NOT is_header-observat IS INITIAL.
      SPLIT is_header-observat AT ',' INTO lv_ref lv_data.
    ELSE.
      SELECT SINGLE nfenum, docdat
        FROM j_1bnfdoc
        INTO ( @DATA(lv_nfenum1), @DATA(lv_date) )
        WHERE docnum = @is_header-docref.
      IF sy-subrc EQ 0.
        CLEAR lv_data.
        lv_data = |{ lv_date+6(2) }.{ lv_date+4(2) }.{ lv_date(4) }|.
        lv_ref = lv_nfenum1.
      ENDIF.
    ENDIF.

    <fs_wnfdoc>-observat = |{ TEXT-f63 }{ lv_ref },{ TEXT-f64 }{ lv_data }|.

    lv_msg_comp = |{ TEXT-f87 } { lv_ref } { TEXT-f88 } { lv_data }|.
    SEARCH cs_header-infcpl FOR lv_msg_comp .
    IF sy-subrc NE 0.
      cs_header-infcpl = |{ cs_header-infcpl }  { lv_msg_comp }|.

      IF <fs_nfetx_tab> IS ASSIGNED.
        lt_nfetx = <fs_nfetx_tab>.

        SORT lt_nfetx BY seqnum DESCENDING.

        lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
        lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).
        ADD 1 TO lv_seq.
        APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = lv_msg_comp ) TO <fs_nfetx_tab>.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
