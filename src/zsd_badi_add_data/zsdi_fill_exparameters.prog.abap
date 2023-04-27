*Classe ZCLSD_NFE_ADD_DATA
*Metodo IF_J_1BNF_ADD_DATA~FILL_EXPARAMETERS
*IT_DOC TYPE J_1BNFDOC  Nota Fiscal Header
*IT_LIN	TYPE J_1BNFLIN OPTIONAL	Nota Fiscal line items
*CH_EXTENSION1  TYPE J1B_NF_XML_EXTENSION1_TAB  NF-e Container1 for 'Customer Exit' Parameter
*CH_EXTENSION2  TYPE J1B_NF_XML_EXTENSION2_TAB  NF-e Container2 for 'Customer Exit' Parameter
*&---------------------------------------------------------------------*
*& Include          ZSDI_FILL_EXPARAMETERS
*&---------------------------------------------------------------------*
    TYPES: BEGIN OF ty_trade_notes,
             mandt   TYPE   j_1bnftradenotes-mandt,
             docnum  TYPE   j_1bnftradenotes-docnum,
             counter TYPE   j_1bnftradenotes-counter,
             ndup    TYPE   j_1bnftradenotes-ndup,
             dvenc   TYPE   j_1bnftradenotes-dvenc,
             vdup    TYPE   j_1bnftradenotes-vdup,
           END OF ty_trade_notes.

    DATA: lt_trade_notes TYPE TABLE OF ty_trade_notes,
          ls_trade_notes TYPE ty_trade_notes,
          lv_counter     TYPE j_1bnftradenotes-counter.

    DATA: lv_tlines TYPE TABLE OF tline-tdline.

    DATA: lv_dif_parc_nftot TYPE f.
    DATA lt_item_text TYPE j_1bnflin_text_tab.

    FIELD-SYMBOLS <fs_item_text> LIKE lt_item_text.
    ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM_TEXT[]') TO <fs_item_text>.
    IF <fs_item_text> IS ASSIGNED.
      SORT <fs_item_text> BY docnum itmnum text.
      DELETE ADJACENT DUPLICATES FROM <fs_item_text> COMPARING docnum itmnum text.
    ENDIF.

    IF <fs_payment> IS ASSIGNED.

      SORT lt_payment_aux BY t_pag.
      READ TABLE lt_payment_aux TRANSPORTING NO FIELDS WITH KEY t_pag = 90 BINARY SEARCH .
      IF sy-subrc NE 0.

        FIELD-SYMBOLS <fs_trade_notes> LIKE lt_trade_notes.
        ASSIGN ('(SAPLJ_1B_NFE)WK_TRADE_NOTES[]') TO <fs_trade_notes>.

        IF <fs_trade_notes> IS ASSIGNED AND <fs_trade_notes> IS INITIAL AND it_lin-reftyp EQ gc_fat.

          SELECT bukrs, gjahr, vbeln, buzei, dmbtr
            FROM bsid_view
            INTO TABLE @DATA(lt_bsid)
            WHERE bukrs EQ @it_doc-bukrs
              AND kunnr EQ @it_doc-parid
              AND gjahr EQ @sy-datum(4)
              AND vbeln EQ @it_lin-refkey.

          IF lt_bsid IS NOT INITIAL.
* LSCHEPP - Ajuste valor tag <dvenc> - 12.07.2022 Início
*        SELECT belnr, buzei, fdtag
            SELECT belnr, buzei, zfbdt, zbd1t
* LSCHEPP - Ajuste valor tag <dvenc> - 12.07.2022 Fim
              FROM bseg
              INTO TABLE @DATA(lt_bseg)
              WHERE bukrs EQ @it_doc-bukrs
                AND gjahr EQ @sy-datum(4)
                AND belnr EQ @it_lin-refkey.


            SORT lt_bseg BY belnr buzei.

            IF lt_bseg IS NOT INITIAL.

              SELECT SINGLE vtweg
              INTO @DATA(lv_vtweg)
              FROM vbrk
              WHERE vtweg EQ '13'.

              IF lv_vtweg IS NOT INITIAL.

                SELECT SINGLE nftot
                INTO @DATA(lv_nftot)
                  FROM j_1bnfdoc
                  WHERE docnum EQ @it_doc-docnum.

              ENDIF.

            ENDIF.

            LOOP AT lt_bsid ASSIGNING FIELD-SYMBOL(<fs_bsid>).

              ls_trade_notes-docnum  = it_doc-docnum.
              lv_counter             = lv_counter + 1.
              ls_trade_notes-counter = lv_counter .
              ls_trade_notes-ndup    = <fs_bsid>-buzei.
              ls_trade_notes-vdup    = <fs_bsid>-dmbtr.

              READ TABLE lt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>) WITH KEY belnr = <fs_bsid>-vbeln
                                                                            buzei = <fs_bsid>-buzei
                                                                   BINARY SEARCH.

              IF sy-subrc = 0.
* LSCHEPP - Ajuste valor tag <dvenc> - 12.07.2022 Início
*            ls_trade_notes-dvenc   = <fs_bseg>-fdtag.
                ls_trade_notes-dvenc   = <fs_bseg>-zfbdt + <fs_bseg>-zbd1t.
