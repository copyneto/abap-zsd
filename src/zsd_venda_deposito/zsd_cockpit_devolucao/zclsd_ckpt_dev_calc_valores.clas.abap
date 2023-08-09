CLASS zclsd_ckpt_dev_calc_valores DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA gv_desconto_total   TYPE kbetr.

    TYPES:
      BEGIN OF ty_prcd_elements,
        vbeln TYPE vbeln_vf,
        kschl TYPE kscha,
        knumv TYPE knumv,
        kposn TYPE kposn,
        kbetr TYPE vfprc_element_amount,
        waers TYPE waers,
        kmein TYPE kvmei,
        kpein TYPE kpein,
      END OF ty_prcd_elements.

    TYPES:
      "! Type Cockpit Devolução Referenciar e Validar
      ty_refval TYPE TABLE OF zi_sd_cockpit_devolucao_refval,
      ty_precos TYPE TABLE OF ty_prcd_elements.

    "! Gera solução de valor
    "! @parameter ct_refvalores| Dados Devolução Referenciar e Validar
    "! @parameter rt_mensagens | Mensagens de erro
    METHODS main CHANGING  ct_refvalores       TYPE ty_refval
                 RETURNING
                           VALUE(rt_mensagens) TYPE  bapiret2_tab.

    "! Atualiza Preço Liquido
    "! @parameter cs_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter rt_mensagens  | Mensagens de erro
    METHODS atualiza_preco_liquido
      EXPORTING ev_erro             TYPE abap_bool
      CHANGING  cs_refvalores       TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
                VALUE(rt_mensagens) TYPE  bapiret2_tab.

    "! Atualiza Preço Bruto
    "! @parameter ct_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter rt_mensagens  | Mensagens de erro
    METHODS atualiza_preco_bruto
      EXPORTING ev_erro             TYPE abap_bool
      CHANGING  ct_refvalores       TYPE ty_refval
      RETURNING
                VALUE(rt_mensagens) TYPE  bapiret2_tab.

    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .

    METHODS get_sugestao_vlr_unit
      IMPORTING
        is_preco         TYPE zclsd_ckpt_dev_calc_valores=>ty_prcd_elements
        iv_sugestaovalor TYPE abap_bool OPTIONAL
      CHANGING
        cs_refvalores    TYPE zi_sd_cockpit_devolucao_refval.

    METHODS get_sugestao_vlr_df_unit
      IMPORTING
        is_preco         TYPE zclsd_ckpt_dev_calc_valores=>ty_prcd_elements
        iv_sugestaovalor TYPE abap_bool OPTIONAL
      CHANGING
        cs_refvalores    TYPE zi_sd_cockpit_devolucao_refval.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      ty_lt_komv   TYPE STANDARD TABLE OF komv WITH DEFAULT KEY .
    TYPES:
      ty_lt_komv_1 TYPE STANDARD TABLE OF komv WITH DEFAULT KEY .
    TYPES:
      ty_lt_komv_2 TYPE STANDARD TABLE OF komv WITH DEFAULT KEY .

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CONDIÇÃO_DESCONTO',
      END OF gc_parametros .
    DATA:
      gt_bapiparnr   TYPE STANDARD TABLE OF bapiparnr .
    DATA:
      gt_bapisditm   TYPE STANDARD TABLE OF bapisditm .
    DATA:
      gt_bapisditmx  TYPE STANDARD TABLE OF bapisditmx .
    DATA:
      gt_bapicond    TYPE STANDARD TABLE OF bapicond .
    DATA:
      gt_bapicondx   TYPE STANDARD TABLE OF bapicondx .
    DATA:
      gt_bapischdl   TYPE STANDARD TABLE OF bapischdl .
    DATA:
      gt_bapischdlx  TYPE STANDARD TABLE OF bapischdlx .
    DATA:
      gt_bapicond_ex TYPE STANDARD TABLE OF bapicond .
    DATA gs_bapisdhd1 TYPE bapisdhd1 .
    DATA gs_bapisdhd1x TYPE bapisdhd1x .
    DATA gt_return TYPE bapiret2_tab .
    DATA:
        "! Tipo ordem de devolução
      gt_condicao TYPE RANGE OF prcd_elements-kschl .

    "! Busca limite inferior e superior
    "! @parameter iv_knumh      | Nº de registro de condição
    "! @parameter cs_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter ct_mensagens  | Mensagens de retorno
    METHODS busca_limite
      IMPORTING
        !iv_knumh      TYPE konp-knumh OPTIONAL
      CHANGING
        !cs_refvalores TYPE zi_sd_cockpit_devolucao_refval
        !ct_mensagens  TYPE bapiret2_tab .
    "! Busca preço para verificar limite
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter is_fatura     | Documento de faturamento: dados de cabeçalho
    "! @parameter ev_knumh      | Nº de registro de condição
    METHODS busca_preco
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval
        !is_fatura     TYPE vbrk
      EXPORTING
        !ev_knumh      TYPE konp-knumh .
    "! Resgata informações da fatura de venda
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter es_vbrk       | Documento de faturamento: dados de cabeçalho
    METHODS resgata_fatura
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval
      EXPORTING
        !es_vbrk       TYPE vbrk .
    "! Converte unidade de Preço
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter rv_valor_liq  | Valor Cliente após conversão
    METHODS converte_unidade_preco
      IMPORTING
        !is_refvalores      TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
        VALUE(rv_valor_liq) TYPE zi_sd_cockpit_devolucao_refval-sugestaovalor .
    "! Converte unidade
    "! @parameter is_refvalores    | Cockpit Devolução Referenciar e Validar
    "! @parameter is_kmein         | Unidade de medida da condição
    "! @parameter rv_valor_cliente | Valor Cliente após conversão
    METHODS converte_unidade
      IMPORTING
        !is_refvalores          TYPE zi_sd_cockpit_devolucao_refval
        !is_kmein               TYPE konp-kmein
      RETURNING
        VALUE(rv_valor_cliente) TYPE zi_sd_cockpit_devolucao_refval-sugestaovalor .
    "! Atualiza Sugestão de Valor na tabela
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter ct_mensagens  | Mensagens de retorno
    METHODS update_table
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval
      CHANGING
        !ct_mensagens  TYPE bapiret2_tab .
    "! Converter Unidade
    "! @parameter is_refvalores | Cockpit Devolução Referenciar e Validar
    "! @parameter rv_unmedida   | Unidade medida
    METHODS convert_unit
      IMPORTING
        !is_refvalores     TYPE zi_sd_cockpit_devolucao_refval
      RETURNING
        VALUE(rv_unmedida) TYPE zi_sd_cockpit_devolucao_refval-unmedida .
    METHODS montar_parceiro_bapi
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval .
    METHODS montar_divisao_remessa_bapi
      IMPORTING
        !iv_quantidade TYPE zi_sd_cockpit_devolucao_refval-quantidade
        !iv_item       TYPE i .
    METHODS montar_condicoes_bapi
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval
        !iv_item       TYPE i .
    METHODS pegar_condicao_preco
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval
      CHANGING
        !cs_bapicond   TYPE bapicond .
    METHODS montar_itens_bapi
      CHANGING
        !ct_refvalores TYPE zclsd_ckpt_dev_calc_valores=>ty_refval .
    METHODS popular_cabecalho_bapi
      IMPORTING
        !is_refvalores TYPE zi_sd_cockpit_devolucao_refval .
    METHODS popular_tabelas_bapi
      CHANGING
        !ct_refvalores TYPE zclsd_ckpt_dev_calc_valores=>ty_refval .
    METHODS chamar_calculo_bruto
      CHANGING
        !ct_refvalores      TYPE ty_refval
      RETURNING
        VALUE(rt_mensagens) TYPE bapiret2_tab .
    METHODS busca_desconto
      IMPORTING
        !it_refvalores TYPE zclsd_ckpt_dev_calc_valores=>ty_refval
      EXPORTING
        !et_pricing    TYPE ty_precos .
