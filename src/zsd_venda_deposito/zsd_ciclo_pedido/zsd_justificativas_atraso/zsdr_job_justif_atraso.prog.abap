*&---------------------------------------------------------------------*
*& Report ZSDR_JOB_JUSTIF_ATRASO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_job_justif_atraso.

DATA: gv_data    TYPE sydatum,
      lt_message TYPE esp1_message_tab_type.


SELECT-OPTIONS: s_data FOR gv_data OBLIGATORY.

PARAMETERS: p_order TYPE vbeln_va,
            p_med   TYPE ze_med OBLIGATORY,
            p_plant TYPE werks_d.

START-OF-SELECTION.

  FREE: lt_message.

  DATA(lt_return) = NEW zclsd_verifica_atrasos( )->execute( EXPORTING ir_datadoc      = s_data[]
                                                                      iv_medicao      = p_med
                                                                      iv_ordem_venda  = p_order
                                                                      iv_centro       = p_plant ).


  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) .

    APPEND VALUE #( msgid = <fs_return>-id
                                        msgno = <fs_return>-number
                                        msgty = <fs_return>-type
                                        msgv1 = <fs_return>-message_v1
                                        msgv2 = <fs_return>-message_v2
                                        msgv3 = <fs_return>-message_v3
                                        msgv4 = <fs_return>-message_v4 ) TO lt_message.

  ENDLOOP.

  CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
    TABLES
      i_message_tab = lt_message.
