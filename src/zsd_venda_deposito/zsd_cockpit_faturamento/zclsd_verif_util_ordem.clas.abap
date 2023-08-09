CLASS zclsd_verif_util_ordem DEFINITION
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
        prreg  TYPE ztca_param_par-chave3 VALUE 'PRREG',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    DATA gs_prreg TYPE RANGE OF prreg.
    DATA gs_atpab TYPE RANGE OF atpab.

    METHODS get_prreg RETURNING VALUE(rv_prreg) TYPE prreg.
    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

ENDCLASS.



CLASS ZCLSD_VERIF_UTIL_ORDEM IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_verif_util_app WITH DEFAULT KEY.
    DATA: lt_original_data_aux TYPE STANDARD TABLE OF zi_sd_verif_util_app WITH DEFAULT KEY.

    DATA: lt_mdpsx      TYPE TABLE OF mdps.

    lt_original_data     = CORRESPONDING #( it_original_data ).
    lt_original_data_aux = CORRESPONDING #( it_original_data ).

*    SORT lt_original_data     BY material plant .
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

*        READ TABLE lt_original_data WITH KEY material = <fs_data_aux>-material
*                                             plant    = <fs_data_aux>-plant TRANSPORTING NO FIELDS BINARY SEARCH.
*
*        IF sy-subrc = 0.

*          LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>) FROM sy-tabix.
*
*            IF <fs_data_aux>-material NE <fs_data>-material
*            OR <fs_data_aux>-plant    NE <fs_data>-plant .
*              EXIT.
*            ENDIF.

        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>) WHERE material = <fs_data_aux>-material
                                                                     AND plant    = <fs_data_aux>-plant.

          READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) WITH KEY delkz = 'VC'
                                                                          delnr = <fs_data>-salesorder
                                                                          delps = <fs_data>-salesorderitem
                                                                          plaab = get_atpab(  ) BINARY SEARCH.
          IF sy-subrc = 0.
            <fs_data>-orderquantity = <fs_mdpsx>-mng01.
*            <fs_data>-ordem         = <fs_data>-Material.
*            ELSE.
*            <fs_data>-ordem         = 1.
          ENDIF.
        ENDLOOP.
*        ENDIF.

      ENDIF.

      CLEAR lt_mdpsx.

    ENDLOOP.

*    DELETE lt_original_data WHERE ordem NE 'X'.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD get_prreg.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    CLEAR gs_prreg.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-atp
      iv_chave3 = gc_parametros-prreg
          IMPORTING
            et_range  = gs_prreg
        ).

        READ TABLE gs_prreg ASSIGNING FIELD-SYMBOL(<fs_prreg>) INDEX 1.
        CHECK sy-subrc = 0.
        rv_prreg = <fs_prreg>-low.

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_atpab.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

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


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
