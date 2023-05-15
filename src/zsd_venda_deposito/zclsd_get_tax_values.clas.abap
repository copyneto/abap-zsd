CLASS zclsd_get_tax_values DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types para dados item
      BEGIN OF ty_item,
        refkey TYPE vbeln_vf,
        refitm TYPE j_1bnflin-refitm,
      END OF ty_item .
    TYPES:
      "! Types para dados impostos
      BEGIN OF ty_tax,
*        billingdocument     TYPE i_billingdocumentitemprcgelmnt-billingdocument,
*        billingdocumentitem TYPE i_billingdocumentitemprcgelmnt-billingdocumentitem,
*        conditiontype       TYPE i_billingdocumentitemprcgelmnt-conditiontype,
*        conditionamount     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
        kposn TYPE prcd_elements-kposn,
        kschl TYPE prcd_elements-kschl,
        kwert TYPE prcd_elements-kwert,
      END OF ty_tax .
    TYPES:
      "! Types para dados ultimas compras
      BEGIN OF ty_last_purchase,
        matnr   TYPE mbew-matnr,
        bwkey   TYPE mbew-bwkey,
*        verpr TYPE mbew-verpr,
        lppid   TYPE j_1blpp-lppid,
        lppbrt  TYPE j_1blpp-lppbrt,
        subtval TYPE j_1blpp-subtval,
        zipival TYPE j_1blpp-zipival,
      END OF ty_last_purchase .
    TYPES:
                "! Types para dados ultimas compras
      tt_ult_compra TYPE TABLE OF ty_last_purchase .

    CONSTANTS:
      "! Constantes para tipo de condição
      BEGIN OF gc_conditiontype,
        zbcr TYPE ze_param_modulo VALUE 'ZBCR',
        zpst TYPE ze_param_chave  VALUE 'ZPST',
        zsub TYPE ze_param_chave  VALUE 'ZSUB',
        zire TYPE ze_param_chave  VALUE 'ZIRE',
        zbfc TYPE ze_param_chave  VALUE 'ZBFC',
        zpfc TYPE ze_param_chave  VALUE 'ZPFC',
        zvfc TYPE ze_param_chave  VALUE 'ZVFC',
        zred TYPE ze_param_chave  VALUE 'ZRED',
        zbef TYPE ze_param_chave  VALUE 'ZBEF',
        zpef TYPE ze_param_chave  VALUE 'ZPEF',
        zlpp TYPE ze_param_chave  VALUE 'ZLPP',
        zvet TYPE ze_param_chave  VALUE 'ZVET',
        vprs TYPE ze_param_chave  VALUE 'VPRS',
      END OF gc_conditiontype .
    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ze_param_chave  VALUE 'TIPO CONDICAO',
      END OF gc_parametros .
    DATA:
          "! Tabela para dados impostos
      gt_tax  TYPE TABLE OF ty_tax .
    DATA:
          "! Tabela para dados itens
      gt_item TYPE SORTED TABLE OF ty_item WITH NON-UNIQUE KEY refkey refitm .
    "! Tabela para dados ultimas compras
    DATA gt_ult_compra TYPE tt_ult_compra .
    "! Atributo dados contribuentes
    DATA gs_contribuinte TYPE kna1-icmstaxpay .
    DATA:
          "! Atributo dados contribuentes
      gs_tipo_condicao TYPE RANGE OF kscha .

    "! Método Constructor
    "! @parameter is_header | Cabeçalho NF
    "! @parameter it_item   | Itens NF
    METHODS constructor
      IMPORTING
        !is_header TYPE j_1bnfdoc
        !it_item   TYPE j_1bnflin_tab
        !it_vbrp   TYPE vbrp_tab OPTIONAL .
    "! Método atualiza impostos do faturamento
    "! @parameter is_item | Itens NF
    "! @parameter cs_item | Itens NF XML
    METHODS set_tax_billing
      IMPORTING
        !is_item   TYPE j_1bnflin
        !iv_manual TYPE abap_bool
      CHANGING
        !cs_item   TYPE j_1bnf_badi_item .
    "! Método atualiza impostos
    "! @parameter is_header | Cabeçalho NF
    "! @parameter is_item   | Itens NF
    "! @parameter cs_item   | Itens NF XML
    METHODS set_tax
      IMPORTING
        !is_header TYPE j_1bnfdoc
        !is_item   TYPE j_1bnflin
        !iv_manual TYPE abap_bool
      CHANGING
        !cs_item   TYPE j_1bnf_badi_item .
    METHODS get_last_purchase
      IMPORTING
        !is_item             TYPE j_1bnflin
        !iv_uf               TYPE j_1bnfdoc-regio OPTIONAL
        !iv_um               TYPE abap_bool DEFAULT abap_false
      RETURNING
        VALUE(rv_ult_compra) TYPE mbew-verpr .
    METHODS get_last_ipi
      IMPORTING
        !is_item          TYPE j_1bnflin
      RETURNING
        VALUE(rv_ult_ipi) TYPE mbew-verpr .
  PROTECTED SECTION.

  PRIVATE SECTION.

    "! Método tratamento de itens para seleção
    "! @parameter it_item | Itens NF
    METHODS get_itens
      IMPORTING
        !it_item TYPE j_1bnflin_tab .
    "! Método seleciona contribuentes
    "! @parameter IV_WERKS  | Identificação do parceiro
    "! @parameter rv_taxpay | Contribuente
    METHODS get_taxpayers
      IMPORTING
        !iv_bukrs        TYPE j_1bnfdoc-bukrs
        !iv_werks        TYPE j_1bnflin-werks
        !iv_itmtyp       TYPE j_1bnflin-itmtyp
        !iv_parid        TYPE j_1bparid
      RETURNING
        VALUE(rv_taxpay) TYPE kna1-icmstaxpay .
    "! Método seleciona ultimas compras
    "! @parameter it_item          | Itens NF
    "! @parameter et_last_purchase | Ultimas compras
    METHODS get_last_purchases
      IMPORTING
        !it_item          TYPE j_1bnflin_tab
      EXPORTING
        !et_last_purchase TYPE tt_ult_compra .
    "! Método preenche valores de impostos calculados
    "! @parameter is_tax  | Impostos
    "! @parameter cs_item | Itens NF XML
    METHODS get_tax_values
      IMPORTING
        !is_tax        TYPE zclsd_get_tax_calculations=>ty_calculos
        !iv_quantidade TYPE j_1bnetqty
        !iv_manual     TYPE abap_bool
      CHANGING
        !cs_item       TYPE j_1bnf_badi_item .
    "! Método seleciona dados na tabela de parâmetros
    METHODS get_param_type_cond .
