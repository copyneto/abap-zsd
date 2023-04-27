class ZCLSD_NFCE_SSRESTO definition
  public
  final
  create public .

public section.

  constants GC_PAR_COND_TYPE type ZE_PARAM_CHAVE value 'COND_TYPE' ##NO_TEXT.
  constants GC_PAR_TP_PEDIDO type ZE_PARAM_CHAVE value 'PO_METHOD' ##NO_TEXT.
  constants GC_PAR_TP_OV type ZE_PARAM_CHAVE value 'DOC_TYPE' ##NO_TEXT.
  constants GC_PAR_ORG_OV type ZE_PARAM_CHAVE value 'SALES_ORG' ##NO_TEXT.
  constants GC_PAR_CANAL_DISTRIBUICAO type ZE_PARAM_CHAVE value 'DISTR_CHAN' ##NO_TEXT.
  constants GC_PAR_SETOR_ATIVIDADE type ZE_PARAM_CHAVE value 'DIVISION' ##NO_TEXT.
  constants GC_STATUS_AUTORIZADO type CHAR2 value 'A' ##NO_TEXT.
  constants GC_STATUS_CANCELADO type CHAR2 value 'C' ##NO_TEXT.
  constants GC_FLAG_INSERT_BAPI type UPDKZ_D value 'I' ##NO_TEXT.
  constants GC_PO_METHOD type BSARK value 'REST' ##NO_TEXT.
  constants GC_MODULO type ZE_PARAM_MODULO value 'SD' ##NO_TEXT.
  constants GC_PAR_PARTNER type ZE_PARAM_CHAVE value 'PARTN_NUMB' ##NO_TEXT.
  constants GC_PAR_PARTNER_ROLE type ZE_PARAM_CHAVE value 'PARTN_ROLE' ##NO_TEXT.
  constants GC_PAR_CHAVE type ZE_PARAM_CHAVE value 'SSRESTO' ##NO_TEXT.
  constants GC_NMTB_HEADER type CHAR20 value 'ZTSD_CAFT_VEND_H' ##NO_TEXT.
  constants GC_NMTB_ITEM type CHAR20 value 'ZTSD_CAFT_VEND_I' ##NO_TEXT.
  constants GC_NMTB_PAG type CHAR20 value 'ZTSD_CAFT_VEND_P' ##NO_TEXT.
  constants GC_NMTB_CUPOM_OV type CHAR20 value 'ZTSD_CAFT_CUP_OV' ##NO_TEXT.
  constants GC_NMTB_PARAMETRO type CHAR20 value 'ZTCA_PARAM_VAL' ##NO_TEXT.

  methods PROCESSA_INTERFACE_NFCE_PUT
    importing
      !IS_INPUT type ZCLSD_MT_CRIAR_NFCE
    raising
      ZCXSD_NFCE_SSRESTO .
protected section.
private section.

  data GS_INTERFACE type ZCLSD_MT_CRIAR_NFCE .
  data GS_HEADER type ZTSD_CAFT_VEND_H .
  data GS_CUPOM type ZTSD_CAFT_CUP_OV .
  data:
    gt_item TYPE STANDARD TABLE OF ztsd_caft_vend_i .
  data:
    gt_pagamento TYPE STANDARD TABLE OF ztsd_caft_vend_p .

  methods PUT_HEADER
    raising
      ZCXSD_NFCE_SSRESTO .
  methods PUT_ITEM
    raising
      ZCXSD_NFCE_SSRESTO .
  methods PUT_PAGAMENTO
    raising
      ZCXSD_NFCE_SSRESTO .
  methods CREATE_OV
    raising
      ZCXSD_NFCE_SSRESTO .
  methods SET_VARIAVEL
    importing
      !IS_INPUT type ZCLSD_MT_CRIAR_NFCE .
  methods PUT_CUPOM_OV
    importing
      !IV_OV type VBELN_VA
    raising
      ZCXSD_NFCE_SSRESTO .
  methods CLEAR_VARIAVEL .
  methods SAVE_DATA
    raising
      ZCXSD_NFCE_SSRESTO .
ENDCLASS.



