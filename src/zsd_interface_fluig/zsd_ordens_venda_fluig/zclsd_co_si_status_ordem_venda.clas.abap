class ZCLSD_CO_SI_STATUS_ORDEM_VENDA definition
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
  methods SI_STATUS_ORDEM_VENDA_FLUIG_OU
    importing
      !OUTPUT type ZCLSD_MT_STATUS_ORDEM_VENDA_FL
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CO_SI_STATUS_ORDEM_VENDA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSD_CO_SI_STATUS_ORDEM_VENDA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method SI_STATUS_ORDEM_VENDA_FLUIG_OU.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'OUTPUT' kind = '0' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'SI_STATUS_ORDEM_VENDA_FLUIG_OU'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
