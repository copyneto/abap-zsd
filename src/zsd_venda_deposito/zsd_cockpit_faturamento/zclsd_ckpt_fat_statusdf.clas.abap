CLASS zclsd_ckpt_fat_statusdf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS zclsd_ckpt_fat_statusdf IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE STANDARD TABLE OF zc_sd_ckpt_fat_app WITH DEFAULT KEY.
    DATA: lt_atpcsx     TYPE TABLE OF atpcs.
    DATA: lt_atpcsx_dep TYPE TABLE OF atpcs.
    DATA: lt_atpdsx     TYPE TABLE OF atpds.
    DATA: lt_atpdsx_dep TYPE TABLE OF atpds.
    DATA: lt_mdpsx      TYPE TABLE OF mdps.
    DATA: lv_qtdordem             TYPE mng01.
    DATA: lv_qtdremessa           TYPE mng01.
    DATA: lv_qtdestoquelivre      TYPE mng01.
    DATA: lv_qtddepositofechado   TYPE mng01.
    DATA: lv_saldo                TYPE mng01.

    lt_original_data = CORRESPONDING #( it_original_data ).

*    DELETE lt_original_data WHERE centrodepfechado IS INITIAL.

    IF lt_original_data[] IS NOT INITIAL.

      SELECT itm~material, itm~plant, ckp~salesorder, itm~salesorderitem,
             itm~storagelocation, itm~orderquantity, ckp~centrodepfechado
      FROM zi_sd_ckpt_fat_app          AS ckp
      INNER JOIN i_salesorderitem      AS itm ON itm~salesorder = ckp~salesorder
                                          AND itm~salesdocumentrjcnreason IS INITIAL
      INNER JOIN zi_sd_verif_disp_app  AS verif ON itm~material = verif~material
                                              AND itm~plant    = verif~plant
                                              AND itm~StorageLocation = verif~deposito
      FOR ALL ENTRIES IN @lt_original_data
      WHERE ckp~salesorder     = @lt_original_data-salesorder
      INTO TABLE @DATA(lt_material).

      IF lt_material[] IS NOT INITIAL.

        SORT lt_material BY salesorder salesorderitem.
        DELETE ADJACENT DUPLICATES FROM lt_material COMPARING salesorder salesorderitem.

        IF lt_material[] IS NOT INITIAL.

          SELECT matnr, werks, lgort, labst
          FROM mard
          FOR ALL ENTRIES IN @lt_material
          WHERE matnr = @lt_material-material
          AND   werks = @lt_material-centrodepfechado
          AND   lgort = @lt_material-storagelocation
          INTO TABLE @DATA(lt_material_aux).

          IF sy-subrc IS INITIAL.

            SORT lt_material_aux BY matnr werks lgort.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_material TRANSPORTING NO FIELDS WITH KEY salesorder     = <fs_data>-salesorder
                                                                           BINARY SEARCH.

      IF sy-subrc IS INITIAL.
        LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) FROM sy-tabix.
          IF <fs_material>-salesorder <> <fs_data>-salesorder.
            EXIT.
          ENDIF.

          READ TABLE lt_material_aux INTO DATA(ls_material) WITH KEY matnr = <fs_material>-material
                                                                     werks = <fs_material>-centrodepfechado
                                                                     lgort = <fs_material>-storagelocation
                                                                     BINARY SEARCH.

          IF sy-subrc IS INITIAL.

            DATA(lv_qtd) = ls_material-labst - <fs_material>-orderquantity.

            IF  lv_qtd >= 0.
              <fs_data>-statusdf = TEXT-001.
              <fs_data>-colorstatusdf = 3.
            ELSE.
              <fs_data>-statusdf = TEXT-002.
              <fs_data>-colorstatusdf = 1.
              EXIT.
            ENDIF.
          ENDIF.
        ENDLOOP.
      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
