CLASS zclsd_verif_disp_custom DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

    TYPES:BEGIN OF ty_filtros,
            material           TYPE if_rap_query_filter=>tt_range_option,
            plant              TYPE if_rap_query_filter=>tt_range_option,
            deposito           TYPE if_rap_query_filter=>tt_range_option,
            motivoindisp       TYPE if_rap_query_filter=>tt_range_option,
            acaonecessaria     TYPE if_rap_query_filter=>tt_range_option,
            descricao          TYPE if_rap_query_filter=>tt_range_option,
            qtdordem           TYPE if_rap_query_filter=>tt_range_option,
            qtdremessa         TYPE if_rap_query_filter=>tt_range_option,
            qtdestoquelivre    TYPE if_rap_query_filter=>tt_range_option,
            saldo              TYPE if_rap_query_filter=>tt_range_option,
            qtddepositofechado TYPE if_rap_query_filter=>tt_range_option,
            orderquantityunit  TYPE if_rap_query_filter=>tt_range_option,
            acaologistica      TYPE if_rap_query_filter=>tt_range_option,
            status             TYPE if_rap_query_filter=>tt_range_option,
            data_solic_logist  TYPE if_rap_query_filter=>tt_range_option,
            centrodepfechado   TYPE if_rap_query_filter=>tt_range_option,
          END OF ty_filtros.

    DATA gs_filtros TYPE ty_filtros.

    TYPES:  ty_verif_disp         TYPE STANDARD TABLE OF zc_sd_verif_disp_custom_app WITH EMPTY KEY.

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
    DATA gv_atpab TYPE prreg.

    METHODS:
      "! Configura os filtros que serão utilizados no relatório
      "! @parameter it_filters | Filtros do Aplicativo
      set_filters
        IMPORTING
          it_filters TYPE if_rap_query_filter=>tt_name_range_pairs.

    METHODS:
      "! Monta os dados para serem visualizados no relatório
      "! @parameter et_verif_disp | Tabela para verificar disponibilidade
      build EXPORTING et_verif_disp TYPE ty_verif_disp.

    "! Leitura da tabela de parâmetros
    "! @parameter rv_atpab | Retorno da tabela de parâmetros
    METHODS get_atpab RETURNING VALUE(rv_atpab) TYPE prreg.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_mdpsx.
        INCLUDE TYPE mdps.
    TYPES: material TYPE matnr,
        plant    TYPE werks,
      END OF ty_mdpsx .
    TYPES:
      ty_lt_mdpsx   TYPE STANDARD TABLE OF mdps WITH DEFAULT KEY .
    TYPES:
      ty_lt_mdpsx_1 TYPE STANDARD TABLE OF mdps WITH DEFAULT KEY .
    TYPES:
      ty_lt_mdpsx_2 TYPE STANDARD TABLE OF mdps WITH DEFAULT KEY .
    TYPES:
      ty_verifdisp  TYPE STANDARD TABLE OF zi_sd_verif_disp_app .
    TYPES:
      ty_ty_mdpsx   TYPE STANDARD TABLE OF ty_mdpsx WITH DEFAULT KEY,
      ty_lt_mdpsx_3 TYPE STANDARD TABLE OF mdps WITH DEFAULT KEY.

    METHODS filtra_dados_estoque
      CHANGING
        ct_mdpsx TYPE ty_lt_mdpsx_3.

    DATA:
      gt_mdpsx TYPE TABLE OF ty_mdpsx .

    METHODS monta_tabela_estoque.
