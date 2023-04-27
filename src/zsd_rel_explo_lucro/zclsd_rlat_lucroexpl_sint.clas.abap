CLASS zclsd_rlat_lucroexpl_sint DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
    INTERFACES if_rap_query_filter .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_filters, " Tipo para ranges
        companycode              TYPE if_rap_query_filter=>tt_range_option,
        plant                    TYPE if_rap_query_filter=>tt_range_option,
        valuationtype            TYPE if_rap_query_filter=>tt_range_option,
        br_notafiscal            TYPE if_rap_query_filter=>tt_range_option,
        br_cfopcode              TYPE if_rap_query_filter=>tt_range_option,
        fiscalmonthcurrentperiod TYPE if_rap_query_filter=>tt_range_option,
        fiscalyearcurrentperiod  TYPE if_rap_query_filter=>tt_range_option,
        creationdate             TYPE if_rap_query_filter=>tt_range_option,
        statusnf                 TYPE if_rap_query_filter=>tt_range_option,
      END OF ty_filters .
    TYPES:
    " Tipo de retorno de dados à custom entity
      ty_relat TYPE STANDARD TABLE OF zc_sd_relex_sintetica_virt WITH EMPTY KEY .

    DATA gs_range TYPE ty_filters .

    METHODS set_filters
      IMPORTING
        !it_filters TYPE if_rap_query_filter=>tt_name_range_pairs .
    METHODS build
      EXPORTING
        !et_relat TYPE ty_relat .
ENDCLASS.



CLASS ZCLSD_RLAT_LUCROEXPL_SINT IMPLEMENTATION.


  METHOD build.

    TYPES: BEGIN OF ty_fltr_relat,
             werks TYPE werks_d,
             bwtar TYPE bwtar_d,
             cfop  TYPE j_1bcfop,
           END OF ty_fltr_relat.

    DATA: lt_fltr_relat TYPE STANDARD TABLE OF ty_fltr_relat,
          lt_relat      TYPE STANDARD TABLE OF zc_sd_relex_sintetica_virt.

    DATA: ls_relat TYPE LINE OF ty_relat.

    CHECK gs_range IS NOT INITIAL.

    SELECT plant,
           valuationtype,
           br_cfopcode,
           companycode,
           br_nfnumber,
           salesorganization,
           fiscalmonthcurrentperiod,
           fiscalyearcurrentperiod,
           additionalmaterialgroup3name,
           salesorgatv,
           batch,
           qtydelivery,
           doc_type,
           br_nftotalamount,
           valortrans,
           vlrconfis,
           vlricms,
           vlripi,
           vlrpis,
           vlrsubtrib
      FROM zi_sd_relex_app
     WHERE companycode              IN @gs_range-companycode
       AND plant                    IN @gs_range-plant
       AND br_cfopcode              IN @gs_range-br_cfopcode
       AND valuationtype            IN @gs_range-valuationtype
       AND br_nfnumber              IN @gs_range-br_notafiscal
       AND fiscalmonthcurrentperiod IN @gs_range-fiscalmonthcurrentperiod
       AND fiscalyearcurrentperiod  IN @gs_range-fiscalyearcurrentperiod
       AND creationdate             IN @gs_range-creationdate
       AND statusnf                 IN @gs_range-statusnf
      INTO TABLE @DATA(lt_relex_item).

    IF sy-subrc IS INITIAL.

      LOOP AT lt_relex_item ASSIGNING FIELD-SYMBOL(<fs_relex_item>).

        ls_relat-br_nfdocumenttype            = <fs_relex_item>-doc_type.
        ls_relat-plant                        = <fs_relex_item>-plant.
        ls_relat-salesorganization            = <fs_relex_item>-salesorganization.
        ls_relat-salesorgatv                  = <fs_relex_item>-salesorgatv.
        ls_relat-additionalmaterialgroup3name = <fs_relex_item>-additionalmaterialgroup3name.
        ls_relat-batch                        = <fs_relex_item>-batch.
        ls_relat-valuationtype                = <fs_relex_item>-valuationtype.
        ls_relat-br_cfopcode                  = <fs_relex_item>-br_cfopcode.
        ls_relat-qtydelivery                  = <fs_relex_item>-qtydelivery.
