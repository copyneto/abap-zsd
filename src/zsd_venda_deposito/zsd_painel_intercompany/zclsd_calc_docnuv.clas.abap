CLASS zclsd_calc_docnuv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_values,
                 tmfo TYPE vbtypl VALUE 'TMFO',
               END OF gc_values.

ENDCLASS.



CLASS zclsd_calc_docnuv IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_calculated_data TYPE STANDARD TABLE OF zi_sd_01_cockpit WITH DEFAULT KEY,
          lt_docflow         TYPE tdt_docflow.

    lt_calculated_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
        EXPORTING
          iv_docnum        = <fs_data>-remessa
          iv_self_if_empty = space
        IMPORTING
          et_docflow       = lt_docflow.

      IF lt_docflow IS NOT INITIAL.
        <fs_data>-docnuv = VALUE #( lt_docflow[ vbtyp_n = gc_values-tmfo ]-docnuv OPTIONAL ).
      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

     APPEND 'FORN' TO et_requested_orig_elements.

  ENDMETHOD.

ENDCLASS.
