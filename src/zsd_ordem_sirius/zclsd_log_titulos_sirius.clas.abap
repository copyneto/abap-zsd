"!<p><h2>Log de envio de títulos para Sirius</h2></p>
"!<br/><br/>
"!<p><strong>Autor:</strong> Anderson Miazato</p>
"!<p><strong>Data:</strong> 05 de nov de 2021</p>
CLASS zclsd_log_titulos_sirius DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS:
      "! Objeto e subobjeto SLG0 de log Envio títulos para Sirius
      BEGIN OF gc_log,
        obj TYPE bal_s_log-object VALUE 'ZSD_ENVIO_OV_SIRIUS',
        sub TYPE bal_s_log-subobject VALUE 'TITULOS_CLIENTE',
      END OF gc_log,

      "!Classe de mensagens
      gc_msg_class TYPE symsgid VALUE 'ZSD_ORDEM_SIRIUS'.

    METHODS:
      "! Inicia o objeto
      constructor
        RAISING zcxsd_log_sirius,
      "! Adiciona mensagem ao log
      "! @parameter is_msg     | Mensagem adicionada ao log
      "! @parameter is_context | Identificador do objeto para a mensagem
      add_msg
        IMPORTING
          is_msg     TYPE bapiret2
          is_context TYPE zssd_log_tit_cliente_sirius OPTIONAL.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA:
      "! Identificador do job
      gv_job        TYPE btcjob,
      "! Controle do log
      gv_log_handle TYPE balloghndl.

    METHODS:
      "! Inicializa o log
      "! @raising zcxsd_log_sirius | Exceções ao gerar log
      init_log
        RAISING zcxsd_log_sirius.
ENDCLASS.



CLASS zclsd_log_titulos_sirius IMPLEMENTATION.
  METHOD add_msg.

    DATA: ls_msg        TYPE bal_s_msg,
          lt_log_handle TYPE bal_t_logh.

    APPEND gv_log_handle TO lt_log_handle.

    DATA: ls_context TYPE zssd_log_tit_cliente_sirius.

    ls_msg-msgty     = is_msg-type.
    ls_msg-msgid     = is_msg-id.
    ls_msg-msgno     = is_msg-number.
    ls_msg-msgv1     = is_msg-message_v1.
    ls_msg-msgv2     = is_msg-message_v2.
    ls_msg-msgv3     = is_msg-message_v3.
    ls_msg-msgv4     = is_msg-message_v4.
    ls_msg-probclass = '1'.


    ls_context = is_context.

    ls_msg-context-tabname = 'ZSSD_LOG_TIT_CLIENTE_SIRIUS'.
    ls_msg-context-value   = ls_context.

    CALL FUNCTION 'BAL_LOG_MSG_ADD'
      EXPORTING
        i_log_handle     = gv_log_handle
        i_s_msg          = ls_msg
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.


    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
*       i_save_all     = 'X' "can cause dumps
        i_t_log_handle = lt_log_handle
      EXCEPTIONS
        OTHERS         = 4.

    IF sy-subrc NE 0.
      RETURN.
    ENDIF.



  ENDMETHOD.

  METHOD constructor.
    me->init_log( ).
  ENDMETHOD.

  METHOD init_log.

    DATA: ls_log        TYPE bal_s_log.

    ls_log-extnumber = gv_job.
    ls_log-aluser    = sy-uname.
    ls_log-alprog    = sy-repid.
    ls_log-object    = gc_log-obj.
    ls_log-subobject = gc_log-sub.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = ls_log
      IMPORTING
        e_log_handle = gv_log_handle
      EXCEPTIONS
        OTHERS       = 1.

    IF sy-subrc NE 0.

      MESSAGE e005(zsd_ordem_sirius) INTO DATA(lv_msg_tracking)
      WITH '' ''.

      RAISE EXCEPTION TYPE zcxsd_log_sirius
        EXPORTING
          is_textid = VALUE scx_t100key( msgid = gc_msg_class
                                         msgno = '005'
                                         attr1 = 'ZSD_ENVIO_OV_SIRIUS'(001)
                                         attr2 = 'TITULOS_CLIENTE'(002)
                       ).
    ENDIF.

    IF NOT sy-batch IS INITIAL.

      CALL FUNCTION 'BP_ADD_APPL_LOG_HANDLE'
        EXPORTING
          loghandle = gv_log_handle
        EXCEPTIONS
          OTHERS    = 4.

      IF sy-subrc NE 0.

        MESSAGE e005(zsd_ordem_sirius) INTO lv_msg_tracking
        WITH '' ''.

        RAISE EXCEPTION TYPE zcxsd_log_sirius
          EXPORTING
            is_textid = VALUE scx_t100key( msgid = gc_msg_class
                                           msgno = '005'
                                           attr1 = 'ZSD_ENVIO_OV_SIRIUS'(001)
                                           attr2 = 'TITULOS_CLIENTE'(002)
                         ).

      ENDIF.

    ENDIF.


  ENDMETHOD.

ENDCLASS.
