CLASS zclsd_devolucoes_vendas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS:
      constructor
        IMPORTING
          is_input TYPE zclsd_mt_devolucao_material
        RAISING
          zcxsd_erro_interface.

  PROTECTED SECTION.
private section.

  types:
    BEGIN OF ty_salesdocument,
             salesdocument        TYPE i_salesdocument-salesdocument,
             salesorganization    TYPE i_salesdocument-salesorganization,
             distributionchannel  TYPE i_salesdocument-distributionchannel,
             organizationdivision TYPE i_salesdocument-organizationdivision,
             creationdate         TYPE i_salesdocument-creationdate,
             sddocumentcategory   TYPE i_salesdocument-sddocumentcategory,
             salesgroup           TYPE i_salesdocument-salesgroup,
             salesoffice          TYPE i_salesdocument-salesoffice,
           END OF ty_salesdocument .
  types:
    BEGIN OF ty_billingdocumentitembasic,
             billingdocument             TYPE i_billingdocumentitembasic-billingdocument,
             billingdocumentitem         TYPE i_billingdocumentitembasic-billingdocumentitem,
             salesdocument               TYPE i_billingdocumentitembasic-salesdocument,
             material                    TYPE i_billingdocumentitembasic-material,
             billingquantity             TYPE i_billingdocumentitembasic-billingquantity,
             plant                       TYPE i_billingdocumentitembasic-plant,
             batch                       TYPE i_billingdocumentitembasic-batch,
             creditrelatedprice          TYPE i_billingdocumentitembasic-creditrelatedprice,
             transactioncurrency         TYPE i_billingdocumentitembasic-transactioncurrency,
             billingquantityunit         TYPE i_billingdocumentitembasic-billingquantityunit,
             billingtobasequantitydnmntr TYPE i_billingdocumentitembasic-billingtobasequantitydnmntr,
           END OF ty_billingdocumentitembasic .
  types:
    BEGIN OF ty_billingdocumentbasic,
             billingdocument            TYPE i_billingdocumentbasic-billingdocument,
             billingdocumentiscancelled TYPE i_billingdocumentbasic-billingdocumentiscancelled,
             salesorganization          TYPE i_billingdocumentbasic-salesorganization,
             distributionchannel        TYPE i_billingdocumentbasic-distributionchannel,
             division                   TYPE i_billingdocumentbasic-division,
             fixedvaluedate             TYPE i_billingdocumentbasic-fixedvaluedate,
             sddocumentcategory         TYPE i_billingdocumentbasic-sddocumentcategory,
           END OF ty_billingdocumentbasic .
  types:
    BEGIN OF ty_vbpa,
             parvw TYPE vbpa-parvw,
             kunnr TYPE vbpa-kunnr,
             lifnr TYPE vbpa-lifnr,
             vbeln TYPE vbpa-vbeln,
             xcpdk TYPE vbpa-xcpdk,
             adrnr TYPE vbpa-adrnr,
           END OF ty_vbpa .

  constants GC_MODULO_SD type ZTCA_PARAM_PAR-MODULO value 'SD' ##NO_TEXT.
  constants GC_CHAVE_WEVO type ZTCA_PARAM_PAR-CHAVE1 value 'WEVO' ##NO_TEXT.
  data GS_INPUT type ZCLSD_MT_DEVOLUCAO_MATERIAL .
  data:
    gt_salesdocument            TYPE TABLE OF ty_salesdocument .
  data:
    gt_billingdocumentitembasic TYPE TABLE OF ty_billingdocumentitembasic .
  data:
    gt_billingdocumentbasic     TYPE TABLE OF ty_billingdocumentbasic .
  data:
    gt_param_val                TYPE TABLE OF ztca_param_val .
  data GS_RETURN_HEADER_IN type BAPISDHD1 .
  data:
    gt_return_items_in          TYPE TABLE OF bapisditm .
  data:
    gt_return_address           TYPE TABLE OF bapiaddr1 .
  data GV_SALESDOCUMENT type BAPIVBELN-VBELN .
  data:
    gt_return                   TYPE TABLE OF bapiret2 .
  data:
    gt_return_schedules_in      TYPE TABLE OF bapischdl .
  data:
    gt_return_partners          TYPE TABLE OF bapiparnr .
  data:
    gt_return_conditions_in     TYPE TABLE OF bapicond .
  data:
    gt_vbpa                     TYPE TABLE OF ty_vbpa .
  data:
    gt_ret                      TYPE STANDARD TABLE OF bapiret2 .
  data:
    gt_partneradr               TYPE TABLE OF bapiaddr1 .

  methods PROCESS_DATA
    raising
      ZCXSD_ERRO_INTERFACE .
  methods EXTRACTOR_DATA
    raising
      ZCXSD_ERRO_INTERFACE .
  methods DEVOL
    raising
      ZCXSD_ERRO_INTERFACE .
  methods PERDA
    raising
      ZCXSD_ERRO_INTERFACE .
  methods DEBIT
    raising
      ZCXSD_ERRO_INTERFACE .
      "! Raising erro
  methods ERRO
    importing
      !IS_ERRO type SCX_T100KEY
    raising
      ZCXSD_ERRO_INTERFACE .
  methods BAPI_COMMIT .
