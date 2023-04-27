CLASS zclsd_ckpt_agend_dataentrega DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zclsd_ckpt_agend_dataentrega IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE STANDARD TABLE OF zc_sd_ckpt_agen_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data[] IS NOT INITIAL.
      SELECT chaveordemremessa, chavedinamica, salesorder, salesorderitem, dataentrega,time_zone
      FROM zi_sd_ckpt_agend_union_app
      FOR ALL ENTRIES IN @lt_original_data
      WHERE chaveordemremessa EQ @lt_original_data-chaveordemremessa
      AND   chavedinamica     EQ @lt_original_data-chavedinamica
      AND   salesorder        EQ @lt_original_data-salesorder
      AND   salesorderitem    EQ @lt_original_data-salesorderitem
          INTO TABLE @DATA(lt_app).

      IF sy-subrc IS INITIAL.

        SORT lt_app BY chaveordemremessa chavedinamica salesorder salesorderitem.
      ENDIF.
    ENDIF.
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_original_data>).


      READ TABLE lt_app INTO DATA(ls_app) WITH KEY chaveordemremessa = <fs_original_data>-chaveordemremessa
                                                   chavedinamica     = <fs_original_data>-chavedinamica
                                                   salesorder        = <fs_original_data>-salesorder
                                                   salesorderitem    = <fs_original_data>-salesorderitem
                                                   BINARY SEARCH.

      IF sy-subrc IS INITIAL.
        IF  ls_app-dataentrega IS NOT INITIAL AND ls_app-time_zone IS NOT INITIAL.

          GET TIME STAMP FIELD DATA(lv_ts).


          lv_ts =  ls_app-dataentrega.

          CONVERT TIME STAMP lv_ts TIME ZONE ls_app-time_zone
                  INTO DATE DATA(lv_data) TIME DATA(lv_time).

          DATA(lv_dia)   = lv_data+6(2).
          DATA(lv_mes)   = lv_data+4(2).
          DATA(lv_ano)   = lv_data(4).
          DATA(lv_hora)  = lv_time(2).
          DATA(lv_hora2) = lv_time+2(2).
          DATA(lv_hora3) = lv_time+4(2).

          DATA(lv_date) =  |{ lv_dia }| & |.| & |{ lv_mes }| & |.| & |{ lv_ano }| & |-| & |{ lv_hora }| & |:| & |{ lv_hora2 }| & |:| & |{ lv_hora3 }|.
          <fs_original_data>-dataentrega = lv_date.
        ENDIF.
      ENDIF.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
