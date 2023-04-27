CLASS zclsd_cds_cfop DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CDS_CFOP IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    APPEND 'CFOP1' TO et_requested_orig_elements.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_cfop_entity WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).


    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'CONVERSION_EXIT_CFOBR_OUTPUT'
        EXPORTING
          input  = <fs_data>-cfop1
        IMPORTING
          output = <fs_data>-cfop.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.
ENDCLASS.
