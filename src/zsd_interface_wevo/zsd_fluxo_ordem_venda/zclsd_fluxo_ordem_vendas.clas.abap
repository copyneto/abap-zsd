class ZCLSD_FLUXO_ORDEM_VENDAS definition
  public
  final
  create public .

public section.

  types:
      "! Sales Order Flow Return Structure Fields - billingdocumentitembasic
    BEGIN OF ty_billingdocumentitembasic,
        billingdocument     TYPE i_billingdocumentitembasic-billingdocument,
        billingdocumentitem TYPE i_billingdocumentitembasic-billingdocumentitem,
        salesdocumentitem   TYPE i_billingdocumentitembasic-salesdocumentitem,
        billingquantity     TYPE i_billingdocumentitembasic-billingquantity,
        itemnetweight       TYPE i_billingdocumentitembasic-itemnetweight,
      END OF ty_billingdocumentitembasic .
  types:
      "! Sales Order Flow Return Structure Fields - br_nfdocument
    BEGIN OF ty_br_nfdocument,
        br_notafiscal             TYPE i_br_nfdocument-br_notafiscal,
        br_nfenumber              TYPE i_br_nfdocument-br_nfenumber,
        creationdate              TYPE i_br_nfdocument-creationdate,
        br_nfdirection            TYPE i_br_nfdocument-br_nfdirection,
        br_nftotalamount          TYPE i_br_nfdocument-br_nftotalamount,
        br_nfauthznprotocolnumber TYPE i_br_nfdocument-br_nfauthznprotocolnumber,
      END OF ty_br_nfdocument .
  types:
      "! Sales Order Flow Return Structure Fields - br_nfitem
    BEGIN OF ty_br_nfitem,
        br_notafiscal             TYPE i_br_nfitem-br_notafiscal,
        br_notafiscalitem         TYPE i_br_nfitem-br_notafiscalitem,
        br_nftotalamount          TYPE i_br_nfitem-br_nftotalamount,
        br_nfsourcedocumentnumber TYPE i_br_nfitem-br_nfsourcedocumentnumber,
        material                   TYPE i_br_nfitem-material,
      END OF ty_br_nfitem .
  types:
      "! Sales Order Flow Return Structure Fields - br_nfpartner_c
    BEGIN OF ty_br_nfpartner_c,
        br_notafiscal TYPE i_br_nfpartner_c-br_notafiscal,
        br_nfpartner  TYPE i_br_nfpartner_c-br_nfpartner,
      END OF ty_br_nfpartner_c .
  types:
      "! Sales Order Flow Return Structure Fields - Header
    BEGIN OF ty_header,
        nfnum      TYPE i_br_nfdocument-br_nfnumber,
        invoice    TYPE i_billingdocumentitembasic-billingdocument,
        docdat     TYPE i_br_nfdocument-creationdate,
        direct     TYPE i_br_nfdocument-br_nfdirection,
        nftot      TYPE i_br_nfdocument-br_nftotalamount,
        invoicekey TYPE i_br_nfdocument-br_nfauthznprotocolnumber,
        kunnr      TYPE i_br_nfpartner_c-br_nfpartner,
      END OF ty_header .
  types:
      "! Sales Order Flow Return Structure Fields - Items
    BEGIN OF ty_items,
        posnv  TYPE i_billingdocumentitembasic-salesdocumentitem,
        menge  TYPE i_billingdocumentitembasic-billingquantity,
        netwrt TYPE i_br_nfitem-br_nftotalamount,
        fkimg  TYPE i_billingdocumentitembasic-itemnetweight,
        status TYPE c LENGTH 10,
      END OF ty_items .

  data:
    gt_billingdocumentitembasic TYPE TABLE OF ty_billingdocumentitembasic .
  data GS_BILLINGDOCUMENTITEMBASIC type TY_BILLINGDOCUMENTITEMBASIC .
  data:
    gt_br_nfdocument            TYPE TABLE OF ty_br_nfdocument .
  data GS_BR_NFDOCUMENT type TY_BR_NFDOCUMENT .
  data:
    gt_salesdocumentitem            TYPE TABLE OF i_salesdocumentitem .
  data:
    gt_br_nfitem                TYPE TABLE OF ty_br_nfitem .
  data GS_BR_NFITEM type TY_BR_NFITEM .
  data:
    gt_br_nfpartner_c           TYPE TABLE OF ty_br_nfpartner_c .
  data GS_BR_NFPARTNER_C type TY_BR_NFPARTNER_C .
      "! Header Structure from outbound
  data GS_HEADER type TY_HEADER .
      "! Items Structure from outbound
  data GS_ITEMS type TY_ITEMS .
  data GS_FLUXO_ORDEM_VENDA type ZCLSD_DT_STATUS_FLUXO_ORDEM_V3 .
  data GS_FLUXO_ORDEM_VE type ZCLSD_MT_STATUS_FLUXO_ORDEM_VE .
  data GT_T_NFE_DETAILS type ZCLSD_DT_STATUS_FLUXO_ORDE_TAB .
  data GS_T_NFE_DETAILS type ZCLSD_DT_STATUS_FLUXO_ORDEM_V1 .
  data GT_T_ITEMS type ZCLSD_DT_STATUS_FLUXO_ORD_TAB1 .
  data GS_T_ITEMS type ZCLSD_DT_STATUS_FLUXO_ORDEM_V2 .
  data LV_KUNNR type I_BR_NFPARTNER_C-BR_NFPARTNER .
  data:
    GT_SALESDOCUMENT type TABLE of I_SALESDOCUMENT .
  data GT_ACCKEY type TABLE of ZI_CA_VH_ACCKEY .

      "! Get data for handling and return
  methods GET_DATA
    importing
      !IS_FLUXO_ORDEM type ZCLSD_DT_STATUS_FLUXO_ORDEM_V3 optional
    exporting
      !ES_FLUXO_ORDEM_VE type ZCLSD_MT_STATUS_FLUXO_ORDEM_VE .
  PROTECTED SECTION.