ENDCLASS.



CLASS ZCLSD_GET_TAX_VALUES IMPLEMENTATION.


  METHOD constructor.

    FIELD-SYMBOLS <fs_komv> TYPE ANY TABLE.

    get_itens( it_item = it_item ).
    get_last_purchases( EXPORTING it_item = it_item IMPORTING et_last_purchase = gt_ult_compra ).

*    gs_contribuinte = get_taxpayers( iv_parid = is_header-parid ).

    CHECK gt_item IS NOT INITIAL.

    get_param_type_cond( ).

    ASSIGN ('(SAPLV60A)XKOMV[]') TO <fs_komv>.
    IF <fs_komv> IS ASSIGNED.

      MOVE-CORRESPONDING <fs_komv> TO gt_tax.

    ELSE.

      READ TABLE it_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>) INDEX 1.
      IF sy-subrc = 0.
        "Cenário de SD
        SELECT SINGLE knumv
          FROM vbak
          INTO @DATA(lv_condicao)
          WHERE vbeln EQ @<fs_vbrp>-aubel.

        IF sy-subrc EQ 0.

          SELECT kposn, kschl, kwert FROM prcd_elements
            INTO TABLE @gt_tax
            FOR ALL ENTRIES IN @it_vbrp
            WHERE knumv EQ @lv_condicao
              AND kposn EQ @it_vbrp-aupos
              AND kschl IN @gs_tipo_condicao.

        ENDIF.

      ENDIF.

    ENDIF.

