"!<p><h2>ZCLSD_PROCESSO_INDUST</h2></p>
"! Processo de Industrialização entre Filiais <br/>
"! <br/>
"!<p><strong>Autor:</strong> Willian Hazor</p>
"!<p><strong>Data:</strong> 24 de Março de 2022</p>
class ZCLSD_PROCESSO_INDUST definition
  public
  final
  create public .

public section.

      "! Mantém Saldo de materiais
      "! @parameter IS_HEADER |Cabeçalho da nota
      "! @parameter IT_NFLIN |Itens da Nota
  methods CALCULA_SALDO
    importing
      !IS_HEADER type J_1BNFDOC
      !IT_NFLIN type J_1BNFLIN_TAB .
  methods EXIT_CRIACAO_ORDEM_VENDA
    importing
      !IS_EKKO type EKKO
      !IV_VORGA type VORGA
      !IS_EKKO_OLD type EKKO
      !IT_EKPO type MEOUT_T_UEKPO .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_PROCESSO_INDUST IMPLEMENTATION.


  METHOD calcula_saldo.
    TYPES:
      BEGIN OF ty_inds_filiais_key,
        matnr TYPE matnr,
        werks TYPE werks_d,
        menge TYPE j_1bnetqty,
      END OF ty_inds_filiais_key.

    DATA: ls_zsd_inds_filiais     TYPE zsd_inds_filiais,
          lt_zsd_inds_filiais_ins TYPE TABLE OF zsd_inds_filiais,
          lt_zsd_inds_filiais_atu TYPE TABLE OF zsd_inds_filiais,
          lt_zsd_inds_filiais     TYPE TABLE OF zsd_inds_filiais,
          lt_inds_filiais_key     TYPE TABLE OF ty_inds_filiais_key,
          ls_inds_filiais_key     TYPE ty_inds_filiais_key.

    IF is_header-code = '100'.

      LOOP AT it_nflin ASSIGNING FIELD-SYMBOL(<fs_nflin>).
        IF <fs_nflin>-cfop = '5901/AA' OR <fs_nflin>-cfop = '6901/AA'.
          ls_zsd_inds_filiais-docnum     = <fs_nflin>-docnum.
          ls_zsd_inds_filiais-nfenum     = is_header-nfenum.
          ls_zsd_inds_filiais-series     = is_header-series.
          ls_zsd_inds_filiais-pstdat     = is_header-pstdat.
          ls_zsd_inds_filiais-matnr      = <fs_nflin>-matnr.
          ls_zsd_inds_filiais-werks      = <fs_nflin>-werks.
          ls_zsd_inds_filiais-nfenum_pro = is_header-nfenum.
          ls_zsd_inds_filiais-netwr      = <fs_nflin>-netwr.
          ls_zsd_inds_filiais-waerk      = is_header-waerk.
          ls_zsd_inds_filiais-meins      = <fs_nflin>-meins.
          ls_zsd_inds_filiais-menge_ori  = 0.
          ls_zsd_inds_filiais-menge_proc = <fs_nflin>-menge.
          ls_zsd_inds_filiais-saldo      = <fs_nflin>-menge.
          COLLECT ls_zsd_inds_filiais INTO lt_zsd_inds_filiais_ins.
        ENDIF.

        IF <fs_nflin>-cfop = '5902/AA' OR <fs_nflin>-cfop = '6902/AA'.
          ls_inds_filiais_key-matnr = <fs_nflin>-matnr.
          ls_inds_filiais_key-werks = <fs_nflin>-werks.
          ls_inds_filiais_key-menge = <fs_nflin>-menge.
          COLLECT ls_inds_filiais_key INTO lt_inds_filiais_key.
        ENDIF.
      ENDLOOP.

      SORT lt_inds_filiais_key. DELETE ADJACENT DUPLICATES FROM lt_inds_filiais_key.

      IF lt_inds_filiais_key IS NOT INITIAL.
        SELECT *
           FROM zsd_inds_filiais
           INTO TABLE lt_zsd_inds_filiais
           FOR ALL ENTRIES IN lt_inds_filiais_key
           WHERE matnr = lt_inds_filiais_key-matnr
             AND werks = lt_inds_filiais_key-werks
             AND saldo > 0.
      ENDIF.

      SORT lt_zsd_inds_filiais BY matnr werks.

      LOOP AT lt_inds_filiais_key ASSIGNING FIELD-SYMBOL(<fs_inds_filiais_key>).
        READ TABLE lt_zsd_inds_filiais INTO ls_zsd_inds_filiais WITH KEY matnr = <fs_inds_filiais_key>-matnr
                                                                         werks = <fs_inds_filiais_key>-werks BINARY SEARCH.

        IF sy-subrc = 0.
          ls_zsd_inds_filiais-nfenum_pro = is_header-nfenum.
          ls_zsd_inds_filiais-menge_ori  = ls_zsd_inds_filiais-saldo.
          ls_zsd_inds_filiais-saldo      = ls_zsd_inds_filiais-saldo - <fs_inds_filiais_key>-menge.
          APPEND ls_zsd_inds_filiais TO lt_zsd_inds_filiais_atu.
        ELSE.
          READ TABLE it_nflin ASSIGNING <fs_nflin> WITH KEY matnr = <fs_inds_filiais_key>-matnr
                                                            werks = <fs_inds_filiais_key>-werks BINARY SEARCH.

          IF <fs_nflin> IS ASSIGNED.

            ls_zsd_inds_filiais-docnum     = <fs_nflin>-docnum.
            ls_zsd_inds_filiais-nfenum     = is_header-nfenum.
            ls_zsd_inds_filiais-series     = is_header-series.
            ls_zsd_inds_filiais-pstdat     = is_header-pstdat.
            ls_zsd_inds_filiais-matnr      = <fs_nflin>-matnr.
            ls_zsd_inds_filiais-werks      = <fs_nflin>-werks.
            ls_zsd_inds_filiais-nfenum_pro = is_header-nfenum.
            ls_zsd_inds_filiais-netwr      = <fs_nflin>-netwr.
            ls_zsd_inds_filiais-waerk      = is_header-waerk.
            ls_zsd_inds_filiais-meins      = <fs_nflin>-meins.
            ls_zsd_inds_filiais-menge_ori  = 0.
            ls_zsd_inds_filiais-menge_proc = <fs_nflin>-menge.
            ls_zsd_inds_filiais-saldo      = <fs_nflin>-menge * -1.
            APPEND ls_zsd_inds_filiais TO lt_zsd_inds_filiais_ins.
          ENDIF.
        ENDIF.
      ENDLOOP.

      IF lt_zsd_inds_filiais_ins IS NOT INITIAL.
        MODIFY zsd_inds_filiais FROM TABLE lt_zsd_inds_filiais_ins.
      ENDIF.
      IF lt_zsd_inds_filiais_atu IS NOT INITIAL.
        MODIFY zsd_inds_filiais FROM TABLE lt_zsd_inds_filiais_atu.
      ENDIF.
    ENDIF.

    IF is_header-code = '101' OR is_header-code = '102'  OR is_header-code = '103'.
      LOOP AT it_nflin ASSIGNING <fs_nflin>.
        ls_inds_filiais_key-matnr = <fs_nflin>-matnr.
        ls_inds_filiais_key-werks = <fs_nflin>-werks.
        APPEND ls_inds_filiais_key TO lt_inds_filiais_key.
      ENDLOOP.

      SELECT *
         FROM zsd_inds_filiais
         INTO TABLE lt_zsd_inds_filiais
         FOR ALL ENTRIES IN lt_inds_filiais_key
         WHERE matnr = lt_inds_filiais_key-matnr
           AND werks = lt_inds_filiais_key-werks
           AND nfenum_pro = is_header-nfenum.

      IF lt_zsd_inds_filiais IS NOT INITIAL.
        DELETE zsd_inds_filiais FROM TABLE lt_zsd_inds_filiais.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD exit_criacao_ordem_venda.

    CONSTANTS: lc_bstyp_l        LIKE is_ekko-bstyp VALUE 'C',
               lc_bstyp_3        LIKE is_ekko-bstyp VALUE '3',
               lc_modulo_sd      TYPE ze_param_modulo VALUE 'SD',
               lc_chave1_lifnr   TYPE ze_param_chave VALUE 'LIFNR',
               lc_doc_type_z025  TYPE auart VALUE 'Z025',
               lc_sales_org_2000 TYPE vkorg VALUE '2000',
               lc_distr_chan_10  TYPE vtweg VALUE '10',
               lc_division_99    TYPE spart VALUE '99',
               lc_partn_role     TYPE parvw VALUE 'AG',
               lc_cond_type_zpr0 TYPE kscha VALUE 'ZPR0'.


    TYPES: BEGIN OF ty_range_lifnr,
             sign TYPE ddsign,
             opt  TYPE ddoption,
             low  TYPE ze_param_low,
             high TYPE  ze_param_high,
           END OF ty_range_lifnr,
           BEGIN OF ty_vbak,
             bstnk TYPE bstnk,
             abstk TYPE abstk,
           END OF ty_vbak.

    DATA: lt_range TYPE TABLE OF ty_range_lifnr,
          ls_vbak  TYPE ty_vbak.

    CHECK is_ekko-bstyp = lc_bstyp_3.

    SELECT sign opt low high
      FROM ztca_param_val
      INTO TABLE lt_range
      WHERE modulo = lc_modulo_sd
        AND chave1 = lc_chave1_lifnr.

    CHECK lt_range IS NOT INITIAL.

    CHECK is_ekko-lifnr IN lt_range.

    IF is_ekko-loekz IS NOT INITIAL.
      SELECT bstnk abstk UP TO 1 ROWS
        FROM vbak
        INTO ls_vbak
        WHERE bstnk = is_ekko-ebeln
          AND abstk <> 'C'.
      ENDSELECT.

      IF sy-subrc = 0.
        MESSAGE e001(zsd_process_indus) WITH ls_vbak-bstnk . " cancelar primeiro a ordem de vendas &
      ENDIF.
      EXIT.
    ENDIF.

    SELECT werks
      UP TO 1 ROWS
      FROM t001w
      INTO @DATA(lv_werks)
      WHERE kunnr = @is_ekko-kunnr.
    ENDSELECT.

    DATA: ls_order_header_in      TYPE bapisdhd1,
          ls_order_header_inx     TYPE bapisdhd1x,
          lt_return               TYPE TABLE OF bapiret2,
          lt_order_items_in       TYPE TABLE OF  bapisditm,
          lt_order_items_inx      TYPE TABLE OF  bapisditmx,
          lt_order_partners       TYPE TABLE OF  bapiparnr,
          lt_order_schedules_in   TYPE TABLE OF  bapischdl,
          lt_order_schedules_inx  TYPE TABLE OF  bapischdlx,
          lt_order_conditions_in  TYPE TABLE OF  bapicond,
          lt_order_conditions_inx TYPE TABLE OF  bapicondx,
          lv_salesdocument        TYPE vbeln.


    ls_order_header_in-doc_type   = lc_doc_type_z025.
    ls_order_header_in-sales_org  = lc_sales_org_2000.
    ls_order_header_in-distr_chan = lc_distr_chan_10.
    ls_order_header_in-division  = lc_division_99.
    ls_order_header_in-purch_no_c  = is_ekko-ebeln.

    ls_order_header_inx-doc_type   =
    ls_order_header_inx-sales_org  =
    ls_order_header_inx-distr_chan =
    ls_order_header_inx-division  =
    ls_order_header_inx-purch_no_c  = abap_true.


    LOOP AT it_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).
      IF sy-tabix = 1.

        SELECT SINGLE kunnr
          FROM t001w
          INTO @DATA(lv_kunnr)
          WHERE werks = @<fs_ekpo>-werks.

          APPEND VALUE #( partn_role = lc_partn_role
                          partn_numb = lv_kunnr ) TO lt_order_partners.
