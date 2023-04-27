CLASS zclsd_criacao_ord_compl_impost DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types referência  para o campo documento de vendas
      ty_auart TYPE RANGE OF auart .


    TYPES:
      "! Types referência  para campo data
      ty_data TYPE RANGE OF erdat .

    TYPES:
      "! Types do item da ordem de vendas
      BEGIN OF ty_vbap,
        vbeln TYPE vbap-vbeln,
        posnr TYPE vbap-posnr,
        matnr TYPE vbap-matnr,
        werks TYPE vbap-werks,
        lgort TYPE vbap-lgort,
      END OF ty_vbap.

    DATA gt_vbap TYPE TABLE OF ty_vbap.

    "! Método principal para a seleção  principal
    "! @parameter IV_ERDAT  | Variavel data para seleção principal
    "! @parameter IV_AUART  | Variavel Doc de vendas para seleção principal
    "! @parameter ET_RETURN | Retorno do log da BAPI
    METHODS process
      IMPORTING
        !iv_erdat  TYPE ty_data
        !iv_auart  TYPE ty_auart
      EXPORTING
        !et_return TYPE bapiret2_tab .

    "! Método de retorno de logs da BAPI
    "! @parameter IT_RETURN |Tabela para retorno no log da BAPI
    METHODS log_process
      IMPORTING
        !it_return TYPE bapiret2_tab .
protected section.
private section.

  "!Variavel global/ armazenbar ordem gerada pela bapi
  data GV_ORDEM type BAPIVBELN-VBELN .
  "!Estrutura global do cabeçalho para passar na BAPI
  data GS_HEADER_IN type BAPISDHD1 .
  "!Estrutura global do cabeçalho para passar na BAPI
  data GS_HEADER_INX type BAPISDHD1X .
  "!Variavel global Documento de vendas
  data GV_VBELN type BAPIVBELN-VBELN .
  data:
    "!Tabela global de itens para passar na bapi
    gt_order_items TYPE TABLE OF bapisditm .
  data:
    "!Tabela global de itens para passar na bapi
    gt_order_itemsx TYPE STANDARD TABLE OF  bapisditmx .
  data:
   "!Tabela global de parceiros para passar na bapi
    gt_order_partners  TYPE STANDARD TABLE OF  bapiparnr .
  data:
    "!Tabela global de condição para passar na bapi
    gt_order_conditions_in  TYPE STANDARD TABLE OF  bapicond .
  data:
    "!Tabela global de condição para passar na bapi
    gt_order_conditions_inx TYPE STANDARD TABLE OF  bapicondx .
  data:
    "!Tabela global de texto SD para passar na bapi
    gt_text TYPE STANDARD TABLE OF bapisdtext .
  data:
     "!Tabela global de retorno de log da BAPI
    gt_return TYPE STANDARD TABLE OF bapiret2 .

  "!Método seleção de cabeçalho
  methods FILL_HEADER .
  "!Método seleçao dos itens
  methods FILL_ITEMS
    importing
      !IV_VBELN type VBAK-VBELN .
  "!Método seleção dos parceiros
  methods FILL_PARTNER .
  "! "!Método seleção das condições  da ordem
  "! @parameter IV_SOMA_ICMS | Variavel de armazenamento da soma do select principal
  methods FILL_CONDITIONS
    importing
      !IV_SOMA_ICMS type CHAR20 optional .
  "!Método seleção dos textos SD
  methods FILL_TEXT .
  "!Método seleção de execução da BAPI
  methods FILL_BAPI .
  "!Método para limpar as variaveis
  methods FILL_CLEAR .
ENDCLASS.



