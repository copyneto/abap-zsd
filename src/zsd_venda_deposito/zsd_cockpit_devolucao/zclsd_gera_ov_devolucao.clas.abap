CLASS zclsd_gera_ov_devolucao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
     "! Type Cockpit Devolução Referenciar e Validar
     ty_refval TYPE TABLE OF zi_sd_cockpit_devolucao_refval.

    "! Executa a geração do  Documento de vendas devolução
    "! @parameter it_devolucao | Dados devolução
    "! @parameter rt_mensagens | Mensagens de erro
    METHODS main IMPORTING it_devolucao        TYPE ty_refval
                 RETURNING
                           VALUE(rt_mensagens) TYPE  bapiret2_tab.

    "! Verifica Quantidade Fatura
    "! @parameter it_devolucao | Dados devolução
    "! @parameter rt_mensagens | Mensagens de erro
    METHODS verificaquantidade IMPORTING it_devolucao        TYPE ty_refval
                               RETURNING
                                         VALUE(rt_mensagens) TYPE  bapiret2_tab.

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo                 TYPE ze_param_modulo VALUE 'SD',
        chave1                 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2                 TYPE ztca_param_par-chave2 VALUE 'TP_OV_DEVOLUCAO',
        chave2_ret             TYPE ztca_param_par-chave2 VALUE 'TP_OV_RETORNO',
        chave2_cond            TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_DESCONTO',
        chave2_cond_preco      TYPE ztca_param_par-chave2 VALUE 'TP_CONDIÇÃO_PREÇO',
        chave2_cond_expo       TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_EXPO',
        chave2_cond_ecom       TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_E-COM',
        chave2_cond_preco_expo TYPE ztca_param_par-chave2 VALUE 'PRICE_CONDIÇÃO_EXPO',
        chave2_cond_preco_ecom TYPE ztca_param_par-chave2 VALUE 'PRICE_CONDIÇÃO_E-COM',
        chave3                 TYPE ztca_param_par-chave3 VALUE 'FKART',
      END OF gc_parametros .

    TYPES:
      BEGIN OF ty_prcd_elements,
        vbeln TYPE vbrk-vbeln,
        kschl TYPE prcd_elements-kschl,
        knumv TYPE prcd_elements-knumv,
        kposn TYPE prcd_elements-kposn,
        kbetr TYPE prcd_elements-kbetr,
        waers TYPE prcd_elements-waers,
        kmein TYPE prcd_elements-kmein,
        kpein TYPE prcd_elements-kpein,
      END OF ty_prcd_elements.

    TYPES: ty_precos TYPE TABLE OF ty_prcd_elements.
    TYPES: ty_t_lpp  TYPE TABLE OF zssd_ckpt_del_zlpp.

    DATA:
      "! Tipo ordem de devolução
      gt_lpp             TYPE ty_t_lpp,
      gt_tipo_ov         TYPE RANGE OF vbrk-fkart,
      gt_cond_preco_expo TYPE RANGE OF vbrk-knumv,
      gt_cond_preco_ecom TYPE RANGE OF vbrk-knumv,
      gt_cond_expo       TYPE RANGE OF prcd_elements-kschl,
      gt_cond_ecom       TYPE RANGE OF prcd_elements-kschl.

    "! Campos de comunicação: cabeçalho doc.SD
    DATA gs_header_in TYPE bapisdhd1 .
    "! Campos de seleção cabeçalho doc.SD
    DATA gs_header_inx TYPE bapisdhd1x .
    "! Documento de vendas
    DATA gv_doc TYPE bapivbeln-vbeln .
    DATA:
      "! Parâmetro de retorno
      gt_return     TYPE STANDARD TABLE OF bapiret2 .
    DATA:
      "! Campos de comunicação: item doc.SD
      gt_items_in   TYPE STANDARD TABLE OF bapisditm .
    DATA:
      "! Campos de comunicação: item doc.SD
      gt_items_inx  TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      "! Campos de comunicação: parceiro doc.SD: WWW
      gt_partners   TYPE STANDARD TABLE OF bapiparnr .
    "! Campos de comunicação para atualizar uma divisão de doc.SD
    DATA gt_schedules_in TYPE esales_bapischdl_tab .
    "! Campos de comunicação para atualizar uma divisão de doc.SD
    DATA gt_schedules_inx TYPE esales_bapischdlx_tab .
    "! Campos de comunicação para atualizar as condições na ordem
    DATA gt_conditions_in TYPE esales_bapicond_tab .

    DATA:
      "! Tipo ordem de devolução
      gt_condicao       TYPE RANGE OF prcd_elements-kschl,
      gt_condicao_preco TYPE RANGE OF vbrk-kalsm.

    "! Preenche cabeçalho BAPI
    "! @parameter is_devolucao | Dados Devolução
    METHODS fill_bapi_header
      IMPORTING
        !is_devolucao     TYPE zi_sd_cockpit_devolucao_refval
      EXPORTING
        VALUE(ev_emissor) TYPE kunag.
    "! Preenche itens BAPI
    "! @parameter it_devolucao | Dados Devolução
    METHODS fill_bapi_itens
      IMPORTING
        !iv_emissor   TYPE kunag
        !it_devolucao TYPE ty_refval .
    "! Chama a Bapi para criar ordem de devolução
    METHODS call_bapi .
    "! Realiza Commit Work
    METHODS commit_work .
    "! Seleciona Ordem de Devolução
    "! @parameter rv_tipo_ov |Tipo Ordem de Devolução
    METHODS get_param_tipo_ov
      IMPORTING
        !is_devolucao     TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
        VALUE(rv_tipo_ov) TYPE vbrk-fkart .
    "! Atualiza dados de devolução
    "! @parameter is_devolucao | Dados Devolução
    METHODS update_table
      IMPORTING
        !is_devolucao TYPE zi_sd_cockpit_devolucao_refval .
    "! Limpa variáveis Globais
    METHODS clear_globals .
    METHODS get_data_emissao
      IMPORTING
        is_devolucao          TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
        VALUE(rv_dataemissao) TYPE zi_sd_chave_acesso_nf_cliente-dataemissao.

    "! Converter Unidade
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter rv_unmedida   | Unidade medida
    METHODS convert_unit
      IMPORTING
                is_refvalores      TYPE zi_sd_cockpit_devolucao_refval
      RETURNING VALUE(rv_unmedida) TYPE zi_sd_cockpit_devolucao_refval-unmedida.
    METHODS get_deposit
      IMPORTING
                is_devolucao       TYPE zi_sd_cockpit_devolucao_refval
      RETURNING VALUE(rv_deposito) TYPE vbrp-lgort.

    METHODS busca_desconto
      IMPORTING
                it_refvalores TYPE zclsd_ckpt_dev_calc_valores=>ty_refval
      EXPORTING et_pricing    TYPE ty_precos.
    METHODS busca_limite_total
      IMPORTING
        it_desconto        TYPE ty_precos
        is_devolucao       TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
        VALUE(rs_desconto) TYPE zclsd_gera_ov_devolucao=>ty_prcd_elements.
    METHODS cond_preco
      RETURNING VALUE(rv_cond_preco) TYPE vbrk-kalsm.
    METHODS get_cond_expo.
    METHODS get_preco_cond_expo.
    METHODS get_cond_ecom.
    METHODS get_preco_cond_ecom.
