CLASS zclsd_cl_si_receber_devolucao DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_receber_devolucao .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_cl_si_receber_devolucao IMPLEMENTATION.


  METHOD zclsd_ii_si_receber_devolucao~si_receber_devolucao_material.
    TRY.

        NEW zclsd_devolucoes_vendas( input ).

      CATCH zcxsd_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_devolucao_materia
          EXPORTING
            standard = ls_erro.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
