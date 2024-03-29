CLASS zclsd_estoque_substituir DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        atp    TYPE ztca_param_par-chave2 VALUE 'ATP',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    DATA gs_atpab TYPE RANGE OF atpab.

    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

ENDCLASS.



CLASS zclsd_estoque_substituir IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF ZI_SD_SUBSTITUIR_APP WITH DEFAULT KEY.
    DATA: lt_original_data_aux TYPE STANDARD TABLE OF ZI_SD_SUBSTITUIR_APP WITH DEFAULT KEY.

    DATA: lt_mdpsx      TYPE TABLE OF mdps.

    lt_original_data     = CORRESPONDING #( it_original_data ).
    lt_original_data_aux = CORRESPONDING #( it_original_data ).

    SORT lt_original_data_aux BY material plant .
    DELETE ADJACENT DUPLICATES FROM lt_original_data_aux COMPARING material plant .

    LOOP AT lt_original_data_aux ASSIGNING FIELD-SYMBOL(<fs_data_aux>).

      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = <fs_data_aux>-material
          werks                    = <fs_data_aux>-plant
        TABLES
          mdpsx                    = lt_mdpsx
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.

      IF sy-subrc = 0.
        SORT lt_mdpsx BY delkz delnr delps delnr.

        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>) WHERE material = <fs_data_aux>-material
                                                                     AND plant    = <fs_data_aux>-plant.

          READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) WITH KEY delkz = 'WB'
                                                                          plaab = get_atpab(  ) BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_data>-EstoqueLivre = <fs_mdpsx>-mng01.
          ENDIF.
          READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx_aux>) WITH KEY delkz = 'VJ'
                                                                          plaab = get_atpab(  ) BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_data>-EstoqueRemessa = <fs_mdpsx>-mng01.
          ENDIF.
        ENDLOOP.

      ENDIF.

      CLEAR lt_mdpsx.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.

  METHOD get_atpab.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

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
