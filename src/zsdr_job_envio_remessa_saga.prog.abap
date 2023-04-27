*&---------------------------------------------------------------------*
*& Report ZSDR_ENVIO_REMESSA_SAGA
*&---------------------------------------------------------------------*
*& 8000006187:SD- Remessas não integradas no SAGA
*&
*& Envio de remessas não integradas para o SAGA -> Execução via JOB
*&---------------------------------------------------------------------*
REPORT zsdr_envio_remessa_saga.

TYPES ty_remessas_enviadas TYPE STANDARD TABLE OF ztsd_rem_saga WITH DEFAULT KEY.

**********************************************************************
START-OF-SELECTION.
  SELECT *
    FROM ztsd_rem_saga
    WHERE enviado_saga = @space
    INTO TABLE @DATA(remessas_saga).

  IF sy-subrc <> 0.
    STOP.
  ENDIF.

*  SELECT a~vbeln               AS remessa,
*         b~transportationorder AS ordem_frete
*    FROM likp AS a
*    LEFT OUTER JOIN i_transportationorder AS b
*      ON b~businesstransactiondocument = a~vbeln
*    FOR ALL ENTRIES IN @remessas_saga
*    WHERE a~vbeln = @remessas_saga-remessa
*    INTO TABLE @DATA(remessas_sap).

  SELECT vbeln AS remessa
    FROM likp
    FOR ALL ENTRIES IN @remessas_saga
    WHERE vbeln = @remessas_saga-remessa
    INTO TABLE @DATA(remessas_sap).

**********************************************************************
END-OF-SELECTION.
  LOOP AT remessas_saga REFERENCE INTO DATA(remessa_saga).
    TRY.
        DATA(remessa_sap) = remessas_sap[ remessa = remessa_saga->remessa ].

      CATCH cx_sy_itab_line_not_found.
        WRITE / |Remessa: { remessa_sap-remessa WIDTH = 10 } - Remessa não encontrada na tabela LIKP.|.
        CONTINUE.
    ENDTRY.

*    DATA(id_log) = |Remessa: { remessa_sap-remessa WIDTH = 10 } / Ordem de Frete: { remessa_sap-ordem_frete WIDTH = 10 }| .
    DATA(id_log) = |Remessa: { remessa_saga->remessa WIDTH = 10 } / Ordem de Frete: { remessa_saga->ordem_frete WIDTH = 10 }| .
    DATA(saga)   = NEW zclsd_saga_envio_pre_registro( ).

    TRY .
*        saga->envio_registro( EXPORTING iv_remessa    = remessa_sap-remessa
*                                        iv_ordemfrete = CONV #( remessa_sap-ordem_frete )
*                              IMPORTING et_return     = DATA(lt_return)
*                            ).
        saga->envio_registro( EXPORTING iv_remessa    = remessa_saga->remessa
                                        iv_ordemfrete = CONV #( remessa_saga->ordem_frete )
                              IMPORTING et_return     = DATA(lt_return)
                            ).

        remessa_saga->enviado_saga = abap_true.

        WRITE / |{ id_log } - Registro enviado com sucesso.|.

      CATCH cx_mdg_missing_input_parameter INTO DATA(lo_catch).
        WRITE / |{ id_log } - Erro na chamada do método de envio de registros à SAGA.|.
        CONTINUE.
    ENDTRY.
  ENDLOOP.

  "Atualização das remessas enviadas
  IF line_exists( remessas_saga[ enviado_saga = abap_true ] ).
    DATA(remessas_enviadas) = VALUE ty_remessas_enviadas( FOR <remessa>
                                                           IN remessas_saga
                                                        WHERE ( enviado_saga = abap_true )
                                                            ( <remessa> ) ).

    CALL FUNCTION 'ZFMTM_REMESSA_SAGA'
      TABLES
        it_remessa = remessas_enviadas.
  ENDIF.

  ULINE.
  WRITE / |{ lines( remessas_saga ) } remessa(s) processada(s).|.