ENDCLASS.



CLASS zclsd_gera_ov_devolucao IMPLEMENTATION.


  METHOD main.

    rt_mensagens = me->verificaquantidade( it_devolucao = it_devolucao ).

    IF rt_mensagens IS INITIAL.
      DATA(lt_devolucao) = it_devolucao.
      SORT lt_devolucao BY guid item.

      READ TABLE lt_devolucao ASSIGNING FIELD-SYMBOL(<fs_devolucao>) INDEX 1.

      IF sy-subrc = 0.

        IF NOT line_exists( it_devolucao[ situacao = '0' ] ). "#EC CI_STDSEQ

          APPEND VALUE #(  type        = 'E'
                            id         = 'ZSD_COCKPIT_DEVOL'
                            number     = '008'
                            message_v1 = <fs_devolucao>-situacao ) TO rt_mensagens.

        ELSE.

          fill_bapi_header(
            EXPORTING
              is_devolucao    = <fs_devolucao>
            IMPORTING
              ev_emissor      = DATA(lv_emissor) ).

          fill_bapi_itens(
                EXPORTING
                  iv_emissor      = lv_emissor
                  it_devolucao    = it_devolucao ).

          call_bapi(  ).

          update_table( is_devolucao = <fs_devolucao> ).

          rt_mensagens = gt_return.

          clear_globals(  ).

        ENDIF.

      ELSE.

        APPEND VALUE #(  type   = 'E'
                          id    = 'ZSD_COCKPIT_DEVOL'
                         number = '009' ) TO rt_mensagens.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD call_bapi.

    CALL FUNCTION 'ZFMSD_GERA_OV_DEVOLUCAO'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        is_return_header_in  = gs_header_in
        is_return_header_inx = gs_header_inx
      TABLES
        et_return            = gt_return
        it_items_in          = gt_items_in
        it_items_inx         = gt_items_inx
        it_partners          = gt_partners
        it_schedules_in      = gt_schedules_in
        it_schedules_inx     = gt_schedules_inx
        it_conditions_in     = gt_conditions_in
        it_lpp               = gt_lpp.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_return IS NOT INITIAL.

  ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_GERA_OV_DEVOLUCAO'
    IMPORTING
    ev_salesdocument = gv_doc
    TABLES
      et_return   = gt_return.
    RETURN.

  ENDMETHOD.


  METHOD get_param_tipo_ov.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    CLEAR gt_tipo_ov.

    SELECT SINGLE tipodoc
      FROM zi_sd_cockpit_devolucao_docfat
      WHERE docfaturamento = @is_devolucao-fatura
        AND item           = @is_devolucao-itemfatura
        AND faturadev      = ''
      INTO @DATA(lv_fkart).
    IF sy-subrc EQ 0.

      IF is_devolucao-tpdevolucao = '1'.
        TRY.
            lo_tabela_parametros->m_get_range(
                                    EXPORTING
                                      iv_modulo = gc_parametros-modulo
                                      iv_chave1 = gc_parametros-chave1
                                      iv_chave2 = gc_parametros-chave2
                                      iv_chave3 = gc_parametros-chave3
                                    IMPORTING
                                      et_range  = gt_tipo_ov ).

            SORT gt_tipo_ov BY low.
            READ TABLE gt_tipo_ov ASSIGNING FIELD-SYMBOL(<fs_tipo_ov>) WITH KEY low = lv_fkart BINARY SEARCH.
            IF sy-subrc EQ 0.
              rv_tipo_ov = <fs_tipo_ov>-high.
            ENDIF.
          CATCH zcxca_tabela_parametros.
        ENDTRY.
      ELSE.
        TRY.
            lo_tabela_parametros->m_get_range(
                                    EXPORTING
                                      iv_modulo = gc_parametros-modulo
                                      iv_chave1 = gc_parametros-chave1
                                      iv_chave2 = gc_parametros-chave2_ret
                                      iv_chave3 = gc_parametros-chave3
                                    IMPORTING
                                      et_range  = gt_tipo_ov ).

            SORT gt_tipo_ov BY low.
            READ TABLE gt_tipo_ov ASSIGNING <fs_tipo_ov> WITH KEY low = lv_fkart BINARY SEARCH.
            IF sy-subrc EQ 0.
              rv_tipo_ov = <fs_tipo_ov>-high.
            ENDIF.
          CATCH zcxca_tabela_parametros.
        ENDTRY.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD fill_bapi_header.

    SELECT SINGLE knumv, vkorg, vtweg, spart, kunag, kurrf
      FROM vbrk
      INTO @DATA(ls_vbrk)
      WHERE vbeln = @is_devolucao-fatura.

    SELECT SINGLE prsdt
      FROM vbrp
      INTO @DATA(lv_prsdt)
      WHERE vbeln = @is_devolucao-fatura
        AND posnr = @is_devolucao-itemfatura.