ENDCLASS.



CLASS zclsd_ckpt_dev_calc_valores IMPLEMENTATION.


  METHOD main.

    DATA: lv_quantidade     TYPE bstmg.

    busca_desconto( EXPORTING it_refvalores = ct_refvalores IMPORTING et_pricing = DATA(lt_pricing) ).

    SORT ct_refvalores BY item.

    LOOP AT ct_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).

      <fs_refvalores>-sugestaovalor = converte_unidade_preco( <fs_refvalores> ).

      READ TABLE lt_pricing ASSIGNING FIELD-SYMBOL(<fs_preco>) WITH KEY vbeln = <fs_refvalores>-fatura
                                                                        kposn = <fs_refvalores>-itemfatura BINARY SEARCH.

      IF <fs_preco> IS ASSIGNED.

        IF <fs_refvalores>-unmedida = <fs_refvalores>-unmedidafatura.
          "Calcula Sugestão de Valores com as mesmas unidades
          get_sugestao_vlr_unit( EXPORTING is_preco = <fs_preco> iv_sugestaovalor = abap_true CHANGING cs_refvalores = <fs_refvalores> ).
        ELSE.
          "Calcula Sugestão de Valores com diferentes unidades
          get_sugestao_vlr_df_unit( EXPORTING is_preco = <fs_preco> iv_sugestaovalor = abap_true CHANGING cs_refvalores = <fs_refvalores> ).
        ENDIF.
        UNASSIGN <fs_preco>.
        CLEAR gv_desconto_total.
      ENDIF.

      "Atualiza Sugestão de Valor na tabela
      update_table( EXPORTING is_refvalores = <fs_refvalores> CHANGING ct_mensagens  = rt_mensagens ).

    ENDLOOP.

  ENDMETHOD.


  METHOD get_sugestao_vlr_df_unit.

    DATA: lv_desconto_unit    TYPE vfprc_element_amount ,
          lv_total_cliente    TYPE vfprc_element_amount ,
          lv_valor_total      TYPE vfprc_element_amount ,
          lv_quantidadefatura TYPE j_1bnetqty,
          lv_quantidade       TYPE bstmg.

    lv_quantidadefatura = cs_refvalores-quantidadefatura.

    CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
      EXPORTING
        i_matnr              = cs_refvalores-material
        i_in_me              = cs_refvalores-unmedidafatura
        i_out_me             = convert_unit( cs_refvalores )
        i_menge              = lv_quantidadefatura
      IMPORTING
        e_menge              = lv_quantidade
      EXCEPTIONS
        error_in_application = 1
        error                = 2
        OTHERS               = 3.

    IF sy-subrc NE 0.
      lv_quantidade = cs_refvalores-quantidade.
    ENDIF.

    lv_desconto_unit    = is_preco-kbetr / lv_quantidade * -1.         "Desconto por Unidade
    gv_desconto_total   = cs_refvalores-quantidade * lv_desconto_unit.       "Desconto Total
    lv_total_cliente    = cs_refvalores-valorunit * cs_refvalores-quantidade."Preço total cliente
    lv_valor_total      = lv_total_cliente + gv_desconto_total.              "Total com desconto

    IF iv_sugestaovalor EQ abap_true.
      cs_refvalores-sugestaovalor = lv_valor_total * cs_refvalores-sugestaovalor / lv_total_cliente.
    ENDIF.
  ENDMETHOD.


  METHOD get_sugestao_vlr_unit.

    DATA: lv_desconto_unit  TYPE  vfprc_element_amount.

    lv_desconto_unit  = is_preco-kbetr / cs_refvalores-quantidadefatura * -1. "Desconto por Unidade
    gv_desconto_total = cs_refvalores-quantidade * lv_desconto_unit.          "Desconto Total

    IF iv_sugestaovalor EQ abap_true.
      cs_refvalores-sugestaovalor = cs_refvalores-sugestaovalor + lv_desconto_unit.
    ENDIF.
  ENDMETHOD.


  METHOD busca_desconto.

    DATA(lo_tabela_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    TRY.
        lo_tabela_parametros->m_get_range(
        EXPORTING
        iv_modulo = gc_parametros-modulo
        iv_chave1 = gc_parametros-chave1
        iv_chave2 = gc_parametros-chave2
        IMPORTING
        et_range  = gt_condicao ).

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

      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.


  METHOD busca_limite.

    DATA lv_mxwrt TYPE char5.
    DATA lv_gkwrt TYPE char5.

    SELECT SINGLE mxwrt, gkwrt, kmein
    FROM konp
    INTO @DATA(ls_konp)
    WHERE knumh = @iv_knumh.
*
*    IF sy-subrc <> 0.
*
*      "Aconteceu um erro na validação do preço para o material &1.
*      APPEND VALUE #(  type       = 'E'
*                       id         = 'ZSD_COCKPIT_DEVOL'
*                       number     = '031'
*                       message_v1 = cs_refvalores-material  ) TO ct_mensagens.
*
*    ELSE.

    IF sy-subrc = 0.
      " retorno - mensagem
      IF ( cs_refvalores-sugestaovalor < ls_konp-mxwrt )
      OR ( cs_refvalores-sugestaovalor  > ls_konp-gkwrt ).
        lv_mxwrt = ls_konp-mxwrt.
        lv_gkwrt = ls_konp-gkwrt.

        APPEND VALUE #(  type       = 'I'
                         id         = 'ZSD_COCKPIT_DEVOL'
                         number     = '034'
                         message_v1 = cs_refvalores-item
                         message_v2 = lv_mxwrt
                         message_v3 = lv_gkwrt ) TO ct_mensagens.

      ENDIF.
    ENDIF.
