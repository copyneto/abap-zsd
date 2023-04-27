CLASS zclsd_relatorio_imobilizados DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_RELATORIO_IMOBILIZADOS IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_sd_relatorio_imobilizados WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).
*    DATA lv_prazo_saida        TYPE p0001-begda.
*    DATA lv_prazo_entrada      TYPE p0001-begda.
    DATA lv_dias_atraso        TYPE vtbbewe-atage.
    DATA lv_dias_atraso2       TYPE vtbbewe-atage.
    DATA lv_dias_pendentes     TYPE vtbbewe-atage.
    DATA lv_day_saida          TYPE i.
    DATA lv_date_saida         TYPE slim_meas_date.
    DATA lv_day_entrada        TYPE i.
    DATA lv_date_entrada       TYPE slim_meas_date.

    DATA: lv_start_date      TYPE  slim_meas_date,
          lv_prazo_saida     TYPE  slim_meas_date,
          lv_prazo_entrada   TYPE  slim_meas_date,
          lv_start_timestamp TYPE  slim_timestamp,
          lv_end_timestamp   TYPE  slim_timestamp.


*    SELECT *
*    FROM zi_sd_relatorio_imobilizados
*    FOR ALL ENTRIES IN @lt_original_data
*    WHERE docnum = @lt_original_data-Docnum_Saida
*    AND   item   = @lt_original_data-Item_Saida
*        INTO TABLE @DATA(lt_dados).
    DATA(lt_dados) = lt_original_data[].
    IF lt_dados[] IS NOT INITIAL.
      SORT lt_dados BY docnum_saida item_saida.
      DELETE ADJACENT DUPLICATES FROM lt_dados COMPARING docnum_saida item_saida.

      SELECT BR_NotaFiscal, br_notafiscalitem, diasatraso1, diasatraso2, nodias
      FROM zi_sd_status_ativo_entrada
      FOR ALL ENTRIES IN @lt_dados
      WHERE br_notafiscal = @lt_dados-docnum_saida
        AND br_notafiscalitem = @lt_dados-item_saida
        AND docnumentrada = '0000000000'
        AND regiaodestino = @lt_dados-ufdestino
        INTO TABLE @DATA(lt_ativos).

      IF lt_ativos IS NOT INITIAL.

        SORT lt_ativos BY br_notafiscal  br_notafiscalitem.
        DELETE ADJACENT DUPLICATES FROM lt_ativos COMPARING  br_notafiscal br_notafiscalitem.

      ENDIF.

      SELECT BR_NotaFiscal, br_notafiscalitem, docnumentrada, diasatraso1, diasatraso2, nodias
      FROM zi_sd_status_ativo_entrada
      FOR ALL ENTRIES IN @lt_original_data
      WHERE br_notafiscal = @lt_original_data-docnum_saida
        AND br_notafiscalitem = @lt_original_data-item_saida
        AND docnumentrada = @lt_original_data-docnum
        AND regiaodestino = @lt_original_data-ufdestino
        INTO TABLE @DATA(lt_ativos_entrada).

      IF lt_ativos_entrada IS NOT INITIAL.

        SORT lt_ativos_entrada BY br_notafiscal  br_notafiscalitem docnumentrada.
        DELETE ADJACENT DUPLICATES FROM lt_ativos_entrada COMPARING  br_notafiscal br_notafiscalitem docnumentrada.

      ENDIF.

      SELECT BR_NotaFiscal, br_notafiscalitem, diasatraso1, diasatraso2, nodias
      FROM zi_sd_status_ativo_entrada
      FOR ALL ENTRIES IN @lt_original_data
      WHERE br_notafiscal = @lt_original_data-docnum_saida
        AND br_notafiscalitem = @lt_original_data-item_saida
        INTO TABLE @DATA(lt_ativos_todas_regioes).

      IF lt_ativos_todas_regioes IS NOT INITIAL.

        SORT lt_ativos_todas_regioes BY br_notafiscal  br_notafiscalitem .
        DELETE ADJACENT DUPLICATES FROM lt_ativos_todas_regioes COMPARING  br_notafiscal br_notafiscalitem.

      ENDIF.


    ENDIF.
