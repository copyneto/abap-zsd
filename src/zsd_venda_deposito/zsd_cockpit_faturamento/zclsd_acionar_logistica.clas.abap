CLASS zclsd_acionar_logistica DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método que realiza o envio do email
    "! @parameter ET_RETURN        | Mensagens de erro
    METHODS envio_email
      IMPORTING
        !iv_storage       TYPE werks_d
      EXPORTING
        !et_return        TYPE bapiret2_t
      RETURNING
        VALUE(rv_success) TYPE abap_bool .
    "! Método que realiza processo em background
    "! @parameter P_TASK        | Parâmentro standard
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Método que realiza processo em background
    "! @parameter P_TASK        | Parâmentro standard
    METHODS task_parameter
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.
  PRIVATE SECTION.


    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM FATURAMENTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'EMAIL',
      END OF gc_parametros .
    "! Constantes para leitura do texto de email
    CONSTANTS gc_log TYPE string VALUE 'LOG' ##NO_TEXT.
    CONSTANTS gc_zmail_log TYPE thead-tdname VALUE 'SD_MAIL_LOG' ##NO_TEXT.
    CONSTANTS gc_text TYPE thead-tdobject VALUE 'TEXT' ##NO_TEXT.
    CONSTANTS gc_lang TYPE thead-tdspras  VALUE 'P' ##NO_TEXT.
    DATA: gv_storage TYPE werks_d.
    DATA: gt_destinatarios TYPE RANGE OF ad_smtpadr .
    DATA: gt_lines TYPE tline_t .
    DATA go_document TYPE REF TO cl_document_bcs .
    DATA go_send_request TYPE REF TO cl_bcs .
    DATA gt_text TYPE bcsy_text VALUE IS INITIAL .
*     DATA gt_text TYPE soli_tab .
    DATA gv_success TYPE abap_bool .
    DATA gt_return TYPE bapiret2_t .

    "! Seleciona os endereços de email Destinatários
    METHODS seleciona_param_end_email .
    "! Seleciona texto para corpo do e-mail
    METHODS seleciona_texto_email .
    "! Trata texto para formato do e-mail
    METHODS trata_texto_email .
    "! Cria o e-mail
    METHODS cria_email .
    "! Cria o envio do pedido
    METHODS cria_envio_request .
    "! Define o Remetente
    METHODS definir_remetente .
    "! Define Destinatarios
    METHODS definir_destinatario .
    "! Envia o e-mail
    METHODS enviar_email .
    "! Método para selecionar a tabela de parâmetro
    "! @parameter IV_CHAVE2        | Chave2
    "! @parameter RV_RETURN        | Valor do parâmetro
    METHODS get_param
      IMPORTING
        !iv_chave2       TYPE ze_param_chave
      RETURNING
        VALUE(rv_return) TYPE ze_param_low .
ENDCLASS.



CLASS ZCLSD_ACIONAR_LOGISTICA IMPLEMENTATION.


  METHOD envio_email.

    gv_storage = iv_storage.
    seleciona_texto_email( ).
    trata_texto_email(  )."Falta implementar essa lógica
    cria_email( ).
    cria_envio_request( ).
    definir_remetente(  ).
    seleciona_param_end_email( ).
    definir_destinatario(  ).
    enviar_email(  ).

    et_return[] = gt_return[].
    rv_success = gv_success.


  ENDMETHOD.


  METHOD seleciona_texto_email.

    CONSTANTS: lc_id    TYPE thead-tdid VALUE 'ST'.
    DATA: lt_lines TYPE tline_t.

*    lv_id = get_param( 'ID_MAIL' ).

