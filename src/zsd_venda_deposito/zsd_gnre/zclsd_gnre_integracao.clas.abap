  CLASS zclsd_gnre_integracao DEFINITION
  PUBLIC
  CREATE PUBLIC .
    PUBLIC SECTION.
      TYPES:
        BEGIN OF ty_s_mod_itens,
          itemguia TYPE ze_gnre_itemguia,
          receita  TYPE ze_gnre_receita,
          convenio TYPE ze_gnre_convenio,
          produto  TYPE ze_gnre_produto,
        END OF ty_s_mod_itens .
      TYPES:
        ty_t_mod_itens TYPE TABLE OF ty_s_mod_itens WITH DEFAULT KEY .
      TYPES:
        BEGIN OF ty_s_retorno_integracao,
          faedt        TYPE ztsd_gnret001-faedt,
          prot_guia    TYPE ztsd_gnret001-prot_guia,
          ident_guia   TYPE ztsd_gnret001-ident_guia,
          num_guia     TYPE ztsd_gnret001-num_guia,
          brcde_guia   TYPE ztsd_gnret001-brcde_guia,
          ldig_guia    TYPE ztsd_gnret001-ldig_guia,
          status_guia  TYPE ztsd_gnret001-status_guia,
          desc_st_guia TYPE ztsd_gnret001-desc_st_guia,
          new_credat   TYPE ztsd_gnret001-credat,
          new_cretim   TYPE ztsd_gnret001-cretim,
          new_crenam   TYPE ztsd_gnret001-crenam,
          mod_itens    TYPE ty_t_mod_itens,
        END OF ty_s_retorno_integracao .
      TYPES:
        ty_v_line43 TYPE n LENGTH 43.

      CONSTANTS:
        BEGIN OF gc_type,
          process TYPE char1 VALUE '1',
          consult TYPE char1 VALUE '2',
        END OF gc_type .
      CLASS-METHODS fill_soap_header_dua_es
        IMPORTING
          !iv_versao  TYPE string
          !iv_servico TYPE string
          !io_proxy   TYPE REF TO if_proxy_basis .
      CLASS-METHODS fill_soap_header_gnre_pe
        IMPORTING
          !iv_versao  TYPE string
          !iv_servico TYPE string
          !io_proxy   TYPE REF TO if_proxy_basis .
      METHODS constructor
        IMPORTING
          !iv_docguia   TYPE ztsd_gnret001-docguia
          !io_automacao TYPE REF TO zclsd_gnre_automacao .
      METHODS integrate
        IMPORTING
          !iv_type         TYPE char1 DEFAULT gc_type-process
        RETURNING
          VALUE(rs_return) TYPE ty_s_retorno_integracao .

    PROTECTED SECTION.
private section.

  data GV_DOCGUIA type ZTSD_GNRET001-DOCGUIA .
  data GO_AUTOMACAO type ref to ZCLSD_GNRE_AUTOMACAO .
  data GS_GNRE_HEADER type ZTSD_GNRET001 .
  data GT_GNRE_ITEM type ZCLSD_GNRE_AUTOMACAO=>TY_T_GNRE_ITEM .
  data:
    GT_GNRE_CONFIG type TABLE of ztsd_gnre_config .
  data GO_XML_HELPER type ref to CL_SECXML_HELPER .

  methods GET_TIPO_VALOR
    importing
      !IV_TAXTYP type J_1BTAXTYP
    returning
      value(RV_TIPO_VALOR) type STRING .
  methods CONSULTAR_LOTE_GNRE_PE_1_00
    importing
      !IS_CONSULTALOTE type ZSSD_GNRE_CONSULTALOTE
    exporting
      !ES_RETORNOLOTE type ZSSD_GNRE_RETORNOLOTE
    returning
      value(RS_RETORNO) type BAPIRETURN .
  methods CONSULT_GNRE_PE_1_00
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods CONSULT_GNRE_PE_2_00
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods CONSULT_GNRE_RJ
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods FILL_BRANCH_DATA_GNRE_PE_1_00
    importing
      !IV_BUKRS type ZCLSD_GNRE_AUTOMACAO=>TY_S_J_1BNFDOC-BUKRS
      !IV_BRANCH type ZCLSD_GNRE_AUTOMACAO=>TY_S_J_1BNFDOC-BRANCH
    changing
      !CS_DADOSGUIA type ZSSD_GNRE_DADOSGUIA .
  methods FILL_INPUT_PROC_GNRE_PE_2_00
    changing
      !CS_INPUT type ZCLSD_MT_DADOS_EMISSAO1 .
  methods GET_BOLETO_INTERVAL
    importing
      !IV_BARCODE type ZTSD_GNRET001-BRCDE_GUIA
    returning
      value(RV_INTERVAL) type NUMC2 .
  methods GET_CAMPOS_EXTRA
    importing
      !IS_GNRE_ITEM type ZTSD_GNRET002
    returning
      value(RT_CAMPOS_EXTRAS) type ZCLSD_DT_DADOS_EMISSAO_CAM_TAB .
  methods GET_CONFIG_DET_RECEITA
    importing
      !IV_TAXTYP type J_1BTAXTYP
      !IV_REGIO type REGIO
    returning
      value(RV_DET_RECEITA) type ZE_GNRE_DETALHA_RECEITA .
  methods GET_CONTRIB_DEST
    importing
      !IS_GNRE_ITEM type ZTSD_GNRET002
    returning
      value(RS_CONTRIB_DEST) type ZCLSD_DT_DADOS_EMISSAO_CONTRI1 .
  methods GET_DATA_VENCIMENTO
    importing
      !IS_GNRE_ITEM type ZTSD_GNRET002
    returning
      value(RV_DATA_VENCIMENTO) type SY-DATUM .
  methods GET_DOC_ORIGEM
    importing
      !IS_GNRE_ITEM type ZTSD_GNRET002
    returning
      value(RS_DOC_ORIGEM) type ZCLSD_DT_DADOS_EMISSAO_DOCUMEN .
  methods GET_EMAIL_GNRE_RJ
    returning
      value(RV_EMAIL) type ZEMITENTE-EMAIL .
  methods GET_INTERVAL_BARCODE_GNRE
    importing
      !IV_BARCODE type ZTSD_GNRET001-BRCDE_GUIA optional
    returning
      value(RV_INTERVAL) type NUMC2 .
  methods GET_ITEM_INP_PROC_GNRE_PE_2_00
    importing
      !IV_REGIO type REGIO
    exporting
      !ET_ITEM type ZCLSD_DT_DADOS_EMISSAO_ITE_TAB
      !EV_VALORGNRE type ZE_GNRE_PE2TDEC_1502 .
  methods GET_ITEM_PAGAMENTO_GNRE_RJ
    returning
      value(RS_ITEM_PAGAMENTO) type ZITEM_PAGAMENTO .
  methods GET_NEXT_IDENT_GUIA
    returning
      value(RV_NEXT_IDENT_GUIA) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO-IDENT_GUIA .
  methods GET_TP_AMB
    returning
      value(RV_TP_AMB) type CHAR1 .
  methods GET_VALUE_FROM_XML_XPATH
    importing
      !IV_EXPRESSION type STRING
      !IV_XML type XSTRING
    returning
      value(RV_VALUE) type STRING .
  methods INTEGRATE_DUA_ES
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods INTEGRATE_GNRE_PE_1_00
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods INTEGRATE_GNRE_PE_2_00
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods INTEGRATE_GNRE_RJ
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods INTEGRATE_GNRE_SP
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods MOUNT_LDIG_GUIA_DUA_ES
    importing
      !IV_BRCDE_GUIA type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO-BRCDE_GUIA
    returning
      value(RV_LDIG_GUIA) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO-LDIG_GUIA .
  methods MOUNT_LDIG_GUIA_GNRE_RJ
    importing
      !IV_BRCDE_GUIA type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO-BRCDE_GUIA
    returning
      value(RV_LDIG_GUIA) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO-LDIG_GUIA .
  methods PROCESSAR_LOTE_GNRE_PE_1_00
    importing
      value(IS_DADOSGUIA) type ZSSD_GNRE_DADOSGUIA
      value(IS_J_1BNFDOC) type ZCLSD_GNRE_AUTOMACAO=>TY_S_J_1BNFDOC
    exporting
      value(ES_RETORNOGUIA) type ZSSD_GNRE_RETORNOGUIA
    returning
      value(RS_RETORNO) type BAPIRETURN .
  methods PROCESS_GNRE_PE_1_00
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods PROCESS_GNRE_PE_2_00
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods PROCESS_GNRE_RJ
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
  methods UPDATE_ITEM_CONFIG
    changing
      !CS_GNRE_ITEM type ZCLSD_GNRE_AUTOMACAO=>TY_T_GNRE_ITEM .
  methods GERAR_DADOS_GNRE_CONFIG .
  methods CONVERTE_XTRING_TO_STRING
    importing
      !IV_XSTRING type XSTRING
    exporting
      !EV_STRING type STRING .
  methods INTEGRATE_DUA_ES_PI
    importing
      !IV_TYPE type CHAR1
    returning
      value(RS_RETURN) type ZCLSD_GNRE_INTEGRACAO=>TY_S_RETORNO_INTEGRACAO .
ENDCLASS.