*    ev_nro_condicao = ls_vbrk-knumv.
    ev_emissor      = ls_vbrk-kunag.

    gs_header_in = VALUE #( doc_type       = get_param_tipo_ov( is_devolucao )
                            sales_org      = ls_vbrk-vkorg
                            distr_chan     = ls_vbrk-vtweg
                            division       = ls_vbrk-spart
                            ord_reason     = is_devolucao-motivo
                            doc_date       = is_devolucao-dtlancamento
                            ref_doc        = is_devolucao-fatura
                            refdoc_cat     = 'M'
                            price_date     = lv_prsdt
                            serv_date      = lv_prsdt
                            pymt_meth      = is_devolucao-meiopagamento
                            exchg_rate     = ls_vbrk-kurrf
                            exrate_fi      = ls_vbrk-kurrf ).

    gs_header_inx = VALUE #( updateflag     = 'I'
                             doc_type       = abap_true
                             sales_org      = abap_true
                             distr_chan     = abap_true
                             division       = abap_true
                             ord_reason     = abap_true
                             doc_date       = abap_true
                             ref_doc        = abap_true
                             refdoc_cat     = abap_true
                             price_date     = abap_true
                             serv_date      = abap_true
                             pymt_meth      = abap_true
                             exchg_rate     = abap_true
                             exrate_fi      = abap_true ).

    IF is_devolucao-tpdevolucao = 1.

      gs_header_in-purch_date = get_data_emissao( is_devolucao ).
      gs_header_in-ref_doc_l  = |{ is_devolucao-numnfe }-{ is_devolucao-serie }|.

      gs_header_inx-purch_date = abap_true.
      gs_header_inx-ref_doc_l  = abap_true.
    ENDIF.

    IF is_devolucao-billingdocumenttype = 'Y000'.
      gs_header_in-ord_reason = is_devolucao-sddocumentreason.
    ENDIF.

  ENDMETHOD.


  METHOD get_deposit.

    DATA(lv_tp_ordem) = get_param_tipo_ov( is_devolucao ).

    SELECT SINGLE lgort
      FROM zc_sd_ctr_det_dep
     WHERE auart EQ @lv_tp_ordem
       AND werks EQ @is_devolucao-centro
       AND augru EQ @is_devolucao-motivo
      INTO @rv_deposito.

    IF rv_deposito IS INITIAL.
      SELECT SINGLE lgort
        FROM zc_sd_ctr_det_dep
       WHERE auart EQ @lv_tp_ordem
         AND werks EQ @is_devolucao-centro
         AND augru EQ @space
        INTO @rv_deposito.
    ENDIF.

  ENDMETHOD.


  METHOD get_data_emissao.

    SELECT SINGLE dataemissao
    FROM zi_sd_chave_acesso_nf_cliente
    WHERE nfe         = @is_devolucao-numnfe
      AND centro      = @is_devolucao-centro
      AND chaveacesso = @is_devolucao-chaveacesso
          INTO @rv_dataemissao.

  ENDMETHOD.


  METHOD fill_bapi_itens.
    DATA lv_zfec TYPE char1.
    DATA ls_desconto TYPE zclsd_gera_ov_devolucao=>ty_prcd_elements.

    get_cond_expo( ).
    get_preco_cond_expo( ).

    get_cond_ecom( ).
    get_preco_cond_ecom( ).

    busca_desconto( EXPORTING it_refvalores = it_devolucao IMPORTING et_pricing = DATA(lt_desconto) ).

    SELECT vbeln, posnr, werks, lgort, charg, prsdt, j_1btaxlw1,
           j_1btaxlw2, j_1btaxlw3, j_1btaxlw4, j_1btaxlw5, kursk,
           j_1btxsdc
      FROM vbrp
      INTO TABLE @DATA(lt_vbrp)
      FOR ALL ENTRIES IN @it_devolucao
      WHERE vbeln = @it_devolucao-fatura
        AND posnr = @it_devolucao-itemfatura.

    SELECT vbeln, knumv, kalsm, waerk
    FROM vbrk
    INTO TABLE @DATA(lt_vbrk)
    FOR ALL ENTRIES IN @it_devolucao
    WHERE vbeln = @it_devolucao-fatura.
    SORT lt_vbrk BY vbeln.

    IF lt_vbrk IS NOT INITIAL.

      READ TABLE lt_vbrk ASSIGNING FIELD-SYMBOL(<fs_condicao_preco>) INDEX 1.

      IF <fs_condicao_preco> IS ASSIGNED AND <fs_condicao_preco>-kalsm IN gt_cond_preco_ecom AND gt_cond_ecom IS NOT INITIAL.
        "Cenário E-commerce
        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein, kwert, waerk
          FROM prcd_elements
          INTO TABLE @DATA(lt_pricing)
          FOR ALL ENTRIES IN @lt_vbrk
          WHERE knumv EQ @lt_vbrk-knumv
            AND kschl IN @gt_cond_ecom.

        SORT lt_pricing BY kschl.
        DELETE ADJACENT DUPLICATES FROM lt_pricing COMPARING kschl.

        SELECT vbeln, kunnr, adrnr
        FROM vbpa
        INTO TABLE @DATA(lt_vbpa)
        FOR ALL ENTRIES IN @lt_vbrk
        WHERE vbeln EQ @lt_vbrk-vbeln
          AND parvw EQ 'WE'
          AND xcpdk EQ @abap_true.

