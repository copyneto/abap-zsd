CLASS zclsd_cria_ordem_intercompany DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método que realiza processo em background
    "! @parameter P_TASK        | Parâmentro standard
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Método principal
    "! @parameter IS_INPUT        | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS execute
      IMPORTING
        !is_input        TYPE zssd_ordem_intercompany
        !is_continuar    TYPE char1
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
  PROTECTED SECTION.
private section.

  types:
    tt_order_items_inx      TYPE TABLE OF bapisditmx .
  types:
    tt_order_items_in       TYPE TABLE OF bapisditm .
  types:
    tt_order_schedules_inx  TYPE TABLE OF bapischdlx .
  types:
    tt_order_schedules_in   TYPE TABLE OF bapischdl .
  types:
    tt_order_conditions_inx TYPE TABLE OF bapicondx .
  types:
    tt_order_conditions_in  TYPE TABLE OF bapicond .
  types:
    tt_order_text           TYPE TABLE OF bapisdtext .
  types:
    tt_extension            TYPE TABLE OF bapiparex .
  types:
    tt_partner              TYPE TABLE OF bapiparnr .
  types:
    tt_ret                  TYPE TABLE OF bapiret2 .
  types:
    tt_schedule             TYPE TABLE OF bapischdl .
  types:
    tt_schedulex            TYPE TABLE OF bapischdlx .

  data GS_INPUT type ZSSD_ORDEM_INTERCOMPANY .
  data GS_T001W_ORIGEM type T001W .
  data GS_T001W_DESTINO type T001W .
  data GV_ORDER type BAPIVBELN-VBELN .
  data GT_RETURN type BAPIRET2_T .
  data GV_CONTINUAR type CHAR1 .
  data GS_T001W_RECEPTOR type T001W .

    "! Método para seleção dos dados
  methods GET_DATA .
    "! Método preenchimento dos itens da BAPI
    "! @parameter ET_ITEM        | Dados dos itens
    "! @parameter ET_ITEMX       | Flags dos itens
  methods FILL_ITEM
    exporting
      !ET_ITEM type TT_ORDER_ITEMS_IN
      !ET_ITEMX type TT_ORDER_ITEMS_INX .
    "! Método preenchimento da tabela Schedule da BAPI
    "! @parameter ET_SCHEDULES        | Dados do Schedule
    "! @parameter ET_SCHEDULESX       | Flags do Schedule
  methods FILL_SCHEDULES
    exporting
      !ET_SCHEDULES type TT_ORDER_SCHEDULES_IN
      !ET_SCHEDULESX type TT_ORDER_SCHEDULES_INX .
    "! Método preenchimento da tabela texto da BAPI
    "! @parameter ET_TEXT        | Dados do texto
  methods FILL_TEXT
    exporting
      !ET_TEXT type TT_ORDER_TEXT .
    "! Método preenchimento da tabela parceiro da BAPI
    "! @parameter ET_PARTNER        | Dados do parceiro
  methods FILL_PARTNER
    exporting
      !ET_PARTNER type TT_PARTNER .
    "! Método preenchimento do headar da BAPI
    "! @parameter ES_HEADER        | Dados do header
    "! @parameter ES_HEADERX       | Flags do header
  methods FILL_HEADER
    exporting
      !ES_HEADER type BAPISDHD1
      !ES_HEADERX type BAPISDHD1X .
    "! Método preenchimento do Extension da BAPI
    "! @parameter ET_EXTENSIONIN        | Dados do Extension
  methods EXTENSION
    exporting
      !ET_EXTENSIONIN type TT_EXTENSION .
    "! Método para realizar o commit
  methods BAPI_COMMIT .
    "! Método realizar a chamada da BAPI
  methods CALL_BAPI .
    "! Método seleção na tabela de parâmetro
    "! @parameter IV_CHAVE2        | Dados da chave 2
    "! @parameter IV_CHAVE3        | Dados da chave 3
    "! @parameter RV_RETURN        | valor do parâmentro
  methods GET_PARAMETRO
    importing
      !IV_CHAVE2 type ZE_PARAM_CHAVE
      !IV_CHAVE3 type ZE_PARAM_CHAVE
    returning
      value(RV_RETURN) type ZE_PARAM_LOW .
  methods VALIDA_CENTRO
    importing
      !IV_CENTRO1 type WERKS_D
      !IV_CENTRO2 type WERKS_D
      !IV_TP_OPERA type BSARK optional
    returning
      value(RV_MESMA_EMPRESA) type BOOLE_D .
