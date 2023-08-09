CLASS zclsd_substituir_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    TYPES:BEGIN OF ty_filtros,
            salesorder        TYPE if_rap_query_filter=>tt_range_option,
            salesorderitem    TYPE if_rap_query_filter=>tt_range_option,
            materialatual     TYPE if_rap_query_filter=>tt_range_option,
            material          TYPE if_rap_query_filter=>tt_range_option,
            plant             TYPE if_rap_query_filter=>tt_range_option,
            orderquantity     TYPE if_rap_query_filter=>tt_range_option,
            orderquantityunit TYPE if_rap_query_filter=>tt_range_option,
            ean               TYPE if_rap_query_filter=>tt_range_option,
          END OF ty_filtros.

    TYPES:BEGIN OF ty_fechado,
            material      TYPE matnr,
            destiny_plant TYPE werks_d,
            origin_plant  TYPE werks_d,
            qtdeposito    TYPE  mng01,
          END OF ty_fechado.

    TYPES:BEGIN OF ty_sales,
            salesorder         TYPE vbeln,
            salesorderitem     TYPE posnr,
            materialatual      TYPE matnr,
            distributionchanel TYPE vtweg,
            pricelist          TYPE pltyp,
            plant              TYPE werks_d,
            material           TYPE matnr,
            pricingdate        TYPE prsdt,
          END OF ty_sales.

    DATA gs_filtros TYPE ty_filtros.
    DATA: lv_qtdestoquelivre      TYPE mng01.
    DATA: lv_qtddepositofechado   TYPE mng01.

    TYPES:  ty_substituir         TYPE STANDARD TABLE OF zc_sd_substituir_custom_app WITH EMPTY KEY.

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
    DATA lt_salesorder TYPE TABLE OF ty_sales.
    DATA ls_sales TYPE ty_sales.

    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters TYPE if_rap_query_filter=>tt_name_range_pairs.

    METHODS:   build EXPORTING et_substituir TYPE ty_substituir.

    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

  PROTECTED SECTION.
  PRIVATE SECTION.


ENDCLASS.



CLASS ZCLSD_SUBSTITUIR_CUSTOM IMPLEMENTATION.


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
    me->build( IMPORTING et_substituir = DATA(lt_result) ).
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
          gs_filtros-materialatual   = it_filters[ name = 'MATERIALATUAL' ]-range. "#EC CI_STDSEQ
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
          gs_filtros-ean   = it_filters[ name = 'EAN' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD build.

*****    DATA: lt_mdpsx      TYPE TABLE OF mdps.
*****
*****    DATA: lt_qtdeposito        TYPE TABLE OF ty_fechado,
*****          ls_qt_deposito       TYPE ty_fechado,
*****          lv_gtdepositofechado TYPE mng01,
*****          lt_matnr_werks TYPE pph_matnr_werks_berid_sel_tab.


    SELECT *
    FROM zi_sd_substituir_app
    WHERE salesorder        IN @gs_filtros-salesorder
      AND salesorderitem    IN @gs_filtros-salesorderitem
      AND materialatual     IN @gs_filtros-materialatual
      AND material          IN @gs_filtros-material
      AND plant             IN @gs_filtros-plant
      AND orderquantity     IN @gs_filtros-orderquantity
      AND orderquantityunit IN @gs_filtros-orderquantityunit
      AND ean               IN @gs_filtros-ean
    INTO CORRESPONDING FIELDS OF TABLE @et_substituir.

*****    DATA(lt_data) = et_substituir[].
*****    SORT lt_data BY material plant .
*****    DELETE ADJACENT DUPLICATES FROM lt_data COMPARING material plant.

*****    DATA(lt_dep)  = et_substituir[].
*****    SORT lt_dep BY salesorder salesorderitem .
*****    DELETE ADJACENT DUPLICATES FROM lt_dep COMPARING salesorder salesorderitem .
*****    DATA(lt_fec)  = et_substituir[].
*****    SORT lt_fec BY plant.
*****    DELETE ADJACENT DUPLICATES FROM lt_fec COMPARING plant .


*****    IF lt_fec[] IS NOT INITIAL.
*****
*****      SELECT centrofaturamento, centrodepfechado
*****         FROM ztsd_centrofatdf
*****           INTO TABLE @DATA(lt_fechado)
*****         FOR ALL ENTRIES IN @lt_fec
*****       WHERE centrofaturamento = @lt_fec-plant.
*****
*****      IF sy-subrc IS INITIAL.
*****
*****        SORT lt_fechado BY centrofaturamento.
*****
*****      ENDIF.
*****
*****    ENDIF.

*****   IF lt_dep[] IS NOT INITIAL.
*****      SELECT salesorder, salesorderitem, storagelocation
*****      FROM i_salesorderitem
*****        INTO TABLE @DATA(lt_deposito)
*****      FOR ALL ENTRIES IN @lt_dep
*****    WHERE salesorder = @lt_dep-salesorder
*****    AND   salesorderitem = @lt_dep-salesorderitem
*****  .
*****
*****      IF sy-subrc IS INITIAL.
*****
*****        SORT lt_deposito BY salesorder salesorderitem.
*****
*****      ENDIF.
*****    ENDIF.
*****
*****    lt_matnr_werks = CORRESPONDING #( lt_data MAPPING matnr = material
*****                                                      werks = plant ).
*****
*****    CALL FUNCTION 'PPH_STOCK_REQ_LISTS_PREREAD'
*****      EXPORTING
*****        it_matnr_werks_berid = lt_matnr_werks.
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

