CLASS zclsd_verif_util_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    TYPES:BEGIN OF ty_filtros,
            salesorder        TYPE if_rap_query_filter=>tt_range_option,
            salesorderitem    TYPE if_rap_query_filter=>tt_range_option,
            material          TYPE if_rap_query_filter=>tt_range_option,
            plant             TYPE if_rap_query_filter=>tt_range_option,
            customer          TYPE if_rap_query_filter=>tt_range_option,
            salesordertype    TYPE if_rap_query_filter=>tt_range_option,
            orderquantity     TYPE if_rap_query_filter=>tt_range_option,
            orderquantityunit TYPE if_rap_query_filter=>tt_range_option,
            datafat           TYPE if_rap_query_filter=>tt_range_option,
            ean               TYPE if_rap_query_filter=>tt_range_option,
            ordem             TYPE if_rap_query_filter=>tt_range_option,
          END OF ty_filtros.

    DATA gs_filtros TYPE ty_filtros.

    TYPES:  ty_verif_util         TYPE STANDARD TABLE OF zc_sd_verif_util_custom_app WITH EMPTY KEY.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
        atp    TYPE ztca_param_par-chave2 VALUE 'ATP',
        prreg  TYPE ztca_param_par-chave3 VALUE 'PRREG',
        atpab  TYPE ztca_param_par-chave3 VALUE 'ATPAB',
      END OF gc_parametros.

    DATA gs_atpab TYPE RANGE OF atpab.

    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters TYPE if_rap_query_filter=>tt_name_range_pairs.

    METHODS:   build EXPORTING et_verif_util TYPE ty_verif_util.

    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCLSD_VERIF_UTIL_CUSTOM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)       = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)      = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows)  = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).
** ---------------------------------------------------------------------------
** Recupera e seta filtros de seleção
** ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) ). "#EC CI_CONV_OK
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        DATA(lv_exp_msg) = lo_ex_filter->get_longtext( ).
    ENDTRY.
*** ---------------------------------------------------------------------------
*** Monta relatório
*** ---------------------------------------------------------------------------
    me->build( IMPORTING et_verif_util = DATA(lt_result) ).
** ---------------------------------------------------------------------------
** Realiza ordenação de acordo com parâmetros de entrada
** ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).
    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.
* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result_aux IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result_aux ) ).

* ---------------------------------------------------------------------------
* Monta o total de registros
* ---------------------------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.
* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada e exibe registros
* ---------------------------------------------------------------------------
    TRY.
        CHECK io_request->is_data_requested( ).
        io_response->set_data( lt_result_page[] ).
      CATCH cx_rfc_dest_provider_error INTO DATA(lo_ex_dest).
        lv_exp_msg = lo_ex_dest->get_longtext( ).
        RETURN.
    ENDTRY.


  ENDMETHOD.


  METHOD set_filters.

    IF it_filters IS NOT INITIAL.

      TRY.
          gs_filtros-salesorder   = it_filters[ name = 'SALESORDER' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-salesorderitem   = it_filters[ name = 'SALESORDERITEM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-material   = it_filters[ name = 'MATERIAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-plant   = it_filters[ name = 'PLANT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.


      TRY.
          gs_filtros-customer = it_filters[ name = 'CUSTOMER' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-salesordertype   = it_filters[ name = 'SALESORDERTYPE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-orderquantity  = it_filters[ name = 'ORDERQUANTITY' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-orderquantityunit   = it_filters[ name = 'ORDERQUANTITYUNIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-datafat  = it_filters[ name = 'DATAFAT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-ean   = it_filters[ name = 'EAN' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD build.

*****    DATA: lt_mdpsx      TYPE TABLE OF mdps.

    SELECT *
    FROM zi_sd_verif_util_app
    WHERE salesorder        IN @gs_filtros-salesorder
      AND salesorderitem    IN @gs_filtros-salesorderitem
      AND material          IN @gs_filtros-material
      AND plant             IN @gs_filtros-plant
      AND customer          IN @gs_filtros-customer
      AND salesordertype    IN @gs_filtros-salesordertype
      AND orderquantity     IN @gs_filtros-orderquantity
      AND orderquantityunit IN @gs_filtros-orderquantityunit
      AND datafat           IN @gs_filtros-datafat
      AND ean               IN @gs_filtros-ean
    INTO CORRESPONDING FIELDS OF TABLE @et_verif_util.

*****    DATA(lt_data) = et_verif_util[].
*****
*****    SORT lt_data BY material plant .
*****    DELETE ADJACENT DUPLICATES FROM lt_data COMPARING material plant .
*****
*****    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data_aux>).
*****
*****      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*****        EXPORTING
*****          matnr                    = <fs_data_aux>-material
*****          werks                    = <fs_data_aux>-plant
*****        TABLES
*****          mdpsx                    = lt_mdpsx
*****        EXCEPTIONS
*****          material_plant_not_found = 1
*****          plant_not_found          = 2
*****          OTHERS                   = 3.
*****
*****      IF sy-subrc = 0.

*        SORT lt_mdpsx BY delkz delnr delps delnr.

*****        SORT lt_mdpsx BY delkz delnr delps plaab.
*****
*****        LOOP AT et_verif_util ASSIGNING FIELD-SYMBOL(<fs_data>) WHERE material = <fs_data_aux>-material
*****                                                                     AND plant    = <fs_data_aux>-plant.
*****
*****          DATA(lv_index) = sy-tabix.

*          READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) WITH KEY delkz = 'VC'
*                                                                          delnr = <fs_data>-salesorder
*                                                                          delps = <fs_data>-salesorderitem
*                                                                          plaab = get_atpab(  ) BINARY SEARCH.

*****          READ TABLE lt_mdpsx  TRANSPORTING NO FIELDS WITH KEY  delkz = 'VC'
*****                                                                delnr = <fs_data>-salesorder
*****                                                                delps = <fs_data>-salesorderitem
*****                                                                plaab = get_atpab(  ) BINARY SEARCH.
*****          IF sy-subrc IS INITIAL.
*****            LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
*****
*****              IF <fs_mdpsx>-delkz <> 'VC'
*****              OR <fs_mdpsx>-delnr <> <fs_data>-salesorder
*****              OR <fs_mdpsx>-delps <> <fs_data>-salesorderitem
*****              OR <fs_mdpsx>-plaab <> get_atpab(  ).
*****
*****                EXIT.
*****              ENDIF.
*****
*****              <fs_data>-qtdebase = <fs_data>-qtdebase + <fs_mdpsx>-mng01.

*            IF sy-subrc = 0.
*              <fs_data>-qtdebase = <fs_mdpsx>-mng01.
*            ELSE.
*              DELETE et_verif_util INDEX lv_index.
*            ENDIF.

*****            ENDLOOP.
*****          ELSE.
*****            DELETE et_verif_util INDEX lv_index.
*****          ENDIF.
*****
*****        ENDLOOP.

        SORT et_verif_util BY salesorder salesorderitem material  plant.
        DELETE ADJACENT DUPLICATES FROM et_verif_util COMPARING salesorder salesorderitem material  plant.

*****      ENDIF.
*****
*****      CLEAR lt_mdpsx.
*****
*****    ENDLOOP.

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
