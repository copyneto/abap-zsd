CLASS zclsd_conversion_gernr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CONVERSION_GERNR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_contr_loc_comodato_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data[] IS NOT INITIAL.
      SELECT s~obknr, s~sdaufnr, s~posnr, k~sernr
          INTO TABLE @DATA(lt_ser02)
          FROM ser02 AS s
          INNER JOIN objk AS k ON k~obknr = s~obknr
          FOR ALL ENTRIES IN @lt_original_data
          WHERE s~sdaufnr = @lt_original_data-salescontract
            AND s~posnr = @lt_original_data-salescontractitem.
      IF sy-subrc IS INITIAL.
        SORT lt_ser02 BY sdaufnr posnr.
      ENDIF.
    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_ser02 ASSIGNING FIELD-SYMBOL(<fs_ser02>) WITH KEY  sdaufnr = <fs_data>-salescontract
                                                                       posnr = <fs_data>-salescontractitem
                                                                       BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_GERNR_OUTPUT'
          EXPORTING
            input  = <fs_ser02>-sernr
          IMPORTING
            output = <fs_data>-serie.

      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
