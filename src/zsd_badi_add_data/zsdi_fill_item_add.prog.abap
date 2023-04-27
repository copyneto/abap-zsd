*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_ITEM_ADD
*&---------------------------------------------------------------------*
    DATA: lt_tlines TYPE TABLE OF tline,
          lv_tlines TYPE char120,
          lv_name   TYPE thead-tdname.


    CONSTANTS: lc_he   TYPE numtp VALUE 'HE',
               lc_cean TYPE char8 VALUE 'SEM GTIN'.

    INCLUDE zsdi_add_tax_cst60_f02 IF FOUND.
    INCLUDE zsdi_add_cest_f01 IF FOUND.
    INCLUDE zsdi_add_unit_exp_f01 IF FOUND.

    IF NOT it_nflin IS INITIAL.
      SELECT matnr, meinh, eantp, ean11
        FROM mean
        INTO TABLE @DATA(lt_mean)
        FOR ALL ENTRIES IN @it_nflin
        WHERE matnr EQ @it_nflin-matnr
          AND meinh EQ @it_nflin-meins.
    ENDIF.

    LOOP AT it_nflin INTO DATA(ls_items).

      gv_total_menge = gv_total_menge + ls_items-menge."-->Usado no METHOD fill_trans_vol.

      READ TABLE ct_item ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY itmnum = ls_items-itmnum BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF ls_items-itmtyp NE '02'. "Item Transferência
          <fs_item>-nitemped  = ls_items-itmnum.
        ENDIF.
*        <fs_item>-cean      = lc_cean.
*        <fs_item>-cean_trib = lc_cean.

        IF NOT ls_items-cean IS INITIAL AND
           <fs_item>-cean    IS INITIAL.
          <fs_item>-cean = ls_items-cean.
        ENDIF.

        IF <fs_item>-cean_trib IS INITIAL OR
           <fs_item>-cean      IS INITIAL.

          IF <fs_item>-cean IS INITIAL AND
             NOT ls_items-meins IS INITIAL.
            TRY.
                <fs_item>-cean = lt_mean[ matnr = ls_items-matnr
                                          meinh = ls_items-meins ]-ean11.
              CATCH cx_sy_itab_line_not_found.
                TRY .
                    <fs_item>-cean = lt_mean[ matnr = ls_items-matnr
                                              eantp = lc_he ]-ean11.
                    <fs_item>-cean_trib = <fs_item>-cean.
                  CATCH cx_sy_itab_line_not_found.
                ENDTRY.
            ENDTRY.
          ENDIF.

          IF <fs_item>-cean_trib IS INITIAL AND
             NOT ls_items-cean   IS INITIAL.
            <fs_item>-cean_trib = ls_items-cean.
          ELSEIF <fs_item>-cean_trib IS INITIAL AND
                 ls_items-cean       IS INITIAL.
            <fs_item>-cean_trib = lc_cean.
            <fs_item>-cean      = lc_cean.
          ENDIF.

        ENDIF.

        INCLUDE zsdi_add_tax_cst60_f01 IF FOUND.
        INCLUDE zsdi_add_cest_f02 IF FOUND.
        INCLUDE zsdi_add_unit_exp_f02 IF FOUND.

        lv_name = ls_items-matnr.

        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            id                      = 'GRUN'
            language                = sy-langu
            name                    = lv_name
            object                  = 'MATERIAL'
          TABLES
            lines                   = lt_tlines
          EXCEPTIONS
            id                      = 1
            language                = 2
            name                    = 3
            not_found               = 4
            object                  = 5
            reference_check         = 6
            wrong_access_to_archive = 7
            OTHERS                  = 8.

        IF sy-subrc = 0 .
          LOOP AT lt_tlines ASSIGNING FIELD-SYMBOL(<fs_tlines>).
            lv_tlines = |{ lv_tlines }| & | | & |{ <fs_tlines>-tdline }|.
          ENDLOOP.
          <fs_item>-xprod = lv_tlines.
          CONDENSE <fs_item>-xprod.
          CLEAR: lv_tlines.
        ELSE.
          CLEAR:<fs_item>-xprod.
        ENDIF.

      ENDIF.
    ENDLOOP.
