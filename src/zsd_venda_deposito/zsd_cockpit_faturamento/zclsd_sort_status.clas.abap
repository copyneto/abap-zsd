CLASS zclsd_sort_status DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
        INTERFACES:
      if_sadl_exit_filter_transform .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_sort_status IMPLEMENTATION.




  METHOD if_sadl_exit_filter_transform~map_atom.

    DATA(lo_cfac)  = cl_sadl_cond_prov_factory_pub=>create_simple_cond_factory(  ).
    DATA(lo_flightdate)  = lo_cfac->element( 'STATUS').

    CASE iv_operator.

      WHEN if_sadl_exit_filter_transform~co_operator-equals        .
        ro_condition = lo_flightdate->equals( 'Indisponível' ).

      WHEN OTHERS.
      ENDCASE.
  ENDMETHOD.

ENDCLASS.
