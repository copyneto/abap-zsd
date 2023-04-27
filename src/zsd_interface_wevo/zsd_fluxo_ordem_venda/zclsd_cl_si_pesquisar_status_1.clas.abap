CLASS zclsd_cl_si_pesquisar_status_1 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_pesquisar_status_1.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CL_SI_PESQUISAR_STATUS_1 IMPLEMENTATION.


  METHOD zclsd_ii_si_pesquisar_status_1~si_pesquisar_status_fluxo_orde.
*** **** INSERT IMPLEMENTATION HERE **** ***
    TRY.

        NEW zclsd_fluxo_ordem_vendas( )->get_data(
            EXPORTING
                is_fluxo_ordem = VALUE zclsd_dt_status_fluxo_ordem_v3( vbelv = input-mt_status_fluxo_ordem_venda-vbelv
                                                                       bstkd = input-mt_status_fluxo_ordem_venda-bstkd
                                                                       auart = input-mt_status_fluxo_ordem_venda-auart )
           IMPORTING
                es_fluxo_ordem_ve = output

         ).
      CATCH cx_ai_system_fault.
*        me->error_raise( is_ret = VALUE scx_t100key(  attr1 = gc_erros-classe attr2 = gc_erros-interface attr3 = gc_erros-metodo ) ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
