CLASS zclsd_cl_si_criacao_ordem_vend DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_criacao_ordem_vend .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_cl_si_criacao_ordem_vend IMPLEMENTATION.

  METHOD zclsd_ii_si_criacao_ordem_vend~si_criacao_ordem_venda_fluig_i.
    TRY.

        NEW zclsd_criacao_ordens_vendas( input ).

      CATCH zcxsd_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data1( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_criacao_ordem_ve1
          EXPORTING
            standard = ls_erro.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