*&---------------------------------------------------------------------*
*       Converter quantidade pela unid. medida do cliente
*----------------------------------------------------------------------*
    cs_refvalores-totalfatura = converte_unidade( is_refvalores = cs_refvalores  is_kmein = ls_konp-kmein  )." Valor liquido


*    ENDIF.

  ENDMETHOD.


  METHOD converte_unidade.

    DATA: lv_menge      TYPE j_1bnetqty,
          lv_quantidade TYPE bstmg,
          lv_decimal    TYPE kbetr.

* Get the decimals.
    lv_decimal = frac( is_refvalores-quantidade ).

    IF is_refvalores-unmedidafatura <> is_refvalores-unmedida OR lv_decimal <> 0.

      lv_quantidade = is_refvalores-quantidade.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = is_refvalores-material
          i_in_me              = is_refvalores-unmedida
          i_out_me             = is_refvalores-unmedidafatura "is_kmein
          i_menge              = lv_quantidade
        IMPORTING
          e_menge              = lv_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.
      IF sy-subrc EQ 0.
        rv_valor_cliente = is_refvalores-sugestaovalor * lv_menge.
      ENDIF.

    ELSE.

      rv_valor_cliente = is_refvalores-sugestaovalor * is_refvalores-quantidade.

    ENDIF.

  ENDMETHOD.


  METHOD busca_preco.

    SELECT SINGLE knumh
    FROM a817
    INTO  ev_knumh
    WHERE kappl = 'V'
    AND kschl ='ZPR0'
    AND vtweg = is_fatura-vtweg
    AND pltyp = is_fatura-pltyp
    AND werks = is_refvalores-centro
    AND matnr = is_refvalores-material.

    IF  ev_knumh IS INITIAL.

      SELECT SINGLE knumh
      FROM a816
      INTO  ev_knumh
      WHERE kappl = 'V'
      AND kschl ='ZPR0'
      AND vtweg = is_fatura-vtweg
      AND werks = is_refvalores-centro
      AND matnr = is_refvalores-material.

    ENDIF.

  ENDMETHOD.


  METHOD resgata_fatura.

    SELECT SINGLE *
    FROM vbrk
    INTO es_vbrk
    WHERE vbeln = is_refvalores-fatura.

  ENDMETHOD.


  METHOD converte_unidade_preco.

    DATA: lv_menge         TYPE j_1bnetqty,
          lv_total_cliente TYPE zi_sd_cockpit_devolucao_refval-sugestaovalor.

    IF is_refvalores-unmedida <> is_refvalores-unmedidafatura.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = is_refvalores-material
          i_in_me              = is_refvalores-unmedidafatura
          i_out_me             = convert_unit( is_refvalores )
          i_menge              = 1
        IMPORTING
          e_menge              = lv_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc EQ 0.
        IF lv_menge IS NOT INITIAL.

          lv_total_cliente = is_refvalores-valorunit * is_refvalores-quantidade.

          lv_menge = is_refvalores-quantidade / lv_menge.
          rv_valor_liq = lv_total_cliente / lv_menge.

        ENDIF.
      ENDIF.

    ELSE.

      rv_valor_liq = is_refvalores-valorunit.

    ENDIF.

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


  METHOD update_table.

    SELECT SINGLE *
      FROM ztsd_devolucao_i
      INTO @DATA(ls_devol_item)
      WHERE guid EQ @is_refvalores-guid
        AND item EQ @is_refvalores-item.

    IF sy-subrc = 0.
      ls_devol_item-vl_sugestao = is_refvalores-sugestaovalor.

      MODIFY ztsd_devolucao_i FROM ls_devol_item.

      APPEND VALUE #(  type       = 'S'
                       id         = 'ZSD_COCKPIT_DEVOL'
                       number     = '033'
                       message_v1 = is_refvalores-item
                       message_v2 = is_refvalores-sugestaovalor ) TO ct_mensagens.

    ENDIF.

  ENDMETHOD.


  METHOD atualiza_preco_bruto.

    popular_tabelas_bapi( CHANGING ct_refvalores = ct_refvalores ).

    chamar_calculo_bruto( CHANGING ct_refvalores = ct_refvalores ).

  ENDMETHOD.


  METHOD popular_tabelas_bapi.

    DATA(ls_refvalores) = ct_refvalores[ 1 ].

    popular_cabecalho_bapi( ls_refvalores ).
    montar_parceiro_bapi( ls_refvalores ).
    montar_itens_bapi( CHANGING ct_refvalores = ct_refvalores ).

  ENDMETHOD.


  METHOD  chamar_calculo_bruto.

    DATA: lv_tabix       TYPE sy-index.

    " Mostrar andamento na barra de status

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        sales_header_in      = gs_bapisdhd1
        sales_header_inx     = gs_bapisdhd1x