ENDCLASS.



CLASS ZCLSD_DEVOLUCOES_VENDAS IMPLEMENTATION.


  METHOD constructor.

    DATA: lv_item TYPE c LENGTH 6.

    MOVE-CORRESPONDING is_input TO gs_input.

    LOOP AT gs_input-mt_devolucao_material-itens ASSIGNING FIELD-SYMBOL(<fs_input_ite>).
      CLEAR: lv_item.
      lv_item = |{ <fs_input_ite>-itm_number ALPHA = IN }|.
      <fs_input_ite>-itm_number = lv_item.
    ENDLOOP.

    SELECT *
    INTO TABLE @gt_param_val
    FROM ztca_param_val
    WHERE modulo = @gc_modulo_sd
    AND   chave1 = @gc_chave_wevo
    AND   chave3 = @gs_input-mt_devolucao_material-ope_type.

    me->process_data( ).
  ENDMETHOD.


  METHOD devol.

    DATA:
      lv_cond_type TYPE bapicond-cond_type,
      ls_output    TYPE zclsd_mt_status_ordem,
      lv_condvalue TYPE bapikbetr1.

    CONSTANTS:
      lc_kpein TYPE kpein VALUE '0'.

    SORT gt_salesdocument BY salesdocument.
    SORT gt_param_val BY chave1.
    SORT gs_input-mt_devolucao_material-itens BY itm_number.
    SORT gt_vbpa BY vbeln.

    LOOP AT gt_billingdocumentbasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentbasic>).

      IF <fs_billingdocumentbasic>-billingdocumentiscancelled IS INITIAL.

        READ TABLE gt_salesdocument ASSIGNING FIELD-SYMBOL(<fs_salesdocument>) INDEX 1.
        IF sy-subrc = 0.

          gs_return_header_in-doc_type    = gs_input-mt_devolucao_material-doc_type.
          gs_return_header_in-sales_org   = <fs_salesdocument>-salesorganization.
          gs_return_header_in-distr_chan  = <fs_salesdocument>-distributionchannel.
          gs_return_header_in-division    = <fs_salesdocument>-organizationdivision.
          gs_return_header_in-sales_grp   = <fs_salesdocument>-salesgroup.
          gs_return_header_in-sales_off   = <fs_salesdocument>-salesoffice.
          gs_return_header_in-ref_1       = gs_input-mt_devolucao_material-ref_1.
          gs_return_header_in-price_date  = <fs_salesdocument>-creationdate.
          gs_return_header_in-po_method   = 'WEVO'.
          gs_return_header_in-purch_no_c  = gs_input-mt_devolucao_material-purch_no_c.
          gs_return_header_in-pmnttrms    = ''.

          READ TABLE gt_param_val ASSIGNING FIELD-SYMBOL(<fs_dvl_block>) WITH KEY chave2 = TEXT-006 BINARY SEARCH.
          IF sy-subrc = 0.
            gs_return_header_in-dlv_block = <fs_dvl_block>-low.
          ENDIF.

          gs_return_header_in-ord_reason  = gs_input-mt_devolucao_material-ord_reason.
          gs_return_header_in-doc_date = sy-datum.

          "gs_return_header_in-refdoc_cat = <fs_salesdocument>-sddocumentcategory.
          gs_return_header_in-refdoc_cat = <fs_billingdocumentbasic>-sddocumentcategory.

          gs_return_header_in-pymt_meth = gs_input-mt_devolucao_material-pymt_meth.
        ENDIF.

*            READ TABLE gt_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WITH KEY vbeln = <fs_salesdocument>-salesdocument BINARY SEARCH.  "CARD 4517
        LOOP AT gt_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WHERE vbeln = <fs_salesdocument>-salesdocument.
*              IF sy-subrc = 0.
          APPEND VALUE #(
              partn_role = <fs_vbpa>-parvw
              addr_link = <fs_vbpa>-adrnr
              partn_numb = COND #( WHEN <fs_vbpa>-kunnr IS INITIAL THEN <fs_vbpa>-lifnr ELSE <fs_vbpa>-kunnr )
          ) TO gt_return_partners.

          CHECK <fs_vbpa>-xcpdk EQ abap_true.

          SELECT name1 AS name,
                 City1 AS city,
                 city2 AS district,
                 post_code1 AS postl_cod1,
                 street,
                 addrnumber AS addr_no,
                 house_num1 AS house_no,
                 country,
                 region,
                 langu,
                 sort1,
                 taxjurcode,
                 tel_number AS tel1_numbr,
                 house_num2 AS house_no2
            FROM adrc
           WHERE addrnumber = @<fs_vbpa>-adrnr
            INTO CORRESPONDING FIELDS OF TABLE @gt_return_address.