CLASS ZCLSD_CRIACAO_ORD_COMPL_IMPOST IMPLEMENTATION.


  METHOD fill_header.

    CONSTANTS: lc_x      TYPE char1 VALUE 'X',
               lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
               lc_chave2 TYPE ztca_param_par-chave2 VALUE 'TP_OV_COMPL'.
    DATA: lr_param  TYPE RANGE OF bwart,
          lv_minimo TYPE char50.
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
          IMPORTING
            et_range  = lr_param ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.


    DATA(ls_vbrk) = VALUE vbrk( vbeln = gv_vbeln ).

    READ TABLE lr_param ASSIGNING FIELD-SYMBOL(<fs_param>) INDEX 1.
    IF sy-subrc IS INITIAL.

      lv_minimo = <fs_param>-low.
      gs_header_in-doc_type = lv_minimo.

    ENDIF.
    gs_header_in-ref_doc     = gv_vbeln.
    gs_header_in-refdoc_cat  = 'M'.
    gs_header_in-sales_org   = ls_vbrk-vkorg.
    gs_header_in-distr_chan  = ls_vbrk-vtweg.
    gs_header_inx-doc_type   = lc_x .
    gs_header_inx-ref_doc    = lc_x .
    gs_header_inx-refdoc_cat = lc_x .
    gs_header_inx-sales_org  = lc_x .
    gs_header_inx-distr_chan = lc_x .


  ENDMETHOD.


  METHOD process.

    CONSTANTS: lc_fatura  TYPE vbfa-vbtyp_n VALUE 'M',
               lc_ordem   TYPE vbfa-vbtyp_v VALUE 'C',
               lc_remessa TYPE vbfa-vbtyp_n VALUE 'J'.


    fill_clear( ).

    SELECT vbeln, zz1_soma_icms
      FROM vbak
      WHERE erdat IN @iv_erdat
        AND auart IN @iv_auart
       AND zz1_soma_icms NE @space
    INTO TABLE @DATA(lt_vbak).

    IF lt_vbak IS NOT INITIAL.
      SELECT vbeln, posnr, matnr, werks, lgort
      FROM vbap
        FOR ALL ENTRIES IN @lt_vbak
      WHERE vbeln EQ @lt_vbak-vbeln
        AND erdat IN @iv_erdat
        AND kzwi4 IS NOT NULL
      INTO TABLE @gt_vbap.

      SORT gt_vbap BY vbeln.
*      DELETE ADJACENT DUPLICATES FROM gt_vbap.
    ENDIF.

    IF sy-subrc EQ 0.

      LOOP AT lt_vbak ASSIGNING FIELD-SYMBOL(<fs_vbak>).

        DATA(ls_doc) = VALUE vbfa( vbelv   = <fs_vbak>-vbeln
                                   vbtyp_v = lc_ordem
                                   vbtyp_n = lc_remessa ).

        IF ls_doc-vbeln IS NOT INITIAL.

          DATA(ls_docv) = VALUE vbfa( vbelv   = ls_doc-vbeln
                                      vbtyp_v = lc_remessa
                                      vbtyp_n = lc_fatura ).
          gv_vbeln = ls_docv-vbeln.
        ENDIF.

        IF ls_docv-vbeln IS NOT INITIAL.
          DATA(ls_vbfa) = VALUE vbfa( vbelv   = ls_docv-vbeln
                                      vbtyp_v = lc_fatura
                                      vbtyp_n = lc_ordem ).
        ENDIF.

        IF sy-subrc NE 0.

          fill_header( ).
          fill_items( iv_vbeln = <fs_vbak>-vbeln ).
          fill_partner( ).
          fill_conditions( ).
          fill_text( ).
          fill_bapi( ).
          et_return = gt_return.

        ELSE.

* Se encontrar registro no ultimo select prosseguir
        ENDIF.

      ENDLOOP.
    ENDIF.


  ENDMETHOD.


  METHOD fill_bapi.
    CONSTANTS: lc_e TYPE char1 VALUE 'E'.


    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in      = gs_header_in
        order_header_inx     = gs_header_inx
      IMPORTING
        salesdocument        = gv_ordem
      TABLES
        return               = gt_return
        order_items_in       = gt_order_items
        order_items_inx      = gt_order_itemsx
        order_partners       = gt_order_partners
        order_conditions_in  = gt_order_conditions_in
        order_conditions_inx = gt_order_conditions_inx
        order_text           = gt_text.

    SORT gt_return BY type.
    READ  TABLE gt_return TRANSPORTING NO FIELDS WITH KEY type = lc_e BINARY SEARCH.
    IF sy-subrc IS INITIAL.
      ROLLBACK WORK.
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD fill_clear.

    CLEAR :   gv_ordem,
              gs_header_in,
              gs_header_inx,
              gv_vbeln,
              gt_order_items,
              gt_order_itemsx,
              gt_order_partners,
              gt_order_conditions_in,
              gt_order_conditions_inx,
              gt_text,
              gt_return.

  ENDMETHOD.


  METHOD fill_conditions.
    CONSTANTS: lc_itm_number TYPE  bapicond-itm_number VALUE '000010',
               lc_x          TYPE char1 VALUE 'X',
               lc_modulo     TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1     TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
               lc_chave2     TYPE ztca_param_par-chave2 VALUE 'COND_ICS3'.

    DATA: lr_param  TYPE RANGE OF bwart,
          lv_minimo TYPE char50.
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_modulo
            iv_chave1 = lc_chave1
            iv_chave2 = lc_chave2
          IMPORTING
            et_range  = lr_param ).
      CATCH zcxca_tabela_parametros.
        "handle exception
    ENDTRY.

    READ TABLE lr_param ASSIGNING FIELD-SYMBOL(<fs_param>) INDEX 1.
    IF sy-subrc IS INITIAL.

      lv_minimo = <fs_param>-low.

    ENDIF.

    APPEND VALUE #( itm_number = lc_itm_number cond_type = lv_minimo cond_value = iv_soma_icms ) TO gt_order_conditions_in.
    APPEND VALUE #( itm_number = lc_itm_number cond_type = lc_x cond_value = lc_x ) TO gt_order_conditions_inx.

  ENDMETHOD.


  METHOD fill_items.
    CONSTANTS: lc_itm_number TYPE bapisditm-itm_number VALUE '000010',
               lc_x          TYPE char1 VALUE 'X',
               lc_modulo     TYPE ztca_param_mod-modulo VALUE 'SD',
               lc_chave1     TYPE ztca_param_par-chave1 VALUE 'ADM DEVOLUÇÃO',
               lc_chave2     TYPE ztca_param_par-chave2 VALUE 'MATERIAL_COMPL'.

    DATA: lr_param  TYPE RANGE OF bwart,
          lv_minimo TYPE char50.
    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