*       business_object      = 'BUS2102'
        business_object      = space
        testrun              = 'X'
      TABLES
        return               = gt_return
        sales_items_in       = gt_bapisditm
        sales_items_inx      = gt_bapisditmx
        sales_partners       = gt_bapiparnr
        sales_schedules_in   = gt_bapischdl
        sales_schedules_inx  = gt_bapischdlx
        sales_conditions_in  = gt_bapicond
        sales_conditions_inx = gt_bapicondx
        conditions_ex        = gt_bapicond_ex.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_return IS NOT INITIAL.
    rt_mensagens = gt_return.
    SORT gt_bapicond_ex BY itm_number cond_type.

*** Mensagens de erro!
    IF line_exists( rt_mensagens[ type = 'E' ] ).

      DELETE rt_mensagens WHERE type EQ 'S'.

    ELSE.

      " Alterando tabela valida com subtotais
      LOOP AT ct_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).
        READ TABLE gt_bapicond_ex ASSIGNING FIELD-SYMBOL(<fs_bapicond_ex>) WITH KEY itm_number = <fs_refvalores>-itemfatura
                                                                                    cond_type  = 'ZTOT' BINARY SEARCH.
        IF <fs_bapicond_ex> IS ASSIGNED.
          <fs_refvalores>-brutofatura = <fs_bapicond_ex>-condvalue.
        ELSE.

          READ TABLE gt_bapicond_ex ASSIGNING <fs_bapicond_ex> WITH KEY itm_number = <fs_refvalores>-itemfatura
                                                                        cond_type  = 'SKTO' BINARY SEARCH."'ZCRE' .
          IF <fs_bapicond_ex> IS ASSIGNED.
            <fs_refvalores>-brutofatura = <fs_bapicond_ex>-condvalue.
          ENDIF.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'SD_SALESDOCUMENT_CREATE'
    TABLES
     return        = gt_return
     conditions_ex = gt_bapicond_ex.
    RETURN.

  ENDMETHOD.


  METHOD popular_cabecalho_bapi .

    DATA: lv_ordem      TYPE vbeln,
          lv_remessa    TYPE vbeln,
          lv_transporte TYPE tknum,
          lv_tipo_ordem TYPE auart.

    CLEAR gs_bapisdhd1.

    " Número de referencia - nota fiscal
    CONCATENATE is_refvalores-numnfe
                '-'
                is_refvalores-serie
           INTO gs_bapisdhd1-ref_doc_l.