CLASS ZCLSD_GNRE_INTEGRACAO IMPLEMENTATION.


    METHOD update_item_config.

      DATA: lt_ztsd_gnre_config TYPE TABLE OF ztsd_gnre_config.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
      ).

      CHECK cs_gnre_item IS NOT INITIAL.

      SELECT *
        FROM ztsd_gnre_config
        INTO TABLE lt_ztsd_gnre_config
        FOR ALL ENTRIES IN cs_gnre_item
        WHERE regio  = ls_j_1bnfdoc-regio
          AND taxtyp = cs_gnre_item-taxtyp.

      IF sy-subrc IS INITIAL.

        LOOP AT cs_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>).

          ASSIGN lt_ztsd_gnre_config[ taxtyp = <fs_s_gnre_item>-taxtyp ] TO FIELD-SYMBOL(<fs_s_gnre_config>).

          CHECK sy-subrc IS INITIAL.

          <fs_s_gnre_item>-receita  = <fs_s_gnre_config>-receita.
          <fs_s_gnre_item>-convenio = <fs_s_gnre_config>-convenio.
          <fs_s_gnre_item>-produto  = <fs_s_gnre_config>-produto.
        ENDLOOP.
      ENDIF.
    ENDMETHOD.


    METHOD process_gnre_rj.

      DATA: ls_input           TYPE zenviar_dados,
            ls_parnad          TYPE j_1binnad,
            lv_vencimento_conv TYPE char10.

      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bnfnad-parid( |{ gs_gnre_header-bukrs }{ gs_gnre_header-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        ls_parnad-name1 = ''.
      ENDIF.

      TRY.

          DATA(lr_gnre_rj) = NEW zclsd_co_gnre_rj_gerar_doc_soa( ).

          "Obtêm a data de vencimento e código do produto
          LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>).
            DATA(lv_cod_produto) = <fs_s_gnre_item>-produto.
            DATA(lv_vencimento)  = get_data_vencimento( <fs_s_gnre_item> ).
            IF lv_vencimento IS NOT INITIAL.
              WRITE lv_vencimento TO lv_vencimento_conv DD/MM/YYYY.
              TRANSLATE lv_vencimento_conv USING './'.
              EXIT.
            ENDIF.
          ENDLOOP.

          rs_return-faedt = lv_vencimento.

          ls_input-emitente-cnpj_emitente = ls_parnad-cgc.
          ls_input-emitente-email         = get_email_gnre_rj( ).
          ls_input-documentos-documento = VALUE #( ( tipo_pagamento = '1' "ICMS/FECP
                                                     tipo_documento = '2' "GNRE
                                                     data_pagamento = lv_vencimento_conv
                                                     itens_pagamentos-item_pagamento = VALUE #( ( get_item_pagamento_gnre_rj( ) ) ) ) ).

          lr_gnre_rj->enviar_dados(
            EXPORTING
              input              = ls_input
            IMPORTING
              output             = DATA(ls_output)
          ).

          rs_return-prot_guia    = ls_output-enviar_dados_result-id_sessao.
          rs_return-status_guia  = ls_output-enviar_dados_result-retorno-codigo_retorno.
          rs_return-desc_st_guia = ls_output-enviar_dados_result-retorno-mensagem_retorno.

          CASE rs_return-status_guia.

            WHEN '14'. "RECEBIDO COM SUCESSO. EM PROCESSAMENTO

              "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_solicitada
                                      iv_newdoc       = CONV #( rs_return-prot_guia )
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN OTHERS.

              "Etapa: Rejeição no Envio do Lote
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-rejeicao_no_envio_do_lote
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

          ENDCASE.

        CATCH cx_ai_system_fault INTO DATA(lo_ref).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

      ENDTRY.

    ENDMETHOD.


    METHOD process_gnre_pe_2_00.

*      DATA: ls_input       TYPE zgnre_dados_msg,
      DATA: ls_input       TYPE zclsd_mt_dados_emissao1,
            ls_output      TYPE zclsd_mt_dados_emissao_resp1,
            lv_xsdany      TYPE xsdany,
            lv_xml_sring   TYPE string,
            lv_str_xstring TYPE xstring,
            ls_output_pe   TYPE zclsd_mt_dados_consulta1,
            ls_input_pe    TYPE zclsd_mt_dados_consulta_resp1,
            lt_itab        TYPE TABLE OF smum_xmltb,
            lt_return      TYPE TABLE OF bapiret2.

      TRY.

*          DATA(lr_gnre_envio) = NEW zclsd_co_gnre_pe2_lote_rec_soa( ).
          DATA(lr_gnre_envio) = NEW zclsd_co_si_enviar_dados_emis1( ).

*          fill_soap_header_gnre_pe( iv_versao  = '2.00'
*                                    iv_servico = 'GnreLoteRecepcao'
*                                    io_proxy   = lr_gnre_envio      ).

          fill_input_proc_gnre_pe_2_00( CHANGING cs_input = ls_input ).

*          CALL TRANSFORMATION ztr_gnre_dua_pe_request
*            SOURCE zgnre_dados_msg = ls_input
*            RESULT XML lv_xsdany
*            OPTIONS xml_header = 'no'.
*
*          me->converte_xtring_to_string(
*            EXPORTING
*              iv_xstring   = lv_xsdany
*            IMPORTING
*              ev_string    = lv_xml_sring
*          ).
*
*          DATA(lr_cosulta_pe) = NEW zclsd_co_si_enviar_dados_cons1( ).
*
**          ls_output_pe-mt_dados_consulta-gnre_dados_msg = |<![CDATA[{ lv_xml_sring }]]>|.
*
*          lr_cosulta_pe->si_enviar_dados_consulta_out(
*            EXPORTING
*              output = ls_output_pe
*            IMPORTING
*              input  = ls_input_pe
*          ).
*

**          lr_gnre_envio->processar(
**            EXPORTING
**              input              = ls_input
**            IMPORTING
**              output             = DATA(ls_output)
**          ).

          CALL METHOD lr_gnre_envio->si_enviar_dados_emissao_out
            EXPORTING
              output = ls_input
            IMPORTING
              input  = ls_output.
*          CATCH cx_ai_system_fault. " Erro de comunicação

          CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
            EXPORTING
              text   = ls_output-mt_dados_emissao_resp-gnre_dados_msg_resp
            IMPORTING
              buffer = lv_str_xstring.

          TRY.
              DATA(lv_data_pagamento) = ls_input-mt_dados_emissao-tlote_gnre-guias-tdados_gnre[ 1 ]-data_pagamento.
              rs_return-faedt         = lv_data_pagamento(4) && lv_data_pagamento+5(2) && lv_data_pagamento+8(2).
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

          TRY.
              rs_return-prot_guia    = get_value_from_xml_xpath( iv_expression = '//*:numero'
                                                                 iv_xml        = lv_str_xstring ).
              rs_return-status_guia  = get_value_from_xml_xpath( iv_expression = '//*:codigo'
                                                                 iv_xml        = lv_str_xstring ).
              rs_return-desc_st_guia = get_value_from_xml_xpath( iv_expression = '//*:descricao'
                                                                 iv_xml        = lv_str_xstring ).
            CATCH cx_sy_itab_line_not_found INTO DATA(ls_line_not_found).

          ENDTRY.
*          rs_return-prot_guia    = ls_output-tret_lote_gnre-recibo-numero.
*          rs_return-status_guia  = ls_output-tret_lote_gnre-situacao_recepcao-codigo.
*          rs_return-desc_st_guia = ls_output-tret_lote_gnre-situacao_recepcao-descricao.

          CASE rs_return-status_guia.

            WHEN '100'. "Lote recebido com Sucesso

              "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_solicitada
                                      iv_newdoc       = CONV #( rs_return-prot_guia )
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN '102'. "CNPJ não habilitado para uso do serviço.

              "Etapa: CNPJ Não Habilitado Para Uso do Serviço
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-cnpj_nao_habilitado_para_uso
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN OTHERS.

              "Etapa: Rejeição no Envio do Lote
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-rejeicao_no_envio_do_lote
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

          ENDCASE.

        CATCH cx_ai_system_fault INTO DATA(lo_ref).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

      ENDTRY.

    ENDMETHOD.


    METHOD process_gnre_pe_1_00.

      DATA: ls_dadosguia TYPE zssd_gnre_dadosguia.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc      = DATA(ls_j_1bnfdoc)
          es_j_1bnfe_active = DATA(ls_j_1bnfe_active)
      ).

      rs_return-ident_guia = get_next_ident_guia( ).

      ls_dadosguia = VALUE #( docdat        = ls_j_1bnfdoc-docdat
                              emit_cnpj     = ls_j_1bnfdoc-cnpj_bupla
                              state_insc    = ls_j_1bnfdoc-ie_bupla
                              dest_regio    = ls_j_1bnfdoc-regio
                              dest_cnpj     = ls_j_1bnfdoc-cgc
                              dest_cpf      = ls_j_1bnfdoc-cpf
                              dest_name     = ls_j_1bnfdoc-name1
                              txjcd         = ls_j_1bnfdoc-txjcd
                              nfenum        = ls_j_1bnfdoc-nfenum
                              identificador = rs_return-ident_guia     ).

      CONCATENATE ls_j_1bnfe_active-regio
                  ls_j_1bnfe_active-nfyear
                  ls_j_1bnfe_active-nfmonth
                  ls_j_1bnfe_active-stcd1
                  ls_j_1bnfe_active-model
                  ls_j_1bnfe_active-serie
                  ls_j_1bnfe_active-nfnum9
                  ls_j_1bnfe_active-docnum9
                  ls_j_1bnfe_active-cdv
             INTO ls_dadosguia-acckey.

      ASSIGN gt_gnre_item[ docguia = gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_item>).
      IF sy-subrc IS INITIAL.

        ls_dadosguia-taxtyp = <fs_s_gnre_item>-taxtyp.
        ls_dadosguia-nftot  = <fs_s_gnre_item>-taxval.

      ENDIF.

      fill_branch_data_gnre_pe_1_00(
        EXPORTING
          iv_bukrs  = ls_j_1bnfdoc-bukrs
          iv_branch = ls_j_1bnfdoc-branch
        CHANGING
          cs_dadosguia = ls_dadosguia
      ).

      "Ajustando caracteres especiais
      TRANSLATE ls_dadosguia-dest_name USING '< > & '' '.
      TRANSLATE ls_dadosguia-street USING '< > & '' '.
      TRANSLATE ls_dadosguia-name1 USING '< > & '' '.
      TRANSLATE ls_dadosguia-name1 USING '< > & '' '.

      processar_lote_gnre_pe_1_00(
        EXPORTING
          is_dadosguia   = ls_dadosguia    " Dados de Guia para geração do GNRE
          is_j_1bnfdoc   = ls_j_1bnfdoc
        IMPORTING
          es_retornoguia = DATA(ls_retornoguia)    " Retorno do Lote
        RECEIVING
          rs_retorno     = DATA(ls_retorno)    " Parâmetro de retorno
      ).

      rs_return-prot_guia    = ls_retornoguia-recibo.
      rs_return-status_guia  = ls_retornoguia-cod_retorno.
      rs_return-desc_st_guia = ls_retornoguia-descricao_retorno.

      CASE rs_return-status_guia.

        WHEN '100'. "Lote recebido com Sucesso

          "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_solicitada
                                  iv_newdoc       = CONV #( rs_return-prot_guia )
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia               ).

        WHEN '102'. "CNPJ não habilitado para uso do serviço.

          "Etapa: CNPJ Não Habilitado Para Uso do Serviço
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-cnpj_nao_habilitado_para_uso
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia               ).

        WHEN OTHERS.

          IF rs_return-status_guia IS INITIAL.

            IF ls_retorno-code = '000'.
              rs_return-desc_st_guia = ls_retorno-message.
            ELSE.
              rs_return-status_guia  = ls_retorno-code.
              rs_return-desc_st_guia = ls_retorno-message.
            ENDIF.

          ENDIF.

          "Etapa: Rejeição no Envio do Lote
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-rejeicao_no_envio_do_lote
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia               ).

      ENDCASE.

    ENDMETHOD.


    METHOD processar_lote_gnre_pe_1_00.

