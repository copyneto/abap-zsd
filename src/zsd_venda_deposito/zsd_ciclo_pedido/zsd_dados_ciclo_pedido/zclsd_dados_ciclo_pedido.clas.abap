"!<p>Essa classe é utilizada para cálculo do Ciclo de Pedido
"!<p><strong>Autor:</strong> Bruno Costa - Meta</p>
"!<p><strong>Data:</strong> 04/02/2022</p>
class ZCLSD_DADOS_CICLO_PEDIDO definition
  public
  final
  create public .

public section.

  types:
    tt_nivel_ser TYPE STANDARD TABLE OF ztsd_nivel_ser WITH EMPTY KEY .
  types:
    tt_range_evento TYPE RANGE OF /scmtms/tor_event .

    "! Método para ser chamado na construção da classe e
    "! instanciar outras classes pertinentes ao processo
  methods CONSTRUCTOR .
    "! Método para ser chamado no calculo da ordem de venda
    "! @parameter iv_auart   | Tipo de documento de vendas
    "! @parameter iv_vbeln   | Documento de vendas
    "! @parameter iv_bstdk   | Data de referência do cliente
    "! @parameter iv_erdat   | Data de criação do registro
    "! @parameter iv_lib_com | Data de criação do registro
    "! @parameter iv_cmgst   | Credit Status
    "! @parameter iv_cmfre   | Data de liberação do documento
  methods CALCULO_ORDEM_VENDA
    importing
      value(IV_AUART) type VBAK-AUART
      value(IV_VBELN) type VBAK-VBELN
      value(IV_BSTDK) type VBAK-BSTDK
      value(IV_ERDAT) type VBAK-ERDAT
      value(IV_LIB_COM) type VBAK-ZZDATA_LIB_COM
      value(IV_CMGST) type VBAK-CMGST
      value(IV_CMFRE) type VBAK-CMFRE
      value(IV_ROUTE) type VBAP-ROUTE optional
      value(IV_LIFSK) type VBAK-LIFSK optional .
    "! Método para ser chamado no calculo da ordem de frete
    "! @parameter iv_key         | ID Registro
    "! @parameter iv_date        | Data Atual
    "! @parameter iv_event_code  | Código do Evento
    "! @parameter iv_evento      | Evento
  methods CALCULO_ORDEM_FRETE
    importing
      !IV_KEY type /BOBF/CONF_KEY
      !IV_DATE type /SCMTMS/ACTUAL_DATE
      !IV_EVENT_CODE type /SCMTMS/TOR_EVENT
      !IV_EVENTO type ZE_EVENTO .
    "! Método para ser chamado no calculo do cockpit de faturamento
    "! @parameter it_vbeln      | Nº Documento de vendas
  methods CALCULO_COCKPIT_FATURAMENTO
    importing
      !IT_VBELN type ZCLSD_DADOS_CICLO_PEDIDO_FAT=>TT_VBELN_LIST
    raising
      ZCXSD_CICLO_PEDIDO .
    "! Método para realizar o calculo do ciclo de pedido
    "! @parameter iv_ordem          | Nº Documento de vendas
    "! @parameter iv_rota           | Rota
    "! @parameter iv_remessa        | Nº Remessa
    "! @parameter iv_data_evento    | Data do evento
    "! @parameter iv_evento         | Evento
    "! @parameter iv_evento_i       | Evento inicio
    "! @parameter iv_evento_f       | Evento fim
  methods CALCULA_DATA
    importing
      !IV_ORDEM type VBELN_VA
      !IV_ROTA type VBAP-ROUTE
      !IV_REMESSA type VBELN_VL
      !IV_DATA_EVENTO type SYDATUM
      !IV_EVENTO type ZE_EVENTO
      !IV_EVENTO_I type ZE_EVEN
      !IV_EVENTO_F type ZE_EVEN_F .
    "! Método para ser chamado no calculo do cockpit de faturamento
    "! @parameter iv_vbeln      | Documento de vendas
  methods CALCULO_FATURAMENTO
    importing
      value(IV_VBELN) type VBRK-VBELN .
  PROTECTED SECTION.

  PRIVATE SECTION.

    DATA go_ciclo_pedido_faturamento TYPE REF TO zclsd_dados_ciclo_pedido_fat .
    DATA go_ciclo_pedido_util TYPE REF TO zclsd_ciclo_pedido_util .
    DATA go_ciclo_po_updater TYPE REF TO zclsd_update_ciclo_po_tab .
    DATA go_parametros TYPE REF TO zclca_tabela_parametros .

    METHODS busca_parametros_of
      EXPORTING
        !ev_roteiriza TYPE tt_range_evento
        !ev_libera    TYPE tt_range_evento
        !ev_carrega   TYPE tt_range_evento
        !ev_saida     TYPE tt_range_evento
        !ev_entrega   TYPE tt_range_evento
        !ev_retorno   TYPE tt_range_evento .

    METHODS busca_eventos
      IMPORTING
        !iv_route    TYPE vbap-route
      EXPORTING
        !ev_evento   TYPE ze_evento
        !ev_evento_i TYPE ze_even
        !ev_evento_f TYPE ze_even_f.


