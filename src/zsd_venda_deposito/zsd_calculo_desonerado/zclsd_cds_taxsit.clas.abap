CLASS zclsd_cds_taxsit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CDS_TAXSIT IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_taxsit_entity WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).


    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'CONVERSION_EXIT_TXSIT_OUTPUT'
        EXPORTING
          input  = <fs_data>-taxsit1
        IMPORTING
          output = <fs_data>-taxsit.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    APPEND 'TAXSIT1' TO et_requested_orig_elements.

  ENDMETHOD.
ENDCLASS.
