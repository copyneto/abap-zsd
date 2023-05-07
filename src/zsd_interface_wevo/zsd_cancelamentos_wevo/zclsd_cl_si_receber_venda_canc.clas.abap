CLASS zclsd_cl_si_receber_venda_canc DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES zclsd_ii_si_receber_venda_canc .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclsd_cl_si_receber_venda_canc IMPLEMENTATION.

  METHOD zclsd_ii_si_receber_venda_canc~si_receber_venda_cancelamento.
*    TRY.

    NEW zclsd_cancelamentos_vendas( input ).
*      CATCH zcxsd_erro_interface INTO DATA(lo_erro).
*
*        DATA(ls_erro) = VALUE zclsd_exchange_fault_data( fault_text = lo_erro->get_text( ) ).
*
*        RAISE EXCEPTION TYPE zclsd_cx_fmt_venda_cancelament
*          EXPORTING
*            standard = ls_erro.
*    ENDTRY.
  ENDMETHOD.
ENDCLASS.
