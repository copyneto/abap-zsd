CLASS zclsd_verif_util_filter DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .
  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_filter_transform .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.


CLASS zclsd_verif_util_filter IMPLEMENTATION.

  METHOD if_sadl_exit_filter_transform~map_atom.
    DATA(lo_order) = cl_sadl_cond_prov_factory_pub=>create_simple_cond_factory( )->element( 'MATERIAL' ).
    ro_condition = lo_order->equals( iv_value ).
  ENDMETHOD.
ENDCLASS.