private section.

  data GV_FO type FLAG .

      "! Get header data
  methods GET_HEADER_ITEMS .
      "! Fill header data
  methods FILL_HEADER_ITEMS .
  methods GET_FO .
ENDCLASS.



CLASS ZCLSD_FLUXO_ORDEM_VENDAS IMPLEMENTATION.


  METHOD get_data.

    MOVE-CORRESPONDING is_fluxo_ordem TO gs_fluxo_ordem_venda.
    me->get_header_items( ).

    es_fluxo_ordem_ve = gs_fluxo_ordem_ve.
  ENDMETHOD.


  METHOD get_header_items.

    DATA: lr_billingdocument TYPE RANGE OF vbeln_vf,
          ls_billingdocument LIKE LINE OF lr_billingdocument,
          lr_fkart           TYPE RANGE OF fkart,
          lv_salesdocument   TYPE vbeln_va.

    IF gs_fluxo_ordem_venda-vbelv IS NOT INITIAL.

      lv_salesdocument = gs_fluxo_ordem_venda-vbelv.
      UNPACK lv_salesdocument TO lv_salesdocument.
      SELECT *
        FROM i_salesdocument
        WHERE salesdocument EQ @lv_salesdocument
        INTO TABLE @gt_salesdocument.

    ELSEIF gs_fluxo_ordem_venda-bstkd IS NOT INITIAL.

      SELECT *
        FROM i_salesdocument
        WHERE purchaseorderbycustomer EQ @gs_fluxo_ordem_venda-bstkd
        AND   SALESDOCUMENTTYPE       EQ @gs_fluxo_ordem_venda-auart
        INTO TABLE @gt_salesdocument.

    ENDIF.



    IF gt_salesdocument IS NOT INITIAL.

      SELECT *
      FROM i_salesdocumentitem
        FOR ALL ENTRIES IN @gt_salesdocument
        WHERE salesdocument EQ @gt_salesdocument-salesdocument
      INTO TABLE @gt_salesdocumentitem.

      SELECT billingdocument,
             billingdocumentitem,
             salesdocumentitem,
             billingquantity,
             itemnetweight
          FROM i_billingdocumentitembasic
          FOR ALL ENTRIES IN @gt_salesdocument
          WHERE salesdocument EQ @gt_salesdocument-salesdocument
          INTO TABLE @gt_billingdocumentitembasic.
      IF sy-subrc EQ 0.

        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'S1'  ) TO lr_fkart.
        APPEND VALUE #( sign = 'I' option = 'EQ' low = 'YS1' ) TO lr_fkart.


        SELECT vbeln
          FROM vbrk
          FOR ALL ENTRIES IN @gt_billingdocumentitembasic
          WHERE vbeln = @gt_billingdocumentitembasic-billingdocument
          AND   fksto = @space
          AND   fkart NOT IN @lr_fkart
          INTO TABLE @DATA(lt_vbrk).

        LOOP AT gt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>).
          READ TABLE lt_vbrk ASSIGNING FIELD-SYMBOL(<fs_vbrk>) WITH KEY vbeln = <fs_billingdocumentitembasic>-billingdocument.
          IF sy-subrc IS INITIAL.
            lr_billingdocument = VALUE #(  sign = 'I' option = 'EQ' ( low = <fs_billingdocumentitembasic>-billingdocument ) ).
          ELSE.
            DELETE gt_billingdocumentitembasic WHERE billingdocument = <fs_billingdocumentitembasic>-billingdocument.
          ENDIF.
        ENDLOOP.

        IF lr_billingdocument[] IS NOT INITIAL.
          SELECT br_notafiscal,
                 br_notafiscalitem,
                 br_nftotalamount,
                 br_nfsourcedocumentnumber,
                 material
            FROM i_br_nfitem
            WHERE br_nfsourcedocumentnumber IN @lr_billingdocument
            INTO TABLE @gt_br_nfitem.
          IF sy-subrc = 0.
            SELECT br_notafiscal,
                   br_nfenumber,
                   creationdate,
                   br_nfdirection,
                   br_nftotalamount,
                   br_nfauthznprotocolnumber
              FROM i_br_nfdocument
              FOR ALL ENTRIES IN @gt_br_nfitem
              WHERE br_notafiscal EQ @gt_br_nfitem-br_notafiscal
              INTO TABLE @gt_br_nfdocument.
            IF sy-subrc = 0.

            ENDIF.

            SELECT *
              FROM zi_ca_vh_acckey
              FOR ALL ENTRIES IN  @gt_br_nfdocument
              WHERE docnum = @gt_br_nfdocument-br_notafiscal
              INTO TABLE @gt_acckey.

            IF sy-subrc IS INITIAL.
              SORT gt_acckey BY docnum.
            ENDIF.

            SELECT br_notafiscal,
                   br_nfpartner
              FROM i_br_nfpartner_c
              INTO TABLE @gt_br_nfpartner_c
              FOR ALL ENTRIES IN @gt_br_nfdocument
              WHERE br_notafiscal = @gt_br_nfdocument-br_notafiscal
              AND   br_nfpartnerfunction = 'SP'.

          ENDIF.
        ENDIF.
      ENDIF.

      me->get_fo( ).

      me->fill_header_items( ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_header_items.
    DATA: lv_tabix TYPE sy-tabix.
    SORT gt_br_nfitem BY br_notafiscal.
    SORT gt_br_nfpartner_c BY br_notafiscal.
    SORT gt_billingdocumentitembasic BY billingdocument.

    READ TABLE gt_salesdocumentitem ASSIGNING FIELD-SYMBOL(<fs_salesdocumenitem>) INDEX 1.
    IF  <fs_salesdocumenitem> IS ASSIGNED AND <fs_salesdocumenitem>-salesdocumentrjcnreason <> ''.
      APPEND VALUE #(
       status = 'CANCELED'
       ) TO gt_t_items.

      APPEND VALUE #( t_items    = gt_t_items ) TO gt_t_nfe_details.
    ELSE.

      IF gt_billingdocumentitembasic IS INITIAL.
        APPEND VALUE #(
         status = 'NOT BILLED'
         ) TO gt_t_items.

        APPEND VALUE #( t_items    = gt_t_items ) TO gt_t_nfe_details.
      ENDIF.
    ENDIF.

    LOOP AT gt_br_nfdocument ASSIGNING FIELD-SYMBOL(<fs_br_nfdocument>).

      READ TABLE gt_br_nfitem WITH KEY br_notafiscal = <fs_br_nfdocument>-br_notafiscal
                              TRANSPORTING NO FIELDS BINARY SEARCH.
      IF sy-subrc = 0.
        lv_tabix = sy-tabix.
      ENDIF.

      LOOP AT gt_br_nfitem ASSIGNING FIELD-SYMBOL(<fs_br_nfitem>) FROM lv_tabix.
        IF <fs_br_nfdocument>-br_notafiscal NE <fs_br_nfitem>-br_notafiscal.
          EXIT.
        ENDIF.

        gs_items-netwrt = <fs_br_nfitem>-br_nftotalamount.

        READ TABLE gt_billingdocumentitembasic ASSIGNING FIELD-SYMBOL(<fs_billingdocumentitembasic>) WITH KEY billingdocument = <fs_br_nfitem>-br_nfsourcedocumentnumber billingdocumentitem = <fs_br_nfitem>-br_notafiscalitem BINARY SEARCH.
        IF sy-subrc = 0.
          DATA(ls_billingdocumentitembasic) = <fs_billingdocumentitembasic>.
          APPEND VALUE #(
            posnv  = <fs_billingdocumentitembasic>-salesdocumentitem
            menge  = <fs_billingdocumentitembasic>-billingquantity
            netwrt = <fs_br_nfitem>-br_nftotalamount
            fkimg  = <fs_billingdocumentitembasic>-itemnetweight
            status = 'BILLED'
            matnr = <fs_br_nfitem>-material
          ) TO gt_t_items.

        ENDIF.

      ENDLOOP.

      READ TABLE gt_br_nfpartner_c ASSIGNING FIELD-SYMBOL(<fs_br_nfpartner_c>) WITH KEY br_notafiscal = <fs_br_nfdocument>-br_notafiscal BINARY SEARCH.
      IF sy-subrc = 0.
        lv_kunnr = <fs_br_nfpartner_c>-br_nfpartner.
      ENDIF.

      APPEND VALUE #(
          nfnum      = <fs_br_nfdocument>-br_nfenumber
          invoice    = ls_billingdocumentitembasic-billingdocument
          docdat     = <fs_br_nfdocument>-creationdate
          direct     = <fs_br_nfdocument>-br_nfdirection
          nftot      = <fs_br_nfdocument>-br_nftotalamount
          invoicekey = VALUE #( gt_acckey[ docnum = <fs_br_nfdocument>-br_notafiscal ]-acckey OPTIONAL )
          kunnr      = lv_kunnr
          t_items    = gt_t_items
          coletado_transp = gv_fo
      ) TO gt_t_nfe_details.

    ENDLOOP.

    IF gs_fluxo_ordem_venda-vbelv IS NOT INITIAL.
      READ TABLE gt_salesdocument INTO DATA(ls_salesdocument) INDEX 1.
      IF sy-subrc IS INITIAL.
        gs_fluxo_ordem_ve-mt_status_fluxo_ordem_venda_re-vbelv = ls_salesdocument-salesdocument.
        gs_fluxo_ordem_ve-mt_status_fluxo_ordem_venda_re-bstkd = ls_salesdocument-purchaseorderbycustomer.
      ENDIF.
    ELSE.
      READ TABLE gt_salesdocument INTO DATA(ls_salesdocument_aux) WITH KEY salesdocumenttype = 'Z003'.
      IF sy-subrc IS INITIAL.
        gs_fluxo_ordem_ve-mt_status_fluxo_ordem_venda_re-vbelv = ls_salesdocument_aux-salesdocument.
        gs_fluxo_ordem_ve-mt_status_fluxo_ordem_venda_re-bstkd = ls_salesdocument_aux-purchaseorderbycustomer.
      ENDIF.
    ENDIF.

    gs_fluxo_ordem_ve-mt_status_fluxo_ordem_venda_re-t_nfe_details[] = gt_t_nfe_details[].

  ENDMETHOD.


  METHOD get_fo.

    DATA: lt_docflow TYPE tdt_docflow.

    DATA(lt_fatura) = gt_billingdocumentitembasic.

    SORT lt_fatura BY billingdocument.

    DELETE ADJACENT DUPLICATES FROM lt_fatura COMPARING billingdocument.


    LOOP AT lt_fatura ASSIGNING FIELD-SYMBOL(<fs_fatura>).


