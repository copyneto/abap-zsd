"!<p><h2></h2>ZCLSD_AGENDAMENTO_ACTIONS</p>
"! Classe utilizada para controlar as ações do APP
"! <br/>
"!<p><strong>Autor:</strong> Gustavo Calvacante - Meta</p>
"!<p><strong>Data:</strong> 25/02/2022</p>

CLASS zclsd_agendamento_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "! Criar Agendamento da Ordem
    "! @parameter iv_ordem           |Ordem
    "! "! @parameter iv_remessa      |Remessa
    "! "! @parameter iv_nfe          |NF-e
    "! "! @parameter iv_dataagendada |Data Agendada
    "! "! @parameter iv_horaagendada |Hora Agendada
    "! "! @parameter iv_motivo       |Motivo
    "! "! @parameter iv_senha        |Senha
    "! "! @parameter iv_obs          |Observações
    "! "! @parameter iv_grp          |Grupo
    "! "! @parameter iv_app_item     |Tratamento para o app de item
    METHODS criaragendamento
      IMPORTING
        !iv_ordem        TYPE vbeln_va
        !iv_item         TYPE posnr OPTIONAL
        !iv_remessa      TYPE vbeln_vl
        !iv_nfe          TYPE j_1bnfnum9
        !iv_dataagendada TYPE j_1bdocdat
        !iv_horaagendada TYPE j_1bauthtime
        !iv_motivo       TYPE vstga
        !iv_senha        TYPE ze_senha
        !iv_obs          TYPE char20
        !iv_grp          TYPE kvgr5
        !iv_app_item     TYPE abap_bool  OPTIONAL
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .

    "! Chama proxy
    "! @parameter is_likp | Documento SD: fornecimento: dados de cabeçalho
    METHODS chama_proxy
      IMPORTING is_likp TYPE likp.


    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .

  PROTECTED SECTION.
  PRIVATE SECTION.
    "!Grupo
    DATA gr_grp TYPE RANGE OF kvgr5.

    "! Seleccionar Grupo dependendo dos valores da Tabela De Parâmetros
    METHODS get_parametro.

ENDCLASS.



CLASS ZCLSD_AGENDAMENTO_ACTIONS IMPLEMENTATION.


  METHOD criaragendamento.

    IF iv_app_item EQ abap_true AND iv_remessa IS NOT INITIAL.

      APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                              number = '004'
                              type = 'E'
                            ) TO rt_return.

    ELSE.

      get_parametro( ).

      IF iv_grp IN gr_grp.

        DATA: lv_datahora TYPE timestamp.
        CONVERT DATE  iv_dataagendada TIME iv_horaagendada
          INTO TIME STAMP lv_datahora TIME ZONE sy-zonlo.

