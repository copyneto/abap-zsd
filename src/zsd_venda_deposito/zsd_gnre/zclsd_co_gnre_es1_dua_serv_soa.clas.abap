class ZCLSD_CO_GNRE_ES1_DUA_SERV_SOA definition
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
  methods DUA_CDA_EMISSAO
    importing
      !INPUT type ZDUA_CDA_EMISSAO
    exporting
      !OUTPUT type ZDUA_CDA_EMISSAO_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_CONSULTA
    importing
      !INPUT type ZDUA_CONSULTA
    exporting
      !OUTPUT type ZDUA_CONSULTA_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_CONSULTA_AREA_SERVICO
    importing
      !INPUT type ZDUA_CONSULTA_AREA_SERVICO
    exporting
      !OUTPUT type ZDUA_CONSULTA_AREA_SERVICO_RES
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_CONSULTA_AREA_SERVICO_UNID
    importing
      !INPUT type ZDUA_CONSULTA_AREA_SERVICO_UN1
    exporting
      !OUTPUT type ZDUA_CONSULTA_AREA_SERVICO_UNI
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_CONSULTA_MUNICIPIO
    importing
      !INPUT type ZDUA_CONSULTA_MUNICIPIO
    exporting
      !OUTPUT type ZDUA_CONSULTA_MUNICIPIO_RESPON
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_CONSULTA_VALOR_SERVICO
    importing
      !INPUT type ZDUA_CONSULTA_VALOR_SERVICO
    exporting
      !OUTPUT type ZDUA_CONSULTA_VALOR_SERVICO_RE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_EMISSAO
    importing
      !INPUT type ZDUA_EMISSAO
    exporting
      !OUTPUT type ZDUA_EMISSAO_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_OBTER_PDF
    importing
      !INPUT type ZDUA_OBTER_PDF
    exporting
      !OUTPUT type ZDUA_OBTER_PDF_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_PAGAMENTO
    importing
      !INPUT type ZDUA_PAGAMENTO
    exporting
      !OUTPUT type ZDUA_PAGAMENTO_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
  methods DUA_PAGOS
    importing
      !INPUT type ZDUA_PAGOS
    exporting
      !OUTPUT type ZDUA_PAGOS_RESPONSE
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_CO_GNRE_ES1_DUA_SERV_SOA IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCLSD_CO_GNRE_ES1_DUA_SERV_SOA'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method DUA_CDA_EMISSAO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CDA_EMISSAO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_CONSULTA.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CONSULTA'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_CONSULTA_AREA_SERVICO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CONSULTA_AREA_SERVICO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_CONSULTA_AREA_SERVICO_UNID.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CONSULTA_AREA_SERVICO_UNID'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_CONSULTA_MUNICIPIO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CONSULTA_MUNICIPIO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_CONSULTA_VALOR_SERVICO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_CONSULTA_VALOR_SERVICO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_EMISSAO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_EMISSAO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_OBTER_PDF.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_OBTER_PDF'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_PAGAMENTO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_PAGAMENTO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method DUA_PAGOS.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'DUA_PAGOS'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