*        IF lt_vbpa IS NOT INITIAL.
*
*          SELECT addrnumber, name1, street, house_num1, house_num2,
*                 country, post_code1, city1, city2, region, langu
*          FROM adrc
*          INTO TABLE @DATA(lt_adrc)
*          FOR ALL ENTRIES IN @lt_vbpa
*          WHERE addrnumber EQ @lt_vbpa-adrnr.
*
*        ENDIF.

      ENDIF.

      IF <fs_condicao_preco> IS ASSIGNED AND <fs_condicao_preco>-kalsm IN gt_cond_preco_expo AND gt_cond_expo IS NOT INITIAL.
        "Cenário exportação
        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein
          FROM prcd_elements
          APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
          FOR ALL ENTRIES IN @lt_vbrk
          WHERE knumv EQ @lt_vbrk-knumv
            AND kschl IN @gt_cond_expo.

      ENDIF.

      IF <fs_condicao_preco> IS ASSIGNED AND <fs_condicao_preco>-kalsm EQ cond_preco( ).

        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein, kwert, waerk
    FROM prcd_elements
    APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
    FOR ALL ENTRIES IN @lt_vbrk
    WHERE knumv = @lt_vbrk-knumv
      AND kschl = 'ZST1'.


*        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein, kwert
*          FROM prcd_elements
*          APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
*          FOR ALL ENTRIES IN @lt_vbrk
*          WHERE knumv = @lt_vbrk-knumv
*            AND kschl = 'ZPR1'.
*
*        IF sy-subrc <> 0.
        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein
           FROM prcd_elements
           APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
           FOR ALL ENTRIES IN @lt_vbrk
           WHERE knumv = @lt_vbrk-knumv
             AND kschl = 'ZLPP'.
