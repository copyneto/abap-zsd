CLASS zclsd_cl_si_gravar_dados_repro DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_gravar_dados_repro .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_cl_si_gravar_dados_repro IMPLEMENTATION.

  METHOD zclsd_ii_si_gravar_dados_repro~si_gravar_dados_reprocessar_in.
    TRY.
        NEW zclsd_processar_campanha( )->reprocessar_campanha( it_input = input  ).

      CATCH zcxca_erro_interface INTO DATA(lo_erro).

         DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_criacao
          EXPORTING
            standard = ls_erro.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
