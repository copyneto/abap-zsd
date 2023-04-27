CLASS zclsd_ckpt_fat_statusft DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        atp    TYPE ztca_param_par-chave2 VALUE 'ATP',
        prreg  TYPE ztca_param_par-chave3 VALUE 'PRREG',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    TYPES: BEGIN OF ty_material_stock,
             material        TYPE mard-matnr,
             plant           TYPE mard-werks,
             storagelocation TYPE mard-lgort,
             stock           TYPE mng01,
           END OF ty_material_stock,
           ty_lt_mdpsx TYPE STANDARD TABLE OF mdps WITH DEFAULT KEY.

    METHODS filtra_dados_estoque
      CHANGING
        ct_mdpsx TYPE ty_lt_mdpsx.

    DATA gs_prreg TYPE RANGE OF prreg.
    DATA gs_atpab TYPE RANGE OF atpab.

    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

ENDCLASS.



CLASS ZCLSD_CKPT_FAT_STATUSFT IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zc_sd_ckpt_fat_app WITH DEFAULT KEY.
    DATA: lt_atpcsx     TYPE TABLE OF atpcs.
    DATA: lt_atpcsx_dep TYPE TABLE OF atpcs.
    DATA: lt_atpdsx     TYPE TABLE OF atpds.
    DATA: lt_atpdsx_dep TYPE TABLE OF atpds.
    DATA: lt_mdpsx          TYPE TABLE OF mdps.
    DATA: lt_material_stock TYPE TABLE OF ty_material_stock.
    DATA: lt_matnr_werks    TYPE pph_matnr_werks_berid_sel_tab.

    DATA: lv_qtdordem             TYPE mng01.
    DATA: lv_qtdremessa           TYPE mng01.
    DATA: lv_qtdestoquelivre      TYPE mng01.
    DATA: lv_qtddepositofechado   TYPE mng01.
    DATA: lv_saldo                TYPE mng01.

    lt_original_data = CORRESPONDING #( it_original_data ).

*    IF lt_original_data[] IS NOT INITIAL.

*      SELECT itm~material,
*             itm~plant,
*             ckp~salesorder,
*             itm~salesorderitem,
*             ckp~centrodepfechado,
*             itm~storagelocation
*        FROM zi_sd_ckpt_fat_app AS ckp
*       INNER JOIN i_salesorderitem AS itm ON itm~salesorder = ckp~salesorder
*                                         AND itm~salesdocumentrjcnreason IS INITIAL
*       INNER JOIN zi_sd_verif_disp_app AS verif ON itm~material        = verif~material
*                                               AND itm~plant           = verif~plant
*                                               AND itm~storagelocation = verif~deposito
*         FOR ALL ENTRIES IN @lt_original_data
*       WHERE ckp~salesorder = @lt_original_data-salesorder
*        INTO TABLE @DATA(lt_material).
*
*      IF lt_material[] IS NOT INITIAL.
*
*        SORT lt_material BY salesorder salesorderitem.
*        DELETE ADJACENT DUPLICATES FROM lt_material COMPARING salesorder salesorderitem.
*
*        IF lt_material[] IS NOT INITIAL.
*
*          DATA(lt_material_fae) = lt_material[].
*
*          SELECT vbeln,
*                 posnr,
*                 gbsta
*            FROM vbap
*             FOR ALL ENTRIES IN @lt_material_fae
*           WHERE vbeln = @lt_material_fae-salesorder
*             AND posnr = @lt_material_fae-salesorderitem
*            INTO TABLE @DATA(lt_vbap).
*
*          IF sy-subrc IS INITIAL.
*            SORT lt_vbap BY vbeln
*                            posnr.
*          ENDIF.
*
*        ENDIF.
*      ENDIF.
*
*    ENDIF.