CLASS ZCLSD_NFCE_SSRESTO IMPLEMENTATION.


  METHOD clear_variavel.
    CLEAR: gs_header,
           gs_cupom,
           gt_item,
           gt_pagamento,
           gs_interface.
  ENDMETHOD.


  METHOD create_ov.

    "Tabelas internas
    DATA: lt_order_items_in       TYPE STANDARD TABLE OF bapisditm,
          lt_order_items_inx      TYPE STANDARD TABLE OF bapisditmx,
          lt_order_partners       TYPE STANDARD TABLE OF bapiparnr,
          lt_order_schedules_in   TYPE STANDARD TABLE OF bapischdl,
          lt_order_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
          lt_order_conditions_in  TYPE STANDARD TABLE OF bapicond,
          lt_order_conditions_inx TYPE STANDARD TABLE OF bapicondx,
          lt_return               TYPE STANDARD TABLE OF bapiret2,
          lt_parameter            TYPE RANGE OF ze_param_high.

    DATA: ls_order_header_in  TYPE bapisdhd1,
          ls_order_header_inx TYPE bapisdhd1x,
          lv_sales_document   TYPE bapivbeln-vbeln,
          lv_partner          TYPE kunnr,
          lv_role             TYPE parvw,
          lv_cond_type        TYPE kscha.

    DATA(lo_tabela_parametros) = NEW zclca_tabela_parametros( ).

    "Montando os dados de cabeçalho da ordem de venda"

    "Tipo de ordem de venda
    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_tp_ov
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          ls_order_header_in-doc_type = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_tp_ov )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

    " Tipo de pedido
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_tp_pedido
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          ls_order_header_in-po_method = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_tp_pedido )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.


    "Organização de venda
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_org_ov
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          ls_order_header_in-sales_org = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_org_ov )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

    "Canal de distribuicao
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_canal_distribuicao
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          ls_order_header_in-distr_chan = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_canal_distribuicao )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

    "Canal de distribuicao
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_setor_atividade
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          ls_order_header_in-division = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_setor_atividade )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.


    "Role do Parceiro
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_partner_role
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          lv_role = lt_parameter[ 1 ]-low.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_partner_role )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

    "Parceiro
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_partner
            iv_chave3 = CONV ze_param_chave_3( gs_header-werks )
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          lv_partner = lt_parameter[ 1 ]-low.
          UNPACK lv_partner TO lv_partner.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_partner )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

    "Tipo de condição de pagamento
    TRY.
        CLEAR lt_parameter.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_modulo
            iv_chave1 = gc_par_chave
            iv_chave2 = gc_par_cond_type
          IMPORTING
            et_range  = lt_parameter
        ).
        IF lt_parameter IS NOT INITIAL.
          lv_cond_type = lt_parameter[ 1 ]-low.
          UNPACK lv_partner TO lv_partner.
        ENDIF.
      CATCH zcxca_tabela_parametros.
        ROLLBACK WORK.
        "Paramento não localizado
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>parameter_not_found
            gv_msgv1 = CONV msgv1( gc_par_cond_type )
            gv_msgv2 = CONV msgv2( gc_nmtb_parametro )
            gv_msgv3 = CONV msgv3( gs_header-numcf )
            gv_msgv4 = CONV msgv4( gs_header-numserie ).

    ENDTRY.

*    READ TABLE gt_pagamento ASSIGNING FIELD-SYMBOL(<fs_pag>) INDEX 1.
*    IF <fs_pag> IS ASSIGNED.
*      ls_order_header_in-pymt_meth      =  <fs_pag>-tipopag.
*    ENDIF.

    ls_order_header_in-purch_no_c       = gs_header-numcf.
    ls_order_header_in-purch_date       = gs_header-ausdat.
    ls_order_header_in-req_date_h       = gs_header-ausdat.
    ls_order_header_in-price_date       = gs_header-ausdat.

    ls_order_header_inx-updateflag      = gc_flag_insert_bapi.
    ls_order_header_inx-doc_type        = abap_true.
    ls_order_header_inx-sales_org       = abap_true.
    ls_order_header_inx-distr_chan      = abap_true.
    ls_order_header_inx-division        = abap_true.
    ls_order_header_inx-purch_date      = abap_true.
    ls_order_header_inx-req_date_h      = abap_true.
    ls_order_header_inx-price_date      = abap_true.
    ls_order_header_inx-po_method       = abap_true.
    ls_order_header_inx-purch_no_c      = abap_true.