*      IMPORTING
*        !is_disp              TYPE zi_sd_verif_disp_app
*        !it_disp_dep          TYPE ty_verif_disp
*      CHANGING
*        !ct_mdpsx             TYPE ty_lt_mdpsx
*        VALUE(ct_mdpsx_final) TYPE zclsd_verif_disp_custom=>ty_ty_mdpsx .
    "! Busca quantidade da ordem
    "! @parameter ct_mdpsx | Item documento MRP
    "! @parameter cs_data  | Tabela para verificar disponibilidade
    METHODS get_qtd_ordem
      CHANGING
        !ct_mdpsx TYPE ty_ty_mdpsx
        !cs_data  TYPE zc_sd_verif_disp_custom_app .
    "! Busca quantidade da remessa
    "! @parameter ct_mdpsx | Item documento MRP
    "! @parameter cs_data  | Tabela para verificar disponibilidade
    METHODS get_qtd_remessa
      CHANGING
        !ct_mdpsx TYPE ty_ty_mdpsx
        !cs_data  TYPE zc_sd_verif_disp_custom_app .
*        is_data         TYPE zc_sd_verif_disp_custom_app
    "! Busca disponibilidade de estoque
    "! @parameter ct_verif_disp  | Tabela para verificar disponibilidade
    METHODS get_estoque
      CHANGING
        !ct_verif_disp TYPE ty_verif_disp .
    "! Busca quantidade
    "! @parameter ct_verif_disp  | Tabela para verificar disponibilidade
    METHODS get_quantity
      CHANGING
        !ct_verif_disp TYPE zclsd_verif_disp_custom=>ty_verif_disp .
    "! Busca Deposito Fechado
    "! @parameter ct_verif_disp  | Tabela para verificar disponibilidade
    METHODS get_deposit_fec
      CHANGING
        !ct_verif_disp TYPE zclsd_verif_disp_custom=>ty_verif_disp .
    "! Busca dados para preencher tabela final
    "! @parameter rt_verif_disp  | Tabela para verificar disponibilidade
    METHODS get_data
      RETURNING
        VALUE(rt_verif_disp) TYPE zclsd_verif_disp_custom=>ty_verif_disp .
    "! Busca saldo e status do estoque
    "! @parameter cs_data  | Tabela para verificar disponibilidade
    METHODS get_saldo_status
      CHANGING
        !cs_data TYPE zc_sd_verif_disp_custom_app .
ENDCLASS.