*    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*
*      READ TABLE lt_material TRANSPORTING NO FIELDS WITH KEY salesorder = <fs_data>-salesorder
*                                                             BINARY SEARCH.
*
*      IF sy-subrc IS INITIAL.
*        LOOP AT lt_material ASSIGNING FIELD-SYMBOL(<fs_material>) FROM sy-tabix.
*          IF <fs_material>-salesorder <> <fs_data>-salesorder.
*            EXIT.
*          ENDIF.
*
*          READ TABLE lt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>)
*                                           WITH KEY vbeln = <fs_material>-salesorder
*                                                    posnr = <fs_material>-salesorderitem
*                                                    BINARY SEARCH.
*          IF sy-subrc IS INITIAL.
*            IF <fs_vbap>-gbsta = 'C'.
*              <fs_data>-status = TEXT-001.
*              <fs_data>-colorstatus = 3.
*              CONTINUE.
*            ENDIF.
*          ENDIF.
*
*          CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*            EXPORTING
*              matnr                    = <fs_material>-material
*              werks                    = <fs_material>-plant
*            TABLES
*              mdpsx                    = lt_mdpsx
*            EXCEPTIONS
*              material_plant_not_found = 1
*              plant_not_found          = 2
*              OTHERS                   = 3.
*
*          IF sy-subrc = 0.
*
*            LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>).
*              IF <fs_mdpsx>-plaab = get_atpab(  )
*             AND <fs_mdpsx>-lgort = <fs_material>-storagelocation.
*
*                CASE <fs_mdpsx>-delkz.
*                  WHEN 'VC'.
*                    lv_qtdordem = lv_qtdordem + <fs_mdpsx>-mng01.
*                  WHEN 'VJ'.
*                    lv_qtdremessa  = lv_qtdremessa + <fs_mdpsx>-mng01.
*                ENDCASE.
*
*              ENDIF.
*            ENDLOOP.
*            CLEAR: lt_mdpsx.
*          ENDIF.
*
*          SELECT SINGLE labst
*            FROM mard
*            INTO lv_qtdestoquelivre
*           WHERE matnr = <fs_material>-material
*             AND werks = <fs_material>-plant
*             AND lgort = <fs_material>-storagelocation.
*
*          lv_saldo = lv_qtdestoquelivre - lv_qtdremessa - lv_qtdordem.
*
*          IF lv_saldo >= 0.
*            <fs_data>-status = TEXT-001.
*            <fs_data>-colorstatus = 3.
*          ELSE.
*            <fs_data>-status = TEXT-002.
*            <fs_data>-colorstatus = 1.
*            EXIT.
*          ENDIF.
*
*          CLEAR: lv_qtdordem, lv_qtdremessa, lv_qtdestoquelivre, lv_saldo, lt_mdpsx.
*
*        ENDLOOP.
*      ENDIF.
*    ENDLOOP.

    IF lt_original_data[] IS NOT INITIAL.

      SELECT *
      FROM zi_sd_ckpt_fat_disp_estoque
      INTO TABLE @DATA(lt_sales_materials)
      FOR ALL ENTRIES IN @lt_original_data
      WHERE salesdocument = @lt_original_data-salesorder.

      SORT: lt_sales_materials BY salesdocument salesdocumentitem.

    ENDIF.

*****    lt_material_stock = CORRESPONDING #( lt_sales_materials ).
*****    DELETE ADJACENT DUPLICATES FROM lt_material_stock COMPARING material plant storagelocation.
*****    SORT lt_material_stock BY material plant storagelocation.

*****    DATA(lv_atpab) = get_atpab(  ).
*****
*****    lt_matnr_werks = CORRESPONDING #( lt_material_stock MAPPING matnr = material
*****                                                                werks = plant ).

**********************************************************************
*** Calcula quantidade de estoque em ordem e em remessa
**********************************************************************