*    " Existe ZOVD ?
*
*    SELECT SINGLE vbak~auart vbak~vkorg vbak~vtweg vbak~spart
*      INTO ( lv_tipo_ordem, gs_bapisdhd1-sales_org,
*             gs_bapisdhd1-distr_chan, gs_bapisdhd1-division )
*       FROM vbak
*    INNER JOIN  vbfa
*    ON vbak~vbeln = vbfa~vbelv
*    WHERE vbfa~vbeln   EQ is_refvalores-fatura
*      AND vbfa~posnn   EQ is_refvalores-itemfatura
*      AND vbfa~vbtyp_n EQ 'M'
*      AND vbfa~vbtyp_v IN ('C', 'I')
*      AND vbak~auart = 'ZOVD'.
*
*    " Buscar Tipo de ordem de saída para definir
*    IF lv_tipo_ordem IS NOT INITIAL.
*
*      gs_bapisdhd1x-sales_org  = abap_true.
*      gs_bapisdhd1x-distr_chan = abap_true.
*      gs_bapisdhd1x-division   = abap_true.
*
*      " de-para - tipos de ordem devolução
*      SELECT SINGLE tpfat
*      FROM zi_sd_param_tp_ov_dev
*        INTO @gs_bapisdhd1-doc_type
*        WHERE tpordem = @lv_tipo_ordem.
*
*    ELSE.

    SELECT SINGLE vbak~auart vbak~vkorg vbak~vtweg vbak~spart
      INTO ( lv_tipo_ordem, gs_bapisdhd1-sales_org,
             gs_bapisdhd1-distr_chan, gs_bapisdhd1-division )
       FROM vbak
    INNER JOIN  vbfa
    ON vbak~vbeln = vbfa~vbelv
  WHERE vbfa~vbeln   EQ is_refvalores-fatura
    AND vbfa~posnn   EQ is_refvalores-itemfatura
    AND vbfa~vbtyp_n EQ 'M'
    AND vbfa~vbtyp_v IN ('C', 'I').

    IF sy-subrc EQ 0.
      gs_bapisdhd1x-sales_org  = abap_true.
      gs_bapisdhd1x-distr_chan = abap_true.
      gs_bapisdhd1x-division   = abap_true.

      " de-para - tipos de ordem devolução
      SELECT SINGLE tpordem
      FROM zi_sd_param_tp_ov_dev
        INTO @gs_bapisdhd1-doc_type
        WHERE tpfat = @is_refvalores-billingdocumenttype.

    ENDIF.