*        ENDIF.
*
*        IF sy-subrc <> 0.
*          SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein
*             FROM prcd_elements
*             APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
*             FOR ALL ENTRIES IN @lt_vbrk
*             WHERE knumv = @lt_vbrk-knumv
*               AND kschl = 'VPRS'.
*        ENDIF.
      ELSE.

        SELECT knumv, kposn, kschl, kbetr, waers, kpein, kmein
          FROM prcd_elements
          APPENDING CORRESPONDING FIELDS OF TABLE @lt_pricing
          FOR ALL ENTRIES IN @lt_vbrk
          WHERE knumv = @lt_vbrk-knumv
            AND kschl = 'ZPR0'.

      ENDIF.

    ENDIF.

    SORT lt_pricing BY knumv kposn.

    LOOP AT it_devolucao ASSIGNING FIELD-SYMBOL(<fs_devolucao>).

      DATA(lv_deposito) = get_deposit( <fs_devolucao> ).

      DATA(lv_itm_number) = CONV posnr_va( <fs_devolucao>-item * 10 ).

      TRY.
          DATA(ls_fatura) = lt_vbrp[ vbeln = <fs_devolucao>-fatura
                                     posnr = <fs_devolucao>-itemfatura ].

          DATA(lv_werks) = ls_fatura-werks.

          DATA(lv_lote) = ls_fatura-charg.

          IF lv_deposito IS INITIAL.
            lv_deposito = ls_fatura-lgort.
          ENDIF.
*          TRY.
*              DATA(ls_vbrk) = lt_vbrk[ vbeln = <fs_devolucao>-fatura ].
*              IF NOT line_exists( lt_pricing[ knumv = ls_vbrk-knumv kposn = <fs_devolucao>-itemfatura  kschl = 'ZLPP' ] ).
*                CLEAR ls_fatura-j_1btxsdc.
*              ELSE.
*                DATA(lv_taxcode) = abap_true.
*              ENDIF.
*            CATCH cx_sy_itab_line_not_found.
*          ENDTRY.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      APPEND VALUE #( itm_number     = lv_itm_number
                      material       = <fs_devolucao>-material
                      plant          = lv_werks
                      store_loc      = lv_deposito
                      batch          = lv_lote
                      target_qty     = <fs_devolucao>-quantidade
                      ref_doc        = <fs_devolucao>-fatura
                      ref_doc_it     = <fs_devolucao>-itemfatura
                      target_qu      = convert_unit( <fs_devolucao> )
                      sales_unit     = convert_unit( <fs_devolucao> )
                      exchg_rate     = ls_fatura-kursk
                      ex_rate_fi     = ls_fatura-kursk
                      ref_doc_ca     = 'M'
                      price_date     = ls_fatura-prsdt
                      serv_date      = ls_fatura-prsdt
                      taxlawicms     = ls_fatura-j_1btaxlw1
                      taxlawipi      = ls_fatura-j_1btaxlw2
                      taxlawiss      = ls_fatura-j_1btaxlw3
                      taxlawcofins   = ls_fatura-j_1btaxlw4
                      taxlawpis      = ls_fatura-j_1btaxlw5
                      sd_taxcode     = ls_fatura-j_1btxsdc ) TO gt_items_in.

      APPEND VALUE #( updateflag     = 'I'
                      itm_number     = lv_itm_number
                      plant          = abap_true
                      store_loc      = abap_true
                      batch          = abap_true
                      material       = abap_true
                      target_qty     = abap_true
                      ref_doc        = abap_true
                      ref_doc_it     = abap_true
                      target_qu      = abap_true
                      sales_unit     = abap_true
                      exchg_rate     = abap_true
                      ex_rate_fi     = abap_true
                      ref_doc_ca     = abap_true
                      price_date     = abap_true
                      serv_date      = abap_true
                      taxlawicms     = abap_true
                      taxlawipi      = abap_true
                      taxlawiss      = abap_true
                      taxlawcofins   = abap_true
                      taxlawpis      = abap_true