* LSCHEPP - Ajuste valor tag <dvenc> - 12.07.2022 Fim

                IF <fs_bsid>-dmbtr GT lv_nftot.
                  lv_dif_parc_nftot = <fs_bsid>-dmbtr - lv_nftot.

                  IF <fs_bsid>-buzei EQ '001' AND lv_dif_parc_nftot LE '0.05'.
                    ls_trade_notes-vdup = ls_trade_notes-vdup - lv_dif_parc_nftot.
                  ENDIF.
                ELSEIF <fs_bsid>-dmbtr LT lv_nftot.
                  lv_dif_parc_nftot = lv_nftot - <fs_bsid>-dmbtr.

                  IF <fs_bsid>-buzei EQ '001' AND lv_dif_parc_nftot LE '0.05'.
                    ls_trade_notes-vdup = ls_trade_notes-vdup + lv_dif_parc_nftot.
                  ENDIF.

                ENDIF.

              ENDIF.

              APPEND ls_trade_notes TO <fs_trade_notes>.
              CLEAR ls_trade_notes.

            ENDLOOP.

          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.

* LSCHEPP - Ajuste PIS e COFINS - 14.04.2022 Início
    FIELD-SYMBOLS: <fs_wk_header>   TYPE j_1bnfdoc,
                   <fs_xmli>        TYPE j1b_nf_xml_item,
                   <fs_lt_item_tax> TYPE ty_j_1bnfstx.

    ASSIGN ('(SAPLJ_1B_NFE)WK_HEADER')     TO <fs_wk_header>.
    ASSIGN ('(SAPLJ_1B_NFE)XMLI')          TO <fs_xmli>.
    ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM_TAX[]') TO <fs_lt_item_tax>.

    IF <fs_wk_header> IS ASSIGNED AND
      <fs_xmli> IS ASSIGNED AND
      <fs_lt_item_tax> IS ASSIGNED.

* LSCHEPP - Ajuste processo de industrialização - 13.07.2022 Início
      IF ( <fs_trade_notes> IS ASSIGNED AND NOT <fs_trade_notes> IS INITIAL )
         AND <fs_payment> IS ASSIGNED.
*        IF it_lin-itmtyp EQ 'Z3' OR
*           it_lin-itmtyp EQ 'Z4'.
        CLEAR: <fs_wk_header>-vliq,
               <fs_wk_header>-vorig.
        LOOP AT <fs_trade_notes> ASSIGNING FIELD-SYMBOL(<fs_lines>).
          ADD <fs_lines>-vdup TO <fs_wk_header>-vliq.
          ADD <fs_lines>-vdup TO <fs_wk_header>-vorig.
        ENDLOOP.
        LOOP AT <fs_payment> ASSIGNING FIELD-SYMBOL(<fs_payment1>).
          <fs_payment1>-v_pag = <fs_wk_header>-vliq.
        ENDLOOP.
*        ENDIF.
      ENDIF.
* LSCHEPP - Ajuste processo de industrialização - 13.07.2022 Fim

      LOOP AT <fs_lt_item_tax> ASSIGNING FIELD-SYMBOL(<fs_item_tax>).

        IF <fs_xmli>-p1_cst EQ 01 AND
           <fs_item_tax>-taxtyp EQ 'IPSV' AND
           <fs_item_tax>-itmnum EQ <fs_xmli>-itmnum.
          <fs_xmli>-p1_vbc  = <fs_item_tax>-base.
          <fs_xmli>-p1_ppis = <fs_item_tax>-rate.
          <fs_xmli>-p1_vpis = <fs_item_tax>-taxval.
        ENDIF.

        IF <fs_xmli>-q1_cst EQ 01 AND
           <fs_item_tax>-taxtyp EQ 'ICOV' AND
           <fs_item_tax>-itmnum EQ <fs_xmli>-itmnum.
          <fs_xmli>-q1_vbc     = <fs_item_tax>-base.
          <fs_xmli>-q1_pcofins = <fs_item_tax>-rate.
          <fs_xmli>-q1_vcofins = <fs_item_tax>-taxval.
        ENDIF.

        IF <fs_wk_header>-nftype EQ 'IF' OR
           <fs_wk_header>-nftype EQ 'IE' OR
           <fs_wk_header>-nftype EQ 'YB'.

          IF <fs_xmli>-p4_cst EQ 50 AND
             <fs_item_tax>-taxtyp EQ 'IPSV' AND
             <fs_item_tax>-itmnum EQ <fs_xmli>-itmnum.
            <fs_xmli>-p4_vbc  = <fs_item_tax>-base.
            <fs_xmli>-p4_ppis = <fs_item_tax>-rate.
            <fs_xmli>-p4_vpis = <fs_item_tax>-taxval.
          ENDIF.

          IF <fs_xmli>-q4_cst EQ 50 AND
             <fs_item_tax>-taxtyp EQ 'ICOV' AND
             <fs_item_tax>-itmnum EQ <fs_xmli>-itmnum.
            <fs_xmli>-q4_vbc     = <fs_item_tax>-base.
            <fs_xmli>-q4_pcofins = <fs_item_tax>-rate.
            <fs_xmli>-q4_vcofins = <fs_item_tax>-taxval.
          ENDIF.

        ENDIF.

      ENDLOOP.

      UNASSIGN: <fs_wk_header>,
                <fs_xmli>,
                <fs_lt_item_tax>.

    ENDIF.
* LSCHEPP - Ajuste PIS e COFINS - 14.04.2022 Fim
