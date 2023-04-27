FUNCTION zfmsd_cmdloc_devolucao_remessa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_KEY) TYPE  ZSSD_KEY_COMODLOC OPTIONAL
*"     VALUE(IS_VBAK) TYPE  TDS_XVBAK OPTIONAL
*"     VALUE(IT_VBAP) TYPE  TT_VBAPVB OPTIONAL
*"----------------------------------------------------------------------

  DO 10 TIMES.

    CALL FUNCTION 'SD_SALES_DOCUMENT_ENQUEUE'
      EXPORTING
        mandt              = sy-mandt
        vbeln              = is_key-contrato
        i_check_scenario_a = abap_true
      EXCEPTIONS
        foreign_lock       = 1
        system_failure     = 2
        no_change          = 3
        OTHERS             = 4.

    IF sy-subrc IS INITIAL.
      DATA(lv_desbloq) = abap_true.

      CALL FUNCTION 'DEQUEUE_EVVBAKE'
        EXPORTING
          mandt = sy-mandt
          vbeln = is_key-contrato.

      EXIT.
    ELSE.
      WAIT UP TO 5 SECONDS.
    ENDIF.

  ENDDO.

  IF lv_desbloq IS NOT INITIAL.
    CLEAR lv_desbloq.

    DATA(lo_object) = NEW zclsd_cmdloc_devol_mercadoria( ).

    DATA(lt_return) = lo_object->devolucao( is_key  = is_key
                                            is_vbak = is_vbak
                                            it_vbap = it_vbap ).

  ENDIF.

ENDFUNCTION.