*    ls_order_header_inx-pymt_meth       = abap_true.

    lt_order_partners = VALUE #(
                                 ( partn_role = lv_role partn_numb = lv_partner )
                               ).

    "Montando os dados de item da ordem de venda
    LOOP AT gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      APPEND INITIAL LINE TO lt_order_items_in ASSIGNING FIELD-SYMBOL(<fs_s_order_items_in>).

      <fs_s_order_items_in>-itm_number = <fs_item>-posnr.
      <fs_s_order_items_in>-material   = <fs_item>-matnr.
      <fs_s_order_items_in>-target_qty = <fs_item>-zmeng.
      <fs_s_order_items_in>-plant      = <fs_item>-werks.
      <fs_s_order_items_in>-item_categ = <fs_item>-pstyv.
      <fs_s_order_items_in>-hg_lv_item = <fs_item>-uepos.


      APPEND INITIAL LINE TO lt_order_items_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_items_inx>).

      <fs_s_order_items_inx>-updateflag = gc_flag_insert_bapi.
      <fs_s_order_items_inx>-itm_number = <fs_item>-posnr.
      <fs_s_order_items_inx>-material   = abap_true.
      <fs_s_order_items_inx>-target_qty = abap_true.
      <fs_s_order_items_inx>-plant      = abap_true.
      <fs_s_order_items_inx>-item_categ = abap_true.
      <fs_s_order_items_inx>-hg_lv_item = abap_true.


      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = <fs_s_order_items_in>-material
        IMPORTING
          output = <fs_s_order_items_in>-material.

      "Montando os dados de divisão da remessa da ordem de venda
      APPEND INITIAL LINE TO lt_order_schedules_in ASSIGNING FIELD-SYMBOL(<fs_s_order_schedules_in>).

      <fs_s_order_schedules_in>-itm_number = <fs_item>-posnr.
      <fs_s_order_schedules_in>-sched_line = '1'.
      <fs_s_order_schedules_in>-req_qty    = <fs_item>-zmeng.

      APPEND INITIAL LINE TO lt_order_schedules_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_schedules_inx>).

      <fs_s_order_schedules_inx>-itm_number = <fs_item>-posnr.
      <fs_s_order_schedules_inx>-updateflag = abap_true.
      <fs_s_order_schedules_inx>-sched_line = '0001'.
      <fs_s_order_schedules_inx>-req_qty    = abap_true.

      "Montando os dados das conditions da ordem de venda
      APPEND INITIAL LINE TO lt_order_conditions_in ASSIGNING FIELD-SYMBOL(<fs_s_order_conditions_in>).

      <fs_s_order_conditions_in>-itm_number = <fs_item>-posnr.
      <fs_s_order_conditions_in>-cond_st_no = '001'.
      <fs_s_order_conditions_in>-cond_count = '01'.
      <fs_s_order_conditions_in>-cond_type  = lv_cond_type.
      <fs_s_order_conditions_in>-cond_value = <fs_item>-netwe.
      <fs_s_order_conditions_in>-currency   = 'BRL'.
      <fs_s_order_conditions_in>-cond_p_unt = '1'.

      APPEND INITIAL LINE TO lt_order_conditions_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_conditions_inx>).

      <fs_s_order_conditions_inx>-itm_number = <fs_item>-posnr.
      <fs_s_order_conditions_inx>-cond_st_no = '001'.
      <fs_s_order_conditions_inx>-cond_count = '01'.
      <fs_s_order_conditions_inx>-cond_type  = lv_cond_type.
      <fs_s_order_conditions_inx>-updateflag = abap_true.
      <fs_s_order_conditions_inx>-cond_value = abap_true.
      <fs_s_order_conditions_inx>-currency   = abap_true.
      <fs_s_order_conditions_inx>-cond_p_unt = abap_true.
    ENDLOOP.

    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in      = ls_order_header_in
        order_header_inx     = ls_order_header_inx
      IMPORTING
        salesdocument        = lv_sales_document
      TABLES
        return               = lt_return
        order_items_in       = lt_order_items_in
        order_items_inx      = lt_order_items_inx
        order_partners       = lt_order_partners
        order_schedules_in   = lt_order_schedules_in
        order_schedules_inx  = lt_order_schedules_inx
        order_conditions_in  = lt_order_conditions_in
        order_conditions_inx = lt_order_conditions_inx.

    IF lv_sales_document IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      "Erro ao criar ordem de venda
      RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
        EXPORTING
          textid      = zcxsd_nfce_ssresto=>sales_order_create_erro
          gv_msgv1    = CONV msgv1( gs_header-numcf )
          gv_msgv2    = CONV msgv2( gs_header-numserie )
          gt_bapiret2 = lt_return.
    ELSE.

      gs_header-ordem = lv_sales_document.
      put_cupom_ov( lv_sales_document ).

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

    ENDIF.


  ENDMETHOD.


  METHOD processa_interface_nfce_put.

    "limpa as variaveis
    clear_variavel( ).

    "seta a estrutra da interace dentro da estrura interna da class
    set_variavel( is_input ).

    "Salva os dados de caebaçho
    put_header( ).

    "Salva os dados de item
    put_item( ).

    "Salva os dados de pagamento
    put_pagamento( ).

    IF gs_header-codsit EQ gc_status_autorizado.
