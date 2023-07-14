"!<p><h2>Envio de informações de títulos para Sirius</h2></p>
"!<br/><br/>
"!<p><strong>Autor:</strong> Anderson Miazato</p>
"!<p><strong>Data:</strong> 05 de nov de 2021</p>
CLASS zclsd_envio_titulos_sirius DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Campos da tela de seleção
      BEGIN OF ty_selscreen,
        s_perio TYPE RANGE OF budat,
      END OF ty_selscreen.

    CONSTANTS:
      "! Crédito duvidoso, cheque devolvido, etc
      gc_credito_duvidoso      TYPE c VALUE 'D',
      "! Forma de Pagto: Boleto
      gc_forma_pagto_boleto    TYPE bseg-zlsch VALUE 'D',
      "! Chave lançamento: Diferença Pagamento
      gc_chave_lancto_difpagto TYPE bseg-bschl VALUE '06'.

    CONSTANTS:
      "! Tipo de conta: Cliente/Fornecedor
      BEGIN OF gc_tipo_conta,
        cliente    TYPE bseg-koart VALUE 'D',
        fornecedor TYPE bseg-koart VALUE 'K',
      END OF gc_tipo_conta,
      "! Código crédito/débito
      BEGIN OF gc_cred_deb,
        credito TYPE shkzg VALUE 'H',
        debito  TYPE shkzg VALUE 'S',
      END OF gc_cred_deb.

    DATA:
       "! Campos da tela de seleção
       gs_selscreen TYPE ty_selscreen.

    METHODS:
      "! Inicializa objeto
      "! @parameter is_selscreen | Campos da tela de seleção
      constructor
        IMPORTING is_selscreen TYPE ty_selscreen,

      "! Envia títulos de cliente ao Sirius
      main.

  PROTECTED SECTION.
private section.

  types:
      "! Campos dos Títulos que serão exportados ao Sirius
    BEGIN OF ty_titulo_export,
        belnr(18),                   " Nº documento (nº título)
        kunnr(10),                   " Nº cliente
        belnr2(10),                  " Nº documento (nº título)
        budat(10),                   " Data de emissão
        wrbtr(15),                   " Valor
        zfbdt(10),                   " Data de vencimento
        zlsch(01),                   " Meio de pagamento
        augdt(10),                   " Data de compensação
        buzei(03),                   " Item
        xblnr      TYPE bsad_view-xblnr,  " Referência
      END OF ty_titulo_export .
  types:
      "! Categ. tabela Títulos que serão exportados para o Sirius
    tt_titulo_export TYPE STANDARD TABLE OF ty_titulo_export WITH NON-UNIQUE KEY belnr kunnr belnr2 .

      "! Ref. ao log SLG1
  data GO_LOG type ref to ZCLSD_LOG_TITULOS_SIRIUS .

      "! Seleciona títulos do cliente
      "! @parameter rt_result | Títulos dos clientes
  methods SELECIONA_TITULOS
    returning
      value(RT_RESULT) type TT_TITULO_EXPORT .
      "! Exporta títulos
  methods EXPORTA_TITULOS .
      "! Envia título selecionado ao Sirius via PO
      "! @parameter is_titulo | Título do cliente
      "! @parameter rt_result | Resultado do envio em caso de erro
  methods ENVIA_TITULO_SIRIUS
    importing
      !IS_TITULO type TY_TITULO_EXPORT
    returning
      value(RT_RESULT) type BAPIRET2_TAB .
      "! Determina datas de vencimento
      "! @parameter is_faede    | Determinação de datas de vencimento
      "! @parameter iv_gl_faede | Determ. global de vencimento
      "! @parameter is_bseg     | Segmento Doc. contábil
      "! @parameter is_bkpf     | Cabeçalho Doc. contábil
      "! @parameter rs_result   | Datas de Vencimento atualizadas
  methods DETERMINE_DUE_DATE
    importing
      !IS_FAEDE type FAEDE
      !IV_GL_FAEDE type XFELD optional
      !IS_BSEG type BSEG optional
      !IS_BKPF type BKPF optional
    returning
      value(RS_RESULT) type FAEDE .
  methods HANDLE_SQL_EXCEPTION
    importing
      !IS_SQL_EXCEPTION type ref to CX_SQL_EXCEPTION .
ENDCLASS.