*        ls_relat-br_nftotalamount             = <fs_relex_item>-br_nftotalamount.
        ls_relat-vlricms_sum                  = <fs_relex_item>-vlricms.
        ls_relat-vlripi_sum                   = <fs_relex_item>-vlripi.
        ls_relat-vlrsubtrib_sum               = <fs_relex_item>-vlrsubtrib.
        ls_relat-vlrpis_sum                   = <fs_relex_item>-vlrpis.
        ls_relat-vlrconfis_sum                = <fs_relex_item>-vlrconfis.
*        ls_relat-valortrans                   = <fs_relex_item>-valortrans.
*        ls_relat-valortrans                   = <fs_relex_item>-br_nftotalamount - <fs_relex_item>-vlripi - <fs_relex_item>-vlrsubtrib.
        ls_relat-valortrans                   = <fs_relex_item>-br_nftotalamount + <fs_relex_item>-vlripi + <fs_relex_item>-vlrsubtrib.
        ls_relat-vlrliq                    = ls_relat-valortrans - ( ls_relat-vlricms_sum + ls_relat-vlripi_sum + ls_relat-vlrsubtrib_sum +
                                                                       ls_relat-vlrpis_sum  +  ls_relat-vlrconfis_sum ).

        COLLECT ls_relat INTO lt_relat.
        CLEAR ls_relat.

      ENDLOOP.

      IF lt_relat[] IS NOT INITIAL.
        et_relat[] = lt_relat[].
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_ranges.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_filter~get_as_sql_string.
    RETURN.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

* ---------------------------------------------------------------------------
* Recupera informações de entidade, paginação, etc
* ---------------------------------------------------------------------------
    DATA(lv_top)      = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)     = io_request->get_paging( )->get_offset( ).
    DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

* ---------------------------------------------------------------------------
* Recupera e seta filtros de seleção
* ---------------------------------------------------------------------------
    TRY.
        me->set_filters( EXPORTING it_filters = io_request->get_filter( )->get_as_ranges( ) ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lo_ex_filter).
        DATA(lv_exp_msg) = lo_ex_filter->get_longtext( ).
    ENDTRY.

* ---------------------------------------------------------------------------
* Monta relatório
* ---------------------------------------------------------------------------
    DATA lt_result TYPE STANDARD TABLE OF zc_sd_relex_sintetica_virt WITH EMPTY KEY.
    me->build( IMPORTING et_relat = lt_result ).

* ---------------------------------------------------------------------------
* Realiza ordenação de acordo com parâmetros de entrada
* ---------------------------------------------------------------------------
    DATA(lt_requested_sort) = io_request->get_sort_elements( ).
    IF lines( lt_requested_sort ) > 0.
      DATA(lt_sort) = VALUE abap_sortorder_tab( FOR ls_sort IN lt_requested_sort ( name = ls_sort-element_name descending = ls_sort-descending ) ).
      SORT lt_result BY (lt_sort).
    ENDIF.

** ---------------------------------------------------------------------------
** Realiza as agregações de acordo com as annotatios na custom entity
** ---------------------------------------------------------------------------
    DATA(lt_req_elements) = io_request->get_requested_elements( ).
    SORT lt_req_elements BY table_line.

    DATA(lt_aggr_element) = io_request->get_aggregation( )->get_aggregated_elements( ).
    IF lt_aggr_element IS NOT INITIAL.
      LOOP AT lt_aggr_element ASSIGNING FIELD-SYMBOL(<fs_aggr_element>).

        READ TABLE lt_req_elements TRANSPORTING NO FIELDS
                                                 WITH KEY table_line = <fs_aggr_element>-result_element
                                                 BINARY SEARCH.
        IF sy-subrc IS INITIAL.
