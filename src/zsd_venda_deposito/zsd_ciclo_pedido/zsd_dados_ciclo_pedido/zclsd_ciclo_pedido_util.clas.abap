"!<p>Classe utilizada para calculo e construção dos dados a serem persistidos na tabela <strong>ZTSD_CICLO_PO</strong>
"!<p><strong>Autor:</strong> Schinaider Sá - Meta</p>
"!<p><strong>Data:</strong> 30/01/2022</p>
CLASS zclsd_ciclo_pedido_util DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES:
      tt_evento_inicio TYPE RANGE OF ze_even,
      tt_evento_fim    TYPE RANGE OF ze_even_f,

      BEGIN OF ty_nivel_servico,
        Ziti            TYPE ze_iti,
        Zmed            TYPE ze_med,
        ZevenI          TYPE ze_even,
        ZevenF          TYPE ze_even_f,
        Zprah           TYPE ze_prah,
        Zprad           TYPE ze_prad,
        Zcale           TYPE fabkl,
        hora_corte      TYPE ze_hor,
        dia_faturamento TYPE ze_dia,
      END OF ty_nivel_servico,

      tt_niveis_servico TYPE STANDARD TABLE OF ty_nivel_servico WITH EMPTY KEY.


    "! Faz o calculo das datas do dia de faturamento para o ciclo de pedido, e
    "! devolve uma tabela de registros a partir dos criterios de entrada em conjuto com a tabela de niveis de serviço
    "! @parameter iv_ordem | Ordem de Compra
    "! @parameter iv_rota | Id da Rota
    "! @parameter iv_remessa | Id da Remessa
    "! @parameter iv_data_evento | Data do evento
    "! @parameter iv_evento | Tipo do Evento
    "! @parameter iv_evento_i | Evento Inicio
    "! @parameter iv_evento_f | Evento Fim
    "! @parameter rv_result | Tabela de resultados contento dados calculados do ciclo de pedido
    "! @raising zcxsd_ciclo_pedido | Exceção para calculo das datas do ciclo de pedido
    METHODS build_ciclo_po
      IMPORTING
        iv_ordem         TYPE vbeln_va
        iv_rota          TYPE vbap-route
        iv_remessa       TYPE vbeln_vl OPTIONAL
        iv_data_evento   TYPE sydatum
        iv_evento        TYPE ze_evento
        iv_evento_i      TYPE ze_even OPTIONAL
        iv_evento_f      TYPE ze_even_f OPTIONAL
      RETURNING
        VALUE(rv_result) TYPE zttsd_ciclo_po
      RAISING
        zcxsd_ciclo_pedido.


  PROTECTED SECTION.
  PRIVATE SECTION.

    "! Busca dos dados de nivel de serviço a partir da CDS ZI_SD_01_NIVEL
    "! @parameter iv_rota | ID da rota
    "! @parameter it_evento_i | Evento Início
    "! @parameter it_evento_f | Evento Fim
    "! @parameter rv_result | Tabela de resultado contendo dados de nivel de serviço
    METHODS busca_niveis_servico
      IMPORTING
        iv_rota          TYPE route
        it_evento_i      TYPE tt_evento_inicio
        it_evento_f      TYPE tt_evento_fim
      RETURNING
        VALUE(rv_result) TYPE tt_niveis_servico.

    "! Wrapper para FM DATE_CONVERT_TO_FACTORYDATE
    "! @parameter iv_calculated_date | Data de entrada calculada a partir dos niveis de serviço
    "! @parameter iv_calendar_id | ID do calendário
    "! @parameter rv_result | Factory Date
    "! @raising zcxsd_ciclo_pedido | Mensagem de erro do FM convertido em exceção
    METHODS date_convert_to_factorydate
      IMPORTING
        iv_calculated_date TYPE dats
        iv_calendar_id     TYPE wfcid
      RETURNING
        VALUE(rv_result)   TYPE dats
      RAISING
        zcxsd_ciclo_pedido.

    "! Wrapper para FM DAY_IN_WEEK
    "! @parameter iv_date | Data de entrada
    "! @parameter rv_result | Dia da semana
    METHODS get_day_in_week
      IMPORTING
        iv_date          TYPE dats
      RETURNING
        VALUE(rv_result) TYPE numc1.

    "! Busca Timestamp atual
    "! @parameter rv_result | Timestamp atual
    METHODS get_timestamp
      RETURNING
        VALUE(rv_result) TYPE timestampl.

    "! Conversão de uma data e hora em timestamp no timezone local
    "! @parameter iv_date | Data de entrada
    "! @parameter iv_time | Hora de entrada
    "! @parameter rv_result | Timestamp resultado
    METHODS convert_date_time_to_timestamp
      IMPORTING
        iv_date          TYPE dats
        iv_time          TYPE t
      RETURNING
        VALUE(rv_result) TYPE timestampl.

    "! Calculo timestamp do dia de faturamento
    "! @parameter iv_data_evento | Data do evento
    "! @parameter iv_prazo_dia | Prazo em dias
    "! @parameter iv_prazo_hora | Prazo em horas
    "! @parameter iv_id_calendario | ID do calendário
    "! @parameter iv_hora_corte | Hora corte
    "! @parameter iv_dia_faturamento | Dia da semana do faturamento
    "! @parameter rv_result | Timestamp calculado
    "! @raising zcxsd_ciclo_pedido | Mensagem de erro convertido em exceção
    METHODS calculate_date_time
      IMPORTING
        iv_data_evento     TYPE dats DEFAULT sy-datum
        iv_prazo_dia       TYPE ze_prad
        iv_prazo_hora      TYPE ze_prah
        iv_id_calendario   TYPE fabkl
        iv_hora_corte      TYPE ze_hor
        iv_dia_faturamento TYPE ze_dia
      RETURNING
        VALUE(rv_result)   TYPE timestampl
      RAISING
        zcxsd_ciclo_pedido.

    "! Calculo da data do faturamento
    "! @parameter iv_dia_faturamento | Dia de faturamento em week day
    "! @parameter iv_factory_date | Factory Date
    "! @parameter iv_calendar_id | ID do caalendario
    "! @parameter rv_result | Data resultado
    "! @raising zcxsd_ciclo_pedido | Mensagem de erro convertida em exceção
    METHODS calculate_dia_faturamento
      IMPORTING
        iv_dia_faturamento TYPE ze_dia
        iv_factory_date    TYPE dats
        iv_calendar_id     TYPE wfcid
      RETURNING
        VALUE(rv_result)   TYPE dats
      RAISING
        zcxsd_ciclo_pedido.

    "! Calculo do numero de dias a somar em uma data para se atingir um determinado dia da semana
    "! @parameter iv_dia_faturamento | Dia do faturamento em week day
    "! @parameter iv_week_day | week day da data calculada
    "! @parameter rv_result | Total de dias a somar
    METHODS calculate_days_to_sum
      IMPORTING
        iv_dia_faturamento TYPE ze_dia
        iv_week_day        TYPE numc1
      RETURNING
        VALUE(rv_result)   TYPE numc1.