*      COMMIT WORK AND WAIT.
      "Cria a Ordem de vendas e salva os dados do cupom
      create_ov( ).
      save_data( ).
    ELSEIF gs_header-codsit EQ gc_status_cancelado.
*      COMMIT WORK AND WAIT.
      save_data( ).
*    ELSE.
*      ROLLBACK WORK.
    ENDIF.

  ENDMETHOD.


  METHOD put_cupom_ov.

    gs_cupom-vbeln    = iv_ov.
    gs_cupom-numcf    = gs_header-numcf.
    gs_cupom-numserie = gs_header-numserie.
    gs_cupom-werks    = gs_header-werks.

*    MODIFY ztsd_caft_cup_ov FROM gs_cupom.
*
*    IF sy-subrc NE 0.
*      ROLLBACK WORK.
*      RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
*        EXPORTING
*          textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
*          gv_msgv1 = CONV msgv1( gc_nmtb_cupom_ov )
*          gv_msgv2 = CONV msgv2( gs_header-numcf )
*          gv_msgv3 = CONV msgv3( gs_header-numserie ).
*
*    ENDIF.

  ENDMETHOD.


  METHOD put_header.

    DATA: lv_werks TYPE WERKS_d.

    CONSTANTS: lc_nmTb TYPE c LENGTH 20 VALUE 'ZTSD_CAFT_VEND_H'.

    IF gs_interface-mt_criar_nfce-itens IS NOT INITIAL.
      lv_werks = gs_interface-mt_criar_nfce-itens[ 1 ]-plant.
    ENDIF.

    IF gs_interface-mt_criar_nfce-cabecalho-codsit EQ gc_status_autorizado OR
      gs_interface-mt_criar_nfce-cabecalho-codsit EQ gc_status_cancelado.

      IF lv_werks IS NOT INITIAL.

        SELECT
          SINGLE numcf
        FROM ztsd_caft_vend_h
        INTO @DATA(lv_numcf)
        WHERE
          numcf        = @gs_interface-mt_criar_nfce-cabecalho-numcf
          AND numserie = @gs_interface-mt_criar_nfce-cabecalho-numserie
          AND werks    = @lv_werks.

        IF sy-subrc NE 0.

          gs_header-numcf    = gs_interface-mt_criar_nfce-cabecalho-numcf .
          CONDENSE gs_header-numcf. "NO-GAPS.
          gs_header-numserie = gs_interface-mt_criar_nfce-cabecalho-numserie.
          gs_header-werks    = lv_werks.
          gs_header-ausdat   = gs_interface-mt_criar_nfce-cabecalho-req_date_h.
          gs_header-authdate = gs_interface-mt_criar_nfce-cabecalho-authdate.
          gs_header-authtime = gs_interface-mt_criar_nfce-cabecalho-authtime.
          gs_header-netwr    = gs_interface-mt_criar_nfce-cabecalho-netwr.
          gs_header-accey    = gs_interface-mt_criar_nfce-cabecalho-acckey.
          gs_header-model    = gs_interface-mt_criar_nfce-cabecalho-model.
          gs_header-codsit   = gs_interface-mt_criar_nfce-cabecalho-codsit.