*        DELETE lt_req_elements WHERE table_line = <fs_aggr_element>-result_element.
          DELETE lt_req_elements INDEX sy-tabix.
        ENDIF.

        DATA(lv_aggregation) = |{ <fs_aggr_element>-aggregation_method }( { <fs_aggr_element>-input_element } ) as { <fs_aggr_element>-result_element }|.
        APPEND lv_aggregation TO lt_req_elements.
      ENDLOOP.
    ENDIF.

    DATA(lv_req_elements)  = concat_lines_of( table = lt_req_elements sep = ',' ).

    DATA(lt_grouped_element) = io_request->get_aggregation( )->get_grouped_elements( ).
    DATA(lv_grouping) = concat_lines_of(  table = lt_grouped_element sep = ',' ).

    SELECT (lv_req_elements) FROM @lt_result AS dados
                             GROUP BY (lv_grouping)
                             INTO CORRESPONDING FIELDS OF TABLE @lt_result.

* ---------------------------------------------------------------------------
* Controla paginação (Adiciona registros de 20 em 20 )
* ---------------------------------------------------------------------------
    DATA(lt_result_page) = lt_result[].
    lt_result_page = VALUE #( FOR ls_result IN lt_result FROM ( lv_skip + 1 ) TO ( lv_skip + lv_max_rows ) ( ls_result ) ).

* ---------------------------------------------------------------------------
* Exibe registros
* ---------------------------------------------------------------------------
    IF io_request->is_total_numb_of_rec_requested(  ).
      io_response->set_total_number_of_records( CONV #( lines( lt_result[] ) ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se informação foi solicitada
* ---------------------------------------------------------------------------
    IF io_request->is_data_requested( ).
      io_response->set_data( lt_result_page[] ).
    ENDIF.

  ENDMETHOD.


  METHOD set_filters.

    CHECK it_filters[] IS NOT INITIAL.

    LOOP AT it_filters ASSIGNING FIELD-SYMBOL(<fs_filters>).

      CASE <fs_filters>-name.
        WHEN 'COMPANYCODE'.
          gs_range-companycode = VALUE #( BASE gs_range-companycode ( LINES OF <fs_filters>-range ) ).

        WHEN 'PLANT'.
          gs_range-plant = VALUE #( BASE gs_range-plant ( LINES OF <fs_filters>-range ) ).

        WHEN 'BR_CFOPCODE'.
          gs_range-br_cfopcode = VALUE #( BASE gs_range-br_cfopcode ( LINES OF <fs_filters>-range ) ).

        WHEN 'VALUATIONTYPE'.
          gs_range-valuationtype = VALUE #( BASE gs_range-valuationtype ( LINES OF <fs_filters>-range ) ).

        WHEN 'BR_NFNUMBER'.
          gs_range-br_notafiscal = VALUE #( BASE gs_range-br_notafiscal ( LINES OF <fs_filters>-range ) ).

        WHEN 'FISCALMONTHCURRENTPERIOD'.
          gs_range-fiscalmonthcurrentperiod = VALUE #( BASE gs_range-fiscalmonthcurrentperiod ( LINES OF <fs_filters>-range ) ).

        WHEN 'FISCALYEARCURRENTPERIOD'.
          gs_range-fiscalyearcurrentperiod = VALUE #( BASE gs_range-fiscalyearcurrentperiod ( LINES OF <fs_filters>-range ) ).

        WHEN 'CREATIONDATE'.
          gs_range-creationdate = VALUE #( BASE gs_range-creationdate ( LINES OF <fs_filters>-range ) ).

        WHEN 'STATUSNF'.
          gs_range-statusnf = VALUE #( BASE gs_range-statusnf ( LINES OF <fs_filters>-range ) ).

        WHEN OTHERS.
          CONTINUE.
      ENDCASE.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
