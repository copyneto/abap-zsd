*&---------------------------------------------------------------------*
*& Report ZSDR_ENVIO_REMESSA_SAGA
*&---------------------------------------------------------------------*
*& 8000006187:SD- Remessas não integradas no SAGA
*&
*& Envio de remessas não integradas para o SAGA -> Execução via JOB
*&---------------------------------------------------------------------*
REPORT zsdr_job_envio_remessa_saga.

TABLES ztsd_rem_saga.

TYPES ty_remessas_enviadas TYPE STANDARD TABLE OF ztsd_rem_saga WITH DEFAULT KEY.

DATA lt_joblist TYPE STANDARD TABLE OF tbtcjob.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_vbeln FOR ztsd_rem_saga-remessa.
SELECTION-SCREEN END OF BLOCK b1.

**********************************************************************
START-OF-SELECTION.

  CALL FUNCTION 'ENQUEUE_E_TRDIR'
    EXPORTING
      mode_trdir     = 'X'
      name           = sy-repid
    EXCEPTIONS
      foreign_lock   = 1
      system_failure = 2
      OTHERS         = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(lv_message).
    RETURN.
  ENDIF.

  SELECT *
    FROM ztsd_rem_saga
    WHERE enviado_saga = @space
      AND remessa IN @s_vbeln
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

        IF lt_return IS NOT INITIAL AND lines( lt_return ) > 0.
          WRITE / |{ id_log } - { lt_return[ 1 ]-message } |.
        ELSE.
          WRITE / |{ id_log } - Registro enviado com sucesso.|.
        ENDIF.

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

  CALL FUNCTION 'DEQUEUE_E_TRDIR'
    EXPORTING
      mode_trdir = 'X'
      name       = sy-repid.
