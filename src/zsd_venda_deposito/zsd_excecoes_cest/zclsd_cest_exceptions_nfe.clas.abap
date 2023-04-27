CLASS zclsd_cest_exceptions_nfe DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types dados cest
      BEGIN OF ty_cest,
        material TYPE j_1btcestdet-material,
        cest     TYPE j_1btcestdet-cest,
      END OF ty_cest.

    "! Tabela Global dados cest
    DATA gt_cest TYPE SORTED TABLE OF ty_cest WITH NON-UNIQUE KEY material.

    "! Método Constructor
    "! @parameter it_nflin | Dados Item NF
    METHODS constructor IMPORTING it_nflin TYPE j_1bnflin_tab.

    "! Método Atualiza Cest na NFE
    "! @parameter is_item | Dados Item NF
    "! @parameter cs_item | Dados Item BADI
    METHODS change_cest IMPORTING is_item TYPE j_1bnflin
                        CHANGING  cs_item TYPE j_1bnf_badi_item.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_cest_exceptions_nfe IMPLEMENTATION.

  METHOD constructor.

    CHECK it_nflin IS NOT INITIAL.

    SELECT material cest
    FROM j_1btcestdet
    INTO TABLE gt_cest
    FOR ALL ENTRIES IN it_nflin
    WHERE material EQ it_nflin-matnr
      AND cest     EQ space.

  ENDMETHOD.

  METHOD change_cest.

    READ TABLE gt_cest ASSIGNING FIELD-SYMBOL(<fs_cest>) WITH KEY material = is_item-matnr BINARY SEARCH.
    IF sy-subrc = 0.
      cs_item-cest = <fs_cest>-cest.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