*                      sd_taxcode     = lv_taxcode
                      sd_taxcode      = abap_true ) TO gt_items_inx.

      APPEND VALUE #( partn_role     = 'AG'
                      partn_numb     = iv_emissor ) TO gt_partners.

      APPEND VALUE #( partn_role     = 'SP'
                      partn_numb     = <fs_devolucao>-transportadora ) TO gt_partners.

      APPEND VALUE #( partn_role     = 'YM'
                      partn_numb     = <fs_devolucao>-motorista ) TO gt_partners.

      APPEND VALUE #( itm_number     = lv_itm_number
                      req_qty        = <fs_devolucao>-quantidade ) TO gt_schedules_in.

      APPEND VALUE #( itm_number     = lv_itm_number
                      req_qty        = abap_true
                      updateflag     = 'I' ) TO gt_schedules_inx.


      TRY.
          "Cenário para E-commerce
          DATA(ls_vbpa) = lt_vbpa[ vbeln = <fs_devolucao>-fatura ].

*          TRY.
*              DATA(ls_adrc) = lt_adrc[ addrnumber = ls_vbpa-adrnr ].

              APPEND VALUE #( partn_role     = 'WE'
                              partn_numb     = ls_vbpa-kunnr
                              address        = ls_vbpa-adrnr ) TO gt_partners.
*                              name           = ls_adrc-name1
*                              street         = |{ ls_adrc-street } { ls_adrc-house_num1 },{ ls_adrc-house_num2 }|
*                              country        = ls_adrc-country
*                              postl_code     = ls_adrc-post_code1
*                              city           = ls_adrc-city1
*                              district       = ls_adrc-city2
*                              region         = ls_adrc-region
*                              langu          = ls_adrc-langu     ) TO gt_partners.
*
*            CATCH cx_sy_itab_line_not_found.
*          ENDTRY.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      TRY.
          DATA(ls_vbrk) = lt_vbrk[ vbeln = <fs_devolucao>-fatura ].

          READ TABLE lt_pricing TRANSPORTING NO FIELDS WITH KEY knumv = ls_vbrk-knumv kposn = <fs_devolucao>-itemfatura BINARY SEARCH.
          IF sy-subrc = 0.

            LOOP AT lt_pricing ASSIGNING FIELD-SYMBOL(<fs_pricing>) FROM sy-tabix.

              IF <fs_pricing>-knumv <> ls_vbrk-knumv
              OR <fs_pricing>-kposn <> <fs_devolucao>-itemfatura.
                EXIT.
              ELSE.

                APPEND VALUE #( kposn         = lv_itm_number
                                kschl         = <fs_pricing>-kschl ) TO gt_lpp.

                IF <fs_devolucao>-aceitavalores IS NOT INITIAL.

                  IF <fs_pricing>-kbetr NE <fs_devolucao>-sugestaovalor AND ls_vbrk-kalsm EQ cond_preco( ).
                    <fs_pricing>-kschl ='ZPR1'.
                  ENDIF.

                  <fs_pricing>-kbetr = <fs_devolucao>-sugestaovalor.

                ENDIF.

*                IF <fs_pricing>-kschl <> 'VPRS'.
                IF <fs_pricing>-kschl <> 'ZST1'.

                  IF <fs_pricing>-kschl = 'ZLPP'.