*****      IF sy-subrc = 0.

*        SORT lt_mdpsx BY delkz delnr delps delnr.

*****        SORT lt_mdpsx BY delkz delnr delps plaab lgort.
*****
*****        LOOP AT et_substituir ASSIGNING FIELD-SYMBOL(<fs_data>) WHERE material = <fs_data_aux>-material
*****                                                                     AND plant    = <fs_data_aux>-plant.
*****
*****          DATA(lv_index) = sy-tabix.
*****
*****          READ TABLE lt_deposito INTO DATA(ls_deposito) WITH KEY salesorder = <fs_data_aux>-salesorder
*****                                                                 salesorderitem = <fs_data_aux>-salesorderitem
*****                                                                 BINARY SEARCH.
*****
*****          IF sy-subrc IS INITIAL.

*            READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) WITH KEY delkz = 'WB'
*                                                                            plaab = get_atpab(  )
*                                                                            lgort = ls_deposito-storagelocation
*                                                                             BINARY SEARCH.
*            IF sy-subrc = 0.

*****            SELECT SINGLE  labst
*****            FROM mard
*****            INTO lv_qtdestoquelivre
*****            WHERE matnr = <fs_data_aux>-material
*****              AND werks = <fs_data_aux>-plant
*****              AND lgort = ls_deposito-storagelocation.
*****
*****
*****            READ TABLE lt_fechado INTO DATA(ls_fechado) WITH KEY centrofaturamento = <fs_data_aux>-plant
*****            BINARY SEARCH.
*****
*****            IF sy-subrc IS INITIAL.
*****
*****              SELECT SINGLE  labst
*****              FROM mard
*****              INTO lv_qtddepositofechado
*****              WHERE matnr = <fs_data_aux>-material
*****                AND werks = ls_fechado-centrodepfechado
*****                AND lgort = ls_deposito-storagelocation.
*****
*****            ENDIF.





*              <fs_data>-estoquelivre = <fs_mdpsx>-mng01 + lv_qtdestoquelivre + lv_qtddepositofechado.

*****            <fs_data>-estoquelivre =  + lv_qtdestoquelivre + lv_qtddepositofechado.

*            ENDIF.

*****            READ TABLE lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx_aux>) WITH KEY delkz = 'VJ'
*****                                                                            plaab = get_atpab(  )
*****                                                                            lgort = ls_deposito-storagelocation
*****                                                                             BINARY SEARCH.
*****            IF sy-subrc = 0.
*****              <fs_data>-estoqueremessa = <fs_mdpsx_aux>-mng01.
*****            ENDIF.

*              SELECT SINGLE  labst
*      FROM mard
*      INTO lv_qtdestoquelivre
*      WHERE matnr = <fs_data_aux>-material
*        AND werks = <fs_data_aux>-Plant
*        AND lgort = ls_deposito-storagelocation.
*
*      SELECT SINGLE  labst
*      FROM mard
*      INTO lv_qtddepositofechado
*      WHERE matnr = <fs_data_aux>-material
*        AND werks = <fs_material>-centrodepfechado
*        AND lgort = <fs_material>-deposito.
*
*          lv_saldo = lv_qtdestoquelivre + lv_qtddepositofechado - lv_qtdremessa - lv_qtdordem.
**          lv_saldo = lv_qtdestoquelivre - lv_qtdremessa - lv_qtdordem.
*
*          IF  lv_saldo >= 0.
*            <fs_data>-status = TEXT-001.
*            <fs_data>-colorstatus = 3.
*          ELSE.
*            <fs_data>-status = TEXT-002.
*            <fs_data>-colorstatus = 1.
*            EXIT.
*          ENDIF.
*
*          CLEAR: lv_qtdordem, lv_qtdremessa, lv_qtdestoquelivre, lv_qtddepositofechado, lv_saldo, lt_mdpsx .