*    ENDIF.

    " Meio de pagamento
    gs_bapisdhd1-pymt_meth  = is_refvalores-meiopagamento.
    gs_bapisdhd1x-pymt_meth = abap_true.


    " Numero do pedido
*    IF is_refvalores- IS NOT INITIAL.
*      gs_bapisdhd1-purch_no_c  = gw_pre_registro-pre_ordem.
*      gs_bapisdhd1x-purch_no_c = abap_true.
*    ENDIF.

    " Quando nota do cliente
    IF is_refvalores-tpdevolucao = '1'.

*      IF is_refvalores-datafatura IS NOT INITIAL.
*        gs_bapisdhd1-fix_val_dy  = is_refvalores-datafatura.
*        gs_bapisdhd1x-fix_val_dy = abap_true.
*      ENDIF.

*      gs_bapisdhd1-ref_1      = gw_pre_registro-pre_ordem.
*      gs_bapisdhd1x-ref_1     = abap_true.
    ENDIF.

    gs_bapisdhd1-ord_reason  = is_refvalores-motivo.
    gs_bapisdhd1-ref_doc     = is_refvalores-fatura.
    gs_bapisdhd1-refdoc_cat  = 'M'.
*    gs_bapisdhd1-purch_date  = is_refvalores-datafatura.

    gs_bapisdhd1x-updateflag = 'I'.
    gs_bapisdhd1x-doc_type   = abap_true.
    gs_bapisdhd1x-ord_reason = abap_true.
    gs_bapisdhd1x-ref_doc    = abap_true.
    gs_bapisdhd1x-ref_doc_l  = abap_true.
    gs_bapisdhd1x-refdoc_cat  = abap_true.
*    gs_bapisdhd1x-purch_date = abap_true.
*    gs_bapisdhd1x-purch_no_c = abap_true.
    gs_bapisdhd1x-name       = abap_true.

    " Data do preço - cabeçalho
*    gs_bapisdhd1-price_date  = is_refvalores-datafatura.
*    gs_bapisdhd1x-price_date = abap_true.


  ENDMETHOD.


  METHOD montar_itens_bapi.

    DATA: lv_matnr      TYPE mara-matnr,
          lv_lote       TYPE charg_d,
          lv_item       TYPE i,
          ls_bapisditm  TYPE bapisditm,
          ls_bapisditmx TYPE bapisditmx.

    CONSTANTS lc_refdoc TYPE string VALUE 'M'.
    CONSTANTS lc_updateflag TYPE string VALUE 'I'.

    " Itens de devolução validados
    LOOP AT ct_refvalores ASSIGNING FIELD-SYMBOL(<fs_refvalores>).

