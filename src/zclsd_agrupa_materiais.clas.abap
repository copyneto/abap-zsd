class ZCLSD_AGRUPA_MATERIAIS definition
  public
  final
  create public .

public section.

  class-methods EXECUTE
    importing
      !IS_OBJ_HEADER type J_1BNFDOC
    changing
      !CT_OBJ_ITEM type J_1BNFLIN_TAB
      !CT_OBJ_ITEM_TAX type J_1BNFSTX_TAB .
  class-methods CHECK_COLIGADA
    importing
      !IS_OBJ_HEADER type J_1BNFDOC
    returning
      value(RV_COLIGADA) type ABAP_BOOL .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_AGRUPA_MATERIAIS IMPLEMENTATION.


  METHOD check_coligada.

    DATA ls_zcgc_coligada TYPE t001w.


    CASE is_obj_header-partyp.

      WHEN 'C'. "Cliente

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE kunnr = is_obj_header-parid.

      WHEN 'V'. "Fornecedor

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE lifnr = is_obj_header-parid.

      WHEN 'B'. "Filial

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE j_1bbranch = is_obj_header-parid+4(4).

      WHEN OTHERS.
        rv_coligada = abap_false.
        RETURN.

    ENDCASE.

    IF sy-subrc IS INITIAL.
      rv_coligada = abap_true.
    ELSE.
      rv_coligada = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD execute.

    DATA: lt_obj_item_agrup     TYPE j_1bnflin_tab,
          ls_obj_item_agrup     TYPE j_1bnflin,
          lt_obj_item_tax_agrup TYPE j_1bnfstx_tab,
          ls_obj_item_tax_agrup TYPE j_1bnfstx.


    IF NOT ct_obj_item[] IS INITIAL.

      IF check_coligada( is_obj_header ) IS INITIAL AND
         ct_obj_item[ 1 ]-itmtyp NE '2' AND
         is_obj_header-land1 EQ 'BR'.

        DATA(lt_obj_item)     = ct_obj_item[].
        DATA(lt_obj_item_tax) = ct_obj_item_tax[].

        LOOP AT lt_obj_item ASSIGNING FIELD-SYMBOL(<fs_obj_item>).
          READ TABLE lt_obj_item_agrup ASSIGNING FIELD-SYMBOL(<fs_obj_item_agrup>) WITH KEY matnr = <fs_obj_item>-matnr.
          IF sy-subrc EQ 0.
            <fs_obj_item_agrup>-menge      = <fs_obj_item_agrup>-menge + <fs_obj_item>-menge.
            <fs_obj_item_agrup>-netwr      = <fs_obj_item_agrup>-netwr + <fs_obj_item>-netwr.
            <fs_obj_item_agrup>-nfnet      = <fs_obj_item_agrup>-nfnet + <fs_obj_item>-nfnet.
            <fs_obj_item_agrup>-netwrt     = <fs_obj_item_agrup>-netwrt + <fs_obj_item>-netwrt.
            <fs_obj_item_agrup>-nfnett     = <fs_obj_item_agrup>-nfnett + <fs_obj_item>-nfnett.
            <fs_obj_item_agrup>-menge_trib = <fs_obj_item_agrup>-menge_trib + <fs_obj_item>-menge_trib.
            LOOP AT lt_obj_item_tax ASSIGNING FIELD-SYMBOL(<fs_obj_item_tax>) WHERE itmnum = <fs_obj_item>-itmnum.
              LOOP AT lt_obj_item_tax_agrup ASSIGNING FIELD-SYMBOL(<fs_obj_item_tax_agrup>) WHERE itmnum = <fs_obj_item_agrup>-itmnum
                                                                                              AND taxtyp = <fs_obj_item_tax>-taxtyp.
                <fs_obj_item_tax_agrup>-base = <fs_obj_item_tax_agrup>-base + <fs_obj_item_tax>-base.
                <fs_obj_item_tax_agrup>-taxval = <fs_obj_item_tax_agrup>-taxval + <fs_obj_item_tax>-taxval.
                <fs_obj_item_tax_agrup>-excbas = <fs_obj_item_tax_agrup>-excbas + <fs_obj_item_tax>-excbas.
                <fs_obj_item_tax_agrup>-othbas = <fs_obj_item_tax_agrup>-othbas + <fs_obj_item_tax>-othbas.
              ENDLOOP.
            ENDLOOP.
          ELSE.
            DESCRIBE TABLE lt_obj_item_agrup LINES DATA(lv_line).
            ADD 1 TO lv_line.
            MOVE-CORRESPONDING <fs_obj_item> TO ls_obj_item_agrup.
            ls_obj_item_agrup-itmnum   = lv_line * 10.
            ls_obj_item_agrup-refitm   = lv_line * 10.
            ls_obj_item_agrup-num_item = lv_line.
            APPEND ls_obj_item_agrup TO lt_obj_item_agrup.
            LOOP AT lt_obj_item_tax ASSIGNING <fs_obj_item_tax> WHERE itmnum = <fs_obj_item>-itmnum.
              <fs_obj_item_tax>-itmnum = ls_obj_item_agrup-itmnum.
              APPEND <fs_obj_item_tax> TO lt_obj_item_tax_agrup.
            ENDLOOP.
          ENDIF.
          CLEAR: ls_obj_item_agrup,
                 lv_line.
        ENDLOOP.

        IF lines( ct_obj_item[] ) NE lines( lt_obj_item_agrup ).
          ct_obj_item     = lt_obj_item_agrup.
          ct_obj_item_tax = lt_obj_item_tax_agrup.
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
