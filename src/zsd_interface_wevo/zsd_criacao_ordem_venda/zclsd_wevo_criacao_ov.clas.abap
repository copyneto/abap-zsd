class ZCLSD_WEVO_CRIACAO_OV definition
  public
  final
  create public .

public section.

  constants GC_FLAG_INSERT_BAPI type UPDKZ_D value 'I' ##NO_TEXT.

  methods PROCESSA_INTERFACE_CRIACAO_OV
    importing
      !IV_INPUT type ZCLSD_MT_VENDA_ORDEM
    returning
      value(RV_ORDEM) type VBELN_VA
    raising
      ZCXSD_WEVO_ORDEM_VENDA .
  methods CRIA_STRING_TEXT_LINE
    importing
      !IV_TEXT_LINE type STRING
      !IV_TEXT_ID type BAPISDTEXT-TEXT_ID
      !IV_LANGU type BAPISDTEXT-LANGU
    changing
      value(CT_ORDERTEXT) type BAPISDTEXT_T .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_WEVO_CRIACAO_OV IMPLEMENTATION.


  METHOD processa_interface_criacao_ov.

    CONSTANTS: BEGIN OF lc_param,
                 modulo TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1 TYPE ztca_param_par-chave1 VALUE 'WEVO',
                 chave2 TYPE ztca_param_par-chave2 VALUE 'AUART',
                 chave3 TYPE ztca_param_par-chave3 VALUE 'DLV_PRIO',
               END OF lc_param.

    "Tabelas internas
    DATA: lt_order_items_in       TYPE STANDARD TABLE OF bapisditm,
          lt_order_items_inx      TYPE STANDARD TABLE OF bapisditmx,
          lt_order_partners       TYPE STANDARD TABLE OF bapiparnr,
          lt_order_schedules_in   TYPE STANDARD TABLE OF bapischdl,
          lt_order_schedules_inx  TYPE STANDARD TABLE OF bapischdlx,
          lt_order_conditions_in  TYPE STANDARD TABLE OF bapicond,
          lt_order_conditions_inx TYPE STANDARD TABLE OF bapicondx,
          lt_return               TYPE STANDARD TABLE OF bapiret2,
          lt_parameteraddresses   TYPE STANDARD TABLE OF bapiaddr1,
          lt_ordertext            TYPE STANDARD TABLE OF bapisdtext,
          lt_jurtab               TYPE STANDARD TABLE OF com_jur,
          lt_lines                TYPE TABLE OF tline.                "VARAUJO - 05.01.2023

    DATA: ls_order_header_in  TYPE bapisdhd1,
          ls_order_header_inx TYPE bapisdhd1x,
          ls_logic_switch     TYPE bapisdls,
          lv_sales_document   TYPE bapivbeln-vbeln,
          lv_nitem            TYPE i,
          lv_lprio            TYPE lprio.


    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ). " CHANGE - LSCHEPP - 24.07.2023

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = lc_param-modulo
                                          iv_chave1 = lc_param-chave1
                                          iv_chave2 = lc_param-chave2
                                          iv_chave3 = lc_param-chave3
                                IMPORTING ev_param  = lv_lprio ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    ls_order_header_in-doc_type   = iv_input-mt_venda_ordem-doc_type.
    ls_order_header_in-sales_org  = iv_input-mt_venda_ordem-sales_org.
    ls_order_header_in-distr_chan = iv_input-mt_venda_ordem-distr_chan.
    ls_order_header_in-division   = iv_input-mt_venda_ordem-division.
    ls_order_header_in-sales_grp  = iv_input-mt_venda_ordem-sales_grp.
    ls_order_header_in-sales_off  = iv_input-mt_venda_ordem-sales_off.
    ls_order_header_in-po_method  = iv_input-mt_venda_ordem-po_method.
    ls_order_header_in-incoterms1 = iv_input-mt_venda_ordem-incoterms1.
    ls_order_header_in-incoterms2 = iv_input-mt_venda_ordem-incoterms2.
    ls_order_header_in-pmnttrms   = iv_input-mt_venda_ordem-pmnttrms.
    ls_order_header_in-dlv_block  = iv_input-mt_venda_ordem-dlv_block.
    ls_order_header_in-purch_date = iv_input-mt_venda_ordem-purch_date.
    ls_order_header_in-purch_no_c = iv_input-mt_venda_ordem-purch_no_c.
    ls_order_header_in-doc_date   = iv_input-mt_venda_ordem-doc_date.
    ls_order_header_in-pymt_meth  = iv_input-mt_venda_ordem-pymt_meth.
    ls_order_header_in-ship_cond  = iv_input-mt_venda_ordem-ship_cond.

    ls_order_header_inx-updateflag = gc_flag_insert_bapi.
    ls_order_header_inx-doc_type   = abap_true.
    ls_order_header_inx-sales_org  = abap_true.
    ls_order_header_inx-distr_chan = abap_true.
    ls_order_header_inx-division   = abap_true.
    ls_order_header_inx-sales_grp  = abap_true.
    ls_order_header_inx-po_method  = abap_true.
    ls_order_header_inx-sales_off  = abap_true.
    ls_order_header_inx-incoterms1 = abap_true.
    ls_order_header_inx-incoterms2 = abap_true.
    ls_order_header_inx-pmnttrms   = abap_true.
    ls_order_header_inx-dlv_block  = abap_true.
    ls_order_header_inx-purch_date = abap_true.
    ls_order_header_inx-purch_no_c = abap_true.
    ls_order_header_inx-doc_date   = abap_true.
    ls_order_header_inx-pymt_meth  = abap_true.
    ls_order_header_inx-ship_cond  = abap_true.

    lv_nitem = 10.