ENDCLASS.



CLASS ZCLSD_DADOS_CICLO_PEDIDO IMPLEMENTATION.


  METHOD constructor.
    go_parametros               = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023
    go_ciclo_pedido_faturamento = NEW #( ).
    go_ciclo_pedido_util        = NEW #( ).
    go_ciclo_po_updater         = NEW #( ).
  ENDMETHOD.


  METHOD calculo_ordem_venda.

    CONSTANTS: lc_001 TYPE c LENGTH 3 VALUE '001',
               lc_002 TYPE c LENGTH 3 VALUE '002',
               lc_003 TYPE c LENGTH 3 VALUE '003',
               lc_d   TYPE c LENGTH 1 VALUE 'D',
               lc_a   TYPE c LENGTH 1 VALUE 'A'.

    DATA: BEGIN OF ls_param,
            modulo TYPE ztca_param_par-modulo VALUE 'SD',
            chave1 TYPE ztca_param_par-chave1 VALUE 'CICLO_PEDIDO',
            chave2 TYPE ztca_param_par-chave1 VALUE 'TIPOS_OV',
          END OF ls_param.

    DATA: lr_auart TYPE RANGE OF vbak-auart.

    DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 22.07.2023

    TRY.

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = ls_param-modulo
            iv_chave1 = ls_param-chave1
            iv_chave2 = ls_param-chave2
          IMPORTING
            et_range  = lr_auart ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

    IF lr_auart IS INITIAL.
      EXIT.
    ENDIF.

    CHECK iv_auart IN lr_auart.

*    SELECT SINGLE route
*      FROM vbap
*      INTO @DATA(lv_route)
*     WHERE vbeln = @iv_vbeln.

*    IF sy-subrc NE 0.
*      EXIT.
*    ENDIF.
    IF iv_route IS INITIAL.
      EXIT.
    ELSE.
      DATA(lv_route) = iv_route.

    ENDIF.

    calcula_data(
      EXPORTING
        iv_ordem       = iv_vbeln              " Documento de vendas
        iv_rota        = lv_route              " Itinerário
        iv_remessa     = ''                    " Remessa
        iv_data_evento = iv_bstdk              " Data do evento
        iv_evento      = abap_true             " Tipo de Evento (Inicio = X / Fim = ' ')
        iv_evento_i    = lc_001                " Evento início - Criação do pedido no Sirius
        iv_evento_f    = ''                    " Evento fim
    ).


    calcula_data(
      EXPORTING
        iv_ordem       = iv_vbeln              " Documento de vendas
        iv_rota        = lv_route              " Itinerário
        iv_remessa     = ''                    " Remessa
        iv_data_evento = sy-datum              " Data do evento
        iv_evento      = abap_false            " Tipo de Evento (Inicio = X / Fim = ' ')
        iv_evento_i    = ''                    " Evento início
        iv_evento_f    = lc_001                " Evento fim - Criação do pedido no SAP
    ).
    IF iv_lifsk IS NOT INITIAL.
      calcula_data(
    EXPORTING
      iv_ordem       = iv_vbeln              " Documento de vendas
      iv_rota        = lv_route              " Itinerário
      iv_remessa     = ''                    " Remessa
      iv_data_evento = iv_erdat              " Data do evento
      iv_evento      = abap_true             " Tipo de Evento (Inicio = X / Fim = ' ')
      iv_evento_i    = lc_002                " Evento início - Criação do pedido no SAP
      iv_evento_f    = ''                    " Evento fim
  ).

      IF iv_lib_com IS NOT INITIAL.

        calcula_data(
          EXPORTING
            iv_ordem       = iv_vbeln            " Documento de vendas
            iv_rota        = lv_route            " Itinerário
            iv_remessa     = ''                  " Remessa
            iv_data_evento = iv_lib_com          " Data do evento
            iv_evento      = abap_false          " Tipo de Evento (Inicio = X / Fim = ' ')
            iv_evento_i    = ''                  " Evento início
            iv_evento_f    = lc_002              " Evento fim - Liberação Comercial
        ).

      ENDIF.
    ENDIF.
