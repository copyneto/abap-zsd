CLASS zclsd_ckpt_fat_valmin DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CKPT_FAT_VALMIN IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_ckpt_fat_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data[] IS NOT INITIAL.
      SELECT k~vbeln,
             k~knumv,
             e~kbetr
        INTO TABLE @DATA(lt_vbak)
        FROM vbak AS k
        INNER JOIN prcd_elements AS e ON e~knumv = k~knumv
                                     AND e~kposn = @space
                                     AND e~kschl = 'ZMIN'
       FOR ALL ENTRIES IN @lt_original_data
       WHERE k~vbeln = @lt_original_data-salesorder.

      IF sy-subrc IS INITIAL.

        SORT lt_vbak BY vbeln.

      ENDIF.
    ENDIF.

    IF lt_original_data[] IS NOT INITIAL.
      SELECT p~vbeln,
             p~posnr,
             k~knumv,
             e~lmeng,
             d~kbetr
        INTO TABLE @DATA(lt_vbap)
        FROM vbap AS p
        INNER JOIN vbep AS e ON e~vbeln = p~vbeln
                            AND e~posnr = p~posnr
        INNER JOIN vbak AS k ON k~vbeln = p~vbeln
        INNER JOIN prcd_elements AS d ON d~knumv = k~knumv
                                     AND d~kposn = p~vgpos
                                     AND d~kschl = 'ZPR0'
        FOR ALL ENTRIES IN @lt_original_data
        WHERE p~vbeln = @lt_original_data-salesorder
          AND p~abgru = @space
          AND p~lfgsa = 'A'.

      IF sy-subrc IS INITIAL.

        SORT lt_vbap BY vbeln knumv.

      ENDIF.
    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).


      READ TABLE  lt_vbak INTO DATA(ls_vbak) WITH KEY  vbeln = <fs_data>-salesorder BINARY SEARCH.

      IF sy-subrc IS INITIAL AND ls_vbak-kbetr IS NOT INITIAL.

        READ TABLE lt_vbap TRANSPORTING NO FIELDS WITH KEY vbeln = ls_vbak-vbeln
                                                           knumv = ls_vbak-knumv BINARY SEARCH.

        IF sy-subrc IS INITIAL.
          LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>) FROM sy-tabix.
            IF <fs_vbap>-vbeln <> <fs_vbap>-vbeln OR
               <fs_vbap>-knumv <> <fs_vbap>-knumv.
              EXIT.
            ENDIF.

            DATA(lv_valor) = <fs_vbap>-lmeng * <fs_vbap>-kbetr.

            IF lv_valor < <fs_vbap>-kbetr.
              <fs_data>-valormin = abap_true.
              EXIT.
            ENDIF.

          ENDLOOP.
        ENDIF.

      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'SALESORDER' TO et_requested_orig_elements.
  ENDMETHOD.
ENDCLASS.
