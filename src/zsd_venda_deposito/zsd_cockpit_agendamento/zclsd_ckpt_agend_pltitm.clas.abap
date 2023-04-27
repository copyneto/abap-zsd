CLASS zclsd_ckpt_agend_pltitm DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_ckpt_agend_pltitm IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

*    DATA: lt_original_data TYPE STANDARD TABLE OF ZI_SD_CKPT_AGEN_ITEM_APP WITH DEFAULT KEY.
    DATA: lt_data TYPE STANDARD TABLE OF zc_sd_ckpt_agen_item_app WITH DEFAULT KEY.
    DATA: ls_data TYPE zi_sd_ckpt_agen_item_app.
    lt_data = CORRESPONDING #( it_original_data ).

    IF lt_data[] IS NOT INITIAL.
      SELECT *
      FROM zi_sd_ckpt_agen_item_app
      FOR ALL ENTRIES IN @lt_data
      WHERE chaveordemremessa = @lt_data-chaveordemremessa
      AND   chavedinamica     = @lt_data-chavedinamica
      AND   salesorder        = @lt_data-chavedinamica
      AND   salesorderitem        = @lt_data-salesorderitem
          INTO TABLE @DATA(lt_original_data).
      SELECT *
FROM zi_sd_ckpt_agen_item_app
FOR ALL ENTRIES IN @lt_data
WHERE chaveordemremessa = @lt_data-chaveordemremessa
AND   chavedinamica     = @lt_data-chavedinamica
AND   remessa           = @lt_data-chavedinamica
AND   salesorderitem        = @lt_data-salesorderitem
   APPENDING TABLE @lt_original_data.

    ENDIF.


    DATA lv_operand  TYPE char30.
    DATA lv_int      TYPE char10.
    DATA lv_dec      TYPE char30.
    DATA lv_div      TYPE char30.
    DATA lv_div2     TYPE char30.
    DATA lv_div3     TYPE char30.
    DATA lv_div4     TYPE char30.
    DATA lv_div5     TYPE char30.
    DATA lv_div6     TYPE char30.
    DATA lv_div7     TYPE char30.
    DATA lv_div8     TYPE char30.
    DATA lv_div9     TYPE char30.
    DATA lv_div10    TYPE char30.
    DATA lv_mult     TYPE char30.
    DATA lv_mult2    TYPE char30.
    DATA lv_inteiro  TYPE int8.
    DATA lv_inteiro2 TYPE int8.
    DATA lv_inteiro3 TYPE int8.
    DATA lv_inteiro4 TYPE int8.
    DATA lv_inteiro5 TYPE int8.

    DATA(lt_area) = lt_original_data[].
