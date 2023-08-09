CLASS zclsd_ckpt_fat_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        atp    TYPE ztca_param_par-chave2 VALUE 'ATP',
        prreg  TYPE ztca_param_par-chave3 VALUE 'PRREG',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    DATA gs_prreg TYPE RANGE OF prreg.
    DATA gs_atpab TYPE RANGE OF atpab.
    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

ENDCLASS.



CLASS zclsd_ckpt_fat_status IMPLEMENTATION.


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

    IF lt_original_data[] IS NOT INITIAL.

*      SELECT ckp~material, ckp~plant, ckp~salesorder, ckp~salesorderitem, verif~storagelocation
*      FROM zi_sd_verif_disp_app AS verif
*      INNER JOIN zi_sd_ckpt_fat_app AS ckp ON ckp~material = verif~material
*                                          AND ckp~plant    = verif~plant
*      FOR ALL ENTRIES IN @lt_original_data
*      WHERE salesorder     = @lt_original_data-salesorder
**      AND   salesorderitem = '000010'
*      AND salesorderitem = @lt_original_data-SalesOrderItem
*      INTO TABLE @DATA(lt_material).
      SELECT itm~material, itm~plant, ckp~salesorder, itm~salesorderitem, verif~centrodepfechado,verif~deposito
      FROM zi_sd_ckpt_fat_app AS ckp
      INNER JOIN i_salesorderitem  AS itm ON itm~salesorder = ckp~salesorder
                                          AND itm~salesdocumentrjcnreason IS INITIAL
      INNER JOIN zi_sd_verif_disp_app AS verif ON itm~material        = verif~material
                                              AND itm~plant           = verif~plant
                                              AND itm~storagelocation = verif~deposito
      FOR ALL ENTRIES IN @lt_original_data
      WHERE ckp~salesorder     = @lt_original_data-salesorder
      INTO TABLE @DATA(lt_material).

      IF lt_material[] IS NOT INITIAL.

        SORT lt_material BY salesorder salesorderitem.
        DELETE ADJACENT DUPLICATES FROM lt_material COMPARING salesorder salesorderitem.

      ENDIF.

    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

**      SELECT SINGLE salesdocumentrjcnreason
**      FROM i_salesorderitem
**      INTO @DATA(lv_status)
**      WHERE salesdocumentrjcnreason NE ''.

*      SELECT SINGLE material, plant
*      FROM zi_sd_ckpt_fat_app
*      WHERE salesorder = @<fs_data>-salesorder
*      AND salesorderitem = '000010'
*      INTO @DATA(ls_material).
**      UP TO 1 ROWS.
**      ENDSELECT.

*      READ TABLE lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) WITH KEY salesorder     = <fs_data>-salesorder
**                                                                            salesorderitem = '000010'
*                                                                            salesorderitem = <fs_data>-salesorderitem
*                                                                            BINARY SEARCH.
*      IF sy-subrc = 0.

      READ TABLE lt_material TRANSPORTING NO FIELDS WITH KEY salesorder     = <fs_data>-salesorder
*                                                                            salesorderitem = <fs_data>-salesorderitem
                                                                           BINARY SEARCH.

      IF sy-subrc IS INITIAL.
        LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) FROM sy-tabix.
          IF <fs_material>-salesorder <> <fs_data>-salesorder.
            EXIT.
          ENDIF.


          CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
            EXPORTING
              matnr                    = <fs_material>-material
              werks                    = <fs_material>-plant
            TABLES
              mdpsx                    = lt_mdpsx
            EXCEPTIONS
              material_plant_not_found = 1
              plant_not_found          = 2
              OTHERS                   = 3.

          IF sy-subrc = 0.

            LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>).
              IF <fs_mdpsx>-plaab = get_atpab(  ) AND <fs_mdpsx>-lgort = <fs_data>-storagelocation.
                CASE <fs_mdpsx>-delkz.
                  WHEN 'VC'.
                    lv_qtdordem = lv_qtdordem + <fs_mdpsx>-mng01.
                  WHEN 'VJ'.
                    lv_qtdremessa  = lv_qtdremessa  + <fs_mdpsx>-mng01.
*                  WHEN 'WB'.
*                    lv_qtdestoquelivre = lv_qtdestoquelivre + <fs_mdpsx>-mng01.
                ENDCASE.
              ENDIF.
            ENDLOOP.

            CLEAR: lt_mdpsx.
          ENDIF.


*          CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*            EXPORTING
*              matnr                    = <fs_material>-material
*              werks                    = <fs_material>-CentroDepFechado
*            TABLES
*              mdpsx                    = lt_mdpsx
*            EXCEPTIONS
*              material_plant_not_found = 1
*              plant_not_found          = 2
*              OTHERS                   = 3.

*          IF sy-subrc = 0.
*            LOOP AT lt_mdpsx ASSIGNING <fs_mdpsx>.
*              IF <fs_mdpsx>-plaab = get_atpab(  ) and <fs_mdpsx>-lgort = <fs_data>-StorageLocation.
*                CASE <fs_mdpsx>-delkz.
*                  WHEN 'WB'.
*                    lv_qtddepositofechado = lv_qtddepositofechado + <fs_mdpsx>-mng01.
*                ENDCASE.
*              ENDIF.
*            ENDLOOP.
*          ENDIF.

      SELECT SINGLE  labst
      FROM mard
      INTO lv_qtdestoquelivre
      WHERE matnr = <fs_material>-material
        AND werks = <fs_material>-Plant
        AND lgort = <fs_material>-deposito.

      SELECT SINGLE  labst
      FROM mard
      INTO lv_qtddepositofechado
      WHERE matnr = <fs_material>-material
        AND werks = <fs_material>-centrodepfechado
        AND lgort = <fs_material>-deposito.

          lv_saldo = lv_qtdestoquelivre + lv_qtddepositofechado - lv_qtdremessa - lv_qtdordem.
*          lv_saldo = lv_qtdestoquelivre - lv_qtdremessa - lv_qtdordem.

          IF  lv_saldo >= 0.
            <fs_data>-status = TEXT-001.
            <fs_data>-colorstatus = 3.
          ELSE.
            <fs_data>-status = TEXT-002.
            <fs_data>-colorstatus = 1.
            EXIT.
          ENDIF.

          CLEAR: lv_qtdordem, lv_qtdremessa, lv_qtdestoquelivre, lv_qtddepositofechado, lv_saldo, lt_mdpsx .
        ENDLOOP.
      ENDIF.
*      IF lv_status IS INITIAL.
*        <fs_data>-status = TEXT-001.
*        <fs_data>-colorstatus = 3.
*      ELSE.
*        <fs_data>-status = TEXT-002.
*        <fs_data>-colorstatus = 1.


    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.


  METHOD get_atpab.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    CLEAR gs_atpab.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-atp
      iv_chave3 = gc_parametros-atpab
          IMPORTING
            et_range  = gs_atpab
        ).

        READ TABLE gs_atpab ASSIGNING FIELD-SYMBOL(<fs_atpab>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_atpab = <fs_atpab>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
