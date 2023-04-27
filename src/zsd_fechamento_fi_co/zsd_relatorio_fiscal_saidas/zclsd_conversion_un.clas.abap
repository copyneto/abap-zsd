CLASS zclsd_conversion_un DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_conversion_un IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_rel_fiscal_saida_app WITH DEFAULT KEY.
*          lv_unit_in       TYPE t006-msehi.

    lt_original_data = CORRESPONDING #( it_original_data ).
    CHECK lt_original_data IS NOT INITIAL.

    SELECT notafiscal,
           itemnf,
           baseunit,
           material,
           qtdconfnfemitida,
           quantityinbaseunitkg
      FROM zi_sd_rel_fiscal_saida_app
       FOR ALL ENTRIES IN @lt_original_data
     WHERE notafiscal = @lt_original_data-notafiscal
       AND itemnf     = @lt_original_data-itemnf
      INTO TABLE @DATA(lt_relat).

    IF sy-subrc IS INITIAL.
      SORT lt_relat BY notafiscal
                       itemnf.

      SELECT matnr,
             meins
        FROM mara
         FOR ALL ENTRIES IN @lt_relat
       WHERE matnr = @lt_relat-material
        INTO TABLE @DATA(lt_mara).
      IF sy-subrc IS INITIAL.
        SORT lt_mara BY matnr.
      ENDIF.
    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_relat ASSIGNING FIELD-SYMBOL(<fs_relat>)
                                        WITH KEY notafiscal = <fs_data>-notafiscal
                                                 itemnf     = <fs_data>-itemnf
                                                 BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>)
                                         WITH KEY matnr = <fs_relat>-material
                                         BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          IF <fs_relat>-baseunit = <fs_mara>-meins.
            <fs_data>-qtdunvdabasica = <fs_relat>-qtdconfnfemitida.

            CLEAR <fs_data>-PrecoCustoTotal.
            <fs_data>-PrecoCustoTotal = <fs_data>-QtdUnVdaBasica * <fs_data>-PrecoCustoUnitario.

            CONTINUE.
          ELSE.
            DATA(lv_matnr)     = <fs_relat>-material.
            DATA(lv_unit_in)   = <fs_relat>-baseunit.
            DATA(lv_menge_in)  = CONV bstmg( <fs_relat>-qtdconfnfemitida ).
            DATA(lv_menge_out) = CONV bstmg( <fs_relat>-quantityinbaseunitkg ).

            CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
              EXPORTING
                i_matnr              = lv_matnr
                i_in_me              = lv_unit_in
                i_out_me             = <fs_mara>-meins
                i_menge              = lv_menge_in
              IMPORTING
                e_menge              = lv_menge_out
              EXCEPTIONS
                error_in_application = 1
                error                = 2
                OTHERS               = 3.

            IF sy-subrc <> 0.
              CLEAR <fs_data>-qtdunvdabasica.
            ELSE.
              <fs_data>-qtdunvdabasica = lv_menge_out.
            ENDIF.

            CLEAR <fs_data>-PrecoCustoTotal.
            <fs_data>-PrecoCustoTotal = <fs_data>-QtdUnVdaBasica * <fs_data>-PrecoCustoUnitario.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
