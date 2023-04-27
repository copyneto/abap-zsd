CLASS zclsd_ckpt_agend_pallet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_ckpt_agend_pallet IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_ckpt_agen_app WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

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
    DATA lv_soma_p   TYPE char20.
    DATA lv_soma_f   TYPE char20.
    DATA lv_pallet   TYPE int8.
    DATA lv_palletf  TYPE int8.
    DATA lv_inteiro  TYPE int8.
    DATA lv_inteiro2 TYPE int8.
    DATA lv_inteiro3 TYPE int8.

    DATA(lt_original_item) = lt_original_data[].
    SORT lt_original_item BY chaveordemremessa chavedinamica salesorder.
    DELETE ADJACENT DUPLICATES FROM lt_original_item COMPARING chaveordemremessa chavedinamica salesorder.


    IF lt_original_item[] IS NOT INITIAL.

      SELECT *
      FROM zi_sd_ckpt_agen_item_app
      FOR ALL ENTRIES IN @lt_original_item
*      WHERE chaveordemremessa = @lt_original_item-chaveordemremessa
*      AND   chavedinamica     = @lt_original_item-chavedinamica
      WHERE   salesorder        = @lt_original_item-salesorder
*      AND     remessa           = @lt_original_item-remessa
      INTO TABLE @DATA(lt_item).




      DATA(lt_area) = lt_item[].
