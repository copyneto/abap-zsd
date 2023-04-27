CLASS zclsd_conversion_parvw DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CONVERSION_PARVW IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_contr_loc_comodato_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data[] IS NOT INITIAL.
      SELECT vbeln, parvw
          INTO TABLE @DATA(lt_vbpa)
          FROM vbpa
          FOR ALL ENTRIES IN @lt_original_data
          WHERE vbeln = @lt_original_data-salescontract
            AND parvw = 'AG'.
      IF sy-subrc IS INITIAL.
        SORT lt_vbpa BY vbeln.

        SELECT parvw, vtext
            INTO TABLE @DATA(lt_tpart)
            FROM tpart
            FOR ALL ENTRIES IN @lt_vbpa
            WHERE parvw = @lt_vbpa-parvw
             AND spras = @sy-langu.
        IF sy-subrc IS INITIAL.
          SORT lt_tpart BY parvw.
        ENDIF.

      ENDIF.
    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WITH KEY vbeln =  <fs_data>-salescontract BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_PARVW_OUTPUT'
          EXPORTING
            input  = <fs_vbpa>-parvw
          IMPORTING
            output = <fs_data>-partnerfunction.
      ENDIF.

      <fs_data>-partnerfunctionname = VALUE #( lt_tpart[ parvw = <fs_vbpa>-parvw ]-vtext  DEFAULT '' ).

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
