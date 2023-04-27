class ZCLSD_CO_GNRE_PE1_LOTE_REC_SOA definition
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
  methods PROCESSAR
    importing
      !INPUT type ZGNRE_DADOS_MSG2
    exporting
      !OUTPUT type ZPROCESSAR_RESPONSE1
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CO_GNRE_PE1_LOTE_REC_SOA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSD_CO_GNRE_PE1_LOTE_REC_SOA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method PROCESSAR.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'PROCESSAR'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