*          MODIFY ztsd_caft_vend_h FROM gs_header.
*
*          IF sy-subrc NE 0.
*            "levantar excesao erro ao salvar tabela de header
*            ROLLBACK WORK.
*            RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
*              EXPORTING
*                textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
*                gv_msgv1 = CONV msgv1( gc_nmtb_header )
*                gv_msgv2 = CONV msgv2( gs_header-numcf )
*                gv_msgv3 = CONV msgv3( gs_header-numserie ).
*          ENDIF.
        ELSE.
          "NFC já cadastrada
          RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
            EXPORTING
              textid   = zcxsd_nfce_ssresto=>cupom_ja_registrado
              gv_msgv1 = CONV msgv1( gs_interface-mt_criar_nfce-cabecalho-numcf )
              gv_msgv2 = CONV msgv2( gs_interface-mt_criar_nfce-cabecalho-numserie ).
        ENDIF.
      ELSE.
        "nfce sem plant informada no item.
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>cupom_sem_centro
            gv_msgv1 = CONV msgv1( gs_interface-mt_criar_nfce-cabecalho-numcf )
            gv_msgv2 = CONV msgv2( gs_interface-mt_criar_nfce-cabecalho-numserie ).
      ENDIF.
    ELSE.
      "status recebido diferente de autorizado e cancelado
      RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
        EXPORTING
          textid   = zcxsd_nfce_ssresto=>cupom_sem_centro
          gv_msgv1 = CONV msgv1( gs_interface-mt_criar_nfce-cabecalho-codsit )
          gv_msgv2 = CONV msgv2( gs_interface-mt_criar_nfce-cabecalho-numcf )
          gv_msgv3 = CONV msgv3( gs_interface-mt_criar_nfce-cabecalho-numserie ).

    ENDIF.
  ENDMETHOD.


  METHOD put_item.

    DATA: lv_item  TYPE i,
          lv_sitem TYPE posnr_va.


    IF gs_interface-mt_criar_nfce-itens IS NOT INITIAL.
      lv_item = 10.

      DATA(lt_uepos) = gs_interface-mt_criar_nfce-itens.

      SORT   lt_uepos BY uepos.

      DELETE lt_uepos WHERE uepos IS INITIAL.

      LOOP AT gs_interface-mt_criar_nfce-itens ASSIGNING FIELD-SYMBOL(<fs_item_interf>).

        APPEND INITIAL LINE TO gt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
        <fs_item>-posnr = lv_item.
        UNPACK <fs_item>-posnr TO <fs_item>-posnr.
        lv_item = lv_item + 10.

        <fs_item>-numcf    = gs_header-numcf.
        <fs_item>-numserie = gs_header-numserie.
        <fs_item>-werks    = <fs_item_interf>-plant.
        <fs_item>-matnr    = <fs_item_interf>-material.
        <fs_item>-zmeng    = <fs_item_interf>-target_qty.
        <fs_item>-netwe    = <fs_item_interf>-netwr.
        <fs_item>-cfop     = <fs_item_interf>-cfop.

        IF <fs_item_interf>-pstyv  IS INITIAL.

          READ TABLE lt_uepos TRANSPORTING NO FIELDS WITH KEY uepos = <fs_item_interf>-posnr BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            <fs_item>-pstyv    = 'Z005'.
          ELSE.
            <fs_item>-pstyv    = 'Z098'.
          ENDIF.
        ELSE.
          <fs_item>-pstyv    = <fs_item_interf>-pstyv.
        ENDIF.


*Início - Cleverson Faria - 06/10/2022 - Tratamento da taxa de serviço
        IF <fs_item_interf>-material EQ '9100060'.
          <fs_item>-pstyv    = 'Z005'.
        ENDIF.
*Fim - Cleverson Faria - 06/10/2022 - Tratamento da taxa de serviço


        <fs_item>-uepos    = <fs_item_interf>-uepos.
        <fs_item>-posnr    = <fs_item_interf>-posnr.
        <fs_item>-icms_cst   = <fs_item_interf>-tributos-icms_cst.
        <fs_item>-pis_cst    = <fs_item_interf>-tributos-pis_cst.
        <fs_item>-cofins_cst = <fs_item_interf>-tributos-cofins_cst.
        <fs_item>-icms_vl    = <fs_item_interf>-tributos-icms_vl.
        <fs_item>-pis_vl     = <fs_item_interf>-tributos-pis_vl.
        <fs_item>-cofins_vl  = <fs_item_interf>-tributos-cofins_vl.
        <fs_item>-icms_st_vl = <fs_item_interf>-tributos-icms_st_vl.

      ENDLOOP.

    ELSE.
      "NFCe sem item
      ROLLBACK WORK.
      RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
        EXPORTING
          textid   = zcxsd_nfce_ssresto=>cupom_sem_item
          gv_msgv1 = CONV msgv1( gs_header-numcf )
          gv_msgv2 = CONV msgv2( gs_header-numserie ).
    ENDIF.


  ENDMETHOD.


  METHOD put_pagamento.
    DATA: lv_item    TYPE i,
          lv_tipopag TYPE ztca_param_par-chave3.

    CONSTANTS: lc_chave2 TYPE ztca_param_par-chave2 VALUE 'ZLSCH'.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    IF gs_interface-mt_criar_nfce-pagamentos IS NOT INITIAL.
      lv_item = 1.

      LOOP AT gs_interface-mt_criar_nfce-pagamentos ASSIGNING FIELD-SYMBOL(<fs_pag_interface>).

        APPEND INITIAL LINE TO gt_pagamento ASSIGNING FIELD-SYMBOL(<fs_pagamento>).

        <fs_pagamento>-item = lv_item.
        UNPACK <fs_pagamento>-item TO <fs_pagamento>-item.
        lv_item = lv_item + 1.

        <fs_pagamento>-numcf    = gs_header-numcf.
        <fs_pagamento>-numserie = gs_header-numserie.
        <fs_pagamento>-werks    = gs_header-werks.
        <fs_pagamento>-tipopag  = <fs_pag_interface>-tipopag.
        <fs_pagamento>-netwr    = <fs_pag_interface>-netwr.
        <fs_pagamento>-codaut   = <fs_pag_interface>-codaut.
        <fs_pagamento>-vl_taxa  = <fs_pag_interface>-vl_taxa.

      ENDLOOP.