*                    partn_numb = <fs_ekpo>-werks ) TO lt_order_partners.
        ENDIF.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
        material = <fs_ekpo>-matnr


        plant = lv_werks  "is_ekko-lifnr
        target_qty = <fs_ekpo>-ktmng
        target_qu = <fs_ekpo>-meins ) TO lt_order_items_in.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
        material = abap_true
        plant = abap_true
        target_qty = abap_true
        target_qu = abap_true ) TO lt_order_items_inx.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
        req_qty = <fs_ekpo>-ktmng ) TO lt_order_schedules_in.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
        req_qty = abap_true ) TO lt_order_schedules_inx.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
         cond_type = lc_cond_type_zpr0
         cond_value = <fs_ekpo>-netpr
        ) TO lt_order_conditions_in.

        APPEND VALUE #(
        itm_number = <fs_ekpo>-ebelp
         cond_type = abap_true
         cond_value = abap_true
        ) TO lt_order_conditions_inx.

      ENDLOOP.

      CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
        EXPORTING
          order_header_in      = ls_order_header_in
          order_header_inx     = ls_order_header_inx
        IMPORTING
          salesdocument        = lv_salesdocument
        TABLES
          return               = lt_return
          order_items_in       = lt_order_items_in
          order_items_inx      = lt_order_items_inx
          order_partners       = lt_order_partners
          order_schedules_in   = lt_order_schedules_in
          order_schedules_inx  = lt_order_schedules_inx
          order_conditions_in  = lt_order_conditions_in
          order_conditions_inx = lt_order_conditions_inx.


      IF lv_salesdocument IS INITIAL.
        MESSAGE e003(zsd_process_indus).
      ELSE.
        MESSAGE s004(zsd_process_indus) WITH lv_salesdocument.
      ENDIF.

    ENDMETHOD.
ENDCLASS.