ENDCLASS.



CLASS ZCLSD_CRIA_ORDEM_INTERCOMPANY IMPLEMENTATION.


  METHOD bapi_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      DESTINATION 'NONE'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD call_bapi.

    DATA: lv_doc    TYPE bapivbeln-vbeln,
          lt_return TYPE TABLE OF bapiret2.

    fill_header( IMPORTING es_header = DATA(ls_header) es_headerx = DATA(ls_headerx) ).

    fill_item( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).

    fill_partner( IMPORTING et_partner = DATA(lt_partner) ).

    fill_schedules( IMPORTING et_schedules = DATA(lt_schedules) et_schedulesx = DATA(lt_schedulesx) ).

    fill_text( IMPORTING et_text = DATA(lt_text) ).

    extension( IMPORTING et_extensionin = DATA(lt_extension) ).

    CALL FUNCTION 'ZFMSD_SALESORDER_CREATE_INTERC'
      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
      EXPORTING
        is_order_header_in     = ls_header
        is_order_header_inx    = ls_headerx
        iv_guid                = gs_input-guid
        iv_continuar           = gv_continuar
*      IMPORTING
*       ev_salesdocument       = gv_order
      TABLES
        et_return              = lt_return
        et_order_items_in      = lt_item
        et_order_items_inx     = lt_itemx
        et_order_partners      = lt_partner
        et_order_schedules_in  = lt_schedules
        et_order_schedules_inx = lt_schedulesx
        et_order_text          = lt_text
        et_extensionin         = lt_extension.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

*    CHECK gv_order IS NOT INITIAL.
*
*    UPDATE ztsd_intercompan SET salesorder = gv_order
*      WHERE guid = gs_input-guid.

*    bapi_commit(  ).

*    APPEND VALUE #(
*      type = 'S'
*      id = 'SUCESSO'
*      message = gv_order
*    ) TO gt_return.

  ENDMETHOD.


  METHOD execute.

    gs_input     = is_input.
    gv_continuar = is_continuar.

    get_data( ).

    call_bapi( ).

    rt_return[] = gt_return[].


  ENDMETHOD.


  METHOD extension.

