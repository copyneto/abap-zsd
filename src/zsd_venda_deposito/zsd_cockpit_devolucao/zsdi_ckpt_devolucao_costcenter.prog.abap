*&---------------------------------------------------------------------*
*& Include ZSDI_CKPT_DEVOLUCAO_COSTCENTER
*&---------------------------------------------------------------------*
DATA lt_fat_dev TYPE TABLE OF vbrp.

TYPES: ty_t_item TYPE TABLE OF bapisditm.

FIELD-SYMBOLS: <fs_dev_items_in> TYPE ty_t_item.

ASSIGN ('(SAPLZFGSD_GERA_OV_DEVOLUCAO)GT_ITEMS_IN[]') TO <fs_dev_items_in>.

IF <fs_dev_items_in> IS ASSIGNED.

  SELECT *
    FROM vbrp
    INTO TABLE lt_fat_dev
    FOR ALL ENTRIES IN <fs_dev_items_in>
    WHERE vbeln = <fs_dev_items_in>-ref_doc
      AND posnr = <fs_dev_items_in>-ref_doc_it.

  IF lt_fat_dev IS NOT INITIAL.

    SORT lt_fat_dev  BY vbeln posnr.

    LOOP AT xvbap[] ASSIGNING FIELD-SYMBOL(<fs_ordem_item>).
      READ TABLE lt_fat_dev  ASSIGNING FIELD-SYMBOL(<fs_fat_item>) WITH KEY vbeln = <fs_ordem_item>-vgbel
                                                                            posnr = <fs_ordem_item>-vgpos BINARY SEARCH.

      IF <fs_fat_item> IS ASSIGNED AND <fs_fat_item>-kostl IS NOT INITIAL.
        <fs_ordem_item>-kostl = <fs_fat_item>-kostl.
        vbap-kostl            = <fs_fat_item>-kostl.
      ENDIF.

    ENDLOOP.

  ENDIF.
ENDIF.