*      SELECT billingdocument, billingdocumentitem, conditiontype, conditionamount
*    FROM i_billingdocumentitemprcgelmnt
*    INTO TABLE @gt_tax
*    FOR ALL ENTRIES IN @gt_item
*    WHERE billingdocument     EQ @gt_item-refkey
*    AND   billingdocumentitem EQ @gt_item-refitm
*    AND   conditiontype       IN @gs_tipo_condicao.

  ENDMETHOD.


  METHOD get_itens.

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).

*      APPEND VALUE #( refkey = <fs_item>-refkey
*                      refitm = <fs_item>-refitm ) TO gt_item.
      INSERT VALUE #( refkey = <fs_item>-refkey
                      refitm = <fs_item>-refitm ) INTO TABLE gt_item.
    ENDLOOP.

  ENDMETHOD.


  METHOD set_tax_billing.

    DATA lv_kwert TYPE dec10.

    DATA: ls_komk TYPE komk,
          ls_komp TYPE komp,
          lt_komv TYPE TABLE OF komv,
          ls_komv TYPE komv.

    SORT gt_tax BY kposn.
    READ TABLE gt_tax TRANSPORTING NO FIELDS WITH KEY kposn = is_item-refitm BINARY SEARCH.
    IF sy-subrc = 0.

      IF iv_manual EQ abap_true.
        DATA(lv_quantity) = is_item-menge.
      ELSE.
        lv_quantity = 1.
      ENDIF.

      LOOP AT gt_tax ASSIGNING FIELD-SYMBOL(<fs_tax>) FROM sy-tabix.

        IF <fs_tax>-kposn <> is_item-refitm.
          EXIT.
        ELSE.
          CASE <fs_tax>-kschl.
            WHEN gc_conditiontype-zbcr.
              cs_item-vbcstret        = <fs_tax>-kwert * lv_quantity.
            WHEN gc_conditiontype-zpst.
              cs_item-pst             = <fs_tax>-kwert.
            WHEN gc_conditiontype-zsub.
              cs_item-vicmssubstituto = <fs_tax>-kwert * lv_quantity.
            WHEN gc_conditiontype-zire.
              cs_item-vicmsstret      = <fs_tax>-kwert * lv_quantity.
            WHEN gc_conditiontype-zbfc.
              cs_item-vbcfcpstret     = <fs_tax>-kwert.
            WHEN gc_conditiontype-zpfc.
              cs_item-pfcpstret       = <fs_tax>-kwert.
            WHEN gc_conditiontype-zvfc.
              cs_item-vfcpstret       = <fs_tax>-kwert.
            WHEN gc_conditiontype-zred.
              cs_item-predbcefet      = <fs_tax>-kwert.
            WHEN gc_conditiontype-zbef.
              cs_item-vbcefet         = <fs_tax>-kwert.
            WHEN gc_conditiontype-zpef.
              cs_item-picmsefet       = <fs_tax>-kwert.
            WHEN gc_conditiontype-zvet.
              cs_item-vicmsefet       = <fs_tax>-kwert.
          ENDCASE.

        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD set_tax.

    DATA lv_ult_compra TYPE kwert.

    DATA(lo_tax_calculations) = NEW zclsd_get_tax_calculations( ).

    SELECT SINGLE lips~vbeln, lips~posnr, lips~bwart
      FROM lips
     INNER JOIN ekbe
        ON lips~vbeln = ekbe~belnr
       AND ekbe~vgabe = '8'
     WHERE ekbe~ebeln EQ @is_item-xped
       AND ekbe~ebelp EQ @is_item-nitemped
      INTO ( @DATA(lv_vbeln), @DATA(lv_kposn), @DATA(lv_bwart) ).

* LSCHEPP - 8000007048 - CST 60 - Valor do ICMS Substituto - 10.05.2023 Início
    SELECT SINGLE meins
      FROM mara
      INTO @DATA(lv_umb)
      WHERE matnr EQ @is_item-matnr.
    IF sy-subrc EQ 0.
      IF lv_umb NE is_item-meins.
        lv_bwart = '862'.
      ENDIF.
    ENDIF.
