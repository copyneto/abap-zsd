*&---------------------------------------------------------------------*
*& Include          ZMMI_ADD_INTERCOMPANY_INFCPL
*&---------------------------------------------------------------------*
SORT lt_nflin BY reftyp.
READ TABLE lt_nflin ASSIGNING FIELD-SYMBOL(<fs_transf>) WITH KEY reftyp = 'MD' BINARY SEARCH.
IF <fs_transf> IS ASSIGNED.

*  SELECT SINGLE ebeln
*  FROM mseg
*  INTO @DATA(lv_ebeln)
*  WHERE mblnr EQ @<fs_transf>-refkey(10)
*    AND mjahr EQ @<fs_transf>-refkey+10(4)
*    AND zeile EQ 1.
*  IF sy-subrc IS INITIAL.

  TYPES: BEGIN OF ty_intercompany,
           purchaseorder TYPE ztsd_intercompan-purchaseorder,
         END OF ty_intercompany.

  DATA lt_nflin_conv TYPE TABLE OF ty_intercompany.

  DATA(lt_nflin_aux) = lt_nflin[].
  FREE: lt_nflin_aux[].

  LOOP AT lt_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin_aux>).
    IF <fs_nflin_aux>-xped IS NOT INITIAL.
      APPEND <fs_nflin_aux> TO lt_nflin_aux.
    ENDIF.
  ENDLOOP.

  IF lt_nflin_aux[] IS NOT INITIAL.
    lt_nflin_conv = CORRESPONDING #( lt_nflin_aux MAPPING purchaseorder = xped ).

    SORT lt_nflin_conv BY purchaseorder.

    DELETE ADJACENT DUPLICATES FROM lt_nflin_conv
                          COMPARING purchaseorder.
  ENDIF.

*  IF lv_ebeln IS NOT INITIAL.
  IF lt_nflin_conv IS NOT INITIAL.

    SELECT purchaseorder,
           txtnf
    FROM ztsd_intercompan
     FOR ALL ENTRIES IN @lt_nflin_conv
   WHERE purchaseorder EQ @lt_nflin_conv-purchaseorder
    INTO TABLE @DATA(lt_intercompany).

    IF lt_intercompany IS NOT INITIAL.

      ASSIGN ('(SAPLJ1BG)WNFFTX[]') TO <fs_nfetx_tab>.
      IF NOT <fs_nfetx_tab> IS ASSIGNED.
        ASSIGN ('(SAPLJ1BF)WA_NF_FTX[]') TO <fs_nfetx_tab>.
      ENDIF.

      IF <fs_nfetx_tab> IS ASSIGNED.
        lt_nfetx = <fs_nfetx_tab>.

        SORT lt_nfetx BY seqnum DESCENDING.

        lv_seq = VALUE #( lt_nfetx[ 1 ]-seqnum DEFAULT 0 ).
        lv_linnum = VALUE #( lt_nfetx[ 1 ]-linnum DEFAULT 0 ).

        LOOP AT lt_intercompany ASSIGNING FIELD-SYMBOL(<fs_intercompany>).
          ADD 1 TO lv_seq.
          APPEND VALUE j_1bnfftx( seqnum = lv_seq linnum = lv_linnum message = <fs_intercompany>-txtnf ) TO <fs_nfetx_tab>.
          SEARCH cs_header-infcpl FOR <fs_intercompany>-txtnf.
          IF sy-subrc NE 0.
            cs_header-infcpl = |{ cs_header-infcpl }  { <fs_intercompany>-txtnf }|.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDIF.
ENDIF.
