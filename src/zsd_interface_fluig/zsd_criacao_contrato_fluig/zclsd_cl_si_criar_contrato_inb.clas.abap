CLASS zclsd_cl_si_criar_contrato_inb DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_criar_contrato_inb .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_cl_si_criar_contrato_inb IMPLEMENTATION.

  METHOD zclsd_ii_si_criar_contrato_inb~si_criar_contrato_inb.
    TRY.

        NEW zclsd_criacao_contratos( input ).

      CATCH zcxsd_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data6( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_criar_contrato
          EXPORTING
            standard = ls_erro.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
