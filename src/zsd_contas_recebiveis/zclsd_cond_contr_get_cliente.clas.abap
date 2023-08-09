CLASS zclsd_cond_contr_get_cliente DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS
      get_cliente
        IMPORTING
          iv_kunnr         TYPE kunnr
        RETURNING
          VALUE(rs_return) TYPE zclsd_condicao_contrato=>ty_cliente.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_kna1,
        kunnr  TYPE kna1-kunnr,
        kdkg1  TYPE kna1-kdkg1,
        katr2  TYPE kna1-katr2,
        katr10 TYPE kna1-katr10,
      END OF ty_kna1.

    CLASS-DATA:
      gt_kna1 TYPE SORTED TABLE OF ty_kna1 WITH UNIQUE KEY kunnr.

    CLASS-METHODS
      get_select_kna1
        IMPORTING
          iv_kunnr         TYPE kunnr
        RETURNING
          VALUE(rs_return) TYPE ty_kna1.
ENDCLASS.

CLASS zclsd_cond_contr_get_cliente IMPLEMENTATION.
  METHOD get_cliente.
    rs_return = CORRESPONDING #( VALUE #(
      gt_kna1[ kunnr = iv_kunnr ]
      DEFAULT get_select_kna1( iv_kunnr )
    ) ).
  ENDMETHOD.

  METHOD get_select_kna1.
    SELECT SINGLE kunnr, kdkg1, katr2, katr10
    FROM kna1
    WHERE kunnr = @iv_kunnr
    INTO @rs_return.
    rs_return-kunnr = iv_kunnr.
    INSERT rs_return INTO TABLE gt_kna1.
  ENDMETHOD.
ENDCLASS.