*              ENDIF.
        ENDLOOP.




        LOOP AT gt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>).

          READ TABLE gs_input-mt_devolucao_material-itens ASSIGNING FIELD-SYMBOL(<fs_itens>) WITH KEY itm_number = <fs_billingdocumentitembasic>-billingdocumentitem BINARY SEARCH.
          IF sy-subrc = 0.

            APPEND VALUE #(
                itm_number  = |{ <fs_itens>-itm_number ALPHA = IN }|
                material    = |{ <fs_itens>-material ALPHA = IN }|
                target_qty  = <fs_itens>-target_qty
                ref_doc     = <fs_billingdocumentitembasic>-billingdocument
                ref_doc_it  = <fs_billingdocumentitembasic>-billingdocumentitem
                ref_doc_ca  = <fs_billingdocumentbasic>-sddocumentcategory
                plant       = <fs_billingdocumentitembasic>-plant
                batch       = <fs_billingdocumentitembasic>-batch
            ) TO gt_return_items_in.




            APPEND VALUE #(
                  itm_number = <fs_billingdocumentitembasic>-billingdocumentitem
                  req_qty    = <fs_itens>-target_qty
            ) TO gt_return_schedules_in.


            LOOP AT gt_param_val ASSIGNING FIELD-SYMBOL(<fs_cond_type>) WHERE chave2 = TEXT-009 AND chave3 = TEXT-010.

              SELECT SINGLE knumv
              FROM vbrk
              INTO @DATA(lv_knumv)
              WHERE vbeln = @<fs_billingdocumentbasic>-billingdocument
              .

              IF sy-subrc IS INITIAL.

                SELECT SINGLE kwert, kbetr, kpein
                FROM prcd_elements
                INTO @DATA(ls_prcd_elements)
                WHERE knumv = @lv_knumv
                AND   kposn = @<fs_billingdocumentitembasic>-billingdocumentitem
                AND   kschl = @<fs_cond_type>-low.

                IF ls_prcd_elements-kpein EQ lc_kpein.
                  lv_condvalue = ls_prcd_elements-kwert.
                ELSE.
                  lv_condvalue = ls_prcd_elements-kbetr.
                ENDIF.



                APPEND VALUE #(
                itm_number     = <fs_billingdocumentitembasic>-billingdocumentitem
                cond_type      = <fs_cond_type>-low
                cond_value     = lv_condvalue
                currency       = <fs_billingdocumentitembasic>-transactioncurrency
                cond_unit      = <fs_billingdocumentitembasic>-billingquantityunit
                cond_p_unt     = <fs_billingdocumentitembasic>-billingtobasequantitydnmntr
            ) TO gt_return_conditions_in.
                CLEAR: lv_condvalue, ls_prcd_elements, lv_knumv.

              ENDIF.

******Início Ajuste Cleverson Faria - 18.11.2022******


              IF gs_input-mt_devolucao_material-doc_type EQ 'ZRP3'.

                SELECT SINGLE knumv
                FROM vbrk
                INTO @lv_knumv
                WHERE vbeln = @<fs_billingdocumentbasic>-billingdocument
                 .

                IF sy-subrc IS INITIAL.

                  SELECT SINGLE kwert, kbetr, kpein
                  FROM prcd_elements
                  INTO @ls_prcd_elements
                  WHERE knumv = @lv_knumv
                  AND   kposn = @<fs_billingdocumentitembasic>-billingdocumentitem
                  AND   kschl = 'ZFEC'.

                  lv_condvalue = ls_prcd_elements-kwert  / <fs_billingdocumentitembasic>-billingquantity * <fs_itens>-target_qty.


                ENDIF.

                APPEND VALUE #(
                    itm_number     = <fs_billingdocumentitembasic>-billingdocumentitem
                    cond_type      = 'ZFEC'
                    cond_value     = lv_condvalue
                    currency       = <fs_billingdocumentitembasic>-transactioncurrency
                    cond_unit      = <fs_billingdocumentitembasic>-billingquantityunit
                    cond_p_unt     = <fs_billingdocumentitembasic>-billingtobasequantitydnmntr
                    ) TO gt_return_conditions_in.
                CLEAR: lv_condvalue, ls_prcd_elements, lv_knumv.
              ENDIF.

          ENDLOOP.

          gs_return_header_in-ref_doc = <fs_billingdocumentitembasic>-billingdocument.
        ENDIF.
      ENDLOOP.

      IF gs_input-mt_devolucao_material-doc_type EQ 'ZR03'.

        SELECT SINGLE knumv
        FROM vbak
        INTO @lv_knumv
        WHERE vbeln = @<fs_salesdocument>-salesdocument
         .

          IF sy-subrc IS INITIAL.

            SELECT SINGLE kwert, kbetr, kpein
            FROM prcd_elements
            INTO @ls_prcd_elements
            WHERE knumv = @lv_knumv
            AND   kposn = ''
            AND   kschl = 'ZFEC'.

              lv_condvalue = ls_prcd_elements-kbetr.


            ENDIF.


            APPEND VALUE #(
                itm_number     = '000000'
                cond_type      = 'ZFEC'
                cond_value     = lv_condvalue
                currency       = <fs_billingdocumentitembasic>-transactioncurrency
                cond_unit      = <fs_billingdocumentitembasic>-billingquantityunit
                cond_p_unt     = <fs_billingdocumentitembasic>-billingtobasequantitydnmntr
            ) TO gt_return_conditions_in.
            CLEAR: lv_condvalue, ls_prcd_elements, lv_knumv.

          ENDIF.