*    CALL FUNCTION 'ZFMSD_READ_TEXT'
*      STARTING NEW TASK 'BACKGROUND' CALLING task_finish ON END OF TASK
*      EXPORTING
*        iv_id       = 'ST'
*        iv_language = gc_lang
*        iv_name     = gc_zmail_log
*        iv_object   = gc_text
*      TABLES
*        t_lines     = lt_lines.
*
*    WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_lines IS NOT INITIAL.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client   = sy-mandt
        id       = lc_id
        language = gc_lang
        name     = gc_zmail_log
        object   = gc_text
      TABLES
        lines    = gt_lines.

  ENDMETHOD.


  METHOD trata_texto_email.

    LOOP AT gt_lines ASSIGNING FIELD-SYMBOL(<fs_line>).
      REPLACE 'XXXX' IN <fs_line>-tdline WITH gv_storage.
      APPEND <fs_line>-tdline TO gt_text.
    ENDLOOP.

  ENDMETHOD.


  METHOD seleciona_param_end_email.

    CLEAR gt_destinatarios.

    CALL FUNCTION 'ZFMSD_READ_EMAIL'
      STARTING NEW TASK 'BACKGROUND' CALLING task_parameter ON END OF TASK
      EXPORTING
        et_return = gt_destinatarios.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gt_destinatarios IS NOT INITIAL.

*    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).
*
*    CLEAR gt_destinatarios.
*
*    TRY.
*        lo_tabela_parametros->m_get_range(
*          EXPORTING
*      iv_modulo = gc_parametros-modulo
*      iv_chave1 = gc_parametros-chave1
*      iv_chave2 = gc_parametros-chave2
*          IMPORTING
*            et_range  = gt_destinatarios
*        ).
*
*      CATCH zcxca_tabela_parametros.
*
*    ENDTRY.


  ENDMETHOD.


  METHOD cria_email.

    DATA:
      lv_type         TYPE so_obj_tp VALUE 'RAW',
      lt_message_body TYPE bcsy_text VALUE IS INITIAL,
      lv_subject      TYPE so_obj_des.

    lv_subject = TEXT-001.

    TRY.

        go_document = cl_document_bcs=>create_document( i_type    = lv_type
                                                        i_text    = gt_text
                                                        i_subject = lv_subject  ).

      CATCH cx_document_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD cria_envio_request.

    TRY.

        go_send_request = cl_bcs=>create_persistent( ).
        go_send_request->set_document( go_document ).

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD definir_remetente.

    TRY.

        DATA(lo_sender) = cl_sapuser_bcs=>create( sy-uname ).

        go_send_request->set_sender( lo_sender ).

      CATCH cx_address_bcs INTO DATA(lo_address).

        APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_address->get_text( ) ) TO gt_return.

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD definir_destinatario.

    DATA lv_destinatarios TYPE ad_smtpadr.

    LOOP AT gt_destinatarios ASSIGNING FIELD-SYMBOL(<fs_destinatarios>).

      lv_destinatarios = <fs_destinatarios>-low.

      TRY.

          DATA(lo_destinatarios) = cl_cam_address_bcs=>create_internet_address( lv_destinatarios ).

          go_send_request->add_recipient( i_recipient = lo_destinatarios
                                          i_express   = abap_true ).

        CATCH cx_address_bcs INTO DATA(lo_address).

          APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_address->get_text( ) ) TO gt_return.

        CATCH cx_send_req_bcs INTO DATA(lo_bcs).

          APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_bcs->get_text( ) ) TO gt_return.

      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD enviar_email.

    TRY.

        go_send_request->set_send_immediately( abap_true ).
        go_send_request->send( abap_true ).

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
          EXPORTING
            wait = abap_true.

        gv_success = abap_true.

      CATCH cx_send_req_bcs INTO DATA(lo_bcs).

        APPEND VALUE bapiret2( id = 'zsd_CKPT_FATURAMENTO' number = 000 type = 'E' message = lo_bcs->get_text( ) ) TO gt_return.

    ENDTRY.

  ENDMETHOD.


  METHOD get_param.

    SELECT SINGLE low
      INTO rv_return
      FROM ztca_param_val
      WHERE modulo = 'SD'
        AND chave1 = 'ADM_FATURAMENTO'
        AND chave2 = iv_chave2.

  ENDMETHOD.


  METHOD task_finish.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_READ_TEXT'
     TABLES
       t_lines   = gt_lines.

    RETURN.

  ENDMETHOD.


  METHOD task_parameter.

    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_READ_EMAIL'
     IMPORTING
     et_return   = gt_destinatarios.

  ENDMETHOD.
ENDCLASS.
