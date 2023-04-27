***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Cálculo de datas para Pedido na Ordem de Venda         *
*** AUTOR : Carlos Galoro – META                                      *
*** FUNCIONAL: Jana Castilhos – META                                  *
*** DATA : 24/01/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&--------------------------------------------------------------------*
*& Include ZSDI_CALCULO_CICLO_PED
*&--------------------------------------------------------------------*

    DATA(lo_ciclo_ped) = NEW  zclsd_dados_ciclo_pedido( ).

    DATA(ls_xvbap) = xvbap[ 1 ].

    lo_ciclo_ped->calculo_ordem_venda(
      EXPORTING
        iv_auart   = vbak-auart
        iv_vbeln   = vbak-vbeln
        iv_bstdk   = vbak-bstdk
        iv_erdat   = vbak-erdat
        iv_lib_com = vbak-zzdata_lib_com
        iv_cmgst   = vbak-cmgst
        iv_cmfre   = vbak-cmfre
        iv_route   = ls_xvbap-route
        iv_lifsk   = vbak-lifsk
    ).
