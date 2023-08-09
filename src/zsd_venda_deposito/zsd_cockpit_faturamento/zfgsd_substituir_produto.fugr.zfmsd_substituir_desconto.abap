FUNCTION zfmsd_substituir_desconto.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_ORDER) TYPE  VBELN_VA
*"     VALUE(IS_ORDERX) TYPE  BAPISDH1X
*"  TABLES
*"      TT_RETURN STRUCTURE  BAPIRET2
*"      TT_ITEM STRUCTURE  BAPISDITM
*"      TT_ITEMX STRUCTURE  BAPISDITMX
*"      TT_SCHEDULE_LINES STRUCTURE  BAPISCHDL OPTIONAL
*"      TT_SCHEDULE_LINESX STRUCTURE  BAPISCHDLX OPTIONAL
*"      TT_CONDITIONS_IN STRUCTURE  BAPICOND OPTIONAL
*"      TT_CONDITIONS_INX STRUCTURE  BAPICONDX OPTIONAL
*"      TT_COSTCENTER STRUCTURE  ZSSD_SUB_PROD_COSTCENTER OPTIONAL
*"----------------------------------------------------------------------

  DATA lt_return TYPE TABLE OF bapiret2.


  "Exporta a variável para o método CALCULAR - classe ZCLSD_CONDICAO_CONTRATO
  "Exporta a variável para o enhancement ZEIMM_PRICING_COMPLETE - início da função PRICING_COMPLETE
  EXPORT gv_sub_prod FROM gv_sub_prod TO MEMORY ID 'ZSD_SUB_PROD'.

  " Tabela será recuperada no include ZSDI_SUBST_PROD_COSTCENTER para passar o cost center ao novo item
  gt_costcenter[] = tt_costcenter[].


**********************************************************************
* desconto - 07.08.2023
  SORT tt_item BY itm_number.
  SORT tt_schedule_lines BY itm_number.
  SORT tt_conditions_inx BY itm_number cond_type.
  LOOP AT tt_conditions_in ASSIGNING FIELD-SYMBOL(<fs_conditions_in>)
    WHERE cond_type = 'ZBON' OR cond_type = 'ZBOS'.
    READ TABLE tt_schedule_lines ASSIGNING FIELD-SYMBOL(<fs_schedule_lines>) WITH KEY itm_number = <fs_conditions_in>-itm_number BINARY SEARCH.
    IF sy-subrc = 0.
      <fs_conditions_in>-cond_p_unt = <fs_schedule_lines>-req_qty.
      READ TABLE tt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY itm_number = <fs_conditions_in>-itm_number BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_conditions_in>-cond_unit = <fs_item>-sales_unit.
      ENDIF.
      READ TABLE tt_conditions_inx ASSIGNING FIELD-SYMBOL(<fs_conditions_inx>)
      WITH KEY itm_number = <fs_conditions_in>-itm_number cond_type = <fs_conditions_in>-cond_type BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_conditions_inx>-cond_p_unt = abap_true.
        <fs_conditions_inx>-cond_unit = abap_true.
      ENDIF.
    ENDIF.
  ENDLOOP.
**********************************************************************

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument    = iv_order
      order_header_inx = is_orderx
    TABLES
      return           = lt_return
      order_item_in    = tt_item
      order_item_inx   = tt_itemx
      schedule_lines   = tt_schedule_lines
      schedule_linesx  = tt_schedule_linesx
      conditions_in    = tt_conditions_in
      conditions_inx   = tt_conditions_inx.
  DELETE lt_return WHERE  type = 'W'.

  IF line_exists( lt_return[ type = 'S' ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*      EXPORTING
*        wait = 'X'.

  ENDIF.

  FREE MEMORY ID 'ZSD_SUB_PROD'.

  tt_return[] = lt_return[].



ENDFUNCTION.