*    LOOP AT input-mt_venda_ordem-itm_number ASSIGNING FIELD-SYMBOL(<fs_item>).

    LOOP AT iv_input-mt_venda_ordem-order_items_in ASSIGNING FIELD-SYMBOL(<fs_order_items_in>).

      APPEND INITIAL LINE TO lt_order_items_in ASSIGNING FIELD-SYMBOL(<fs_s_order_items_in>).

      <fs_s_order_items_in>-itm_number = <fs_order_items_in>-itm_number.
      UNPACK <fs_s_order_items_in>-itm_number TO <fs_s_order_items_in>-itm_number.
      <fs_s_order_items_in>-material   = <fs_order_items_in>-material.
      UNPACK <fs_s_order_items_in>-material TO <fs_s_order_items_in>-material.

      <fs_s_order_items_in>-plant      = <fs_order_items_in>-plant.
      <fs_s_order_items_in>-store_loc  = <fs_order_items_in>-store_loc.
      <fs_s_order_items_in>-target_qty = <fs_order_items_in>-target_qty.
      <fs_s_order_items_in>-dlv_prio   = lv_lprio.

    ENDLOOP.

    APPEND INITIAL LINE TO lt_order_items_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_items_inx>).

    <fs_s_order_items_inx>-updateflag = gc_flag_insert_bapi.
    <fs_s_order_items_inx>-itm_number = <fs_s_order_items_in>-itm_number.
    <fs_s_order_items_inx>-material   = abap_true.
    <fs_s_order_items_inx>-target_qty = abap_true.
    <fs_s_order_items_inx>-dlv_prio   = abap_true.
    <fs_s_order_items_inx>-plant      = abap_true.
    lv_nitem = lv_nitem + 10.