* Buscar configuração
      DATA: ls_gnre_config TYPE ztsd_gnre_config.

      DATA: lv_stains_type TYPE dd01v-datatype.

      DATA: lv_message TYPE string.
      lv_message = TEXT-004.

      SELECT SINGLE * FROM ztsd_gnre_config
       INTO ls_gnre_config
       WHERE regio = is_dadosguia-dest_regio
         AND taxtyp = is_dadosguia-taxtyp.

      IF sy-subrc <> 0.

        REPLACE '&1' WITH is_dadosguia-dest_regio INTO lv_message.
        REPLACE '&2' WITH is_dadosguia-taxtyp INTO lv_message.

        rs_retorno-type = 'E'.
        rs_retorno-message = lv_message.
        "rs_retorno-message = |Sem configuração para o estado { is_dadosguia-dest_regio } e tipo de imposto { is_dadosguia-taxtyp }|.

        RETURN.
      ENDIF.

      DATA: lo_gnre_pe TYPE REF TO zclsd_co_gnre_pe1_lote_rec_soa.

      TRY.

          lo_gnre_pe = NEW #( ).

          fill_soap_header_gnre_pe( io_proxy   = lo_gnre_pe
                                    iv_servico = 'GnreLoteRecepcao'
                                    iv_versao  = '1.00'             ).

        CATCH cx_ai_system_fault INTO DATA(lo_ref).
          rs_retorno-type = 'E'.
          rs_retorno-message = lo_ref->get_text( ).
          RETURN.
      ENDTRY.


      DATA: ls_soap_in  TYPE zgnre_dados_msg2,
            ls_soap_out TYPE zprocessar_response1.

      DATA: ls_dados_gnre TYPE ztlote_gnre_tdados_gnre1.

      DATA: lv_data       TYPE d,
            lv_dw         TYPE p,
            ls_uf_diautil TYPE ztsd_gnre_uf_du.

      lv_data = sy-datum.

      ls_dados_gnre-c01_uf_favorecida =  is_dadosguia-dest_regio.
      ls_dados_gnre-c02_receita       =  ls_gnre_config-receita.
      ls_dados_gnre-c25_detalhamento_receita  =  ls_gnre_config-detalha_receita. " '000000'.
      ls_dados_gnre-c26_produto = ls_gnre_config-produto.
      ls_dados_gnre-c27_tipo_identificacao_emitent =  '1'.
      ls_dados_gnre-c03_id_contribuinte_emitente-choice-selection = 'CNPJ'.
      ls_dados_gnre-c03_id_contribuinte_emitente-choice-cnpj = is_dadosguia-emit_cnpj.
      ls_dados_gnre-c28_tipo_doc_origem =  ls_gnre_config-tipo_doc_origem.
      ls_dados_gnre-c04_doc_origem = is_dadosguia-nfenum.
      ls_dados_gnre-c06_valor_principal =  |{ is_dadosguia-nftot }|.
      ls_dados_gnre-c10_valor_total =  |{ is_dadosguia-nftot }|.
      IF ls_gnre_config-enviar_vencimento = abap_true.
        ls_dados_gnre-c14_data_vencimento =  |{ lv_data DATE = ISO }|.
      ENDIF.
      ls_dados_gnre-c15_convenio = ls_gnre_config-convenio.
      ls_dados_gnre-c16_razao_social_emitente = is_dadosguia-name1.
      ls_dados_gnre-c17_inscricao_estadual_emitent = is_dadosguia-state_insc.
      ls_dados_gnre-c18_endereco_emitente = is_dadosguia-street.
      is_dadosguia-city1 = |{ is_dadosguia-city1 WIDTH = 15 ALIGN = RIGHT  PAD = ' ' }|.
      ls_dados_gnre-c19_municipio_emitente = is_dadosguia-city1+10(5).  " ultimos 5 caracteres
      ls_dados_gnre-c20_uf_endereco_emitente = is_dadosguia-region.
      ls_dados_gnre-c21_cep_emitente = is_dadosguia-post_code1.
      ls_dados_gnre-c22_telefone_emitente = is_dadosguia-tel_number.

      IF ls_gnre_config-enviar_destinatario = abap_true.

        IF is_dadosguia-dest_cpf IS INITIAL OR is_dadosguia-dest_cpf = '00000000000'.
          ls_dados_gnre-c34_tipo_identificacao_destina                  = '1'.
          ls_dados_gnre-c35_id_contribuinte_destinatar-choice-selection = 'CNPJ'.
          ls_dados_gnre-c35_id_contribuinte_destinatar-choice-cnpj      = is_dadosguia-dest_cnpj.
        ELSE.
          ls_dados_gnre-c34_tipo_identificacao_destina                  = '2'.
          ls_dados_gnre-c35_id_contribuinte_destinatar-choice-selection = 'CPF'.
          ls_dados_gnre-c35_id_contribuinte_destinatar-choice-cpf       = is_dadosguia-dest_cpf.
        ENDIF.

        CALL FUNCTION 'NUMERIC_CHECK'
          EXPORTING
            string_in = is_j_1bnfdoc-stains
          IMPORTING
            htype     = lv_stains_type.

        "Verifica se o campo está preenchido e não possui apenas números
        IF is_j_1bnfdoc-stains IS NOT INITIAL AND lv_stains_type = 'NUMC'.
          ls_dados_gnre-c36_inscricao_estadual_destina = is_j_1bnfdoc-stains.
        ENDIF.

        ls_dados_gnre-c37_razao_social_destinatario = is_dadosguia-dest_name.
        is_dadosguia-txjcd = |{ is_dadosguia-txjcd WIDTH = 15 ALIGN = RIGHT  PAD = ' ' }|.
        ls_dados_gnre-c38_municipio_destinatario =  is_dadosguia-txjcd+10(5).  " ultimos 5 caracteres
      ENDIF.

      ls_dados_gnre-c33_data_pagamento =  |{ lv_data DATE = ISO }|.
      ls_dados_gnre-c05_referencia-periodo = ls_gnre_config-periodo.
      ls_dados_gnre-c05_referencia-mes = lv_data+4(2).
      ls_dados_gnre-c05_referencia-ano = lv_data(4).
      ls_dados_gnre-c05_referencia-parcela = COND #( WHEN ls_gnre_config-enviar_parcela = abap_true THEN '1' ELSE ' ' )..

      IF NOT ls_gnre_config-codigo_chaveacesso IS INITIAL.
        DATA: ls_campoextra TYPE ztlote_gnre_campo_extra.
*    ZTLOTE_GNRE_CAMPO_EXTRA : CODIGO TIPO VALOR
        ls_campoextra-codigo = ls_gnre_config-codigo_chaveacesso.
        ls_campoextra-tipo = 'T'.
        ls_campoextra-valor = is_dadosguia-acckey.
        APPEND ls_campoextra TO ls_dados_gnre-c39_campos_extras-campo_extra.
      ENDIF.