*****          ENDIF.
*****        ENDLOOP.


*          ELSE.
*            DELETE et_substituir INDEX lv_index.
*          ENDIF.
*
*        ENDLOOP.

*        DELETE ADJACENT DUPLICATES FROM et_substituir COMPARING salesorder  salesorderitem material  plant.

******      ENDIF.
******
******      CLEAR lt_mdpsx.
******
******    ENDLOOP.

*      IF  lt_data[] IS NOT INITIAL.
*        SELECT destiny_plant,
*               destiny_plant_type,
*               origin_plant,
*               origin_plant_type
*        FROM ztmm_prm_dep_fec
*        INTO TABLE @DATA(lt_fechado)
*        FOR ALL ENTRIES IN @lt_data
*       WHERE destiny_plant      = @lt_data-plant
*         AND destiny_plant_type = '02'
*         AND origin_plant_type  = '01'.
*        IF  sy-subrc IS INITIAL.
*
*          SORT lt_fechado BY destiny_plant.
*
*          LOOP AT et_substituir ASSIGNING FIELD-SYMBOL(<fs_data_fc>).
*
*            READ TABLE lt_fechado ASSIGNING FIELD-SYMBOL(<fs_fech>) WITH KEY destiny_plant = <fs_data_fc>-plant
*                                                                    BINARY SEARCH.
*
*            IF sy-subrc IS INITIAL.
*
*              CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*                EXPORTING
*                  matnr                    = <fs_data_fc>-material
*                  werks                    = <fs_fech>-origin_plant
*                TABLES
*                  mdpsx                    = lt_mdpsx
*                EXCEPTIONS
*                  material_plant_not_found = 1
*                  plant_not_found          = 2
*                  OTHERS                   = 3.
*
*              IF sy-subrc = 0.
*
*                LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx2>).
*                  IF <fs_mdpsx2>-plaab = get_atpab(  ).
*                    CASE <fs_mdpsx2>-delkz.
*                      WHEN 'WB'.
*                        lv_gtdepositofechado  = lv_gtdepositofechado  + <fs_mdpsx2>-mng01.
*                    ENDCASE.
*                  ENDIF.
*                ENDLOOP.
*              ENDIF.
*              <fs_data_fc>-estoquelivre = <fs_data_fc>-estoquelivre + lv_gtdepositofechado.
*              CLEAR lv_gtdepositofechado.
*            ENDIF.
*          ENDLOOP.
*
*        ENDIF.
*      ENDIF.

*****    DATA(lt_data_aux) = et_substituir[].

*    SORT lt_data_aux BY salesorder salesorderitem materialatual.
*    DELETE ADJACENT DUPLICATES FROM lt_data_aux COMPARING salesorder salesorderitem materialatual.

*****    FREE lt_salesorder.
*****
*****    IF lt_data_aux[] IS NOT INITIAL.
*****      SELECT  a~salesorder,
*****              a~salesorderitem,
*****              a~material,
*****              a~pricingdate,
*****              a~plant,
*****              b~salesorganization,
*****              b~distributionchannel,
*****              b~pricelisttype
*****      FROM i_salesorderitem AS a
*****      INNER JOIN i_salesorder AS b
*****      ON b~salesorder = a~salesorder
*****      FOR ALL ENTRIES IN @lt_data_aux
*****      WHERE a~salesorder     = @lt_data_aux-salesorder
*****        AND a~salesorderitem = @lt_data_aux-salesorderitem
*****        AND a~material       = @lt_data_aux-materialatual
*****      INTO TABLE @DATA(lt_sales).
*****    ENDIF.
*****    IF sy-subrc IS INITIAL.
*****
*****      DATA(lt_sales_bk) = lt_sales[].
*****      SORT lt_sales_bk BY salesorder salesorderitem material .
*****
*****      LOOP AT lt_data_aux ASSIGNING FIELD-SYMBOL(<fs_data_aux2>).
*****
*****        READ TABLE lt_sales_bk ASSIGNING FIELD-SYMBOL(<fs_sales_aux>) WITH KEY salesorder     = <fs_data_aux2>-salesorder
*****                                                                               salesorderitem = <fs_data_aux2>-salesorderitem
*****                                                                               material       = <fs_data_aux2>-materialatual
*****                                                                               BINARY SEARCH.
*****        IF <fs_sales_aux> IS ASSIGNED.
*****          ls_sales-salesorder         = <fs_data_aux2>-salesorder.
*****          ls_sales-salesorderitem     = <fs_data_aux2>-salesorderitem.
*****          ls_sales-materialatual      = <fs_data_aux2>-materialatual.
*****          ls_sales-distributionchanel = <fs_sales_aux>-distributionchannel.
*****          ls_sales-pricelist          = <fs_sales_aux>-pricelisttype.
*****          ls_sales-plant              = <fs_sales_aux>-plant.
*****          ls_sales-material           = <fs_data_aux2>-material.
*****          ls_sales-pricingdate        = <fs_sales_aux>-pricingdate.
*****
*****          APPEND ls_sales TO lt_salesorder.
*****          CLEAR  ls_sales.
*****
*****        ENDIF.
*****      ENDLOOP.

