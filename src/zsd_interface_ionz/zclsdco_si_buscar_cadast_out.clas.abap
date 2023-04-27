class ZCLSDCO_SI_BUSCAR_CADAST_OUT definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods SI_BUSCAR_CADASTROS_OUT_SYNC
    importing
      !OUTPUT type ZSDMT_CADASTROS_BUSCAR
    exporting
      !INPUT type ZSDMT_CADASTROS_BUSCAR_RESP
    raising
      CX_AI_SYSTEM_FAULT
      ZSDCX_FMT_CADASTROS .
protected section.
private section.
ENDCLASS.



CLASS ZCLSDCO_SI_BUSCAR_CADAST_OUT IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSDCO_SI_BUSCAR_CADAST_OUT'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_BUSCAR_CADASTROS_OUT_SYNC.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
    ( name = 'INPUT' kind = '1' value = ref #( INPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_BUSCAR_CADASTROS_OUT_SYNC'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