* Parametrizar

      ls_dados_gnre-c42_identificador_guia = is_dadosguia-identificador.

      APPEND ls_dados_gnre TO ls_soap_in-tlote_gnre-guias-tdados_gnre.

      TRY.
          lo_gnre_pe->processar( EXPORTING input  = ls_soap_in
                                  IMPORTING output = ls_soap_out ).

        CATCH cx_ai_system_fault INTO DATA(lo_ref_fault).
          rs_retorno-type = 'E'.
          rs_retorno-message = lo_ref_fault->get_text( ).
          RETURN.
      ENDTRY.
      DATA ls_datahora TYPE string.

      es_retornoguia-cod_retorno =  ls_soap_out-tret_lote_gnre-situacao_recepcao-codigo.
      es_retornoguia-descricao_retorno = ls_soap_out-tret_lote_gnre-situacao_recepcao-descricao.
      es_retornoguia-recibo = ls_soap_out-tret_lote_gnre-recibo-numero.
      ls_datahora = ls_soap_out-tret_lote_gnre-recibo-data_hora_recibo.
      IF strlen( ls_datahora ) >= 19.
        es_retornoguia-data_recibo = ls_datahora(4) && ls_datahora+5(2) && ls_datahora+8(2).
        es_retornoguia-hora_recibo = ls_datahora+11(2) && ls_datahora+14(2) && ls_datahora+17(2).
      ENDIF.
      es_retornoguia-tempo_estimado_proc = ls_soap_out-tret_lote_gnre-recibo-tempo_estimado_proc.

      IF es_retornoguia-cod_retorno = '100'.
        rs_retorno-type = 'S'.
        rs_retorno-message = TEXT-003. "Processado com sucesso'. " es_retornoguia-descricao_retorno.
      ELSE.
        rs_retorno-type = 'E'.
        rs_retorno-message = TEXT-001. "'Erro no processamento'.  " es_retornoguia-descricao_retorno.
      ENDIF.

    ENDMETHOD.


    METHOD mount_ldig_guia_gnre_rj.
      DATA: lv_check_digit_grp1 TYPE c,
            lv_check_digit_grp2 TYPE c,
            lv_check_digit_grp3 TYPE c,
            lv_check_digit_grp4 TYPE c,
            ls_parnad           TYPE j_1binnad.
      "Obtêm os dígitos verificadores
      lv_check_digit_grp1 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia(11) ).
      lv_check_digit_grp2 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+11(11) ).
      lv_check_digit_grp3 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+22(11) ).
      lv_check_digit_grp4 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+33(11) ).
      "Monta a linha digitável
      rv_ldig_guia = iv_brcde_guia(11)    && lv_check_digit_grp1 &&
                     iv_brcde_guia+11(11) && lv_check_digit_grp2 &&
                     iv_brcde_guia+22(11) && lv_check_digit_grp3 &&
                     iv_brcde_guia+33(11) && lv_check_digit_grp4.
    ENDMETHOD.


    METHOD mount_ldig_guia_dua_es.
      DATA: lv_check_digit_grp1 TYPE c,
            lv_check_digit_grp2 TYPE c,
            lv_check_digit_grp3 TYPE c,
            lv_check_digit_grp4 TYPE c,
            ls_parnad           TYPE j_1binnad.
      "Obtêm os dígitos verificadores
      lv_check_digit_grp1 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia(11) ).
      lv_check_digit_grp2 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+11(11) ).
      lv_check_digit_grp3 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+22(11) ).
      lv_check_digit_grp4 = zcl_fi_boletos=>dv_conv_mod11( iv_brcde_guia+33(11) ).
      "Monta a linha digitável
      rv_ldig_guia = iv_brcde_guia(11)    && lv_check_digit_grp1 &&
                     iv_brcde_guia+11(11) && lv_check_digit_grp2 &&
                     iv_brcde_guia+22(11) && lv_check_digit_grp3 &&
                     iv_brcde_guia+33(11) && lv_check_digit_grp4.
    ENDMETHOD.


    METHOD integrate_gnre_sp.

      DATA: lv_valor_total      TYPE c LENGTH 11,
            lv_brcde_43         TYPE c LENGTH 43,
            lv_check_digit_43   TYPE c,
            lv_check_digit_grp1 TYPE c,
            lv_check_digit_grp2 TYPE c,
            lv_check_digit_grp3 TYPE c,
            lv_check_digit_grp4 TYPE c,
            lv_codigo           TYPE char7,
            ls_parnad           TYPE j_1binnad.

      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bnfnad-parid( |{ gs_gnre_header-bukrs }{ gs_gnre_header-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        ls_parnad-name1 = ''.
      ENDIF.

      "1       Identificação do Produto                       Fixo: "8" para identificar arrecadação
      "2       Identificação do Segmento                      Fixo: "5" para órgãos governamentais
      "3       Identificador de Valor Efetivo ou Referência   Fixo: "6" Valor a ser cobrado efetivamente em reais
      "4       Dígito Verificador                             Dígito Verificador calculado com base nos outros 43 dígitos do código de barras
      "5~15    Valor                                          Valor total do boleto
      "16~22   Identificação da Empresa/Órgão                 Fixo: "0099991" para identificação do órgão
      "23~36   CNPJ do emissor                                Números do CNPJ referente ao Local de Negócios emissor da NF-e
      "37~44   Período                                        Período de emissão da GNRE no formato AAAAMMDD (DD sempre será fixo como 01)

      "Monta o valor total, removendo o . e acrescentando zeros a esquerda
      lv_valor_total = gs_gnre_header-vlrtot.
      REPLACE ALL OCCURRENCES OF '.' IN lv_valor_total WITH ''.
      SHIFT lv_valor_total RIGHT DELETING TRAILING space.
      TRANSLATE lv_valor_total USING ' 0'.

      SELECT SINGLE codigo
        FROM zfit050
        INTO lv_codigo
        WHERE data <= sy-datum.


      lv_brcde_43 = |856{ lv_valor_total }{ lv_codigo }{ ls_parnad-cgc }{ sy-datum(6) }{ get_interval_barcode_gnre( ) }|.

      CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
        EXPORTING
          number_part = lv_brcde_43
        IMPORTING
          check_digit = lv_check_digit_43.

      rs_return-brcde_guia = lv_brcde_43(3) && lv_check_digit_43 && lv_brcde_43+3.

      "Verificando se existe barcode gerado. Caso sim, gerando um intervalo novo
      DATA(lv_interval) = get_boleto_interval( rs_return-brcde_guia ).

      IF lv_interval NE '00'.
        lv_brcde_43 = |856{ lv_valor_total }{ lv_codigo }{ ls_parnad-cgc }{ sy-datum(6) }{ lv_interval }|.

        CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
          EXPORTING
            number_part = lv_brcde_43
          IMPORTING
            check_digit = lv_check_digit_43.

        rs_return-brcde_guia = lv_brcde_43(3) && lv_check_digit_43 && lv_brcde_43+3.
      ENDIF.

      "Obtêm os dígitos verificadores para a linha digitável
      CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
        EXPORTING
          number_part = rs_return-brcde_guia(11)
        IMPORTING
          check_digit = lv_check_digit_grp1.

      CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
        EXPORTING
          number_part = rs_return-brcde_guia+11(11)
        IMPORTING
          check_digit = lv_check_digit_grp2.

      CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
        EXPORTING
          number_part = rs_return-brcde_guia+22(11)
        IMPORTING
          check_digit = lv_check_digit_grp3.

      CALL FUNCTION 'CALCULATE_CHECK_DIGIT_MOD10'
        EXPORTING
          number_part = rs_return-brcde_guia+33(11)
        IMPORTING
          check_digit = lv_check_digit_grp4.

      "Monta a linha digitável
      rs_return-ldig_guia = rs_return-brcde_guia(11)    && lv_check_digit_grp1 &&
                            rs_return-brcde_guia+11(11) && lv_check_digit_grp2 &&
                            rs_return-brcde_guia+22(11) && lv_check_digit_grp3 &&
                            rs_return-brcde_guia+33(11) && lv_check_digit_grp4.

      "Obtêm a data de vencimento
      TRY.
          rs_return-faedt = get_data_vencimento( is_gnre_item = gt_gnre_item[ 1 ] ).
        CATCH cx_sy_itab_line_not_found.
      ENDTRY.

      GET TIME.

      "Atribui a data de criação da guia
      rs_return-new_credat = sy-datum.
      rs_return-new_cretim = sy-uzeit.
      rs_return-new_crenam = sy-uname.

      "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
      go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                              iv_step         = go_automacao->gc_step-guia_criada ).

    ENDMETHOD.


    METHOD integrate_gnre_rj.
      CASE iv_type.
        WHEN gc_type-process.
          rs_return = process_gnre_rj( ).
        WHEN gc_type-consult.
          rs_return = consult_gnre_rj( ).
      ENDCASE.
    ENDMETHOD.


    METHOD integrate_gnre_pe_2_00.
      CASE iv_type.
        WHEN gc_type-process.
          rs_return = process_gnre_pe_2_00( ).
        WHEN gc_type-consult.
          rs_return = consult_gnre_pe_2_00( ).
      ENDCASE.
    ENDMETHOD.


    METHOD integrate_gnre_pe_1_00.
      CASE iv_type.
        WHEN gc_type-process.
          rs_return = process_gnre_pe_1_00( ).
        WHEN gc_type-consult.
          rs_return = consult_gnre_pe_1_00( ).
      ENDCASE.
    ENDMETHOD.


    METHOD integrate_dua_es.

      DATA: ls_input TYPE zdua_emissao.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc      = DATA(ls_j_1bnfdoc)
      ).

      TRY.

          DATA(lr_dua_es) = NEW zclsd_co_gnre_es1_dua_serv_soa( logical_port_name = CONV #( ls_j_1bnfdoc-bukrs ) ).

          fill_soap_header_dua_es( iv_versao  = '1.00'
                                   iv_servico = 'DuaEmissao'
                                   io_proxy   = lr_dua_es    ).

          DATA(lv_vlrtot_conv) = CONV char15( gs_gnre_header-vlrtot ).
          REPLACE ALL OCCURRENCES OF '.' IN lv_vlrtot_conv WITH ''.
          CONDENSE lv_vlrtot_conv NO-GAPS.

          SHIFT lv_vlrtot_conv LEFT DELETING LEADING '0'.
          CONDENSE lv_vlrtot_conv NO-GAPS.

          DATA(ls_emis_dua) = VALUE zssd_gnree009( tp_amb   = get_tp_amb( )
                                               cnpj_org = '27080571000130'
                                               cnpj_pes = COND #( WHEN ls_j_1bnfdoc-cgc <> '00000000000000'
                                                                  THEN ls_j_1bnfdoc-cgc
                                                                  ELSE ls_j_1bnfdoc-cpf                     )
                                               c_area   = '5'
                                               x_inf    = |Recolhimento referente à NFe { ls_j_1bnfdoc-nfenum } { ls_j_1bnfdoc-series }|
                                               v_rec    = lv_vlrtot_conv
                                               x_ide    = ls_j_1bnfdoc-name1(30) ).


          "Obtêm o De/Para dos códigos de município DUA ES
          SELECT SINGLE
                 cmun_es
            FROM ztsd_gnret018
            INTO ls_emis_dua-c_mun
            WHERE txjcd   =  ls_j_1bnfdoc-txjcd
              AND cmun_es <> space.

          IF sy-subrc IS NOT INITIAL AND strlen( ls_j_1bnfdoc-txjcd ) >= 10.

            "Preenche o código do município, caso não seja encontrado
            ls_emis_dua-c_mun = substring( val = ls_j_1bnfdoc-txjcd off = strlen( ls_j_1bnfdoc-txjcd ) - 5 len = 5 ).

          ENDIF.

          "Preenche o código da receita e data de vencimento
          ASSIGN gt_gnre_item[ docguia = gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_item>).
          IF sy-subrc IS INITIAL.
            DATA(lv_data_vencimento) = get_data_vencimento( <fs_s_gnre_item> ).
            DATA(lv_data_vencimento_conv) = |{ lv_data_vencimento DATE = ISO }|.

            ls_emis_dua-c_serv = <fs_s_gnre_item>-receita.

            IF lv_data_vencimento IS NOT INITIAL.
              ls_emis_dua-d_ref = lv_data_vencimento_conv(7).
              ls_emis_dua-d_ven = lv_data_vencimento_conv(10).
              ls_emis_dua-d_pag = lv_data_vencimento_conv(10).
            ENDIF.

          ENDIF.

          CALL TRANSFORMATION ztr_gnre_dua_es_request
            SOURCE emisdua = ls_emis_dua
            RESULT XML ls_input-dua_dados_msg
            OPTIONS xml_header = 'no'.

          lr_dua_es->dua_emissao(
            EXPORTING
              input              = ls_input
            IMPORTING
              output             = DATA(ls_output)
          ).

          rs_return-faedt        = lv_data_vencimento.
          rs_return-status_guia  = get_value_from_xml_xpath( iv_expression = '//*:cStat'
                                                             iv_xml        = ls_output-dua_emissao_result ).
          rs_return-desc_st_guia = get_value_from_xml_xpath( iv_expression = '//*:xMotivo'
                                                             iv_xml        = ls_output-dua_emissao_result ).

          CASE rs_return-status_guia.

            WHEN '105'. "Dua emitido

              rs_return-num_guia  = get_value_from_xml_xpath( iv_expression = '//*:nDua'
                                                              iv_xml        = ls_output-dua_emissao_result ).
              rs_return-ldig_guia = get_value_from_xml_xpath( iv_expression = '//*:nBar'
                                                              iv_xml        = ls_output-dua_emissao_result ).

              "Monta o código de barras
              IF rs_return-ldig_guia IS NOT INITIAL.
                rs_return-brcde_guia = rs_return-ldig_guia(11)    && rs_return-ldig_guia+12(11) &&
                                       rs_return-ldig_guia+24(11) && rs_return-ldig_guia+36(11).
              ENDIF.

              GET TIME.

              "Atribui a data de criação da guia
              rs_return-new_credat = sy-datum.
              rs_return-new_cretim = sy-uzeit.
              rs_return-new_crenam = sy-uname.

              "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_criada
                                      iv_newdoc       = rs_return-num_guia
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN OTHERS.

              "Etapa: Rejeição no Envio do Lote
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-rejeicao_no_envio_do_lote
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

          ENDCASE.

        CATCH cx_transformation_error INTO DATA(lo_ref).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

        CATCH cx_ai_system_fault INTO DATA(lo_ref_fault).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref_fault->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

      ENDTRY.

    ENDMETHOD.


    METHOD integrate.
      CASE gs_gnre_header-tpguia.
        WHEN zclsd_gnre_automacao=>gc_tpguia-gnre_pe_1_00.
          rs_return = integrate_gnre_pe_1_00( iv_type ).
        WHEN zclsd_gnre_automacao=>gc_tpguia-gnre_pe_2_00.
          rs_return = integrate_gnre_pe_2_00( iv_type ).
        WHEN zclsd_gnre_automacao=>gc_tpguia-gnre_sp.
          rs_return = integrate_gnre_sp( iv_type ).
        WHEN zclsd_gnre_automacao=>gc_tpguia-gnre_rj.
          rs_return = integrate_gnre_rj( iv_type ).
        WHEN zclsd_gnre_automacao=>gc_tpguia-dua_es.
          "rs_return = integrate_dua_es( iv_type ).
          rs_return = integrate_dua_es_pi( iv_type ).
        WHEN OTHERS.
          "Integração Automática Não Implementada - Incluir Guia Manual
          go_automacao->set_step( iv_docguia = gv_docguia
                                  iv_step    = zclsd_gnre_automacao=>gc_step-integracao_auto_n_implementada ).
      ENDCASE.
      rs_return-mod_itens = CORRESPONDING #( gt_gnre_item ).
    ENDMETHOD.


    METHOD get_value_from_xml_xpath.
      DATA: lr_node     TYPE REF TO if_ixml_node,
            lr_iterator TYPE REF TO if_ixml_node_iterator,
            lr_nodes    TYPE REF TO if_ixml_node_collection,
            lr_xslt     TYPE REF TO cl_xslt_processor,
            lv_value    TYPE string,
            lv_length   TYPE i.
      CREATE OBJECT lr_xslt.
      lr_xslt->set_source_xstring( iv_xml ).
      CHECK lr_xslt IS BOUND.
      lr_xslt->set_expression( expression = iv_expression ).
      TRY .
          lr_xslt->run( '' ).
          lr_nodes = lr_xslt->get_nodes( ).
          CHECK lr_nodes IS BOUND.
          lr_iterator = lr_nodes->create_iterator( ).
          lv_length = lr_nodes->get_length( ).
          DO lv_length TIMES.
            lr_node  = lr_iterator->get_next( ).
            rv_value = lr_node->get_value( ).
            EXIT.
          ENDDO.
        CATCH cx_root.
          RETURN.
      ENDTRY.
    ENDMETHOD.


    METHOD get_tp_amb.
      SELECT SINGLE
             valor
        FROM ztsd_gnret015
        INTO rv_tp_amb
        WHERE parametro = zclsd_gnre_automacao=>gc_parametro-tipo_de_ambiente.
      IF sy-subrc IS NOT INITIAL OR rv_tp_amb IS INITIAL.
