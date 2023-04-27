class ZCLSD_IONZ_NFE_ADD_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_J_1BNF_ADD_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_IONZ_NFE_ADD_DATA IMPLEMENTATION.


  METHOD if_j_1bnf_add_data~fill_cod_sit.

    DATA(lo_notas) = NEW zclsd_notas_autorizadas( ).

    IF is_header-code EQ '100'.
      TRY.
          lo_notas->main( is_header = is_header ).
        CATCH zcxca_erro_interface.
      ENDTRY.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