*****      DATA(lt_sales_aux) = lt_salesorder[].
*****      SORT lt_sales_aux BY distributionchanel pricelist plant material pricingdate.

*      DELETE ADJACENT DUPLICATES FROM lt_sales_aux COMPARING distributionchannel pricelisttype plant material pricingdate.

*****      IF lt_sales_aux[] IS NOT INITIAL.
*****        SELECT knumh, vtweg, pltyp, werks, matnr, datbi, datab
*****        FROM a817
*****        INTO TABLE @DATA(lt_a817)
*****        FOR ALL ENTRIES IN @lt_sales_aux
*****        WHERE kschl = 'ZPR0'

*and VKORG = @lt_sales-SALESORGANIZATION

*****        AND vtweg =  @lt_sales_aux-distributionchanel
*****        AND pltyp =  @lt_sales_aux-pricelist
*****        AND werks =  @lt_sales_aux-plant
*****        AND matnr =  @lt_sales_aux-material
*****        AND datbi >= @lt_sales_aux-pricingdate
*****        AND datab <= @lt_sales_aux-pricingdate .
*****
*****        IF sy-subrc IS INITIAL.
*****
*****          DATA(lt_a817_aux) = lt_a817[].
*****          SORT lt_a817_aux BY knumh.
*****          DELETE ADJACENT DUPLICATES FROM lt_a817_aux COMPARING knumh.
*****
*****          SORT lt_a817 BY vtweg pltyp werks matnr.
*****
*****        ENDIF.
*****      ENDIF.
*****
*****      DATA(lt_sales_aux2) = lt_salesorder[].
*****      SORT lt_sales_aux2 BY distributionchanel  plant material pricingdate.

*      DELETE ADJACENT DUPLICATES FROM lt_sales_aux2 COMPARING distributionchanel  plant material pricingdate.

*****      IF lt_sales_aux2[] IS NOT INITIAL.
*****        SELECT knumh, vtweg, werks, matnr, datbi, datab
*****        FROM a816
*****        INTO TABLE @DATA(lt_a816)
*****        FOR ALL ENTRIES IN @lt_sales_aux2
*****        WHERE kschl = 'ZPR0'

*and VKORG = @lt_sales-SALESORGANIZATION

