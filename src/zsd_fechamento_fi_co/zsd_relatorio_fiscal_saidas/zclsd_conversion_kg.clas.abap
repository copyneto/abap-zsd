CLASS zclsd_conversion_kg DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CONVERSION_KG IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_rel_fiscal_saida_app WITH DEFAULT KEY.
*          lv_unit_in       TYPE t006-msehi.

    lt_original_data = CORRESPONDING #( it_original_data ).
    check lt_original_data is not initial.

*    SELECT *
*      INTO TABLE @data(lt_mara)
*      FROM mara
*      FOR ALL ENTRIES IN @lt_original_data
*      WHERE matnr = @lt_original_data-Material.
*      if sy-subrc is INITIAL.
*        sort lt_mara by matnr.
*      ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF <fs_data>-BaseUnit = 'KG'.
        <fs_data>-QuantityInBaseUnitKG = <fs_data>-QtdConfNFEmitida.
        CONTINUE.
      ENDIF.

      DATA(lv_matnr) = <fs_data>-Material .
      DATA(lv_unit_in) = <fs_data>-BaseUnit .
      DATA(lv_menge_in) = conv BSTMG( <fs_data>-QtdConfNFEmitida ).
      DATA(lv_menge_out) = conv BSTMG( <fs_data>-QuantityInBaseUnitKG ).


      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr                    = lv_matnr
          i_in_me                    = lv_unit_in
          i_out_me                   = 'KG'
          i_menge                    = lv_menge_in
       IMPORTING
         E_MENGE                    = lv_menge_out
       EXCEPTIONS
         ERROR_IN_APPLICATION       = 1
         ERROR                      = 2
         OTHERS                     = 3
                .
      IF sy-subrc <> 0.
        CLEAR <fs_data>-QuantityInBaseUnitKG.
      ELSE.
        <fs_data>-QuantityInBaseUnitKG = lv_menge_out.
      ENDIF.

*      lv_unit_in = <fs_data>-baseunit.

*      CALL FUNCTION 'UNIT_CONVERSION_SIMPLE'
*        EXPORTING
*          input                = <fs_data>-QtdConfNFEmitida
*          unit_in              = lv_unit_in
*          unit_out             = 'KG'
*        IMPORTING
*          output               = <fs_data>-QuantityInBaseUnitKG
*        EXCEPTIONS
*          conversion_not_found = 1
*          division_by_zero     = 2
*          input_invalid        = 3
*          output_invalid       = 4
*          overflow             = 5
*          type_invalid         = 6
*          units_missing        = 7
*          unit_in_not_found    = 8
*          unit_out_not_found   = 9
*          OTHERS               = 10.
*      IF sy-subrc <> 0.
*        CLEAR <fs_data>-QuantityInBaseUnitKG.
*      ENDIF.

*      <fs_data>-QuantityInBaseUnitKG = <fs_data>-QtdConfNFEmitida * <fs_data>-MaterialGrossWeight.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).


  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

*    IF line_exists( it_requested_calc_elements[ table_line = 'QUANTITYINBASEUNITKG' ]  ).
*      APPEND 'MATERIALGROSSWEIGHT' TO et_requested_orig_elements.
*      APPEND 'MATERIALWEIGHTUNIT' TO et_requested_orig_elements.
*    ENDIF.
    RETURN.
  ENDMETHOD.
ENDCLASS.
