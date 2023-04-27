*&---------------------------------------------------------------------*
*& Include          ZSDI_ADD_LPP_F02
*&---------------------------------------------------------------------*
  DATA: ls_header	TYPE j_1bnfdoc,
        lt_item	  TYPE j_1bnflin_tab.

  ASSIGN ('(SAPLJ1BG)WNFDOC') TO FIELD-SYMBOL(<fs_wnfdoc>).

  if <fs_wnfdoc> is ASSIGNED.
    ls_header = <fs_wnfdoc>.
    APPEND LINES OF ct_nflin TO lt_item.


    DATA(lo_tax_values) = NEW zclsd_get_tax_values( is_header = ls_header it_item = lt_item ).

    LOOP AT ct_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).
      <fs_nflin>-lppbrt = lo_tax_values->get_last_purchase( is_item = <fs_nflin> ).
    ENDLOOP.
    UNASSIGN <fs_wnfdoc>.
  ENDIF.