*      DATA(lv_docnum) = CONV vbeln( <fs_fatura>-billingdocument ).
      DATA(lv_docnum) = <fs_fatura>-billingdocument.

      CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
        EXPORTING
          iv_docnum  = lv_docnum
        IMPORTING
          et_docflow = lt_docflow.

      IF lt_docflow IS NOT INITIAL.

        SORT lt_docflow BY posnn vbtyp_v.

        READ TABLE lt_docflow ASSIGNING FIELD-SYMBOL(<fs_docflow>) WITH KEY posnn = '0000' vbtyp_v = 'J' BINARY SEARCH.
        IF sy-subrc = 0.

          lv_docnum =   <fs_docflow>-docnuv.

          REFRESH lt_docflow.

          CALL FUNCTION 'SD_DOCUMENT_FLOW_GET'
            EXPORTING
              iv_docnum  = lv_docnum
            IMPORTING
              et_docflow = lt_docflow.

          IF lt_docflow IS NOT INITIAL.

            SORT lt_docflow BY posnn vbtyp_n.

            READ TABLE lt_docflow ASSIGNING <fs_docflow> WITH KEY posnn = '0000' vbtyp_n = 'TMFO' BINARY SEARCH.
            IF sy-subrc = 0.
              gv_fo    =  abap_true.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