CLASS ZCLSD_ENVIO_TITULOS_SIRIUS IMPLEMENTATION.


  METHOD main.

    TRY.
        me->go_log = NEW zclsd_log_titulos_sirius( ).
      CATCH zcxsd_log_sirius INTO DATA(lo_error_log).
        WRITE: / lo_error_log->get_text( ).
        RETURN.
    ENDTRY.

    me->exporta_titulos( ).

  ENDMETHOD.


  METHOD seleciona_titulos.

    DATA:
      lt_titulos_export TYPE tt_titulo_export,
      lt_faede          TYPE STANDARD TABLE OF faede,
      lt_faede_result   TYPE STANDARD TABLE OF faede.

    DATA:
      ls_faede_result LIKE LINE OF lt_faede_result.

    SELECT  bukrs,
            kunnr,
            umsks,
            umskz,
            belnr,
            buzei,
            gjahr,
            budat,
            zlsch,
            wrbtr,
            zfbdt,
            zbd1t,
            zbd2t,
            zbd3t,
            xblnr,
            bschl,
            rebzg,
            salesorganization
            FROM zi_sd_titulosclientesirius
            WHERE budat IN @me->gs_selscreen-s_perio
            INTO TABLE @DATA(lt_titulos).

    IF sy-subrc NE 0.

      MESSAGE s001(zsd_ordem_sirius) DISPLAY LIKE 'E'.

      DATA(ls_msg) = VALUE bapiret2(
                            id = 'ZSD_ORDEM_SIRIUS'
                            type = 'E'
                            number = '001'
                     ).

      me->go_log->add_msg(
        EXPORTING
          is_msg = ls_msg
      ).

      RETURN.

    ENDIF.

    LOOP AT lt_titulos ASSIGNING FIELD-SYMBOL(<fs_titulos>).

      IF <fs_titulos>-salesorganization IS INITIAL.
        CONTINUE.
      ENDIF.

      IF <fs_titulos>-zlsch IS INITIAL.

        " Se meio de pagamento estiver em branco continua somente se for cheque devolvido
        IF <fs_titulos>-umsks NE gc_credito_duvidoso
            OR <fs_titulos>-umskz NE gc_credito_duvidoso.

          CONTINUE.

        ENDIF.

      ENDIF.

      APPEND INITIAL LINE TO lt_faede ASSIGNING FIELD-SYMBOL(<fs_faede>).
      <fs_faede> = CORRESPONDING #( <fs_titulos> ).
      <fs_faede>-koart = gc_tipo_conta-cliente.

      ls_faede_result = me->determine_due_date( EXPORTING is_faede = <fs_faede> ).

      IF ls_faede_result IS INITIAL.
        CONTINUE.
      ENDIF.

      " Envia títulos vencidos para exportação ao Sirius
      APPEND INITIAL LINE TO lt_titulos_export ASSIGNING FIELD-SYMBOL(<fs_titulo_export>).

      <fs_titulo_export>-kunnr = <fs_titulos>-kunnr.

      <fs_titulo_export>-zlsch = COND #( WHEN <fs_titulos>-zlsch IS INITIAL
                                            THEN gc_forma_pagto_boleto

                                            ELSE <fs_titulos>-zlsch ).

      <fs_titulo_export>-belnr2 = <fs_titulos>-belnr.

      <fs_titulo_export>-belnr = |{ <fs_titulos>-kunnr+3 }| && |{ <fs_titulos>-belnr }|.
      CONDENSE <fs_titulo_export>-belnr NO-GAPS.

      <fs_titulo_export>-wrbtr = <fs_titulos>-wrbtr.

      <fs_titulo_export>-xblnr = COND #(  WHEN <fs_titulos>-bschl EQ gc_chave_lancto_difpagto
                                               AND <fs_titulos>-rebzg NE space
                                              THEN <fs_titulos>-rebzg

                                              ELSE <fs_titulos>-xblnr ).

      <fs_titulo_export>-budat = <fs_titulos>-budat.

      <fs_titulo_export>-zfbdt = ls_faede_result-netdt.

      <fs_titulo_export>-buzei = <fs_titulos>-buzei.

    ENDLOOP.

    IF lt_titulos_export IS INITIAL.

      MESSAGE s001(zsd_ordem_sirius) DISPLAY LIKE 'E'.
      RETURN.

    ENDIF.

    SORT lt_titulos_export.
    DELETE ADJACENT DUPLICATES FROM lt_titulos_export COMPARING ALL FIELDS.

    rt_result = lt_titulos_export.

  ENDMETHOD.


  METHOD constructor.
    me->gs_selscreen = is_selscreen.
  ENDMETHOD.


  METHOD exporta_titulos.

    DATA lt_return TYPE bapiret2_tab.

    DATA lv_item TYPE i.

    DATA(lt_titulos) = me->seleciona_titulos( ).

    IF lt_titulos IS INITIAL.
      RETURN.
    ENDIF.