*    IF gs_sirius-mt_criacao_ordem_venda-extensionin IS NOT INITIAL.
*
*      et_extensionin = VALUE #( BASE et_extensionin ( structure = gs_sirius-mt_criacao_ordem_venda-extensionin-structure ) ).
*
*    ENDIF.

    RETURN.

  ENDMETHOD.


  METHOD fill_header.

    DATA(lv_spart) = gs_t001w_origem-spart.

    IF gs_input-tipo_operacao = 'INT7'. "Grão verde
      lv_spart = get_parametro( iv_chave2 = 'SPART_GRAO' iv_chave3 = CONV ze_param_chave( gs_input-tipo_operacao ) ).
    ENDIF.

    IF gv_continuar IS NOT INITIAL. "segunda etapa
      SELECT SINGLE inco2, inco2_l
        INTO @DATA(ls_knvv)
      FROM knvv
      WHERE kunnr = @gs_t001w_receptor-kunnr AND
            vkorg = @gs_t001w_destino-vkorg AND
            vtweg = @gs_t001w_destino-vtweg AND
            spart = @gs_t001w_destino-spart.
      IF sy-subrc EQ 0.
        IF NOT ls_knvv-inco2 IS INITIAL.
          DATA(lv_inco2) = ls_knvv-inco2.
        ELSEIF NOT ls_knvv-inco2_l IS INITIAL.
          lv_inco2 = ls_knvv-inco2_l.
        ENDIF.
      ENDIF.
      es_header = VALUE bapisdhd1(  doc_type    = get_parametro( iv_chave2 = 'DOC_TYPE' iv_chave3 = CONV ze_param_chave( gs_input-tipo_operacao ) )
                                    sales_org   = gs_t001w_destino-vkorg
                                    distr_chan  = gs_t001w_destino-vtweg
                                    division    = gs_t001w_destino-spart
*                                    incoterms1  = get_parametro( iv_chave2 = CONV ze_param_chave( gs_input-modalidade_frete ) iv_chave3 = CONV ze_param_chave( gs_input-tipo_frota ) )
                                    incoterms1  = get_parametro( iv_chave2 = 'INCO' iv_chave3 = CONV ze_param_chave( gs_input-modalidade_frete ) )
                                    incoterms2  = lv_inco2
                                    ship_cond   = gs_input-cond_exped
                                    ship_type   = gs_input-tipo_exped
                                    po_method   = gs_input-tipo_operacao
                                    purch_date  = sy-datlo
                                    purch_no_c  = '0000000000'
                                    pymt_meth   = get_parametro( iv_chave2 = 'PYMT_METH' iv_chave3 = CONV #( gs_input-tipo_operacao ) )
                                 ).
    ELSE.
      SELECT SINGLE inco2, inco2_l
        INTO @ls_knvv
      FROM knvv
      WHERE kunnr = @gs_t001w_destino-kunnr AND
            vkorg = @gs_t001w_origem-vkorg AND
            vtweg = @gs_t001w_origem-vtweg AND
            spart = @gs_t001w_origem-spart.
      IF sy-subrc EQ 0.
        IF NOT ls_knvv-inco2 IS INITIAL.
          lv_inco2 = ls_knvv-inco2.
        ELSEIF NOT ls_knvv-inco2_l IS INITIAL.
          lv_inco2 = ls_knvv-inco2_l.
        ENDIF.
      ENDIF.

      es_header = VALUE bapisdhd1(  doc_type    = get_parametro( iv_chave2 = 'DOC_TYPE' iv_chave3 = CONV ze_param_chave( gs_input-tipo_operacao ) )
                                    sales_org   = gs_t001w_origem-vkorg
                                    distr_chan  = gs_t001w_origem-vtweg
                                    division    = lv_spart
*                                    incoterms1  = get_parametro( iv_chave2 = CONV ze_param_chave( gs_input-modalidade_frete ) iv_chave3 = CONV ze_param_chave( gs_input-tipo_frota ) )
                                    incoterms1  = get_parametro( iv_chave2 = 'INCO' iv_chave3 = CONV ze_param_chave( gs_input-modalidade_frete ) )
                                    incoterms2  = lv_inco2
                                    ship_cond   = gs_input-cond_exped
                                    ship_type   = gs_input-tipo_exped
                                    po_method   = gs_input-tipo_operacao
                                    purch_date  = sy-datlo
                                    purch_no_c  = '0000000000'
                                    pymt_meth   = get_parametro( iv_chave2 = 'PYMT_METH' iv_chave3 = CONV #( gs_input-tipo_operacao ) )
                                    dlvschduse  = COND #( WHEN gs_input-tipo_operacao = 'INT7' THEN gs_input-abrvw )
                                 ).
    ENDIF.

    es_headerx = VALUE bapisdhd1x( doc_type   = abap_true
                                   sales_org  = abap_true
                                   distr_chan = abap_true
                                   division   = abap_true
                                   incoterms1 = abap_true
                                   incoterms2 = abap_true
                                   ship_cond  = abap_true
                                   ship_type  = abap_true
                                   po_method  = abap_true
                                   purch_date = abap_true
                                   purch_no_c = abap_true
                                   pymt_meth  = abap_true
                                   dlvschduse = COND #( WHEN es_header-dlvschduse IS NOT INITIAL THEN abap_true ) ).

  ENDMETHOD.


  METHOD fill_item.

    DATA lv_itm_number TYPE n LENGTH 6.

    IF gv_continuar IS INITIAL.
      LOOP AT gs_input-itens ASSIGNING FIELD-SYMBOL(<fs_item>).

        ADD 10 TO lv_itm_number.

        et_item = VALUE #( BASE et_item ( itm_number = lv_itm_number
                                          material   = <fs_item>-material
                                          plant      = gs_input-centro_fornecedor
                                          target_qty = <fs_item>-quantidade
                                          target_qu  = <fs_item>-unidade
                                          sales_unit = <fs_item>-unidade
                                          store_loc  = gs_input-deposito_origem ) ).

        et_itemx = VALUE #( BASE et_itemx ( itm_number = lv_itm_number
                                            material   = abap_true
                                            plant      = abap_true
                                            target_qty = abap_true
                                            target_qu  = abap_true
                                            sales_unit = abap_true
                                            store_loc  = abap_true ) ).

      ENDLOOP.
    ELSE.
      "Segunda etapa proceso com duas etapas
      IF NOT gs_input-guid IS INITIAL.