*    ENDLOOP.

    "Montando os dados de divisão da remessa da ordem de venda
    LOOP AT iv_input-mt_venda_ordem-order_schedules_in ASSIGNING FIELD-SYMBOL(<fs_order_schedules_in>).

      APPEND INITIAL LINE TO lt_order_schedules_in ASSIGNING FIELD-SYMBOL(<fs_s_order_schedules_in>).

      <fs_s_order_schedules_in>-itm_number = <fs_order_schedules_in>-itm_number.
      <fs_s_order_schedules_in>-sched_line = <fs_order_schedules_in>-sched_line.
      <fs_s_order_schedules_in>-req_qty    = <fs_order_schedules_in>-req_qty.
      <fs_s_order_schedules_in>-req_dlv_bl = <fs_order_schedules_in>-req_dlv_bl.
    ENDLOOP.

    APPEND INITIAL LINE TO lt_order_schedules_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_schedules_inx>).

    <fs_s_order_schedules_inx>-itm_number = <fs_s_order_items_in>-itm_number.
    <fs_s_order_schedules_inx>-updateflag = abap_true.
    <fs_s_order_schedules_inx>-sched_line = <fs_s_order_schedules_in>-sched_line.
    <fs_s_order_schedules_inx>-req_qty    = abap_true.

    LOOP AT iv_input-mt_venda_ordem-order_partners ASSIGNING FIELD-SYMBOL(<fs_order_partners>).

      APPEND INITIAL LINE TO lt_order_partners ASSIGNING FIELD-SYMBOL(<fs_partner>).

      <fs_partner>-partn_role = <fs_order_partners>-partn_role.
      <fs_partner>-partn_numb = <fs_order_partners>-partn_numb.
      <fs_partner>-name       = <fs_order_partners>-name.
      <fs_partner>-street     = <fs_order_partners>-street.
      <fs_partner>-country    = <fs_order_partners>-country.
      <fs_partner>-postl_code = <fs_order_partners>-postl_code.
      <fs_partner>-city       = <fs_order_partners>-city.
      <fs_partner>-district   = <fs_order_partners>-district.
      <fs_partner>-region     = <fs_order_partners>-region.
      <fs_partner>-telephone  = <fs_order_partners>-telephone.
      <fs_partner>-addr_link  = <fs_order_partners>-addr_link.
    ENDLOOP.

    APPEND INITIAL LINE TO lt_parameteraddresses ASSIGNING FIELD-SYMBOL(<fs_address>).
    <fs_address>-addr_no    = iv_input-mt_venda_ordem-partneraddresses-addr_no.
    <fs_address>-name       = iv_input-mt_venda_ordem-partneraddresses-name.
    <fs_address>-city       = iv_input-mt_venda_ordem-partneraddresses-city.
    <fs_address>-district   = iv_input-mt_venda_ordem-partneraddresses-district.
    <fs_address>-postl_cod1 = iv_input-mt_venda_ordem-partneraddresses-postl_cod1.
    <fs_address>-street     = iv_input-mt_venda_ordem-partneraddresses-street.
    <fs_address>-house_no   = iv_input-mt_venda_ordem-partneraddresses-house_no.
    <fs_address>-country    = iv_input-mt_venda_ordem-partneraddresses-country.
    <fs_address>-langu      = iv_input-mt_venda_ordem-partneraddresses-langu.
    <fs_address>-region     = iv_input-mt_venda_ordem-partneraddresses-region.
    <fs_address>-tel1_numbr = iv_input-mt_venda_ordem-partneraddresses-tel1_numbr.
    <fs_address>-house_no2  = iv_input-mt_venda_ordem-partneraddresses-house_no2.
    <fs_address>-e_mail     = iv_input-mt_venda_ordem-partneraddresses-e_mail.

    IF NOT <fs_address>-country IS INITIAL AND
       NOT <fs_address>-postl_cod1 IS INITIAL AND
       NOT <fs_address>-region IS INITIAL AND
       NOT <fs_address>-city IS INITIAL.

      CALL FUNCTION 'TAX_TXJCD_DETERMINE_TABLE'
        EXPORTING
          im_country             = <fs_address>-country
          im_region              = <fs_address>-region
          im_zipcode             = <fs_address>-postl_cod1
          im_city                = <fs_address>-city
        TABLES
          t_jurtab               = lt_jurtab
        EXCEPTIONS
          input_incomplete       = 1
          no_tax_procedure       = 2
          no_taxjurcode_required = 3
          rfcdest_not_found      = 4
          taxjurcode_not_found   = 5
          other_error            = 6.

      IF sy-subrc EQ 0 AND
        NOT lt_jurtab IS INITIAL.
        TRY.
            <fs_address>-taxjurcode = lt_jurtab[ 1 ]-txjcd.
          CATCH cx_sy_itab_line_not_found.
        ENDTRY.
      ENDIF.
    ENDIF.

    "Montando os dados das conditions da ordem de venda
    LOOP AT iv_input-mt_venda_ordem-order_conditions_in ASSIGNING FIELD-SYMBOL(<fs_order_conditions_in>).

      READ TABLE lt_order_conditions_in ASSIGNING FIELD-SYMBOL(<fs_s_order_conditions_in>) WITH KEY itm_number = <fs_order_conditions_in>-itm_number
                                                                                                    cond_type = <fs_order_conditions_in>-cond_type.
      IF sy-subrc EQ 0.
        DATA(lv_cond_value) = <fs_order_conditions_in>-cond_value.
        REPLACE ',' WITH '.' INTO lv_cond_value.
        ADD lv_cond_value TO <fs_s_order_conditions_in>-cond_value.
      ELSE.
        APPEND INITIAL LINE TO lt_order_conditions_in ASSIGNING <fs_s_order_conditions_in>.

        <fs_s_order_conditions_in>-itm_number = <fs_order_conditions_in>-itm_number.
        <fs_s_order_conditions_in>-cond_type  = <fs_order_conditions_in>-cond_type.

        lv_cond_value = <fs_order_conditions_in>-cond_value.
        REPLACE ',' WITH '.' INTO lv_cond_value.

        <fs_s_order_conditions_in>-cond_value = lv_cond_value.
        <fs_s_order_conditions_in>-currency   = <fs_order_conditions_in>-currency.
      ENDIF.

    ENDLOOP.

    APPEND INITIAL LINE TO lt_order_conditions_inx ASSIGNING FIELD-SYMBOL(<fs_s_order_conditions_inx>).

    <fs_s_order_conditions_inx>-itm_number = <fs_s_order_items_in>-itm_number.
    <fs_s_order_conditions_inx>-cond_type  = <fs_order_conditions_in>-cond_type.
    <fs_s_order_conditions_inx>-updateflag = abap_true.
    <fs_s_order_conditions_inx>-cond_value = abap_true.
    <fs_s_order_conditions_inx>-currency   = abap_true.
    <fs_s_order_conditions_inx>-cond_p_unt = abap_true.

    LOOP AT iv_input-mt_venda_ordem-order_text ASSIGNING FIELD-SYMBOL(<fs_text_id>).

