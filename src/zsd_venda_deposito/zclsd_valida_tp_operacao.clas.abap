class ZCLSD_VALIDA_TP_OPERACAO definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_posnr,
      posnr TYPE lips-posnr,
    END OF ty_posnr .
  types:
    ty_t_posnr TYPE STANDARD TABLE OF ty_posnr .

  class-methods GET_INSTANCE
    returning
      value(RO_INSTANCE) type ref to ZCLSD_VALIDA_TP_OPERACAO .
  methods EXECUTE
    importing
      !IV_KNUMP type KNUMP
      !IV_POSNR type POSNR_VL
    returning
      value(RV_SUBRC) type SYST_SUBRC .
protected section.
private section.

  class-data GO_INSTANCE type ref to ZCLSD_VALIDA_TP_OPERACAO .
  class-data GT_POSNR type TY_T_POSNR .
  class-data GV_INSTANCE type ABAP_BOOL .
  class-data GV_EXECUTED type ABAP_BOOL .
ENDCLASS.



CLASS ZCLSD_VALIDA_TP_OPERACAO IMPLEMENTATION.


  METHOD execute.

    IF gv_instance = abap_true AND gv_executed IS INITIAL.

      SELECT lips~posnr
        FROM ekbe
       INNER JOIN likp
          ON ekbe~belnr = likp~vbeln
       INNER JOIN lips
          ON likp~vbeln = lips~vbeln
       WHERE likp~knump = @iv_knump
         AND ekbe~vgabe = '8'
       INTO TABLE @gt_posnr.

        IF sy-subrc IS INITIAL.
          SORT gt_posnr BY posnr.
        ENDIF.

        gv_executed = abap_true.

    ENDIF.

    READ TABLE gt_posnr TRANSPORTING NO FIELDS WITH KEY posnr = iv_posnr BINARY SEARCH.
    rv_subrc = sy-subrc.

  ENDMETHOD.


  method GET_INSTANCE.

    IF NOT go_instance IS BOUND.
      gv_instance = abap_true.
      go_instance = NEW zclsd_valida_tp_operacao( ).
    ENDIF.

    ro_instance = go_instance.
  endmethod.
ENDCLASS.