*                    <fs_pricing>-kschl ='ZPR1'.
                    EXIT.
                  ENDIF.

                  IF <fs_pricing>-kschl IN gt_cond_ecom AND lv_zfec NE abap_true.
                    " Atualiza o cabeçalho
                    APPEND VALUE #( itm_number    = '000000'
                                    cond_type     = <fs_pricing>-kschl
                                    cond_value    = <fs_pricing>-kbetr
                                    currency      = <fs_pricing>-waers
                                    cond_unit     = <fs_pricing>-kmein
                                    cond_p_unt    = <fs_pricing>-kpein ) TO gt_conditions_in.

                    lv_zfec  = abap_true.

                  ELSE.

                    APPEND VALUE #( itm_number    = lv_itm_number
                                    cond_type     = <fs_pricing>-kschl
                                    cond_value    = <fs_pricing>-kbetr
                                    currency      = <fs_pricing>-waers
                                    cond_unit     = <fs_pricing>-kmein
                                    cond_p_unt    = <fs_pricing>-kpein ) TO gt_conditions_in.
                  ENDIF.

                ELSE.

                  IF ls_vbrk-waerk NE 'BRL'.

                    <fs_pricing>-kschl ='ZPR1'.
                    <fs_pricing>-kbetr = ( <fs_pricing>-kwert / <fs_devolucao>-quantidadefatura ) * 1000.

                    APPEND VALUE #( itm_number    = lv_itm_number
                                    cond_type     = <fs_pricing>-kschl
                                    cond_value    = <fs_pricing>-kbetr
                                    currency      = <fs_pricing>-waerk
                                    cond_unit     = <fs_pricing>-kmein
                                    cond_p_unt    = '1000' ) TO gt_conditions_in.

                  ELSE.
                    <fs_pricing>-kbetr = ( <fs_pricing>-kwert / <fs_devolucao>-quantidadefatura ) * 1000.

                    <fs_pricing>-kschl ='ZPR1'.
                    APPEND VALUE #( itm_number    = lv_itm_number
                                    cond_type     = <fs_pricing>-kschl
                                    cond_value    = <fs_pricing>-kbetr
                                    currency      = <fs_pricing>-waerk
                                    cond_unit     = <fs_pricing>-kmein
                                    cond_p_unt    = '1000' ) TO gt_conditions_in.

                  ENDIF.

                ENDIF.

              ENDIF.
            ENDLOOP.
          ENDIF.

        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      ls_desconto = busca_limite_total( it_desconto = lt_desconto is_devolucao = <fs_devolucao> ).

      IF ls_desconto IS NOT INITIAL.
        APPEND VALUE #( itm_number    = lv_itm_number
                        cond_type     = ls_desconto-kschl
                        cond_value    = ls_desconto-kbetr
                        currency      = ls_desconto-waers
                        cond_unit     = ls_desconto-kmein
                        cond_p_unt    = ls_desconto-kpein ) TO gt_conditions_in.
      ENDIF.

      CLEAR: lv_deposito, lv_lote, lv_werks, ls_desconto, ls_fatura, ls_vbrk.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_cond_expo.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
                                EXPORTING
                                  iv_modulo = gc_parametros-modulo
                                  iv_chave1 = gc_parametros-chave1
                                  iv_chave2 = gc_parametros-chave2_cond_expo
                                IMPORTING
                                  et_range  = gt_cond_expo ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.

  METHOD get_cond_ecom.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
                                EXPORTING
                                  iv_modulo = gc_parametros-modulo
                                  iv_chave1 = gc_parametros-chave1
                                  iv_chave2 = gc_parametros-chave2_cond_ecom
                                IMPORTING
                                  et_range  = gt_cond_ecom ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.


  METHOD cond_preco.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
        EXPORTING
        iv_modulo = gc_parametros-modulo
        iv_chave1 = gc_parametros-chave1
        iv_chave2 = gc_parametros-chave2_cond_preco
        IMPORTING
        et_range  = gt_condicao_preco ).

        READ TABLE gt_condicao_preco ASSIGNING FIELD-SYMBOL(<fs_condicao_preco>) INDEX 1.
        IF <fs_condicao_preco> IS ASSIGNED.
          rv_cond_preco = <fs_condicao_preco>-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.


  METHOD busca_limite_total.

    TRY.

        DATA(lo_desconto) =  NEW zclsd_ckpt_dev_calc_valores(  ).

        rs_desconto  = it_desconto[ vbeln = is_devolucao-fatura kposn = is_devolucao-itemfatura ].

        DATA(ls_devolucao) = is_devolucao.

        IF is_devolucao-unmedida = is_devolucao-unmedidafatura.
          "Calcula Sugestão de Valores com as mesmas unidades
          lo_desconto->get_sugestao_vlr_unit( EXPORTING is_preco = rs_desconto CHANGING cs_refvalores = ls_devolucao ).
        ELSE.
          "Calcula Sugestão de Valores com diferentes unidades
          lo_desconto->get_sugestao_vlr_df_unit( EXPORTING is_preco = rs_desconto CHANGING cs_refvalores = ls_devolucao ).
        ENDIF.

        rs_desconto-kbetr = lo_desconto->gv_desconto_total * -1.

      CATCH cx_sy_itab_line_not_found.
    ENDTRY.

  ENDMETHOD.


  METHOD busca_desconto.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
        EXPORTING
        iv_modulo = gc_parametros-modulo
        iv_chave1 = gc_parametros-chave1
        iv_chave2 = gc_parametros-chave2_cond
        IMPORTING
        et_range  = gt_condicao ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    SELECT vbrk~vbeln, prcd_elements~kschl, prcd_elements~knumv, prcd_elements~kposn, prcd_elements~kbetr,
    prcd_elements~waers, prcd_elements~kmein, prcd_elements~kpein
    INTO TABLE @et_pricing
    FROM vbrk
      INNER JOIN prcd_elements
       ON vbrk~knumv EQ prcd_elements~knumv
      FOR ALL ENTRIES IN @it_refvalores
      WHERE vbrk~vbeln = @it_refvalores-fatura
        AND prcd_elements~kbetr NE '0'
        AND prcd_elements~kschl IN @gt_condicao.
    SORT et_pricing BY knumv.

  ENDMETHOD.


  METHOD update_table.

    CHECK gv_doc IS NOT INITIAL.

    SELECT SINGLE *
      FROM ztsd_devolucao
      INTO @DATA(ls_devolucao)
      WHERE guid EQ @is_devolucao-guid.

    IF sy-subrc = 0.

      ls_devolucao-ord_devolucao = gv_doc.
      ls_devolucao-situacao      = '2'.

      MODIFY ztsd_devolucao FROM ls_devolucao.

      REFRESH gt_return.
      APPEND VALUE #(  type       = 'S'
                       id         = 'ZSD_COCKPIT_DEVOL'
                       number     = '021'
                       message_v1 = gv_doc ) TO gt_return.

    ENDIF.

  ENDMETHOD.


  METHOD clear_globals.

    CLEAR: gs_header_in,
           gs_header_inx,
           gv_doc,
           gt_return,
           gt_items_in,
           gt_items_inx,
           gt_partners.

  ENDMETHOD.


  METHOD verificaquantidade.

    DATA: lv_menge      TYPE j_1bnetqty,
          lv_quantidade TYPE bstmg.

    SELECT *                                       "#EC CI_EMPTY_SELECT
    FROM zi_sd_cockpit_devolucao_docfat
    FOR ALL ENTRIES IN @it_devolucao
    WHERE docfaturamento EQ @it_devolucao-fatura
      AND item           EQ @it_devolucao-itemfatura
    INTO TABLE @DATA(lt_docfat).
    SORT lt_docfat BY docfaturamento item.

    LOOP AT it_devolucao ASSIGNING FIELD-SYMBOL(<fs_refvalores>).

      READ TABLE lt_docfat ASSIGNING FIELD-SYMBOL(<fs_docfat>) WITH KEY docfaturamento = <fs_refvalores>-fatura
                                                                        item           = <fs_refvalores>-itemfatura BINARY SEARCH.
      IF <fs_docfat> IS ASSIGNED.

        IF <fs_refvalores>-unmedidafatura <> <fs_refvalores>-unmedida.

          lv_quantidade = <fs_refvalores>-quantidade.

          CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
            EXPORTING
              i_matnr              = <fs_refvalores>-material
              i_in_me              = convert_unit( <fs_refvalores> )
              i_out_me             = <fs_refvalores>-unmedidafatura
              i_menge              = lv_quantidade
            IMPORTING
              e_menge              = lv_menge
            EXCEPTIONS
              error_in_application = 1
              error                = 2
              OTHERS               = 3.
          IF sy-subrc <> 0.
            lv_menge = <fs_refvalores>-quantidade.
