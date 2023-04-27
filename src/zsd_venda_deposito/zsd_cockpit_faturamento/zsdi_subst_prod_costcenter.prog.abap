*&---------------------------------------------------------------------*
*& Include ZSDI_SUBST_PROD_COSTCENTER
*&---------------------------------------------------------------------*
TYPES: ty_t_sub_prod TYPE TABLE OF zssd_sub_prod_costcenter.

FIELD-SYMBOLS: <fs_sub_prod> TYPE ty_t_sub_prod.

ASSIGN ('(SAPLZFGSD_SUBSTITUIR_PRODUTO)GT_COSTCENTER[]') TO <fs_sub_prod>.

IF  <fs_sub_prod> IS ASSIGNED.

  SORT xvbap[]  BY vbeln posnr.

  LOOP AT  <fs_sub_prod> ASSIGNING FIELD-SYMBOL(<fs_s_sub_prod>).
    READ TABLE xvbap[]  ASSIGNING FIELD-SYMBOL(<fs_sub_prod_item>) WITH KEY vbeln = <fs_s_sub_prod>-vbeln
                                                                            posnr = <fs_s_sub_prod>-posnr BINARY SEARCH.

    IF <fs_sub_prod_item> IS ASSIGNED AND <fs_sub_prod_item>-kostl IS NOT INITIAL.
      READ TABLE xvbap[] ASSIGNING FIELD-SYMBOL(<fs_sub_prod_item_new>) WITH KEY vbeln = <fs_s_sub_prod>-vbeln
                                                                                 posnr = <fs_s_sub_prod>-posnr_new BINARY SEARCH.
      IF <fs_sub_prod_item_new> IS ASSIGNED .
        <fs_sub_prod_item_new>-kostl = <fs_sub_prod_item>-kostl.
        vbap-kostl                   = <fs_sub_prod_item>-kostl.
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDIF.