ENDCLASS.

CLASS zclsd_ciclo_pedido_util IMPLEMENTATION.
  METHOD build_ciclo_po.

    DATA(lt_niveis_servico) = busca_niveis_servico(
      it_evento_f = COND #(
        WHEN iv_evento = abap_false
        THEN VALUE tt_evento_fim(
          ( option = 'EQ'
            sign   = 'I'
            low    = iv_evento_f
          )
        )
        ELSE VALUE #( )
      )
      it_evento_i = COND #(
        WHEN iv_evento = abap_true
        THEN VALUE tt_evento_inicio(
          ( option = 'EQ'
            sign   = 'I'
            low    = iv_evento_i
          )
        )
        ELSE VALUE #( )
      )
      iv_rota     = iv_rota
    ).

    LOOP AT lt_niveis_servico ASSIGNING FIELD-SYMBOL(<fs_nivel_servico>).


      APPEND VALUE ztsd_ciclo_po(
        mandt               = sy-mandt
        ordem_venda         = iv_ordem
        remessa             = iv_remessa
        medicao             = <fs_nivel_servico>-Zmed
        data_hora_planejada = COND #(
                                WHEN iv_evento = abap_true
                                THEN calculate_date_time(
                                       iv_data_evento     = iv_data_evento
                                       iv_prazo_dia       = <fs_nivel_servico>-Zprad
                                       iv_prazo_hora      = <fs_nivel_servico>-Zprah
                                       iv_id_calendario   = <fs_nivel_servico>-Zcale
                                       iv_hora_corte      = <fs_nivel_servico>-hora_corte
                                       iv_dia_faturamento = <fs_nivel_servico>-dia_faturamento
                                     )
                                ELSE ''
                              )
        data_hora_realizada = COND #(
                                WHEN iv_evento = abap_false
                                THEN calculate_date_time(
                                       iv_data_evento     = iv_data_evento
                                       iv_prazo_dia       = <fs_nivel_servico>-Zprad
                                       iv_prazo_hora      = <fs_nivel_servico>-Zprah
                                       iv_id_calendario   = <fs_nivel_servico>-Zcale
                                       iv_hora_corte      = <fs_nivel_servico>-hora_corte
                                       iv_dia_faturamento = <fs_nivel_servico>-dia_faturamento
                                     )
                                ELSE ''
                              )
        data_hora_registro  = get_timestamp( )
      ) TO rv_result.

    ENDLOOP.
  ENDMETHOD.

  METHOD busca_niveis_servico.
    SELECT
      Ziti,
      Zmed,
      ZevenI,
      ZevenF,
      Zprah,
      Zprad,
      Zcale,
      \_Hora-Zhora AS hora_corte,
      \_Dia-Zdia AS dia_faturamento
      FROM zi_sd_01_nivel AS cds
      WHERE Ziti = @iv_rota
        AND ZevenI IN @it_evento_i
        AND ZevenF IN @it_evento_f
        INTO TABLE @rv_result.
  ENDMETHOD.

  METHOD date_convert_to_factorydate.
    CALL FUNCTION 'DATE_CONVERT_TO_FACTORYDATE'
      EXPORTING
        date                         = iv_calculated_date
        factory_calendar_id          = iv_calendar_id
      IMPORTING
        date                         = rv_result
      EXCEPTIONS
        calendar_buffer_not_loadable = 1
        correct_option_invalid       = 2
        date_after_range             = 3
        date_before_range            = 4
        date_invalid                 = 5
        factory_calendar_not_found   = 6
        OTHERS                       = 7.
    IF sy-subrc <> 0.
      RAISE EXCEPTION NEW zcxsd_ciclo_pedido( CORRESPONDING #( sy ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_day_in_week.
    DATA lv_wotnr TYPE p.
    CALL FUNCTION 'DAY_IN_WEEK'
      EXPORTING
        datum = iv_date
      IMPORTING
        wotnr = lv_wotnr.
    rv_result = CONV #( lv_wotnr ).
  ENDMETHOD.

  METHOD get_timestamp.
    GET TIME STAMP FIELD rv_result.
  ENDMETHOD.

  METHOD convert_date_time_to_timestamp.
    CONVERT DATE iv_date TIME iv_time INTO TIME STAMP rv_result TIME ZONE sy-zonlo.
  ENDMETHOD.

  METHOD calculate_date_time.
*    IF NOT iv_dia_faturamento CO '012345678'.
    IF iv_dia_faturamento CA sy-abcde.
      MESSAGE e006(zsd_ciclo_pedido) INTO DATA(lv_message).
      RAISE EXCEPTION NEW zcxsd_ciclo_pedido( CORRESPONDING #( sy ) ).
    ENDIF.

    DATA(lv_calculated_date) = CONV dats( iv_data_evento + iv_prazo_dia ).
    DATA(lv_factory_date) = date_convert_to_factorydate(
      iv_calculated_date = lv_calculated_date
      iv_calendar_id     = iv_id_calendario
    ).

    DATA(lv_data_faturamento) = calculate_dia_faturamento(
      iv_dia_faturamento = iv_dia_faturamento
      iv_factory_date    = lv_factory_date
      iv_calendar_id     = iv_id_calendario
    ).

    "#TODO -> Hora corte

    rv_result = convert_date_time_to_timestamp( iv_date = lv_data_faturamento iv_time = CONV t( iv_prazo_hora ) ).
  ENDMETHOD.

  METHOD calculate_dia_faturamento.
    CONSTANTS lc_dia_geral TYPE ze_dia VALUE 8.

    DATA(lv_week_day) = get_day_in_week( iv_factory_date ).

    IF iv_dia_faturamento = lc_dia_geral OR iv_dia_faturamento = lv_week_day OR iv_dia_faturamento IS INITIAL.
      rv_result = iv_factory_date.
      RETURN.
    ENDIF.

    DATA(lv_factory_date) = iv_factory_date.

    DO.
      DATA(lv_days_to_sum) = calculate_days_to_sum(
        iv_week_day        = lv_week_day
        iv_dia_faturamento = iv_dia_faturamento
      ).

      DATA(lv_calc_data_faturamento) = CONV dats( lv_factory_date + lv_days_to_sum ).

      DATA(lv_calc_factory_date) = date_convert_to_factorydate(
        iv_calculated_date = lv_calc_data_faturamento
        iv_calendar_id     = iv_calendar_id
      ).

      lv_week_day = get_day_in_week( lv_calc_factory_date ).

      IF lv_week_day = iv_dia_faturamento.
        rv_result = lv_calc_factory_date.
        RETURN.
      ELSE.
        lv_factory_date = lv_calc_factory_date.
      ENDIF.
    ENDDO.

  ENDMETHOD.

  METHOD calculate_days_to_sum.
    rv_result = COND numc1(
        WHEN iv_week_day < iv_dia_faturamento
          THEN iv_dia_faturamento - iv_week_day
        WHEN iv_week_day = '7'          "Domingo
          THEN iv_dia_faturamento
        WHEN iv_week_day = '6'          "Sabado
          THEN iv_dia_faturamento + 1
        WHEN iv_week_day = '5'          "Sexta
          THEN iv_dia_faturamento + 2
        WHEN iv_week_day = '4'          "Quinta
          THEN iv_dia_faturamento + 3
        WHEN iv_week_day = '3'          "Quarta
          THEN iv_dia_faturamento + 4
        WHEN iv_week_day = '2'          "Terça
          THEN iv_dia_faturamento + 5
        ELSE iv_dia_faturamento + 6
      ).
  ENDMETHOD.

ENDCLASS.
