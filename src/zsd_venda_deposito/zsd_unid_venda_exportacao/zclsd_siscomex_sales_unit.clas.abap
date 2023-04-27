CLASS zclsd_siscomex_sales_unit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! Método Constructor
    "! @parameter it_nflin | Dados Item NF
    METHODS constructor IMPORTING it_nflin TYPE j_1bnflin_tab.

    "! Método Atualiza Unidade de vendas na NFE
    "! @parameter is_item | Dados Item NF
    "! @parameter cs_item | Dados Item BADI
    METHODS change_unit IMPORTING is_header TYPE j_1bnfdoc
                                  is_item   TYPE j_1bnflin
                        CHANGING  cs_item   TYPE j_1bnf_badi_item.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      "! Type dos dados da Tabela NCM – Unidade tributável
      BEGIN OF ty_unit,
        steuc  TYPE ztsd_unid_trib-steuc,
        msehi  TYPE ztsd_unid_trib-msehi,
        un_xml TYPE ztsd_unid_trib-un_xml,
      END OF ty_unit .
    TYPES:
      "! Type dos dados da Tabela Nº Europeu de Artigo (EAN) do material
      BEGIN OF ty_mean,
        matnr TYPE mean-matnr,
        meinh TYPE mean-meinh,
        ean11 TYPE mean-ean11,
      END OF ty_mean .

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ze_param_chave  VALUE 'CFOP EXPORTACAO',
      END OF gc_parametros .
    "! Constante Domicílio fiscal
    CONSTANTS gc_txjcd TYPE j_1bnfdoc-txjcd VALUE 'EX' ##NO_TEXT.
    DATA:
      "! Tabela NCM – Unidade tributável
      gt_unit TYPE SORTED TABLE OF ty_unit WITH NON-UNIQUE KEY steuc .
    DATA:
      "! Tabela NCM – Unidade tributável
      gt_mean TYPE SORTED TABLE OF ty_mean WITH NON-UNIQUE KEY matnr meinh .
    DATA:
      "! Atributo CFOP
      gs_cfop TYPE RANGE OF j_1bcfop .

    "! Método Seleciona dados tabela parâmetros
    METHODS get_param_cfop .
    "! Método Converte quantidade
    "! @parameter is_item  | Dados Item NF
    "! @parameter is_unit  | Dados NCM – Unidade tributável
    "! @parameter rv_menge | Quantidade do pedido
    METHODS get_quantity
      IMPORTING
        !is_item        TYPE j_1bnflin
        !is_unit        TYPE ty_unit
      RETURNING
        VALUE(rv_menge) TYPE zmenge .
ENDCLASS.



CLASS ZCLSD_SISCOMEX_SALES_UNIT IMPLEMENTATION.


  METHOD get_param_cfop.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gs_cfop.

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
            iv_modulo = gc_parametros-modulo
            iv_chave1 = gc_parametros-chave1
          IMPORTING
            et_range  = gs_cfop
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD constructor.

    get_param_cfop( ).

    CHECK it_nflin IS NOT INITIAL.

    SELECT steuc msehi un_xml
    FROM ztsd_unid_trib
    INTO TABLE gt_unit
    FOR ALL ENTRIES IN it_nflin
    WHERE steuc     EQ it_nflin-nbm
    AND valid_from  <= sy-datum
    AND valid_to    >= sy-datum.

    SELECT matnr meinh ean11
    FROM mean
    INTO TABLE gt_mean
    FOR ALL ENTRIES IN it_nflin
    WHERE matnr     EQ it_nflin-matnr.

    IF Sy-subrc <> 0 .
      SELECT matnr meinh
      FROM marm
      INTO TABLE gt_mean
      FOR ALL ENTRIES IN it_nflin
      WHERE matnr     EQ it_nflin-matnr.
    ENDIF.

  ENDMETHOD.


  METHOD change_unit.

*    CHECK is_header-direct = 2 AND is_header-txjcd = gc_txjcd OR is_item-cfop IN gs_cfop.
    CHECK is_header-txjcd = gc_txjcd OR is_item-cfop IN gs_cfop.

    READ TABLE gt_unit ASSIGNING FIELD-SYMBOL(<fs_unit>) WITH KEY steuc = is_item-nbm BINARY SEARCH.
    IF sy-subrc = 0 AND is_item-meins NE <fs_unit>-msehi.

      READ TABLE gt_mean ASSIGNING FIELD-SYMBOL(<fs_mean>) WITH KEY matnr = is_item-matnr
                                                                    meinh = <fs_unit>-msehi BINARY SEARCH.
      IF sy-subrc = 0.
        IF NOT <fs_mean>-ean11 IS INITIAL.
          cs_item-cean_trib = <fs_mean>-ean11.

          IF cs_item-cean IS INITIAL.
            cs_item-cean = <fs_mean>-ean11.
          ENDIF.
        ENDIF.
      ENDIF.

      DATA(lv_menge) = get_quantity( is_item = is_item is_unit = <fs_unit> ).
      IF lv_menge IS NOT INITIAL.
        cs_item-menge_trib = lv_menge.
      ENDIF.

      IF <fs_unit>-un_xml IS NOT INITIAL.
        cs_item-meins_trib = <fs_unit>-un_xml.
      ELSE.
        cs_item-meins_trib = <fs_unit>-msehi.
      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD get_quantity.
    CONSTANTS : lc_unit_to TYPE ztsd_unid_trib-msehi VALUE 'TO',
                lc_unit_kg TYPE ztsd_unid_trib-msehi VALUE 'KG'.

    DATA lv_menge TYPE ekpo-menge.
    IF is_unit-msehi = lc_unit_to.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = is_item-matnr
          i_in_me              = is_item-meins
          i_out_me             = lc_unit_kg
          i_menge              = is_item-menge
        IMPORTING
          e_menge              = lv_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc = 0.
        rv_menge = lv_menge / 1000.
      ENDIF.

    ELSE.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = is_item-matnr
          i_in_me              = is_item-meins
          i_out_me             = is_unit-msehi
          i_menge              = is_item-menge
        IMPORTING
          e_menge              = lv_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc NE 0.
        CLEAR lv_menge.
      ENDIF.

    ENDIF.

    IF rv_menge IS INITIAL.
      rv_menge  = lv_menge.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
