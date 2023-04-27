CLASS zclsd_cl_si_devolucao_picking DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_devolucao_picking .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CL_SI_DEVOLUCAO_PICKING IMPLEMENTATION.


  METHOD zclsd_ii_si_devolucao_picking~si_devolucao_picking_remessa_i.

    DATA ls_proxy TYPE zclsd_saga_devolv_picking=>ty_proxy_wa.
    DATA lr_proxy TYPE REF TO zclsd_saga_devolv_picking.

    lr_proxy ?= zclsd_saga_integracoes=>factory( ).

    LOOP AT input-mt_devolucao_picking_remessa-pedidos ASSIGNING FIELD-SYMBOL(<fs_pedidos>).

      MOVE-CORRESPONDING <fs_pedidos> TO ls_proxy.

      lr_proxy->set_proxy_data( EXPORTING is_proxy = ls_proxy
                                          it_proxy = VALUE #( FOR ls_item IN <fs_pedidos>-itens ( CORRESPONDING #( ls_item ) ) ) ).

      lr_proxy->zifsd_saga_integracoes~build( ).

      lr_proxy->zifsd_saga_integracoes~execute( ).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