******Final Ajuste Cleverson Faria - 18.11.2022******

          CALL FUNCTION 'BAPI_CUSTOMERRETURN_CREATE'
            EXPORTING
              return_header_in     = gs_return_header_in
            IMPORTING
              salesdocument        = gv_salesdocument
            TABLES
              return               = gt_ret
              return_items_in      = gt_return_items_in
              return_partners      = gt_return_partners
              return_schedules_in  = gt_return_schedules_in
              return_conditions_in = gt_return_conditions_in
              partneraddresses     = gt_return_address.

          IF ( line_exists( gt_ret[ type = 'E' ] ) ) OR  "#EC CI_STDSEQ
             ( line_exists( gt_ret[ type = 'E' ] ) ).    "#EC CI_STDSEQ

            me->erro( VALUE scx_t100key( msgid = gt_ret[ 1 ]-id
                                         msgno = gt_ret[ 1 ]-number
                                         attr1 = gt_ret[ 1 ]-message
                                         attr2 = gt_ret[ 1 ]-message_v1
                                         attr3 = gt_ret[ 1 ]-message_v2
                                         attr4 = gt_ret[ 1 ]-message_v3
                                          ) ).

          ELSE.

            IF gv_salesdocument IS NOT INITIAL.
              ls_output-mt_status_ordem-salesdocum = gv_salesdocument.
              ls_output-mt_status_ordem-purch_no_c = gs_return_header_in-purch_no_c.
              ls_output-mt_status_ordem-auart = gs_return_header_in-doc_type.
              TRY.
                  NEW zclsd_co_si_enviar_status_orde( )->si_enviar_status_ordem_out( output = ls_output ).
                CATCH cx_ai_system_fault INTO DATA(lo_system_fault).
                  DATA(lv_msg) = lo_system_fault->get_longtext( ).
              ENDTRY.

            ENDIF.

            me->bapi_commit(  ).
          ENDIF.

        ELSE.
          me->erro( VALUE scx_t100key( msgid = TEXT-001
                                       msgno = '001'
                                       attr1 = TEXT-002
          ) ).

        ENDIF.

      ENDLOOP.


    ENDMETHOD.


  METHOD perda.

    DATA: ls_order_header_in    TYPE bapisdhd1,
          lt_order_items_in     TYPE TABLE OF bapisditm,
          lt_order_partners     TYPE TABLE OF bapiparnr,
          lt_order_schedules_in TYPE TABLE OF bapischdl,
          lt_ret                TYPE STANDARD TABLE OF bapiret2.

    SORT gt_param_val BY chave1.
    SORT gs_input-mt_devolucao_material-itens BY itm_number.
    SORT gt_vbpa BY vbeln.
    LOOP AT gt_billingdocumentbasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentbasic>).

      IF <fs_billingdocumentbasic>-billingdocumentiscancelled IS INITIAL.

        READ TABLE gt_salesdocument ASSIGNING FIELD-SYMBOL(<fs_salesdocument>) INDEX 1.
        IF sy-subrc = 0.