*        Copia dados da ov original
        SELECT SINGLE salesorder
               INTO @DATA(lv_ov)
        FROM ztsd_intercompan
        WHERE guid = @gs_input-guid.

        IF NOT lv_ov IS INITIAL.
          SELECT vbeln,
                 posnr,
                 matnr,
                 werks,
                 kwmeng,
                 vrkme,
                 meins
            FROM vbap
            WHERE vbeln EQ @lv_ov
            ORDER BY PRIMARY KEY
            INTO TABLE @DATA(lt_vbap).

          LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_item2>).
            et_item = VALUE #( BASE et_item (  itm_number = <fs_item2>-posnr
                                               material   = <fs_item2>-matnr
                                               plant      = gs_input-centro_destino
                                               target_qty = <fs_item2>-kwmeng
                                               target_qu  = <fs_item2>-vrkme
                                               sales_unit = <fs_item2>-vrkme
*                                               store_loc  = gs_input-deposito_destino ) ).
                                               store_loc  = COND #( WHEN valida_centro( iv_centro1  = gs_input-centro_destino
                                                                                        iv_centro2  = gs_input-centro_receptor
                                                                                        iv_tp_opera = gs_input-tipo_operacao ) IS NOT INITIAL
                                                                      THEN gs_input-deposito_destino
                                                                    ELSE gs_input-deposito_origem ) ) ).

            et_itemx = VALUE #( BASE et_itemx ( itm_number = <fs_item2>-posnr
                                                 material   = abap_true
                                                 plant      = abap_true
                                                 target_qty = abap_true
                                                 target_qu  = abap_true
                                                 sales_unit = abap_true
                                                 store_loc  = abap_true ) ).
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD fill_partner.

    DATA: lv_dep_fechado TYPE char1.

    IF gv_continuar IS NOT INITIAL.
      et_partner = VALUE #( BASE et_partner ( partn_role = 'AG'
                                              partn_numb = gs_t001w_receptor-kunnr
                                              itm_number = '000000' ) ).
    ELSE.
      IF gs_t001w_destino IS NOT INITIAL.
        et_partner = VALUE #( BASE et_partner ( partn_role = 'AG'
                                                partn_numb = gs_t001w_destino-kunnr ) ).
        CASE gs_input-tipo_operacao.
*          WHEN 'INT3' OR 'INT4'.
*            IF gs_t001w_receptor IS NOT INITIAL.
*              et_partner = VALUE #( BASE et_partner ( partn_role = 'WE'
*                                                      partn_numb = gs_t001w_receptor-kunnr ) ).
*            ENDIF.

          WHEN 'INT2'.
            IF gs_t001w_receptor-kunnr IS NOT INITIAL.
              et_partner = VALUE #( BASE et_partner ( partn_role = 'ZD'
                                                      partn_numb = gs_t001w_receptor-kunnr ) ).
            ENDIF.

          WHEN OTHERS.
        ENDCASE.
      ENDIF.

      IF lv_dep_fechado IS NOT INITIAL.
        et_partner = VALUE #( BASE et_partner ( partn_role = 'ZR'
                                                partn_numb = gs_t001w_origem-kunnr
                                                itm_number = '000000' ) ).
      ENDIF.

    ENDIF.

    IF gs_input-agente_frete IS NOT INITIAL.
      et_partner = VALUE #( BASE et_partner ( partn_role = 'SP'
                                              partn_numb = gs_input-agente_frete
                                              itm_number = '000000' ) ).
    ENDIF.

    IF gs_input-motorista IS NOT INITIAL.
      et_partner = VALUE #( BASE et_partner ( partn_role = 'YM'
                                              partn_numb = gs_input-motorista
                                              itm_number = '000000' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_schedules.

    DATA lv_itm_number TYPE n LENGTH 6.
    IF gv_continuar IS INITIAL.
      LOOP AT gs_input-itens ASSIGNING FIELD-SYMBOL(<fs_schedules>).

        ADD 10 TO lv_itm_number.

        et_schedules = VALUE #( BASE et_schedules ( itm_number = lv_itm_number
                                                    sched_line = '0001'
                                                    req_qty    = <fs_schedules>-quantidade ) ).

        et_schedulesx = VALUE #( BASE et_schedulesx ( itm_number  = lv_itm_number
                                                      sched_line  = abap_true
                                                      req_qty     = abap_true ) ).
      ENDLOOP.

    ELSE.
      "Segunda etapa proceso com duas etapas
      IF NOT gs_input-guid IS INITIAL.