*//////////////////////////////////////////////////////

*    SELECT *
*    FROM zi_sd_relatorio_imobilizados
*    FOR ALL ENTRIES IN @lt_original_data
*    WHERE docnum = @lt_original_data-docnum
*    AND   item   = @lt_original_data-item
*        INTO TABLE @DATA(lt_dados).
*
*    "Quando há Doc de sáda
*    DATA(lt_status_saida) = lt_dados[].
*    SORT lt_status_saida BY docnum_saida item.
*    DELETE ADJACENT DUPLICATES FROM lt_status_saida  COMPARING docnum_saida item.
*    IF lt_status_saida[] IS NOT INITIAL.

*      SELECT *
*      FROM zi_sd_status_ativos
*      FOR ALL ENTRIES IN @lt_status_saida
*      WHERE br_notafiscal = @lt_status_saida-docnum_saida
*        AND br_notafiscalitem = @lt_status_saida-item
*        AND regiaodestino = @lt_status_saida-ufdestino
*              INTO TABLE @DATA(lt_ativos_saida)
*.
*
*    ENDIF.
    "Quando NÃO há Doc de sáda
*    DATA(lt_status_entrada) = lt_dados[].
*    SORT lt_status_entrada BY docnum item.
*    DELETE ADJACENT DUPLICATES FROM lt_status_entrada COMPARING docnum item.
*    IF lt_status_entrada[] IS NOT INITIAL.
*
*      SELECT *
*      FROM zi_sd_status_ativo_entrada
*
*      FOR ALL ENTRIES IN @lt_status_entrada
*      WHERE br_notafiscal = @lt_status_entrada-docnum
*        AND br_notafiscalitem = @lt_status_entrada-item
*        AND regiaodestino = @lt_status_entrada-ufdestino
*        INTO TABLE @DATA(lt_ativos_entrada)
*.
*    ENDIF.

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      READ TABLE lt_ativos ASSIGNING FIELD-SYMBOL(<fs_saida>) WITH KEY br_notafiscal = <fs_data>-docnum_saida
                                                                   br_notafiscalitem = <fs_data>-item_saida BINARY SEARCH.

      "Só calcular quando não haver docnum de entrada
      IF <fs_saida> IS ASSIGNED.

        IF <fs_saida>-nodias > 0 AND <fs_saida>-nodias < <fs_saida>-diasatraso1.
          <fs_data>-status = text-001.
        ELSEIF <fs_saida>-nodias > 0 AND <fs_saida>-nodias >= <fs_saida>-diasatraso1 AND <fs_saida>-nodias <= <fs_saida>-diasatraso2.
          <fs_data>-status = text-002.
        ELSEIF <fs_saida>-nodias > 0 AND  <fs_saida>-nodias > <fs_saida>-diasatraso2.
          <fs_data>-status = text-003.
        ELSE.
          <fs_data>-status = text-001.
        ENDIF.

        IF <fs_saida>-nodias > 0 AND <fs_saida>-nodias < <fs_saida>-diasatraso1.
          <fs_data>-statuscriticality = 3.
        ELSEIF <fs_saida>-nodias > 0 AND <fs_saida>-nodias >= <fs_saida>-diasatraso1 AND <fs_saida>-nodias <= <fs_saida>-diasatraso2.
          <fs_data>-statuscriticality = 2.
        ELSEIF <fs_saida>-nodias > 0 AND  <fs_saida>-nodias > <fs_saida>-diasatraso2.
          <fs_data>-statuscriticality = 1.
        ELSE.
          <fs_data>-statuscriticality = 3.
        ENDIF.


        lv_day_saida = <fs_saida>-diasatraso2.
        lv_date_saida = <fs_data>-datasaida.

        CALL FUNCTION 'SLIM_GET_START_END_DAY'
          EXPORTING
            slim_meas_date  = lv_date_saida
            days_back       = 0
            days_forward    = lv_day_saida
          IMPORTING
            start_date      = lv_start_date
            end_date        = lv_prazo_saida
            start_timestamp = lv_start_timestamp
            end_timestamp   = lv_end_timestamp.