*      SORT lt_area BY soldtoparty.
*      DELETE ADJACENT DUPLICATES FROM lt_area COMPARING soldtoparty.
      SORT lt_area BY salesorder.
      DELETE ADJACENT DUPLICATES FROM lt_area COMPARING salesorder.

      DATA(lt_agend) = lt_item[].
      SORT lt_agend BY soldtoparty material.
      DELETE ADJACENT DUPLICATES FROM lt_agend COMPARING soldtoparty material.

      DATA(lt_agend2) = lt_item[].
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
    ENDIF.
    SORT lt_item BY salesorder remessa.

    LOOP AT lt_original_data  ASSIGNING FIELD-SYMBOL(<fs_data>).


      READ TABLE lt_item WITH KEY     salesorder        = <fs_data>-salesorder
                                      remessa           = <fs_data>-remessa
                                            TRANSPORTING NO FIELDS BINARY SEARCH.
      CHECK sy-subrc = 0.

      LOOP AT lt_item INTO DATA(ls_item) FROM sy-tabix.
        IF  ls_item-salesorder        <> <fs_data>-salesorder
          OR    ls_item-remessa       <> <fs_data>-remessa.
          EXIT.
        ENDIF.

        READ TABLE lt_area_dados INTO DATA(ls_dados) WITH KEY salesorder = ls_item-salesorder
                                                     BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          IF ls_item-orderquantity IS INITIAL.
            DATA(lv_orderqt) = ls_item-orderquantityitem.
          ELSE.
            lv_orderqt = ls_item-orderquantity.
          ENDIF.

          READ TABLE lt_agend_dados INTO DATA(ls_agend) WITH KEY cliente  = ls_item-soldtoparty
                                                                 material = ls_item-material
                                                                 BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            IF ls_agend-unidade_de_medida_pallet = ls_item-orderquantityunit.

              lv_div = lv_orderqt / ls_agend-qtd_total.
              CONDENSE lv_div.
              lv_operand = lv_div.

              SPLIT lv_operand AT '.' INTO lv_int lv_dec.
              lv_soma_p = lv_soma_p + lv_int.
              lv_operand = lv_operand - lv_int.
              CONDENSE lv_operand.
              lv_soma_f = lv_soma_f + ( lv_operand   * ls_agend-qtd_total ).

            ELSE.
              READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_agend-material
              BINARY SEARCH.

              IF sy-subrc IS INITIAL.


                READ TABLE lt_marm INTO DATA(ls_marm) WITH KEY matnr = ls_agend-material
                                                               meinh = ls_agend-unidade_de_medida_pallet
                                                               BINARY SEARCH.

                IF sy-subrc IS INITIAL.
                  IF ls_mara-meins = ls_item-orderquantityunit.

                    lv_div2 = lv_orderqt / ls_marm-umrez.
                    lv_div3 = lv_div2 / ls_agend-qtd_total.
                    CONDENSE lv_div3.
                    lv_operand = lv_div3.

                    SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                    lv_soma_p = lv_soma_p + lv_int.

                    lv_dec = ( lv_operand - lv_int ) * ls_agend-qtd_total * ls_marm-umrez.
                    CONDENSE lv_dec.
                    lv_inteiro = lv_dec.
                    <fs_data>-palletfracionado =  lv_inteiro.

                    lv_soma_f =  lv_soma_f + lv_inteiro.

                  ELSE.

                    READ TABLE lt_marm3 INTO DATA(ls_marm3) WITH KEY matnr = ls_item-material
                                                                     meinh = ls_item-orderquantityunit
                                                                     BINARY SEARCH.

                    IF sy-subrc IS INITIAL.

                      lv_mult = lv_orderqt * ls_marm3-umrez.
                      lv_div4 = lv_mult / ls_marm-umrez.
                      lv_div10 = lv_div4 / ls_agend-qtd_total.
                      CONDENSE lv_div10.
                      lv_operand = lv_div10.

                      SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                      lv_soma_p = lv_soma_p + lv_int.
                      lv_soma_f =  lv_soma_f + ( ( lv_operand - lv_int )  * ls_agend-qtd_total * ls_marm-umrez / ls_marm3-umrez ).

                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.

          ELSE.
            READ TABLE lt_agend_dados2 INTO DATA(ls_agend2) WITH KEY cliente  = space
            material = ls_item-material
            BINARY SEARCH.
            IF sy-subrc IS INITIAL.

              IF ls_agend2-unidade_de_medida_pallet = ls_item-orderquantityunit.

                lv_div5 = lv_orderqt / ls_agend2-qtd_total.
                CONDENSE lv_div5.
                lv_operand = lv_div5.

                SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                lv_soma_p = lv_soma_p + lv_int.

                lv_operand = lv_operand - lv_int.
                CONDENSE lv_operand.
                lv_inteiro2 = lv_operand * ls_agend2-qtd_total.

                lv_soma_f = lv_soma_f + lv_inteiro2 .

              ELSE.

                READ TABLE lt_mara INTO DATA(ls_mara2) WITH KEY matnr = ls_item-material
                BINARY SEARCH.

                IF sy-subrc IS INITIAL.


                  READ TABLE lt_marm2 INTO DATA(ls_marm2) WITH KEY matnr = ls_agend2-material
                                                                   meinh = ls_agend2-unidade_de_medida_pallet
                                                                   BINARY SEARCH.

                  IF sy-subrc IS INITIAL.
                    IF ls_mara2-meins = ls_item-orderquantityunit.
                      lv_div6 = lv_orderqt / ls_marm2-umrez.
                      lv_div7 = lv_div6 / ls_agend2-qtd_total.
                      CONDENSE lv_div7.
                      lv_operand = lv_div7.

                      SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                      lv_soma_p = lv_soma_p + lv_int.
                      lv_soma_f =  lv_soma_f + ( ( lv_operand - lv_int )  * ls_agend2-qtd_total * ls_marm2-umrez ).

                    ELSE.

                      READ TABLE lt_marm3 INTO DATA(ls_marm3_2) WITH KEY matnr = ls_item-material
                                                   meinh = ls_item-orderquantityunit
                                                   BINARY SEARCH.

                      IF sy-subrc IS INITIAL.

                        lv_mult2 = lv_orderqt * ls_marm3_2-umrez.
                        lv_div8 = lv_mult2 / ls_marm2-umrez.
                        lv_div9 = lv_div8 / ls_agend2-qtd_total.
                        CONDENSE lv_div9.
                        lv_operand = lv_div9.

                        SPLIT lv_operand AT '.' INTO lv_int lv_dec.
                        lv_soma_p = lv_soma_p + lv_int.
                        lv_soma_f =  lv_soma_f + ( ( lv_operand - lv_int )  * ls_agend2-qtd_total * ls_marm2-umrez / ls_marm3_2-umrez ) .

                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        CLEAR: lv_operand, lv_int, lv_dec, lv_div, lv_div2, lv_div3, lv_div4, lv_div5, lv_div6, lv_div7, lv_div8, lv_div9, lv_div10, lv_mult, lv_mult2, lv_orderqt.
      ENDLOOP.
      lv_pallet = lv_soma_p.
      lv_palletf = lv_soma_f.
      <fs_data>-pallettotal      = lv_pallet.
      <fs_data>-palletfracionado = lv_palletf.

      CLEAR: lv_soma_p, lv_soma_f.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