*         READ TABLE gt_param_val ASSIGNING FIELD-SYMBOL(<fs_cond_type>) WITH KEY chave2 = TEXT-005 BINARY SEARCH.
*          IF sy-subrc = 0.
*            ls_order_header_in-doc_type = <fs_cond_type>-low.
*          ENDIF.

          ls_order_header_in-doc_type    = 'Y024'.
          ls_order_header_in-sales_org   = <fs_billingdocumentbasic>-salesorganization.
          ls_order_header_in-distr_chan  = <fs_billingdocumentbasic>-distributionchannel.
          ls_order_header_in-division    = <fs_billingdocumentbasic>-division.
          ls_order_header_in-price_date  = <fs_billingdocumentbasic>-fixedvaluedate.
          ls_order_header_in-po_method   = 'WEVO'.
          ls_order_header_in-purch_no_c  = gs_input-mt_devolucao_material-purch_no_c.
          ls_order_header_in-ord_reason  = gs_input-mt_devolucao_material-ord_reason.
          ls_order_header_in-sales_grp   = <fs_salesdocument>-salesgroup.
          ls_order_header_in-sales_off   = <fs_salesdocument>-salesoffice.
          ls_order_header_in-ref_1       = gs_input-mt_devolucao_material-ref_1.
          ls_order_header_in-price_date  = <fs_salesdocument>-creationdate.
          ls_order_header_in-purch_date  = sy-datum.

        ENDIF.

        LOOP AT gt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>).

          READ TABLE gs_input-mt_devolucao_material-itens ASSIGNING FIELD-SYMBOL(<fs_itens>) WITH KEY itm_number = <fs_billingdocumentitembasic>-billingdocumentitem BINARY SEARCH.
          IF sy-subrc = 0.

            APPEND VALUE #(
                itm_number  = <fs_itens>-itm_number
                material    = |{ <fs_itens>-material ALPHA = IN }|
                target_qty  = <fs_itens>-target_qty
                plant       = <fs_billingdocumentitembasic>-plant
            ) TO lt_order_items_in.

            APPEND VALUE #(
                  itm_number = <fs_billingdocumentitembasic>-billingdocumentitem
                  req_qty    = <fs_billingdocumentitembasic>-billingquantity
            ) TO lt_order_schedules_in.

          ENDIF.
        ENDLOOP.

        READ TABLE gt_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WITH KEY vbeln = <fs_billingdocumentitembasic>-billingdocument BINARY SEARCH.
        IF sy-subrc = 0.
          APPEND VALUE #(
              partn_role = <fs_vbpa>-parvw
              partn_numb = <fs_vbpa>-kunnr
          ) TO lt_order_partners.
        ENDIF.


        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            order_header_in    = ls_order_header_in
          IMPORTING
            salesdocument      = gv_salesdocument
          TABLES
            return             = lt_ret
            order_items_in     = lt_order_items_in
            order_partners     = lt_order_partners
            order_schedules_in = lt_order_schedules_in.


        IF ( line_exists( lt_ret[ type = 'E' ] ) ) OR    "#EC CI_STDSEQ
           ( line_exists( lt_ret[ type = 'E' ] ) ).      "#EC CI_STDSEQ

          me->erro( VALUE scx_t100key( msgid = lt_ret[ 1 ]-id
                                       msgno = lt_ret[ 1 ]-number
                                       attr1 = lt_ret[ 1 ]-message
                                       attr2 = lt_ret[ 1 ]-message_v1
                                       attr3 = lt_ret[ 1 ]-message_v2
                                       attr4 = lt_ret[ 1 ]-message_v3
                                        ) ).

        ELSE.
          me->bapi_commit(  ).
        ENDIF.

        IF gv_salesdocument IS INITIAL.

          me->erro( VALUE scx_t100key( msgid = TEXT-001
                                       msgno = '001'
                                       attr1 = TEXT-002
          ) ).

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD debit.

    DATA: ls_order_header_in     TYPE bapisdhd1,
          lt_order_items_in      TYPE TABLE OF bapisditm,
          lt_order_partners      TYPE TABLE OF bapiparnr,
          lt_order_schedules_in  TYPE TABLE OF bapischdl,
          lt_order_conditions_in TYPE TABLE OF bapicond,
          lt_ret                 TYPE STANDARD TABLE OF bapiret2,
          lv_condvalue           TYPE bapikbetr1.

    CONSTANTS:
    lc_kpein TYPE kpein VALUE '0'.

    SORT gt_param_val BY chave1.
    SORT gs_input-mt_devolucao_material-itens BY itm_number.
    SORT gt_vbpa BY vbeln.
    LOOP AT gt_billingdocumentbasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentbasic>).

      IF <fs_billingdocumentbasic>-billingdocumentiscancelled IS INITIAL.

        READ TABLE gt_salesdocument ASSIGNING FIELD-SYMBOL(<fs_salesdocument>) INDEX 1.
        IF sy-subrc = 0.

          ls_order_header_in-doc_type    = 'Z012'.
          ls_order_header_in-sales_org   = <fs_billingdocumentbasic>-salesorganization.
          ls_order_header_in-distr_chan  = <fs_billingdocumentbasic>-distributionchannel.
          ls_order_header_in-division    = <fs_billingdocumentbasic>-division.
          ls_order_header_in-price_date  = <fs_billingdocumentbasic>-fixedvaluedate.
          ls_order_header_in-po_method   = 'WEVO'.
          ls_order_header_in-purch_no_c  = gs_input-mt_devolucao_material-purch_no_c.
          ls_order_header_in-pmnttrms    = ''.
          ls_order_header_in-ord_reason  = gs_input-mt_devolucao_material-ord_reason.
          ls_order_header_in-purch_date  = sy-datum.
          ls_order_header_in-ref_doc     = <fs_billingdocumentbasic>-billingdocument.
