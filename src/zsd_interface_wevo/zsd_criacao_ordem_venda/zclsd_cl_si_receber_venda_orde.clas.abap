class ZCLSD_CL_SI_RECEBER_VENDA_ORDE definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_RECEBER_VENDA_ORDE .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_RECEBER_VENDA_ORDE IMPLEMENTATION.


  METHOD zclsd_ii_si_receber_venda_orde~si_receber_venda_ordem_inb.
    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg    TYPE ty_msg,
          ls_output TYPE zclsd_mt_status_ordem.

    TRY.

        DATA(lv_ordemVenda) = NEW zclsd_wevo_criacao_ov( )->processa_interface_criacao_ov( iv_input = input ).

        IF lv_ordemVenda IS NOT INITIAL.
          ls_output-mt_status_ordem-salesdocum = lv_ordemVenda.
          ls_output-mt_status_ordem-purch_no_c = input-mt_venda_ordem-purch_no_c.
          ls_output-mt_status_ordem-auart = input-mt_venda_ordem-doc_type.
          NEW zclsd_co_si_enviar_status_orde( )->si_enviar_status_ordem_out( output = ls_output ).
        ENDIF.

      CATCH zcxsd_wevo_ordem_venda INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZSD_CX_FMT_VENDA_ORDEM'
            bapireturn_tab       = lo_cx_erro->get_bapiretreturn( ).

      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZSD_CX_FMT_VENDA_ORDEM'
            bapireturn_tab       = NEW zcxsd_wevo_ordem_venda(
                                                              textid      = zcxsd_wevo_ordem_venda=>zcxsd_wevo_ordem_venda
                                                              gv_msgv1    = ls_msg-msgv1
                                                              gv_msgv2    = ls_msg-msgv2
                                                              gv_msgv3    = ls_msg-msgv3
                                                              gv_msgv4    = ls_msg-msgv4
                                                            )->get_bapiretreturn( ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