*        rv_tp_amb = SWITCH #( cl_adt_permission_control=>is_productive_customer_client( ) WHEN abap_true THEN '1' ELSE '2' ).
      ENDIF.
    ENDMETHOD.


    METHOD get_tipo_valor.
      go_automacao->get_config_data(
        IMPORTING
          es_ztsd_gnret005 = DATA(ls_ztsd_gnre_config)
      ).
      SELECT SINGLE subdivision
       FROM    j_1baj
       INTO @DATA(ls_subdivision)
       WHERE j_1baj~taxtyp = @iv_taxtyp
         AND j_1baj~taxgrp     IN ( 'ICMS', 'ICST' ).
      IF sy-subrc = 0 AND ( ls_subdivision = '003' OR ls_subdivision = '004' )
        AND ls_ztsd_gnre_config-guia_por_receita <> 'X'.
        rv_tipo_valor = '12'.
      ELSE.
        rv_tipo_valor = '11'.
      ENDIF.
    ENDMETHOD.


    METHOD get_next_ident_guia.
      go_automacao->get_gnre_data(
        IMPORTING
          et_header = DATA(lt_gnre_header)
      ).
      "Obtêm o registro com o maior identificador
      SORT lt_gnre_header DESCENDING BY ident_guia.
      ASSIGN lt_gnre_header[ 1 ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
      IF sy-subrc IS INITIAL.
        rv_next_ident_guia = <fs_s_gnre_header>-ident_guia + 1.
      ENDIF.
    ENDMETHOD.


    METHOD get_item_pagamento_gnre_rj.

      DATA: ls_parnad          TYPE j_1binnad,
            lv_vencimento_conv TYPE char10,
            lv_authdate_conv   TYPE char10.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc      = DATA(ls_j_1bnfdoc)
          et_j_1bnfstx      = DATA(lt_j_1bnfstx)
      ).

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_gnre_config)
      ).

      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bnfnad-parid( |{ gs_gnre_header-bukrs }{ gs_gnre_header-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        ls_parnad-name1 = ''.
      ENDIF.

      "Obtêm a data de vencimento e código do produto
      LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>).

        DATA(lv_cod_produto) = <fs_s_gnre_item>-produto.
        DATA(lv_receita)     = <fs_s_gnre_item>-receita.

        ASSIGN lt_gnre_config[ taxtyp = <fs_s_gnre_item>-taxtyp ] TO FIELD-SYMBOL(<fs_s_gnre_config>).
        IF sy-subrc IS INITIAL.
          DATA(lv_periodo) = <fs_s_gnre_config>-periodo.
        ENDIF.

        DATA(lv_vencimento)  = get_data_vencimento( <fs_s_gnre_item> ).
        IF lv_vencimento IS NOT INITIAL.
          WRITE lv_vencimento TO lv_vencimento_conv DD/MM/YYYY.
          TRANSLATE lv_vencimento_conv USING './'.
          EXIT.
        ENDIF.

      ENDLOOP.

      WRITE ls_j_1bnfdoc-authdate TO lv_authdate_conv DD/MM/YYYY.
      TRANSLATE lv_authdate_conv USING './'.

      rs_item_pagamento = VALUE #( tipo_id                   = '1' "CNPJ
                                   cnpj                      = ls_parnad-cgc
                                   codigo_produto            = lv_cod_produto
                                   data_vencimento           = lv_vencimento_conv
                                   endereco_contribuinte     = ls_parnad-stras
                                   municipio_contribuinte    = ls_parnad-ort01
                                   uf_contribuinte           = ls_parnad-regio
                                   natureza                  = lv_receita
                                   nome_razao_social         = ls_parnad-name1
                                   nota_fiscal_data_emissao  = lv_authdate_conv
                                   nota_fiscal_numero        = ls_j_1bnfdoc-nfenum
                                   nota_fiscal_serie         = ls_j_1bnfdoc-series
                                   "nota_fiscal_tipo          = 'NF-e'
                                   nota_fiscal_tipo          = TEXT-005
                                   num_controle_contribuinte = '1'
                                   tipo_apuracao             = '2'
                                   periodo_referencia_mes    = COND #( WHEN lv_periodo IS INITIAL OR
                                                                            lv_periodo = '0'
                                                                       THEN 0
                                                                       ELSE ls_j_1bnfdoc-authdate+4(2) )
                                   periodo_referencia_ano    = COND #( WHEN lv_periodo IS INITIAL OR
                                                                            lv_periodo = '0'
                                                                       THEN 0
                                                                       ELSE ls_j_1bnfdoc-authdate(4)   )
                                   valor_total               = gs_gnre_header-vlrtot                          ).

      IF ls_j_1bnfdoc-cpf IS NOT INITIAL.
        rs_item_pagamento-nota_fiscal_cpf  = ls_j_1bnfdoc-cpf.
      ELSE.
        rs_item_pagamento-nota_fiscal_cnpj = ls_j_1bnfdoc-cgc.
      ENDIF.

      SORT lt_j_1bnfstx BY taxtyp subdivision.

      LOOP AT gt_gnre_item ASSIGNING <fs_s_gnre_item>.

        "Verifica se o imposto é de ICMS ou FCP
*        LOOP AT lt_j_1bnfstx TRANSPORTING NO FIELDS WHERE   taxtyp      = <fs_s_gnre_item>-taxtyp
*                                                      AND ( subdivision = '003'
*                                                      OR    subdivision = '004' ).
*          EXIT.
*        ENDLOOP.

        READ TABLE lt_j_1bnfstx WITH KEY taxtyp = <fs_s_gnre_item>-taxtyp subdivision = '003' BINARY SEARCH TRANSPORTING NO FIELDS.

        IF sy-subrc IS NOT INITIAL.
          READ TABLE lt_j_1bnfstx WITH KEY taxtyp = <fs_s_gnre_item>-taxtyp subdivision = '004' BINARY SEARCH TRANSPORTING NO FIELDS.
        ENDIF.

        "ICMS?
        IF sy-subrc IS NOT INITIAL.
          rs_item_pagamento-valor_icmsprincipal = rs_item_pagamento-valor_icmsprincipal + <fs_s_gnre_item>-taxval.
        ELSE.
          rs_item_pagamento-valor_fecpprincipal = rs_item_pagamento-valor_fecpprincipal + <fs_s_gnre_item>-taxval.
        ENDIF.

      ENDLOOP.

    ENDMETHOD.


    METHOD get_item_inp_proc_gnre_pe_2_00.

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_zgnre_config)
      ).

      LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>).

        IF sy-tabix = 1.

          APPEND INITIAL LINE TO et_item ASSIGNING FIELD-SYMBOL(<fs_s_out_item>).

          DATA(lv_data_vencimento) = get_data_vencimento( <fs_s_gnre_item> ).

          <fs_s_out_item> = VALUE #( receita                   = <fs_s_gnre_item>-receita
                                     produto                   = <fs_s_gnre_item>-produto
                                     referencia-mes            = lv_data_vencimento+4(2)
                                     referencia-ano            = lv_data_vencimento(4)
                                     referencia-periodo        = lt_zgnre_config[ regio = iv_regio taxtyp = <fs_s_gnre_item>-taxtyp ]-periodo
                                     documento_origem          = get_doc_origem( <fs_s_gnre_item> )
                                     campos_extras-campo_extra = get_campos_extra( <fs_s_gnre_item> )
                                     data_vencimento           = |{ lv_data_vencimento DATE = ISO }|
                                     convenio                  = |{ lt_zgnre_config[ regio = iv_regio taxtyp = <fs_s_gnre_item>-taxtyp ]-convenio }|
                                     contribuinte_destinatario = get_contrib_dest( <fs_s_gnre_item> )
                                     valor                     = VALUE #( ( content = |{ <fs_s_gnre_item>-taxval }|
                                                                              tipo    = get_tipo_valor( <fs_s_gnre_item>-taxtyp ) ) )
                                     detalhamento_receita      = get_config_det_receita( iv_taxtyp = <fs_s_gnre_item>-taxtyp
                                                                                           iv_regio  = iv_regio ) ).

        ELSE.

*          DATA: ls_valor TYPE zdados_gnre_2_00_1_retorno_doc.
          DATA: ls_valor TYPE ZCLSD_DT_DADOS_EMISSAO_VALOR.

          ls_valor = VALUE #( content = |{ <fs_s_gnre_item>-taxval }|
                              tipo    = get_tipo_valor( <fs_s_gnre_item>-taxtyp ) ).


          APPEND ls_valor TO <fs_s_out_item>-valor.

        ENDIF.

        ev_valorgnre = ev_valorgnre + <fs_s_gnre_item>-taxval.

      ENDLOOP.

      CONDENSE ev_valorgnre NO-GAPS.

    ENDMETHOD.


    METHOD get_interval_barcode_gnre.
      CALL FUNCTION 'NUMBER_GET_NEXT'
        EXPORTING
          nr_range_nr             = '01'
          object                  = 'ZGNRE_SP'
        IMPORTING
          number                  = rv_interval
        EXCEPTIONS
          interval_not_found      = 1
          number_range_not_intern = 2
          object_not_found        = 3
          quantity_is_0           = 4
          quantity_is_not_1       = 5
          interval_overflow       = 6
          buffer_overflow         = 7
          OTHERS                  = 8.

      IF sy-subrc <> 0.
        RETURN.
      ENDIF.

    ENDMETHOD.


    METHOD get_email_gnre_rj.
      SELECT SINGLE
             valor
        FROM ztsd_gnret015
        INTO rv_email
        WHERE parametro = zclsd_gnre_automacao=>gc_parametro-email_gnre_rj.
      TRANSLATE rv_email TO LOWER CASE.
    ENDMETHOD.


    METHOD get_doc_origem.

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_zgnre_config)
      ).

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
          es_j_1bnfe_active = DATA(ls_j_1bnfe_active)
      ).

      ASSIGN lt_zgnre_config[ regio  = ls_j_1bnfdoc-regio
                              taxtyp = is_gnre_item-taxtyp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).

      IF sy-subrc IS INITIAL AND <fs_s_zgnre_config>-tipo_doc_origem IS NOT INITIAL.

        rs_doc_origem-tipo    = <fs_s_zgnre_config>-tipo_doc_origem.

        IF <fs_s_zgnre_config>-tipo_doc_origem = 10.
          rs_doc_origem-content = ls_j_1bnfe_active-nfnum9.

        ELSE.

          CONCATENATE ls_j_1bnfe_active-regio
                      ls_j_1bnfe_active-nfyear
                      ls_j_1bnfe_active-nfmonth
                      ls_j_1bnfe_active-stcd1
                      ls_j_1bnfe_active-model
                      ls_j_1bnfe_active-serie
                      ls_j_1bnfe_active-nfnum9
                      ls_j_1bnfe_active-docnum9
                      ls_j_1bnfe_active-cdv
                 INTO rs_doc_origem-content.
        ENDIF.

      ENDIF.

    ENDMETHOD.


    METHOD get_data_vencimento.

      DATA: lv_wotnr           TYPE p,
            lv_data_vencimento TYPE sy-datum.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
      ).

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_zgnre_config)
      ).

      ASSIGN lt_zgnre_config[ regio  = ls_j_1bnfdoc-regio
                              taxtyp = is_gnre_item-taxtyp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).
      IF sy-subrc IS INITIAL AND <fs_s_zgnre_config>-enviar_vencimento IS NOT INITIAL.
        rv_data_vencimento = sy-datum.
      ENDIF.

    ENDMETHOD.


    METHOD get_contrib_dest.

      DATA: lv_stains_type TYPE dd01v-datatype.

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_zgnre_config)
      ).

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
      ).

      ASSIGN lt_zgnre_config[ regio  = ls_j_1bnfdoc-regio
                              taxtyp = is_gnre_item-taxtyp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).

      IF sy-subrc IS INITIAL AND <fs_s_zgnre_config>-enviar_destinatario IS NOT INITIAL.

        CALL FUNCTION 'NUMERIC_CHECK'
          EXPORTING
            string_in = ls_j_1bnfdoc-stains
          IMPORTING
            htype     = lv_stains_type.

        "Verifica se o campo está preenchido e não possui apenas números
        IF ls_j_1bnfdoc-stains IS NOT INITIAL AND lv_stains_type = 'NUMC'.
          rs_contrib_dest-identificacao-ie   = ls_j_1bnfdoc-stains.
        ELSEIF ls_j_1bnfdoc-cpf IS NOT INITIAL.
          rs_contrib_dest-identificacao-cpf  = ls_j_1bnfdoc-cpf.
        ELSE.
          rs_contrib_dest-identificacao-cnpj = ls_j_1bnfdoc-cgc.
        ENDIF.

        IF strlen( ls_j_1bnfdoc-txjcd ) >= 10.
          rs_contrib_dest-municipio  = substring( val = ls_j_1bnfdoc-txjcd off = strlen( ls_j_1bnfdoc-txjcd ) - 5 len = 5 ).
        ENDIF.

        rs_contrib_dest-razao_social = ls_j_1bnfdoc-name1.

      ENDIF.

    ENDMETHOD.


    METHOD get_config_det_receita.