*        Copia dados da ov original
        SELECT SINGLE salesorder
               INTO @DATA(lv_ov)
        FROM ztsd_intercompan
        WHERE guid = @gs_input-guid.

        IF NOT lv_ov IS INITIAL.
          SELECT vbeln,
                 posnr,
                 kwmeng,
                 vrkme
          FROM vbap
            WHERE vbeln EQ @lv_ov
            ORDER BY PRIMARY KEY
            INTO TABLE @DATA(lt_vbap).

          LOOP AT lt_vbap ASSIGNING FIELD-SYMBOL(<fs_item2>).
            et_schedules = VALUE #( BASE et_schedules ( itm_number = <fs_item2>-posnr
                                                        sched_line = '0001'
                                                        req_qty    = <fs_item2>-kwmeng ) ).

            et_schedulesx = VALUE #( BASE et_schedulesx ( itm_number  = <fs_item2>-posnr
                                                          sched_line  = abap_true
                                                          req_qty     = abap_true ) ).
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD fill_text.

    LOOP AT  gs_input-texto_nfe ASSIGNING FIELD-SYMBOL(<fs_text>).

      et_text = VALUE #( BASE et_text ( itm_number = '000000'
                                        text_id = 'Z001'
                                        langu = sy-langu
                                        text_line = <fs_text>-line ) ).

    ENDLOOP.

    LOOP AT  gs_input-texto_geral ASSIGNING <fs_text>.

*      et_text = VALUE #( BASE et_text ( itm_number = '000000'
*                                        text_id = 'Z002'
*                                        langu = sy-langu
*                                        text_line = <fs_text>-line ) ).
       et_text = VALUE #( BASE et_text ( itm_number = '000000'
                                         text_id = 'Z012'
                                         langu = sy-langu
                                         text_line = <fs_text>-line ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD get_data.

    IF gs_input-centro_fornecedor IS NOT INITIAL.
      SELECT SINGLE werks,
                    vtweg,
                    spart,
                    vkorg,
                    kunnr
        FROM t001w
       WHERE werks = @gs_input-centro_fornecedor
        INTO CORRESPONDING FIELDS OF @gs_t001w_origem.

      IF sy-subrc IS NOT INITIAL.
        CLEAR: gs_t001w_origem.
      ENDIF.
    ENDIF.

    IF gs_input-centro_receptor IS NOT INITIAL.
      SELECT SINGLE werks,
                    vtweg,
                    spart,
                    vkorg,
                    kunnr
        FROM t001w
       WHERE werks = @gs_input-centro_receptor
        INTO CORRESPONDING FIELDS OF @gs_t001w_receptor.

      IF sy-subrc IS NOT INITIAL.
        CLEAR: gs_t001w_receptor.
      ENDIF.
    ENDIF.

    IF gs_input-centro_destino IS NOT INITIAL.
      SELECT SINGLE werks,
                    vtweg,
                    spart,
                    vkorg,
                    kunnr
        FROM t001w
       WHERE werks = @gs_input-centro_destino
        INTO CORRESPONDING FIELDS OF @gs_t001w_destino.

      IF sy-subrc IS NOT INITIAL.
        CLEAR: gs_t001w_destino.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_parametro.

    SELECT SINGLE low
      INTO rv_return
      FROM ztca_param_val
      WHERE modulo = 'SD'
        AND chave1 = 'ADM_INTER'
        AND chave2 = iv_chave2
        AND chave3 = iv_chave3.

  ENDMETHOD.


  METHOD task_finish.

    DATA: lv_doc    TYPE bapivbeln-vbeln,
          lt_return TYPE TABLE OF bapiret2.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_SALESORDER_CREATE_INTERC'
      IMPORTING
        ev_salesdocument       = gv_order
      TABLES
        et_return              = gt_return.

    RETURN.

  ENDMETHOD.


  METHOD valida_centro.

    CHECK iv_tp_opera EQ 'INT4'.

*   Método para Validar se dois Centros são da mesma Empresa
    SELECT SINGLE t001k~bukrs BYPASSING BUFFER
      FROM t001w
      INNER JOIN t001k
         ON t001k~bwkey = t001w~bwkey
      INTO @DATA(lv_bukrs1)
      WHERE werks = @iv_centro1.

    SELECT SINGLE t001k~bukrs BYPASSING BUFFER
      FROM t001w
      INNER JOIN t001k
         ON t001k~bwkey = t001w~bwkey
      INTO @DATA(lv_bukrs2)
      WHERE werks = @iv_centro2.

    IF lv_bukrs1 = lv_bukrs2.
      rv_mesma_empresa = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