*      IF gt_pagamento IS NOT INITIAL.
*        MODIFY ztsd_caft_vend_p FROM TABLE gt_pagamento.
*
*        IF sy-subrc NE 0.
*          "erro ao gravar forma de pagamento
*          ROLLBACK WORK.
*          RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
*            EXPORTING
*              textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
*              gv_msgv1 = CONV msgv1( gc_nmtb_pag )
*              gv_msgv2 = CONV msgv2( gs_header-numcf )
*              gv_msgv3 = CONV msgv3( gs_header-numserie ).
*        ENDIF.
*      ENDIF.
    ELSE.
      "Cupom sem forma de pagamento
      ROLLBACK WORK.
      RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
        EXPORTING
          textid   = zcxsd_nfce_ssresto=>cupom_sem_form_pg
          gv_msgv1 = CONV msgv1( gs_header-numcf )
          gv_msgv2 = CONV msgv2( gs_header-numserie ).
    ENDIF.

  ENDMETHOD.


  METHOD set_variavel.
    me->gs_interface = is_input.
  ENDMETHOD.


  METHOD save_data.

    IF gs_header IS   NOT INITIAL.
      MODIFY ztsd_caft_vend_h FROM gs_header.

      IF sy-subrc NE 0.
        "levantar excesao erro ao salvar tabela de header
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
            gv_msgv1 = CONV msgv1( gc_nmtb_header )
            gv_msgv2 = CONV msgv2( gs_header-numcf )
            gv_msgv3 = CONV msgv3( gs_header-numserie ).
      ENDIF.
    ENDIF.

    IF gt_item IS NOT INITIAL.
      MODIFY ztsd_caft_vend_i FROM TABLE gt_item.

      IF sy-subrc NE 0.
        "erro ao inserir item da OV
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
            gv_msgv1 = CONV msgv1( gc_nmtb_item )
            gv_msgv2 = CONV msgv2( gs_header-numcf )
            gv_msgv3 = CONV msgv3( gs_header-numserie ).
      ENDIF.
    ENDIF.

    IF gt_pagamento IS NOT INITIAL.
      MODIFY ztsd_caft_vend_p FROM TABLE gt_pagamento.

      IF sy-subrc NE 0.
        "erro ao gravar forma de pagamento
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
            gv_msgv1 = CONV msgv1( gc_nmtb_pag )
            gv_msgv2 = CONV msgv2( gs_header-numcf )
            gv_msgv3 = CONV msgv3( gs_header-numserie ).
      ENDIF.
    ENDIF.

    IF gs_cupom IS NOT INITIAL.
      MODIFY ztsd_caft_cup_ov FROM gs_cupom.

      IF sy-subrc NE 0.
        ROLLBACK WORK.
        RAISE EXCEPTION TYPE zcxsd_nfce_ssresto
          EXPORTING
            textid   = zcxsd_nfce_ssresto=>erro_save_tb_db
            gv_msgv1 = CONV msgv1( gc_nmtb_cupom_ov )
            gv_msgv2 = CONV msgv2( gs_header-numcf )
            gv_msgv3 = CONV msgv3( gs_header-numserie ).

      ENDIF.
    ENDIF.
    COMMIT WORK AND WAIT.

  ENDMETHOD.
ENDCLASS.