*      SELECT SINGLE detalha_receita FROM ztsd_gnre_config
*      INTO rv_det_receita
*      WHERE regio = iv_regio
*        AND taxtyp = iv_taxtyp.

      SORT gt_gnre_config BY regio taxtyp.
      READ TABLE gt_gnre_config WITH KEY regio = iv_regio taxtyp = iv_taxtyp INTO DATA(lv_receita) BINARY SEARCH.

      rv_det_receita = lv_receita-detalha_receita.


    ENDMETHOD.


    METHOD get_campos_extra.

      go_automacao->get_config_data(
        IMPORTING
          et_ztsd_gnre_config = DATA(lt_ZTSD_GNRE_CONFIG)
      ).

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
          es_j_1bnfe_active = DATA(ls_j_1bnfe_active)
      ).

      ASSIGN lt_ZTSD_GNRE_CONFIG[ regio  = ls_j_1bnfdoc-regio
                              taxtyp = is_gnre_item-taxtyp ] TO FIELD-SYMBOL(<fs_s_ZTSD_GNRE_CONFIG>).

      IF sy-subrc IS INITIAL AND <fs_s_ZTSD_GNRE_CONFIG>-codigo_chaveacesso IS NOT INITIAL.

        APPEND INITIAL LINE TO rt_campos_extras ASSIGNING FIELD-SYMBOL(<fs_s_campo_extra>).

        <fs_s_campo_extra>-codigo = <fs_s_ZTSD_GNRE_CONFIG>-codigo_chaveacesso.

        CONCATENATE ls_j_1bnfe_active-regio
                    ls_j_1bnfe_active-nfyear
                    ls_j_1bnfe_active-nfmonth
                    ls_j_1bnfe_active-stcd1
                    ls_j_1bnfe_active-model
                    ls_j_1bnfe_active-serie
                    ls_j_1bnfe_active-nfnum9
                    ls_j_1bnfe_active-docnum9
                    ls_j_1bnfe_active-cdv
               INTO <fs_s_campo_extra>-valor.

      ENDIF.

    ENDMETHOD.


    METHOD get_boleto_interval.
      "Variáveis
      DATA: lv_count TYPE i.
      "Verificando se já existe o barcode gerado no exercício
      SELECT COUNT( * )
        FROM ztsd_gnret001
        INTO lv_count
        WHERE brcde_guia = iv_barcode.
      rv_interval = lv_count.
    ENDMETHOD.


    METHOD fill_soap_header_gnre_pe.

      TRY.
          DATA(lr_ws_header) = CAST if_wsprotocol_ws_header( io_proxy->get_protocol( if_wsprotocol=>ws_header ) ).

          DATA(lv_header_str) = |<root><gnreCabecMsg xmlns="http://www.gnre.pe.gov.br/wsdl/{ iv_servico }"><versaoDados xmlns="">{ iv_versao }</versaoDados></gnreCabecMsg></root>|.

          DATA(lr_ixml)          = cl_ixml=>create(  ).
          DATA(lr_ixml_document) = lr_ixml->create_document( ).
          DATA(lr_ixml_factory)  = lr_ixml->create_stream_factory( ).
          DATA(lr_ixml_stream)   = lr_ixml_factory->create_istream_string( lv_header_str ).
          DATA(lr_ixml_parser)   = lr_ixml->create_parser( stream_factory = lr_ixml_factory
                                                           istream        = lr_ixml_stream
                                                           document       = lr_ixml_document ).

          lr_ixml_parser->parse( ).

          DATA(lr_element) = CAST if_ixml_element( lr_ixml_document->get_root_element( )->get_first_child( ) ).

          WHILE NOT lr_element IS INITIAL.

            DATA(lv_name)      = lr_element->get_name( ).
            DATA(lv_namespace) = lr_element->get_namespace_uri( ).

            lr_ws_header->set_request_header(
              EXPORTING
                name            = lv_name
                namespace       = lv_namespace
                dom             = lr_element
            ).

            lr_element ?= lr_element->get_next( ).

          ENDWHILE.

        CATCH cx_ai_system_fault.

      ENDTRY.

    ENDMETHOD.


    METHOD fill_soap_header_dua_es.

      TRY.
          DATA(lr_ws_header) = CAST if_wsprotocol_ws_header( io_proxy->get_protocol( if_wsprotocol=>ws_header ) ).

          DATA(lv_header_str) = |<root><duae:DuaServiceHeader xmlns:duae="http://www.sefaz.es.gov.br/duae"><duae:versao>{ iv_versao }</duae:versao></duae:DuaServiceHeader></root>|.

          DATA(lr_ixml)          = cl_ixml=>create(  ).
          DATA(lr_ixml_document) = lr_ixml->create_document( ).
          DATA(lr_ixml_factory)  = lr_ixml->create_stream_factory( ).
          DATA(lr_ixml_stream)   = lr_ixml_factory->create_istream_string( lv_header_str ).
          DATA(lr_ixml_parser)   = lr_ixml->create_parser( stream_factory = lr_ixml_factory
                                                           istream        = lr_ixml_stream
                                                           document       = lr_ixml_document ).

          lr_ixml_parser->parse( ).

          DATA(lr_element) = CAST if_ixml_element( lr_ixml_document->get_root_element( )->get_first_child( ) ).

          WHILE NOT lr_element IS INITIAL.

            DATA(lv_name)      = lr_element->get_name( ).
            DATA(lv_namespace) = lr_element->get_namespace_uri( ).

            lr_ws_header->set_request_header(
              EXPORTING
                name            = lv_name
                namespace       = lv_namespace
                dom             = lr_element
            ).

            lr_element ?= lr_element->get_next( ).

          ENDWHILE.

        CATCH cx_ai_system_fault.

      ENDTRY.

    ENDMETHOD.


    METHOD fill_input_proc_gnre_pe_2_00.

      DATA: ls_parnad TYPE j_1binnad.

      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bnfnad-parid( |{ gs_gnre_header-bukrs }{ gs_gnre_header-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        ls_parnad-name1 = ''.
      ENDIF.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc = DATA(ls_j_1bnfdoc)
      ).

      get_item_inp_proc_gnre_pe_2_00(
        EXPORTING
          iv_regio = ls_j_1bnfdoc-regio
        IMPORTING
          et_item      = DATA(lt_item)
          ev_valorgnre = DATA(lv_valorgnre)

      ).

      "Atribui a data do pagamento, o valor do vencimento
      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_s_item>) WHERE data_vencimento IS NOT INITIAL.
        EXIT.
      ENDLOOP.

      IF sy-subrc IS INITIAL.
        DATA(lv_data_pagamento) = <fs_s_item>-data_vencimento.
      ENDIF.

      cs_input-mt_dados_emissao-TLOTE_GNRE-versao            = '2.00'.
      cs_input-mt_dados_emissao-TLOTE_GNRE-guias-tdados_gnre = VALUE #( ( versao                                   = '2.00'
                                                                          uf_favorecida                            = ls_j_1bnfdoc-regio
                                                                          tipo_gnre                                = COND #( WHEN lines( gt_gnre_item ) = 1 THEN '0' ELSE '2' )
                                                                          contribuinte_emitente-identificacao-cnpj = ls_parnad-cgc
                                                                          contribuinte_emitente-razao_social       = ls_parnad-name1
                                                                          contribuinte_emitente-endereco           = ls_parnad-stras
                                                                          contribuinte_emitente-municipio          = substring( val = ls_parnad-txjcd off = strlen( ls_parnad-txjcd ) - 5 len = 5 )
                                                                          contribuinte_emitente-uf                 = ls_parnad-regio
                                                                          itens_gnre-item                          = lt_item
                                                                          valor_gnre                               = lv_valorgnre
                                                                          data_pagamento                           = lv_data_pagamento
                                                                      ) ).

    ENDMETHOD.


    METHOD fill_branch_data_gnre_pe_1_00.

      DATA: lt_adrc       TYPE TABLE OF adrc,
            lv_addrnumber TYPE adrc-addrnumber.

      " Endereço Filial
      SELECT SINGLE adrnr FROM j_1bbranch
        INTO lv_addrnumber
        WHERE bukrs  = iv_bukrs
          AND branch = iv_branch.

      IF sy-subrc EQ 0.

        FREE lt_adrc.

        CALL FUNCTION 'ADDR_SELECT_ADRC_SINGLE'
          EXPORTING
            addrnumber = lv_addrnumber
          TABLES
            et_adrc    = lt_adrc
          EXCEPTIONS
            OTHERS     = 4.

        IF sy-subrc <> 0 OR lt_adrc[] IS INITIAL.
          RETURN.
        ENDIF.

        ASSIGN lt_adrc[ 1 ] TO FIELD-SYMBOL(<fs_s_adrc>).

        IF sy-subrc EQ 0.

          MOVE-CORRESPONDING <fs_s_adrc> TO cs_dadosguia.
          REPLACE '-' IN cs_dadosguia-post_code1 WITH space.
          CONDENSE cs_dadosguia-post_code1 NO-GAPS.
          " Códido do municipio emitente
          cs_dadosguia-city1 = <fs_s_adrc>-taxjurcode+5(5).
          " Data do documento
          cs_dadosguia-docdat = sy-datum.
          CLEAR cs_dadosguia-state_insc.
        ENDIF.
      ENDIF.
    ENDMETHOD.


    METHOD consult_gnre_rj.

      DATA: ls_input  TYPE zconsultar_dados,
            ls_parnad TYPE j_1binnad.

      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bnfnad-parid( |{ gs_gnre_header-bukrs }{ gs_gnre_header-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        ls_parnad-name1 = ''.
      ENDIF.

      rs_return-faedt = gs_gnre_header-faedt.

      TRY.
          DATA(lr_gnre_rj) = NEW zclsd_co_gnre_rj_gerar_doc_soa( ).

          ls_input-cnpj       = ls_parnad-cgc.
          rs_return-prot_guia =
          ls_input-id_sessao  = gs_gnre_header-prot_guia.

          lr_gnre_rj->consultar_dados(
            EXPORTING
              input              = ls_input
            IMPORTING
              output             = DATA(ls_output)
          ).

          rs_return-status_guia  = ls_output-consultar_dados_result-retorno-codigo_retorno.
          rs_return-desc_st_guia = ls_output-consultar_dados_result-retorno-mensagem_retorno.

          CONDENSE rs_return-status_guia NO-GAPS.

          CASE rs_return-status_guia.

            WHEN '0'. "SUCESSO

              "Obtêm os dados da guia gerada
              ASSIGN ls_output-consultar_dados_result-docs_retorno-documentos_retorno[ 1 ]
                  TO FIELD-SYMBOL(<fs_s_doc_retorno>).
              IF sy-subrc IS INITIAL.

                IF <fs_s_doc_retorno>-lista_codigo_barra IS INITIAL.
                  "Consulta não retornou o código de barras, aguardando consulta automática.
                  go_automacao->add_to_log( iv_docguia      = gs_gnre_header-docguia
                                            iv_step         = gs_gnre_header-step
                                            iv_status_guia  = '999'
                                            iv_desc_st_guia = TEXT-003 ).
                  RETURN.
                ENDIF.

                rs_return-num_guia   = <fs_s_doc_retorno>-nosso_numero_sefaz.
                rs_return-brcde_guia = <fs_s_doc_retorno>-lista_codigo_barra.
                rs_return-ldig_guia  = mount_ldig_guia_gnre_rj( rs_return-brcde_guia ).

              ELSE.
                "Consulta não retornou o código de barras, aguardando consulta automática.
                go_automacao->add_to_log( iv_docguia      = gs_gnre_header-docguia
                                          iv_step         = gs_gnre_header-step
                                          iv_status_guia  = '999'
                                          iv_desc_st_guia = TEXT-003 ).
                RETURN.
              ENDIF.

              GET TIME.

              "Atribui a data de criação da guia
              rs_return-new_credat = sy-datum.
              rs_return-new_cretim = sy-uzeit.
              rs_return-new_crenam = sy-uname.

              "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_criada
                                      iv_newdoc       = rs_return-num_guia
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia           ).

            WHEN OTHERS.

              "Etapa: Guia Rejeitada - Verificar Motivo
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_rejeitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia              ).

          ENDCASE.

        CATCH cx_ai_system_fault INTO DATA(lo_ref).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_na_consulta_lote
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

      ENDTRY.

    ENDMETHOD.


    METHOD consult_gnre_pe_2_00.

      DATA: ls_input TYPE zgnre_dados_msg3.
      DATA ls_output_pe TYPE zclsd_mt_dados_consulta1.
      DATA: lv_str_xstring TYPE xstring.

      "Verifica o ambiente de execução do serviço
      ls_input-tcons_lote_gnre-ambiente = get_tp_amb( ).

      rs_return-faedt                        = gs_gnre_header-faedt.
      rs_return-prot_guia                    =
      ls_input-tcons_lote_gnre-numero_recibo = gs_gnre_header-prot_guia.

      TRY.

          DATA(lv_char) = abap_false.
          IF lv_char EQ abap_true.