*          ls_order_header_in-refdoc_cat  = <fs_salesdocument>-sddocumentcategory.
          ls_order_header_in-refdoc_cat = 'M'.
          ls_order_header_in-pymt_meth   = gs_input-mt_devolucao_material-pymt_meth.

        ENDIF.

        LOOP AT gt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>).

          READ TABLE gs_input-mt_devolucao_material-itens ASSIGNING FIELD-SYMBOL(<fs_itens>) WITH KEY itm_number = <fs_billingdocumentitembasic>-billingdocumentitem BINARY SEARCH.
          IF sy-subrc = 0.

            APPEND VALUE #(
                itm_number  = <fs_itens>-itm_number
                material    = |{ <fs_itens>-material ALPHA = IN }|
                target_qty  = <fs_itens>-target_qty
*                ref_doc     = gs_input-mt_devolucao_material-ref_doc
*                ref_doc_it  = <fs_billingdocumentitembasic>-billingdocumentitem
*                ref_doc_ca  = <fs_salesdocument>-sddocumentcategory
                  ref_doc     = <fs_billingdocumentitembasic>-billingdocument
                  ref_doc_it  = <fs_billingdocumentitembasic>-billingdocumentitem
                  plant       = <fs_billingdocumentitembasic>-plant
                  ref_doc_ca  = 'M'
            ) TO lt_order_items_in.

            APPEND VALUE #(
                  itm_number = <fs_billingdocumentitembasic>-billingdocumentitem
*                  req_qty    = <fs_billingdocumentitembasic>-billingquantity
                  req_qty    = <fs_itens>-target_qty
            ) TO lt_order_schedules_in.

            READ TABLE gt_vbpa ASSIGNING FIELD-SYMBOL(<fs_vbpa>) WITH KEY vbeln = <fs_billingdocumentbasic>-billingdocument BINARY SEARCH.
            IF sy-subrc = 0.
              APPEND VALUE #(
                  partn_role = 'AG'
*                  partn_numb = <fs_vbpa>-kunnr
                  partn_numb = <fs_vbpa>-lifnr
              ) TO lt_order_partners.
            ENDIF.


******Início Ajuste Cleverson Faria - 10.01.2023********

*            READ TABLE gt_param_val ASSIGNING FIELD-SYMBOL(<fs_cond_type>) WITH KEY chave2 = TEXT-009 BINARY SEARCH.
*            APPEND VALUE #(
*                  itm_number = <fs_billingdocumentitembasic>-billingdocumentitem
*                  cond_type  = 'ZPR0'
*                  cond_value = gs_input-mt_devolucao_material-cond_value_tot
*                  currency   = 'BRL'
*            ) TO lt_order_conditions_in.


            LOOP AT gt_param_val ASSIGNING FIELD-SYMBOL(<fs_cond_type>) WHERE chave2 = TEXT-009 AND chave3 = 'DEBIT'.

              SELECT SINGLE knumv
              FROM vbrk
              INTO @DATA(lv_knumv)
              WHERE vbeln = @<fs_billingdocumentbasic>-billingdocument
              .

              IF sy-subrc IS INITIAL.

                SELECT SINGLE kwert, kbetr, kpein
                FROM prcd_elements
                INTO @DATA(ls_prcd_elements)
                WHERE knumv = @lv_knumv
                AND   kposn = @<fs_billingdocumentitembasic>-billingdocumentitem
                AND   kschl = @<fs_cond_type>-low.

                IF ls_prcd_elements-kpein EQ lc_kpein.
                  lv_condvalue = ls_prcd_elements-kwert / 10.
                ELSE.
                  lv_condvalue = ls_prcd_elements-kbetr / 10.
                ENDIF.



                APPEND VALUE #(
                itm_number     = <fs_billingdocumentitembasic>-billingdocumentitem
                cond_type      = <fs_cond_type>-low
                cond_value     = lv_condvalue
                currency       = <fs_billingdocumentitembasic>-transactioncurrency
                cond_unit      = <fs_billingdocumentitembasic>-billingquantityunit
                cond_p_unt     = <fs_billingdocumentitembasic>-billingtobasequantitydnmntr
            ) TO gt_return_conditions_in.
                CLEAR: lv_condvalue, ls_prcd_elements, lv_knumv.

              ENDIF.



*              IF gs_input-mt_devolucao_material-doc_type EQ 'Z012'.

*                SELECT SINGLE knumv
*                FROM vbrk
*                INTO @lv_knumv
*                WHERE vbeln = @<fs_billingdocumentbasic>-billingdocument
                 .

*               IF sy-subrc IS INITIAL.

*                  SELECT SINGLE kwert, kbetr, kpein
*                  FROM prcd_elements
*                  INTO @ls_prcd_elements
*                  WHERE knumv = @lv_knumv
*                  AND   kposn = @<fs_billingdocumentitembasic>-billingdocumentitem.
*                  AND   kschl = 'ZFEC'.

*                  lv_condvalue = ( ls_prcd_elements-kwert  / <fs_billingdocumentitembasic>-billingquantity * <fs_itens>-target_qty ) / 10..


*                ENDIF.