*      IF iv_remessa IS INITIAL.
*        lv_chave = iv_ordem.
*      ELSEIF iv_nfe IS INITIAL.
*        lv_chave = |{ iv_ordem }{ iv_remessa }|.
*      ELSE.
*        lv_chave = |{ iv_ordem }{ iv_remessa }{ iv_nfe }|.
*      ENDIF.
        IF iv_app_item EQ abap_true.

          DATA(ls_agendamento) = VALUE ztsd_agendamento( ordem          = iv_ordem
                                                         item           = iv_item
                                                         remessa        = iv_remessa
                                                         nf_e           = iv_nfe
                                                         data_agendada  = iv_dataagendada
                                                         hora_agendada  = iv_horaagendada
                                                         motivo         = iv_motivo
                                                         senha          = iv_senha
                                                         observacoes    = iv_obs
                                                         usuario        = sy-uname
                                                         data_registro  = sy-datum
                                                         hora_registro  = sy-uzeit
                                                         data_hora_agendada = lv_datahora ).



          IF ls_agendamento IS NOT INITIAL.
            MODIFY ztsd_agendamento FROM ls_agendamento.
            IF sy-subrc IS INITIAL.

              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                DESTINATION 'NONE'
                EXPORTING
                  wait = abap_true.

              APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                                     number = '001'
                                     type = 'S'
                                   ) TO rt_return.
            ELSE.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
                DESTINATION 'NONE'.

              APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                                     number = '002'
                                     type = 'E'
                                   ) TO rt_return.

            ENDIF.
          ENDIF.
        ELSE.

          DATA lt_agendamento TYPE TABLE OF ztsd_agendamento.

          SELECT remessa, salesorderitem, notafiscal
          FROM zi_sd_ckpt_agen_item_app
          WHERE salesorder = @iv_ordem
          INTO TABLE @DATA(lt_item).

          LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
            CHECK <fs_item>-remessa = iv_remessa AND <fs_item>-notafiscal = iv_nfe.
            APPEND VALUE ztsd_agendamento( ordem         = iv_ordem
                                                        item           = <fs_item>-salesorderitem
                                                        remessa        = iv_remessa
                                                        nf_e           = iv_nfe
                                                        data_agendada  = iv_dataagendada
                                                        hora_agendada  = iv_horaagendada
                                                        motivo         = iv_motivo
                                                        senha          = iv_senha
                                                        observacoes    = iv_obs
                                                        usuario        = sy-uname
                                                        data_registro  = sy-datum
                                                        hora_registro  = sy-uzeit
                                                        data_hora_agendada = lv_datahora ) TO lt_agendamento.

          ENDLOOP.

          IF lt_agendamento[] IS NOT INITIAL.

            SELECT COUNT(*)
             FROM ztsd_agendamento AS lt_agen
             WHERE ordem = @iv_ordem
             AND   REMESSA = @iv_remessa
             AND
              ( data_agendada IS NOT INITIAL
               OR hora_agendada IS NOT INITIAL ).

            IF sy-dbcnt >= 1 .

              DATA(lv_true) = abap_true.

            ENDIF.

            MODIFY ztsd_agendamento FROM TABLE lt_agendamento[].
            IF sy-subrc IS INITIAL.

              CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
                DESTINATION 'NONE'
                EXPORTING
                  wait = abap_true.
              IF lv_true EQ abap_false.
                APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                                       number = '001'
                                       type = 'S'
                                     ) TO rt_return.
              ELSE.
                APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                                       number = '008'
                                       type = 'S'
                                     ) TO rt_return.
              ENDIF.
            ELSE.

              CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'
                DESTINATION 'NONE'.

              APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                                     number = '002'
                                     type = 'E'
                                   ) TO rt_return.

            ENDIF.
          ENDIF.
        ENDIF.

      ELSE.

        APPEND VALUE bapiret2( id = 'ZSD_CKPT_AGENDAMENTO'
                               number = '003'
                               type = 'E'
                             ) TO rt_return.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_parametro.

*    SELECT SINGLE low
*      INTO rv_return
*      FROM ztca_param_val
*      WHERE modulo = 'SD'
*        AND chave1 = 'ADM_AGENDAMENTO'
*        AND chave2 = 'GRP_AGENDA'.

    CONSTANTS:
      "! Constantes para tabela de parâmetros
      BEGIN OF gc_parametros,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_AGENDAMENTO',
        chave2 TYPE ztca_param_par-chave2 VALUE 'GRP_AGENDA',
      END OF gc_parametros.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    CLEAR gr_grp.
    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = gc_parametros-modulo
      iv_chave1 = gc_parametros-chave1
      iv_chave2 = gc_parametros-chave2
          IMPORTING
            et_range  = gr_grp
        ).


      CATCH zcxca_tabela_parametros.

    ENDTRY.


  ENDMETHOD.


  METHOD chama_proxy.

*    CALL FUNCTION 'ZFMSD_ADM_AGENDAMENTO'
*      STARTING NEW TASK 'ADM_AGENDAMENTO' CALLING task_finish ON END OF TASK
*      EXPORTING
*        iv_likp = is_likp.

    CALL FUNCTION 'ZFMSD_ADM_AGENDAMENTO'
      STARTING NEW TASK 'ADM_AGENDAMENTO'
      EXPORTING
        iv_likp = is_likp.

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_ADM_AGENDAMENTO'.
    RETURN.
  ENDMETHOD.
ENDCLASS.