*      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*        EXPORTING
*          input  = <fs_refvalores>-material
*        IMPORTING
*          output = lv_matnr.

      " Buscar lote
      CLEAR lv_lote.
      SELECT SINGLE charg FROM vbrp
        INTO lv_lote
        WHERE vbeln   EQ <fs_refvalores>-fatura
          AND aupos   EQ <fs_refvalores>-itemfatura
          AND matnr   EQ <fs_refvalores>-material
          AND charg   NE space.

      CLEAR gt_bapisditm.
      CLEAR gt_bapisditmx.

      ADD 10 TO lv_item.

      ls_bapisditm-itm_number  = lv_item.
      ls_bapisditmx-itm_number = lv_item.

      ls_bapisditm-ref_doc     = <fs_refvalores>-fatura.
      ls_bapisditmx-ref_doc    = abap_true.

      ls_bapisditm-ref_doc_it  = <fs_refvalores>-itemfatura.
      ls_bapisditmx-ref_doc_it = abap_true.

      ls_bapisditm-ref_doc_ca  = lc_refdoc.
      ls_bapisditmx-ref_doc_ca = abap_true.

      ls_bapisditm-material    = <fs_refvalores>-material.
      ls_bapisditmx-material   = abap_true.

      ls_bapisditm-target_qty  = <fs_refvalores>-quantidade.
      ls_bapisditmx-target_qty = abap_true.

      ls_bapisditm-sales_unit  = <fs_refvalores>-unmedida.
      ls_bapisditmx-sales_unit = abap_true.

      ls_bapisditm-po_itm_no   = <fs_refvalores>-itemfatura.
      ls_bapisditmx-po_itm_no  = abap_true.

      ls_bapisditm-price_date  = <fs_refvalores>-datafatura.
      ls_bapisditmx-price_date = abap_true.

      ls_bapisditm-serv_date   = <fs_refvalores>-datafatura.
      ls_bapisditmx-serv_date  = abap_true.

      ls_bapisditm-plant       = <fs_refvalores>-centro.
      ls_bapisditmx-plant      = abap_true.

      IF lv_lote IS NOT INITIAL.
        ls_bapisditm-batch       = lv_lote.
        ls_bapisditmx-batch      = abap_true.
      ENDIF.

      APPEND ls_bapisditm  TO gt_bapisditm.

      ls_bapisditmx-updateflag = lc_updateflag.

      APPEND ls_bapisditmx TO gt_bapisditmx.

      " Monta divisão de remessa
      montar_divisao_remessa_bapi( iv_item = lv_item iv_quantidade = <fs_refvalores>-quantidade ).

      montar_condicoes_bapi( iv_item = lv_item is_refvalores = <fs_refvalores> ).

      <fs_refvalores>-itemfatura = lv_item.

    ENDLOOP.

  ENDMETHOD.


  METHOD montar_divisao_remessa_bapi.

    CONSTANTS lc_0001 TYPE decfloat16 VALUE '0001'.

    DATA: ls_bapischdl  TYPE bapischdl,
          ls_bapischdlx TYPE bapischdlx.

    CLEAR ls_bapischdl.
    ls_bapischdl-itm_number  = iv_item.
    ls_bapischdl-req_qty     = iv_quantidade.
    ls_bapischdl-sched_line  = lc_0001.
    APPEND ls_bapischdl TO gt_bapischdl.

    CLEAR ls_bapischdlx.
    ls_bapischdlx-itm_number  = iv_item.
    ls_bapischdlx-sched_line  = lc_0001.
    ls_bapischdlx-req_qty     = abap_true.
    APPEND ls_bapischdlx TO gt_bapischdlx.

  ENDMETHOD.


  METHOD montar_condicoes_bapi.

    CONSTANTS lc_zpr0 TYPE string VALUE 'ZPR0' ##NO_TEXT.
    CONSTANTS lc_zdcd TYPE string VALUE 'ZDCD' ##NO_TEXT.

    DATA: lv_menge      TYPE menge_d,
          lv_quantidade TYPE bstmg.

    DATA: ls_bapicond  TYPE bapicond,
          ls_bapicondx TYPE bapicondx.

    CLEAR ls_bapicond.
    ls_bapicond-itm_number = iv_item.
    ls_bapicond-cond_st_no = 10.
    ls_bapicond-cond_count = 1.
    ls_bapicond-cond_type  = lc_zpr0.
    ls_bapicond-cond_updat = abap_true.
    ls_bapicond-cond_value = is_refvalores-sugestaovalor." * '0.1'.
    ls_bapicond-cond_unit  = is_refvalores-unmedidafatura.
    ls_bapicond-currency   = is_refvalores-codmoeda.
    ls_bapicond-cond_p_unt = 1.
    APPEND ls_bapicond TO gt_bapicond.

    CLEAR ls_bapicondx.
    ls_bapicondx-itm_number = iv_item.
    ls_bapicondx-cond_st_no = 10.
    ls_bapicondx-cond_count = 1.
    ls_bapicondx-cond_type  = lc_zpr0.
    ls_bapicondx-updateflag = abap_true.
    ls_bapicondx-cond_value = abap_true.
    ls_bapicondx-cond_unit  = abap_true.
    ls_bapicondx-currency   = abap_true.
    ls_bapicondx-cond_p_unt = abap_true.
    APPEND ls_bapicondx TO gt_bapicondx.

    CLEAR: ls_bapicond, ls_bapicondx.

    " Quando houver desconto
    IF gs_bapisdhd1-doc_type = lc_zdcd.

      pegar_condicao_preco(  EXPORTING is_refvalores = is_refvalores CHANGING cs_bapicond = ls_bapicond ).

      IF ls_bapicond-cond_type IS NOT INITIAL.

        lv_quantidade = is_refvalores-quantidade.

        " Converter quantidade na unidade do cliente
        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = is_refvalores-material
            i_in_me              = is_refvalores-unmedidafatura
            i_out_me             = is_refvalores-unmedida
            i_menge              = lv_quantidade
          IMPORTING
            e_menge              = lv_menge
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        IF sy-subrc EQ 0.

          " Preencher ZBON
          ls_bapicond-itm_number = iv_item.
          ls_bapicond-cond_st_no = 10.
          ls_bapicond-cond_count = 1.
          ls_bapicond-cond_updat = abap_true.
          ls_bapicond-cond_value = lv_menge * ( ls_bapicond-cond_value * '0.1' ).
          APPEND ls_bapicond TO gt_bapicond.

          ls_bapicondx-itm_number = iv_item.
          ls_bapicondx-cond_st_no = 10.
          ls_bapicondx-cond_count = 1.
          ls_bapicondx-cond_type  = ls_bapicond-cond_type.
          ls_bapicondx-updateflag = abap_true.
          ls_bapicondx-cond_value = abap_true.
          APPEND ls_bapicondx TO gt_bapicondx.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD pegar_condicao_preco.

    CONSTANTS: lc_m    TYPE string VALUE 'M',
               lc_c    TYPE string VALUE 'C',
               lc_i    TYPE string VALUE 'I',
               lc_zbon TYPE string VALUE 'ZBON',
               lc_000  TYPE decfloat16 VALUE '0.00'.

    DATA:lv_kwert TYPE kwert,
         lv_menge TYPE menge_d.