*                APPEND VALUE #(
*                    itm_number     = <fs_billingdocumentitembasic>-billingdocumentitem
*                    cond_type      = 'ZFEC'
*                    cond_value     = lv_condvalue
*                    currency       = <fs_billingdocumentitembasic>-transactioncurrency
*                    cond_unit      = <fs_billingdocumentitembasic>-billingquantityunit
*                    cond_p_unt     = <fs_billingdocumentitembasic>-billingtobasequantitydnmntr
*                    ) TO gt_return_conditions_in.
*                CLEAR: lv_condvalue, ls_prcd_elements, lv_knumv.
*              ENDIF.

            ENDLOOP.

******FIM Ajuste Cleverson Faria - 10.01.2023********

          ENDIF.
        ENDLOOP.



        CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
          EXPORTING
            order_header_in     = ls_order_header_in
          IMPORTING
            salesdocument       = gv_salesdocument
          TABLES
            return              = lt_ret
            order_items_in      = lt_order_items_in
            order_partners      = lt_order_partners
            order_schedules_in  = lt_order_schedules_in
            order_conditions_in = gt_return_conditions_in.
        IF ( line_exists( lt_ret[ type = 'E' ] ) ) OR    "#EC CI_STDSEQ
           ( line_exists( lt_ret[ type = 'E' ] ) ).      "#EC CI_STDSEQ

          me->erro( VALUE scx_t100key( msgid = lt_ret[ 1 ]-id
                                       msgno = lt_ret[ 1 ]-number
                                       attr1 = lt_ret[ 1 ]-message
                                       attr2 = lt_ret[ 1 ]-message_v1
                                       attr3 = lt_ret[ 1 ]-message_v2
                                       attr4 = lt_ret[ 1 ]-message_v3
                                        ) ).

        ELSE.
          me->bapi_commit(  ).
        ENDIF.

      ELSE.
        me->erro( VALUE scx_t100key( msgid = TEXT-001
                                     msgno = '001'
                                     attr1 = TEXT-002
        ) ).

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD process_data.

    me->extractor_data( ).

  ENDMETHOD.


  METHOD erro.

    RAISE EXCEPTION TYPE zcxsd_erro_interface
      EXPORTING
        textid = is_erro.

  ENDMETHOD.


  METHOD bapi_commit.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD extractor_data.

    SPLIT gs_input-mt_devolucao_material-purch_no_c AT '|' INTO DATA(lv_purch_no_c)
                                                                DATA(lv_dummy).

    IF gs_input-mt_devolucao_material-ope_type = 'DEVOL'.

      SELECT salesdocument,
             salesorganization,
             distributionchannel,
             organizationdivision,
             creationdate,
             sddocumentcategory,
             salesgroup,
             salesoffice
      INTO TABLE @gt_salesdocument
      FROM i_salesdocument
      WHERE purchaseorderbycustomer EQ @lv_purch_no_c.
      IF sy-subrc = 0.
        SELECT billingdocument,
               billingdocumentitem,
               salesdocument,
               material,
               billingquantity,
               plant,
               batch,
               creditrelatedprice,
               transactioncurrency,
               billingquantityunit,
               billingtobasequantitydnmntr
            INTO TABLE @gt_billingdocumentitembasic
            FROM i_billingdocumentitembasic
            FOR ALL ENTRIES IN @gt_salesdocument
            WHERE salesdocument = @gt_salesdocument-salesdocument.
        IF sy-subrc = 0.

          SELECT billingdocument,
                 billingdocumentiscancelled,
                 salesorganization,
                 distributionchannel,
                 division,
                 fixedvaluedate,
                 sddocumentcategory
              INTO TABLE @gt_billingdocumentbasic
              FROM i_billingdocumentbasic
              FOR ALL ENTRIES IN @gt_billingdocumentitembasic
              WHERE billingdocument = @gt_billingdocumentitembasic-billingdocument.
          IF sy-subrc = 0.
*            SORT gt_param_val BY chave1.
*            READ TABLE gt_param_val ASSIGNING FIELD-SYMBOL(<fs_partn_role_devol>) WITH KEY chave2 = TEXT-007 BINARY SEARCH.
*            IF sy-subrc = 0.

            SELECT parvw,
                   kunnr,
                   lifnr,
                   vbeln,
                   xcpdk,
                   adrnr
                INTO TABLE @gt_vbpa
                FROM vbpa
                FOR ALL ENTRIES IN @gt_salesdocument
                WHERE vbeln = @gt_salesdocument-salesdocument.
*                AND parvw = 'AG'.