*    IF iv_cmgst EQ lc_d
*    AND iv_cmgst NE lc_d.
    IF iv_cmgst NE space
      AND iv_cmgst NE lc_a.

      calcula_data(
        EXPORTING
          iv_ordem       = iv_vbeln              " Documento de vendas
          iv_rota        = lv_route              " Itinerário
          iv_remessa     = ''                    " Remessa
          iv_data_evento = iv_cmfre              " Data do evento
          iv_evento      = abap_false            " Tipo de Evento (Inicio = X / Fim = ' ')
          iv_evento_i    = ''                    " Evento início
          iv_evento_f    = lc_003                " Evento fim - Liberação Crédito
      ).

    ENDIF.

  ENDMETHOD.


  METHOD calculo_ordem_frete.

    DATA: lv_date_exp       TYPE scal-date,
          lv_date_imp       TYPE scal-date,
          lv_factorydate    TYPE  scal-facdate,
          lv_workingday_ind TYPE scal-indicator,
          lv_vbeln          TYPE vbeln_vl.

    DATA: lv_evento   TYPE ze_evento,
          lv_evento_i TYPE ze_even,
          lv_evento_f TYPE ze_even_f.

    DATA: lr_lfart TYPE RANGE OF lfart.

    SELECT SINGLE db_key
             FROM /scmtms/d_torrot
             INTO @DATA(lv_db_key)
            WHERE db_key EQ @iv_key.

    CHECK sy-subrc EQ 0.

    SELECT SINGLE base_btd_id
             FROM /scmtms/d_torite
             INTO @DATA(lv_base_btd_id)
            WHERE parent_key  EQ @lv_db_key
              AND base_btd_id NE @space.

    CHECK sy-subrc EQ 0.

    lv_vbeln = lv_base_btd_id+25.

    SELECT SINGLE vbeln, lfart
             FROM likp
             INTO @DATA(ls_likp)
            WHERE vbeln EQ @lv_vbeln.

    CHECK sy-subrc EQ 0.

    SELECT SINGLE vgbel
             FROM lips
             INTO @DATA(lv_vgbel)
            WHERE vbeln EQ @ls_likp-vbeln.

    CHECK sy-subrc EQ 0.

    SELECT SINGLE vbeln
             FROM vbak
             INTO @DATA(lv_vbak_vbeln)
            WHERE vbeln EQ @lv_vgbel.

    CHECK sy-subrc EQ 0.

    SELECT SINGLE route
             FROM vbap
             INTO @DATA(lv_route)
            WHERE vbeln EQ @lv_vbak_vbeln.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_OV'
          IMPORTING
            et_range  = lr_lfart
        ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    CHECK NOT lr_lfart IS INITIAL.

    CHECK ls_likp-lfart IN lr_lfart.

    IF iv_evento EQ abap_true.

      busca_eventos(
        EXPORTING
           iv_route   = lv_route
        IMPORTING
          ev_evento   = lv_evento
          ev_evento_i = lv_evento_i
          ev_evento_f = lv_evento_f
      ).

    ELSE.

      busca_parametros_of(
        IMPORTING
          ev_roteiriza = DATA(lr_roteiriza)
          ev_libera    = DATA(lr_libera)
          ev_carrega   = DATA(lr_carrega)
          ev_saida     = DATA(lr_saida)
          ev_entrega   = DATA(lr_entrega)
          ev_retorno   = DATA(lr_retorno)
      ).

      lv_evento_f = COND #( WHEN iv_event_code IN lr_roteiriza
                            THEN '005'
                            ELSE
                    COND #( WHEN iv_event_code IN lr_libera
                            THEN '006'
                            ELSE
                    COND #( WHEN iv_event_code IN lr_carrega
                            THEN '007'
                            ELSE
                    COND #( WHEN iv_event_code IN lr_saida
                            THEN '009'
                            ELSE
                    COND #( WHEN iv_event_code IN lr_entrega
                            THEN '010'
                            ELSE
                    COND #( WHEN iv_event_code IN lr_retorno
                            THEN '011'
                            ELSE lv_evento_f ) ) ) ) ) ).

    ENDIF.

    lv_evento = iv_evento.

    IF NOT lv_evento_i IS INITIAL OR NOT lv_evento_f IS INITIAL.

      CONVERT TIME STAMP iv_date TIME ZONE sy-zonlo
               INTO DATE DATA(lv_date) TIME DATA(lv_time).

      calcula_data(
        EXPORTING
          iv_ordem       = lv_vbak_vbeln  " Documento de vendas
          iv_rota        = lv_route       " Itinerário
          iv_remessa     = ls_likp-vbeln  " Remessa
          iv_data_evento = lv_date        " Data do evento
          iv_evento      = lv_evento      " Tipo de Evento (Inicio = X / Fim = ' ')
          iv_evento_i    = lv_evento_i    " Evento início
          iv_evento_f    = lv_evento_f    " Evento fim
      ).

    ENDIF.


  ENDMETHOD.


  METHOD calculo_cockpit_faturamento.
    go_ciclo_pedido_faturamento->calculate_cockpit_faturamento( it_vbeln ).
  ENDMETHOD.


  METHOD busca_parametros_of.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'ROTEIRIZ'"'ROTEIRIZA'
          IMPORTING
            et_range  = ev_roteiriza ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'LIBERA'
          IMPORTING
            et_range  = ev_libera ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'CARREGA'
          IMPORTING
            et_range  = ev_carrega ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'SAIDA'
          IMPORTING
            et_range  = ev_saida ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'RETORNO'
          IMPORTING
            et_range  = ev_retorno ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

    TRY.
        go_parametros->m_get_range(
          EXPORTING
            iv_modulo = 'SD'
            iv_chave1 = 'CICLO_PEDIDO'
            iv_chave2 = 'TIPOS_EVENTO'
            iv_chave3 = 'ENTREGA'
          IMPORTING
            et_range  = ev_entrega ).
      CATCH zcxca_tabela_parametros. " Classe de exceção Tabela de Parâmetros

    ENDTRY.

  ENDMETHOD.


  METHOD calcula_data.
    TRY.
        DATA(lt_ciclo_po) = go_ciclo_pedido_util->build_ciclo_po(
          EXPORTING
            iv_ordem       = iv_ordem
            iv_rota        = iv_rota
            iv_remessa     = iv_remessa
            iv_data_evento = iv_data_evento
            iv_evento      = iv_evento
            iv_evento_i    = iv_evento_i
            iv_evento_f    = iv_evento_f
        ).
        go_ciclo_po_updater->update_ciclo_po_tab( lt_ciclo_po ).
      CATCH zcxsd_ciclo_pedido INTO DATA(lo_exception).
        DATA(lv_message) = lo_exception->gs_message.
    ENDTRY.
  ENDMETHOD.


  METHOD calculo_faturamento.

    CONSTANTS: lc_008 TYPE c LENGTH 3 VALUE '008'. " Emissão da NF-E

    SELECT SINGLE vgbel
      FROM vbrp
      INTO @DATA(lv_vgbel)
     WHERE vbeln = @iv_vbeln.

    IF sy-subrc NE 0.
      EXIT.
    ENDIF.

    SELECT SINGLE route
      FROM likp
      INTO @DATA(lv_route)
     WHERE vbeln = @lv_vgbel.

    IF sy-subrc NE 0.
      EXIT.
    ENDIF.

    calcula_data(
      EXPORTING
        iv_ordem       = iv_vbeln              " Documento de vendas
        iv_rota        = lv_route              " Itinerário
        iv_remessa     = lv_vgbel              " Remessa
        iv_data_evento = sy-datum              " Data da criação do evento
        iv_evento      = abap_false            " Tipo de Evento (Inicio = X / Fim = ' ')
        iv_evento_i    = ''                    " Evento início
        iv_evento_f    = lc_008                " Evento fim
    ).

  ENDMETHOD.


  METHOD busca_eventos.

    SELECT SINGLE ziti, zmed, zeveni, zevenf
             FROM zi_sd_01_nivel
            WHERE ziti EQ @iv_route
            INTO @DATA(ls_nivel_serv).

    IF sy-subrc EQ 0.
      IF NOT ls_nivel_serv-zeveni IS INITIAL.
        ev_evento   = abap_true.
        ev_evento_i = ls_nivel_serv-zeveni.
      ELSE.
        ev_evento   = abap_false.
        ev_evento_f = ls_nivel_serv-zevenf.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
