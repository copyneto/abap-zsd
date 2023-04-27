class ZCLSD_CL_SI_ENTRAR_NOTA_FISCAL definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_ENTRAR_NOTA_FISCAL .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_ENTRAR_NOTA_FISCAL IMPLEMENTATION.


  METHOD zclsd_ii_si_entrar_nota_fiscal~si_entrar_nota_fiscal_servico.

    TRY.
        DATA(lr_gko_process) = NEW zcltm_gko_process( iv_new      = abap_true
                                                      iv_tpdoc     = zcltm_gko_process=>gc_tpdoc-nfs
                                                      iv_tpprocess = zcltm_gko_process=>gc_tpprocess-automatico
                                                      is_nfs_data   = input-mt_nota_fiscal_servico  ).
        lr_gko_process->process( ).
        lr_gko_process->persist( ).
* BEGIN OF DELETE - JWSILVA - 30.03.2023
** Processamento de cálculo de custo da OF após integração do documento de frete.
*        TRY.
*              lr_gko_process->process( ).
*              lr_gko_process->persist( ).
*              lr_gko_process->free( ).
*            CATCH zcxtm_gko_process INTO DATA(lr_cxtm_gko_process_2).
*              IF lr_gko_process IS BOUND.
*                lr_gko_process->free( ).
*              ENDIF.
*              CALL METHOD cl_proxy_fault=>raise
*                EXPORTING
**                 exception_class_name = 'ZCX_FMT_ENTRAR_NOTA_FISCAL_SER'
**                 bapireturn_tab       = lr_cx_gko_process->get_bapi_return( ).
*                  exception_class_name = 'ZCLSD_CX_FMT_ENTRAR_NOTA_FISCA'
*                  bapireturn_tab       = lr_cxtm_gko_process_2->get_bapi_return( ).
*        ENDTRY.
* END OF DELETE - JWSILVA - 30.03.2023

        lr_gko_process->free( ).

      CATCH zcxtm_gko_process INTO DATA(lr_cxtm_gko_process).
        IF lr_gko_process IS BOUND.
          lr_gko_process->free( ).
        ENDIF.
        CALL METHOD cl_proxy_fault=>raise
          EXPORTING
*           exception_class_name = 'ZCX_FMT_ENTRAR_NOTA_FISCAL_SER'
*           bapireturn_tab       = lr_cx_gko_process->get_bapi_return( ).
            exception_class_name = 'ZCLSD_CX_FMT_ENTRAR_NOTA_FISCA'
            bapireturn_tab       = lr_cxtm_gko_process->get_bapi_return( ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