*    TRY.
*        lo_parametros->m_get_range(
*          EXPORTING
*            iv_modulo = lc_modulo
*            iv_chave1 = lc_chave1
*            iv_chave2 = lc_chave2
*          IMPORTING
*            et_range  = lr_param ).
*      CATCH zcxca_tabela_parametros.
*        "handle exception
*    ENDTRY.
*
*
*    DATA(ls_vbrp) = VALUE vbrp( vbeln = gv_vbeln ).
*
*    READ TABLE lr_param ASSIGNING FIELD-SYMBOL(<fs_param>) INDEX 1.
*    IF sy-subrc IS INITIAL.
*
*      lv_minimo = <fs_param>-low.
*
*    ENDIF.
*
*    APPEND VALUE #( itm_number = lc_itm_number material = lv_minimo plant = ls_vbrp-werks store_loc = ls_vbrp-lgort
*                target_qty = '1' target_qu = 'UN' ) TO gt_order_items.
*
*    APPEND VALUE #( itm_number = lc_itm_number material = lc_x plant = lc_x store_loc = lc_x
*                    target_qty = lc_x target_qu = lc_x ) TO gt_order_itemsx.
    READ TABLE gt_vbap WITH KEY vbeln = iv_vbeln  TRANSPORTING NO FIELDS BINARY SEARCH.
    IF sy-subrc = 0.
      LOOP AT gt_vbap ASSIGNING FIELD-SYMBOL(<fs_vbap>) FROM sy-tabix.
        IF <fs_vbap>-vbeln = iv_vbeln.

          APPEND VALUE #( itm_number = <fs_vbap>-posnr material = <fs_vbap>-matnr plant = <fs_vbap>-werks store_loc = <fs_vbap>-lgort
                          target_qty = '1' target_qu = 'UN' ) TO gt_order_items.

          APPEND VALUE #( itm_number = <fs_vbap>-posnr material = lc_x plant = lc_x store_loc = lc_x
                          target_qty = lc_x target_qu = lc_x ) TO gt_order_itemsx.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD fill_partner.

    DATA(ls_vbrp) = VALUE vbrp( vbeln = gv_vbeln ).

    APPEND VALUE #( partn_role = 'PC' partn_numb = ls_vbrp-kunag_ana ) TO gt_order_partners.

  ENDMETHOD.


  METHOD fill_text.
    CONSTANTS : lc_id TYPE bapisdtext-text_id VALUE 'Z001'.

    DATA(ls_vbrk) = VALUE vbrk( vbeln = gv_vbeln ).

    APPEND VALUE #( text_id = lc_id langu = 'PT' langu_iso = 'PT' text_line = |{ TEXT-001 }{ ls_vbrk-xblnr }| ) TO gt_text.

  ENDMETHOD.


  METHOD log_process.
        DATA: lo_salv  TYPE REF TO cl_salv_table.

    TRY.

        cl_salv_table=>factory(
        EXPORTING
          list_display = abap_true
        IMPORTING
          r_salv_table = lo_salv
        CHANGING
          t_table = gt_return ).

        lo_salv->display( ).

      CATCH cx_salv_msg.                                "#EC NO_HANDLER
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
