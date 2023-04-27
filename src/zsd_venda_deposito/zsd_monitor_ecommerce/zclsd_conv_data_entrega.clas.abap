"!<p>Converte data de entrega para o fuso horário de Brasília GMT-3. <br/>
"! Esta classe é utilizada na CDS view <em>ZI_SD_MONITOR_APP</em> <br/> <br/>
"!<p><strong>Autor:</strong> Anderson Miazato - Meta</p>
"!<p><strong>Data:</strong> 12/jul/2022</p>
CLASS zclsd_conv_data_entrega DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_conv_data_entrega IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_calculated_data TYPE STANDARD TABLE OF zi_sd_monitor_app WITH DEFAULT KEY.
    DATA: lv_date_conv TYPE char10,
          lv_time_conv TYPE char8.

    IF it_original_data IS INITIAL.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

      IF <fs_calc_data>-ActualDate IS NOT INITIAL.

        CONVERT TIME STAMP <fs_calc_data>-ActualDate TIME ZONE sy-zonlo
        INTO DATE DATA(lv_date) TIME DATA(lv_time).

        WRITE lv_date TO lv_date_conv.
        WRITE lv_time TO lv_time_conv.

        <fs_calc_data>-ActualDateSaida = |{ lv_date_conv } | && |{ lv_time_conv }|.
      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.


  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    IF line_exists( it_requested_calc_elements[ table_line = 'ACTUALDATESAIDA' ] ).
      APPEND 'ACTUALDATE' TO et_requested_orig_elements.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