* Pricing Condition Master
    TYPES: BEGIN OF ty_t685a,
             kschl     TYPE t685a-kschl,
             kaend_wrt TYPE t685a-kaend_wrt,
           END OF ty_t685a.

    SELECT SINGLE vbelv FROM vbfa
      INTO @DATA(lv_ordem)
      WHERE vbeln   EQ @is_refvalores-fatura
        AND posnn   EQ @is_refvalores-itemfatura
        AND vbtyp_n EQ @lc_m
        AND vbtyp_v IN ( @lc_c, @lc_i ).

    IF sy-subrc EQ 0.

      SELECT *
             INTO TABLE @DATA(lt_vbak)
             FROM vbak
             WHERE vbeln = @lv_ordem.

      READ TABLE lt_vbak ASSIGNING FIELD-SYMBOL(<fs_vbak>) INDEX 1.
      IF <fs_vbak> IS ASSIGNED.

        SELECT SINGLE kwert kschl
               INTO (lv_kwert, cs_bapicond-cond_type)
               FROM konv
               WHERE knumv = <fs_vbak>-knumv AND
                     kposn = is_refvalores-itemfatura AND
                     kschl = lc_zbon  AND
                     kwert <> lc_000.

        IF sy-subrc EQ 0 AND  lv_kwert IS NOT INITIAL.

          SELECT SINGLE kwmeng
                 INTO lv_menge
                 FROM vbap
                 WHERE vbeln = lv_ordem
                   AND matnr = is_refvalores-material.
          IF sy-subrc EQ 0.
            IF lv_menge IS NOT INITIAL.
              cs_bapicond-cond_value = lv_kwert / lv_menge.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD montar_parceiro_bapi.

    DATA ls_bapiparnr TYPE bapiparnr.

    ls_bapiparnr-partn_role   = 'AG'.
    ls_bapiparnr-partn_numb   = is_refvalores-cliente.
    APPEND ls_bapiparnr TO gt_bapiparnr.

    CLEAR ls_bapiparnr.
    ls_bapiparnr-partn_role   = 'WE'.
    ls_bapiparnr-partn_numb   = is_refvalores-cliente.
    APPEND ls_bapiparnr TO gt_bapiparnr.

  ENDMETHOD.


  METHOD atualiza_preco_liquido.

    DATA: lt_komv      TYPE TABLE OF komv,
          lt_tvbdpr_in TYPE TABLE OF vbdpr,
          lt_hkomvd    TYPE TABLE OF komvd.

    DATA: ls_vbco3 TYPE vbco3,
          ls_konp  TYPE konp,
          ls_komp  TYPE komp,
          ls_komk  TYPE komk,
          ls_komv  TYPE komv.


*&---------------------------------------------------------------------*
*       Verifica se preço está entre mínimo e máximo
*----------------------------------------------------------------------*

    " Resgata informações da fatura de venda
    resgata_fatura( EXPORTING
                     is_refvalores = cs_refvalores
                    IMPORTING
                     es_vbrk = DATA(ls_fatura) ).

    IF ls_fatura IS NOT INITIAL.

      busca_preco( EXPORTING
                    is_refvalores = cs_refvalores
                    is_fatura = ls_fatura
                   IMPORTING
                    ev_knumh = DATA(lv_knumh) ).

      " busca limite inferior e superior
      busca_limite( EXPORTING
                     iv_knumh      = lv_knumh
                    CHANGING
                     cs_refvalores = cs_refvalores
                     ct_mensagens  = rt_mensagens ).
    ENDIF.

    "Atualiza Sugestão de Valor na tabela
    IF line_exists( rt_mensagens[ type = 'E' ] ).
      "Aconteceu um erro na validação do preço para o item &1.
      APPEND VALUE #(  type       = 'E'
                       id         = 'ZSD_COCKPIT_DEVOL'
                       number     = '032'
                       message_v1 = cs_refvalores-item ) TO rt_mensagens.

      ev_erro = abap_true.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
