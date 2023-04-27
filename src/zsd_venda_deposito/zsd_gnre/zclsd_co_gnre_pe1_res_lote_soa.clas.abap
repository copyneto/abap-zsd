class ZCLSD_CO_GNRE_PE1_RES_LOTE_SOA definition
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
  methods CONSULTAR
    importing
      !INPUT type ZGNRE_DADOS_MSG1
    exporting
      !OUTPUT type ZGNRE_RESPOSTA_MSG
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CO_GNRE_PE1_RES_LOTE_SOA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSD_CO_GNRE_PE1_RES_LOTE_SOA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method CONSULTAR.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CONSULTAR'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