*        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*          EXPORTING
*            date      = lv_date_saida
*            days      = lv_day_saida
*            months    = '00'
*            signum    = '+'
*            years     = '00'
*          IMPORTING
*            calc_date = lv_prazo_saida.

        IF sy-datum > lv_prazo_saida.

          CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
            EXPORTING
              i_date_from = lv_prazo_saida
              i_date_to   = sy-datum
            IMPORTING
              e_days      = lv_dias_atraso.

          <fs_data>-diasatrasados = lv_dias_atraso.

*          READ TABLE lt_ativos_entrada TRANSPORTING NO FIELDS WITH KEY br_notafiscal = <fs_data>-docnum_saida.
*          IF sy-subrc IS INITIAL.


          <fs_data>-diaspendentes = <fs_saida>-nodias.
*          ELSE.
*
*            <fs_data>-diaspendentes = 0.
*          ENDIF.

          UNASSIGN <fs_saida>.

        ELSE.

*          CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*            EXPORTING
*              i_date_from = sy-datum
*              i_date_to   = lv_prazo_saida
*            IMPORTING
*              e_days      = lv_dias_pendentes.

          <fs_data>-diasatrasados = 0.
*          <fs_data>-diaspendentes = lv_dias_pendentes.
          <fs_data>-diaspendentes = <fs_saida>-nodias.
        ENDIF.

      ELSE.

        READ TABLE lt_ativos_entrada ASSIGNING FIELD-SYMBOL(<fs_entrada>) WITH KEY br_notafiscal = <fs_data>-docnum_saida
                                                                                   br_notafiscalitem = <fs_data>-item_saida
                                                                                   docnumentrada     = <fs_data>-docnum   BINARY SEARCH.

        IF <fs_entrada> IS ASSIGNED.

          lv_day_entrada  = <fs_entrada>-diasatraso2.
          lv_date_entrada =  <fs_data>-dataentrada.


          CALL FUNCTION 'SLIM_GET_START_END_DAY'
            EXPORTING
              slim_meas_date  = lv_date_entrada
              days_back       = 0
              days_forward    = lv_day_entrada
            IMPORTING
              start_date      = lv_start_date
              end_date        = lv_prazo_entrada
              start_timestamp = lv_start_timestamp
              end_timestamp   = lv_end_timestamp.

*          CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*            EXPORTING
*              date      = lv_date_entrada
*              days      = lv_day_entrada
*              months    = '00'
*              signum    = '+'
*              years     = '00'
*            IMPORTING
*              calc_date = lv_prazo_entrada.

          IF <fs_data>-dataentrada > lv_prazo_entrada.

            CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
              EXPORTING
                i_date_from = lv_prazo_entrada
                i_date_to   = <fs_data>-dataentrada
              IMPORTING
                e_days      = lv_dias_atraso2.


          ELSE.

            CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
              EXPORTING
                i_date_from = <fs_data>-dataentrada
                i_date_to   = lv_prazo_entrada
              IMPORTING
                e_days      = lv_dias_pendentes.


          ENDIF.

          <fs_data>-diasatrasados = 0.
          <fs_data>-diaspendentes = 0.

          IF lv_dias_pendentes < <fs_entrada>-diasatraso1.
            <fs_data>-status = text-001.
          ELSEIF lv_dias_atraso2 >= <fs_entrada>-diasatraso1 AND lv_dias_atraso2 <= <fs_entrada>-diasatraso2.
            <fs_data>-status = text-002.
          ELSEIF lv_dias_atraso2 > <fs_entrada>-diasatraso2.
            <fs_data>-status = text-003.
          ELSE.
            <fs_data>-status = text-001.
          ENDIF.

          IF lv_dias_pendentes < <fs_entrada>-diasatraso1.
            <fs_data>-statuscriticality = 3.
          ELSEIF lv_dias_atraso2 >= <fs_entrada>-diasatraso1 AND lv_dias_atraso2 <= <fs_entrada>-diasatraso2.
            <fs_data>-statuscriticality = 2.
          ELSEIF lv_dias_atraso2 > <fs_entrada>-diasatraso2.
            <fs_data>-statuscriticality = 1.
          ELSE.
            <fs_data>-statuscriticality = 3.
          ENDIF.
          UNASSIGN <fs_entrada>.

        ELSE.

          READ TABLE lt_ativos_todas_regioes ASSIGNING FIELD-SYMBOL(<fs_todas_regioes>) WITH KEY br_notafiscal = <fs_data>-docnum_saida
                                                                                     br_notafiscalitem = <fs_data>-item_saida   BINARY SEARCH.


          IF  <fs_todas_regioes> IS ASSIGNED.

            lv_day_saida = <fs_todas_regioes>-diasatraso2.
            lv_date_saida = <fs_data>-datasaida.

            CALL FUNCTION 'SLIM_GET_START_END_DAY'
              EXPORTING
                slim_meas_date  = lv_date_saida
                days_back       = 0
                days_forward    = lv_day_saida
              IMPORTING
                start_date      = lv_start_date
                end_date        = lv_prazo_saida
                start_timestamp = lv_start_timestamp
                end_timestamp   = lv_end_timestamp.

            CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
              EXPORTING
                i_date_from = lv_prazo_saida
                i_date_to   = sy-datum
              IMPORTING
                e_days      = lv_dias_atraso.

            <fs_data>-diasatrasados = lv_dias_atraso.


            <fs_data>-diaspendentes = <fs_todas_regioes>-nodias.


          ELSE.

            <fs_data>-status = text-001.
            <fs_data>-statuscriticality = 3.
            <fs_data>-diasatrasados = 0.
            <fs_data>-diaspendentes = 0.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.
