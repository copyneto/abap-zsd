*&---------------------------------------------------------------------*
*& Include ZSDI_QUEBRA_LOTE_XML
*&---------------------------------------------------------------------*
  FIELD-SYMBOLS:
    <fs_wa_nf_lin_xml> TYPE j_1bnflin_tab,
    <fs_wa_nf_stx_xml> TYPE j_1bnfstx_tab,
    <fs_wk_item_xml>   TYPE j_1bnflin_tab.

  IF is_header-land1 = 'BR' AND
     check_coligada( is_header ) IS INITIAL.
    DATA(ls_nflin_index1) = VALUE #( it_nflin[ 1 ] OPTIONAL ).

    IF ls_nflin_index1-itmtyp <> '2'  AND
       ls_nflin_index1-itmtyp <> '72' AND                     "Inclusão de condição para Comodato - VARAUJO 23.05.2023 - Def. 8000007682
       ls_nflin_index1-itmtyp <> '75'.                        "Inclusão de condição para Locação  - VARAUJO 24.05.2023 - Def. 8000007649
      ASSIGN ('(SAPLJ1BF)WA_NF_LIN[]') TO <fs_wa_nf_lin_xml>.
      ASSIGN ('(SAPLJ1BF)WA_NF_STX[]') TO <fs_wa_nf_stx_xml>.
      IF <fs_wa_nf_lin_xml> IS ASSIGNED AND <fs_wa_nf_stx_xml> IS ASSIGNED.
        SORT <fs_wa_nf_lin_xml> BY docnum matnr itmnum.
        DELETE ADJACENT DUPLICATES FROM <fs_wa_nf_lin_xml> COMPARING docnum matnr.
        SORT <fs_wa_nf_lin_xml> BY docnum itmnum.
        LOOP AT <fs_wa_nf_stx_xml> INTO DATA(ls_wa_nf_stx).
          DATA(li_tabix) = sy-tabix.
          IF NOT line_exists( <fs_wa_nf_lin_xml>[ docnum = ls_wa_nf_stx-docnum itmnum = ls_wa_nf_stx-itmnum ] ).
            DELETE <fs_wa_nf_stx_xml> INDEX li_tabix.
          ENDIF.
        ENDLOOP.
      ENDIF.

      ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM[]') TO <fs_wk_item_xml>.
      IF <fs_wk_item_xml> IS ASSIGNED.
        SORT <fs_wk_item_xml> BY docnum matnr itmnum.
        DELETE ADJACENT DUPLICATES FROM <fs_wk_item_xml> COMPARING docnum matnr.
        SORT <fs_wk_item_xml> BY docnum itmnum.
      ENDIF.
    ENDIF.
  ENDIF.