*      APPEND INITIAL LINE TO lt_ordertext ASSIGNING FIELD-SYMBOL(<fs_ordertxt>).
*      <fs_ordertxt>-text_id   = <fs_text_id>-text_id.
*      <fs_ordertxt>-langu     = <fs_text_id>-langu.

*------Inicio VARAUJO - 05.01.2023------*

      me->cria_string_text_line(
       EXPORTING
         iv_text_id   = CONV #( <fs_text_id>-text_id )
         iv_langu     = CONV #( <fs_text_id>-langu )
         iv_text_line = <fs_text_id>-text_line
       CHANGING
         ct_ordertext = lt_ordertext
       ).

*-------Fim VARAUJO - 05.01.2023--------*

    ENDLOOP.

*    ls_logic_switch-pricing = 'C'.

    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in      = ls_order_header_in
        order_header_inx     = ls_order_header_inx
        logic_switch         = ls_logic_switch
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
        order_conditions_inx = lt_order_conditions_inx
        order_text           = lt_ordertext
        partneraddresses     = lt_parameteraddresses.

    IF lv_sales_document IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      "Erro ao criar ordem de venda
      RAISE EXCEPTION TYPE zcxsd_wevo_ordem_venda
        EXPORTING
          textid      = zcxsd_wevo_ordem_venda=>gc_sales_order_create_erro
          gv_msgv1    = CONV msgv1( iv_input-mt_venda_ordem-purch_no_c )
          gt_bapiret2 = lt_return.
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
      rv_ordem = lv_sales_document.
    ENDIF.

  ENDMETHOD.


  METHOD cria_string_text_line.

    DATA: lt_lines TYPE TABLE OF tline.
    DATA: lv_texto(65000) TYPE c.

    lv_texto =  iv_text_line.

    CALL FUNCTION 'C14W_STRING_TO_TLINE'
      EXPORTING
        i_string    = lv_texto
      TABLES
        e_tline_tab = lt_lines.

    LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).
      APPEND INITIAL LINE TO ct_ordertext ASSIGNING FIELD-SYMBOL(<fs_ordertxt>).
      <fs_ordertxt>-text_id    = iv_text_id.
      <fs_ordertxt>-langu      = iv_langu.
      <fs_ordertxt>-text_line  = <fs_lines>-tdline.
      <fs_ordertxt>-format_col = '*'.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