*    //////////////
*
*    LOOP AT lt_dados ASSIGNING FIELD-SYMBOL(<fs_dados>).
*
*      READ TABLE lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>) WITH KEY docnum = <fs_dados>-docnum
*                                                                             item   = <fs_dados>-item .
*
*      IF <fs_data> IS ASSIGNED.
*
*        IF <fs_data>-docnum_saida IS NOT INITIAL.
*
*          READ TABLE lt_ativos_saida INTO DATA(ls_saida) WITH KEY br_notafiscal = <fs_dados>-docnum_saida
*                                                                  br_notafiscalitem = <fs_dados>-item.
*          IF sy-subrc IS INITIAL.
*
*            IF ls_saida-nodias > 0 AND ls_saida-nodias < ls_saida-diasatraso1.
*              <fs_data>-status = 'Dentro do Prazo'.
*            ELSEIF ls_saida-nodias > 0 AND ls_saida-nodias >= ls_saida-diasatraso1 AND ls_saida-nodias <= ls_saida-diasatraso2.
*              <fs_data>-status = 'Prazo Mínimo Expirado'.
*            ELSEIF ls_saida-nodias > 0 AND  ls_saida-nodias > ls_saida-diasatraso2.
*              <fs_data>-status = 'Prazo Máximo Expirado'.
*            ELSE.
*              <fs_data>-status = 'Dentro do Prazo'.
*            ENDIF.
*
*            IF ls_saida-nodias > 0 AND ls_saida-nodias < ls_saida-diasatraso1.
*              <fs_data>-statuscriticality = 3.
*            ELSEIF ls_saida-nodias > 0 AND ls_saida-nodias >= ls_saida-diasatraso1 AND ls_saida-nodias <= ls_saida-diasatraso2.
*              <fs_data>-statuscriticality = 2.
*            ELSEIF ls_saida-nodias > 0 AND  ls_saida-nodias > ls_saida-diasatraso2.
*              <fs_data>-statuscriticality = 1.
*            ELSE.
*              <fs_data>-statuscriticality = 3.
*            ENDIF.
*
*
*            lv_day_saida = ls_saida-diasatraso2.
*            lv_date_saida = <fs_dados>-dataentrada.
*
*            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*              EXPORTING
*                date      = lv_date_saida
*                days      = lv_day_saida
*                months    = '00'
*                signum    = '+'
*                years     = '00'
*              IMPORTING
*                calc_date = lv_prazo_saida.
*
*            IF ls_saida-br_nfpostingdate > lv_prazo_saida.
*
*              CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*                EXPORTING
*                  i_date_from = lv_prazo_saida
*                  i_date_to   = ls_saida-br_nfpostingdate
*                IMPORTING
*                  e_days      = lv_dias_atraso.
*
*              <fs_data>-diasatrasados = lv_dias_atraso.
*
*            ELSE.
*
*              <fs_data>-diasatrasados = 0.
*
*            ENDIF.
*
*          ELSE.
*            <fs_data>-status = 'Dentro do Prazo'.
*            <fs_data>-statuscriticality = 3.
*            <fs_data>-diasatrasados = 0.
*          ENDIF.
*
*          <fs_data>-diaspendentes = 0.
*
*        ELSE.
*
*          READ TABLE lt_ativos_entrada INTO DATA(ls_entrada) WITH KEY br_notafiscal = <fs_dados>-docnum
*                                                                      br_notafiscalitem = <fs_dados>-item.
*          IF sy-subrc IS INITIAL.
*
*            IF ls_entrada-nodias > 0 AND ls_entrada-nodias < ls_entrada-diasatraso1.
*              <fs_data>-status = 'Dentro do Prazo'.
*            ELSEIF ls_entrada-nodias > 0 AND ls_entrada-nodias >= ls_entrada-diasatraso1 AND ls_entrada-nodias <= ls_saida-diasatraso2.
*              <fs_data>-status = 'Prazo Mínimo Expirado'.
*            ELSEIF ls_entrada-nodias > 0 AND  ls_entrada-nodias > ls_entrada-diasatraso2.
*              <fs_data>-status = 'Prazo Máximo Expirado'.
*            ELSE.
*              <fs_data>-status = 'Dentro do Prazo'.
*            ENDIF.
*
*            IF ls_entrada-nodias > 0 AND ls_entrada-nodias < ls_entrada-diasatraso1.
*              <fs_data>-statuscriticality = 3.
*            ELSEIF ls_entrada-nodias > 0 AND ls_entrada-nodias >= ls_entrada-diasatraso1 AND ls_entrada-nodias <= ls_saida-diasatraso2.
*              <fs_data>-statuscriticality = 2.
*            ELSEIF ls_entrada-nodias > 0 AND  ls_entrada-nodias > ls_entrada-diasatraso2.
*              <fs_data>-statuscriticality = 1.
*            ELSE.
*              <fs_data>-statuscriticality = 3.
*            ENDIF.
*
*            lv_day_entrada  = ls_entrada-diasatraso2.
*            lv_date_entrada = <fs_dados>-dataentrada.
*
*            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*              EXPORTING
*                date      = lv_date_entrada
*                days      = lv_day_entrada
*                months    = '00'
*                signum    = '+'
*                years     = '00'
*              IMPORTING
*                calc_date = lv_prazo_entrada.
*
*
*            DATA(lv_data) = sy-datum.
*
*            IF lv_data > lv_prazo_entrada.
*
*              CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*                EXPORTING
*                  i_date_from = lv_prazo_entrada
*                  i_date_to   = lv_data
*                IMPORTING
*                  e_days      = lv_dias_atraso2.
*
*              <fs_data>-diasatrasados = lv_dias_atraso2.
*              <fs_data>-diaspendentes = 0.
*
*            ELSE.
*              <fs_data>-diasatrasados = 0.
*              CALL FUNCTION 'FIMA_DAYS_AND_MONTHS_AND_YEARS'
*                EXPORTING
*                  i_date_from = lv_data
*                  i_date_to   = lv_prazo_entrada
*                IMPORTING
*                  e_days      = lv_dias_pendentes.
*
*              <fs_data>-diasatrasados = lv_dias_atraso2.
*              <fs_data>-diaspendentes = lv_dias_pendentes.
*
*            ENDIF.
*
*          ELSE.
*            <fs_data>-status = 'Dentro do Prazo'.
*            <fs_data>-statuscriticality = 3.
*            <fs_data>-diasatrasados = 0.
*            <fs_data>-diaspendentes = 0.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF sy-subrc IS INITIAL.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