***--> CONECTA COM O BANCO DE DADOS EXTERNO.
**    EXEC SQL.
**      CONNECT TO 'PSIRIUS2' AS 'A'
**    ENDEXEC.
**
**    LOOP AT lt_titulos ASSIGNING FIELD-SYMBOL(<fs_titulos>).
**      lv_item = <fs_titulos>-buzei.
**      TRY.
**          EXEC SQL.
**            UPDATE TITULO SET DATACOMPENSACAO = :<fs_titulos>-AUGDT, DATACONTROLE = GETDATE()
**                                                           WHERE CODIGO = :<fs_titulos>-BELNR AND
**                                                                 ITEM   = :LV_ITEM AND
**                                                                 DATACOMPENSACAO IS NULL
**          ENDEXEC.
**        CATCH cx_sy_native_sql_error INTO DATA(lo_exc_ref).
**          EXEC SQL.
**            ROLLBACK CONNECTION 'A'
**            SET CONNECTION DEFAULT
**            DISCONNECT 'A'
**          ENDEXEC.
**          DATA(lv_error_text) = lo_exc_ref->get_text( ).
**          MESSAGE e000(zsd_ordem_sirius) WITH lv_error_text.
**        CATCH cx_sql_exception INTO DATA(lo_sqlerr_ref).
**          handle_sql_exception( lo_sqlerr_ref  ).
**      ENDTRY.
**
**    ENDLOOP.
**
**    COMMIT WORK.
**
***--> DESCONECTAR.
**    EXEC SQL.
**      DISCONNECT 'A'
**    ENDEXEC.
**
***--> VOLTA PARA OS ACESSOS AO BD DEFAULT DO R3.
**    EXEC SQL.
**      SET CONNECTION DEFAULT
**    ENDEXEC.

    lt_return = VALUE #( FOR ls_titulo IN lt_titulos
                              FOR ls_return IN me->envia_titulo_sirius( ls_titulo )
                              ( id         = ls_return-id
                                type       = ls_return-type
                                number     = ls_return-number
                                message    = ls_return-message
                                message_v1 = ls_return-message_v1
                                message_v2 = ls_return-message_v2
                                message_v3 = ls_return-message_v3
                                message_v4 = ls_return-message_v4
                              )
                ).

    MESSAGE s006(zsd_ordem_sirius) WITH 'ZSD_ENVIO_OV_SIRIUS'(003) 'TITULOS_CLIENTE'(004).

    DATA(ls_msg) = VALUE bapiret2(
                          id = 'ZSD_ORDEM_SIRIUS'
                          type = 'S'
                          number = '006'
                          message_v1 = 'ZSD_ENVIO_OV_SIRIUS'(003)
                          message_v2 = 'TITULOS_CLIENTE'(004)
                   ).

    me->go_log->add_msg(
      EXPORTING
        is_msg = ls_msg
    ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD envia_titulo_sirius.

    DATA(ls_output) = VALUE zclsd_mt_dados_titulos(
                                mt_dados_titulos-belnr  = is_titulo-belnr
                                mt_dados_titulos-belnr2 = is_titulo-belnr2
                                mt_dados_titulos-budat  = is_titulo-budat
                                mt_dados_titulos-buzei  = is_titulo-buzei
                                mt_dados_titulos-kunnr  = is_titulo-kunnr
                                mt_dados_titulos-wrbtr  = is_titulo-wrbtr
                                mt_dados_titulos-xblnr  = is_titulo-xblnr
                                mt_dados_titulos-zfbdt  = is_titulo-zfbdt
                                mt_dados_titulos-zlsch  = is_titulo-zlsch
                            ).

    TRY.

        NEW zclsd_co_si_envia_dados_titulo( )->si_envia_dados_titulos_out( ls_output ).

        DATA(ls_log_context) = CORRESPONDING zssd_log_tit_cliente_sirius( is_titulo ).

        DATA(ls_msg) = VALUE bapiret2( id = 'ZSD_ORDEM_SIRIUS'
                                       type = 'S'
                                       number = '007'
                                       message_v1 = is_titulo-belnr2 ).

        me->go_log->add_msg(
          EXPORTING
            is_msg     = ls_msg
            is_context = ls_log_context
        ).

      CATCH cx_ai_system_fault.

        rt_result = VALUE #(
                             ( id = 'ZSD_ORDEM_SIRIUS'
                               type = 'E'
                               number = '003'
                               message_v1 = is_titulo-belnr2 )
                    ).

        ls_log_context = CORRESPONDING zssd_log_tit_cliente_sirius( is_titulo ).

        ls_msg = VALUE bapiret2( id = 'ZSD_ORDEM_SIRIUS'
                                 type = 'E'
                                 number = '003'
                                 message_v1 = is_titulo-belnr2 ).

        me->go_log->add_msg(
          EXPORTING
            is_msg     = ls_msg
            is_context = ls_log_context
        ).

    ENDTRY.


  ENDMETHOD.


  METHOD determine_due_date.
