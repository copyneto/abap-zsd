class ZCLSD_CL_SI_CRIAR_ORDEM_VENDA1 definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_CRIAR_ORDEM_VENDA1 .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_CRIAR_ORDEM_VENDA1 IMPLEMENTATION.


  METHOD zclsd_ii_si_criar_ordem_venda1~si_criar_ordem_venda_in.

    DATA(lo_venda) = NEW zclsd_ordem_venda( ).

    TRY.

        lo_venda->execute_in( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_criacao
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