*            ENDIF.

            me->devol( ).

          ELSE.

            me->erro( VALUE scx_t100key( msgid = TEXT-001
                                         msgno = '001'
                                         attr1 = TEXT-005
            ) ).

          ENDIF.


        ELSE.

          me->erro( VALUE scx_t100key( msgid = TEXT-001
                                       msgno = '001'
                                       attr1 = TEXT-004
          ) ).

        ENDIF.


      ELSE.

        me->erro( VALUE scx_t100key( msgid = TEXT-001
                                     msgno = '001'
                                     attr1 = TEXT-003
        ) ).


      ENDIF.

    ENDIF.

    IF gs_input-mt_devolucao_material-ope_type = 'PERDA'.


      SELECT salesdocument,
                  salesorganization,
                  distributionchannel,
                  organizationdivision,
                  creationdate,
                  sddocumentcategory,
                  salesgroup,
                  salesoffice
           INTO TABLE @gt_salesdocument
           FROM i_salesdocument
           WHERE purchaseorderbycustomer EQ @lv_purch_no_c
           AND salesdocumenttype = 'Z003'.
      IF sy-subrc = 0.
        SELECT billingdocument,
               billingdocumentitem,
               salesdocument,
               material,
               billingquantity,
               plant,
               batch,
               creditrelatedprice,
               transactioncurrency,
               billingquantityunit,
               billingtobasequantitydnmntr
            INTO TABLE @gt_billingdocumentitembasic
            FROM i_billingdocumentitembasic
            FOR ALL ENTRIES IN @gt_salesdocument
            WHERE salesdocument = @gt_salesdocument-salesdocument.
        IF sy-subrc = 0.

          SELECT billingdocument,
                 billingdocumentiscancelled,
                 salesorganization,
                 distributionchannel,
                 division,
                 fixedvaluedate,
                 sddocumentcategory
              INTO TABLE @gt_billingdocumentbasic
              FROM i_billingdocumentbasic
              FOR ALL ENTRIES IN @gt_billingdocumentitembasic
              WHERE billingdocument = @gt_billingdocumentitembasic-billingdocument.

          IF gt_billingdocumentbasic IS NOT INITIAL.

            SELECT parvw,
                   kunnr,
                   lifnr,
                   vbeln,
                   xcpdk,
                   adrnr
              INTO TABLE @gt_vbpa
              FROM vbpa
              FOR ALL ENTRIES IN @gt_billingdocumentbasic
              WHERE vbeln = @gt_billingdocumentbasic-billingdocument
              AND parvw = 'AG'.

          ENDIF.
        ENDIF.
      ENDIF.

      IF sy-subrc = 0.

        me->perda( ).

      ELSE.

        me->erro( VALUE scx_t100key( msgid = TEXT-001
                                     msgno = '001'
                                     attr1 = TEXT-005
        ) ).

      ENDIF.

    ENDIF.

    IF gs_input-mt_devolucao_material-ope_type = 'DEBIT'.

      SELECT salesdocument,
             salesorganization,
             distributionchannel,
             organizationdivision,
             creationdate,
             sddocumentcategory,
             salesgroup,
             salesoffice
      INTO TABLE @gt_salesdocument
      FROM i_salesdocument
      WHERE purchaseorderbycustomer EQ @lv_purch_no_c.
      IF sy-subrc = 0.

        SELECT billingdocument,
               billingdocumentitem,
               salesdocument,
               material,
               billingquantity,
               Plant
        INTO TABLE @gt_billingdocumentitembasic
        FROM i_billingdocumentitembasic
        FOR ALL ENTRIES IN @gt_salesdocument
        WHERE salesdocument = @gt_salesdocument-salesdocument.
        IF sy-subrc = 0.

          SELECT billingdocument,
                 billingdocumentiscancelled,
                 salesorganization,
                 distributionchannel,
                 division,
                 fixedvaluedate
            INTO TABLE @gt_billingdocumentbasic
            FROM i_billingdocumentbasic
            FOR ALL ENTRIES IN @gt_billingdocumentitembasic
            WHERE billingdocument = @gt_billingdocumentitembasic-billingdocument.
          IF sy-subrc = 0.

            SORT gt_param_val BY chave1.
*            READ TABLE gt_param_val ASSIGNING FIELD-SYMBOL(<fs_partn_role_debit>) WITH KEY chave2 = TEXT-008 BINARY SEARCH.
            IF sy-subrc = 0.

              SELECT parvw,
                     kunnr,
                     lifnr,
                     vbeln,
                     xcpdk,
                     adrnr
                  INTO TABLE @gt_vbpa
                  FROM vbpa
                  FOR ALL ENTRIES IN @gt_billingdocumentbasic
                  WHERE vbeln = @gt_billingdocumentbasic-billingdocument
*                  AND parvw = 'AG'.
                  AND parvw = 'SP'.
            ENDIF.

            me->debit( ).

          ELSE.

            me->erro( VALUE scx_t100key( msgid = TEXT-001
                                         msgno = '001'
                                         attr1 = TEXT-005
            ) ).

          ENDIF.


        ELSE.

          me->erro( VALUE scx_t100key( msgid = TEXT-001
                                       msgno = '001'
                                       attr1 = TEXT-004
          ) ).

        ENDIF.

      ELSE.

        me->erro( VALUE scx_t100key( msgid = TEXT-001
                                     msgno = '001'
                                     attr1 = TEXT-003
        ) ).

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