*      SORT lt_area BY soldtoparty.
*      DELETE ADJACENT DUPLICATES FROM lt_area COMPARING soldtoparty.
    SORT lt_area BY salesorder.
    DELETE ADJACENT DUPLICATES FROM lt_area COMPARING salesorder.

    DATA(lt_agend) = lt_original_data[].
    SORT lt_agend BY soldtoparty material.
    DELETE ADJACENT DUPLICATES FROM lt_agend COMPARING soldtoparty material.

    DATA(lt_agend2) = lt_original_data[].
    SORT lt_agend2 BY material.
    DELETE ADJACENT DUPLICATES FROM lt_agend2 COMPARING material.

    IF  lt_area[] IS NOT INITIAL.

      SELECT *
      FROM zi_sd_ckpt_agend_area
      FOR ALL ENTRIES IN @lt_area
      WHERE salesorder = @lt_area-salesorder
            INTO TABLE @DATA(lt_area_dados).

      IF sy-subrc IS INITIAL.

        SORT lt_area_dados BY salesorder.

      ENDIF.
    ENDIF.

    IF lt_agend[] IS NOT INITIAL.

      SELECT *
      FROM ztsd_agenda001
      INTO TABLE @DATA(lt_agend_dados)
      FOR ALL ENTRIES IN @lt_agend
      WHERE cliente = @lt_agend-soldtoparty
      AND material  = @lt_agend-material.

      IF sy-subrc IS INITIAL.

        DATA(lt_agend_dados3) = lt_agend_dados[].
        SORT lt_agend_dados  BY cliente material.
        SORT lt_agend_dados3 BY material unidade_de_medida_pallet.
        DELETE ADJACENT DUPLICATES FROM lt_agend_dados3 COMPARING material unidade_de_medida_pallet.

        IF lt_agend_dados3[] IS NOT INITIAL.

          SELECT matnr, meinh, umrez
          FROM marm
          INTO TABLE @DATA(lt_marm)
          FOR ALL ENTRIES IN @lt_agend_dados3
          WHERE matnr  = @lt_agend_dados3-material
          AND meinh  = @lt_agend_dados3-unidade_de_medida_pallet.

          IF sy-subrc IS INITIAL.

            SORT lt_marm BY matnr meinh.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF lt_agend2[] IS NOT INITIAL.

      SELECT *
      FROM ztsd_agenda001
      INTO TABLE @DATA(lt_agend_dados2)
      FOR ALL ENTRIES IN @lt_agend2
      WHERE material  = @lt_agend2-material.

      IF sy-subrc IS INITIAL.

        DATA(lt_agend_dados4) = lt_agend_dados2[].
        SORT lt_agend_dados2  BY cliente material.
        SORT lt_agend_dados4 BY material unidade_de_medida_pallet.
        DELETE ADJACENT DUPLICATES FROM lt_agend_dados4 COMPARING material unidade_de_medida_pallet.

        IF lt_agend_dados4[] IS NOT INITIAL.

          SELECT matnr, meinh, umrez
          FROM marm
          INTO TABLE @DATA(lt_marm2)
          FOR ALL ENTRIES IN @lt_agend_dados4
          WHERE matnr  = @lt_agend_dados4-material
          AND meinh  = @lt_agend_dados4-unidade_de_medida_pallet.

          IF sy-subrc IS INITIAL.

            SORT lt_marm2 BY matnr meinh.

          ENDIF.
        ENDIF.
      ENDIF.

      SELECT matnr, meins
      FROM mara
      INTO TABLE @DATA(lt_mara)
      FOR ALL ENTRIES IN @lt_agend2
      WHERE matnr  = @lt_agend2-material.

      IF sy-subrc IS INITIAL.
        SORT lt_mara BY matnr.
      ENDIF.

      SELECT matnr, meinh, umrez
      FROM marm
      INTO TABLE @DATA(lt_marm3)
      FOR ALL ENTRIES IN @lt_agend2
      WHERE matnr  = @lt_agend2-material
      AND meinh  = @lt_agend2-orderquantityunit.

      IF sy-subrc IS INITIAL.
        SORT lt_marm3 BY matnr meinh.
      ENDIF.


    ENDIF.
    SORT lt_original_data BY chavedinamica chaveordemremessa salesorder salesorderitem  .

    LOOP AT lt_data  ASSIGNING FIELD-SYMBOL(<fs_data_aux>).

      READ TABLE lt_original_data  ASSIGNING FIELD-SYMBOL(<fs_data>) WITH KEY chavedinamica     = <fs_data_aux>-chavedinamica
                                                                              chaveordemremessa = <fs_data_aux>-chaveordemremessa
                                                                              salesorder        = <fs_data_aux>-chavedinamica
                                                                              salesorderitem    = <fs_data_aux>-salesorderitem
                                                                              BINARY SEARCH.
      IF <fs_data> IS ASSIGNED.

        MOVE-CORRESPONDING <fs_data> TO ls_data.

      ELSE.
        READ TABLE lt_original_data  ASSIGNING FIELD-SYMBOL(<fs_data2>) WITH KEY chavedinamica     = <fs_data_aux>-chavedinamica
                                                                        chaveordemremessa          = <fs_data_aux>-chaveordemremessa
                                                                        remessa                    = <fs_data_aux>-chavedinamica
                                                                        salesorderitem             = <fs_data_aux>-salesorderitem.
        IF <fs_data2> IS ASSIGNED.

          MOVE-CORRESPONDING <fs_data2> TO ls_data.
        ENDIF.
      ENDIF.
      IF ls_data IS NOT INITIAL.

        IF ls_data-orderquantity IS INITIAL.
          DATA(lv_orderqt) = ls_data-orderquantityitem.
        ELSE.
          lv_orderqt = ls_data-orderquantity.
        ENDIF.

        READ TABLE lt_area_dados INTO DATA(ls_dados) WITH KEY salesorder = ls_data-salesorder
                                                     BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          READ TABLE lt_agend_dados INTO DATA(ls_agend) WITH KEY cliente = ls_data-soldtoparty
                                                                 material = ls_data-material
                                                                 BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            IF ls_agend-unidade_de_medida_pallet = ls_data-orderquantityunit.

              lv_div = lv_orderqt / ls_agend-qtd_total.
              CONDENSE lv_div.
              lv_operand = lv_div.

              SPLIT lv_operand AT '.' INTO lv_int lv_dec.
              <fs_data_aux>-palletitem = lv_int.
              lv_operand = lv_operand - lv_int.
              CONDENSE lv_operand.
              lv_inteiro2 = lv_operand * ls_agend-qtd_total.
              <fs_data_aux>-palletfracionado = lv_inteiro2.
            ELSE.
              READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_agend-material
              BINARY SEARCH.

              IF sy-subrc IS INITIAL.


                READ TABLE lt_marm INTO DATA(ls_marm) WITH KEY matnr = ls_agend-material
                                                               meinh = ls_agend-unidade_de_medida_pallet
                                                               BINARY SEARCH.

                IF sy-subrc IS INITIAL.
                  IF ls_mara-meins = ls_data-orderquantityunit.

                    lv_div2 = lv_orderqt / ls_marm-umrez.
                    lv_div3 = lv_div2 / ls_agend-qtd_total.
                    CONDENSE lv_div3.
                    lv_operand = lv_div3.

                    SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                    <fs_data_aux>-palletitem = lv_int.
                    lv_dec = ( lv_operand - lv_int ) * ls_agend-qtd_total * ls_marm-umrez.
                    CONDENSE lv_dec.
                    lv_inteiro = lv_dec.
                    <fs_data_aux>-palletfracionado =  lv_inteiro.

                  ELSE.

                    READ TABLE lt_marm3 INTO DATA(ls_marm3) WITH KEY matnr = ls_data-material
                                                                     meinh = ls_data-orderquantityunit
                                                                     BINARY SEARCH.

                    IF sy-subrc IS INITIAL.

                      lv_mult = lv_orderqt * ls_marm3-umrez.
                      lv_div4 = lv_mult / ls_marm-umrez.
                      lv_div10 = lv_div4 / ls_agend-qtd_total.
                      CONDENSE lv_div10.
                      lv_operand = lv_div10.

                      SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                      <fs_data_aux>-palletitem = lv_int.
                      lv_inteiro5 = ( lv_operand - lv_int ) * ls_agend-qtd_total * ls_marm-umrez / ls_marm3-umrez.
                      <fs_data_aux>-palletfracionado = lv_inteiro5.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

          ELSE.
            READ TABLE lt_agend_dados2 INTO DATA(ls_agend2) WITH KEY cliente = space
            material = ls_data-material
            BINARY SEARCH.
            IF sy-subrc IS INITIAL.

              IF ls_agend2-unidade_de_medida_pallet = ls_data-orderquantityunit.

                lv_div5 = lv_orderqt / ls_agend2-qtd_total.
                CONDENSE lv_div5.
                lv_operand = lv_div5.

                SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                <fs_data_aux>-palletitem = lv_int.
                lv_operand = lv_operand - lv_int.
                CONDENSE lv_operand.
                lv_inteiro2 = lv_operand * ls_agend2-qtd_total.
                <fs_data_aux>-palletfracionado = lv_inteiro2.

              ELSE.
                READ TABLE lt_mara INTO DATA(ls_mara2) WITH KEY matnr = ls_data-material
                BINARY SEARCH.

                IF sy-subrc IS INITIAL.


                  READ TABLE lt_marm2 INTO DATA(ls_marm2) WITH KEY matnr = ls_agend2-material
                                                                   meinh = ls_agend2-unidade_de_medida_pallet
                                                                   BINARY SEARCH.

                  IF sy-subrc IS INITIAL.
                    IF ls_mara2-meins = ls_data-orderquantityunit.
                      lv_div6 = lv_orderqt / ls_marm2-umrez.
                      lv_div7 = lv_div6 / ls_agend2-qtd_total.
                      CONDENSE lv_div7.
                      lv_operand = lv_div7.

                      SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                      <fs_data_aux>-palletitem = lv_int.
                      lv_inteiro3 = ( lv_operand - lv_int ) * ls_agend2-qtd_total * ls_marm2-umrez .
                      <fs_data_aux>-palletfracionado = lv_inteiro3.
                    ELSE.
                      READ TABLE lt_marm3 INTO DATA(ls_marm3_2) WITH KEY matnr = ls_data-material
                                                   meinh = ls_data-orderquantityunit
                                                   BINARY SEARCH.

                      IF sy-subrc IS INITIAL.

                        lv_mult2 = lv_orderqt * ls_marm3_2-umrez.
                        lv_div8 = lv_mult2 / ls_marm2-umrez.
                        lv_div9 = lv_div8 / ls_agend2-qtd_total.
                        CONDENSE lv_div9.
                        lv_operand = lv_div9.

                        SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                        <fs_data_aux>-palletitem = lv_int.
                        lv_inteiro4 = ( lv_operand - lv_int ) * ls_agend2-qtd_total * ls_marm2-umrez / ls_marm3_2-umrez.
                        <fs_data_aux>-palletfracionado = lv_inteiro4.

                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.

            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR: lv_operand, lv_int, lv_dec, lv_div, lv_div2, lv_div3, lv_div4, lv_div5, lv_div6, lv_div7, lv_div8, lv_div9, lv_div10, lv_mult, lv_mult2, lv_orderqt,
               lv_inteiro, lv_inteiro2, lv_inteiro3, lv_inteiro4, lv_inteiro5, ls_data.
        UNASSIGN: <fs_data>, <fs_data2>.
      ENDIF.
      IF <fs_data_aux>-palletfracionado IS INITIAL.
        <fs_data_aux>-palletfracionado = 0.
      ENDIF.
      IF <fs_data_aux>-palletitem IS INITIAL.
        <fs_data_aux>-palletitem = 0.
      ENDIF.
    ENDLOOP.


    ct_calculated_data = CORRESPONDING #( lt_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