*            DATA(lr_gnre_consulta) = NEW zclsd_co_gnre_pe2_res_lote_soa( ).
*
*            fill_soap_header_gnre_pe( iv_versao  = '2.00'
*                                      iv_servico = 'GnreResultadoLote'
*                                      io_proxy   = lr_gnre_consulta    ).
*
*            lr_gnre_consulta->consultar(
*              EXPORTING
*                input              = ls_input
*              IMPORTING
*                output             = DATA(ls_output)
*            ).

          ENDIF.

          DATA(lr_gnre_consulta_pe) = NEW zclsd_co_si_enviar_dados_cons1( ).

          ls_output_pe-mt_dados_consulta-ambiente      = get_tp_amb( ).
          ls_output_pe-mt_dados_consulta-numero_recibo = gs_gnre_header-prot_guia.

          lr_gnre_consulta_pe->si_enviar_dados_consulta_out(
            EXPORTING
              output = ls_output_pe
            IMPORTING
              input  = DATA(ls_input_pe)
          ).

          CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
            EXPORTING
              text   = ls_input_pe-mt_dados_consulta_resp-gnre_dados_msg_resp
            IMPORTING
              buffer = lv_str_xstring.

          rs_return-status_guia  = get_value_from_xml_xpath( iv_expression = '//*:codigo'
                                                           iv_xml        = lv_str_xstring ).
          rs_return-desc_st_guia = get_value_from_xml_xpath( iv_expression = '//*:descricao'
                                                           iv_xml        = lv_str_xstring ).

          CASE rs_return-status_guia.

            WHEN '400'. "Lote Recebido. Aguardando processamento

              "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_solicitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN '401'. "Lote em Processamento

              "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_solicitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN '402'. "Lote processado com sucesso

              "Obtêm os dados da guia gerada
*              ASSIGN ls_output-tresult_lote_gnre-resultado-guia[ 1 ]
*                  TO FIELD-SYMBOL(<fs_s_guia>).
*              IF sy-subrc IS INITIAL.
              rs_return-num_guia   = get_value_from_xml_xpath( iv_expression = '//*:nossoNumero'
                                                               iv_xml        = lv_str_xstring ).
              rs_return-brcde_guia = get_value_from_xml_xpath( iv_expression = '//*:codigoBarras'
                                                               iv_xml        = lv_str_xstring ).
              rs_return-ldig_guia  = get_value_from_xml_xpath( iv_expression = '//*:linhaDigitavel'
                                                               iv_xml        = lv_str_xstring ).
*              ENDIF.

              GET TIME.

              "Atribui a data de criação da guia
              rs_return-new_credat = sy-datum.
              rs_return-new_cretim = sy-uzeit.
              rs_return-new_crenam = sy-uname.

              "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_criada
                                      iv_newdoc       = rs_return-num_guia
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia           ).

            WHEN '403'. "Processado com pendência

              "Obtêm o motivo
*              ASSIGN ls_output-tresult_lote_gnre-resultado-guia[ 1 ]-motivos_rejeicao-motivo[ 1 ]
*                  TO FIELD-SYMBOL(<fs_s_motivo>).
*              IF sy-subrc IS INITIAL.
              rs_return-status_guia  = get_value_from_xml_xpath( iv_expression = '//*:codigo'
                                                                 iv_xml        = lv_str_xstring ).
              rs_return-desc_st_guia = get_value_from_xml_xpath( iv_expression = '//*:descricao'
                                                                 iv_xml        = lv_str_xstring ).