* A lógica é baseada na função standard DETERMINE_DUE_DATE

    DATA:
      lv_REFE    TYPE p.

    DATA(ls_FAEDE) = Is_FAEDE.

    IF ls_FAEDE-koart = gc_tipo_conta-fornecedor
       OR ls_FAEDE-koart = gc_tipo_conta-cliente
       OR Iv_GL_FAEDE = abap_true.

*---------------------------------------------------------------------*
      IF ls_FAEDE-zfbdt IS INITIAL.
        ls_FAEDE-zfbdt = ls_FAEDE-bldat.
      ENDIF.

*--Nettofälligkeit bestimmen------------------------------------------*
      IF NOT ls_FAEDE-zbd3t IS INITIAL.
        lv_REFE = ls_FAEDE-zbd3t.
      ELSE.
        IF NOT ls_FAEDE-zbd2t IS INITIAL.
          lv_REFE = ls_FAEDE-zbd2t.
        ELSE.
          lv_REFE = ls_FAEDE-zbd1t.
        ENDIF.
      ENDIF.
*--Nichtrechnungsbezogene Gutschriften sind sofort fällig-------------*
      IF ls_FAEDE-koart = gc_tipo_conta-cliente AND ls_FAEDE-shkzg = gc_cred_deb-credito
      OR ls_FAEDE-koart = gc_tipo_conta-fornecedor AND ls_FAEDE-shkzg = gc_cred_deb-debito.
        IF ls_FAEDE-rebzg IS INITIAL.
          lv_REFE = 0.
        ENDIF.
      ENDIF.
      ls_FAEDE-netdt = ls_FAEDE-zfbdt + lv_REFE.

*--Skontofälligkeiten bestimmen---------------------------------------*
      IF NOT ls_FAEDE-zbd2t IS INITIAL.
        ls_FAEDE-sk2dt = ls_FAEDE-zfbdt + ls_FAEDE-zbd2t.
      ELSE.
        ls_FAEDE-sk2dt = ls_FAEDE-netdt.
      ENDIF.
      IF NOT ls_FAEDE-zbd1t IS INITIAL
      OR NOT ls_FAEDE-zbd2t IS INITIAL.
        ls_FAEDE-sk1dt = ls_FAEDE-zfbdt + ls_FAEDE-zbd1t.
      ELSE.
        ls_FAEDE-sk1dt = ls_FAEDE-netdt.
      ENDIF.
*--Nichtrechnungsbezogene Gutschriften sind sofort fällig-------------*
      IF ls_FAEDE-koart = gc_tipo_conta-cliente AND ls_FAEDE-shkzg = gc_cred_deb-credito
      OR ls_FAEDE-koart = gc_tipo_conta-fornecedor AND ls_FAEDE-shkzg = gc_cred_deb-debito.
        IF ls_FAEDE-rebzg IS INITIAL.
          ls_FAEDE-sk2dt = ls_FAEDE-netdt.
          ls_FAEDE-sk1dt = ls_FAEDE-netdt.
        ENDIF.
      ENDIF.

    ELSE.
      " MESSAGE E122 RAISING ACCOUNT_TYPE_NOT_SUPPORTED.
      RETURN.
    ENDIF.

    rs_result = ls_FAEDE.

  ENDMETHOD.


  METHOD handle_sql_exception.

    FORMAT COLOR COL_NEGATIVE.
    IF is_sql_exception->db_error = 'X'.
      WRITE: / 'SQL error occured:', is_sql_exception->sql_code,
             / is_sql_exception->sql_message.               "#EC NOTEXT
    ELSE.
      WRITE:
        / 'Error from DBI (details in dev-trace):',
          is_sql_exception->internal_error.                 "#EC NOTEXT
    ENDIF.

    MESSAGE e000(zsd_ordem_sirius) WITH 'ERRO'.

  ENDMETHOD.
ENDCLASS.