*****    CALL FUNCTION 'PPH_STOCK_REQ_LISTS_PREREAD'
*****      EXPORTING
*****        it_matnr_werks_berid = lt_matnr_werks.
*****
*****    LOOP AT lt_material_stock ASSIGNING FIELD-SYMBOL(<fs_material_stock>).
*****
*****      CLEAR lt_mdpsx.
*****      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*****        EXPORTING
*****          matnr                    = <fs_material_stock>-material
*****          werks                    = <fs_material_stock>-plant
*****        TABLES
*****          mdpsx                    = lt_mdpsx
*****        EXCEPTIONS
*****          material_plant_not_found = 1
*****          plant_not_found          = 2
*****          OTHERS                   = 3.
*****
*****      IF sy-subrc = 0.
*****
*****        filtra_dados_estoque( CHANGING ct_mdpsx = lt_mdpsx ).
*****
*****        READ TABLE lt_mdpsx TRANSPORTING NO FIELDS WITH KEY plaab = lv_atpab
*****                                                            lgort = <fs_material_stock>-storagelocation BINARY SEARCH.
*****
*****        CHECK sy-subrc IS INITIAL.
*****
*****        LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
*****          IF <fs_mdpsx>-plaab <> lv_atpab OR <fs_mdpsx>-lgort <> <fs_material_stock>-storagelocation .
*****            EXIT.
*****          ENDIF.
*****
*****          CASE <fs_mdpsx>-delkz.
*****            WHEN 'VC'.
*****              lv_qtdordem = lv_qtdordem + <fs_mdpsx>-mng01.
*****            WHEN 'VJ'.
*****              lv_qtdremessa  = lv_qtdremessa + <fs_mdpsx>-mng01.
*****          ENDCASE.
*****        ENDLOOP.
*****
*****        <fs_material_stock>-stock = <fs_material_stock>-stock - lv_qtdremessa - lv_qtdordem.
*****
*****        CLEAR: lv_qtdordem, lv_qtdremessa.
*****      ENDIF.
*****    ENDLOOP.

**********************************************************************
*** Atualizando os campos de Status
**********************************************************************

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_sales_materials TRANSPORTING NO FIELDS WITH KEY salesdocument = <fs_data>-salesorder BINARY SEARCH.

      CHECK sy-subrc IS INITIAL.

      LOOP AT lt_sales_materials ASSIGNING FIELD-SYMBOL(<fs_material>) FROM sy-tabix.
        IF <fs_material>-salesdocument <> <fs_data>-salesorder.
          EXIT.
        ENDIF.

        "Verificando se foi encontrado registro no estoque tanto para o centro da ordem ou para
        "o centro do depósito fechado.
        IF <fs_material>-stockmardexist IS INITIAL AND <fs_material>-stockdfmardexist IS INITIAL.
          EXIT.
        ENDIF.

*****        READ TABLE lt_material_stock ASSIGNING <fs_material_stock> WITH KEY material        = <fs_material>-material
*****                                                                              plant           = <fs_material>-plant
*****                                                                              storagelocation = <fs_material>-storagelocation
*****                                                                              BINARY SEARCH.

*****        IF sy-subrc IS INITIAL.
          IF <fs_material>-stockmardexist = abap_true.
            IF <fs_data>-status <> TEXT-002.
*****              IF <fs_material>-sdprocessstatus = 'C' OR <fs_material_stock>-stock >= 0.
              IF <fs_material>-sdprocessstatus = 'C' OR <fs_material>-saldolivre > 0.
                <fs_data>-status      = TEXT-001. "Disponível
                <fs_data>-colorstatus = 3.
              ELSE.
                <fs_data>-status      = TEXT-002. "Indisponível
                <fs_data>-colorstatus = 1.
              ENDIF.
            ENDIF.
          ELSE.
            <fs_data>-status      = TEXT-002. "Indisponível
            <fs_data>-colorstatus = 1.
          ENDIF.
*****        ENDIF.

        IF <fs_material>-stockdfmardexist = abap_true.
          IF <fs_data>-statusdf <> TEXT-002.
*****            lv_saldo = <fs_material>-stockdf - <fs_material>-orderquantity.

            IF <fs_material>-saldodf > 0.
              <fs_data>-statusdf      = TEXT-001. "Disponível
              <fs_data>-colorstatusdf = 3.
            ELSE.
              <fs_data>-statusdf      = TEXT-002. "Indisponível
              <fs_data>-colorstatusdf = 1.
            ENDIF.
          ENDIF.
        ELSE.
          <fs_data>-statusdf      = TEXT-002. "Indisponível
          <fs_data>-colorstatusdf = 1.
        ENDIF.

        "Verificando se os dois status estão indisponíveis. Caso sim, sair do loop
        IF <fs_data>-status = TEXT-002 AND <fs_data>-statusdf <> TEXT-002.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD filtra_dados_estoque.

    DELETE ct_mdpsx WHERE mng01 = 0.
    DELETE ct_mdpsx WHERE delkz <> 'VC' AND delkz <>'VJ'.
    SORT ct_mdpsx BY plaab lgort.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.


  METHOD get_atpab.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

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
