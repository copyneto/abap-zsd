class ZCLSD_CL_SI_DEVOLUCAO_PICKING1 definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_DEVOLUCAO_PICKING .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_DEVOLUCAO_PICKING1 IMPLEMENTATION.


  METHOD zclsd_ii_si_devolucao_picking~si_devolucao_picking_remessa_i.

    DATA lv_vbeln TYPE likp-vbeln.

    DATA ls_proxy TYPE zclsd_saga_devolv_picking=>ty_proxy_wa.
    DATA lr_proxy TYPE REF TO zclsd_saga_devolv_picking.
    DATA lt_rem_saga TYPE TABLE OF ztsd_rem_saga.

    lr_proxy ?= zclsd_saga_integracoes=>factory( ).

    DATA(lt_pedido_aux) = input-mt_devolucao_picking_remessa-pedidos.

    LOOP AT lt_pedido_aux ASSIGNING FIELD-SYMBOL(<fs_pedidos>).

      lv_vbeln = <fs_pedidos>-vbeln.
      <fs_pedidos>-vbeln = |{ lv_vbeln ALPHA = IN  }|.

    ENDLOOP.

    SORT lt_pedido_aux BY vbeln.
    DELETE ADJACENT DUPLICATES FROM lt_pedido_aux COMPARING vbeln.

    IF lt_pedido_aux[] IS NOT INITIAL.

      REFRESH: lt_rem_saga.
      SELECT remessa , ordem_frete ,
             enviado_saga , tipo_remessa , centro
        FROM ztsd_rem_saga
         FOR ALL ENTRIES IN @lt_pedido_aux
       WHERE remessa = @lt_pedido_aux-vbeln
        INTO TABLE @DATA(lt_dados_rem_saga).

      lt_rem_saga = VALUE #( FOR ls_saga
                              IN lt_dados_rem_saga ( remessa = ls_saga-remessa
                                                     ordem_frete = ls_saga-ordem_frete
                                                     enviado_saga = ls_saga-enviado_saga
                                                     tipo_remessa = ls_saga-tipo_remessa
                                                     centro = ls_saga-centro
                                                     data = sy-datum
                                                     hora = sy-uzeit ) ).

      IF lines( lt_rem_saga ) > 0.
        CALL FUNCTION 'ZFMTM_REMESSA_SAGA'
          TABLES
            it_remessa = lt_rem_saga.
      ENDIF.

      SELECT vbeln,
             kostk
        FROM likp
         FOR ALL ENTRIES IN @lt_pedido_aux
       WHERE vbeln = @lt_pedido_aux-vbeln
        INTO TABLE @DATA(lt_likp).

      IF sy-subrc IS INITIAL.
        SORT lt_likp BY vbeln.
      ENDIF.
    ENDIF.

    LOOP AT input-mt_devolucao_picking_remessa-pedidos ASSIGNING <fs_pedidos>.

      MOVE-CORRESPONDING <fs_pedidos> TO ls_proxy.

      lv_vbeln = |{ ls_proxy-vbeln ALPHA = IN  }|.

      READ TABLE lt_likp ASSIGNING FIELD-SYMBOL(<fs_likp>)
                                       WITH KEY vbeln = lv_vbeln
                                       BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        IF <fs_likp>-kostk = 'C'.
*        OR  <fs_likp>-kostk = ' '.
          CONTINUE.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.

      lr_proxy->set_proxy_data( EXPORTING is_proxy = ls_proxy
                                          it_proxy = VALUE #( FOR ls_item
                                                               IN <fs_pedidos>-itens
                                                                ( CORRESPONDING #( ls_item ) ) ) ).

      lr_proxy->zifsd_saga_integracoes~build( ).
*      lr_proxy->zifsd_saga_integracoes~execute( ).

      DATA(lt_return) = lr_proxy->executar( ).
      IF NOT lt_return IS INITIAL.
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCLSD_CX_FMT_DEVOLUCAO_PICKING'
            bapireturn_tab       = lt_return.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