CLASS ZCLSD_VERIF_DISP_CUSTOM IMPLEMENTATION.


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
    me->build( IMPORTING et_verif_disp = DATA(lt_result) ).
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
          gs_filtros-material   = it_filters[ name = 'MATERIAL' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_exp_msg) = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-plant   = it_filters[ name = 'PLANT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-deposito   = it_filters[ name = 'DEPOSITO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-motivoindisp   = it_filters[ name = 'MOTIVOINDISP' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.


      TRY.
          gs_filtros-acaonecessaria = it_filters[ name = 'ACAONECESSARIA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-descricao   = it_filters[ name = 'DESCRICAO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-qtdordem  = it_filters[ name = 'QTDORDEM' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-qtdremessa   = it_filters[ name = 'QTDREMESSA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-qtdestoquelivre  = it_filters[ name = 'QTDESTOQUELIVRE' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-saldo   = it_filters[ name = 'SALDO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-qtddepositofechado  = it_filters[ name = 'QTDDEPOSITOFECHADO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-orderquantityunit  = it_filters[ name = 'ORDERQUANTITYUNIT' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-acaologistica  = it_filters[ name = 'ACAOLOGISTICA' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-status  = it_filters[ name = 'STATUS' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-data_solic_logist  = it_filters[ name = 'DATA_SOLIC_LOGIST' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

      TRY.
          gs_filtros-centrodepfechado  = it_filters[ name = 'CENTRODEPFECHADO' ]-range. "#EC CI_STDSEQ
        CATCH cx_root INTO lo_root.
          lv_exp_msg = lo_root->get_longtext( ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.


  METHOD build.

    et_verif_disp = get_data( ).

    IF et_verif_disp IS NOT INITIAL AND
 (  gs_filtros-status IS NOT INITIAL
 OR gs_filtros-qtdordem            IS NOT INITIAL
 OR gs_filtros-qtdremessa          IS NOT INITIAL
 OR gs_filtros-qtdestoquelivre     IS NOT INITIAL
 OR gs_filtros-saldo               IS NOT INITIAL
 OR gs_filtros-qtddepositofechado  IS NOT INITIAL ).

      SELECT *
       FROM @et_verif_disp AS dados
     WHERE  material            IN @gs_filtros-material
       AND  plant               IN @gs_filtros-plant
       AND  deposito            IN @gs_filtros-deposito
       AND  motivoindisp        IN @gs_filtros-motivoindisp
       AND  acaonecessaria      IN @gs_filtros-acaonecessaria
       AND  descricao           IN @gs_filtros-descricao
       AND  qtdordem            IN @gs_filtros-qtdordem
       AND  qtdremessa          IN @gs_filtros-qtdremessa
       AND  qtdestoquelivre     IN @gs_filtros-qtdestoquelivre
       AND  saldo               IN @gs_filtros-saldo
       AND  qtddepositofechado  IN @gs_filtros-qtddepositofechado
       AND  orderquantityunit   IN @gs_filtros-orderquantityunit
       AND  acaologistica       IN @gs_filtros-acaologistica
       AND  status              IN @gs_filtros-status
       AND  data_solic_logist   IN @gs_filtros-data_solic_logist
       AND  centrodepfechado    IN @gs_filtros-centrodepfechado
     INTO CORRESPONDING FIELDS OF TABLE @et_verif_disp.

    ENDIF.

  ENDMETHOD.


  METHOD get_data.

    SELECT material, plant, deposito,
           descricao, orderquantityunit, data_solic_logist,
           acaologistica, coloracaologistica, datasolic,
           motivoindisp, acaonecessaria, motivotext,
           acaotext, centrodepfechado, qtdestoquelivre,
           qtddepositofechado
  FROM zi_sd_verif_disp_custom_app
    WHERE  material           IN @gs_filtros-material
      AND  plant              IN @gs_filtros-plant
      AND  deposito           IN @gs_filtros-deposito
      AND  motivoindisp       IN @gs_filtros-motivoindisp
      AND  acaonecessaria     IN @gs_filtros-acaonecessaria
      AND  descricao          IN @gs_filtros-descricao
      AND  orderquantityunit  IN @gs_filtros-orderquantityunit
      AND  acaologistica      IN @gs_filtros-acaologistica
      AND  data_solic_logist  IN @gs_filtros-data_solic_logist
      AND  centrodepfechado   IN @gs_filtros-centrodepfechado
      INTO TABLE @DATA(lt_verif_disp).                  "#EC CI_SEL_DEL

    rt_verif_disp = VALUE #( BASE rt_verif_disp FOR ls_verif_disp IN lt_verif_disp ( CORRESPONDING #( ls_verif_disp ) ) ).

    gv_atpab = get_atpab(  ).

    get_estoque( CHANGING ct_verif_disp = rt_verif_disp ).

*    IF lt_verif_disp IS NOT INITIAL.
*      SORT rt_verif_disp BY material plant.
*      SORT lt_verif_disp BY material plant.
*      DELETE ADJACENT DUPLICATES FROM lt_verif_disp COMPARING material plant.
*      gt_mdpsx = get_estoque( it_verif_disp = lt_verif_disp it_verif_disp_dep = rt_verif_disp ).
*    ENDIF.
*
*    get_quantity( CHANGING ct_verif_disp = rt_verif_disp ).

  ENDMETHOD.


  METHOD get_deposit_fec.

    SELECT  mard~matnr, mard~werks, mard~lgort, mard~labst
    FROM mard
    INNER JOIN @ct_verif_disp AS verifdisp
   ON mard~matnr = verifdisp~material
  AND mard~werks = verifdisp~centrodepfechado
  AND mard~lgort = verifdisp~deposito
          INTO TABLE @DATA(lt_mard).
    SORT lt_mard BY matnr werks lgort.


    LOOP AT ct_verif_disp ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_mard ASSIGNING FIELD-SYMBOL(<fs_mard>) WITH KEY matnr = <fs_data>-material
                                                                werks = <fs_data>-centrodepfechado
                                                                lgort = <fs_data>-deposito BINARY SEARCH.
      IF <fs_mard> IS ASSIGNED.
        <fs_data>-qtddepositofechado = <fs_mard>-labst.
      ENDIF.

      <fs_data>-saldo = <fs_data>-qtdestoquelivre + <fs_data>-qtddepositofechado - <fs_data>-qtdremessa - <fs_data>-qtdordem.

      IF  <fs_data>-saldo > 0.
        <fs_data>-status = TEXT-001.
        <fs_data>-colorstatus = 3.
      ELSE.
        <fs_data>-status = TEXT-002.
        <fs_data>-colorstatus = 1.
      ENDIF.



    ENDLOOP.

  ENDMETHOD.


  METHOD get_quantity.

    IF ct_verif_disp IS NOT INITIAL.

      SELECT matnr, werks, lgort, labst
          FROM mard
          FOR ALL ENTRIES IN @ct_verif_disp
         WHERE matnr = @ct_verif_disp-material
           AND werks = @ct_verif_disp-plant
           AND lgort = @ct_verif_disp-deposito
                INTO TABLE @DATA(lt_mard).
      SORT lt_mard BY matnr werks lgort.

      SELECT matnr, werks, lgort, labst
          FROM mard
          FOR ALL ENTRIES IN @ct_verif_disp
         WHERE matnr = @ct_verif_disp-material
           AND werks = @ct_verif_disp-centrodepfechado
           AND lgort = @ct_verif_disp-deposito
        INTO TABLE @DATA(lt_depfec).
      SORT lt_depfec BY matnr werks lgort.

    ENDIF.

    SORT gt_mdpsx BY plaab lgort delkz material plant.

    LOOP AT ct_verif_disp ASSIGNING FIELD-SYMBOL(<fs_data>).

      get_qtd_remessa( CHANGING ct_mdpsx = gt_mdpsx cs_data = <fs_data> ).

      get_qtd_ordem( CHANGING ct_mdpsx = gt_mdpsx cs_data = <fs_data> ).

      READ TABLE lt_mard ASSIGNING FIELD-SYMBOL(<fs_mard>) WITH KEY matnr = <fs_data>-material
                                                                    werks = <fs_data>-plant
                                                                    lgort = <fs_data>-deposito BINARY SEARCH.
      IF <fs_mard> IS ASSIGNED.
        <fs_data>-qtdestoquelivre = <fs_mard>-labst.
      ENDIF.

      READ TABLE lt_depfec ASSIGNING FIELD-SYMBOL(<fs_depfec>) WITH KEY matnr = <fs_data>-material
                                                                        werks = <fs_data>-centrodepfechado
                                                                        lgort = <fs_data>-deposito BINARY SEARCH.
      IF <fs_depfec> IS ASSIGNED.
        <fs_data>-qtddepositofechado = <fs_depfec>-labst.
      ENDIF.

      get_saldo_status( CHANGING cs_data = <fs_data> ).


      UNASSIGN: <fs_mard>, <fs_depfec>.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_qtd_ordem.

    READ TABLE ct_mdpsx TRANSPORTING NO FIELDS WITH KEY plaab    = gv_atpab
                                                        lgort    = cs_data-deposito
                                                        delkz    = 'VC'
                                                        material = cs_data-material
                                                        plant    = cs_data-plant     BINARY SEARCH.
    IF sy-subrc = 0.

      LOOP AT ct_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
        IF <fs_mdpsx>-plaab    <> gv_atpab
        OR <fs_mdpsx>-lgort    <> cs_data-deposito
        OR <fs_mdpsx>-delkz    <> 'VC'
        OR <fs_mdpsx>-material <> cs_data-material
        OR <fs_mdpsx>-plant    <> cs_data-plant.
          EXIT.
        ELSE.
          cs_data-qtdordem = cs_data-qtdordem + <fs_mdpsx>-mng01.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD get_saldo_status.

    cs_data-saldo = cs_data-qtdestoquelivre + cs_data-qtddepositofechado - cs_data-qtdremessa - cs_data-qtdordem.

    IF  cs_data-saldo > 0.
      cs_data-status      = '0'.
      cs_data-statusdesc  = TEXT-001.
      cs_data-colorstatus = 3.
    ELSE.
      cs_data-status      = '1'.
      cs_data-statusdesc  = TEXT-002.
      cs_data-colorstatus = 1.
    ENDIF.

  ENDMETHOD.


  METHOD get_qtd_remessa.

    READ TABLE ct_mdpsx TRANSPORTING NO FIELDS WITH KEY plaab    = gv_atpab
                                                        lgort    = cs_data-deposito
                                                        delkz    = 'VJ'
                                                        material = cs_data-material
                                                        plant    = cs_data-plant     BINARY SEARCH.
    IF sy-subrc = 0.

      LOOP AT ct_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
        IF <fs_mdpsx>-plaab    <> gv_atpab
        OR <fs_mdpsx>-lgort    <> cs_data-deposito
        OR <fs_mdpsx>-delkz    <> 'VJ'
        OR <fs_mdpsx>-material <> cs_data-material
        OR <fs_mdpsx>-plant    <> cs_data-plant.
          EXIT.
        ELSE.
          cs_data-qtdremessa = cs_data-qtdremessa + <fs_mdpsx>-mng01.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD get_estoque.

    DATA lt_mdpsx TYPE STANDARD TABLE OF mdps.
    DATA ls_mdpsx TYPE ty_mdpsx.
    DATA lt_matnr_werks TYPE pph_matnr_werks_berid_sel_tab.

    lt_matnr_werks = CORRESPONDING #( ct_verif_disp MAPPING matnr = material
                                                            werks = plant ).

    CALL FUNCTION 'PPH_STOCK_REQ_LISTS_PREREAD'
      EXPORTING
        it_matnr_werks_berid = lt_matnr_werks.


    LOOP AT ct_verif_disp ASSIGNING FIELD-SYMBOL(<fs_original_data>).
      CLEAR lt_mdpsx.
      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
        EXPORTING
          matnr                    = <fs_original_data>-material
          werks                    = <fs_original_data>-plant
        TABLES
          mdpsx                    = lt_mdpsx
        EXCEPTIONS
          material_plant_not_found = 1
          plant_not_found          = 2
          OTHERS                   = 3.

      IF sy-subrc = 0.

        filtra_dados_estoque( CHANGING ct_mdpsx = lt_mdpsx ).

        READ TABLE lt_mdpsx TRANSPORTING NO FIELDS WITH KEY plaab = gv_atpab
                                                            lgort = <fs_original_data>-deposito BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          LOOP AT lt_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
            IF <fs_mdpsx>-plaab <> gv_atpab OR <fs_mdpsx>-lgort <> <fs_original_data>-deposito.
              EXIT.
            ENDIF.
            CASE <fs_mdpsx>-delkz.
              WHEN 'VC'.
                <fs_original_data>-qtdordem = <fs_original_data>-qtdordem + <fs_mdpsx>-mng01.
              WHEN 'VJ'.
                <fs_original_data>-qtdremessa = <fs_original_data>-qtdremessa + <fs_mdpsx>-mng01.
            ENDCASE.
          ENDLOOP.

        ENDIF.

        <fs_original_data>-saldo = <fs_original_data>-qtdestoquelivre + <fs_original_data>-qtddepositofechado -
                                     <fs_original_data>-qtdremessa - <fs_original_data>-qtdordem.

      ENDIF.

      IF <fs_original_data>-saldo > 0.
        <fs_original_data>-status      = '0'.
        <fs_original_data>-statusdesc  = TEXT-001. "Disponível
        <fs_original_data>-colorstatus = 3.
      ELSE.
        <fs_original_data>-status      = '1'.
        <fs_original_data>-statusdesc  = TEXT-002. "Indisponível
        <fs_original_data>-colorstatus = 1.
      ENDIF.
    ENDLOOP.


*    LOOP AT it_verif_disp ASSIGNING FIELD-SYMBOL(<fs_disp>).
*
*      CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
*        EXPORTING
*          matnr                    = <fs_disp>-material
*          werks                    = <fs_disp>-plant
*        TABLES
*          mdpsx                    = lt_mdpsx
*        EXCEPTIONS
*          material_plant_not_found = 1
*          plant_not_found          = 2
*          OTHERS                   = 3.
*
*      IF sy-subrc EQ 0.
*
*        monta_tabela_estoque( EXPORTING
*                               is_disp        = <fs_disp>
*                               it_disp_dep    = it_verif_disp_dep
*                              CHANGING
*                               ct_mdpsx       = lt_mdpsx
*                               ct_mdpsx_final = rt_mdpsx ).
*
*      ELSE.
*        CLEAR lt_mdpsx.
*      ENDIF.
*
*    ENDLOOP.

  ENDMETHOD.


  METHOD filtra_dados_estoque.

    DELETE ct_mdpsx WHERE mng01 = 0.
    DELETE ct_mdpsx WHERE delkz <> 'VC' AND delkz <>'VJ'.
    SORT ct_mdpsx BY plaab lgort.

  ENDMETHOD.


  METHOD monta_tabela_estoque.
return.
*    DATA ls_mdpsx TYPE ty_mdpsx.
*
*    SORT ct_mdpsx BY plaab lgort delkz.
*
*    READ TABLE it_disp_dep TRANSPORTING NO FIELDS  WITH KEY material = is_disp-material
*                                                            plant    = is_disp-plant BINARY SEARCH.
*
*    IF sy-subrc = 0.
*      LOOP AT it_disp_dep ASSIGNING FIELD-SYMBOL(<fs_disp_dep>) FROM sy-tabix.
*
*        IF <fs_disp_dep>-material = is_disp-material
*       AND <fs_disp_dep>-plant    = is_disp-plant.
*
*          READ TABLE ct_mdpsx TRANSPORTING NO FIELDS  WITH KEY plaab    = gv_atpab
*                                                               lgort    = <fs_disp_dep>-deposito
*                                                               delkz    = 'VJ' BINARY SEARCH.
*
*          IF sy-subrc = 0.
*            LOOP AT ct_mdpsx ASSIGNING FIELD-SYMBOL(<fs_mdpsx>) FROM sy-tabix.
*              IF <fs_mdpsx>-plaab = gv_atpab AND <fs_mdpsx>-lgort = <fs_disp_dep>-deposito AND <fs_mdpsx>-delkz = 'VJ'.
*                ls_mdpsx = CORRESPONDING #( <fs_mdpsx> ).
*                ls_mdpsx-material = is_disp-material.
*                ls_mdpsx-plant    = is_disp-plant.
*                APPEND ls_mdpsx TO ct_mdpsx_final.
*                CLEAR ls_mdpsx.
*              ELSE.
*                EXIT.
*              ENDIF.
*            ENDLOOP.
*          ENDIF.
*
*          READ TABLE ct_mdpsx TRANSPORTING NO FIELDS  WITH KEY plaab    = gv_atpab
*                                                               lgort    = <fs_disp_dep>-deposito
*                                                               delkz    = 'VC' BINARY SEARCH.
*
*          IF sy-subrc = 0.
*            LOOP AT ct_mdpsx ASSIGNING <fs_mdpsx> FROM sy-tabix.
*              IF <fs_mdpsx>-plaab = gv_atpab AND <fs_mdpsx>-lgort = <fs_disp_dep>-deposito AND <fs_mdpsx>-delkz = 'VC'.
*                ls_mdpsx = CORRESPONDING #( <fs_mdpsx> ).
*                ls_mdpsx-material = is_disp-material.
*                ls_mdpsx-plant    = is_disp-plant.
*                APPEND ls_mdpsx TO ct_mdpsx_final.
*                CLEAR ls_mdpsx.
*              ELSE.
*                EXIT.
*              ENDIF.
*            ENDLOOP.
*          ENDIF.
*
*        ELSE.
*          EXIT.
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
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
