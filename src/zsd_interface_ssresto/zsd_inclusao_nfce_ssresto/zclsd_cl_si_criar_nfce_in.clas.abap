class ZCLSD_CL_SI_CRIAR_NFCE_IN definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_CRIAR_NFCE_IN .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_CRIAR_NFCE_IN IMPLEMENTATION.


  METHOD zclsd_ii_si_criar_nfce_in~si_criar_nfce_in.
    TYPES: BEGIN OF ty_msg,
             msgv1 TYPE msgv1,
             msgv2 TYPE msgv2,
             msgv3 TYPE msgv3,
             msgv4 TYPE msgv4,
           END OF ty_msg.
    DATA: ls_msg TYPE ty_msg.

    TRY.
        NEW zclsd_nfce_ssresto( )->processa_interface_nfce_PUT( input ).
      CATCH zcxsd_nfce_ssresto INTO DATA(lo_cx_erro).
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCLSD_CX_FMT_CRIAR_NFCE'
            bapireturn_tab       = lo_cx_erro->get_bapiretreturn( ).
      CATCH cx_root INTO DATA(lo_cx_root).
        ls_msg = lo_cx_root->get_text( ).

        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
            exception_class_name = 'ZCLSD_CX_FMT_CRIAR_NFCE'
            bapireturn_tab       = NEW zcxsd_nfce_ssresto(
                                                              textid      = zcxsd_nfce_ssresto=>zcxsd_nfce_ssresto
                                                              gv_msgv1    = ls_msg-msgv1
                                                              gv_msgv2    = ls_msg-msgv2
                                                              gv_msgv3    = ls_msg-msgv3
                                                              gv_msgv4    = ls_msg-msgv4
                                                            )->get_bapiretreturn( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