*              ENDIF.

              "Etapa: Guia Rejeitada - Verificar Motivo
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_rejeitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia              ).

            WHEN '404'. "Erro no processamento do lote. Enviar o lote novamente.

              "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_solicitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia               ).

            WHEN OTHERS.

              "Etapa: Guia Rejeitada - Verificar Motivo
              go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                      iv_step         = go_automacao->gc_step-guia_rejeitada
                                      iv_status_guia  = rs_return-status_guia
                                      iv_desc_st_guia = rs_return-desc_st_guia              ).

          ENDCASE.

        CATCH cx_ai_system_fault INTO DATA(lo_ref).

          rs_return-status_guia  = '999'.
          rs_return-desc_st_guia = lo_ref->get_text( ).

          "Etapa: Erro Interno no Envio
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-erro_interno_na_consulta_lote
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia                     ).

      ENDTRY.

    ENDMETHOD.


    METHOD consult_gnre_pe_1_00.

      go_automacao->get_nf_data(
        IMPORTING
          es_j_1bnfdoc      = DATA(ls_j_1bnfdoc)
      ).

      consultar_lote_gnre_pe_1_00(
        EXPORTING
          is_consultalote = VALUE #( recibo     = gs_gnre_header-prot_guia
                                     dest_regio = ls_j_1bnfdoc-regio )    " Consulta de Lote
        IMPORTING
          es_retornolote  = DATA(ls_retornolote)    " Retorno da Consulta do Lote
        RECEIVING
          rs_retorno      = DATA(ls_retorno)    " Parâmetro de retorno
      ).

      rs_return-prot_guia    = gs_gnre_header-prot_guia.
      rs_return-ident_guia   = gs_gnre_header-ident_guia.
      rs_return-faedt        = ls_retornolote-data_vencimento.
      rs_return-num_guia     = ls_retornolote-num_controle.
      rs_return-brcde_guia   = ls_retornolote-codigo_barra.
      rs_return-ldig_guia    = ls_retornolote-linha_digitavel.
      rs_return-status_guia  = ls_retornolote-codigo.
      rs_return-desc_st_guia = ls_retornolote-descricao.

      CASE rs_return-status_guia.

        WHEN '400'. "Lote Recebido. Aguardando processamento

          "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_solicitada
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

        WHEN '401'. "Lote em Processamento

          "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_solicitada
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

        WHEN '402'. "Lote processado com sucesso

          GET TIME.

          "Atribui a data de criação da guia
          rs_return-new_credat = sy-datum.
          rs_return-new_cretim = sy-uzeit.
          rs_return-new_crenam = sy-uname.

          "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_criada
                                  iv_newdoc       = rs_return-num_guia
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

        WHEN '403'. "Processado com pendência

          "Armazena o motivo do erro
          rs_return-status_guia  = ls_retornolote-resultado+35(3).
          rs_return-desc_st_guia = ls_retornolote-resultado+38.

          "Etapa: Guia Rejeitada - Verificar Motivo
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_rejeitada
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

        WHEN '404'. "Erro no processamento do lote. Enviar o lote novamente.

          "Etapa: Guia Solicitada - Aguardando Retorno SEFAZ
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_solicitada
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

        WHEN OTHERS.

          IF rs_return-status_guia IS INITIAL.
            IF ls_retorno-code = '000'.
              rs_return-desc_st_guia = ls_retorno-message.
            ELSE.
              rs_return-status_guia  = ls_retorno-code.
              rs_return-desc_st_guia = ls_retorno-message.
            ENDIF.
          ENDIF.

          "Etapa: Guia Rejeitada - Verificar Motivo
          go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                  iv_step         = go_automacao->gc_step-guia_rejeitada
                                  iv_status_guia  = rs_return-status_guia
                                  iv_desc_st_guia = rs_return-desc_st_guia ).

      ENDCASE.

    ENDMETHOD.


    METHOD consultar_lote_gnre_pe_1_00.

      DATA: lo_gnre_ret_pe TYPE REF TO zclsd_co_gnre_pe1_res_lote_soa.

      TRY.

          lo_gnre_ret_pe = NEW #( ).

          fill_soap_header_gnre_pe( iv_versao  = '1.00'
                                    iv_servico = 'GnreResultadoLote'
                                    io_proxy   = lo_gnre_ret_pe     ).

        CATCH cx_ai_system_fault INTO DATA(lo_ref).
          rs_retorno-type = 'E'.
          rs_retorno-message = lo_ref->get_text( ).
          RETURN.

      ENDTRY.

      DATA: ls_soap_in  TYPE zgnre_dados_msg1,
            ls_soap_out TYPE zgnre_resposta_msg.

      ls_soap_in-tcons_lote_gnre-ambiente = get_tp_amb( ).
      ls_soap_in-tcons_lote_gnre-numero_recibo = is_consultalote-recibo.

      TRY.
          lo_gnre_ret_pe->consultar( EXPORTING input  = ls_soap_in
                                      IMPORTING output = ls_soap_out ).

        CATCH cx_ai_system_fault  INTO DATA(lo_ref_fault).
          rs_retorno-type = 'E'.
          rs_retorno-message = lo_ref_fault->get_text( ).
          RETURN.
      ENDTRY.

      DATA: lv_result TYPE i.

      es_retornolote-codigo = ls_soap_out-tresult_lote_gnre-situacao_process-codigo.
      es_retornolote-descricao = ls_soap_out-tresult_lote_gnre-situacao_process-descricao.


      IF es_retornolote-codigo = '402'.
        lv_result = find( val = ls_soap_out-tresult_lote_gnre-resultado regex = |\n1| ) + 1.

        DATA: lv_linha TYPE string.
        lv_linha = ls_soap_out-tresult_lote_gnre-resultado+lv_result.
        es_retornolote-resultado = lv_linha.
        es_retornolote-codigo_barra = lv_linha+1026(44).   " 1027 1070 44
        es_retornolote-linha_digitavel = lv_linha+978(48). " 979 1026 48
        DATA(lv_strdata) = lv_linha+892(8).                 " 893 900 8
        es_retornolote-data_vencimento = lv_strdata+4 && lv_strdata+2(2) && lv_strdata(2).
        es_retornolote-num_controle = lv_linha+1071(16).   " 1072 1087 16

        rs_retorno-type = 'S'.
        rs_retorno-message = TEXT-003. "'Processado com sucesso'. " es_retornolote-descricao.
      ELSE.
        lv_result = find( val = ls_soap_out-tresult_lote_gnre-resultado regex = |\n2| ) + 1.

        es_retornolote-resultado = ls_soap_out-tresult_lote_gnre-resultado+lv_result.

        rs_retorno-type = 'E'.
        rs_retorno-message = TEXT-001. "'Erro no processamento'.  " es_retornolote-descricao.
      ENDIF.

    ENDMETHOD.


    METHOD constructor.
      gv_docguia   = iv_docguia  .
      go_automacao = io_automacao.
      go_automacao->get_gnre_data(
        IMPORTING
          et_header = DATA(lt_gnre_header)
          et_item   = DATA(lt_gnre_item)
      ).
      TRY.
          gerar_dados_gnre_config( ).
          gs_gnre_header = lt_gnre_header[ docguia = gv_docguia ].
          gt_gnre_item = VALUE #( FOR <fs_s_item> IN lt_gnre_item WHERE ( docguia = gv_docguia )
                                    ( <fs_s_item> ) ).
          update_item_config( CHANGING cs_gnre_item = gt_gnre_item ).
        CATCH cx_sy_itab_line_not_found.
          RETURN.
      ENDTRY.
    ENDMETHOD.


  method GERAR_DADOS_GNRE_CONFIG.
    SELECT * FROM ztsd_gnre_config INTO TABLE gt_gnre_config.
  endmethod.


  METHOD converte_xtring_to_string.

    IF go_xml_helper IS INITIAL.
      CREATE OBJECT go_xml_helper.
    ENDIF.
    "Converter assinatura Xtring para String - UTF-8
    go_xml_helper->utf8_2_string(
      EXPORTING
        if_input           =  iv_xstring " Input Value
      RECEIVING
        ef_output          =  ev_string  " Output Value
      EXCEPTIONS
        conversion_error   = 1  " UTF-8 conversion failed
        createobject_error = 2  " Internal error occurred during creation of object
        OTHERS             = 3
    ).

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD integrate_dua_es_pi.

    DATA: ls_emissao TYPE zdua_emissao.
    DATA: ls_input TYPE zclsd_mt_dados_emissao.
    DATA: ls_output TYPE zclsd_mt_dados_emissao_resp.
    DATA: lv_xml_result_sig TYPE string.
    DATA: lv_str_xstring TYPE xstring.

    go_automacao->get_nf_data(
      IMPORTING
        es_j_1bnfdoc      = DATA(ls_j_1bnfdoc)
    ).

    TRY.

        DATA(lr_dua_es) = NEW zclsd_co_si_enviar_dados_emiss( ).


        DATA(lv_vlrtot_conv) = CONV char15( gs_gnre_header-vlrtot ).
        REPLACE ALL OCCURRENCES OF '.' IN lv_vlrtot_conv WITH ''.
        CONDENSE lv_vlrtot_conv NO-GAPS.

        SHIFT lv_vlrtot_conv LEFT DELETING LEADING '0'.
        CONDENSE lv_vlrtot_conv NO-GAPS.

        DATA(ls_emis_dua) = VALUE zssd_gnree009( tp_amb   = get_tp_amb( )
                                             cnpj_org = '27080571000130'
                                             cnpj_pes = COND #( WHEN ls_j_1bnfdoc-cgc <> '00000000000000'
                                                                THEN ls_j_1bnfdoc-cgc
                                                                ELSE ls_j_1bnfdoc-cpf                     )
                                             c_area   = '5'
                                             x_inf    = |Recolhimento referente à NFe { ls_j_1bnfdoc-nfenum } { ls_j_1bnfdoc-series }|
                                             v_rec    = lv_vlrtot_conv
                                             x_ide    = ls_j_1bnfdoc-name1 ).


        "Obtêm o De/Para dos códigos de município DUA ES
        SELECT SINGLE
               cmun_es
          FROM ztsd_gnret018
          INTO ls_emis_dua-c_mun
          WHERE txjcd   =  ls_j_1bnfdoc-txjcd
            AND cmun_es <> space.

        IF sy-subrc IS NOT INITIAL AND strlen( ls_j_1bnfdoc-txjcd ) >= 10.

          "Preenche o código do município, caso não seja encontrado
          ls_emis_dua-c_mun = substring( val = ls_j_1bnfdoc-txjcd off = strlen( ls_j_1bnfdoc-txjcd ) - 5 len = 5 ).

        ENDIF.

        "Preenche o código da receita e data de vencimento
        ASSIGN gt_gnre_item[ docguia = gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_item>).
        IF sy-subrc IS INITIAL.
          DATA(lv_data_vencimento) = get_data_vencimento( <fs_s_gnre_item> ).
          DATA(lv_data_vencimento_conv) = |{ lv_data_vencimento DATE = ISO }|.

          ls_emis_dua-c_serv = <fs_s_gnre_item>-receita.

          IF lv_data_vencimento IS NOT INITIAL.
            ls_emis_dua-d_ref = lv_data_vencimento_conv(7).
            ls_emis_dua-d_ven = lv_data_vencimento_conv(10).
            ls_emis_dua-d_pag = lv_data_vencimento_conv(10).
          ENDIF.

        ENDIF.

        CALL TRANSFORMATION ztr_gnre_dua_es_request
          SOURCE emisdua = ls_emis_dua
          RESULT XML ls_emissao-dua_dados_msg
          OPTIONS xml_header = 'no'.

        me->converte_xtring_to_string(
          EXPORTING
            iv_xstring   = ls_emissao-dua_dados_msg
          IMPORTING
            ev_string    = lv_xml_result_sig
        ).

*        ls_input-mt_dados_emissao-dua_dados_msg = lv_xml_result_sig.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-tp_amb   = get_tp_amb( ).
*        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-cnpj_emi = COND #( WHEN ls_j_1bnfdoc-cgc <> '00000000000000'
*                                                                            THEN ls_j_1bnfdoc-cgc
*                                                                            ELSE ls_j_1bnfdoc-cpf                     ).
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-cnpj_emi = ls_j_1bnfdoc-cnpj_bupla.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-cnpj_org = '27080571000130'.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-c_area   = '5'.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-c_serv   = <fs_s_gnre_item>-receita.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-cnpj_pes = ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-cnpj_emi.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-d_ref    = lv_data_vencimento_conv(7).
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-d_ven    = lv_data_vencimento_conv(10).
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-d_pag    = lv_data_vencimento_conv(10).

*        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-c_mun    = substring( val = ls_j_1bnfdoc-txjcd off = strlen( ls_j_1bnfdoc-txjcd ) - 5 len = 5 ).
        "Obtêm o De/Para dos códigos de município DUA ES
        SELECT SINGLE
               cmun_es
          FROM ztsd_gnret018
          INTO ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-c_mun
          WHERE txjcd   =  ls_j_1bnfdoc-txjcd
            AND cmun_es <> space.

        IF sy-subrc IS NOT INITIAL AND strlen( ls_j_1bnfdoc-txjcd ) >= 10.

          "Preenche o código do município, caso não seja encontrado
          ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-c_mun = substring( val = ls_j_1bnfdoc-txjcd off = strlen( ls_j_1bnfdoc-txjcd ) - 5 len = 5 ).

        ENDIF.

        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-x_inf    = |Recolhimento referente à NFe { ls_j_1bnfdoc-nfenum } { ls_j_1bnfdoc-series }|.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-v_rec    = lv_vlrtot_conv.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-qtde     = '1'.
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-x_ide    = ls_j_1bnfdoc-name1(30).
        ls_input-mt_dados_emissao-dua_dados_msg-emis_dua-versao   = '1.01'.

        lr_dua_es->si_enviar_dados_emissao_out(
          EXPORTING
            output = ls_input
          IMPORTING
            input = ls_output
        ).

        CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
          EXPORTING
            text   = ls_output-mt_dados_emissao_resp-dua_dados_msg_resp
          IMPORTING
            buffer = lv_str_xstring.

        rs_return-faedt        = lv_data_vencimento.
        rs_return-status_guia  = get_value_from_xml_xpath( iv_expression = '//*:cStat'
                                                           iv_xml        = lv_str_xstring ).
        rs_return-desc_st_guia = get_value_from_xml_xpath( iv_expression = '//*:xMotivo'
                                                           iv_xml        = lv_str_xstring ).

        CASE rs_return-status_guia.

          WHEN '105'. "Dua emitido

            rs_return-num_guia  = get_value_from_xml_xpath( iv_expression = '//*:nDua'
                                                            iv_xml        = lv_str_xstring ).
            rs_return-ldig_guia = get_value_from_xml_xpath( iv_expression = '//*:nBar'
                                                            iv_xml        = lv_str_xstring ).

            "Monta o código de barras
            IF rs_return-ldig_guia IS NOT INITIAL.
              rs_return-brcde_guia = rs_return-ldig_guia(11)    && rs_return-ldig_guia+12(11) &&
                                     rs_return-ldig_guia+24(11) && rs_return-ldig_guia+36(11).
            ENDIF.

            GET TIME.

            "Atribui a data de criação da guia
            rs_return-new_credat = sy-datum.
            rs_return-new_cretim = sy-uzeit.
            rs_return-new_crenam = sy-uname.

            "Etapa: Guia Criada - Aguardando Envio ao VAN FINNET
            go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                    iv_step         = go_automacao->gc_step-guia_criada
                                    iv_newdoc       = rs_return-num_guia
                                    iv_status_guia  = rs_return-status_guia
                                    iv_desc_st_guia = rs_return-desc_st_guia               ).

          WHEN OTHERS.

            "Etapa: Rejeição no Envio do Lote
            go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                    iv_step         = go_automacao->gc_step-rejeicao_no_envio_do_lote
                                    iv_status_guia  = rs_return-status_guia
                                    iv_desc_st_guia = rs_return-desc_st_guia               ).

        ENDCASE.

      CATCH cx_transformation_error INTO DATA(lo_ref).

        rs_return-status_guia  = '999'.
        rs_return-desc_st_guia = lo_ref->get_text( ).

        "Etapa: Erro Interno no Envio
        go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                iv_status_guia  = rs_return-status_guia
                                iv_desc_st_guia = rs_return-desc_st_guia                     ).

      CATCH cx_ai_system_fault INTO DATA(lo_ref_fault).

        rs_return-status_guia  = '999'.
        rs_return-desc_st_guia = lo_ref_fault->get_text( ).

        "Etapa: Erro Interno no Envio
        go_automacao->set_step( iv_docguia      = gs_gnre_header-docguia
                                iv_step         = go_automacao->gc_step-erro_interno_no_envio
                                iv_status_guia  = rs_return-status_guia
                                iv_desc_st_guia = rs_return-desc_st_guia                     ).

    ENDTRY.


  ENDMETHOD.
ENDCLASS.
