*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_ITEM_ADD
*&---------------------------------------------------------------------*
    DATA: lt_tlines TYPE TABLE OF tline,
          lv_tlines TYPE char120,
          lv_name   TYPE thead-tdname.

* LSCHEPP - 8000007104 - Unidade tributária XML - 09.05.2023 Início
    DATA: lv_matnr   TYPE mara-matnr,
          lv_in_me   TYPE mara-meins,
          lv_out_me  TYPE mara-meins,
          lv_menge_i TYPE ekpo-menge,
          lv_menge_o TYPE ekpo-menge.
* LSCHEPP - 8000007104 - Unidade tributária XML - 09.05.2023 Fim

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
        WHERE matnr EQ @it_nflin-matnr.
* LSCHEPP - 8000007138 - CORE 11 - Tag <cEANTrib> do XML - 09.05.2023 Início
*          AND meinh EQ @it_nflin-meins.

      SELECT matnr, meins
        FROM mara
        INTO TABLE @DATA(lt_mara)
        FOR ALL ENTRIES IN @it_nflin
        WHERE matnr EQ @it_nflin-matnr.
* LSCHEPP - 8000007138 - CORE 11 - Tag <cEANTrib> do XML - 09.05.2023 Fim
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

* LSCHEPP - 8000007138 - CORE 11 - Tag <cEANTrib> do XML - 09.05.2023 Início
        READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>) WITH KEY matnr = ls_items-matnr BINARY SEARCH.
        IF sy-subrc EQ 0.
          IF <fs_mara>-meins NE ls_items-meins.
            TRY.
                <fs_item>-cean_trib = lt_mean[ matnr = ls_items-matnr
                                               meinh = <fs_mara>-meins
                                               eantp = lc_he ]-ean11.
              CATCH cx_sy_itab_line_not_found.
            ENDTRY.
* LSCHEPP - 8000007104 - Unidade tributária XML - 09.05.2023 Início
            <fs_item>-meins_trib = <fs_mara>-meins.

            lv_matnr   = ls_items-matnr.
            lv_in_me   = ls_items-meins.
            lv_out_me  = <fs_mara>-meins.
            lv_menge_i = ls_items-menge.

            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = lv_matnr
                i_in_me              = lv_in_me
                i_out_me             = lv_out_me
                i_menge              = lv_menge_i
              IMPORTING
                e_menge              = lv_menge_o
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.
            IF sy-subrc EQ 0.
              <fs_item>-menge_trib = lv_menge_o.
            ENDIF.

            CLEAR: lv_matnr,
                   lv_in_me,
                   lv_out_me,
                   lv_menge_i.
* LSCHEPP - 8000007104 - Unidade tributária XML - 09.05.2023 Fim
          ENDIF.
        ENDIF.
* LSCHEPP - 8000007138 - CORE 11 - Tag <cEANTrib> do XML - 09.05.2023 Fim

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
