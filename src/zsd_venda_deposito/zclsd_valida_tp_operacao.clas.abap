CLASS zclsd_valida_tp_operacao DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_return_select,
        knump TYPE likp-knump,
        posnr TYPE lips-posnr,
      END OF ty_return_select,

      ty_t_return_select TYPE SORTED TABLE OF ty_return_select WITH UNIQUE KEY knump posnr,

      BEGIN OF ty_knumv_filtered,
        knumv TYPE komv_index-knumv,
      END OF ty_knumv_filtered,

      ty_t_knumv_filtered TYPE SORTED TABLE OF ty_knumv_filtered WITH UNIQUE KEY knumv.


    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_return) TYPE REF TO zclsd_valida_tp_operacao .

    METHODS execute
      IMPORTING
        iv_knumv         TYPE komv_index-knumv
        iv_kposn         TYPE komv_index-kposn
      RETURNING
        VALUE(rv_return) TYPE sy-subrc.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CLASS-DATA:
      gt_return_select  TYPE ty_t_return_select,
      gt_knumv_filtered TYPE ty_t_knumv_filtered,
      go_instance       TYPE REF TO zclsd_valida_tp_operacao.

ENDCLASS.



CLASS ZCLSD_VALIDA_TP_OPERACAO IMPLEMENTATION.


  METHOD execute.

    IF NOT line_exists( gt_knumv_filtered[ knumv = iv_knumv ] ).
      INSERT VALUE #( knumv = iv_knumv ) INTO TABLE gt_knumv_filtered.

      SELECT likp~knump, lips~posnr
        FROM ekbe
       INNER JOIN likp
          ON  ekbe~belnr = likp~vbeln
          AND ekbe~vgabe = '8'
       INNER JOIN lips
          ON  likp~vbeln = lips~vbeln
          AND likp~knump = @iv_knumv
       INTO TABLE @DATA(lt_tp_operacao)
       GROUP BY likp~knump, lips~posnr.

      IF sy-subrc = 0.
        "DELETE ADJACENT DUPLICATES FROM lt_tp_operacao COMPARING knump posnr.
        INSERT LINES OF lt_tp_operacao INTO TABLE gt_return_select.
      ENDIF.
    ENDIF.

    rv_return = COND #(
      WHEN line_exists( gt_return_select[ knump = iv_knumv posnr = iv_kposn ] )
      THEN 0
      ELSE 4
    ).
*    DATA lt_filter_xkomv TYPE ty_t_xkomv_unique.
*
*    lt_filter_xkomv = CORRESPONDING #( it_filter_xkomv DISCARDING DUPLICATES ).
*
*    LOOP AT lt_filter_xkomv ASSIGNING FIELD-SYMBOL(<fs_is_filter_xkomv>).
*      READ TABLE gt_filtered_xkomv INTO DATA(ls_filtered_xkomv) WITH KEY knumv = <fs_is_filter_xkomv>-knumv kposn = <fs_is_filter_xkomv>-kposn BINARY SEARCH.
*      IF sy-subrc = 0.
*        rv_return = ls_filtered_xkomv-subrc.
*        IF ls_filtered_xkomv-subrc = 0.
*          RETURN.
*        ENDIF.
*      ELSE.
*        INSERT <fs_is_filter_xkomv> INTO TABLE gt_filtered_xkomv.
*        DATA(lv_execute_select) = abap_true.
*      ENDIF.
*    ENDLOOP.
*
*    IF lv_execute_select = abap_true AND gt_filtered_xkomv IS NOT INITIAL.
*      SELECT COUNT(*)
*        FROM ekbe
*       INNER JOIN likp
*          ON ekbe~belnr = likp~vbeln
*       INNER JOIN lips
*          ON likp~vbeln = lips~vbeln
*       INNER JOIN @gt_filtered_xkomv AS _filtered_xkomv
*          ON _filtered_xkomv~knumv = likp~knumv
*          AND _filtered_xkomv~kposn = lips~posnr
*       WHERE ekbe~vgabe = '8'.
*
*      rv_return = sy-subrc.
*
*      LOOP AT gt_filtered_xkomv ASSIGNING FIELD-SYMBOL(<fs_filtered_xkomv>).
*        <fs_filtered_xkomv>-subrc = rv_return.
*      ENDLOOP.
*    ENDIF.
  ENDMETHOD.


  METHOD get_instance.
    ro_return = go_instance = COND #(
      WHEN go_instance IS BOUND
      THEN go_instance
      ELSE NEW zclsd_valida_tp_operacao( )
    ).
  ENDMETHOD.
ENDCLASS.