*            lv_menge = lv_menge * <fs_docfat>-quantidadependente.
          ENDIF.

        ELSE.
          lv_menge = <fs_refvalores>-quantidade.
        ENDIF.

        IF <fs_refvalores>-fatura IS NOT INITIAL AND lv_menge > <fs_docfat>-quantidadependente.

          APPEND VALUE #( id         = 'ZSD_COCKPIT_DEVOL'
                          number     = 036
                          message_v1 = <fs_refvalores>-item
                          field      = 'QUANTIDADEFATURA'
                          type       = 'E'  )  TO rt_mensagens.


        ENDIF.

      ENDIF.
    ENDLOOP.

    SORT rt_mensagens BY message_v1.

  ENDMETHOD.


  METHOD convert_unit.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = is_refvalores-unmedida
        language       = sy-langu
      IMPORTING
        output         = rv_unmedida
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      rv_unmedida = is_refvalores-unmedida.
    ENDIF.

  ENDMETHOD.
  METHOD get_preco_cond_expo.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
                                EXPORTING
                                  iv_modulo = gc_parametros-modulo
                                  iv_chave1 = gc_parametros-chave1
                                  iv_chave2 = gc_parametros-chave2_cond_preco_expo
                                IMPORTING
                                  et_range  = gt_cond_preco_expo ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.

  METHOD get_preco_cond_ecom.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
                                EXPORTING
                                  iv_modulo = gc_parametros-modulo
                                  iv_chave1 = gc_parametros-chave1
                                  iv_chave2 = gc_parametros-chave2_cond_preco_ecom
                                IMPORTING
                                  et_range  = gt_cond_preco_ecom ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
