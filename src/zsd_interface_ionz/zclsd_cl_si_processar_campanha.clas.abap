class ZCLSD_CL_SI_PROCESSAR_CAMPANHA definition
  public
  create public .

public section.

  interfaces ZCLSD_II_SI_PROCESSAR_CAMPANHA .
protected section.
private section.
ENDCLASS.

CLASS ZCLSD_CL_SI_PROCESSAR_CAMPANHA IMPLEMENTATION.

  METHOD zclsd_ii_si_processar_campanha~si_processar_campanha_inb.

    TRY.
        NEW zclsd_processar_campanha( )->processar_campanha( is_input = input  ).

      CATCH zcxca_erro_interface INTO DATA(lo_erro).

        DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).

        RAISE EXCEPTION TYPE zclsd_cx_fmt_criacao
          EXPORTING
            standard = ls_erro.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
