class ZCLSD_CL_SI_RECEBE_ALTERACAO_O definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_RECEBE_ALTERACAO_O .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CL_SI_RECEBE_ALTERACAO_O IMPLEMENTATION.


  METHOD zclsd_ii_si_recebe_alteracao_o~si_recebe_alteracao_ordem_vend.

    DATA(lo_venda) = NEW zclsd_ordem_venda( ).

    TRY.

        lo_venda->execute_change( input ).

      CATCH zcxmm_erro_interface_mes INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_alteracao_ordem_v
          EXPORTING
            standard = ls_erro.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