* LSCHEPP - 8000007048 - CST 60 - Valor do ICMS Substituto - 10.05.2023 Fim

    lv_ult_compra = get_last_purchase( is_item = is_item iv_uf = is_header-regio iv_um = COND #( WHEN lv_bwart = |862| THEN abap_true ELSE abap_false ) ).

    DATA(lv_ult_ipi) = get_last_ipi( is_item = is_item ).

    IF is_item-netwrt IS NOT INITIAL.
      DATA(lv_valor_prod) = is_item-netwrt.
    ELSE.
      lv_valor_prod  = is_item-netwr.
    ENDIF.

    gs_contribuinte = get_taxpayers( iv_bukrs  = is_header-bukrs
                                     iv_werks  = is_item-werks
                                     iv_itmtyp = is_item-itmtyp
                                     iv_parid  = is_header-parid ).

    lo_tax_calculations->main(
      EXPORTING
        iv_bukrs         = is_header-bukrs
        iv_centro        = is_item-werks
        iv_uf            = is_header-regio
        iv_material      = is_item-matnr
        iv_gp_mercadoria = is_item-matkl
        iv_contribuinte  = gs_contribuinte
        iv_ult_compra    = CONV #( lv_ult_compra )
        iv_ult_ipi       = lv_ult_ipi
        iv_valor_unit    = is_item-netpr
        iv_valor_prod    = lv_valor_prod
        iv_quantidade    = is_item-menge
        iv_unidade       = is_item-meins
        iv_vbeln         = CONV #( lv_vbeln )
        iv_kposn         = CONV #( lv_kposn )
      IMPORTING
        es_calculos      = DATA(ls_tax)
    ).

    get_tax_values( EXPORTING is_tax        = ls_tax
                              iv_quantidade = is_item-menge
                              iv_manual     = iv_manual
                    CHANGING  cs_item = cs_item ).

  ENDMETHOD.


  METHOD get_tax_values.

    IF iv_manual EQ abap_true.
      DATA(lv_quantity) = iv_quantidade.
    ELSE.
      lv_quantity = 1.
    ENDIF.

    IF is_tax-vbcstret IS NOT INITIAL.
      cs_item-vbcstret        = is_tax-vbcstret.
    ENDIF.
    IF is_tax-pst IS NOT INITIAL.
      cs_item-pst             = is_tax-pst.
    ENDIF.
    IF is_tax-vicmssubstituto IS NOT INITIAL.
      cs_item-vicmssubstituto = is_tax-vicmssubstituto.
    ENDIF.
    IF is_tax-vicmsstret IS NOT INITIAL.
      cs_item-vicmsstret      = is_tax-vicmsstret.
    ENDIF.
    IF is_tax-vbcfcpstret IS NOT INITIAL.
      cs_item-vbcfcpstret     = is_tax-vbcfcpstret.
    ENDIF.
    IF is_tax-pfcpstret IS NOT INITIAL.
      cs_item-pfcpstret       = is_tax-pfcpstret.
    ENDIF.
    IF is_tax-vfcpstret IS NOT INITIAL.
      cs_item-vfcpstret       = is_tax-vfcpstret.
    ENDIF.
    IF is_tax-predbcefet IS NOT INITIAL.
      cs_item-predbcefet      = is_tax-predbcefet.
    ENDIF.
    IF is_tax-vbcefet IS NOT INITIAL.
      cs_item-vbcefet         = is_tax-vbcefet.
    ENDIF.
    IF is_tax-picmsefet IS NOT INITIAL.
      cs_item-picmsefet       = is_tax-picmsefet.
    ENDIF.
    IF is_tax-vicmsefet IS NOT INITIAL.
      cs_item-vicmsefet       = is_tax-vicmsefet.
    ENDIF.

  ENDMETHOD.


  METHOD get_last_purchase.

    CONSTANTS: lc_s TYPE char1 VALUE 'S',
               lc_i TYPE char1 VALUE 'I'.

    DATA: lv_um TYPE meins,
          lv_qt TYPE menge_d.

    SORT gt_ult_compra BY matnr bwkey.
    READ TABLE gt_ult_compra ASSIGNING FIELD-SYMBOL(<fs_ult_compra>) WITH KEY  matnr = is_item-matnr
                                                                               bwkey = is_item-werks BINARY SEARCH.
    IF sy-subrc = 0.

      IF iv_um EQ abap_true.

        NEW zclsd_get_tables_cst60( )->execute( EXPORTING iv_centro         = is_item-werks
                                                          iv_uf             = iv_uf
                                                          iv_material       = is_item-matnr
                                                          iv_gp_mercadoria  = is_item-matkl
                                                IMPORTING ev_um             = lv_um ).

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = is_item-matnr
            i_in_me              = is_item-meins
            i_out_me             = lv_um
            i_menge              = is_item-menge
          IMPORTING
            e_menge              = lv_qt
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

      ELSE.

        lv_qt = is_item-menge.

      ENDIF.


      IF <fs_ult_compra>-lppid = lc_s.
        rv_ult_compra = <fs_ult_compra>-lppbrt + <fs_ult_compra>-subtval * lv_qt. "is_item-menge .

      ELSEIF <fs_ult_compra>-lppid = lc_i.
        rv_ult_compra = <fs_ult_compra>-lppbrt * lv_qt. "is_item-menge.

      ELSE.
        rv_ult_compra = <fs_ult_compra>-lppbrt * lv_qt. "is_item-menge.

      ENDIF.
*      rv_ult_compra = <fs_ult_compra>-verpr.
    ENDIF.








  ENDMETHOD.


  METHOD get_taxpayers.

    IF iv_itmtyp EQ '2'.
      IF NOT iv_werks IS INITIAL.
        SELECT SINGLE kunnr
          INTO @DATA(lv_kunnr)
          FROM t001w
          WHERE werks = @iv_werks.
        IF sy-subrc IS INITIAL.
          SELECT SINGLE icmstaxpay
            FROM kna1
            INTO rv_taxpay
            WHERE kunnr EQ lv_kunnr.
        ENDIF.
      ENDIF.
    ELSE.
      IF NOT iv_parid IS INITIAL.
        SELECT SINGLE icmstaxpay
          FROM kna1
          INTO rv_taxpay
          WHERE kunnr EQ iv_parid.
        IF sy-subrc NE 0.

          SELECT SINGLE icmstaxpay
            FROM j_1bbranch
           INNER JOIN t001w
              ON j_1bbranch~branch = t001w~j_1bbranch
               WHERE j_1bbranch~bukrs = @iv_bukrs
                 AND t001w~werks      = @iv_werks
                INTO @rv_taxpay.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_last_purchases.

    CHECK it_item IS NOT INITIAL.

*    SELECT matnr bwkey verpr
*    FROM mbew
*    INTO TABLE et_last_purchase
*    FOR ALL ENTRIES IN it_item
*    WHERE matnr EQ it_item-matnr
*      AND bwkey EQ it_item-werks.

    SELECT matnr bwkey lppid lppbrt subtval zipival
        INTO TABLE et_last_purchase
        FROM j_1blpp
        FOR ALL ENTRIES IN it_item
        WHERE matnr  EQ it_item-matnr
          AND bwkey  EQ it_item-werks.

    IF et_last_purchase IS INITIAL.

      SELECT matnr bwkey stprs AS lppbrt
        FROM mbew
        INTO CORRESPONDING FIELDS OF TABLE et_last_purchase
        FOR ALL ENTRIES IN it_item
        WHERE matnr EQ it_item-matnr
          AND bwkey EQ it_item-werks
          AND bwtar EQ it_item-bwtar.

    ENDIF.

  ENDMETHOD.


  METHOD get_param_type_cond.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_tipo_condicao.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_parametros-modulo
            iv_chave1 = gc_parametros-chave1
          IMPORTING
            et_range  = gs_tipo_condicao
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD get_last_ipi.

    SORT gt_ult_compra BY matnr bwkey.
    READ TABLE gt_ult_compra ASSIGNING FIELD-SYMBOL(<fs_ult_compra>) WITH KEY  matnr = is_item-matnr
                                                                               bwkey = is_item-werks BINARY SEARCH.
    IF sy-subrc = 0.

      rv_ult_ipi = <fs_ult_compra>-zipival * is_item-menge.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
