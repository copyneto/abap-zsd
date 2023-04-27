CLASS zclsd_preco_substituir DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_PRECO_SUBSTITUIR IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_substituir_app WITH DEFAULT KEY.
    DATA: lt_original_data_aux TYPE STANDARD TABLE OF zi_sd_substituir_app WITH DEFAULT KEY.

    lt_original_data     = CORRESPONDING #( it_original_data ).
    lt_original_data_aux = CORRESPONDING #( it_original_data ).

    SORT lt_original_data_aux BY salesorder salesorderitem .
    DELETE ADJACENT DUPLICATES FROM lt_original_data_aux COMPARING salesorder salesorderitem.

    IF lt_original_data_aux[] IS NOT INITIAL.
      SELECT  a~salesorder,
              a~salesorderitem,
              a~material,
              a~pricingdate,
              a~plant,
              b~salesorganization,
              b~distributionchannel,
              b~pricelisttype
      FROM i_salesorderitem AS a
      INNER JOIN i_salesorder AS b
      ON b~salesorder = a~salesorder
      FOR ALL ENTRIES IN @lt_original_data_aux
      WHERE a~salesorder = @lt_original_data_aux-salesorder
        AND a~salesorderitem = @lt_original_data_aux-salesorderitem
      INTO TABLE @DATA(lt_sales).
    ENDIF.
    IF sy-subrc IS INITIAL.

      DATA(lt_sales_aux) = lt_sales[].
      SORT lt_sales_aux BY distributionchannel pricelisttype plant material pricingdate.
      DELETE ADJACENT DUPLICATES FROM lt_sales_aux COMPARING distributionchannel pricelisttype plant material pricingdate.

      IF lt_sales_aux[] IS NOT INITIAL.
        SELECT knumh, vtweg, pltyp, werks, matnr, datbi, datab
        FROM a817
        INTO TABLE @DATA(lt_a817)
        FOR ALL ENTRIES IN @lt_sales_aux
        WHERE kschl = 'ZPR0'
*and VKORG = @lt_sales-SALESORGANIZATION
        AND vtweg =  @lt_sales_aux-distributionchannel
        AND pltyp =  @lt_sales_aux-pricelisttype
        AND werks =  @lt_sales_aux-plant
        AND matnr =  @lt_sales_aux-material
        AND datbi >= @lt_sales_aux-pricingdate
        AND datab <= @lt_sales_aux-pricingdate .

        IF sy-subrc IS NOT INITIAL.

          DATA(lt_sales_aux2) = lt_sales[].
          SORT lt_sales_aux2 BY distributionchannel plant material pricingdate.
          DELETE ADJACENT DUPLICATES FROM lt_sales_aux2 COMPARING distributionchannel plant material pricingdate.

          IF lt_sales_aux[] IS NOT INITIAL.
            SELECT knumh, vtweg, werks, matnr, datbi, datab
            FROM a816
            INTO TABLE @DATA(lt_a816)
            FOR ALL ENTRIES IN @lt_sales_aux
            WHERE kschl = 'ZPR0'
*and VKORG = @lt_sales-SALESORGANIZATION
            AND vtweg =  @lt_sales_aux-distributionchannel
            AND werks =  @lt_sales_aux-plant
            AND matnr =  @lt_sales_aux-material
            AND datbi >= @lt_sales_aux-pricingdate
            AND datab <= @lt_sales_aux-pricingdate .

            IF sy-subrc IS INITIAL.

              DATA(lt_a816_aux) = lt_a816[].
              SORT lt_a816_aux BY knumh.
              DELETE ADJACENT DUPLICATES FROM lt_a816_aux COMPARING knumh.

              SORT lt_a816 BY vtweg werks matnr datbi datab.

              IF lt_a816_aux[] IS NOT INITIAL.
                SELECT knumh, kbetr, konwa, kpein, kmein
                FROM konp
                 INTO TABLE @DATA(lt_konp_816)
                 FOR ALL ENTRIES IN @lt_a816_aux
                 WHERE knumh = @lt_a816_aux-knumh.

                IF sy-subrc IS INITIAL.
                  SORT lt_konp_816 BY knumh.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ELSE.

          DATA(lt_a817_aux) = lt_a817[].
          SORT lt_a817_aux BY knumh.
          DELETE ADJACENT DUPLICATES FROM lt_a817_aux COMPARING knumh.

          SORT lt_a817 BY vtweg pltyp werks matnr datbi datab.

          IF lt_a817_aux[] IS NOT INITIAL.
            SELECT knumh, kbetr, konwa, kpein, kmein
            FROM konp
             INTO TABLE @DATA(lt_konp_817)
             FOR ALL ENTRIES IN @lt_a817_aux
             WHERE knumh = @lt_a817_aux-knumh.

            IF sy-subrc IS INITIAL.
              SORT lt_konp_817 BY knumh.
            ENDIF.
          ENDIF.
        ENDIF.


        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

          READ TABLE lt_sales ASSIGNING FIELD-SYMBOL(<fs_sales>) WITH KEY salesorder = <fs_data>-salesorder
                                                                          salesorderitem = <fs_data>-salesorderitem
                                                                          BINARY SEARCH.
          IF <fs_sales> IS ASSIGNED.

            READ TABLE lt_a817 ASSIGNING FIELD-SYMBOL(<fs_a817>) WITH KEY vtweg =  <fs_sales>-distributionchannel
                                                                          pltyp =  <fs_sales>-pricelisttype
                                                                          werks =  <fs_sales>-plant
                                                                          matnr =  <fs_sales>-material
                                                                          BINARY SEARCH.
            IF <fs_a817> IS ASSIGNED.

              READ TABLE lt_konp_817 ASSIGNING FIELD-SYMBOL(<fs_konp_817>) WITH KEY knumh = <fs_a817>-knumh
                                                                                    BINARY SEARCH.

              IF <fs_konp_817> IS ASSIGNED.

*                <fs_data>-preco     = <fs_konp_817>-kbetr.
*                <fs_data>-moeda     = <fs_konp_817>-konwa.
*                <fs_data>-umpreco   = <fs_konp_817>-kmein.
*                <fs_data>-unitpreco = <fs_konp_817>-kpein.

              ENDIF.
            ELSE.

              READ TABLE lt_a816 ASSIGNING FIELD-SYMBOL(<fs_a816>) WITH KEY vtweg =  <fs_sales>-distributionchannel
                                                                            werks =  <fs_sales>-plant
                                                                            matnr =  <fs_sales>-material
                                                                            BINARY SEARCH.
              IF <fs_a816> IS ASSIGNED.

                READ TABLE lt_konp_816 ASSIGNING FIELD-SYMBOL(<fs_konp_816>) WITH KEY knumh = <fs_a816>-knumh
                                                                                      BINARY SEARCH.

                IF <fs_konp_816> IS ASSIGNED.

*                  <fs_data>-preco     = <fs_konp_816>-kbetr.
*                  <fs_data>-moeda     = <fs_konp_816>-konwa.
*                  <fs_data>-umpreco   = <fs_konp_816>-kmein.
*                  <fs_data>-unitpreco = <fs_konp_816>-kpein.

                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDLOOP.

        ct_calculated_data = CORRESPONDING #(  lt_original_data ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
