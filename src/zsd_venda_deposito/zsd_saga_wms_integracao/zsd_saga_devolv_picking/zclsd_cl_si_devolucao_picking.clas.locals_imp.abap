
CLASS lcl_fill_data IMPLEMENTATION.

*  METHOD zclsd_mt_devolucao_picking_rem.
*    CALL METHOD zclsd_dt_devolucao_picking_rem
*      IMPORTING
*        out = out.
*  ENDMETHOD.

*  METHOD zclsd_dt_devolucao_picking_rem.

*    out-pedidos-vbeln = `String 1`.  "#EC NOTEXT
*    out-pedidos-anzpk = `2 `.                                       "#EC NOTEXT
*    out-pedidos-zordemfrete = `3 `.                                 "#EC NOTEXT
*    out-pedidos-traid = `String 4`.                                 "#EC NOTEXT
*    out-pedidos-ztraid = `St`.                                      "#EC NOTEXT

*    APPEND VALUE zclsd_dt_devolucao_picking_re1(
*       vbeln = `String 1`
*       anzpk = `2 `
*       zordemfrete = `3 `
*       traid = `String 4`
*       ztraid = `St` ) to out.

*    CALL METHOD zclsd_dt_devolucao_picking_tab
*      IMPORTING
*        out = out.
*  ENDMETHOD.

*  METHOD zclsd_dt_devolucao_picking_tab.
*    DATA: ls_out LIKE LINE OF out.
*    CALL METHOD zclsd_dt_devolucao_picking_re1
*      IMPORTING
*        out = ls_out.
*    DO 3 TIMES.
*      APPEND ls_out TO out.
*    ENDDO.
*  ENDMETHOD.
*
*  METHOD zclsd_dt_devolucao_picking_re1.
*    out-pedido-item-posnn = `5 `.                                       "#EC NOTEXT
*    out-pedido-item-matnr = `7 `.                                       "#EC NOTEXT
*    out-pedido-item-ndifm = `8.000 `.                                   "#EC NOTEXT
*    out-pedido-item-pikmg = `9.000 `.                                   "#EC NOTEXT
*  ENDMETHOD.

ENDCLASS.
