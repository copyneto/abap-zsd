class ZCLSD_CO_GNRE_RJ_GERAR_DOC_SOA definition
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
  methods CONSULTAR_DADOS
    importing
      !INPUT type ZCONSULTAR_DADOS
    exporting
      !OUTPUT type ZCONSULTAR_DADOS_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS
    importing
      !INPUT type ZENVIAR_DADOS
    exporting
      !OUTPUT type ZENVIAR_DADOS_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_AUTO
    importing
      !INPUT type ZENVIAR_DADOS_AUTO
    exporting
      !OUTPUT type ZENVIAR_DADOS_AUTO_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_CDI
    importing
      !INPUT type ZENVIAR_DADOS_CDI
    exporting
      !OUTPUT type ZENVIAR_DADOS_CDIRESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_ITD
    importing
      !INPUT type ZENVIAR_DADOS_ITD
    exporting
      !OUTPUT type ZENVIAR_DADOS_ITDRESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_PARCELAMENTO
    importing
      !INPUT type ZENVIAR_DADOS_PARCELAMENTO
    exporting
      !OUTPUT type ZENVIAR_DADOS_PARCELAMENTO_RES
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_PRECATORIO
    importing
      !INPUT type ZENVIAR_DADOS_PRECATORIO
    exporting
      !OUTPUT type ZENVIAR_DADOS_PRECATORIO_RESPO
    raising
      CX_AI_SYSTEM_FAULT .
  methods ENVIAR_DADOS_PROC_ESPECIAL
    importing
      !INPUT type ZENVIAR_DADOS_PROC_ESPECIAL
    exporting
      !OUTPUT type ZENVIAR_DADOS_PROC_ESPECIAL_RE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CO_GNRE_RJ_GERAR_DOC_SOA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSD_CO_GNRE_RJ_GERAR_DOC_SOA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method CONSULTAR_DADOS.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CONSULTAR_DADOS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_AUTO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_AUTO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_CDI.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_CDI'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_ITD.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_ITD'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_PARCELAMENTO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_PARCELAMENTO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_PRECATORIO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_PRECATORIO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method ENVIAR_DADOS_PROC_ESPECIAL.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'ENVIAR_DADOS_PROC_ESPECIAL'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
