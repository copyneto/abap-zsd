CLASS zclsd_cl_si_consulta_ativo_inb DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_consulta_ativo_inb .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_CL_SI_CONSULTA_ATIVO_INB IMPLEMENTATION.


  METHOD zclsd_ii_si_consulta_ativo_inb~si_consulta_ativo_inb.
    TRY.

        DATA(lo_envio_ativos) = NEW zclsd_envio_ativos( ).
        lo_envio_ativos->get_data( input ).

      CATCH zcxsd_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data7( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_consulta_ativo
          EXPORTING
            standard = ls_erro.
    ENDTRY.

    TRY.

        lo_envio_ativos->envio_fluig( IMPORTING es_output = output ).

      CATCH zcxsd_erro_interface INTO DATA(lo_erro_r).

        DATA(ls_erro_r) = VALUE zclsd_exchange_fault_data7( fault_text = lo_erro_r->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_consulta_ativo
          EXPORTING
            standard = ls_erro_r.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
