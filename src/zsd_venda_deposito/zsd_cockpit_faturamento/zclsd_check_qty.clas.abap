CLASS zclsd_check_qty DEFINITION
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



CLASS ZCLSD_CHECK_QTY IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_verif_disp_app WITH DEFAULT KEY.
    DATA: lt_atpcsx     TYPE TABLE OF atpcs.
    DATA: lt_atpcsx_dep TYPE TABLE OF atpcs.
    DATA: lt_atpdsx     TYPE TABLE OF atpds.
    DATA: lt_atpdsx_dep TYPE TABLE OF atpds.
    DATA: lt_mdpsx      TYPE TABLE OF mdps.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = <fs_data>-material
          werks                    = <fs_data>-plant
        TABLES
          mdpsx                    = lt_mdpsx
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.

      IF sy-subrc = 0.

        LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>).
          IF <fs_mdpsx>-plaab = get_atpab(  ) AND <fs_mdpsx>-lgort = <fs_data>-deposito.
*            CASE <fs_mdpsx>-delkz.
**              WHEN 'VC'.
**                <fs_data>-qtdordem = <fs_data>-qtdordem + <fs_mdpsx>-mng01.
**              WHEN 'VJ'.
**                <fs_data>-qtdremessa = <fs_data>-qtdremessa + <fs_mdpsx>-mng01.
***              WHEN 'WB'.
***                <fs_data>-qtdestoquelivre = <fs_data>-qtdestoquelivre + <fs_mdpsx>-mng01.
*            ENDCASE.
          ENDIF.
        ENDLOOP.

        CLEAR lt_mdpsx.

      ENDIF.

*      SELECT SINGLE labst
*      FROM mard
*      INTO <fs_data>-qtdestoquelivre
*      WHERE matnr = <fs_data>-material
*        AND werks = <fs_data>-plant
*        AND lgort = <fs_data>-deposito.


*      DATA(ls_atpca) = VALUE atpca( anwdg = '8'
*                                    anwdg_orig = 'A'
*                                    azerg = 'T'
*                                    rdmod = 'A'
*                                    xenqmd = 'N'
*                                    force_r3 = 'X' ).
*
*      APPEND VALUE atpcs( matnr = <fs_data>-material
*                          werks = <fs_data>-plant
*                          prreg =  get_prreg( )
*                          chmod = '011'
*                          bdter = sy-datum
*                          xline = '1'
*                          trtyp = 'A'
*                          idxatp = '1'
*                          resmd = 'X'
*                          chkflg = 'X'
*                                ) TO lt_atpcsx.
*
*
*      CALL FUNCTION 'AVAILABILITY_CHECK_S4'
*        TABLES
*          p_atpcsx = lt_atpcsx
*          p_atpdsx = lt_atpdsx
*        CHANGING
*          p_atpca  = ls_atpca
*        EXCEPTIONS
*          error    = 1
*          OTHERS   = 2.
*
*      IF sy-subrc = 0 AND lt_atpdsx[] IS NOT INITIAL.
*
*        LOOP AT lt_atpdsx ASSIGNING FIELD-SYMBOL(<fs_atpdsx>).
*          IF <fs_atpdsx>-atpab = get_atpab(  ).
*            CASE <fs_atpdsx>-delkz.
*              WHEN 'VC'.
*                <fs_data>-qtdordem = <fs_data>-qtdordem + <fs_atpdsx>-qty_o.
*              WHEN 'VJ'.
*                <fs_data>-qtdremessa = <fs_data>-qtdremessa + <fs_atpdsx>-qty_o.
*              WHEN 'WB'.
*                <fs_data>-qtdestoquelivre = <fs_data>-qtdestoquelivre + <fs_atpdsx>-qty_o.
*            ENDCASE.
*          ENDIF.
*        ENDLOOP.
*
*      ENDIF.
*      CLEAR: lt_atpcsx, lt_atpdsx, ls_atpca.

    ENDLOOP.

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


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.
ENDCLASS.