*****        AND vtweg =  @lt_sales_aux2-distributionchanel
*****        AND werks =  @lt_sales_aux2-plant
*****        AND matnr =  @lt_sales_aux2-material
*****        AND datbi >= @lt_sales_aux2-pricingdate
*****        AND datab <= @lt_sales_aux2-pricingdate .
*****
*****        IF sy-subrc IS INITIAL.
*****
*****          DATA(lt_a816_aux) = lt_a816[].
*****          SORT lt_a816_aux BY knumh.
*****          DELETE ADJACENT DUPLICATES FROM lt_a816_aux COMPARING knumh.
*****
*****          SORT lt_a816 BY vtweg werks matnr datbi datab.
*****
*****        ENDIF.
*****      ENDIF.
*****
*****      IF lt_a817_aux[] IS NOT INITIAL.
*****        SELECT knumh, kbetr, konwa, kpein, kmein
*****        FROM konp
*****         INTO TABLE @DATA(lt_konp_817)
*****         FOR ALL ENTRIES IN @lt_a817_aux
*****         WHERE knumh = @lt_a817_aux-knumh
*****           AND loevm_ko = @space.
*****
*****        IF sy-subrc IS INITIAL.
*****          SORT lt_konp_817 BY knumh.
*****        ENDIF.
*****      ENDIF.
*****
*****      IF lt_a816_aux[] IS NOT INITIAL.
*****        SELECT knumh, kbetr, konwa, kpein, kmein
*****        FROM konp
*****         INTO TABLE @DATA(lt_konp_816)
*****         FOR ALL ENTRIES IN @lt_a816_aux
*****         WHERE knumh = @lt_a816_aux-knumh
*****           AND loevm_ko = @space.
*****
*****        IF sy-subrc IS INITIAL.
*****          SORT lt_konp_816 BY knumh.
*****        ENDIF.
*****      ENDIF.
*****
*****      SORT lt_salesorder BY salesorder salesorderitem materialatual material.
*****      LOOP AT et_substituir ASSIGNING FIELD-SYMBOL(<fs_substituir>).
*****
*****        READ TABLE lt_salesorder INTO DATA(ls_salesorder) WITH KEY salesorder     = <fs_substituir>-salesorder
*****                                                                   salesorderitem = <fs_substituir>-salesorderitem
*****                                                                   materialatual   = <fs_substituir>-materialatual
*****                                                                   material        = <fs_substituir>-material
*****                                                                   BINARY SEARCH.
*****        IF sy-subrc IS INITIAL.
*****
*****          READ TABLE lt_a817 INTO DATA(ls_a817) WITH KEY vtweg =  ls_salesorder-distributionchanel
*****                                                         pltyp =  ls_salesorder-pricelist
*****                                                         werks =  ls_salesorder-plant
*****                                                         matnr =  <fs_substituir>-material
*****                                                         BINARY SEARCH.
*****          IF sy-subrc IS INITIAL.
*****
*****            READ TABLE lt_konp_817 INTO DATA(ls_konp_817) WITH KEY knumh = ls_a817-knumh
*****                                                                  BINARY SEARCH.
*****
*****            IF sy-subrc IS INITIAL.
*****
*****              <fs_substituir>-preco     = ls_konp_817-kbetr.
*****              <fs_substituir>-moeda     = ls_konp_817-konwa.
*****              <fs_substituir>-umpreco   = ls_konp_817-kmein.
*****              <fs_substituir>-unitpreco = ls_konp_817-kpein.
*****
*****            ELSE.
*****
*****              READ TABLE lt_a816 INTO DATA(ls_a816) WITH KEY vtweg =  ls_salesorder-distributionchanel
*****                                                             werks =  ls_salesorder-plant
*****                                                             matnr =  <fs_substituir>-material
*****                                                             BINARY SEARCH.
*****              IF sy-subrc IS INITIAL.
*****
*****                READ TABLE lt_konp_816 INTO DATA(ls_konp_816) WITH KEY knumh = ls_a816-knumh
*****                                                                               BINARY SEARCH.
*****
*****                IF sy-subrc IS INITIAL.
*****
*****                  <fs_substituir>-preco     = ls_konp_816-kbetr.
*****                  <fs_substituir>-moeda     = ls_konp_816-konwa.
*****                  <fs_substituir>-umpreco   = ls_konp_816-kmein.
*****                  <fs_substituir>-unitpreco = ls_konp_816-kpein.
*****
*****                ENDIF.
*****              ENDIF.
*****
*****            ENDIF.
*****          ELSE.
*****
*****            READ TABLE lt_a816 INTO DATA(ls_a8162) WITH KEY vtweg =  ls_salesorder-distributionchanel
*****                                                                          werks =  ls_salesorder-plant
*****                                                                          matnr =  <fs_substituir>-material
*****                                                                          BINARY SEARCH.
*****            IF sy-subrc IS INITIAL.
*****
*****              READ TABLE lt_konp_816 INTO DATA(ls_konp_8162) WITH KEY knumh = ls_a8162-knumh
*****                                                                                    BINARY SEARCH.
*****
*****              IF sy-subrc IS INITIAL.
*****
*****                <fs_substituir>-preco     = ls_konp_8162-kbetr.
*****                <fs_substituir>-moeda     = ls_konp_8162-konwa.
*****                <fs_substituir>-umpreco   = ls_konp_8162-kmein.
*****                <fs_substituir>-unitpreco = ls_konp_8162-kpein.
*****
*****              ENDIF.
*****            ENDIF.
*****          ENDIF.
*****        ENDIF.
*****
*****        CLEAR: ls_salesorder, ls_a817, ls_konp_817, ls_a816, ls_konp_816, ls_a8162, ls_konp_8162.
*****      ENDLOOP.
*****    ENDIF.
*****
*****    DELETE et_substituir WHERE estoquelivre IS INITIAL.
    SORT et_substituir BY salesorder salesorderitem materialatual material  plant.
    DELETE ADJACENT DUPLICATES FROM et_substituir COMPARING salesorder salesorderitem materialatual material  plant.


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
ENDCLASS.
