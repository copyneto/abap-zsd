class ZCLSD_GNRE_AUTOMACAO definition
  public
  final
  create public .

public section.

  types:
    ty_t_gnre_header   TYPE TABLE OF ztsd_gnret001 WITH DEFAULT KEY .
  types:
    ty_t_gnre_item     TYPE TABLE OF ztsd_gnret002 WITH DEFAULT KEY .
  types:
    ty_t_gnre_log      TYPE TABLE OF ztsd_gnret003 WITH DEFAULT KEY .
  types:
    ty_t_gnre_calc_log TYPE TABLE OF ztsd_gnret004 WITH DEFAULT KEY .
  types:
    ty_t_zgnre_config  TYPE TABLE OF ztsd_gnre_config WITH DEFAULT KEY .
  types:
    ty_r_docguia       TYPE RANGE OF ze_gnre_docguia .
  types:
    ty_t_step          TYPE TABLE OF ztsd_gnret001-step WITH DEFAULT KEY .
  types:
    ty_r_step          TYPE RANGE OF ztsd_gnret001-step .
  types:
    BEGIN OF ty_s_j_1bnfdoc,
        docnum       TYPE j_1bnfdoc-docnum,
        direct       TYPE j_1bnfdoc-direct,
        docdat       TYPE j_1bnfdoc-docdat,
        bukrs        TYPE j_1bnfdoc-bukrs,
        branch       TYPE j_1bnfdoc-branch,
        nfesrv       TYPE j_1bnfdoc-nfesrv,
        regio        TYPE j_1bnfdoc-regio,
        ind_iedest   TYPE j_1bnfdoc-ind_iedest,
        ind_final    TYPE j_1bnfdoc-ind_final,
        id_dest      TYPE j_1bnfdoc-id_dest,
        cgc          TYPE j_1bnfdoc-cgc,
        cpf          TYPE j_1bnfdoc-cpf,
        name1        TYPE j_1bnfdoc-name1,
        txjcd        TYPE j_1bnfdoc-txjcd,
        cnpj_bupla   TYPE j_1bnfdoc-cnpj_bupla,
        ie_bupla     TYPE j_1bnfdoc-ie_bupla,
        nfenum       TYPE j_1bnfdoc-nfenum,
        series       TYPE j_1bnfdoc-series,
        authdate     TYPE j_1bnfdoc-authdate,
        nftype       TYPE j_1bnfdoc-nftype,
        parvw        TYPE j_1bnfdoc-parvw,
        parid        TYPE j_1bnfdoc-parid,
        parxcpdk     TYPE j_1bnfdoc-parxcpdk,
        partyp       TYPE j_1bnfdoc-partyp,
        printd       TYPE j_1bnfdoc-printd,
        ort01        TYPE j_1bnfdoc-ort01,
        authtime     TYPE j_1bnfdoc-authtime,
        stains       TYPE j_1bnfdoc-stains,
* LSCHEPP - SD - 8000007642 - GNRE DUA-ES, Codigo de barras incorreto - 29.05.2023 Início
        waerk        TYPE j_1bnfdoc-waerk,
* LSCHEPP - SD - 8000007642 - GNRE DUA-ES, Codigo de barras incorreto - 29.05.2023 Fim
        regio_branch TYPE adrc-region,
      END OF ty_s_j_1bnfdoc .
  types:
    BEGIN OF ty_s_j_1bnflin,
        docnum TYPE j_1bnflin-docnum,
        itmnum TYPE j_1bnflin-itmnum,
        matnr  TYPE j_1bnflin-matnr,
        matorg TYPE j_1bnflin-matorg,
        taxsit TYPE j_1bnflin-taxsit,
        matkl  TYPE j_1bnflin-matkl,
        werks  TYPE j_1bnflin-werks,
        nfnet  TYPE j_1bnflin-nfnet,
        nfnett TYPE j_1bnflin-nfnett,
        menge  TYPE j_1bnflin-menge,
        meins  TYPE j_1bnflin-meins,
      END OF ty_s_j_1bnflin .
  types:
    ty_t_j_1bnflin TYPE TABLE OF ty_s_j_1bnflin WITH DEFAULT KEY .
  types:
    BEGIN OF ty_s_j_1bnfstx,
        docnum      TYPE j_1bnfstx-docnum,
        itmnum      TYPE j_1bnfstx-itmnum,
        taxtyp      TYPE j_1bnfstx-taxtyp,
        base        TYPE j_1bnfstx-base,
        rate        TYPE j_1bnfstx-rate,
        taxval      TYPE j_1bnfstx-taxval,
        excbas      TYPE j_1bnfstx-excbas,
        othbas      TYPE j_1bnfstx-othbas,
        taxgrp      TYPE j_1bnfstx-taxgrp,
        subdivision TYPE j_1baj-subdivision,
      END OF ty_s_j_1bnfstx .
  types:
    ty_t_j_1bnfstx TYPE TABLE OF ty_s_j_1bnfstx WITH DEFAULT KEY .
  types:
    BEGIN OF ty_s_steps_status,
        from TYPE ze_gnre_step,
        to   TYPE ze_gnre_step,
      END OF ty_s_steps_status .
  types:
    ty_t_steps_status TYPE TABLE OF ty_s_steps_status WITH DEFAULT KEY .
  types:
    BEGIN OF ty_s_to_delete,
        docnum  TYPE ztsd_gnret001-docnum,
        docguia TYPE ztsd_gnret001-docguia,
      END OF ty_s_to_delete .
  types:
    ty_t_to_delete TYPE TABLE OF ty_s_to_delete WITH DEFAULT KEY .
  types:
    BEGIN OF ty_s_step_print,
        step   TYPE ztsd_gnret010-step_from,
        opcoes TYPE ztsd_gnret010-opcoes,
      END OF ty_s_step_print .
  types:
    ty_t_step_print TYPE TABLE OF ty_s_step_print WITH DEFAULT KEY .
  types:
    BEGIN OF ty_s_j_1btxst3,
        gruop  TYPE j_1btxst3-gruop,
        value  TYPE j_1btxst3-value,
        value2 TYPE j_1btxst3-value2,
        value3 TYPE j_1btxst3-value3,
      END OF ty_s_j_1btxst3 .
  types:
    ty_t_j_1btxst3 TYPE TABLE OF ty_s_j_1btxst3 WITH DEFAULT KEY .

  constants:
    BEGIN OF gc_tpprocess,
        automatico TYPE ze_gnre_tpprocess VALUE '1',
        manual     TYPE ze_gnre_tpprocess VALUE '2',
      END OF gc_tpprocess .
  constants:
    BEGIN OF gc_modo_exec,
        manual     TYPE ze_gnre_modo_exec VALUE '1',
        automatico TYPE ze_gnre_modo_exec VALUE '2',
        desativado TYPE ze_gnre_modo_exec VALUE '3',
      END OF gc_modo_exec .
  constants:
    BEGIN OF gc_price,
        difal  TYPE ze_gnre_parametro VALUE 'B',    "Valor máximo DIFAL
        st     TYPE ze_gnre_parametro VALUE 'C',    "Valor máximo ST
        email  TYPE ze_gnre_parametro VALUE 'D',    "E-mail para validar valor de guia
        fdifal TYPE ze_gnre_parametro VALUE 'E',    "Valor máximo Frete DIFAL
        fst    TYPE ze_gnre_parametro VALUE 'F',    "Valor máximo Frete ST
      END OF gc_price .
  constants:
    BEGIN OF gc_step,
        aguardando_envio               TYPE ze_gnre_step VALUE '000',    "Aguardando Envio
        guia_solicitada                TYPE ze_gnre_step VALUE '001',    "Guia Solicitada - Aguardando Retorno SEFAZ
        operacao_manual                TYPE ze_gnre_step VALUE '002',    "Operação Manual - Incluir Guia Manual
        aguardando_preenchimento_dados TYPE ze_gnre_step VALUE '003',    "Aguardando Preenchimento dos Dados
        operacao_c_insc_substituto     TYPE ze_gnre_step VALUE '091',    "Operação Com Inscrição Substituto (NIF Regional)
        operacao_c_somatorio_trib_zero TYPE ze_gnre_step VALUE '092',    "Operação com Somatório dos Tributos Igual Zero
        guia_criada                    TYPE ze_gnre_step VALUE '101',    "Guia Criada - Aguardando Criação do Doc. FI
        documento_criado               TYPE ze_gnre_step VALUE '102',    "Doc. FI Criado - Aguardando Preenchimento do Código de Barras
        cod_barras_preenchido          TYPE ze_gnre_step VALUE '103',    "Código de Barras preenchido - Aguardando Envio ao VAN FINNET
        documento_enviado              TYPE ze_gnre_step VALUE '104',    "Doc. FI Enviado ao VAN FINNET
        pagamento_enviado              TYPE ze_gnre_step VALUE '201',    "Pagamento Enviado - Aguardando Retorno Bancário
        pagamento_autenticado          TYPE ze_gnre_step VALUE '301',    "Pagamento Autenticado
        pagamento_manual_realizado     TYPE ze_gnre_step VALUE '302',    "Pagamento Manual Realizado
        documentos_impressos_c_sucesso TYPE ze_gnre_step VALUE '400',    "Todos os Documentos Impressos Com Sucesso
        nfe_cancelada                  TYPE ze_gnre_step VALUE '500',    "NF-e Cancelada
        guia_vencida                   TYPE ze_gnre_step VALUE '501',    "Guia Vencida
        guia_inutilizada_manualmente   TYPE ze_gnre_step VALUE '502',    "Guia Inutilizada Manualmente
        cnpj_nao_habilitado_para_uso   TYPE ze_gnre_step VALUE 'E01',    "CNPJ Não Habilitado Para Uso do Serviço
        integracao_auto_n_implementada TYPE ze_gnre_step VALUE 'E02',    "Integração Automática Não Implementada - Incluir Guia Manual
        guia_valor_muito_alto          TYPE ze_gnre_step VALUE 'E03',    "Guia com Valor Muito Alto
        impossivel_ident_tipo_de_guia  TYPE ze_gnre_step VALUE 'E04',    "Impossível Identificar Tipo de Guia
        integracao_desativada_manual   TYPE ze_gnre_step VALUE 'E05',    "Integração Desativada Manualmente
        impossivel_ident_cod_receita   TYPE ze_gnre_step VALUE 'E06',    "Impossível Identificar Código de Receita
        erro_interno_no_envio          TYPE ze_gnre_step VALUE 'E07',    "Erro Interno no Envio
        rejeicao_no_envio_do_lote      TYPE ze_gnre_step VALUE 'E08',    "Rejeição no Envio do Lote
        erro_ao_converter_um_pauta     TYPE ze_gnre_step VALUE 'E09',    "Erro ao converter unidade de medida - Pauta ICMS
        impossivel_ident_fornecedor_cr TYPE ze_gnre_step VALUE 'E10',    "Impossível Identificar Fornecedor e/ou Conta do Razão
        guia_rejeitada                 TYPE ze_gnre_step VALUE 'E11',    "Guia Rejeitada - Verificar Motivo
        erro_interno_na_consulta_lote  TYPE ze_gnre_step VALUE 'E13',    "Erro Interno na Consulta do Lote
        erro_ao_gerar_o_documento_fi   TYPE ze_gnre_step VALUE 'E14',    "Erro ao Gerar o Documento Financeiro
        erro_ao_incluir_codigo_barras  TYPE ze_gnre_step VALUE 'E15',    "Erro ao Incluir o Código de Barras
        erro_ao_gerar_ciclo_pagamento  TYPE ze_gnre_step VALUE 'E16',    "Erro ao gerar o ciclo de pagamento - Verificar variante banco empresa
        erro_no_ciclo_de_pagamento     TYPE ze_gnre_step VALUE 'E17',    "Erro no Ciclo de Pagamento - Verificar F110
        pagamento_rejeitado            TYPE ze_gnre_step VALUE 'E21',    "Pagamento Rejeitado - Verificar status no VAN FINNET
      END OF gc_step .
  constants:
    BEGIN OF gc_tpguia,
        gnre_pe_1_00 TYPE ze_gnre_tpguia VALUE '01',
        gnre_pe_2_00 TYPE ze_gnre_tpguia VALUE '02',
        gnre_sp      TYPE ze_gnre_tpguia VALUE '03',
        gnre_rj      TYPE ze_gnre_tpguia VALUE '04',
        darj_rj      TYPE ze_gnre_tpguia VALUE '05',
        dua_es       TYPE ze_gnre_tpguia VALUE '06',
        dar_df       TYPE ze_gnre_tpguia VALUE '07',
        dare_to      TYPE ze_gnre_tpguia VALUE '08',
      END OF gc_tpguia .
  constants:
    BEGIN OF gc_smartforms,
        gnre_pe TYPE tdsfname VALUE 'ZSFSD_GNRE_PE',
        gnre_rj TYPE tdsfname VALUE 'ZSFSD_GNRE_RJ',
        gnre_sp TYPE tdsfname VALUE 'ZSFSD_GNRE_SP',
        dua_es  TYPE tdsfname VALUE 'ZSFSD_DUA_ES',
      END OF gc_smartforms .
  constants:
    BEGIN OF gc_acao,
        reprocessar         TYPE ze_gnre_acao VALUE 'R',
        imprimir            TYPE ze_gnre_acao VALUE 'I',
        pagamento_manual    TYPE ze_gnre_acao VALUE 'P',
        incluir_guia_manual TYPE ze_gnre_acao VALUE 'M',
        inutilizar_guia     TYPE ze_gnre_acao VALUE 'N',
      END OF gc_acao .
  constants:
    BEGIN OF gc_acao_at,
        cancelamento_nota TYPE ze_gnre_acao_at VALUE 'C',
        job               TYPE ze_gnre_acao_at VALUE 'J',
      END OF gc_acao_at .
  constants:
    BEGIN OF gc_parametro,
        email_gnre_rj      TYPE ze_gnre_parametro VALUE '1',
        tipo_de_documento  TYPE ze_gnre_parametro VALUE '2',
        texto_cabecalho    TYPE ze_gnre_parametro VALUE '3',
        condicao_pagamento TYPE ze_gnre_parametro VALUE '4',
        forma_pagamento    TYPE ze_gnre_parametro VALUE '5',
        atribuicao         TYPE ze_gnre_parametro VALUE '6',
        centro_de_lucro    TYPE ze_gnre_parametro VALUE '7',
        segmento           TYPE ze_gnre_parametro VALUE '8',
        tipo_de_ambiente   TYPE ze_gnre_parametro VALUE '9',
        tempo_maximo_f110  TYPE ze_gnre_parametro VALUE 'A',
      END OF gc_parametro .
  constants:
    BEGIN OF gc_taxtyp_zsub,
        icms TYPE j_1bnfstx-taxtyp VALUE 'ICS3',
        fcp  TYPE j_1bnfstx-taxtyp VALUE 'ICFP',
      END OF gc_taxtyp_zsub .

  class-methods CREATE_START_JOB
    importing
      !IV_DOCNUM type ZTSD_GNRET001-DOCNUM
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA optional
      !IV_USERNAME type SY-UNAME default SY-UNAME
      !IV_DELAY type ABAP_BOOL default ABAP_TRUE
    raising
      ZCXSD_GNRE_AUTOMACAO .
  class-methods DEQUEUE_DOCNUM_CANCEL
    importing
      !IV_DOCNUM type ZTSD_GNRET001-DOCNUM .
  class-methods ENQUEUE_DOCNUM_CANCEL
    importing
      !IV_DOCNUM type ZTSD_GNRET001-DOCNUM .
  class-methods GET_ICON_FROM_STEP
    importing
      !IV_STEP type ZTSD_GNRET001-STEP
    returning
      value(RV_ICON) type ICON-ID .
  class-methods GET_STEPS_DISABLE_GUIA
    returning
      value(RT_STEPS) type TY_T_STEP .
  class-methods GET_STEPS_GUIA_MANUAL
    returning
      value(RT_STEPS) type TY_T_STEP .
  class-methods GET_STEPS_MANUAL_PAYMENT
    returning
      value(RT_STEPS) type TY_T_STEP .
  class-methods GET_STEPS_PRINT
    returning
      value(RT_STEPS) type TY_T_STEP_PRINT .
  class-methods GET_STEPS_REPROCESS
    returning
      value(RT_STEPS_REPROCESS) type TY_T_STEPS_STATUS .
  methods ADD_GUIA_COMPL
    importing
      !IV_TAXTYP_ICMS type ZE_GNRE_TAXTYP_ICMS optional
      !IV_TAXVAL_ICMS type ZE_GNRE_TAXVAL_ICMS optional
      !IV_TAXTYP_FCP type ZE_GNRE_TAXTYP_FCP optional
      !IV_TAXVAL_FCP type ZE_GNRE_TAXVAL_FCP optional
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods ADD_GUIA_MANUAL
    importing
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA
      !IV_FAEDT type ZTSD_GNRET001-FAEDT
      !IV_NUM_GUIA type ZTSD_GNRET001-NUM_GUIA
      !IV_LDIG_GUIA type ZTSD_GNRET001-LDIG_GUIA
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods ADD_MANUAL_PAYMENT
    importing
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA
      !IV_CODAUT type ZTSD_GNRET001-CODAUT_GUIA
      !IV_DTPGTO type ZTSD_GNRET001-DTPGTO optional
      !IV_VLRPAGO type ZTSD_GNRET001-VLRPAGO optional
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods ADD_TO_LOG
    importing
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA
      !IV_STEP type ZTSD_GNRET001-STEP
      !IV_NEWDOC type ZTSD_GNRET003-NEWDOC optional
      !IV_STATUS_GUIA type ZTSD_GNRET003-STATUS_GUIA optional
      !IV_DESC_ST_GUIA type ZTSD_GNRET003-DESC_ST_GUIA optional .
  methods CONSTRUCTOR
    importing
      !IV_DOCNUM type J_1BNFDOC-DOCNUM
      !IV_NEW type ABAP_BOOL default ABAP_FALSE
      !IV_GUIACOMPL type ZE_GNRE_GUIACOMPL default ABAP_FALSE
      !IV_TPPROCESS type ZE_GNRE_TPPROCESS default GC_TPPROCESS-AUTOMATICO
      !IV_IGNORE_JOB_LOCK type ABAP_BOOL default ABAP_FALSE
      !IS_J_1BNFE_ACTIVE type J_1BNFE_ACTIVE optional
      !IS_HEADER type J_1BNFDOC optional
      !IV_LOCK type ABAP_BOOL default ABAP_TRUE
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods DISABLE_GUIA
    importing
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods FREE .
  methods GET_CONFIG_DATA
    exporting
      !ES_ZTSD_GNRET005 type ZTSD_GNRET005
      !ET_ZTSD_GNRE_CONFIG type TY_T_ZGNRE_CONFIG .
  methods GET_GNRE_DATA
    exporting
      !ET_HEADER type TY_T_GNRE_HEADER
      !ET_ITEM type TY_T_GNRE_ITEM
      !ET_LOG type TY_T_GNRE_LOG
      !ET_CALC_LOG type TY_T_GNRE_CALC_LOG .
  methods GET_NF_DATA
    exporting
      !ES_J_1BNFDOC type TY_S_J_1BNFDOC
      !ES_J_1BNFE_ACTIVE type J_1BNFE_ACTIVE
      !ET_J_1BNFLIN type TY_T_J_1BNFLIN
      !ET_J_1BNFSTX type TY_T_J_1BNFSTX .
  methods PERSIST
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods PRINT
    importing
      !IV_PDF type ABAP_BOOL default ABAP_FALSE
      !IV_PATH type RLGRAP-FILENAME optional
      !IV_ANEXO type FLAG optional
      !IV_DOWNLOAD type ABAP_BOOL default ABAP_FALSE
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods PROCESS
    importing
      !IR_DOCGUIA type TY_R_DOCGUIA optional
    returning
      value(RV_CONTINUE) type ABAP_BOOL .
  methods REPROCESS
    importing
      !IR_DOCGUIA type TY_R_DOCGUIA optional
    raising
      ZCXSD_GNRE_AUTOMACAO .
  methods SET_CANCEL .
  methods SET_STEP
    importing
      !IV_DOCGUIA type ZTSD_GNRET001-DOCGUIA
      !IV_STEP type ZTSD_GNRET001-STEP
      !IV_NEWDOC type ZTSD_GNRET003-NEWDOC optional
      !IV_STATUS_GUIA type ZTSD_GNRET003-STATUS_GUIA optional
      !IV_DESC_ST_GUIA type ZTSD_GNRET003-DESC_ST_GUIA optional .
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gv_docnum TYPE j_1bnfdoc-docnum .
    DATA gv_new TYPE abap_bool .
    DATA gv_tpprocess TYPE ze_gnre_tpprocess .
    DATA gs_j_1bnfe_active TYPE j_1bnfe_active .
    DATA gs_gnre_header TYPE ztsd_gnret001 .
    DATA:
      gt_gnre_header    TYPE TABLE OF ztsd_gnret001 .
    DATA:
      gt_gnre_item      TYPE TABLE OF ztsd_gnret002 .
    DATA:
      gt_gnre_log       TYPE TABLE OF ztsd_gnret003 .
    DATA:
      gt_gnre_calc_log  TYPE TABLE OF ztsd_gnret004 .
    DATA gt_to_delete TYPE ty_t_to_delete .
    DATA gs_j_1bnfdoc TYPE ty_s_j_1bnfdoc .
    DATA gt_j_1bnflin TYPE ty_t_j_1bnflin .
    DATA gt_j_1bnfstx TYPE ty_t_j_1bnfstx .
    DATA gs_ztsd_gnret005 TYPE ztsd_gnret005 .
    DATA:
      gt_ztsd_gnre_config    TYPE TABLE OF ztsd_gnre_config .
    DATA gv_ignore_job_lock TYPE abap_bool .
    DATA:
      gt_ztsd_gnret015 TYPE TABLE OF ztsd_gnret015 .
    DATA gv_price TYPE flag .

    METHODS add_item_value
      IMPORTING
        !iv_taxtyp           TYPE ztsd_gnret002-taxtyp
        !iv_taxval           TYPE ztsd_gnret002-taxval
        !iv_ztsd_gnre_config TYPE ztsd_gnre_config
        !iv_replace_header   TYPE abap_bool DEFAULT abap_false
      CHANGING
        !cs_gnre_header      TYPE ztsd_gnret001 .
    METHODS add_to_calc_log
      IMPORTING
        !is_calc_log TYPE ztsd_gnret004 .
    METHODS calculate_zsub .
    METHODS calculate_zsub_1
      IMPORTING
        !iv_base       TYPE j_1bnfstx-base
        !is_j_1bnflin  TYPE zclsd_gnre_automacao=>ty_s_j_1bnflin
        !is_dados_zsub TYPE zssd_gnree008 .
    METHODS calculate_zsub_2
      IMPORTING
        !iv_base       TYPE j_1bnfstx-base
        !iv_conv_menge TYPE j_1bnflin-menge
        !is_j_1bnflin  TYPE zclsd_gnre_automacao=>ty_s_j_1bnflin
        !is_dados_zsub TYPE zssd_gnree008 .
    METHODS calculate_zsub_3
      IMPORTING
        !iv_base       TYPE j_1bnfstx-base
        !iv_conv_menge TYPE j_1bnflin-menge
        !is_j_1bnflin  TYPE zclsd_gnre_automacao=>ty_s_j_1bnflin
        !is_dados_zsub TYPE zssd_gnree008 .
    METHODS calculate_zsub_4
      IMPORTING
        !iv_base       TYPE j_1bnfstx-base
        !iv_tot_ipi    TYPE j_1bnfstx-taxval
        !iv_conv_menge TYPE j_1bnflin-menge
        !is_j_1bnflin  TYPE zclsd_gnre_automacao=>ty_s_j_1bnflin
        !is_dados_zsub TYPE zssd_gnree008 .
    METHODS calculate_zsub_5
      IMPORTING
        !iv_base       TYPE j_1bnfstx-base
        !iv_tot_ipi    TYPE j_1bnfstx-taxval
        !is_j_1bnflin  TYPE zclsd_gnre_automacao=>ty_s_j_1bnflin
        !is_dados_zsub TYPE zssd_gnree008 .
    METHODS check_change_step_reprocess
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001
      RAISING
        zcxsd_gnre_automacao .
    METHODS check_document_status
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS check_doc_is_valid
      RAISING
        zcxsd_gnre_automacao .
    METHODS check_effect_reversal
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS check_payment_cycle
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS check_payment_status
      CHANGING
        VALUE(cs_gnre_header) TYPE ztsd_gnret001 OPTIONAL .
    METHODS check_step_exception .
    METHODS create_fi_document
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS delete_docguia
      IMPORTING
        !iv_docguia TYPE ztsd_gnret001-docguia .
    METHODS dequeue_nf .
    METHODS enqueue_nf
      RAISING
        zcxsd_gnre_automacao .
    METHODS execute_from_step
      IMPORTING
        !iv_step           TYPE ztsd_gnret001-step OPTIONAL
      CHANGING
        !cs_gnre_header    TYPE ztsd_gnret001
      RETURNING
        VALUE(rv_continue) TYPE abap_bool .
    METHODS fill_barcode_fi_document
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS fill_gnre_data .
    METHODS fill_gnre_data_after_error
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS fill_gnre_item .
    METHODS generate_payment_cycle
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS generate_pdf
      IMPORTING
        !iv_path    TYPE rlgrap-filename
        !iv_compl   TYPE rlgrap-filename
        !it_otfdata TYPE tsfotf    OPTIONAL
        !it_pdfdata TYPE solix_tab OPTIONAL
        !iv_pdfsize TYPE i         OPTIONAL
      RAISING
        zcxsd_gnre_automacao .
    METHODS get_bukrs_branch_for_fi_doc
      IMPORTING
        !is_gnre_header  TYPE ztsd_gnret001
      EXPORTING
        !ev_bukrs        TYPE ztsd_gnret001-bukrs_doc
        !ev_branch       TYPE ztsd_gnret001-branch_doc
        !ev_adiantamento TYPE ztsd_gnret009-adiantamento .
    METHODS get_fi_document_params
      EXPORTING
        !ev_blart   TYPE bkpf-blart
        !ev_bktxt   TYPE bkpf-bktxt
        !ev_zterm   TYPE bseg-zterm
        !ev_zlsch   TYPE bseg-zlsch
        !ev_zuonr   TYPE bseg-zuonr
        !ev_prctr   TYPE bseg-prctr
        !ev_segment TYPE bseg-segment
      RAISING
        zcxsd_gnre_automacao .
    METHODS get_max_time_for_f110
      RETURNING
        VALUE(rv_max_time) TYPE i .
    METHODS get_total_value_nf
      IMPORTING
        !iv_docnum    TYPE any
      RETURNING
        VALUE(rv_vlr) TYPE ze_gnre_vlrtot_guia .
    METHODS is_coligada
      EXPORTING
        !ev_bukrs          TYPE ztsd_cgccoligada-bukrs
        !ev_branch         TYPE ztsd_cgccoligada-bupla
      RETURNING
        VALUE(rv_coligada) TYPE abap_bool .
    METHODS is_final_consumer
      RETURNING
        VALUE(rv_consumer) TYPE ztsd_gnret001-consumo .
    METHODS is_substitute_insc
      RETURNING
        VALUE(rv_result) TYPE abap_bool .
    METHODS print_dua_es
      IMPORTING
        !is_gnre_header TYPE ztsd_gnret001
        !iv_pdf         TYPE abap_bool DEFAULT abap_false
        !iv_path        TYPE rlgrap-filename OPTIONAL
      RAISING
        zcxsd_gnre_automacao .
    METHODS print_gnre_pe
      IMPORTING
        !is_gnre_header TYPE ztsd_gnret001
        !iv_pdf         TYPE abap_bool DEFAULT abap_false
        !iv_path        TYPE rlgrap-filename OPTIONAL
      RAISING
        zcxsd_gnre_automacao .
    METHODS print_gnre_rj
      IMPORTING
        !is_gnre_header TYPE ztsd_gnret001
        !iv_pdf         TYPE abap_bool DEFAULT abap_false
        !iv_path        TYPE rlgrap-filename OPTIONAL
      RAISING
        zcxsd_gnre_automacao .
    METHODS print_gnre_sp
      IMPORTING
        !is_gnre_header TYPE ztsd_gnret001
        !iv_pdf         TYPE abap_bool
        !iv_path        TYPE rlgrap-filename
      RAISING
        zcxsd_gnre_automacao .
    METHODS print_nf
      IMPORTING
        !iv_pdf  TYPE abap_bool DEFAULT abap_false
        !iv_path TYPE rlgrap-filename OPTIONAL
        !iv_try  TYPE abap_bool DEFAULT abap_true
      RAISING
        zcxsd_gnre_automacao .

    "! @parameter is_gnre_header | Dados do cabeçalho da guia GNRE
    "! @parameter iv_pdf | Indicador para geração de arquivo PDF em diretório fornecido (X = gerar, ' ' = não gerar)
    "! @parameter iv_path | Caminho para salvar PDF quando iv_pdf = True
    METHODS print_comprovante_pagamento
      IMPORTING
        !is_gnre_header TYPE ztsd_gnret001
        !iv_pdf         TYPE abap_bool DEFAULT abap_false
        !iv_path        TYPE rlgrap-filename
      RAISING
        zcxsd_gnre_automacao .
    METHODS process_values_fcp
      EXPORTING
        !ev_taxtyp           TYPE ztsd_gnret002-taxtyp
        !ev_taxval           TYPE ztsd_gnret002-taxval
        !ev_found_fcp        TYPE abap_bool
        !es_ztsd_gnre_config TYPE ztsd_gnre_config .
    METHODS process_values_icms
      EXPORTING
        !ev_taxtyp           TYPE ztsd_gnret002-taxtyp
        !ev_taxval           TYPE ztsd_gnret002-taxval
        !ev_found_icms       TYPE abap_bool
        !es_ztsd_gnre_config TYPE ztsd_gnre_config .
    METHODS select_config_data .
    METHODS select_gnre_data
      RAISING
        zcxsd_gnre_automacao .
    METHODS select_nf_data
      RAISING
        zcxsd_gnre_automacao .
    METHODS send_to_integration
      IMPORTING
        !iv_type        TYPE char1 DEFAULT zclsd_gnre_integracao=>gc_type-process
      CHANGING
        !cs_gnre_header TYPE ztsd_gnret001 .
    METHODS validate_price
      IMPORTING
        !iv_docnum       TYPE ztsd_gnret001-docnum
        !iv_consumo      TYPE ztsd_gnret001-consumo
        !iv_frete        TYPE any OPTIONAL
        !iv_step_old     TYPE ztsd_gnret001-step OPTIONAL
      RETURNING
        VALUE(rv_return) TYPE flag .
    METHODS send_email_price .
    CLASS-METHODS send_email
      IMPORTING
        !iv_remetente_uname     TYPE sy-uname OPTIONAL
        !iv_remetente           TYPE adr6-smtp_addr OPTIONAL
        !iv_assunto             TYPE so_obj_des
        !iv_conteudo            TYPE bcsy_text
        !iv_destinatarios       TYPE bcsy_smtpa OPTIONAL
        !iv_destinatarios_cc    TYPE bcsy_smtpa OPTIONAL
        !iv_uname_destinatarios TYPE uname_range_tab OPTIONAL
        !iv_uname_copia         TYPE uname_range_tab OPTIONAL
        !iv_commit              TYPE boolean OPTIONAL
        !iv_tipo                TYPE so_obj_tp DEFAULT 'RAW'
        !iv_mime                TYPE REF TO cl_gbt_multirelated_service OPTIONAL
      RAISING
        cx_idm_error .
ENDCLASS.



CLASS ZCLSD_GNRE_AUTOMACAO IMPLEMENTATION.


  METHOD get_bukrs_branch_for_fi_doc.

*    DATA: ls_zcgc_coligada TYPE ztsd_cgccoligada.
    DATA: ls_zcgc_coligada TYPE t001w.

    "Verifica se é o cenário de adiantamento
    SELECT COUNT(*)
      FROM ztsd_gnret009
      WHERE bukrs        = is_gnre_header-bukrs
        AND branch       = is_gnre_header-branch
        AND shipto       = gs_j_1bnfdoc-regio
        AND zsub         = is_gnre_header-zsub
        AND adiantamento = abap_true.

    IF sy-subrc IS NOT INITIAL.
      ev_bukrs  = gs_j_1bnfdoc-bukrs.
      ev_branch = gs_j_1bnfdoc-branch.
    ELSE.

      ev_adiantamento = abap_true.

      CASE gs_j_1bnfdoc-partyp.

        WHEN 'C'. "Cliente

*          SELECT SINGLE *
*            FROM ztsd_cgccoligada
*            INTO ls_zcgc_coligada
*            WHERE kunnr = gs_j_1bnfdoc-parid.

          SELECT SINGLE *
             FROM t001w
            INTO ls_zcgc_coligada
            WHERE kunnr = gs_j_1bnfdoc-parid.

        WHEN 'V'. "Fornecedor

*          SELECT SINGLE *
*            FROM ztsd_cgccoligada
*            INTO ls_zcgc_coligada
*            WHERE lifnr = gs_j_1bnfdoc-parid.

          SELECT SINGLE *
             FROM t001w
            INTO ls_zcgc_coligada
            WHERE lifnr = gs_j_1bnfdoc-parid.


        WHEN 'B'. "Filial
*
*          SELECT SINGLE *
*            FROM ztsd_cgccoligada
*            INTO ls_zcgc_coligada
*            WHERE filial = gs_j_1bnfdoc-parid.

          SELECT SINGLE *
            FROM t001w
            INTO ls_zcgc_coligada
            WHERE j_1bbranch = gs_j_1bnfdoc-parid+4(4).

      ENDCASE.

      IF ls_zcgc_coligada IS INITIAL.
        ev_bukrs  = gs_j_1bnfdoc-bukrs.
        ev_branch = gs_j_1bnfdoc-branch.
      ELSE.
        ev_bukrs  = ls_zcgc_coligada-vkorg.
        ev_branch = ls_zcgc_coligada-j_1bbranch.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD get_config_data.

    es_ztsd_gnret005    = gs_ztsd_gnret005.
    et_ztsd_gnre_config = gt_ztsd_gnre_config.

  ENDMETHOD.


  METHOD get_fi_document_params.

    DATA: lt_zgnret015 TYPE TABLE OF ztsd_gnret015.

    FIELD-SYMBOLS: <fs_s_zgnret015> LIKE LINE OF lt_zgnret015.

    DEFINE _get_parametro.
      ASSIGN lt_zgnret015[ parametro = &1 ] TO <fs_s_zgnret015>.
      IF sy-subrc IS INITIAL.
        &2 = <fs_s_zgnret015>-valor.
      ENDIF.
    END-OF-DEFINITION.

    "Obtêm os parâmetros cadastrados
    SELECT ('*')
      FROM ztsd_gnret015
      INTO TABLE lt_zgnret015
      WHERE parametro IN ( gc_parametro-tipo_de_documento,
                           gc_parametro-texto_cabecalho,
                           gc_parametro-condicao_pagamento,
                           gc_parametro-forma_pagamento,
                           gc_parametro-atribuicao,
                           gc_parametro-centro_de_lucro,
                           gc_parametro-segmento            ).

    _get_parametro: gc_parametro-tipo_de_documento  ev_blart,
                    gc_parametro-texto_cabecalho    ev_bktxt,
                    gc_parametro-condicao_pagamento ev_zterm,
                    gc_parametro-forma_pagamento    ev_zlsch,
                    gc_parametro-atribuicao         ev_zuonr,
                    gc_parametro-centro_de_lucro    ev_prctr,
                    gc_parametro-segmento           ev_segment.

    "Verifica se os parâmetros foram encontrados
    IF ev_blart   IS INITIAL OR ev_bktxt IS INITIAL OR
       ev_zterm   IS INITIAL OR ev_zlsch IS INITIAL OR
       ev_zuonr   IS INITIAL OR ev_prctr IS INITIAL OR
       ev_segment IS INITIAL.

      "Parâmetros não encontrados, verificar cadastro da tabela ZGNRET015.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_parameters_not_found.

    ENDIF.

  ENDMETHOD.


  METHOD get_gnre_data.

    et_header   = gt_gnre_header  .
    et_item     = gt_gnre_item    .
    et_log      = gt_gnre_log     .
    et_calc_log = gt_gnre_calc_log.

  ENDMETHOD.


  METHOD get_icon_from_step.

    CASE iv_step.
      WHEN gc_step-aguardando_envio.                  "Aguardando Envio
        rv_icon = icon_activity.
      WHEN gc_step-guia_solicitada.                   "Guia Solicitada - Aguardando RVtorno SEFAZ
        rv_icon = icon_activity.
      WHEN gc_step-operacao_manual.                   "Operação Manual - Incluir Guia Manual
        rv_icon = icon_used_relation.
      WHEN gc_step-aguardando_preenchimento_dados.    "Aguardando PRVenchimento dos Dados
        rv_icon = icon_activity.
      WHEN gc_step-operacao_c_insc_substituto.        "Operação Com Inscrição Substituto (NIF RVgional)
        rv_icon = icon_complete.
      WHEN gc_step-operacao_c_somatorio_trib_zero.    "Operação com Somatório dos Tributos Igual Zero
        rv_icon = icon_complete.
      WHEN gc_step-guia_criada.                       "Guia Criada - Aguardando Envio ao VAN FINNET
        rv_icon = icon_activity.
      WHEN gc_step-documento_criado.                  "Doc. FI Criado - Aguardando PRVenchimento do Código de Barras
        rv_icon = icon_annotation.
      WHEN gc_step-cod_barras_preenchido.             "Código de Barras pRVenchido - Aguardando Envio ao VAN FINNET
        rv_icon = icon_annotation.
      WHEN gc_step-documento_enviado.                 "Documento Enviado ao VAN FINNET
        rv_icon = icon_financing.
      WHEN gc_step-pagamento_enviado.                 "Pagamento Enviado - Aguardando RVtorno Bancário
        rv_icon = icon_budget_structure_element.
      WHEN gc_step-pagamento_autenticado.             "Pagamento Autenticado - Imprimir (NFe+Guia+Aut.)
        rv_icon = icon_budget_structure_element.
      WHEN gc_step-pagamento_manual_realizado.        "Pagamento Manual RValizado - Imprimir (NFe+Guia+Aut.)
        rv_icon = icon_budget_structure_element.
      WHEN gc_step-documentos_impressos_c_sucesso.    "Documentos ImpRVssos Com Sucesso
        rv_icon = icon_complete.
      WHEN gc_step-nfe_cancelada.                     "NF-e Cancelada
        rv_icon = icon_warning.
      WHEN gc_step-guia_vencida.                      "Guia Vencida
        rv_icon = icon_warning.
      WHEN gc_step-guia_inutilizada_manualmente.      "Guia Inutilizada Manualmente
        rv_icon = icon_reject.
      WHEN gc_step-cnpj_nao_habilitado_para_uso.      "CNPJ Não Habilitado Para Uso do Serviço
        rv_icon = icon_alert.
      WHEN gc_step-integracao_auto_n_implementada.    "Integração Automática Não Implementada - Incluir Guia Manual
        rv_icon = icon_alert.
      WHEN gc_step-impossivel_ident_fornecedor_cr.    "Impossível Identificar Fornecedor e/ou Conta do Razão
        rv_icon = icon_alert.
      WHEN gc_step-impossivel_ident_tipo_de_guia.     "Impossível Identificar Tipo de Guia
        rv_icon = icon_alert.
      WHEN gc_step-integracao_desativada_manual.      "Integração Desativada Manualmente
        rv_icon = icon_warning.
      WHEN gc_step-impossivel_ident_cod_receita.      "Impossível Identificar Código de RVceita
        rv_icon = icon_alert.
      WHEN gc_step-erro_interno_no_envio.             "Erro Interno no Envio
        rv_icon = icon_alert.
      WHEN gc_step-erro_interno_na_consulta_lote.     "Erro Interno na Consulta do Lote
        rv_icon = icon_alert.
      WHEN gc_step-rejeicao_no_envio_do_lote.         "RVjeição no Envio do Lote
        rv_icon = icon_alert.
      WHEN gc_step-erro_ao_converter_um_pauta.        "Erro ao converter unidade de medida - Pauta ICMS
        rv_icon = icon_alert.
      WHEN gc_step-erro_ao_gerar_o_documento_fi.      "Erro ao Gerar o Documento Financeiro
        rv_icon = icon_alert.
      WHEN gc_step-erro_ao_incluir_codigo_barras.     "Erro ao Incluir o Código de Barras
        rv_icon = icon_alert.
      WHEN gc_step-erro_ao_gerar_ciclo_pagamento.     "Erro ao gerar o ciclo de pagamento - Verificar banco empRVsa
        rv_icon = icon_alert.
      WHEN gc_step-erro_no_ciclo_de_pagamento.        "Erro no Ciclo de Pagamento - RVprocessar
        rv_icon = icon_alert.
      WHEN gc_step-guia_rejeitada.                    "Guia RVjeitada - Verificar Motivo
        rv_icon = icon_alert.
      WHEN gc_step-pagamento_rejeitado.               "Pagamento RVjeitado - Verificar status no VAN FINNET
        rv_icon = icon_red_xcircle.
      WHEN gc_step-guia_valor_muito_alto.             "Guia com valor muito alto - impostos.
        rv_icon = icon_warning.
      WHEN OTHERS.
        rv_icon = icon_dummy.
    ENDCASE.

  ENDMETHOD.


  METHOD get_max_time_for_f110.

    DATA: lv_valor TYPE ztsd_gnret015-valor.

    SELECT SINGLE
           valor
      FROM ztsd_gnret015
      INTO lv_valor
      WHERE parametro = gc_parametro-tempo_maximo_f110.

    IF sy-subrc IS INITIAL.

      rv_max_time = lv_valor.

      IF rv_max_time <= 0.
        "Tempo padrão, 5 minutos
        rv_max_time = '300'.
      ENDIF.

    ELSE.
      "Tempo padrão, 5 minutos
      rv_max_time = '300'.
    ENDIF.

  ENDMETHOD.


  METHOD get_nf_data.

    es_j_1bnfdoc      = gs_j_1bnfdoc.
    es_j_1bnfe_active = gs_j_1bnfe_active.
    et_j_1bnflin      = gt_j_1bnflin.
    et_j_1bnfstx      = gt_j_1bnfstx.

  ENDMETHOD.


  METHOD get_steps_disable_guia.

    SELECT step_from
    FROM ztsd_gnret010
    INTO TABLE rt_steps
    WHERE acao = gc_acao-inutilizar_guia.

  ENDMETHOD.


  METHOD get_steps_guia_manual.

    SELECT step_from
    FROM ztsd_gnret010
    INTO TABLE rt_steps
    WHERE acao = gc_acao-incluir_guia_manual.

  ENDMETHOD.


  METHOD get_steps_manual_payment.

    SELECT step_from
    FROM ztsd_gnret010
    INTO TABLE rt_steps
    WHERE acao = gc_acao-pagamento_manual.

  ENDMETHOD.


  METHOD get_steps_print.

    SELECT step_from
         opcoes
    FROM ztsd_gnret010
    INTO TABLE rt_steps
    WHERE acao = gc_acao-imprimir.

  ENDMETHOD.


  METHOD get_steps_reprocess.

    SELECT step_from
         step_to
    FROM ztsd_gnret010
    INTO TABLE rt_steps_reprocess
    WHERE acao = gc_acao-reprocessar.

  ENDMETHOD.


  METHOD get_total_value_nf.

    LOOP AT me->gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_gnre>) WHERE docnum = iv_docnum.
      ADD <fs_gnre>-vlrtot TO rv_vlr.
    ENDLOOP.
    IF me->gt_gnre_header IS INITIAL OR
      ( NOT me->gs_gnre_header-vlrtot IS INITIAL AND me->gs_gnre_header-vlrtot NE rv_vlr ).
      ADD me->gs_gnre_header-vlrtot TO rv_vlr.
    ENDIF.

  ENDMETHOD.


  METHOD is_coligada.

*    DATA: ls_zcgc_coligada TYPE ztsd_cgccoligada.
    DATA: ls_zcgc_coligada TYPE t001w.

    CASE gs_j_1bnfdoc-partyp.

      WHEN 'C'. "Cliente

*        SELECT SINGLE *
*          FROM ztsd_cgccoligada
*          INTO ls_zcgc_coligada
*          WHERE kunnr = gs_j_1bnfdoc-parid.

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE kunnr = gs_j_1bnfdoc-parid.



      WHEN 'V'. "Fornecedor

*        SELECT SINGLE *
*          FROM ztsd_cgccoligada
*          INTO ls_zcgc_coligada
*          WHERE lifnr = gs_j_1bnfdoc-parid.

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE lifnr = gs_j_1bnfdoc-parid.

      WHEN 'B'. "Filial
*
*        SELECT SINGLE *
*          FROM ztsd_cgccoligada
*          INTO ls_zcgc_coligada
*          WHERE filial = gs_j_1bnfdoc-parid.

        SELECT SINGLE *
          FROM t001w
          INTO ls_zcgc_coligada
          WHERE j_1bbranch = gs_j_1bnfdoc-parid+4(4).

      WHEN OTHERS.
        rv_coligada = abap_false.
        RETURN.

    ENDCASE.

    IF sy-subrc IS INITIAL.
      ev_bukrs   = ls_zcgc_coligada-vkorg.
      ev_branch  = ls_zcgc_coligada-bwkey.
      rv_coligada = abap_true.
    ELSE.
      rv_coligada = abap_false.
    ENDIF.


  ENDMETHOD.


  METHOD is_final_consumer.

    rv_consumer = COND #( WHEN ( gs_j_1bnfdoc-ind_iedest = '2'   OR
                             gs_j_1bnfdoc-ind_iedest = '9' ) AND
                             gs_j_1bnfdoc-ind_final  = '1'   THEN
                        abap_true   "Consumidor Final
                      ELSE
                        abap_false                                ).

  ENDMETHOD.


  METHOD is_substitute_insc.

    SELECT *
  FROM j_1bstast
      INTO TABLE @DATA(lt_j_1bstast)
  WHERE bukrs  = @gs_j_1bnfdoc-bukrs
    AND branch = @gs_j_1bnfdoc-branch
    AND txreg  = @gs_j_1bnfdoc-regio.

    IF sy-subrc IS INITIAL.
      rv_result = abap_true.
    ELSE.
      rv_result = abap_false.
    ENDIF.

  ENDMETHOD.


  METHOD persist.

    IF gt_to_delete IS NOT INITIAL.

      LOOP AT gt_to_delete ASSIGNING FIELD-SYMBOL(<fs_s_to_delete>).

        "Remove os registros das tabelas transparentes
        DELETE FROM ztsd_gnret001 WHERE docnum  = <fs_s_to_delete>-docnum
                                AND docguia = <fs_s_to_delete>-docguia.

        DELETE FROM ztsd_gnret002 WHERE docnum  = <fs_s_to_delete>-docnum
                                AND docguia = <fs_s_to_delete>-docguia.

        DELETE FROM ztsd_gnret003 WHERE docnum  = <fs_s_to_delete>-docnum
                                AND docguia = <fs_s_to_delete>-docguia.

      ENDLOOP.

    ENDIF.

    IF gt_gnre_header IS NOT INITIAL.

      IF line_exists( gt_gnre_header[ step = space ] ).
        LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_gnre_header>).
          IF <fs_gnre_header>-step EQ space.
            <fs_gnre_header>-step = '000'.
          ENDIF.
        ENDLOOP.
      ENDIF.

      MODIFY ztsd_gnret001 FROM TABLE gt_gnre_header.

      IF sy-subrc IS NOT INITIAL.
        "Erro ao inserir/modificar os dados da tabela &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_error_on_persist_data_on_db
            iv_msgv1  = 'ZTSD_GNRET001'.
      ENDIF.

    ENDIF.

    IF gt_gnre_item IS NOT INITIAL.

      MODIFY ztsd_gnret002 FROM TABLE gt_gnre_item.

      IF sy-subrc IS NOT INITIAL.
        "Erro ao inserir/modificar os dados da tabela &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_error_on_persist_data_on_db
            iv_msgv1  = 'ZTSD_GNRET002'.
      ENDIF.

    ENDIF.

    IF gt_gnre_log IS NOT INITIAL.

      IF line_exists( gt_gnre_log[ step = space ] ).
        LOOP AT gt_gnre_log ASSIGNING FIELD-SYMBOL(<fs_gnre_log>).
          IF <fs_gnre_log>-step EQ space.
            <fs_gnre_log>-step = '000'.
          ENDIF.
        ENDLOOP.
      ENDIF.

      MODIFY ztsd_gnret003 FROM TABLE gt_gnre_log.

      IF sy-subrc IS NOT INITIAL.
        "Erro ao inserir/modificar os dados da tabela &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_error_on_persist_data_on_db
            iv_msgv1  = 'ZTSD_GNRET003'.
      ENDIF.

    ENDIF.

    IF gt_gnre_calc_log IS NOT INITIAL.

      MODIFY ztsd_gnret004 FROM TABLE gt_gnre_calc_log.

      IF sy-subrc IS NOT INITIAL.
        "Erro ao inserir/modificar os dados da tabela &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_error_on_persist_data_on_db
            iv_msgv1  = 'ZTSD_GNRET004'.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD print.

    DATA(lt_steps_print) = get_steps_print( ).
    DATA lv_msgv1     TYPE msgv1.
    DATA lv_msgv1_2   TYPE msgv1.
    DATA lv_msgv3     TYPE msgv2.

    lv_msgv1 = gv_docnum.

    LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>).
      IF NOT line_exists( lt_steps_print[ step = <fs_s_gnre_header>-step ] ).
        lv_msgv3 = <fs_s_gnre_header>-step.
        DATA(lv_tabix) = sy-tabix.
        IF iv_download EQ abap_false.
          "NFe & Guia &, com a etapa & não permite impressão.
          RAISE EXCEPTION TYPE zcxsd_gnre_automacao
            EXPORTING
              iv_textid = zcxsd_gnre_automacao=>gc_nf_guia_step_not_allo_print
              iv_msgv1  = |{ gv_docnum ALPHA = OUT }|
              iv_msgv2  = |{ <fs_s_gnre_header>-docguia ALPHA = OUT }|
              iv_msgv3  = lv_msgv3.
        ELSE.
          DELETE gt_gnre_header INDEX lv_tabix.
        ENDIF.
      ENDIF.
    ENDLOOP.


    IF sy-subrc IS NOT INITIAL AND iv_download EQ abap_false.
      "Para a Nota &, não foi encontrado o Nº interno de Guia &.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_docguia_not_found
          iv_msgv1  = lv_msgv1.
    ENDIF.

    IF iv_download EQ abap_false.
      "Verifica se o usuário possui autorização para impressão, em uma filial específica
      SELECT COUNT(*)
        FROM ztsd_nfe_usuario
        WHERE branch = gs_j_1bnfdoc-branch
          AND uname  = sy-uname.
      IF sy-subrc IS NOT INITIAL.

        "Verifica se o usuário possui autorização para impressão, em todas as filiais
        SELECT COUNT(*)
          FROM ztsd_nfe_usuario
          WHERE branch = space
            AND uname  = sy-uname.
      ENDIF.

      IF sy-subrc IS NOT INITIAL.
        "NFe &, usuário não autorizado para imprimir.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_user_not_allowed_for_print
            iv_msgv1  = lv_msgv1.
      ENDIF.

      "Realiza a impressão da nota
      print_nf( iv_pdf  = iv_pdf
                iv_path = iv_path ).

    ENDIF.

    LOOP AT gt_gnre_header ASSIGNING <fs_s_gnre_header>.

      ASSIGN lt_steps_print[ step = <fs_s_gnre_header>-step ] TO FIELD-SYMBOL(<fs_s_step_print>).

      TRY.

          "Verifica se é para ser realizada a impressão da guia
          CHECK <fs_s_step_print>-opcoes+1(1) = space.

          "Realiza a impressão da guia
          CASE <fs_s_gnre_header>-tpguia.

            WHEN gc_tpguia-gnre_pe_1_00 OR
                 gc_tpguia-gnre_pe_2_00.

              print_gnre_pe( is_gnre_header = <fs_s_gnre_header>
                             iv_pdf         = iv_pdf
                             iv_path        = iv_path            ).

            WHEN gc_tpguia-gnre_rj.

              print_gnre_rj( is_gnre_header = <fs_s_gnre_header>
                             iv_pdf         = iv_pdf
                             iv_path        = iv_path            ).

            WHEN gc_tpguia-gnre_sp.

              print_gnre_sp( is_gnre_header = <fs_s_gnre_header>
                             iv_pdf         = iv_pdf
                             iv_path        = iv_path            ).

            WHEN gc_tpguia-dua_es.

              print_dua_es( is_gnre_header = <fs_s_gnre_header>
                            iv_pdf         = iv_pdf
                            iv_path        = iv_path            ).

            WHEN OTHERS.
              lv_msgv1_2 = <fs_s_gnre_header>-tpguia.
              "Para o tipo de guia & não existe um formulário criado.
              RAISE EXCEPTION TYPE zcxsd_gnre_automacao
                EXPORTING
                  iv_textid = zcxsd_gnre_automacao=>gc_for_tp_guia_form_not_found
                  iv_msgv1  = lv_msgv1_2.

          ENDCASE.

          "Imprimir comprovante pagamento para guias automáticas/manuais
          me->print_comprovante_pagamento(
            EXPORTING
              is_gnre_header = <fs_s_gnre_header>
              iv_pdf         = iv_pdf
              iv_path        = iv_path
          ).

          IF <fs_s_step_print>-opcoes(1) = space AND iv_download EQ abap_false.

            "Etapa: Todos os Documentos Impressos Com Sucesso
            set_step( iv_docguia = <fs_s_gnre_header>-docguia
                      iv_step    = gc_step-documentos_impressos_c_sucesso ).

          ENDIF.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          IF iv_download EQ abap_false.
            RAISE EXCEPTION TYPE zcxsd_gnre_automacao
              EXPORTING
                it_errors = VALUE #( ( lr_cx_gnre_automacao ) ).
          ENDIF.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD print_dua_es.

    DATA: ls_parnad             TYPE j_1binnad,
          lv_smartforms_fm_name TYPE rs38l_fnam,
          ls_control_parameters TYPE ssfctrlop,
          ls_job_output_info    TYPE ssfcrescl,
          lv_hbkid              TYPE bseg-hbkid.

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = 'B'
        partner_id             = CONV j_1bnfnad-parid( |{ is_gnre_header-bukrs }{ is_gnre_header-branch }| )
      IMPORTING
        parnad                 = ls_parnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.
    IF sy-subrc IS NOT INITIAL.
      DATA(lv_erro) = abap_true.
    ENDIF.

    DATA(ls_gnre_campos) = VALUE zssd_gnree003( doc_regio     = gs_j_1bnfdoc-regio
                                            doc_nfenum    = gs_j_1bnfdoc-nfenum
                                            doc_series    = gs_j_1bnfdoc-series
                                            doc_cgc       = gs_j_1bnfdoc-cgc
                                            doc_cpf       = gs_j_1bnfdoc-cpf
                                            doc_ort01     = gs_j_1bnfdoc-ort01
                                            authdate      = gs_j_1bnfdoc-authdate
                                            authtime      = gs_j_1bnfdoc-authtime
                                            emit_name1    = ls_parnad-name1
                                            emit_cgc      = ls_parnad-cgc
                                            emit_stras    = ls_parnad-stras
                                            emit_reg      = ls_parnad-regio
                                            emit_ort01    = ls_parnad-ort01
                                            emit_pstlz    = ls_parnad-pstlz
                                            emit_telf1    = ls_parnad-telf1
                                            emit_txjcd    = ls_parnad-txjcd
                                            hr_controle   = is_gnre_header-num_guia
                                            hr_valor      = is_gnre_header-vlrtot
                                            itemguia      = is_gnre_header-docguia
                                            cod_barras    = is_gnre_header-brcde_guia
                                            cod_barras_dv = is_gnre_header-ldig_guia
                                            codaut        = is_gnre_header-codaut_guia
                                            faedt         = is_gnre_header-faedt
                                            dtpgto        = is_gnre_header-dtpgto
                                            vlrpago       = is_gnre_header-vlrpago  ).

    CONCATENATE gs_j_1bnfe_active-regio
                gs_j_1bnfe_active-nfyear
                gs_j_1bnfe_active-nfmonth
                gs_j_1bnfe_active-stcd1
                gs_j_1bnfe_active-model
                gs_j_1bnfe_active-serie
                gs_j_1bnfe_active-nfnum9
                gs_j_1bnfe_active-docnum9
                gs_j_1bnfe_active-cdv
           INTO ls_gnre_campos-acckey.

    SELECT SINGLE
           hbkid
      FROM bseg
      INTO lv_hbkid
      WHERE bukrs = is_gnre_header-bukrs_doc
        AND belnr = is_gnre_header-belnr
        AND gjahr = is_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE
             bankl
        FROM t012
        INTO ls_gnre_campos-bankl
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

      SELECT SINGLE
             bankn
             bkont
        FROM t012k
        INTO ( ls_gnre_campos-bankn, ls_gnre_campos-bkont )
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

    ENDIF.

    DATA(lt_itens_gnre) = VALUE zctgsd_gnrec001( FOR <fs_s_gnre_item> IN gt_gnre_item WHERE ( docguia = is_gnre_header-docguia )
                                             ( <fs_s_gnre_item> )  ).

    IF lt_itens_gnre IS NOT INITIAL.
      ASSIGN lt_itens_gnre[ 1 ] TO FIELD-SYMBOL(<fs_s_item_gnre>).
      ls_gnre_campos-it_convenio = <fs_s_item_gnre>-convenio.
      ls_gnre_campos-it_produto  = <fs_s_item_gnre>-produto.
      ls_gnre_campos-it_receita  = <fs_s_item_gnre>-receita.
      ls_gnre_campos-itemguia    = lines( lt_itens_gnre ).
    ENDIF.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gc_smartforms-dua_es
      IMPORTING
        fm_name            = lv_smartforms_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

    IF iv_pdf = abap_true.
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-getotf    = abap_true.
    ENDIF.

    CALL FUNCTION lv_smartforms_fm_name
      EXPORTING
        control_parameters = ls_control_parameters
        is_zgnre_campos       = ls_gnre_campos
      IMPORTING
        job_output_info    = ls_job_output_info
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0 AND sy-subrc <> 4.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ELSEIF iv_pdf = abap_true.
      generate_pdf( iv_path    = iv_path
                    iv_compl   = |GUIA_{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-branch }-{ gs_j_1bnfdoc-regio }-{ is_gnre_header-docguia ALPHA = OUT }|
                    it_otfdata = ls_job_output_info-otfdata[] ).
    ENDIF.

  ENDMETHOD.


  METHOD print_gnre_pe.

    DATA: ls_parnad             TYPE j_1binnad,
          lv_smartforms_fm_name TYPE rs38l_fnam,
          ls_control_parameters TYPE ssfctrlop,
          ls_job_output_info    TYPE ssfcrescl,
          lv_hbkid              TYPE bseg-hbkid.

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = 'B'
        partner_id             = CONV j_1bnfnad-parid( |{ is_gnre_header-bukrs }{ is_gnre_header-branch }| )
      IMPORTING
        parnad                 = ls_parnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.
    IF sy-subrc IS NOT INITIAL.
      DATA(lv_erro) = abap_true.
    ENDIF.

    DATA(ls_gnre_campos) = VALUE zssd_gnree003( doc_regio     = gs_j_1bnfdoc-regio
                                            doc_nfenum    = gs_j_1bnfdoc-nfenum
                                            doc_series    = gs_j_1bnfdoc-series
                                            doc_cgc       = gs_j_1bnfdoc-cgc
                                            doc_cpf       = gs_j_1bnfdoc-cpf
                                            doc_ort01     = gs_j_1bnfdoc-ort01
                                            authdate      = gs_j_1bnfdoc-authdate
                                            authtime      = gs_j_1bnfdoc-authtime
                                            emit_name1    = ls_parnad-name1
                                            emit_cgc      = ls_parnad-cgc
                                            emit_stras    = ls_parnad-stras
                                            emit_reg      = ls_parnad-regio
                                            emit_ort01    = ls_parnad-ort01
                                            emit_pstlz    = ls_parnad-pstlz
                                            emit_telf1    = ls_parnad-telf1
                                            emit_txjcd    = ls_parnad-txjcd
                                            hr_controle   = is_gnre_header-num_guia
                                            hr_valor      = is_gnre_header-vlrtot
                                            itemguia      = is_gnre_header-docguia
                                            cod_barras    = is_gnre_header-brcde_guia
                                            cod_barras_dv = is_gnre_header-ldig_guia
                                            codaut        = is_gnre_header-codaut_guia
                                            faedt         = is_gnre_header-faedt
                                            dtpgto        = is_gnre_header-dtpgto
                                            vlrpago       = is_gnre_header-vlrpago  ).

    CONCATENATE gs_j_1bnfe_active-regio
                gs_j_1bnfe_active-nfyear
                gs_j_1bnfe_active-nfmonth
                gs_j_1bnfe_active-stcd1
                gs_j_1bnfe_active-model
                gs_j_1bnfe_active-serie
                gs_j_1bnfe_active-nfnum9
                gs_j_1bnfe_active-docnum9
                gs_j_1bnfe_active-cdv
           INTO ls_gnre_campos-acckey.

    SELECT SINGLE
           hbkid
      FROM bseg
      INTO lv_hbkid
      WHERE bukrs = is_gnre_header-bukrs_doc
        AND belnr = is_gnre_header-belnr
        AND gjahr = is_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE
             bankl
        FROM t012
        INTO ls_gnre_campos-bankl
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

      SELECT SINGLE
             bankn
             bkont
        FROM t012k
        INTO ( ls_gnre_campos-bankn, ls_gnre_campos-bkont )
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

    ENDIF.

    DATA(lt_itens_gnre) = VALUE zctgsd_gnrec001( FOR <fs_s_gnre_item> IN gt_gnre_item WHERE ( docguia = is_gnre_header-docguia )
                                             ( <fs_s_gnre_item> ) ).

    IF lt_itens_gnre IS NOT INITIAL.
      ASSIGN lt_itens_gnre[ 1 ] TO FIELD-SYMBOL(<fs_s_item_gnre>).
      ls_gnre_campos-it_convenio = <fs_s_item_gnre>-convenio.
      ls_gnre_campos-it_produto  = <fs_s_item_gnre>-produto.
      ls_gnre_campos-it_receita  = <fs_s_item_gnre>-receita.
      ls_gnre_campos-itemguia    = lines( lt_itens_gnre ).
    ENDIF.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gc_smartforms-gnre_pe
      IMPORTING
        fm_name            = lv_smartforms_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

    IF iv_pdf = abap_true.
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-getotf    = abap_true.
    ENDIF.

    CALL FUNCTION lv_smartforms_fm_name
      EXPORTING
        control_parameters = ls_control_parameters
        is_zgnre_campos    = ls_gnre_campos
      IMPORTING
        job_output_info    = ls_job_output_info
      TABLES
        it_zitens_gnre     = lt_itens_gnre
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0 AND sy-subrc <> 4.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ELSEIF iv_pdf = abap_true.
      generate_pdf( iv_path    = iv_path
                    iv_compl   = |GUIA_{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-branch }-{ gs_j_1bnfdoc-regio }-{ is_gnre_header-docguia ALPHA = OUT }|
                    it_otfdata = ls_job_output_info-otfdata[] ).
    ENDIF.


  ENDMETHOD.


  METHOD print_gnre_rj.

    DATA: ls_parnad             TYPE j_1binnad,
          lv_smartforms_fm_name TYPE rs38l_fnam,
          ls_control_parameters TYPE ssfctrlop,
          ls_job_output_info    TYPE ssfcrescl,
          lv_hbkid              TYPE bseg-hbkid.

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = 'B'
        partner_id             = CONV j_1bnfnad-parid( |{ is_gnre_header-bukrs }{ is_gnre_header-branch }| )
      IMPORTING
        parnad                 = ls_parnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.
    IF sy-subrc IS NOT INITIAL.
      DATA(lv_erro) = abap_true.
    ENDIF.

    DATA(ls_gnre_campos) = VALUE zssd_gnree003( doc_regio     = gs_j_1bnfdoc-regio
                                                doc_nfenum    = gs_j_1bnfdoc-nfenum
                                                doc_series    = gs_j_1bnfdoc-series
                                                doc_cgc       = gs_j_1bnfdoc-cgc
                                                doc_cpf       = gs_j_1bnfdoc-cpf
                                                doc_ort01     = gs_j_1bnfdoc-ort01
                                                authdate      = gs_j_1bnfdoc-authdate
                                                authtime      = gs_j_1bnfdoc-authtime
                                                emit_name1    = ls_parnad-name1
                                                emit_cgc      = ls_parnad-cgc
                                                emit_stras    = ls_parnad-stras
                                                emit_reg      = ls_parnad-regio
                                                emit_ort01    = ls_parnad-ort01
                                                emit_pstlz    = ls_parnad-pstlz
                                                emit_telf1    = ls_parnad-telf1
                                                emit_txjcd    = ls_parnad-txjcd
                                                hr_controle   = is_gnre_header-num_guia
                                                hr_valor      = is_gnre_header-vlrtot
                                                itemguia      = is_gnre_header-docguia
                                                cod_barras    = is_gnre_header-brcde_guia
                                                cod_barras_dv = is_gnre_header-ldig_guia
                                                codaut        = is_gnre_header-codaut_guia
                                                faedt         = is_gnre_header-faedt
                                                dtpgto        = is_gnre_header-dtpgto
                                                vlrpago       = is_gnre_header-vlrpago  ).

    CONCATENATE gs_j_1bnfe_active-regio
                gs_j_1bnfe_active-nfyear
                gs_j_1bnfe_active-nfmonth
                gs_j_1bnfe_active-stcd1
                gs_j_1bnfe_active-model
                gs_j_1bnfe_active-serie
                gs_j_1bnfe_active-nfnum9
                gs_j_1bnfe_active-docnum9
                gs_j_1bnfe_active-cdv
           INTO ls_gnre_campos-acckey.

    SELECT SINGLE
           hbkid
      FROM bseg
      INTO lv_hbkid
      WHERE bukrs = is_gnre_header-bukrs_doc
        AND belnr = is_gnre_header-belnr
        AND gjahr = is_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE
             bankl
        FROM t012
        INTO ls_gnre_campos-bankl
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

      SELECT SINGLE
             bankn
             bkont
        FROM t012k
        INTO ( ls_gnre_campos-bankn, ls_gnre_campos-bkont )
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

    ENDIF.

    DATA(lt_itens_gnre) = VALUE zctgsd_gnrec001( FOR <fs_s_gnre_item> IN gt_gnre_item WHERE ( docguia = is_gnre_header-docguia )
                                             ( <fs_s_gnre_item> ) ).

    IF lt_itens_gnre IS NOT INITIAL.
      ASSIGN lt_itens_gnre[ 1 ] TO FIELD-SYMBOL(<fs_s_item_gnre>).
      ls_gnre_campos-it_convenio = <fs_s_item_gnre>-convenio.
      ls_gnre_campos-it_produto  = <fs_s_item_gnre>-produto.
      ls_gnre_campos-it_receita  = <fs_s_item_gnre>-receita.
      ls_gnre_campos-itemguia    = lines( lt_itens_gnre ).
    ENDIF.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gc_smartforms-gnre_rj
      IMPORTING
        fm_name            = lv_smartforms_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

    IF iv_pdf = abap_true.
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-getotf    = abap_true.
    ENDIF.

    CALL FUNCTION lv_smartforms_fm_name
      EXPORTING
        control_parameters = ls_control_parameters
        zgnre_campos       = ls_gnre_campos
        gs_zgnret001       = is_gnre_header
      IMPORTING
        job_output_info    = ls_job_output_info
      TABLES
        zitens_gnre        = lt_itens_gnre
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0 AND sy-subrc <> 4.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ELSEIF iv_pdf = abap_true.
      generate_pdf( iv_path    = iv_path
                    iv_compl   = |GUIA_{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-branch }-{ gs_j_1bnfdoc-regio }-{ is_gnre_header-docguia ALPHA = OUT }|
                    it_otfdata = ls_job_output_info-otfdata[] ).
    ENDIF.

  ENDMETHOD.


  METHOD print_gnre_sp.

    DATA: ls_parnad             TYPE j_1binnad,
          lv_smartforms_fm_name TYPE rs38l_fnam,
          ls_control_parameters TYPE ssfctrlop,
          ls_job_output_info    TYPE ssfcrescl,
          lv_hbkid              TYPE bseg-hbkid.

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = 'B'
        partner_id             = CONV j_1bnfnad-parid( |{ is_gnre_header-bukrs }{ is_gnre_header-branch }| )
      IMPORTING
        parnad                 = ls_parnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.
    IF sy-subrc IS NOT INITIAL.
      DATA(lv_erro) = abap_true.
    ENDIF.

    DATA(ls_gnre_campos) = VALUE zssd_gnree003( doc_regio     = gs_j_1bnfdoc-regio
                                                doc_nfenum    = gs_j_1bnfdoc-nfenum
                                                doc_series    = gs_j_1bnfdoc-series
                                                doc_cgc       = gs_j_1bnfdoc-cgc
                                                doc_cpf       = gs_j_1bnfdoc-cpf
                                                doc_ort01     = gs_j_1bnfdoc-ort01
                                                authdate      = gs_j_1bnfdoc-authdate
                                                authtime      = gs_j_1bnfdoc-authtime
                                                emit_name1    = ls_parnad-name1
                                                emit_cgc      = ls_parnad-cgc
                                                emit_stras    = ls_parnad-stras
                                                emit_reg      = ls_parnad-regio
                                                emit_ort01    = ls_parnad-ort01
                                                emit_pstlz    = ls_parnad-pstlz
                                                emit_telf1    = ls_parnad-telf1
                                                emit_txjcd    = ls_parnad-txjcd
                                                hr_controle   = is_gnre_header-num_guia
                                                hr_valor      = is_gnre_header-vlrtot
                                                itemguia      = is_gnre_header-docguia
                                                cod_barras    = is_gnre_header-brcde_guia
                                                cod_barras_dv = is_gnre_header-ldig_guia
                                                codaut        = is_gnre_header-codaut_guia
                                                faedt         = is_gnre_header-faedt
                                                dtpgto        = is_gnre_header-dtpgto
                                                vlrpago       = is_gnre_header-vlrpago  ).

    CONCATENATE gs_j_1bnfe_active-regio
                gs_j_1bnfe_active-nfyear
                gs_j_1bnfe_active-nfmonth
                gs_j_1bnfe_active-stcd1
                gs_j_1bnfe_active-model
                gs_j_1bnfe_active-serie
                gs_j_1bnfe_active-nfnum9
                gs_j_1bnfe_active-docnum9
                gs_j_1bnfe_active-cdv
           INTO ls_gnre_campos-acckey.

    SELECT SINGLE
           hbkid
      FROM bseg
      INTO lv_hbkid
      WHERE bukrs = is_gnre_header-bukrs_doc
        AND belnr = is_gnre_header-belnr
        AND gjahr = is_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    IF sy-subrc IS INITIAL.

      SELECT SINGLE
             bankl
        FROM t012
        INTO ls_gnre_campos-bankl
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

      SELECT SINGLE
             bankn
             bkont
        FROM t012k
        INTO ( ls_gnre_campos-bankn, ls_gnre_campos-bkont )
        WHERE bukrs = is_gnre_header-bukrs_doc
          AND hbkid = lv_hbkid.

    ENDIF.

    DATA(lt_itens_gnre) = VALUE zctgsd_gnrec001( FOR <fs_s_gnre_item> IN gt_gnre_item WHERE ( docguia = is_gnre_header-docguia )
                                             ( <fs_s_gnre_item> ) ).

    IF lt_itens_gnre IS NOT INITIAL.
      ASSIGN lt_itens_gnre[ 1 ] TO FIELD-SYMBOL(<fs_s_item_gnre>).
      ls_gnre_campos-it_convenio = <fs_s_item_gnre>-convenio.
      ls_gnre_campos-it_produto  = <fs_s_item_gnre>-produto.
      ls_gnre_campos-it_receita  = <fs_s_item_gnre>-receita.
      ls_gnre_campos-itemguia    = lines( lt_itens_gnre ).
    ENDIF.

    CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
      EXPORTING
        formname           = gc_smartforms-gnre_sp
      IMPORTING
        fm_name            = lv_smartforms_fm_name
      EXCEPTIONS
        no_form            = 1
        no_function_module = 2
        OTHERS             = 3.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

    IF iv_pdf = abap_true.
      ls_control_parameters-no_dialog = abap_true.
      ls_control_parameters-getotf    = abap_true.
    ENDIF.

    CALL FUNCTION lv_smartforms_fm_name
      EXPORTING
        control_parameters = ls_control_parameters
        zgnre_campos       = ls_gnre_campos
        gs_zgnret001       = is_gnre_header
      IMPORTING
        job_output_info    = ls_job_output_info
      TABLES
        zitens_gnre        = lt_itens_gnre
      EXCEPTIONS
        formatting_error   = 1
        internal_error     = 2
        send_error         = 3
        user_canceled      = 4
        OTHERS             = 5.

    IF sy-subrc <> 0 AND sy-subrc <> 4.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ELSEIF iv_pdf = abap_true.
      generate_pdf( iv_path    = iv_path
                    iv_compl   = |GUIA_{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-branch }-{ gs_j_1bnfdoc-regio }-{ is_gnre_header-docguia ALPHA = OUT }|
                    it_otfdata = ls_job_output_info-otfdata[] ).
    ENDIF.

  ENDMETHOD.


  METHOD print_nf.

* LSCHEPP - SD - 8000007861 - Impressão de guia GNRE e NF - 29.05.2023 Início
    DATA: lv_pdf_nfe  TYPE char1,
          lv_buf_id   TYPE indx_srtfd,
          lv_file     TYPE xstring,
          lv_filesize TYPE int4.

    DATA: lt_otf TYPE tsfotf,
          lt_pdf TYPE tline_t.


    " Import no report ZNFE_PRINT_DANFE
    lv_pdf_nfe = abap_true.
    lv_buf_id = 'NFE_PDF_' && gs_j_1bnfdoc-docnum.
    EXPORT lv_pdf_nfe = lv_pdf_nfe TO MEMORY ID lv_buf_id.

    CALL FUNCTION 'ZFMSD_GET_DANFE_PDF'
      EXPORTING
        iv_docnum            = gs_j_1bnfdoc-docnum
      IMPORTING
        et_file              = lt_pdf
        ev_filesize          = lv_filesize
        ev_file              = lv_file
      TABLES
        et_otf               = lt_otf
      EXCEPTIONS
        document_not_found   = 1
        nfe_not_approved     = 2
        nfe_not_printed      = 3
        conversion_exception = 4
        print_program_error  = 5
        OTHERS               = 6.

    IF sy-subrc EQ 0.
      generate_pdf( iv_path    = iv_path
                    iv_compl   = |{ gs_j_1bnfdoc-docnum }|
                    it_otfdata = lt_otf[] ).
    ENDIF.

*    DATA: lt_bdcdata TYPE TABLE OF bdcdata,
*          lt_bdcmsg  TYPE TABLE OF bdcmsgcoll,
*          lv_mode    TYPE c VALUE 'N',
*          lv_msg     TYPE ztsd_gnret003-desc_st_guia,
*          lv_objeto  TYPE seqg3-garg,
*          lv_subrc   TYPE sy-subrc,
*          lv_tabix   TYPE sy-tabix,
*          lt_enq     TYPE TABLE OF seqg7,
*          lv_while   TYPE c.
*
*    DEFINE _bdc_dynpro.
*      APPEND VALUE #( program  = &1
*                      dynpro   = &2
*                      dynbegin = 'X' ) TO lt_bdcdata.
*    END-OF-DEFINITION.
*
*    DEFINE _bdc_field.
*      APPEND VALUE #( fnam = &1
*                      fval = &2 ) TO lt_bdcdata.
*    END-OF-DEFINITION.
*
*    IF gs_j_1bnfdoc-printd = abap_true.
*
*      _bdc_dynpro 'SAPMJ1B1'           '1100'.
*      _bdc_field: 'BDC_OKCODE'         '=REPR',
*                  'J_1BDYDOC-DOCNUM'   gv_docnum.
*
*      _bdc_dynpro 'SAPLSPO1'           '0100'.
*      _bdc_field  'BDC_OKCODE'         '=YES'.
*
*    ENDIF.
*
*    _bdc_dynpro 'SAPMJ1B1'           '1100'.
*    _bdc_field: 'BDC_OKCODE'         '=OUTP',
*                'J_1BDYDOC-DOCNUM'   gv_docnum.
*
*    EXPORT p1 = iv_pdf              TO MEMORY ID 'ZNFE_PRINT_MANUAL_B_PDF'.
*    EXPORT p1 = iv_path             TO MEMORY ID 'ZNFE_PRINT_MANUAL_B_FILE'.
*    EXPORT p1 = gs_j_1bnfdoc-docnum TO MEMORY ID 'ZNFE_PRINT_MANUAL_B_DOCNUM'.
*
*    CALL TRANSACTION  'J1B3N'
*               WITH AUTHORITY-CHECK
*               USING  lt_bdcdata
*               MODE   lv_mode
*               UPDATE 'S'
*               MESSAGES INTO lt_bdcmsg.
*
*    lv_objeto = |{ sy-mandt }{ gs_j_1bnfdoc-docnum }|.
*
*    WHILE lv_while IS INITIAL.
*      CALL FUNCTION 'ENQUE_READ2'
*        EXPORTING
*          gclient = sy-mandt
*          gname   = 'J_1BNFDOC'
*          garg    = lv_objeto
*          guname  = sy-uname
*        IMPORTING
*          number  = lv_tabix
*          subrc   = lv_subrc
*        TABLES
*          enq     = lt_enq.
*      IF lt_enq[] IS INITIAL.
*        lv_while = 'X'.
*      ENDIF.
*    ENDWHILE.
*
*    FREE MEMORY ID 'ZNFE_PRINT_MANUAL_B_PDF'.
*    FREE MEMORY ID 'ZNFE_PRINT_MANUAL_B_FILE'.
*    FREE MEMORY ID 'ZNFE_PRINT_MANUAL_B_DOCNUM'.

* LSCHEPP - SD - 8000007933 - 8000007861 - Impressão de guia GNRE e NF - 29.05.2023 Fim

  ENDMETHOD.


  METHOD print_comprovante_pagamento.
*    IF ( is_gnre_header-tpprocess = zclsd_gnre_automacao=>gc_tpprocess-automatico ).
    SELECT SINGLE
     hbkid,
     lifnr,
     zlsch
    FROM bseg
    INTO @DATA(ls_vendor_payment)
    WHERE bukrs = @is_gnre_header-bukrs_doc
      AND belnr = @is_gnre_header-belnr
      AND gjahr = @is_gnre_header-gjahr
      AND shkzg = 'H'
      AND koart = 'K'.

    CHECK sy-subrc IS INITIAL.

    DATA(ls_fields_comprovante) = VALUE zsfi_comprov_pagto_chave(
       empresa              =  is_gnre_header-bukrs_doc
       fatura               =  is_gnre_header-belnr
       doccontabauxiliar    =  is_gnre_header-augbl
       exerciciocompensacao =  is_gnre_header-auggj
       bancoempresa         =  ls_vendor_payment-hbkid
       formapagto           =  ls_vendor_payment-zlsch
       fornecedor           =  ls_vendor_payment-lifnr
    ).

    NEW zclfi_comprovante_pagamento( )->gerar_comprovante(
      EXPORTING
        iv_print_dialog    = COND #( WHEN iv_pdf = abap_true THEN abap_false ELSE abap_true )
        is_campos_chave    = ls_fields_comprovante
      IMPORTING
        ev_comprovante     = DATA(lv_pdf_str)
        et_comprovante_tab = DATA(lt_pdf_data)
    ).

    IF iv_pdf = abap_true.
      DATA(lv_strlen) = xstrlen( lv_pdf_str ).
* LSCHEPP - SD - 8000007861 - Impressão de guia GNRE e NF - 26.05.2023 Início
      IF NOT lv_strlen IS INITIAL.
* LSCHEPP - SD - 8000007861 - Impressão de guia GNRE e NF - 26.05.2023 Fim
        me->generate_pdf(
            iv_path    = iv_path
            iv_compl   = |COMPROVANTE_MULTIBANCOS_{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-branch }-{ gs_j_1bnfdoc-regio }-{ is_gnre_header-docguia ALPHA = OUT }|
            iv_pdfsize = lv_strlen
            it_pdfdata = lt_pdf_data
        ).
* LSCHEPP - SD - 8000007861 - Impressão de guia GNRE e NF - 26.05.2023 Início
      ENDIF.
* LSCHEPP - SD - 8000007861 - Impressão de guia GNRE e NF - 26.05.2023 Fim
    ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD process.

    rv_continue = abap_false.

    LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>) WHERE docguia IN ir_docguia.

      DATA(lv_continue) = execute_from_step( CHANGING cs_gnre_header = <fs_s_gnre_header> ).

      IF lv_continue = abap_true.
        rv_continue = abap_true.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD process_values_fcp.

    "Processa os impostos de FCP
    LOOP AT gt_j_1bnfstx ASSIGNING FIELD-SYMBOL(<fs_s_j_1bnfstx>) WHERE subdivision = '003'
                                                                    OR  subdivision = '004'.

      ASSIGN gt_ztsd_gnre_config[ taxtyp = <fs_s_j_1bnfstx>-taxtyp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).
      CHECK sy-subrc IS INITIAL.

      add_to_calc_log( CORRESPONDING #( <fs_s_j_1bnfstx> ) ).

      es_ztsd_gnre_config = <fs_s_zgnre_config>.

      ev_taxtyp = <fs_s_j_1bnfstx>-taxtyp.
      ev_taxval = ev_taxval + <fs_s_j_1bnfstx>-taxval.

      ev_found_fcp = abap_true.

    ENDLOOP.

  ENDMETHOD.


  METHOD process_values_icms.

    "Processa os impostos de ICMS
    LOOP AT gt_j_1bnfstx ASSIGNING FIELD-SYMBOL(<fs_s_j_1bnfstx>) WHERE subdivision <> '003'
                                                                    AND subdivision <> '004'.

      ASSIGN gt_ztsd_gnre_config[ taxtyp = <fs_s_j_1bnfstx>-taxtyp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).
      CHECK sy-subrc IS INITIAL.

      add_to_calc_log( CORRESPONDING #( <fs_s_j_1bnfstx> ) ).

      es_ztsd_gnre_config = <fs_s_zgnre_config>.

      ev_taxtyp = <fs_s_j_1bnfstx>-taxtyp.
      ev_taxval = ev_taxval + <fs_s_j_1bnfstx>-taxval.

      ev_found_icms = abap_true.

    ENDLOOP.

  ENDMETHOD.


  METHOD reprocess.

    DATA: lt_errors  TYPE zcxsd_gnre_automacao=>ty_t_errors.

    LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>) WHERE docguia IN ir_docguia.

      TRY.
          DATA(lv_step) = <fs_s_gnre_header>-step.

          check_change_step_reprocess( CHANGING cs_gnre_header = <fs_s_gnre_header> ).

          execute_from_step( EXPORTING iv_step        = lv_step
                              CHANGING cs_gnre_header = <fs_s_gnre_header> ).

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_errors = lt_errors.
    ENDIF.

  ENDMETHOD.


  METHOD select_config_data.

    DATA(lv_consumo) = is_final_consumer( ).

    "Obtêm o tipo de guia
    SELECT SINGLE *
      FROM ztsd_gnret005
      INTO gs_ztsd_gnret005
      WHERE shipfrom = gs_j_1bnfdoc-regio_branch
        AND shipto   = gs_j_1bnfdoc-regio
        AND consumo  = lv_consumo.

    IF sy-subrc IS NOT INITIAL.
      SELECT SINGLE *
        FROM ztsd_gnret005
        INTO gs_ztsd_gnret005
        WHERE shipfrom = space
          AND shipto   = gs_j_1bnfdoc-regio
          AND consumo  = lv_consumo.
    ENDIF.

    "Obtêm os dados fiscais para a guia
    SELECT *
      FROM ztsd_gnre_config
      INTO TABLE gt_ztsd_gnre_config
      WHERE regio = gs_j_1bnfdoc-regio.

    SELECT *
      FROM ztsd_gnret015
      INTO TABLE gt_ztsd_gnret015
     WHERE parametro IN (gc_price-difal,
                         gc_price-st,
                         gc_price-email,
                         gc_price-fdifal,
                         gc_price-fst).

  ENDMETHOD.


  METHOD select_gnre_data.

    DATA lv_msgv1 TYPE msgv1.

    lv_msgv1 = gv_docnum.

    SELECT *
  FROM ztsd_gnret001
  INTO TABLE gt_gnre_header
  WHERE docnum = gv_docnum.

    IF sy-subrc IS NOT INITIAL.
      "A Nota & não está em processamento.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_nf_is_not_in_process
          iv_msgv1  = lv_msgv1.
    ENDIF.

    SELECT *
      FROM ztsd_gnret002
      INTO TABLE gt_gnre_item
      WHERE docnum = gv_docnum.

    SELECT *
      FROM ztsd_gnret003
      INTO TABLE gt_gnre_log
      WHERE docnum = gv_docnum.

    SELECT *
      FROM ztsd_gnret004
      INTO TABLE gt_gnre_calc_log
      WHERE docnum = gv_docnum.

  ENDMETHOD.


  METHOD select_nf_data.

    DATA lv_msgv1 TYPE msgv1.
    lv_msgv1 = gv_docnum.

    TYPES:
      BEGIN OF ty_s_j_1bnfcpd,
        name1      TYPE j_1bnfcpd-name1,
        ort01      TYPE j_1bnfcpd-ort01,
        regio      TYPE j_1bnfcpd-regio,
        stcd1      TYPE j_1bnfcpd-stcd1,
        stcd2      TYPE j_1bnfcpd-stcd2,
        taxjurcode TYPE j_1bnfcpd-taxjurcode,
      END OF ty_s_j_1bnfcpd.

    DATA: lr_taxsit    TYPE RANGE OF j_1bnflin-taxsit,
          ls_j_1bnfcpd TYPE ty_s_j_1bnfcpd.

    SELECT SINGLE
           j_1bnfdoc~docnum
           j_1bnfdoc~direct
           j_1bnfdoc~docdat
           j_1bnfdoc~bukrs
           j_1bnfdoc~branch
           j_1bnfdoc~nfesrv
           j_1bnfdoc~regio
           j_1bnfdoc~ind_iedest
           j_1bnfdoc~ind_final
           j_1bnfdoc~id_dest
           j_1bnfdoc~cgc
           j_1bnfdoc~cpf
           j_1bnfdoc~name1
           j_1bnfdoc~txjcd
           j_1bnfdoc~cnpj_bupla
           j_1bnfdoc~ie_bupla
           j_1bnfdoc~nfenum
           j_1bnfdoc~series
           j_1bnfdoc~authdate
           j_1bnfdoc~nftype
           j_1bnfdoc~parvw
           j_1bnfdoc~parid
           j_1bnfdoc~parxcpdk
           j_1bnfdoc~partyp
           j_1bnfdoc~printd
           j_1bnfdoc~ort01
           j_1bnfdoc~authtime
           j_1bnfdoc~stains
* LSCHEPP - SD - 8000007642 - GNRE DUA-ES, Codigo de barras incorreto - 29.05.2023 Início
           j_1bnfdoc~waerk
* LSCHEPP - SD - 8000007642 - GNRE DUA-ES, Codigo de barras incorreto - 29.05.2023 Fim
           adrc~region
      FROM j_1bnfdoc
      INNER JOIN j_1bbranch
        ON ( j_1bbranch~bukrs  = j_1bnfdoc~bukrs
        AND  j_1bbranch~branch = j_1bnfdoc~branch )
      INNER JOIN adrc
        ON ( adrc~addrnumber = j_1bbranch~adrnr )
      INTO gs_j_1bnfdoc
      WHERE docnum = gv_docnum.

    IF sy-subrc IS NOT INITIAL.

      "Nota fiscal & não foi encontrada
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_nf_not_found
          iv_msgv1  = lv_msgv1.

      "A conta é uma conta ocasional?
    ELSEIF gs_j_1bnfdoc-parxcpdk = abap_true.

      "Obtêm os dados da conta ocasional
      SELECT SINGLE
             name1
             ort01
             regio
             stcd1      AS cgc
             stcd2      AS cpf
             taxjurcode AS txjcd
        FROM j_1bnfcpd
        INTO ls_j_1bnfcpd
        WHERE docnum = gs_j_1bnfdoc-docnum
          AND parvw  = gs_j_1bnfdoc-parvw.

      gs_j_1bnfdoc-name1 = ls_j_1bnfcpd-name1.
      gs_j_1bnfdoc-ort01 = ls_j_1bnfcpd-ort01.
      gs_j_1bnfdoc-regio = ls_j_1bnfcpd-regio.
      gs_j_1bnfdoc-cgc   = ls_j_1bnfcpd-stcd1.
      gs_j_1bnfdoc-cpf   = ls_j_1bnfcpd-stcd2.
      gs_j_1bnfdoc-txjcd = ls_j_1bnfcpd-taxjurcode.

    ENDIF.

    IF gs_j_1bnfe_active IS INITIAL.
      SELECT SINGLE *
        FROM j_1bnfe_active
        INTO gs_j_1bnfe_active
        WHERE docnum = gv_docnum.
    ENDIF.

    SELECT j_1bnflin~docnum
         , j_1bnflin~itmnum
         , j_1bnflin~matnr
         , j_1bnflin~matorg
         , j_1bnflin~taxsit
         , j_1bnflin~matkl
         , j_1bnflin~werks
         , j_1bnflin~nfnet
         , j_1bnflin~nfnett
         , j_1bnflin~menge
         , j_1bnflin~meins
      FROM j_1bnflin
      LEFT JOIN ztsd_gnret008
        ON ( ztsd_gnret008~nftype = @space
        AND  ztsd_gnret008~cfop   = j_1bnflin~cfop )
      INTO TABLE @gt_j_1bnflin
      WHERE j_1bnflin~docnum =  @gs_j_1bnfdoc-docnum
        AND j_1bnflin~taxsit IN @lr_taxsit
        AND ztsd_gnret008~cfop   IS NULL. "Remove os itens com o CFOP cadastrado na tabela ZGNRET008

    IF sy-subrc IS INITIAL.
      SELECT j_1bnfstx~docnum
             j_1bnfstx~itmnum
             j_1bnfstx~taxtyp
             j_1bnfstx~base
             j_1bnfstx~rate
             j_1bnfstx~taxval
             j_1bnfstx~excbas
             j_1bnfstx~othbas
             j_1bnfstx~taxgrp
             j_1baj~subdivision
        FROM j_1bnfstx
        INNER JOIN j_1baj
          ON ( j_1baj~taxtyp = j_1bnfstx~taxtyp )
        INTO TABLE gt_j_1bnfstx
        FOR ALL ENTRIES IN gt_j_1bnflin
        WHERE j_1bnfstx~docnum = gt_j_1bnflin-docnum
          AND j_1bnfstx~itmnum = gt_j_1bnflin-itmnum.
    ENDIF.

  ENDMETHOD.


  METHOD send_email.

    DATA: ls_message TYPE bapiret2.

    DATA(lv_tipo) = iv_tipo.
    IF lv_tipo IS INITIAL.
      lv_tipo = 'RAW'.
    ENDIF.

    TRY.
        " Cria o e-mail
        DATA(lo_email) = cl_bcs=>create_persistent( ).

        IF iv_mime IS INITIAL.
          " Cria o corpo do e-mail
          DATA(lo_corpo_email) = cl_document_bcs=>create_document( i_type    = lv_tipo
                                                                   i_text    = iv_conteudo
                                                                   i_subject = iv_assunto ).
        ELSE.
          "Cria corpo do e-mail com anexos mime (Ex.: Imagem de assinatura).

          lo_corpo_email = cl_document_bcs=>create_from_multirelated( i_subject          = iv_assunto
                                                                      i_multirel_service = iv_mime ).
        ENDIF.

        " Vincula o corpo do e-mail ao e-mail.
        lo_email->set_document( lo_corpo_email ).

        " Determina o remetente do e-mail.
        IF iv_remetente IS NOT INITIAL.
          DATA(lo_remetente) = cl_cam_address_bcs=>create_internet_address( iv_remetente ).
          lo_email->set_sender( lo_remetente ).
        ELSE.
          DATA lv_copia_para TYPE sy-uname.
          IF iv_remetente_uname IS NOT INITIAL.
            lv_copia_para = iv_remetente_uname.
          ELSE.
            lv_copia_para = sy-uname.
          ENDIF.

          DATA(lo_remetente_u) = cl_sapuser_bcs=>create( lv_copia_para ).
          lo_email->set_sender( i_sender = lo_remetente_u ).
        ENDIF.

**********************************************************************
*       " Gera destinatários de email através do endereço de email
**********************************************************************
        LOOP AT iv_destinatarios ASSIGNING FIELD-SYMBOL(<fs_destinatarios>).
          IF <fs_destinatarios> IS NOT INITIAL.
            DATA(lo_destinatario) = cl_cam_address_bcs=>create_internet_address( <fs_destinatarios> ).

            lo_email->add_recipient(
              EXPORTING
                i_recipient = lo_destinatario
                i_express   = 'X' ) .
          ENDIF.
        ENDLOOP.

**********************************************************************
*       " Gera emails em cópia pelo endereço de email
**********************************************************************
        LOOP AT iv_destinatarios_cc ASSIGNING FIELD-SYMBOL(<fs_destinatarios_cc>).
          IF <fs_destinatarios_cc> IS ASSIGNED.
            DATA(lo_reply_dest) = cl_cam_address_bcs=>create_internet_address( <fs_destinatarios_cc> ).

            lo_email->set_reply_to( i_reply_to = lo_reply_dest ).
          ENDIF.
        ENDLOOP.

**********************************************************************
*       " Gera destinatários de email através do SY-UNAME.
**********************************************************************
        LOOP AT iv_uname_destinatarios ASSIGNING FIELD-SYMBOL(<fs_uname_destinatarios>).
          IF <fs_uname_destinatarios>-low IS ASSIGNED.
            DATA(lo_destinatario_u) = cl_sapuser_bcs=>create( <fs_uname_destinatarios>-low ).

            lo_email->add_recipient(
              EXPORTING
                i_recipient = lo_destinatario_u
                i_express   = 'X' ).
          ENDIF.
        ENDLOOP.

**********************************************************************
*       " Gera emails em cópia pelo SY_UNAME
**********************************************************************
        LOOP AT iv_uname_copia ASSIGNING FIELD-SYMBOL(<fs_copia_para>).
          IF <fs_copia_para>-low IS NOT INITIAL.
            DATA(lo_reply_u) = cl_sapuser_bcs=>create( <fs_copia_para>-low ).

            lo_email->set_reply_to( i_reply_to = lo_reply_u ).
          ENDIF.
        ENDLOOP.

*       " Realiza o envio do e-mail
        lo_email->set_send_immediately( abap_true ).
        DATA(lv_email_enviado) = lo_email->send( ).

*       " Em caso de sucesso, conclui o envio - Deve ser executado fora do método.
        IF NOT iv_commit IS INITIAL AND NOT lv_email_enviado IS INITIAL.
          COMMIT WORK.
        ENDIF.

      CATCH cx_gbt_mime INTO DATA(lo_cx_gbt_mime).
      CATCH cx_bcom_mime INTO DATA(lo_cx_bcom_mime).
      CATCH cx_bcs INTO DATA(lo_cx_bcs).
        ls_message-id         = lo_cx_bcs->msgid.
        ls_message-type       = lo_cx_bcs->msgty.
        ls_message-number     = lo_cx_bcs->msgno.
        ls_message-message_v1 = lo_cx_bcs->msgv1.
        ls_message-message_v2 = lo_cx_bcs->msgv2.
        ls_message-message_v3 = lo_cx_bcs->msgv3.
        ls_message-message_v4 = lo_cx_bcs->msgv4.
        RAISE EXCEPTION TYPE cx_idm_error EXPORTING message = ls_message.
    ENDTRY.
  ENDMETHOD.


  METHOD send_email_price.

    DATA: lt_body TYPE bcsy_text,
          lt_hdr  LIKE me->gt_gnre_header,
          lv_vlr  LIKE me->gs_gnre_header-vlrtot.
    SET COUNTRY 'BR'.

    CONSTANTS: lc_texto1(100) TYPE c VALUE 'Existe(m) guia(s) criada(s) aguardando validação de preço no monitor GNRE. Favor verificar:'.

    lt_hdr[] = me->gt_gnre_header[].
    IF lt_hdr IS INITIAL.
      IF NOT me->gs_gnre_header IS INITIAL.
        APPEND me->gs_gnre_header TO lt_hdr.
      ELSE.
        RETURN.
      ENDIF.
    ENDIF.
    APPEND VALUE #( line = '<html><body>' ) TO lt_body.
    APPEND VALUE #( line = 'Olá' ) TO lt_body.
    APPEND VALUE #( line = '<p>' ) TO lt_body.
    APPEND VALUE #( line = lc_texto1 ) TO lt_body.
    APPEND VALUE #( line = '<br>' ) TO lt_body.
    LOOP AT lt_hdr ASSIGNING FIELD-SYMBOL(<fs_hdr>).
      APPEND VALUE #( line = |<b>Spool:</b> { <fs_hdr>-docnum }| ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
      APPEND VALUE #( line = |<b>Local de Negócios:</b> { <fs_hdr>-branch }| ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
      APPEND VALUE #( line = |<b>N° Interno de Guia:</b> { <fs_hdr>-docguia }| ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
      APPEND VALUE #( line = |<b>Valor da Guia gerada:</b> { <fs_hdr>-vlrtot }| ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
      APPEND VALUE #( line = |<b>Criada em:</b> { <fs_hdr>-credat DATE = ENVIRONMENT } às {
                                                  <fs_hdr>-cretim TIME = ENVIRONMENT }| ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
      APPEND VALUE #( line = '<br>' ) TO lt_body.
    ENDLOOP.
    APPEND VALUE #( line = '</body></html>' ) TO lt_body.

    READ TABLE gt_ztsd_gnret015 INTO DATA(ls_gnre015) WITH KEY parametro = gc_price-email.
    IF sy-subrc EQ 0.
      TRY.
          zclsd_gnre_automacao=>send_email(  iv_assunto             = CONV so_obj_des( TEXT-t01 ) "GNRE - Validar Guia com Valor Muito Alto
                                           iv_conteudo            = lt_body
                                           iv_destinatarios       = VALUE #( ( ls_gnre015-valor ) )
                                           iv_remetente           = 'gnre-no-reply@3coracoes.com.br'
                                           iv_commit              = abap_true
                                           iv_tipo                = 'HTM' ).
        CATCH cx_idm_error INTO DATA(lo_cx_idm_error).    "
      ENDTRY.
    ELSE.

    ENDIF.

  ENDMETHOD.


  METHOD set_cancel.

    LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>).

      "Etapa: NF-e Cancelada
      set_step( iv_docguia = <fs_s_gnre_header>-docguia
                iv_step    = gc_step-nfe_cancelada ).

    ENDLOOP.

  ENDMETHOD.


  METHOD set_step.

    GET TIME.

    "Atualiza a etapa de acordo com o docguia
    ASSIGN gt_gnre_header[ docguia = iv_docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
    IF sy-subrc IS INITIAL.

      <fs_s_gnre_header>-step = iv_step.

      add_to_log( iv_docguia      = <fs_s_gnre_header>-docguia
                  iv_step         = <fs_s_gnre_header>-step
                  iv_newdoc       = iv_newdoc
                  iv_status_guia  = iv_status_guia
                  iv_desc_st_guia = iv_desc_st_guia            ).

    ELSE.

      gs_gnre_header-step = iv_step.

      add_to_log( iv_docguia      = gs_gnre_header-docguia
                  iv_step         = gs_gnre_header-step
                  iv_newdoc       = iv_newdoc
                  iv_status_guia  = iv_status_guia
                  iv_desc_st_guia = iv_desc_st_guia            ).

    ENDIF.

  ENDMETHOD.


  METHOD validate_price.

    DATA: lv_vlr     TYPE ze_gnre_vlrtot_guia,
          lr_status  TYPE RANGE OF ztsd_gnret001-status_guia,
          lv_process TYPE flag,
          ls_header  TYPE ztsd_gnret001.
    CLEAR: rv_return, me->gv_price.
    "Verifica os valores do header.
    IF me->gs_gnre_header IS INITIAL AND NOT me->gt_gnre_header IS INITIAL.
      READ TABLE me->gt_gnre_header INTO ls_header INDEX 1.
    ELSE.
      ls_header = me->gs_gnre_header.
    ENDIF.
    "Agrupa os status sensíveis ao processamento da validação de preço.
    lr_status =  VALUE #( sign = 'I' option = 'EQ'
                          ( low = '' )
                          ( low = '003' )
                          ( low = 'E04' )
                          ( low = 'E05' )
                          ( low = 'E06' )
                          ( low = '501' ) ).
    SORT lr_status ASCENDING BY sign option low.
    "Verifica se o Step anterior foi informado.
    IF iv_step_old IS SUPPLIED.
      IF iv_step_old IS INITIAL OR ls_header-status_guia IS INITIAL.
        DELETE lr_status WHERE low = ''.
      ENDIF.
      "Verifica se o Step anterior é sensível à validação de preço.
      IF iv_step_old IN lr_status.
        lv_process = abap_true.
      ENDIF.
    ELSE. "Usa o step atual caso anterior não tenha sido informado.
      "Verifica se o Step atual é sensível à validação de preço.
      IF me->gs_gnre_header-status_guia IN lr_status.
        lv_process = abap_true.
      ENDIF.
    ENDIF.
    "Só executa a validação de preço para alguns status específicos.
    IF NOT lv_process IS INITIAL.
      "Busca o valor total do documento fiscal (podendo ser várias GUIAS).
      DATA(lv_vlr_tot) = get_total_value_nf( iv_docnum = iv_docnum ).
      "Identifica se é consumidor ou contribuinte.
      IF iv_consumo IS INITIAL. "Contribuinte.
        DATA(lv_par) = gc_price-st.
        "Verifica se é uma guida de frete.
        IF NOT iv_frete IS INITIAL.
          lv_par = gc_price-fst.
        ENDIF.
      ELSE. "Consumidor.
        lv_par = gc_price-difal.
        "Verifica se é uma guida de frete.
        IF NOT iv_frete IS INITIAL.
          lv_par = gc_price-fdifal.
        ENDIF.
      ENDIF.
      "Lê os limites dos valores para cada tipo de registro de NF.
      READ TABLE gt_ztsd_gnret015 INTO DATA(ls_gnre015) WITH KEY parametro = lv_par.
      IF sy-subrc EQ 0.
        DATA(lv_value) = ls_gnre015-valor.
        REPLACE ALL OCCURRENCES OF '.' IN lv_value WITH ''.
        TRANSLATE lv_value USING ',.'.
        lv_vlr = lv_value.
      ENDIF.
      "Verifica se o valor total é maior que o limite automático.
      "Verificação será feita, apnas se existir valor na configuração.
      IF lv_vlr_tot GE lv_vlr AND lv_vlr > 0.
        me->gv_price = rv_return = abap_true.
        "Verifica se a estrutrua header da guia está preenchida.
        IF NOT me->gs_gnre_header IS INITIAL.
          "Atribui o STEP com erro.
          me->gs_gnre_header-step = gc_step-guia_valor_muito_alto.
          "Verifica se a guia já está na tabela
          ASSIGN me->gt_gnre_header[ docguia = me->gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_hdr>).
          IF NOT sy-subrc IS INITIAL.
            me->gs_gnre_header-docguia = 1.
            APPEND me->gs_gnre_header TO me->gt_gnre_header.
          ENDIF.
          LOOP AT me->gt_gnre_header ASSIGNING <fs_s_gnre_hdr>.
            "Etapa: Não foi possivel determinar o tipo de guia.
            set_step( iv_docguia = <fs_s_gnre_hdr>-docguia
                      iv_step    = gc_step-guia_valor_muito_alto ).
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD generate_pdf.

    DATA: lt_tab_archive  TYPE STANDARD TABLE OF docs,
          lt_tlines       TYPE STANDARD TABLE OF tline,
          lv_bin_filesize TYPE i,
          lv_window_title TYPE string,
          lv_file_name    TYPE string,
          lv_file_path    TYPE string,
          lv_full_path    TYPE string,
          lv_action       TYPE i,
          lv_size         TYPE i,
          lt_bindata      TYPE solix_tab,
          lv_err_text     TYPE string,
          lv_mess         TYPE string,
          lv_myref        TYPE REF TO cx_sy_file_open_mode.

    IF ( it_pdfdata IS NOT INITIAL ).

      DATA(lv_xstring) = cl_bcs_convert=>solix_to_xstring(
                           it_solix = it_pdfdata ).

      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = lv_xstring
        IMPORTING
          output_length = lv_size
        TABLES
          binary_tab    = lt_bindata.

      LOOP AT it_pdfdata ASSIGNING FIELD-SYMBOL(<fs_pdf_data>).
        APPEND VALUE tline( tdline = <fs_pdf_data>-line ) TO lt_tlines.
      ENDLOOP.
      lv_bin_filesize = iv_pdfsize.
    ELSE.
      CALL FUNCTION 'CONVERT_OTF_2_PDF'
        IMPORTING
          bin_filesize           = lv_bin_filesize
        TABLES
          otf                    = it_otfdata[]
          doctab_archive         = lt_tab_archive[]
          lines                  = lt_tlines[]
        EXCEPTIONS
          err_conv_not_possible  = 1
          err_otf_mc_noendmarker = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            it_bapi_return = VALUE #( ( id         = sy-msgid
                                     type       = sy-msgty
                                     number     = sy-msgno
                                     message_v1 = sy-msgv1
                                     message_v2 = sy-msgv2
                                     message_v3 = sy-msgv3
                                     message_v4 = sy-msgv4 ) ).
      ENDIF.
    ENDIF.

    DATA(lv_strlen_path) = strlen( iv_path ) - 1.
    IF iv_path+lv_strlen_path(1) = '\'.
      DATA(lv_filename) = iv_path && iv_compl && '.pdf'.
    ELSE.
      lv_filename = iv_path && '\' && iv_compl && '.pdf'.
    ENDIF.

    CONDENSE lv_filename NO-GAPS.


    IF sy-batch EQ 'X'.

      TRY.

          OPEN DATASET lv_filename FOR OUTPUT IN BINARY MODE MESSAGE lv_mess.

          LOOP AT lt_tlines ASSIGNING FIELD-SYMBOL(<fs_lines>).
            TRANSFER <fs_lines> TO lv_filename.
          ENDLOOP.

          MESSAGE |Arquivo| && | { lv_filename } foi gerado.| TYPE 'S'.

        CATCH cx_sy_file_open_mode INTO lv_myref.

          lv_err_text = lv_myref->get_text( ).
          MESSAGE lv_err_text TYPE 'S'.
      ENDTRY.
      CLOSE DATASET lv_filename.

    ELSE.

      lv_file_name  = iv_compl.

      lv_window_title = TEXT-001.

      CALL METHOD cl_gui_frontend_services=>file_save_dialog
        EXPORTING
          window_title         = lv_window_title
          initial_directory    = 'C:\TEMP\'
          prompt_on_overwrite  = 'X'
          default_extension    = 'PDF'
          default_file_name    = lv_file_name
        CHANGING
          filename             = lv_file_name
          path                 = lv_file_path
          fullpath             = lv_full_path
          user_action          = lv_action
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.

      IF sy-subrc EQ 0.
        lv_filename = lv_full_path.
      ENDIF.

      IF it_pdfdata IS NOT INITIAL.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            bin_filesize            = lv_size
            filename                = lv_filename
            filetype                = 'BIN'
          TABLES
            data_tab                = lt_bindata[]
          EXCEPTIONS
            file_write_error        = 1
            no_batch                = 2
            gui_refuse_filetransfer = 3
            invalid_type            = 4
            no_authority            = 5
            unknown_error           = 6
            header_not_allowed      = 7
            separator_not_allowed   = 8
            filesize_not_allowed    = 9
            header_too_long         = 10
            dp_error_create         = 11
            dp_error_send           = 12
            dp_error_write          = 13
            unknown_dp_error        = 14
            access_denied           = 15
            dp_out_of_memory        = 16
            disk_full               = 17
            dp_timeout              = 18
            file_not_found          = 19
            dataprovider_exception  = 20
            control_flush_error     = 21
            OTHERS                  = 22.

      ELSE.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            bin_filesize            = lv_bin_filesize
            filename                = lv_filename
            filetype                = 'BIN'
          TABLES
            data_tab                = lt_tlines[]
          EXCEPTIONS
            file_write_error        = 1
            no_batch                = 2
            gui_refuse_filetransfer = 3
            invalid_type            = 4
            no_authority            = 5
            unknown_error           = 6
            header_not_allowed      = 7
            separator_not_allowed   = 8
            filesize_not_allowed    = 9
            header_too_long         = 10
            dp_error_create         = 11
            dp_error_send           = 12
            dp_error_write          = 13
            unknown_dp_error        = 14
            access_denied           = 15
            dp_out_of_memory        = 16
            disk_full               = 17
            dp_timeout              = 18
            file_not_found          = 19
            dataprovider_exception  = 20
            control_flush_error     = 21
            OTHERS                  = 22.

      ENDIF.

      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            it_bapi_return = VALUE #( ( id         = sy-msgid
                                     type       = sy-msgty
                                     number     = sy-msgno
                                     message_v1 = sy-msgv1
                                     message_v2 = sy-msgv2
                                     message_v3 = sy-msgv3
                                     message_v4 = sy-msgv4 ) ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD add_guia_compl.

    DATA lv_msgv1   TYPE msgv1.
    DATA lv_msgv2   TYPE msgv2.
    DATA lv_msgv2_2 TYPE msgv2.

    lv_msgv1 = gv_docnum.
    IF gs_j_1bnfe_active-docsta <> '1'.

      "Nota fiscal & não autorizada.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_nf_not_authorized
          iv_msgv1  = lv_msgv1.

    ELSEIF   iv_taxtyp_icms IS INITIAL     AND iv_taxtyp_fcp  IS INITIAL   OR
           ( iv_taxtyp_icms IS NOT INITIAL AND iv_taxval_icms IS INITIAL ) OR
           ( iv_taxtyp_fcp  IS NOT INITIAL AND iv_taxtyp_fcp  IS INITIAL ).

      "NFe &, favor informar valores de ICMS e/ou FCP.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_icms_fcp_not_informed
          iv_msgv1  = lv_msgv1.

    ELSEIF is_substitute_insc( ) = abap_true.

      "NFe &, Oper.Insc.Substituto (NIF Regional), contatar área fiscal!
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_operation_w_substitute_insc
          iv_msgv1  = lv_msgv1.

    ELSEIF gs_ztsd_gnret005 IS INITIAL.

      "NFe &, não foi possivel determinar o tipo de guia.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_not_able_to_determ_tpguia
          iv_msgv1  = lv_msgv1.

    ENDIF.

    IF iv_taxtyp_icms IS NOT INITIAL.
      lv_msgv2 = iv_taxtyp_icms.
      "Verifica se o imposto é ICMS
      SELECT COUNT( * )
        FROM j_1baj
        UP TO 1 ROWS
        WHERE taxtyp        =      @iv_taxtyp_icms
          AND taxgrp        IN     ('ICMS','ICST')
          AND ( subdivision NOT IN ('003','004')
          OR    subdivision IS NULL                ).
      IF sy-subrc IS NOT INITIAL.

        "NFe &, o tipo de imposto &, não é válido para o grupo &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_taxtyp_not_valid_for_group
            iv_msgv1  = lv_msgv1
            iv_msgv2  = lv_msgv2
            iv_msgv3  = 'ICMS'.

      ELSEIF NOT line_exists( gt_ztsd_gnre_config[ taxtyp = iv_taxtyp_icms ] ).

        "NFe &, não foi possivel determinar a receita para o tipo de imposto &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_for_taxtyp_reven_not_found
            iv_msgv1  = lv_msgv1
            iv_msgv2  = lv_msgv2.

      ENDIF.

    ENDIF.

    IF iv_taxtyp_fcp IS NOT INITIAL.
      lv_msgv2_2 = iv_taxtyp_fcp.
      "Verifica se o imposto é FCP
      SELECT COUNT(*)
        FROM j_1baj
         UP TO 1 ROWS
        WHERE taxtyp      =  @iv_taxtyp_fcp
          AND taxgrp      IN ('ICMS','ICST')
          AND subdivision IN ('003','004')
          AND subdivision IS NOT NULL.
      IF sy-subrc IS NOT INITIAL.

        "NFe &, o tipo de imposto &, não é válido para o grupo &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_taxtyp_not_valid_for_group
            iv_msgv1  = lv_msgv1
            iv_msgv2  = lv_msgv2_2
            iv_msgv3  = 'FCP'.

      ELSEIF NOT line_exists( gt_ztsd_gnre_config[ taxtyp = iv_taxtyp_fcp ] ).

        "NFe &, não foi possivel determinar a receita para o tipo de imposto &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_for_taxtyp_reven_not_found
            iv_msgv1  = lv_msgv1
            iv_msgv2  = lv_msgv2_2.

      ENDIF.

    ENDIF.

    gs_gnre_header = CORRESPONDING #( gs_j_1bnfdoc ).
    gs_gnre_header-tpprocess = gv_tpprocess.
    gs_gnre_header-consumo   = is_final_consumer( ).
    gs_gnre_header-guiacompl = abap_true.
    gs_gnre_header-tpguia    = gs_ztsd_gnret005-tpguia.
    gs_gnre_header-crenam    = sy-uname.
    gs_gnre_header-credat    = sy-datum.
    gs_gnre_header-cretim    = sy-uzeit.

    "Verica o modo de execução
    IF gs_ztsd_gnret005-modo = gc_modo_exec-manual.

      "Etapa: Operação Manual - Incluir Guia Manual
      gs_gnre_header-step = gc_step-operacao_manual.

    ELSEIF gs_ztsd_gnret005-modo = gc_modo_exec-desativado.

      "Etapa: Integração Desativada Manualmente
      gs_gnre_header-step = gc_step-integracao_desativada_manual.

    ELSE.

      "Etapa: Aguardando Envio
      gs_gnre_header-step = gc_step-aguardando_envio.

    ENDIF.

    "Para os casos de consumidor final, não há ZSUB
    IF gs_gnre_header-consumo = abap_true.
      gs_gnre_header-zsub = abap_false.
    ELSE.
      gs_gnre_header-zsub = COND #( WHEN line_exists( gt_gnre_header[ zsub = abap_true ] )
                                    THEN abap_true
                                    ELSE abap_false ).
    ENDIF.

    "Obtêm o próximo docguia
    SORT gt_gnre_header DESCENDING BY docguia.
    ASSIGN gt_gnre_header[ 1 ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
    IF sy-subrc IS INITIAL.
      gs_gnre_header-docguia = <fs_s_gnre_header>-docguia + 1.
    ELSE.
      gs_gnre_header-docguia = 1.
    ENDIF.

    IF iv_taxtyp_fcp IS NOT INITIAL.

      ASSIGN gt_ztsd_gnre_config[ taxtyp = iv_taxtyp_fcp ] TO FIELD-SYMBOL(<fs_s_zgnre_config>).

      APPEND CORRESPONDING #( gs_gnre_header ) TO gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>).
      MOVE-CORRESPONDING <fs_s_zgnre_config> TO <fs_s_gnre_item>.
      <fs_s_gnre_item>-itemguia = 1.
      <fs_s_gnre_item>-taxtyp   = iv_taxtyp_fcp.
      <fs_s_gnre_item>-taxval   = iv_taxval_fcp.

      gs_gnre_header-vlrtot = iv_taxval_fcp.

      IF gs_ztsd_gnret005-guia_por_receita = abap_true.

        APPEND gs_gnre_header TO gt_gnre_header.

        add_to_log( iv_docguia = gs_gnre_header-docguia
                    iv_step    = gs_gnre_header-step    ).

      ENDIF.

    ENDIF.

    IF iv_taxtyp_icms IS NOT INITIAL.

      ASSIGN gt_ztsd_gnre_config[ taxtyp = iv_taxtyp_icms ] TO <fs_s_zgnre_config>.

      APPEND CORRESPONDING #( gs_gnre_header ) TO gt_gnre_item ASSIGNING <fs_s_gnre_item>.
      MOVE-CORRESPONDING <fs_s_zgnre_config> TO <fs_s_gnre_item>.

      IF gs_ztsd_gnret005-guia_por_receita = abap_true.

        gs_gnre_header-vlrtot = iv_taxval_icms.

        APPEND gs_gnre_header TO gt_gnre_header ASSIGNING <fs_s_gnre_header>.

        IF iv_taxtyp_fcp IS NOT INITIAL.
          <fs_s_gnre_header>-docguia = <fs_s_gnre_header>-docguia + 1.
        ENDIF.

        <fs_s_gnre_item>-docguia  = <fs_s_gnre_header>-docguia.
        <fs_s_gnre_item>-itemguia = 1.
        <fs_s_gnre_item>-taxtyp   = iv_taxtyp_icms.
        <fs_s_gnre_item>-taxval   = iv_taxval_icms.

        add_to_log( iv_docguia = <fs_s_gnre_header>-docguia
                    iv_step    = <fs_s_gnre_header>-step    ).

      ELSE.

        <fs_s_gnre_item>-itemguia = 2.
        <fs_s_gnre_item>-taxtyp   = iv_taxtyp_icms.
        <fs_s_gnre_item>-taxval   = iv_taxval_icms.

        gs_gnre_header-vlrtot = gs_gnre_header-vlrtot + iv_taxval_icms.

      ENDIF.

    ENDIF.

    IF gs_ztsd_gnret005-guia_por_receita = abap_false.

      APPEND gs_gnre_header TO gt_gnre_header.

      add_to_log( iv_docguia = gs_gnre_header-docguia
                  iv_step    = gs_gnre_header-step    ).

    ENDIF.

  ENDMETHOD.


  METHOD add_guia_manual.

    DATA(lt_steps) = get_steps_guia_manual( ).
    DATA lv_msgv1     TYPE msgv1.
    DATA lv_msgv1_2   TYPE msgv1.
    DATA lv_msgv2     TYPE msgv2.

    lv_msgv1 = gv_docnum.
    lv_msgv2 = iv_docguia.

    ASSIGN gt_gnre_header[ docguia = iv_docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
    IF sy-subrc IS NOT INITIAL.

      "Para a Nota &, não foi encontrado o Nº interno de Guia &.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_docguia_not_found
          iv_msgv1  = lv_msgv1
          iv_msgv2  = lv_msgv2.

    ELSEIF NOT line_exists( lt_steps[ table_line = <fs_s_gnre_header>-step ] ).
      lv_msgv1_2 = <fs_s_gnre_header>-step.
      "A etapa & não permite a inclusão de guia manual.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_step_not_allow_for_guia_man
          iv_msgv1  = lv_msgv1_2.
    ENDIF.

    "Verifica se os campos foram informados
    IF iv_faedt IS INITIAL OR iv_num_guia IS INITIAL OR iv_ldig_guia IS INITIAL.

      "O preenchimento dos campos é obrigatório.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_empty_fields.

    ELSEIF iv_faedt < sy-datum.

      "A data de vencimento informada é inválida.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_invalid_due_date.

    ELSEIF strlen( iv_ldig_guia ) < 48.

      "A linha digitável deve conter 48 dígitos.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_ldig_guia_lt_48.

    ENDIF.

    "Etapa: Guia Criada - Aguardando Criação do Doc. FI
    set_step( iv_docguia = iv_docguia
              iv_step    = gc_step-guia_criada
              iv_newdoc  = <fs_s_gnre_header>-num_guia ).

    <fs_s_gnre_header>-faedt      = iv_faedt.
    <fs_s_gnre_header>-num_guia   = iv_num_guia.
    <fs_s_gnre_header>-ldig_guia  = iv_ldig_guia.
    <fs_s_gnre_header>-brcde_guia = iv_ldig_guia(11) && iv_ldig_guia+12(11) && iv_ldig_guia+24(11) && iv_ldig_guia+36(11).
    <fs_s_gnre_header>-credat     = sy-datum.
    <fs_s_gnre_header>-cretim     = sy-uzeit.
    <fs_s_gnre_header>-crenam     = sy-uname.
    <fs_s_gnre_header>-chadat     = sy-datum.
    <fs_s_gnre_header>-chatim     = sy-uzeit.
    <fs_s_gnre_header>-chanam     = sy-uname.
  ENDMETHOD.


  METHOD add_item_value.

    DATA: ls_gnre_item TYPE ztsd_gnret002,
          lv_item      TYPE ztsd_gnret002-itemguia.

    cs_gnre_header-vlrtot = cs_gnre_header-vlrtot + iv_taxval.

    MOVE-CORRESPONDING cs_gnre_header  TO ls_gnre_item.
    MOVE-CORRESPONDING iv_ztsd_gnre_config TO ls_gnre_item.
    ls_gnre_item-taxtyp = iv_taxtyp.
    ls_gnre_item-taxval = COND #( WHEN iv_taxval < 0 THEN 0 ELSE iv_taxval ).

    IF gs_ztsd_gnret005-guia_por_receita = abap_true.

      IF iv_replace_header = abap_false.
        cs_gnre_header-docguia = cs_gnre_header-docguia + 1.
      ENDIF.

      IF iv_replace_header = abap_true.
        ASSIGN gt_gnre_header[ docguia = cs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
        IF sy-subrc IS INITIAL.
          <fs_s_gnre_header> = cs_gnre_header.
          FREE: cs_gnre_header-vlrtot.
        ELSE.
          cs_gnre_header-docguia = cs_gnre_header-docguia + 1.
          APPEND cs_gnre_header TO gt_gnre_header.
          FREE: cs_gnre_header-vlrtot.
        ENDIF.

      ELSE.
        APPEND cs_gnre_header TO gt_gnre_header.
        FREE: cs_gnre_header-vlrtot.

      ENDIF.

      IF iv_taxval <= 0.
        "Etapa: Operação com Somatório dos Tributos Igual Zero
        set_step( iv_docguia = cs_gnre_header-docguia
                  iv_step    = gc_step-operacao_c_somatorio_trib_zero ).
      ENDIF.

      ls_gnre_item-itemguia = 1.
      ls_gnre_item-docguia  = cs_gnre_header-docguia.
      APPEND ls_gnre_item TO gt_gnre_item.
      FREE: ls_gnre_item.

    ELSE.

      cs_gnre_header-docguia = 1.

      LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>) WHERE docguia = cs_gnre_header-docguia.
        lv_item = lv_item + 1.
      ENDLOOP.

      ls_gnre_item-itemguia = lv_item + 1.
      ls_gnre_item-docguia  = cs_gnre_header-docguia.
      APPEND ls_gnre_item TO gt_gnre_item.
      FREE: ls_gnre_item-taxval.

    ENDIF.

  ENDMETHOD.


  METHOD add_manual_payment.

    DATA(lt_steps) = get_steps_manual_payment( ).
    DATA lv_msgv1     TYPE msgv1.
    DATA lv_msgv1_2   TYPE msgv1.
    DATA lv_msgv2     TYPE msgv2.

    lv_msgv1 = gv_docnum.
    lv_msgv2 = iv_docguia.

    ASSIGN gt_gnre_header[ docguia = iv_docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
    IF sy-subrc IS NOT INITIAL.

      "Para a Nota &, não foi encontrado o Nº interno de Guia &.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_docguia_not_found
          iv_msgv1  = lv_msgv1
          iv_msgv2  = lv_msgv2.

    ELSEIF NOT line_exists( lt_steps[ table_line = <fs_s_gnre_header>-step ] ).
      lv_msgv1_2 = <fs_s_gnre_header>-step.
      "A etapa & não permite a inclusão de pagamento manual.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_step_not_allow_for_man_pay
          iv_msgv1  = lv_msgv1_2.
    ENDIF.

    "Verifica se os campos foram informados
    IF iv_codaut IS INITIAL.

      "O preenchimento dos campos é obrigatório.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_empty_fields.

    ENDIF.

    "Etapa: Pagamento Manual Realizado
    set_step( iv_docguia = iv_docguia
              iv_step    = gc_step-pagamento_manual_realizado
              iv_newdoc  = CONV #( iv_codaut )                   ).

    <fs_s_gnre_header>-codaut_guia = iv_codaut.
    <fs_s_gnre_header>-dtpgto      = iv_dtpgto.
    <fs_s_gnre_header>-vlrpago     = iv_vlrpago.
    <fs_s_gnre_header>-chadat      = sy-datum.
    <fs_s_gnre_header>-chatim      = sy-uzeit.
    <fs_s_gnre_header>-chanam      = sy-uname.
  ENDMETHOD.


  METHOD add_to_calc_log.

    APPEND is_calc_log TO gt_gnre_calc_log.

  ENDMETHOD.


  METHOD add_to_log.

    DATA: ls_gnre_log TYPE ztsd_gnret003.

    GET TIME.

    SORT gt_gnre_log BY counter DESCENDING.

    READ TABLE gt_gnre_log ASSIGNING FIELD-SYMBOL(<fs_s_gnre_log>) WITH KEY docnum  = gv_docnum
                                                                            docguia = iv_docguia.
    IF sy-subrc IS INITIAL.
      DATA(lv_counter) = CONV ztsd_gnret003-counter( <fs_s_gnre_log>-counter + 1 ).
    ELSE.
      lv_counter = 1.
    ENDIF.

    ls_gnre_log-docnum       = gv_docnum.
    ls_gnre_log-docguia      = iv_docguia.
    ls_gnre_log-counter      = lv_counter.
    ls_gnre_log-step         = iv_step.
    ls_gnre_log-tpprocess    = gv_tpprocess.
    ls_gnre_log-newdoc       = iv_newdoc.
    ls_gnre_log-status_guia  = iv_status_guia.
    ls_gnre_log-desc_st_guia = iv_desc_st_guia.
    ls_gnre_log-credat       = sy-datum.
    ls_gnre_log-cretim       = sy-uzeit.
    ls_gnre_log-crenam       = sy-uname.

    APPEND ls_gnre_log TO gt_gnre_log.

  ENDMETHOD.


  METHOD calculate_zsub.

    DATA: lv_werks         TYPE t001w-werks,
          lv_regio         TYPE t001w-regio,
          ls_dados_zsub    TYPE zssd_gnree008,
          ls_calc_log      TYPE ztsd_gnret004,
          lv_tot_ipi       TYPE j_1bnfstx-taxval,
          lv_base          TYPE j_1bnfstx-base,
          lv_conv_menge    TYPE j_1bnflin-menge,
          lv_desc_st_guia  TYPE ztsd_gnret003-desc_st_guia,
          lv_total_fcp     TYPE ztsd_gnret002-taxval,
          lv_total_icms    TYPE ztsd_gnret002-taxval,
          lv_invdt_output  TYPE j_1btxdatf,
          lv_sy_datum_conv TYPE char10,
          lt_ztsd_gnret016 TYPE TABLE OF ztsd_gnret016,
          lt_ztsd_gnret017 TYPE TABLE OF ztsd_gnret017,
          lt_j_1btxst3_val TYPE ty_t_j_1btxst3,
          lt_j_1btxst3     TYPE ty_t_j_1btxst3.



    "Verifica se é um cliente
    IF gs_j_1bnfdoc-partyp = 'C'.

      WRITE sy-datum TO lv_sy_datum_conv DD/MM/YYYY.

      CALL FUNCTION 'CONVERSION_EXIT_INVDT_INPUT'
        EXPORTING
          input  = lv_sy_datum_conv
        IMPORTING
          output = lv_invdt_output.

      "Verifica se o cliente é uma exceção
      SELECT COUNT(*)
        FROM j_1btxst3
        WHERE land1     =  'BR'
          AND shipfrom  =  gs_j_1bnfdoc-regio_branch
          AND shipto    =  gs_j_1bnfdoc-regio
          AND gruop     =  '51'
          AND value     =  gs_j_1bnfdoc-parid
          AND stgrp     =  '01'
          AND validfrom >= lv_invdt_output
          AND validto   <= lv_invdt_output.

      IF sy-subrc IS INITIAL.
        delete_docguia( gs_gnre_header-docguia ).
        RETURN.
      ENDIF.

      lt_j_1btxst3_val = CORRESPONDING #( gt_j_1bnflin MAPPING value  = matkl
                                                               value3 = matorg ).
      SORT lt_j_1btxst3_val BY value value3.
      DELETE ADJACENT DUPLICATES FROM lt_j_1btxst3_val COMPARING value value3.

      "Verifica se o cliente é uma exceção
      IF lt_j_1btxst3_val[] IS NOT INITIAL.
        SELECT gruop
               value
               value2
               value3
          FROM j_1btxst3
          INTO TABLE lt_j_1btxst3
          FOR ALL ENTRIES IN lt_j_1btxst3_val
          WHERE land1     =  'BR'
            AND shipfrom  =  gs_j_1bnfdoc-regio_branch
            AND shipto    =  gs_j_1bnfdoc-regio
            AND gruop     =  '61'
            AND value     =  lt_j_1btxst3_val-value
            AND value2    =  gs_j_1bnfdoc-parid
            AND stgrp     =  '01'
            AND validfrom >= lv_invdt_output
            AND validto   <= lv_invdt_output.

      ENDIF.

      "Verifica se o cliente é uma exceção
      IF lt_j_1btxst3_val[] IS NOT INITIAL.
        SELECT gruop
               value
               value2
               value3
          FROM j_1btxst3
          APPENDING TABLE lt_j_1btxst3
          FOR ALL ENTRIES IN lt_j_1btxst3_val
          WHERE land1     =  'BR'
            AND shipfrom  =  gs_j_1bnfdoc-regio_branch
            AND shipto    =  gs_j_1bnfdoc-regio
            AND gruop     =  '59'
            AND value     =  lt_j_1btxst3_val-value
            AND value2    =  gs_j_1bnfdoc-parid
            AND value3    =  lt_j_1btxst3_val-value3
            AND stgrp     =  '01'
            AND validfrom >= lv_invdt_output
            AND validto   <= lv_invdt_output.
      ENDIF.
    ENDIF.

    gs_gnre_header-zsub = abap_true.

    get_bukrs_branch_for_fi_doc(
      EXPORTING
        is_gnre_header = gs_gnre_header
      IMPORTING
        ev_bukrs      = gs_gnre_header-bukrs_doc
        ev_branch     = gs_gnre_header-branch_doc
    ).

    is_coligada(
      IMPORTING
        ev_bukrs   = DATA(lv_bukrs)
        ev_branch  = DATA(lv_branch)
      RECEIVING
        rv_coligada = DATA(lv_coligada)
    ).

    "Verifica se é uma operação entre coligadas
    IF lv_coligada = abap_true.

*      "Obtêm o centro da filial coligada
*      SELECT SINGLE werks,regio
*        FROM t001w
*        INTO ( @lv_werks, @lv_regio )
*        WHERE j_1bbranch = @lv_branch.

      "Obtêm as configurações do ZSUB
      SELECT *
        FROM ztsd_gnret016
        INTO TABLE lt_ztsd_gnret016
        WHERE shipfrom = gs_j_1bnfdoc-regio_branch
          AND werks    = lv_branch.

      "Obtêm as configurações do ZSUB
      SELECT ('*')
        FROM ztsd_gnret017
        INTO TABLE lt_ztsd_gnret017
        WHERE shipfrom = gs_j_1bnfdoc-regio_branch
          AND werks    = lv_branch.

    ELSE.

      "Obtêm as configurações do ZSUB
      SELECT ('*')
        FROM ztsd_gnret016
        INTO TABLE lt_ztsd_gnret016
        WHERE shipfrom = gs_j_1bnfdoc-regio_branch
          AND shipto   = gs_j_1bnfdoc-regio.

      "Obtêm as configurações do ZSUB
      SELECT ('*')
        FROM ztsd_gnret017
        INTO TABLE lt_ztsd_gnret017
        WHERE shipfrom = gs_j_1bnfdoc-regio_branch
          AND shipto   = gs_j_1bnfdoc-regio.

    ENDIF.

    "Se não encontrar nenhuma regra, remove o registro
    IF lt_ztsd_gnret016 IS INITIAL AND lt_ztsd_gnret017 IS INITIAL.

      delete_docguia( gs_gnre_header-docguia ).
      RETURN.

    ENDIF.

    "Verifica se o caso é para considerar o campo NFNET ou NFNETT
    SELECT COUNT(*)
      FROM ztsd_ovd_subtrib
      WHERE regio = gs_j_1bnfdoc-regio.
    IF sy-subrc IS INITIAL.
      DATA(lv_zovd) = abap_true.
    ELSE.
      lv_zovd = abap_false.
    ENDIF.

    DATA(lt_j_1bnfstx) = gt_j_1bnfstx[].
    SORT lt_j_1bnfstx BY itmnum taxgrp.
    DELETE lt_j_1bnfstx WHERE taxgrp <> 'IPI'.

    LOOP AT gt_j_1bnflin ASSIGNING FIELD-SYMBOL(<fs_s_j_1bnflin>).

      "Obtêm a regra de cálculo, caso não exista, desconsidera o registro
      ASSIGN lt_ztsd_gnret016[ matnr = <fs_s_j_1bnflin>-matnr ] TO FIELD-SYMBOL(<fs_s_ztsd_gnret016>).
      IF sy-subrc IS NOT INITIAL.
        ASSIGN lt_ztsd_gnret017[ matkl = <fs_s_j_1bnflin>-matkl ] TO FIELD-SYMBOL(<fs_s_ztsd_gnret017>).
        IF sy-subrc IS NOT INITIAL.
          CONTINUE.
        ELSE.
          ls_dados_zsub = CORRESPONDING #( <fs_s_ztsd_gnret017> ).
        ENDIF.
      ELSE.
        ls_dados_zsub = CORRESPONDING #( <fs_s_ztsd_gnret016> ).
      ENDIF.

      "Verifica se o registro é uma exceção
      CHECK NOT line_exists( lt_j_1btxst3[ gruop = '61'
                                           value = <fs_s_j_1bnflin>-matkl ] ) AND
            NOT line_exists( lt_j_1btxst3[ gruop  = '59'
                                           value  = <fs_s_j_1bnflin>-matkl
                                           value3 = <fs_s_j_1bnflin>-matorg ] ).

      FREE: lv_tot_ipi.
      READ TABLE lt_j_1bnfstx WITH KEY itmnum = <fs_s_j_1bnflin>-itmnum
                                       taxgrp = 'IPI' BINARY SEARCH
                                       TRANSPORTING NO FIELDS.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_j_1bnfstx ASSIGNING FIELD-SYMBOL(<fs_s_j1bnfstx>) FROM sy-tabix.
          IF <fs_s_j1bnfstx>-itmnum <> <fs_s_j_1bnflin>-itmnum
            OR <fs_s_j1bnfstx>-taxgrp <>  'IPI'.
            EXIT.
          ENDIF.
          lv_tot_ipi = lv_tot_ipi + <fs_s_j1bnfstx>-taxval.
        ENDLOOP.

      ENDIF.

      IF lv_zovd = abap_true.
        lv_base = <fs_s_j_1bnflin>-nfnett + lv_tot_ipi.
      ELSE.
        lv_base = <fs_s_j_1bnflin>-nfnet + lv_tot_ipi.
      ENDIF.

      IF ls_dados_zsub-pauta_st = abap_false.

        IF ls_dados_zsub-aliq_fixa IS NOT INITIAL.

          "1 - ICMS ST com alíquota fixa sobre o valor do produto
          calculate_zsub_1( iv_base       = lv_base
                            is_j_1bnflin  = <fs_s_j_1bnflin>
                            is_dados_zsub = ls_dados_zsub    ).

        ELSE.

          "5 - ICMS ST com MVA
          calculate_zsub_5( iv_base       = lv_base
                            iv_tot_ipi    = lv_tot_ipi
                            is_j_1bnflin  = <fs_s_j_1bnflin>
                            is_dados_zsub = ls_dados_zsub    ).

        ENDIF.

      ELSE.

        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
          EXPORTING
            i_matnr              = <fs_s_j_1bnflin>-matnr
            i_in_me              = <fs_s_j_1bnflin>-meins
            i_out_me             = ls_dados_zsub-meins
            i_menge              = <fs_s_j_1bnflin>-menge
          IMPORTING
            e_menge              = lv_conv_menge
          EXCEPTIONS
            error_in_application = 1
            error                = 2
            OTHERS               = 3.

        IF sy-subrc <> 0.

          "Obtêm a mensagem de erro
          MESSAGE ID     sy-msgid
                  TYPE   sy-msgty
                  NUMBER sy-msgno
                  WITH   sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
                  INTO   lv_desc_st_guia.

          "Verifica se a guia já está na tabela
          ASSIGN gt_gnre_header[ docguia = gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
          IF sy-subrc IS INITIAL.
            <fs_s_gnre_header> = gs_gnre_header.
          ELSE.
            IF gs_gnre_header-docguia IS INITIAL.
              gs_gnre_header-docguia = 1.
            ENDIF.
            APPEND gs_gnre_header TO gt_gnre_header.
          ENDIF.

          "Etapa: Erro ao converter unidade de medida - Pauta ICMS
          set_step( iv_docguia      = gs_gnre_header-docguia
                    iv_step         = gc_step-erro_ao_converter_um_pauta
                    iv_desc_st_guia = lv_desc_st_guia                   ).

          RETURN.

        ENDIF.

        IF ls_dados_zsub-icms_orig IS NOT INITIAL AND ls_dados_zsub-icms_dest IS NOT INITIAL.

          "4 - Pauta ICMS ST com cálculo do ICMS Dest e ICMS Orig
          calculate_zsub_4( iv_base       = lv_base
                            iv_tot_ipi    = lv_tot_ipi
                            iv_conv_menge = lv_conv_menge
                            is_j_1bnflin  = <fs_s_j_1bnflin>
                            is_dados_zsub = ls_dados_zsub    ).

        ELSEIF ls_dados_zsub-aliq_fixa IS NOT INITIAL.

          "3 - Pauta ICMS ST com alíquota fixa
          calculate_zsub_3( iv_base       = lv_base
                            iv_conv_menge = lv_conv_menge
                            is_j_1bnflin  = <fs_s_j_1bnflin>
                            is_dados_zsub = ls_dados_zsub    ).

        ELSE.

          "2 - Pauta ICMS ST (Pela Unidade de Medida)
          calculate_zsub_2( iv_base       = lv_base
                            iv_conv_menge = lv_conv_menge
                            is_j_1bnflin  = <fs_s_j_1bnflin>
                            is_dados_zsub = ls_dados_zsub    ).

        ENDIF.

      ENDIF.

    ENDLOOP.

    "Se não for efetuado nenhum cálculo (ser regime especial ou não possuir configuração ZSUB)
    IF gt_gnre_calc_log IS INITIAL.
      delete_docguia( gs_gnre_header-docguia ).
      RETURN.
    ELSE.

      LOOP AT gt_gnre_calc_log ASSIGNING FIELD-SYMBOL(<fs_s_gnre_calc_log>).
        IF <fs_s_gnre_calc_log>-taxtyp = gc_taxtyp_zsub-icms.
          lv_total_icms = lv_total_icms + <fs_s_gnre_calc_log>-taxval.
        ELSE.
          lv_total_fcp = lv_total_fcp + <fs_s_gnre_calc_log>-taxval.
        ENDIF.
      ENDLOOP.

      gs_gnre_header-zsub = abap_true.

      IF lv_total_fcp > 0 OR line_exists( gt_gnre_calc_log[ taxtyp = gc_taxtyp_zsub-fcp ] ).

        IF NOT line_exists( gt_ztsd_gnre_config[ taxtyp = gc_taxtyp_zsub-fcp ] ).

          "Verifica se a guia já está na tabela
          ASSIGN gt_gnre_header[ docguia = gs_gnre_header-docguia ] TO <fs_s_gnre_header>.
          IF sy-subrc IS INITIAL.
            <fs_s_gnre_header> = gs_gnre_header.
          ELSE.
            IF gs_gnre_header-docguia IS INITIAL.
              gs_gnre_header-docguia = 1.
            ENDIF.
            APPEND gs_gnre_header TO gt_gnre_header.
          ENDIF.

          "Etapa: Não foi possivel determinar a receita.
          set_step( iv_docguia = gs_gnre_header-docguia
                    iv_step    = gc_step-impossivel_ident_cod_receita ).

          FREE: gt_gnre_calc_log.
          RETURN.

        ENDIF.

        ASSIGN gt_ztsd_gnre_config[ taxtyp = gc_taxtyp_zsub-fcp ] TO FIELD-SYMBOL(<fs_s_ztsd_gnre_config>).
        IF sy-subrc IS INITIAL.

          gs_gnre_header-step = gc_step-aguardando_envio.

          add_item_value(
            EXPORTING
              iv_taxtyp         = gc_taxtyp_zsub-fcp
              iv_taxval         = lv_total_fcp
              iv_ztsd_gnre_config   = <fs_s_ztsd_gnre_config>
              iv_replace_header = abap_true
            CHANGING
              cs_gnre_header    = gs_gnre_header
          ).

        ENDIF.

      ENDIF.

      IF lv_total_icms > 0 OR line_exists( gt_gnre_calc_log[ taxtyp = gc_taxtyp_zsub-icms ] ).

        IF NOT line_exists( gt_ztsd_gnre_config[ taxtyp = gc_taxtyp_zsub-icms ] ).

          "Verifica se a guia já está na tabela
          ASSIGN gt_gnre_header[ docguia = gs_gnre_header-docguia ] TO <fs_s_gnre_header>.
          IF sy-subrc IS INITIAL.
            <fs_s_gnre_header> = gs_gnre_header.
          ELSE.
            IF gs_gnre_header-docguia IS INITIAL.
              gs_gnre_header-docguia = 1.
            ENDIF.
            APPEND gs_gnre_header TO gt_gnre_header.
          ENDIF.

          "Etapa: Não foi possivel determinar a receita.
          set_step( iv_docguia = gs_gnre_header-docguia
                    iv_step    = gc_step-impossivel_ident_cod_receita ).

          FREE: gt_gnre_calc_log.
          RETURN.

        ENDIF.

        ASSIGN gt_ztsd_gnre_config[ taxtyp = gc_taxtyp_zsub-icms ] TO <fs_s_ztsd_gnre_config>.
        IF sy-subrc IS INITIAL.

          gs_gnre_header-step = gc_step-aguardando_envio.

          add_item_value(
            EXPORTING
              iv_taxtyp         = gc_taxtyp_zsub-icms
              iv_taxval         = lv_total_icms
              iv_ztsd_gnre_config   = <fs_s_ztsd_gnre_config>
              iv_replace_header = COND #( WHEN line_exists( gt_gnre_calc_log[ taxtyp = gc_taxtyp_zsub-fcp ] )
                                          THEN abap_false
                                          ELSE abap_true  )
            CHANGING
              cs_gnre_header    = gs_gnre_header
          ).

        ENDIF.

      ENDIF.

      IF gs_ztsd_gnret005-guia_por_receita = abap_false.

        "Verifica se a guia já está na tabela
        ASSIGN gt_gnre_header[ docguia = gs_gnre_header-docguia ] TO <fs_s_gnre_header>.
        IF sy-subrc IS INITIAL.
          <fs_s_gnre_header> = gs_gnre_header.
        ELSE.
          gs_gnre_header-docguia = 1.
          APPEND gs_gnre_header TO gt_gnre_header.
        ENDIF.

        IF lv_total_icms <= 0 AND lv_total_fcp <= 0.
          "Etapa: Operação com Somatório dos Tributos Igual Zero
          set_step( iv_docguia = gs_gnre_header-docguia
                    iv_step    = gc_step-operacao_c_somatorio_trib_zero ).
        ENDIF.

      ENDIF.

    ENDIF.

    "Valida o preço / imposto
    me->gv_price = validate_price( iv_docnum  = gs_gnre_header-docnum
                                   iv_consumo = gs_gnre_header-consumo ).

  ENDMETHOD.


  METHOD calculate_zsub_1.

    DATA(ls_calc_log) = CORRESPONDING ztsd_gnret004( is_j_1bnflin ).
    MOVE-CORRESPONDING is_dados_zsub TO ls_calc_log.

    "Calcula o valor do ICMS
    ls_calc_log-taxtyp = gc_taxtyp_zsub-icms.
    ls_calc_log-base   = iv_base.
    ls_calc_log-taxval = iv_base * ( ( is_dados_zsub-aliq_fixa - is_dados_zsub-aliq_fcp ) / 100 ).

    add_to_calc_log( ls_calc_log ).

    IF is_dados_zsub-aliq_fcp > 0.

      "Calcula o valor do FCP
      ls_calc_log-taxtyp = gc_taxtyp_zsub-fcp.
      ls_calc_log-base   = iv_base * ( is_dados_zsub-bc_reduzida_fcp / 100 ).
      ls_calc_log-taxval = ls_calc_log-base * ( is_dados_zsub-aliq_fcp / 100 ).

      add_to_calc_log( ls_calc_log ).

    ENDIF.

  ENDMETHOD.


  METHOD calculate_zsub_2.

    DATA(ls_calc_log) = CORRESPONDING ztsd_gnret004( is_j_1bnflin ).
    MOVE-CORRESPONDING is_dados_zsub TO ls_calc_log.

    "Calcula o valor do ICMS
    ls_calc_log-taxtyp = gc_taxtyp_zsub-icms.
    ls_calc_log-base   =
    ls_calc_log-taxval = ( iv_conv_menge / is_dados_zsub-num_unidade ) * is_dados_zsub-preco_fixo.

    add_to_calc_log( ls_calc_log ).

  ENDMETHOD.


  METHOD calculate_zsub_3.

    IF is_dados_zsub-num_unidade >= 0.
      DATA(lv_base_pauta) = CONV j_1bbase( ( iv_conv_menge / is_dados_zsub-num_unidade ) * is_dados_zsub-preco_fixo ).
    ENDIF.

    DATA(lv_base_fcp)   = CONV j_1bbase( lv_base_pauta * ( is_dados_zsub-bc_reduzida_dest / 100 ) ).
    DATA(lv_base_icms)  = CONV j_1bbase( lv_base_fcp * ( is_dados_zsub-bc_reduzida_orig / 100 ) ).

    DATA(lv_valor_icms) = CONV j_1btaxval( lv_base_icms * ( ( is_dados_zsub-aliq_fixa - is_dados_zsub-aliq_fcp ) / 100 ) ).
    DATA(lv_valor_fcp)  = CONV j_1btaxval( lv_base_fcp * ( is_dados_zsub-aliq_fcp / 100 ) ).

    DATA(ls_calc_log) = CORRESPONDING ztsd_gnret004( is_j_1bnflin ).
    MOVE-CORRESPONDING is_dados_zsub TO ls_calc_log.

    "Calcula o valor do ICMS
    ls_calc_log-taxtyp = gc_taxtyp_zsub-icms.
    ls_calc_log-base   = lv_base_icms.
    ls_calc_log-taxval = lv_valor_icms.

    add_to_calc_log( ls_calc_log ).

    IF is_dados_zsub-aliq_fcp > 0.

      "Calcula o valor do FCP
      ls_calc_log-taxtyp = gc_taxtyp_zsub-fcp.
      ls_calc_log-base   = lv_base_fcp.
      ls_calc_log-taxval = lv_valor_fcp.

      add_to_calc_log( ls_calc_log ).

    ENDIF.

  ENDMETHOD.


  METHOD calculate_zsub_4.

    IF is_dados_zsub-num_unidade >= 0.
      DATA(lv_base_pauta) = CONV j_1bbase( ( iv_conv_menge / is_dados_zsub-num_unidade ) * is_dados_zsub-preco_fixo ).
    ENDIF.

    "Caso o valor do produto seja maior que a Pauta ST, Realiza o cálculo 5 ( ICMS ST com MVA )
    IF is_dados_zsub-mva > 0 AND iv_base > lv_base_pauta.
      calculate_zsub_5(
        EXPORTING
          iv_base       = iv_base
          iv_tot_ipi    = iv_tot_ipi
          is_j_1bnflin  = is_j_1bnflin
          is_dados_zsub = is_dados_zsub
      ).
      RETURN.
    ENDIF.

    DATA(lv_base_icms_dest) = CONV j_1bbase( lv_base_pauta * ( is_dados_zsub-bc_reduzida_dest / 100 ) ).
    DATA(lv_aliq_icms_dest) = CONV j_1btaxval( ( is_dados_zsub-icms_dest - is_dados_zsub-aliq_fcp ) / 100 ).
    DATA(lv_icms_dest)      = CONV j_1btaxval( lv_base_icms_dest * lv_aliq_icms_dest ).

    DATA(lv_base_icms_orig) = CONV j_1bbase( is_j_1bnflin-nfnett * ( is_dados_zsub-bc_reduzida_orig / 100 ) ).
    DATA(lv_icms_orig)      = CONV j_1btaxval( lv_base_icms_orig * ( is_dados_zsub-icms_orig / 100 ) ).

    DATA(lv_base_fcp_pauta)  = CONV j_1bbase( lv_base_icms_dest * ( is_dados_zsub-bc_reduzida_fcp / 100 ) ).
    DATA(lv_valor_fcp_pauta) = CONV j_1btaxval( lv_base_fcp_pauta * ( is_dados_zsub-aliq_fcp / 100 ) ).

    DATA(ls_calc_log) = CORRESPONDING ztsd_gnret004( is_j_1bnflin ).
    MOVE-CORRESPONDING is_dados_zsub TO ls_calc_log.

    "Calcula o valor do ICMS
    ls_calc_log-taxtyp = gc_taxtyp_zsub-icms.
    ls_calc_log-base   = lv_base_icms_dest.
    ls_calc_log-taxval = lv_icms_dest - lv_icms_orig.

    add_to_calc_log( ls_calc_log ).

    IF is_dados_zsub-aliq_fcp > 0.

      "Calcula o valor do FCP
      ls_calc_log-taxtyp = gc_taxtyp_zsub-fcp.
      ls_calc_log-base   = lv_base_fcp_pauta.
      ls_calc_log-taxval = lv_valor_fcp_pauta.

      add_to_calc_log( ls_calc_log ).

    ENDIF.

  ENDMETHOD.


  METHOD calculate_zsub_5.

    DATA(lv_base_icms_dest) = CONV j_1bbase( ( iv_base * ( 1 + ( is_dados_zsub-mva / 100 ) ) ) * ( is_dados_zsub-bc_reduzida_dest / 100 ) ).
    DATA(lv_aliq_icms_dest) = CONV j_1btxrate( ( is_dados_zsub-icms_dest - is_dados_zsub-aliq_fcp ) / 100 ).
    DATA(lv_icms_dest)      = CONV j_1btaxval( lv_base_icms_dest * lv_aliq_icms_dest ).

    DATA(lv_base_icms_orig) = CONV j_1bbase( is_j_1bnflin-nfnett * ( is_dados_zsub-bc_reduzida_orig / 100 ) ).
    DATA(lv_icms_orig)      = CONV j_1btaxval( lv_base_icms_orig * ( is_dados_zsub-icms_orig / 100 ) ).

    DATA(ls_calc_log) = CORRESPONDING ztsd_gnret004( is_j_1bnflin ).
    MOVE-CORRESPONDING is_dados_zsub TO ls_calc_log.

    "Calcula o valor do ICMS
    ls_calc_log-taxtyp = gc_taxtyp_zsub-icms.
    IF is_dados_zsub-mva IS NOT INITIAL.
      ls_calc_log-base   = ( lv_base_icms_orig * is_dados_zsub-mva / 100  ) + lv_base_icms_orig.
    ELSE.
      ls_calc_log-base   = lv_base_icms_orig.
    ENDIF.
    ls_calc_log-taxval = lv_icms_dest - lv_icms_orig.

    add_to_calc_log( ls_calc_log ).

    IF is_dados_zsub-aliq_fcp > 0.

      "Calcula o valor do FCP
      ls_calc_log-taxtyp = gc_taxtyp_zsub-fcp.
      ls_calc_log-base   = lv_base_icms_dest * ( is_dados_zsub-bc_reduzida_fcp / 100 ).
      ls_calc_log-taxval = ls_calc_log-base * ( is_dados_zsub-aliq_fcp / 100 ).

      add_to_calc_log( ls_calc_log ).

    ENDIF.

  ENDMETHOD.


  METHOD check_change_step_reprocess.

    DATA lv_msgv1 TYPE msgv1.

    lv_msgv1 = cs_gnre_header-step.

    DATA(lt_steps_reprocess) = get_steps_reprocess( ).

    "Verifica se a etapa permite reprocessamento
    ASSIGN lt_steps_reprocess[ from = cs_gnre_header-step ] TO FIELD-SYMBOL(<fs_s_step_reprocess>).
    IF sy-subrc IS NOT INITIAL.

      "Para a etapa &, não é permitido o reprocessamento.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_for_step_reproc_is_not_all
          iv_msgv1  = lv_msgv1.

    ENDIF.

    "Se sim, atualiza a etapa
    set_step( iv_docguia = cs_gnre_header-docguia
              iv_step    = <fs_s_step_reprocess>-to ).

  ENDMETHOD.


  METHOD check_document_status.

    DATA: lv_xecht TYPE reguv-xecht,
          lv_anzer TYPE reguv-anzer.

    GET TIME.

    "Verifica se a guia está vencida
    IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      cs_gnre_header-step = gc_step-guia_vencida.

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    SELECT SINGLE
           augbl
           auggj
      FROM bseg
      INTO (cs_gnre_header-augbl, cs_gnre_header-auggj)
      WHERE bukrs =  cs_gnre_header-bukrs_doc
        AND belnr =  cs_gnre_header-belnr
        AND gjahr =  cs_gnre_header-gjahr
        AND augbl <> space
        AND shkzg =  'H'. "Crédito

    IF sy-subrc IS INITIAL.

      "Etapa: Pagamento Enviado - Aguardando Retorno Bancário
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-pagamento_enviado
                iv_newdoc  = |{ cs_gnre_header-augbl }{ cs_gnre_header-bukrs_doc }{ cs_gnre_header-auggj }| ).

      cs_gnre_header-chadat = sy-datum.
      cs_gnre_header-chatim = sy-uzeit.
      cs_gnre_header-chanam = sy-uname.

    ELSE.

      "Verifica se a proposta foi gerada
      IF cs_gnre_header-laufd IS NOT INITIAL AND cs_gnre_header-laufi IS NOT INITIAL.

        SELECT SINGLE
               xecht
               anzer
          FROM reguv
          INTO (lv_xecht, lv_anzer)
          WHERE laufd = cs_gnre_header-laufd
            AND laufi = cs_gnre_header-laufi.

        IF sy-subrc IS NOT INITIAL.
          RETURN.
        ELSEIF ( lv_xecht = 'X' AND lv_anzer <= 0 ) OR lv_xecht = 'A'.

          "Etapa: Erro no Ciclo de Pagamento - Verificar F110
          set_step( iv_docguia = cs_gnre_header-docguia
                    iv_step    = gc_step-erro_no_ciclo_de_pagamento ).
          RETURN.

          "Verifica se passou do tempo máximo de espera
        ELSEIF ( sy-uzeit - cs_gnre_header-chatim ) > get_max_time_for_f110( ).

          "Tempo máximo de espera (& segundos) atingido.
          MESSAGE s035(zsd_gnre) WITH get_max_time_for_f110( ) INTO DATA(lv_msg).

          "Etapa: Erro no Ciclo de Pagamento - Verificar F110
          set_step( iv_docguia      = cs_gnre_header-docguia
                    iv_step         = gc_step-erro_no_ciclo_de_pagamento
                    iv_status_guia  = '999'
                    iv_desc_st_guia = CONV #( lv_msg )                  ).
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_doc_is_valid.

    DATA lv_msgv1 TYPE msgv1.
    lv_msgv1 = gv_docnum.

    SELECT COUNT(*)
  FROM ztsd_gnret001
  WHERE docnum = gv_docnum.

    IF sy-subrc IS INITIAL.
      "Nota & já está em processamento.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_nf_in_process
          iv_msgv1  = lv_msgv1.
    ENDIF.

    "Para os casos de contribuinte, somente serão processados os itens com CST 00, 10, 30, 70
    IF is_final_consumer( ) = abap_false.
      DELETE gt_j_1bnflin WHERE taxsit <> '0'   "CST 00
                            AND taxsit <> '1'   "CST 10
                            AND taxsit <> '3'   "CST 30
                            AND taxsit <> '7'.  "CST 70
    ENDIF.

    "Verifica se a nota é um exceção
    SELECT COUNT(*)
      FROM ztsd_gnret008
      WHERE nftype = gs_j_1bnfdoc-nftype
        AND cfop   = space.

    IF sy-subrc     IS INITIAL OR
       gt_j_1bnflin IS INITIAL OR
*       is_final_consumer( )           = abap_false OR "Remove os registros quando não é consumidor final
       NOT ( gs_j_1bnfdoc-id_dest     = '2'   AND     "Interestadual
             gs_j_1bnfdoc-nfesrv      = ''    AND     "Não é um NF de serviço
             gs_j_1bnfdoc-direct      = '2'   AND     "Saída
*             gs_j_1bnfe_active-docsta = '1'   AND     "Autorizada
             gs_j_1bnfe_active-code   = '100' ).
      "A Nota & não é válida para a geração de GNRE.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_nf_is_not_valid
          iv_msgv1  = lv_msgv1.
    ENDIF.
  ENDMETHOD.


  METHOD check_effect_reversal.

    IF cs_gnre_header-belnr IS NOT INITIAL.

      SELECT SINGLE
             augbl
             auggj
        FROM bseg
        INTO (cs_gnre_header-augbl, cs_gnre_header-auggj)
        WHERE bukrs =  cs_gnre_header-bukrs_doc
          AND belnr =  cs_gnre_header-belnr
          AND gjahr =  cs_gnre_header-gjahr
          AND augbl <> space
          AND shkzg =  'H'. "Crédito

      IF sy-subrc IS INITIAL AND cs_gnre_header-augbl IS NOT INITIAL.

        CALL FUNCTION 'CALL_FBRA'
          EXPORTING
            i_bukrs      = cs_gnre_header-bukrs_doc
            i_augbl      = cs_gnre_header-augbl
            i_gjahr      = cs_gnre_header-auggj
            i_update     = 'S'
          EXCEPTIONS
            not_possible = 1
            OTHERS       = 2.

        IF sy-subrc IS NOT INITIAL.

          cs_gnre_header-step = gc_step-pagamento_enviado.

          MESSAGE e042(zsd_gnre) WITH 'FBRA' INTO DATA(lv_msg).

          set_step( iv_docguia      = cs_gnre_header-docguia
                    iv_step         = gc_step-pagamento_enviado
                    iv_status_guia  = '999'
                    iv_desc_st_guia = CONV #( lv_msg )                  ).

          RETURN.

        ELSE.

          DO 5 TIMES.
            SELECT COUNT(*)
              FROM bseg
              WHERE bukrs = cs_gnre_header-bukrs_doc
                AND belnr = cs_gnre_header-belnr
                AND gjahr = cs_gnre_header-gjahr
                AND augbl = space
                AND shkzg = 'H'. "Crédito
            IF sy-subrc IS INITIAL.
              EXIT.
            ELSE.
              WAIT UP TO 1 SECONDS.
            ENDIF.
          ENDDO.

          IF sy-subrc IS INITIAL.

            CALL FUNCTION 'CALL_FB08'
              EXPORTING
                i_bukrs      = cs_gnre_header-bukrs_doc
                i_belnr      = cs_gnre_header-augbl
                i_gjahr      = cs_gnre_header-auggj
                i_stgrd      = '01'
                i_update     = 'S'
              EXCEPTIONS
                not_possible = 1
                OTHERS       = 2.
            IF sy-subrc IS NOT INITIAL.

              cs_gnre_header-step = gc_step-pagamento_enviado.

              MESSAGE e042(zsd_gnre) WITH 'FB08' INTO lv_msg.

              set_step( iv_docguia      = cs_gnre_header-docguia
                        iv_step         = gc_step-pagamento_enviado
                        iv_status_guia  = '999'
                        iv_desc_st_guia = CONV #( lv_msg )                  ).

              DATA(lv_erro) = abap_true.

            ELSE.

              cs_gnre_header-step = gc_step-guia_vencida.

*              FREE: cs_gnre_header-belnr, cs_gnre_header-gjahr.
              FREE: cs_gnre_header-augbl, cs_gnre_header-auggj.

            ENDIF.

          ENDIF.

          CALL FUNCTION 'CALL_FB08'
            EXPORTING
              i_bukrs      = cs_gnre_header-bukrs_doc
              i_belnr      = cs_gnre_header-belnr
              i_gjahr      = cs_gnre_header-gjahr
              i_stgrd      = '01'
              i_update     = 'S'
            EXCEPTIONS
              not_possible = 1
              OTHERS       = 2.

          IF sy-subrc IS INITIAL.
            cs_gnre_header-step = gc_step-guia_vencida.
            FREE: cs_gnre_header-belnr, cs_gnre_header-gjahr.
            FREE: cs_gnre_header-augbl, cs_gnre_header-auggj.
          ELSE.
            cs_gnre_header-step = gc_step-pagamento_enviado.

            MESSAGE e042(zsd_gnre) WITH 'FB08' INTO lv_msg.

            set_step( iv_docguia      = cs_gnre_header-docguia
                      iv_step         = gc_step-pagamento_enviado
                      iv_status_guia  = '999'
                      iv_desc_st_guia = CONV #( lv_msg )                  ).
          ENDIF.

        ENDIF.

      ELSE.

        CALL FUNCTION 'CALL_FB08'
          EXPORTING
            i_bukrs      = cs_gnre_header-bukrs_doc
            i_belnr      = cs_gnre_header-belnr
            i_gjahr      = cs_gnre_header-gjahr
            i_stgrd      = '01'
            i_update     = 'S'
          EXCEPTIONS
            not_possible = 1
            OTHERS       = 2.

        IF sy-subrc IS INITIAL.
          cs_gnre_header-step = gc_step-guia_vencida.
          FREE: cs_gnre_header-belnr, cs_gnre_header-gjahr.
          FREE: cs_gnre_header-augbl, cs_gnre_header-auggj.
        ELSE.
          cs_gnre_header-step = gc_step-pagamento_enviado.

          MESSAGE e042(zsd_gnre) WITH 'FB08' INTO lv_msg.

          set_step( iv_docguia      = cs_gnre_header-docguia
                    iv_step         = gc_step-pagamento_enviado
                    iv_status_guia  = '999'
                    iv_desc_st_guia = CONV #( lv_msg )                  ).
        ENDIF.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD check_payment_cycle.

    DATA: lv_max_laufi TYPE regut-laufi,
          lr_bukrs     TYPE RANGE OF t001-bukrs,
          lr_sel_kred  TYPE RANGE OF lfa1-lifnr,
          lr_sel_var1  TYPE RANGE OF raldb_vari,
          ls_zgnret012 TYPE ztsd_gnret012,
          lv_par_neda  TYPE sy-datum,
          lv_zlsch     TYPE bseg-zlsch,
          lv_hbkid     TYPE bseg-hbkid,
          lv_hex_value TYPE x LENGTH 2.

    "Verifica se a guia está vencida
    IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      cs_gnre_header-step = gc_step-guia_vencida.

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    SELECT SINGLE
           zlsch
           hbkid
      FROM bseg
      INTO (lv_zlsch,lv_hbkid)
      WHERE bukrs = cs_gnre_header-bukrs_doc
        AND belnr = cs_gnre_header-belnr
        AND gjahr = cs_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    SELECT SINGLE *
      FROM ztsd_gnret012
      INTO ls_zgnret012
      WHERE bukrs   =  cs_gnre_header-bukrs_doc
        AND hbkid   =  lv_hbkid
        AND report  <> space
        AND variant <> space.

    IF sy-subrc IS NOT INITIAL.
      "Etapa: Erro ao gerar o ciclo de pagamento - Verificar variante banco empresa
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-erro_ao_gerar_ciclo_pagamento ).
      RETURN.
    ENDIF.

    SELECT MAX( laufi )
      FROM reguv
      INTO lv_max_laufi
      WHERE laufd =    sy-datum
        AND laufi LIKE '____G'.

    IF lv_max_laufi IS INITIAL.
      lv_max_laufi = '0001G'.
    ELSE.
      lv_hex_value    = lv_max_laufi(4).
      lv_hex_value    = lv_hex_value + 1.
      lv_max_laufi(4) = lv_hex_value.
    ENDIF.

    cs_gnre_header-laufd = sy-datum.
    cs_gnre_header-laufi = lv_max_laufi.

    lr_bukrs = VALUE #( ( sign   = 'I'
                          option = 'EQ'
                          low    = cs_gnre_header-bukrs_doc ) ).

    lr_sel_kred = VALUE #( ( sign   = 'I'
                             option = 'EQ'
                             low    = cs_gnre_header-lifnr ) ).

    lr_sel_var1 = VALUE #( ( sign   = 'I'
                             option = 'EQ'
                             low    = ls_zgnret012-variant ) ).

    lv_par_neda = sy-datum + 1.

    SUBMIT rff110s
      WITH par_lfd  =  sy-datum
      WITH par_lfid =  lv_max_laufi
      WITH par_buda =  sy-datum
      WITH par_grda =  sy-datum
      WITH sel_bukr IN lr_bukrs
      WITH par_zwe  =  lv_zlsch
      WITH par_neda =  lv_par_neda
      WITH sel_kred IN lr_sel_kred
      WITH par_tex1 =  'BKPF-BELNR'
      WITH par_lis1 =  cs_gnre_header-belnr
      WITH par_tex2 =  'BKPF-GJAHR'
      WITH par_lis2 =  cs_gnre_header-gjahr
      WITH par_xfa  =  'X'
      WITH par_xze  =  'X'
      WITH par_xbl  =  'X'
      WITH par_mitd =  'X'
      WITH par_mitl =  'X'
      WITH sel_krep IN lr_sel_kred
      WITH par_prp1 =  ls_zgnret012-report
      WITH sel_var1 IN lr_sel_var1
      AND RETURN.

    "Verifica se o Job já foi executado
    DO 5 TIMES.
      SELECT COUNT(*)
        FROM reguv
        WHERE laufd = sy-datum
          AND laufi = lv_max_laufi
          AND xecht = 'X'.
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.

    "Etapa: Documento Enviado ao VAN FINNET
    set_step( iv_docguia = cs_gnre_header-docguia
              iv_step    = gc_step-documento_enviado
              iv_newdoc  = |{ sy-datum DATE = USER }/{ lv_max_laufi }| ).

  ENDMETHOD.


  METHOD check_payment_status.

    DATA: lv_stblg       TYPE bkpf-stblg,
          lv_stjah       TYPE bkpf-stjah,
          ls_gnre_header TYPE ztsd_gnret001.

    MOVE-CORRESPONDING cs_gnre_header TO ls_gnre_header.

    "Verifica se a guia está vencida
    IF ls_gnre_header-faedt IS NOT INITIAL AND ls_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = ls_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      cs_gnre_header-step = gc_step-guia_vencida.

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    "Verifica se o pagamento foi rejeitado
    SELECT SINGLE
           stblg
           stjah
      FROM bkpf
      INTO (lv_stblg, lv_stjah)
      WHERE bukrs =  ls_gnre_header-bukrs_doc
        AND belnr =  ls_gnre_header-augbl
        AND gjahr =  ls_gnre_header-gjahr
        AND stblg <> space.

    IF sy-subrc IS INITIAL.

      "Etapa: Pagamento Rejeitado - Verificar status no VAN FINNET
      set_step( iv_docguia = ls_gnre_header-docguia
                iv_step    = gc_step-pagamento_rejeitado
                iv_newdoc  = |{ lv_stblg }{ ls_gnre_header-bukrs_doc }{ lv_stjah }| ).

      GET TIME.

      ls_gnre_header-chadat = sy-datum.
      ls_gnre_header-chatim = sy-uzeit.
      ls_gnre_header-chanam = sy-uname.

      FREE: ls_gnre_header-augbl,
            ls_gnre_header-auggj.

    ELSE.

      "Verifica se o pagamento foi efetuado
*      SELECT SINGLE
*             zautenticaban
*        FROM ztfi_retpag_segz
*        INTO ls_gnre_header-codaut_guia
*        WHERE zgjahr   =  ls_gnre_header-auggj
*          AND belnr   =  ls_gnre_header-augbl
*          AND bukrs   =  ls_gnre_header-bukrs_doc
*          AND zautenticaban <> space.
      "Busca da autenticação após o pagamento
      SELECT SINGLE zautenticaban
        FROM ztfi_retpag_segz
        INTO ls_gnre_header-codaut_guia
        WHERE bukrs         EQ ls_gnre_header-bukrs_doc
          AND nbbln_eb      EQ ls_gnre_header-augbl
          AND zgjahr        EQ ls_gnre_header-auggj
          AND zautenticaban NE space.

      IF sy-subrc IS INITIAL.

        GET TIME.

        "Etapa: Pagamento Autenticado
        set_step( iv_docguia = ls_gnre_header-docguia
                  iv_step    = gc_step-pagamento_autenticado ).

        ls_gnre_header-dtpgto  = sy-datum.
        ls_gnre_header-vlrpago = ls_gnre_header-vlrtot.
        ls_gnre_header-chadat  = sy-datum.
        ls_gnre_header-chatim  = sy-uzeit.
        ls_gnre_header-chanam  = sy-uname.
        ls_gnre_header-step    = gc_step-pagamento_autenticado.

      ENDIF.

    ENDIF.

    MOVE-CORRESPONDING ls_gnre_header TO cs_gnre_header.

  ENDMETHOD.


  METHOD check_step_exception.

    DATA(lv_substitute_insc) = is_substitute_insc( ).

    "Processa as guias com a etapa Aguardando Envio.
    LOOP AT gt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>) WHERE step = gc_step-aguardando_envio.

      IF lv_substitute_insc = abap_true.

        "Modifica para a etapa Operação Com Inscrição Substituto (NIF Regional)
        <fs_s_gnre_header>-step = gc_step-operacao_c_insc_substituto.

        "Armazena o Log da etapa
        set_step( iv_step    = <fs_s_gnre_header>-step
                  iv_docguia = <fs_s_gnre_header>-docguia ).

        CONTINUE.

      ELSEIF gs_ztsd_gnret005-modo = gc_modo_exec-manual.

        "Modifica para a etapa Operação Manual - Incluir Guia Manual
        <fs_s_gnre_header>-step = gc_step-operacao_manual.

        "Armazena o Log da etapa
        set_step( iv_step    = <fs_s_gnre_header>-step
                  iv_docguia = <fs_s_gnre_header>-docguia ).

        CONTINUE.

      ELSEIF gs_ztsd_gnret005-modo = gc_modo_exec-desativado.

        "Modifica para a etapa Integração Desativada Manualmente
        <fs_s_gnre_header>-step = gc_step-integracao_desativada_manual.

        "Armazena o Log da etapa
        set_step( iv_step    = <fs_s_gnre_header>-step
                  iv_docguia = <fs_s_gnre_header>-docguia ).

        CONTINUE.

      ENDIF.

      "Armazena o Log da etapa
      set_step( iv_step    = <fs_s_gnre_header>-step
                iv_docguia = <fs_s_gnre_header>-docguia ).

    ENDLOOP.

  ENDMETHOD.


  METHOD constructor.

    gv_docnum          = iv_docnum.
    gv_new             = iv_new.
    gv_tpprocess       = iv_tpprocess.
    gv_ignore_job_lock = iv_ignore_job_lock.
*    gs_j_1bnfe_active  = is_j_1bnfe_active.
    MOVE-CORRESPONDING is_header TO gs_j_1bnfe_active.

    IF iv_lock EQ abap_true.
      enqueue_nf( ).
    ENDIF.

    TRY.

        select_nf_data( ).

        IF iv_new = abap_true.

          check_doc_is_valid( ).

          select_config_data( ).

          "Para guia complementar, os dados deverão ser preenchidos atra
          IF iv_guiacompl = abap_false.

            fill_gnre_data( ).

          ENDIF.

        ELSE.

          select_config_data( ).

          select_gnre_data( ).

        ENDIF.

      CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).

        IF iv_lock EQ abap_true.
          dequeue_nf( ).
        ENDIF.

        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            it_errors = VALUE #( ( lr_cx_gnre_automacao ) ).

    ENDTRY.
  ENDMETHOD.


  METHOD create_fi_document.

    DATA: lv_item           TYPE bseg-buzei,
          ls_header         TYPE bapiache09,
          lt_accountgl      TYPE TABLE OF bapiacgl09,
          lt_accountpayable TYPE TABLE OF bapiacap09,
          lt_currencyamount TYPE TABLE OF bapiaccr09,
          lt_return         TYPE TABLE OF bapiret2,
          lv_gsber          TYPE bseg-gsber,
          lv_werks          TYPE bseg-werks,
          lt_extension2     TYPE STANDARD TABLE OF bapiparex,
          lv_obj_key        TYPE bapiache09-obj_key,
          lv_vbeln          TYPE vbrk-vbeln.

    CONSTANTS: lc_texto1(16)    TYPE c VALUE 'VR.REF. ICMS NFe'.

    "Verifica se a guia está vencida
    IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      cs_gnre_header-step = gc_step-guia_vencida.

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    IF cs_gnre_header-zsub = abap_true.

      get_bukrs_branch_for_fi_doc(
        EXPORTING
          is_gnre_header   = cs_gnre_header
        IMPORTING
          ev_bukrs        = cs_gnre_header-bukrs_doc
          ev_branch       = cs_gnre_header-branch_doc
          ev_adiantamento = DATA(lv_adiantamento)
      ).

    ELSE.

      cs_gnre_header-bukrs_doc  = cs_gnre_header-bukrs.
      cs_gnre_header-branch_doc = cs_gnre_header-branch.

    ENDIF.
    IF gt_gnre_item[] IS NOT INITIAL.
      SELECT bukrs, branch, taxtyp, adiantamento, lifnr, hkont, hbkid
        FROM ztsd_gnret009
        INTO TABLE @DATA(lt_zgnret009)
        FOR ALL ENTRIES IN @gt_gnre_item
        WHERE bukrs        = @cs_gnre_header-bukrs
          AND branch       = @cs_gnre_header-branch
          AND shipto       = @gs_j_1bnfdoc-regio
          AND taxtyp       = @gt_gnre_item-taxtyp
          AND zsub         = @cs_gnre_header-zsub
          AND adiantamento = @lv_adiantamento.

    ENDIF.
    IF sy-subrc IS NOT INITIAL.
      "Etapa: Impossível Identificar Fornecedor e/ou Conta do Razão
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-impossivel_ident_fornecedor_cr ).
      RETURN.
    ENDIF.

    SELECT SINGLE refkey
      INTO @DATA(lv_refkey)
      FROM j_1bnflin
      WHERE docnum = @cs_gnre_header-docnum.

    IF sy-subrc EQ 0.

      lv_vbeln = lv_refkey(10).

      SELECT SINGLE
             vbrp~gsber,
             vbrp~werks
        FROM vbrp AS vbrp
        INNER JOIN vbrk AS vbrk ON vbrk~vbeln = vbrp~vbeln
        WHERE vbrk~vbeln = @lv_vbeln
        AND  vbrk~bukrs =  @cs_gnre_header-bukrs
        INTO (@lv_gsber, @lv_werks).

    ENDIF.


    IF lv_gsber IS INITIAL.

      SELECT *
        FROM ztfi_param_rm
        INTO TABLE @DATA(lt_param_rm)
        FOR ALL ENTRIES IN @lt_zgnret009
       WHERE bukrs   EQ @lt_zgnret009-bukrs
         AND bupla   EQ @lt_zgnret009-branch.

      IF sy-subrc EQ 0.

        DATA(lv_lines) = lines( lt_param_rm ).

        IF lv_lines GT 1.

          IF line_exists( lt_param_rm[ zmatriz = 'X' ] ).
            lv_gsber = lt_param_rm[ zmatriz = 'X' ]-gsber.
          ELSE.

            FREE lt_param_rm.

            SELECT *
              FROM ztfi_param_rm
              INTO TABLE lt_param_rm
              FOR ALL ENTRIES IN lt_zgnret009
             WHERE bukrs   EQ lt_zgnret009-bukrs
               AND zmatriz EQ abap_true.

            IF sy-subrc EQ 0.
              lv_gsber = lt_param_rm[ 1 ]-gsber.
            ENDIF.

          ENDIF.

        ELSE.

          lv_gsber = lt_param_rm[ 1 ]-gsber.

        ENDIF.

      ENDIF.

    ENDIF.

*    "Divisão
*    SELECT SINGLE
*           gsber
*           werks
*      FROM ztmm_divisao
*      INTO (lv_gsber, lv_werks)
*      WHERE bupla = cs_gnre_header-branch_doc.

    TRY.
        get_fi_document_params(
          IMPORTING
            ev_blart   = DATA(lv_blart)
            ev_bktxt   = DATA(lv_bktxt)
            ev_zterm   = DATA(lv_zterm)
            ev_zlsch   = DATA(lv_zlsch)
            ev_zuonr   = DATA(lv_zuonr)
            ev_prctr   = DATA(lv_prctr)
            ev_segment = DATA(lv_segment)
        ).
      CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
        "Etapa: Erro ao Gerar o Documento Financeiro
        set_step( iv_docguia      = cs_gnre_header-docguia
                  iv_step         = gc_step-erro_ao_gerar_o_documento_fi
                  iv_desc_st_guia = CONV #( lr_cx_gnre_automacao->get_text( ) ) ).
        RETURN.
    ENDTRY.

    "Cabeçalho
    ls_header = VALUE #( username   = sy-uname
                         doc_type   = lv_blart
                         header_txt = lv_bktxt
                         comp_code  = cs_gnre_header-bukrs_doc
                         ref_doc_no = |NF{ gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-series ALPHA = OUT }|
                         doc_date   = sy-datum
                         pstng_date = sy-datum
                         fis_period = sy-datum+4(2)
                         fisc_year  = sy-datum(4)   ).

    lv_item = lv_item + 1.

    "Fornecedor Crédito
    ASSIGN lt_zgnret009[ 1 ] TO FIELD-SYMBOL(<fs_s_zgnret009>).

    cs_gnre_header-lifnr = <fs_s_zgnret009>-lifnr.

    APPEND INITIAL LINE TO lt_accountpayable ASSIGNING FIELD-SYMBOL(<fs_s_accountpayable>).

    <fs_s_accountpayable>-itemno_acc    = lv_item.
    <fs_s_accountpayable>-vendor_no     = <fs_s_zgnret009>-lifnr.
    <fs_s_accountpayable>-comp_code     = cs_gnre_header-bukrs_doc.
    <fs_s_accountpayable>-businessplace = cs_gnre_header-branch_doc.
    <fs_s_accountpayable>-bus_area      = lv_gsber.
    <fs_s_accountpayable>-pmnttrms      = lv_zterm.
    <fs_s_accountpayable>-pymt_meth     = lv_zlsch.
    <fs_s_accountpayable>-alloc_nmbr    = lv_zuonr.
    <fs_s_accountpayable>-item_text     = |{ lc_texto1 } { gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-series ALPHA = OUT }|.
    <fs_s_accountpayable>-bline_date    = sy-datum.
    <fs_s_accountpayable>-bank_id       = <fs_s_zgnret009>-hbkid.

    APPEND INITIAL LINE TO lt_currencyamount ASSIGNING FIELD-SYMBOL(<fs_s_currencyamount>).

    <fs_s_currencyamount>-itemno_acc = lv_item.
    <fs_s_currencyamount>-currency   = 'BRL'.
    <fs_s_currencyamount>-amt_doccur = cs_gnre_header-vlrtot * -1.

    IF lv_adiantamento = abap_true.

      "Modifica a chave de lançamento
      APPEND INITIAL LINE TO lt_extension2 ASSIGNING FIELD-SYMBOL(<fs_s_extension2>).
      <fs_s_extension2>-structure  = 'ZSSD_GNREE007'.
      <fs_s_extension2>-valuepart1 = lv_item.
      <fs_s_extension2>-valuepart2 = VALUE zssd_gnree007( bschl = '31' ).

    ENDIF.

    LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>) WHERE docguia = cs_gnre_header-docguia.

      ASSIGN lt_zgnret009[ taxtyp = <fs_s_gnre_item>-taxtyp ] TO <fs_s_zgnret009>.
      IF sy-subrc IS NOT INITIAL.
        "Etapa: Impossível Identificar Fornecedor e/ou Conta do Razão
        set_step( iv_docguia = cs_gnre_header-docguia
                  iv_step    = gc_step-impossivel_ident_fornecedor_cr ).
        RETURN.
      ENDIF.

      lv_item = lv_item + 1.

      "Caso seja adiantamento, lança para o fornecedor
      IF <fs_s_zgnret009>-adiantamento = abap_true.

        <fs_s_gnre_item>-hkont = <fs_s_zgnret009>-lifnr.

        "Fornecedor Débito
        APPEND INITIAL LINE TO lt_accountpayable ASSIGNING <fs_s_accountpayable>.

        <fs_s_accountpayable>-itemno_acc    = lv_item.
        <fs_s_accountpayable>-vendor_no     = <fs_s_zgnret009>-lifnr.
        <fs_s_accountpayable>-comp_code     = cs_gnre_header-bukrs_doc.
        <fs_s_accountpayable>-businessplace = cs_gnre_header-branch_doc.
        <fs_s_accountpayable>-bus_area      = lv_gsber.
        <fs_s_accountpayable>-profit_ctr    = lv_prctr.
        <fs_s_accountpayable>-alloc_nmbr    = lv_zuonr.
        <fs_s_accountpayable>-sp_gl_ind     = 'A'.
        <fs_s_accountpayable>-item_text     = |{ lc_texto1 } { gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-series ALPHA = OUT } { <fs_s_gnre_item>-taxtyp }|.

        APPEND INITIAL LINE TO lt_currencyamount ASSIGNING <fs_s_currencyamount>.

        <fs_s_currencyamount>-itemno_acc = lv_item.
        <fs_s_currencyamount>-currency   = 'BRL'.
        <fs_s_currencyamount>-amt_doccur = <fs_s_gnre_item>-taxval.

        "Modifica a chave de lançamento
        APPEND INITIAL LINE TO lt_extension2 ASSIGNING <fs_s_extension2>.
        <fs_s_extension2>-structure  = 'ZSSD_GNREE007'.
        <fs_s_extension2>-valuepart1 = lv_item.
        <fs_s_extension2>-valuepart2 = VALUE zssd_gnree007( bschl = '29' ).

      ELSE.

        <fs_s_gnre_item>-hkont = <fs_s_zgnret009>-hkont.

        "Conta do Razão Débito
        APPEND INITIAL LINE TO lt_accountgl ASSIGNING FIELD-SYMBOL(<fs_s_accountgl>).

        <fs_s_accountgl>-itemno_acc = lv_item.
        <fs_s_accountgl>-gl_account = <fs_s_zgnret009>-hkont.
        <fs_s_accountgl>-comp_code  = cs_gnre_header-bukrs_doc.
        <fs_s_accountgl>-bus_area   = lv_gsber.
        <fs_s_accountgl>-plant      = lv_werks.
        <fs_s_accountgl>-profit_ctr = lv_prctr.
        <fs_s_accountgl>-segment    = lv_segment.
        <fs_s_accountgl>-alloc_nmbr = lv_zuonr.
        <fs_s_accountgl>-item_text  = |{ lc_texto1 } { gs_j_1bnfdoc-nfenum }-{ gs_j_1bnfdoc-series ALPHA = OUT } { <fs_s_gnre_item>-taxtyp }|.

        APPEND INITIAL LINE TO lt_currencyamount ASSIGNING <fs_s_currencyamount>.

        <fs_s_currencyamount>-itemno_acc = lv_item.
        <fs_s_currencyamount>-currency   = 'BRL'.
        <fs_s_currencyamount>-amt_doccur = <fs_s_gnre_item>-taxval.

      ENDIF.

    ENDLOOP.

    "Atribui o código da transação
    APPEND INITIAL LINE TO lt_extension2 ASSIGNING <fs_s_extension2>.
    <fs_s_extension2>-structure  = 'ZSSD_GNREE007'.
    <fs_s_extension2>-valuepart2 = VALUE zssd_gnree007( tcode = 'ZGNRE_MONITOR' ).

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
      EXPORTING
        documentheader = ls_header
      IMPORTING
        obj_key        = lv_obj_key
      TABLES
        accountgl      = lt_accountgl
        accountpayable = lt_accountpayable
        currencyamount = lt_currencyamount
        return         = lt_return
        extension2     = lt_extension2.

    ASSIGN lt_return[ type = 'E' ] TO FIELD-SYMBOL(<fs_s_return>).
    IF sy-subrc IS INITIAL.

      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.

      "Etapa: Erro ao Gerar o Documento Financeiro
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-erro_ao_gerar_o_documento_fi ).

      LOOP AT lt_return ASSIGNING <fs_s_return> WHERE type = 'E'.
        "Etapa: Documento Enviado ao VAN FINNET
        add_to_log(
          EXPORTING
            iv_docguia      = cs_gnre_header-docguia
            iv_step         = gc_step-erro_ao_gerar_o_documento_fi
            iv_newdoc       = CONV #( <fs_s_return>-id )
            iv_status_guia  = CONV #( <fs_s_return>-number )
            iv_desc_st_guia = <fs_s_return>-message
        ).
      ENDLOOP.

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = 'X'.

      cs_gnre_header-belnr = lv_obj_key(10).
      cs_gnre_header-gjahr = lv_obj_key+14(4).

      "Etapa: Doc. FI Criado - Aguardando Preenchimento do Código de Barras
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-documento_criado
                iv_newdoc  = CONV #( lv_obj_key )     ).

    ENDIF.

    GET TIME.

    cs_gnre_header-chadat = sy-datum.
    cs_gnre_header-chatim = sy-uzeit.
    cs_gnre_header-chanam = sy-uname.

  ENDMETHOD.


  METHOD create_start_job.

    DATA: lv_jobname          TYPE tbtcjob-jobname,
          lv_jobcount         TYPE tbtcjob-jobcount,
          lr_docnum           TYPE RANGE OF ztsd_gnret001-docnum,
          lr_docguia          TYPE RANGE OF ztsd_gnret001-docguia,
          ls_job_was_released TYPE btch0000-char1,
          lv_sdlstrdt         TYPE tbtcjob-sdlstrtdt,
          lv_sdlstrtm         TYPE tbtcjob-sdlstrttm,
          lv_timelimit        TYPE tbtcjob-sdlstrttm VALUE '235955'.

    lv_jobname = |ZAUTOMACAO_GNRE_{ iv_docnum }|.

    lr_docnum = VALUE #( ( sign   = 'I'
                           option = 'EQ'
                           low    = iv_docnum ) ).

    IF iv_docguia IS NOT INITIAL.
      lr_docguia = VALUE #( ( sign   = 'I'
                              option = 'EQ'
                              low    = iv_docguia ) ).
    ENDIF.

    lv_sdlstrdt = sy-datum.
    lv_sdlstrtm = sy-uzeit.

    IF iv_delay = abap_true.

      IF lv_sdlstrtm < lv_timelimit.
        lv_sdlstrtm = lv_sdlstrtm + 5.
      ELSE.
        lv_sdlstrdt = lv_sdlstrdt + 1.
        lv_sdlstrtm = lv_sdlstrtm + 5.
      ENDIF.

    ENDIF.

    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = lv_jobname
      IMPORTING
        jobcount         = lv_jobcount
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

    SUBMIT zsdr_gnre002
      WITH s_docnum IN lr_docnum
      WITH s_dcguia IN lr_docguia
      USER iv_username
      VIA JOB lv_jobname
      NUMBER  lv_jobcount
      AND RETURN.

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname              = lv_jobname
        sdlstrtdt            = lv_sdlstrdt
        sdlstrttm            = lv_sdlstrtm
      IMPORTING
        job_was_released     = ls_job_was_released
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        OTHERS               = 9.

    IF sy-subrc <> 0.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_bapi_return = VALUE #( ( id         = sy-msgid
                                   type       = sy-msgty
                                   number     = sy-msgno
                                   message_v1 = sy-msgv1
                                   message_v2 = sy-msgv2
                                   message_v3 = sy-msgv3
                                   message_v4 = sy-msgv4 ) ).
    ENDIF.

  ENDMETHOD.


  METHOD delete_docguia.

    IF gv_new = abap_false.

      "Insere o registro para ser removido das tabelas transparentes
      APPEND VALUE #( docnum  = gv_docnum
                      docguia = iv_docguia ) TO gt_to_delete.

    ENDIF.

    "Remove os registros das tabelas internas
    DELETE gt_gnre_header WHERE docnum  = gv_docnum
                            AND docguia = iv_docguia.

    DELETE gt_gnre_item WHERE docnum  = gv_docnum
                          AND docguia = iv_docguia.

    DELETE gt_gnre_log WHERE docnum  = gv_docnum
                         AND docguia = iv_docguia.


  ENDMETHOD.


  METHOD dequeue_docnum_cancel.
    DELETE FROM ztsd_gnret011 WHERE docnum = iv_docnum
                        AND acao   = gc_acao_at-cancelamento_nota.
  ENDMETHOD.


  METHOD dequeue_nf.

    CALL FUNCTION 'DEQUEUE_E_TABLE'
      EXPORTING
        tabname   = 'ZTSD_GNRET001'
        varkey    = CONV rstable-varkey( |{ sy-mandt }{ gv_docnum }| )
        _synchron = abap_true.

  ENDMETHOD.


  METHOD disable_guia.

    DATA(lt_steps) = get_steps_disable_guia( ).
    DATA lv_msgv1     TYPE msgv1.
    DATA lv_msgv1_2   TYPE msgv1.
    DATA lv_msgv2     TYPE msgv2.

    lv_msgv1 = gv_docnum.
    lv_msgv2 = iv_docguia.

    ASSIGN gt_gnre_header[ docguia = iv_docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
    IF sy-subrc IS NOT INITIAL.

      "Para a Nota &, não foi encontrado o Nº interno de Guia &.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_docguia_not_found
          iv_msgv1  = lv_msgv1
          iv_msgv2  = lv_msgv2.

    ELSEIF NOT line_exists( lt_steps[ table_line = <fs_s_gnre_header>-step ] ).
      lv_msgv1_2 = <fs_s_gnre_header>-step.
      "A etapa & não permite Inutilização de Guia.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_step_not_allow_for_disable
          iv_msgv1  = lv_msgv1_2.
    ENDIF.

    GET TIME.

    "Etapa: Guia Inutilizada Manualmente
    set_step( iv_docguia      = iv_docguia
              iv_step         = gc_step-guia_inutilizada_manualmente ).

  ENDMETHOD.


  METHOD enqueue_docnum_cancel.

    DATA(ls_ztsd_gnret011) = VALUE ztsd_gnret011( docnum = iv_docnum
                                      acao   = gc_acao_at-cancelamento_nota
                                      credat = sy-datum
                                      cretim = sy-uzeit
                                      crenam = sy-uname                    ).

    INSERT ztsd_gnret011 FROM ls_ztsd_gnret011.

  ENDMETHOD.


  METHOD enqueue_nf.

    DATA: lv_crenam TYPE ztsd_gnret011-crenam,
          lv_msgv1  TYPE msgv1,
          lv_msgv2  TYPE msgv2.

    lv_msgv1 = gv_docnum.

    CALL FUNCTION 'ENQUEUE_E_TABLE'
      EXPORTING
        tabname        = 'ZTSD_GNRET001'
        varkey         = CONV rstable-varkey( |{ sy-mandt }{ gv_docnum }| )
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc <> 0.

      IF sy-msgid = 'MC' AND sy-msgno = '601'.

        "Nota fiscal & bloqueada pelo usuário &.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            iv_textid = zcxsd_gnre_automacao=>gc_nf_blocked
            iv_msgv1  = lv_msgv1
            iv_msgv2  = sy-msgv1.

      ELSE.
        RAISE EXCEPTION TYPE zcxsd_gnre_automacao
          EXPORTING
            it_bapi_return = VALUE #( ( id         = sy-msgid
                                     number     = sy-msgno
                                     type       = sy-msgty
                                     message_v1 = sy-msgv1
                                     message_v2 = sy-msgv2
                                     message_v3 = sy-msgv3
                                     message_v4 = sy-msgv4 ) ).
      ENDIF.

    ELSE.

      IF gv_ignore_job_lock = abap_false.

        "Verifica se a nota está em processamento pelo Job
        SELECT SINGLE
               crenam
          FROM ztsd_gnret011
          INTO lv_crenam
          WHERE docnum = gv_docnum
            AND acao   = gc_acao_at-job.

        IF sy-subrc IS INITIAL.
          lv_msgv2 = lv_crenam.
          "Nota fiscal & bloqueada pelo usuário &.
          RAISE EXCEPTION TYPE zcxsd_gnre_automacao
            EXPORTING
              iv_textid = zcxsd_gnre_automacao=>gc_nf_blocked
              iv_msgv1  = lv_msgv1
              iv_msgv2  = lv_msgv2.

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD execute_from_step.

    rv_continue = abap_false.

    "Realiza as ações de acordo com a etapa da guia
    CASE cs_gnre_header-step.

        "Aguardando Preenchimento dos Dados
      WHEN gc_step-aguardando_preenchimento_dados.
        fill_gnre_data_after_error( CHANGING cs_gnre_header = cs_gnre_header ).

        "Aguardando Envio / Guia Solicitada - Aguardando Retorno SEFAZ
      WHEN gc_step-aguardando_envio OR
           gc_step-guia_solicitada.

        IF validate_price(  iv_docnum   = cs_gnre_header-docnum
                            iv_consumo  = cs_gnre_header-consumo
                            iv_step_old = iv_step ) IS INITIAL.
          "Verifica se o tipo de execução na ZTGNRE005 é diferente de automático, para comportamento específico.
          IF iv_step EQ me->gc_step-guia_valor_muito_alto AND me->gs_ztsd_gnret005-modo NE me->gc_modo_exec-automatico.
            CASE me->gs_ztsd_gnret005-modo.
              WHEN 1. "Manual
                set_step( iv_docguia = cs_gnre_header-docguia
                          iv_step    = me->gc_step-operacao_manual ).

              WHEN 3. "Desativado
                set_step( iv_docguia = cs_gnre_header-docguia
                          iv_step    = me->gc_step-integracao_desativada_manual ).
            ENDCASE.
          ELSE.
            send_to_integration( EXPORTING iv_type        = COND char1( WHEN cs_gnre_header-step = gc_step-aguardando_envio
                                                                        THEN zclsd_gnre_integracao=>gc_type-process
                                                                        ELSE zclsd_gnre_integracao=>gc_type-consult )
                                  CHANGING cs_gnre_header = cs_gnre_header ).
          ENDIF.
        ELSE.
          "Se sim, atualiza a etapa
          set_step( iv_docguia = cs_gnre_header-docguia
                    iv_step    = gc_step-guia_valor_muito_alto ).
        ENDIF.

        "Caso a guia tenha sido criada, continua a execução
        IF cs_gnre_header-step = gc_step-guia_criada.
          rv_continue = abap_true.
        ENDIF.

        "Guia Criada - Aguardando Criação do Doc. FI
      WHEN gc_step-guia_criada.

        "Só realiza o processo em background
        CHECK sy-batch IS NOT INITIAL.

        create_fi_document( CHANGING cs_gnre_header = cs_gnre_header ).

        "Caso o documento tenha sido criado, continua a execução
        IF cs_gnre_header-step = gc_step-documento_criado.
          rv_continue = abap_true.
        ENDIF.

        "Doc. FI - Aguardando Preenchimento do Código de Barras
      WHEN gc_step-documento_criado.
        fill_barcode_fi_document( CHANGING cs_gnre_header = cs_gnre_header ).

        "Caso o código de barras tenha sido preenchido, continua a execução
        IF cs_gnre_header-step = gc_step-cod_barras_preenchido.
          rv_continue = abap_true.
        ENDIF.

        "Código de Barras preenchido - Aguardando Envio ao VAN FINNET
      WHEN gc_step-cod_barras_preenchido.

        "Só realiza o processo em background
        CHECK sy-batch IS NOT INITIAL.

        generate_payment_cycle( CHANGING cs_gnre_header = cs_gnre_header ).

        "Documento Enviado ao VAN FINNET
      WHEN gc_step-documento_enviado.
        check_document_status( CHANGING cs_gnre_header = cs_gnre_header ).

        "Pagamento Enviado - Aguardando Retorno Bancário
      WHEN gc_step-pagamento_enviado.
        check_payment_status( CHANGING cs_gnre_header = cs_gnre_header ).

        "Guia Vencida
      WHEN gc_step-guia_vencida.

        IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum AND
           cs_gnre_header-belnr IS NOT INITIAL AND cs_gnre_header-gjahr IS NOT INITIAL AND
           cs_gnre_header-augbl IS NOT INITIAL AND cs_gnre_header-auggj IS NOT INITIAL.

          "Etapa: Guia Vencida
          set_step( iv_docguia = cs_gnre_header-docguia
                    iv_step    = gc_step-guia_vencida    ).

          cs_gnre_header-step = gc_step-guia_vencida.

          "Verifica e efetua o estorno
          check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

          RETURN.

        ENDIF.

      WHEN OTHERS.

        "Verifica se a guia está vencida
        IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

          "Etapa: Guia Vencida
          set_step( iv_docguia = cs_gnre_header-docguia
                    iv_step    = gc_step-guia_vencida    ).

          cs_gnre_header-step = gc_step-guia_vencida.

          "Verifica e efetua o estorno
          check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

          RETURN.

        ENDIF.

    ENDCASE.

  ENDMETHOD.


  METHOD fill_barcode_fi_document.

    DATA: lt_bdcdata TYPE TABLE OF bdcdata,
          lt_bdcmsg  TYPE TABLE OF bdcmsgcoll,
          lv_mode    TYPE c VALUE 'P',
          lv_msg     TYPE ztsd_gnret003-desc_st_guia.

    DEFINE _bdc_dynpro.
      APPEND VALUE #( program  = &1
                      dynpro   = &2
                      dynbegin = 'X' ) TO lt_bdcdata.
    END-OF-DEFINITION.

    DEFINE _bdc_field.
      APPEND VALUE #( fnam = &1
                      fval = &2 ) TO lt_bdcdata.
    END-OF-DEFINITION.

    "Verifica se a guia está vencida
    IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    SELECT COUNT(*)
      FROM bseg
      WHERE bukrs =  cs_gnre_header-bukrs_doc
        AND belnr =  cs_gnre_header-belnr
        AND gjahr =  cs_gnre_header-gjahr
        AND shkzg =  'H' "Crédito
        AND esrre <> space.

    IF sy-subrc IS INITIAL.

      "Etapa: Doc. FI Enviado ao VAN FINNET
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-documento_enviado ).

      GET TIME.

      cs_gnre_header-chadat = sy-datum.
      cs_gnre_header-chatim = sy-uzeit.
      cs_gnre_header-chanam = sy-uname.

    ELSE.

      _bdc_dynpro 'SAPMF05L'     '0100'.
      _bdc_field: 'BDC_CURSOR'   'RF05L-BELNR'           ,
                  'BDC_OKCODE'   '/00'                   ,
                  'RF05L-BELNR'  cs_gnre_header-belnr    ,
                  'RF05L-BUKRS'  cs_gnre_header-bukrs_doc,
                  'RF05L-GJAHR'  cs_gnre_header-gjahr    .

      _bdc_dynpro 'SAPMF05L'     '0700'.
      _bdc_field: 'BDC_CURSOR'   'RF05L-ANZDT(01)',
                  'BDC_OKCODE'   '=PK'            .

      _bdc_dynpro 'SAPMF05L'     '0302'.
      _bdc_field: 'BDC_CURSOR'   'RF05L-BRCDE'               ,
                  'RF05L-BRCDE'  cs_gnre_header-ldig_guia(48),
                  'BDC_OKCODE'   '=AE'                       .

      CALL TRANSACTION 'FB02' WITHOUT AUTHORITY-CHECK
                              USING lt_bdcdata
                              MODE lv_mode
                              MESSAGES INTO lt_bdcmsg.

      COMMIT WORK AND WAIT.

      "Erro?
      ASSIGN lt_bdcmsg[ msgtyp = 'E' ] TO FIELD-SYMBOL(<fs_s_bdcmsg>).
      IF sy-subrc IS INITIAL.

        MESSAGE ID     <fs_s_bdcmsg>-msgid
                TYPE   <fs_s_bdcmsg>-msgtyp
                NUMBER <fs_s_bdcmsg>-msgnr
                WITH   <fs_s_bdcmsg>-msgv1
                       <fs_s_bdcmsg>-msgv2
                       <fs_s_bdcmsg>-msgv3
                       <fs_s_bdcmsg>-msgv4
                INTO   lv_msg.

        "Etapa: Erro ao Incluir o Código de Barras
        set_step( iv_docguia      = cs_gnre_header-docguia
                  iv_step         = gc_step-erro_ao_incluir_codigo_barras
                  iv_newdoc       = CONV #( <fs_s_bdcmsg>-msgid )
                  iv_status_guia  = <fs_s_bdcmsg>-msgnr
                  iv_desc_st_guia = lv_msg                               ).
      ELSE.

        "Etapa: Código de Barras preenchido - Aguardando Envio ao VAN FINNET
        set_step( iv_docguia = cs_gnre_header-docguia
                  iv_step    = gc_step-cod_barras_preenchido ).
      ENDIF.

      GET TIME.

      cs_gnre_header-chadat = sy-datum.
      cs_gnre_header-chatim = sy-uzeit.
      cs_gnre_header-chanam = sy-uname.

    ENDIF.

  ENDMETHOD.


  METHOD fill_gnre_data.

    CLEAR: me->gv_price.

    gs_gnre_header = CORRESPONDING #( gs_j_1bnfdoc ).
    gs_gnre_header-tpprocess = gv_tpprocess.
    gs_gnre_header-consumo   = is_final_consumer( ).
    gs_gnre_header-guiacompl = abap_false.
    gs_gnre_header-crenam    = sy-uname.
    gs_gnre_header-credat    = sy-datum.
    gs_gnre_header-cretim    = sy-uzeit.

    "Define inicialmente, a etapa Aguardando Envio
    gs_gnre_header-step = gc_step-aguardando_envio.

    "Para os casos de consumidor final, não há ZSUB
    IF gs_gnre_header-consumo = abap_true.
      gs_gnre_header-zsub = abap_false.
    ENDIF.

    IF gs_ztsd_gnret005 IS INITIAL.

      gs_gnre_header-docguia = 1.
      APPEND gs_gnre_header TO gt_gnre_header.

      "Etapa: Não foi possivel determinar o tipo de guia.
      set_step( iv_docguia = gs_gnre_header-docguia
                iv_step    = gc_step-impossivel_ident_tipo_de_guia ).

    ELSE.

      gs_gnre_header-tpguia = gs_ztsd_gnret005-tpguia.

      IF gt_ztsd_gnre_config IS INITIAL.

        gs_gnre_header-docguia = 1.
        APPEND gs_gnre_header TO gt_gnre_header.

        "Etapa: Não foi possivel determinar a receita.
        set_step( iv_docguia = gs_gnre_header-docguia
                  iv_step    = gc_step-impossivel_ident_cod_receita ).

      ELSE.

        fill_gnre_item( ).
*        check_step_exception( ).
        "Verifica se houve prolema na validação de preço.
        IF me->gv_price IS INITIAL.
          check_step_exception( ).
        ELSE.
          "Envia e-mail com erro de verificação de preço.
          send_email_price( ).
        ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_gnre_data_after_error.

    IF gs_ztsd_gnret005 IS INITIAL.

      "Etapa: Não foi possivel determinar o tipo de guia.
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-impossivel_ident_tipo_de_guia ).

    ELSE.

      cs_gnre_header-tpguia = gs_ztsd_gnret005-tpguia.

      IF gt_ztsd_gnre_config IS INITIAL.

        "Etapa: Não foi possivel determinar a receita.
        set_step( iv_docguia = cs_gnre_header-docguia
                  iv_step    = gc_step-impossivel_ident_cod_receita ).

      ELSE.

        cs_gnre_header-step = gc_step-aguardando_envio.
        gs_gnre_header      = cs_gnre_header.

        fill_gnre_item( ).

        check_step_exception( ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD fill_gnre_item.

    DATA: lv_sum_taxval TYPE ztsd_gnret002-taxval.

    "Processa os impostos de FCP
    process_values_fcp(
      IMPORTING
        ev_taxtyp       = DATA(lv_taxtyp)
        ev_taxval       = DATA(lv_taxval)
        ev_found_fcp    = DATA(lv_found_fcp)
        es_ztsd_gnre_config = DATA(ls_zgnre_config)
    ).

    IF lv_found_fcp = abap_true.
      add_item_value(
        EXPORTING
          iv_taxtyp         = lv_taxtyp
          iv_taxval         = lv_taxval
          iv_ztsd_gnre_config   = ls_zgnre_config
          iv_replace_header = abap_true
        CHANGING
          cs_gnre_header    = gs_gnre_header
      ).
    ENDIF.

    FREE: lv_taxtyp, lv_taxval.

    "Processa os impostos de ICMS
    process_values_icms(
      IMPORTING
        ev_taxtyp       = lv_taxtyp
        ev_taxval       = lv_taxval
        ev_found_icms   = DATA(lv_found_icms)
        es_ztsd_gnre_config = ls_zgnre_config
    ).

    IF lv_found_icms = abap_true.
      add_item_value(
        EXPORTING
          iv_taxtyp         = lv_taxtyp
          iv_taxval         = lv_taxval
          iv_ztsd_gnre_config   = ls_zgnre_config
          iv_replace_header = COND abap_bool( WHEN lv_found_fcp = abap_true THEN abap_false ELSE abap_true )
        CHANGING
          cs_gnre_header    = gs_gnre_header
      ).
    ENDIF.

    "Valida o preço / imposto
    me->gv_price = validate_price( iv_docnum  = gs_gnre_header-docnum
                                   iv_consumo = gs_gnre_header-consumo ).

    "Consumidor final e impostos não encontrados, remove o registro
    IF gs_gnre_header-consumo = abap_true AND lv_found_fcp = abap_false AND lv_found_icms = abap_false.

      delete_docguia( iv_docguia = gs_gnre_header-docguia ).

    ELSEIF lv_found_fcp  = abap_false AND
           lv_found_icms = abap_false.

      "Cálculo ZSUB
      calculate_zsub( ).

    ELSEIF gs_ztsd_gnret005-guia_por_receita = abap_false.

      "Ao final, armazena a estrutura de cabeçalho da NF
      LOOP AT gt_gnre_item ASSIGNING FIELD-SYMBOL(<fs_s_gnre_item>) WHERE docguia = gs_gnre_header-docguia.
        lv_sum_taxval = lv_sum_taxval + <fs_s_gnre_item>-taxval.
      ENDLOOP.

      IF lv_sum_taxval <= 0.
        "Etapa: Operação com Somatório dos Tributos Igual Zero
        set_step( iv_docguia = gs_gnre_header-docguia
                  iv_step    = gc_step-operacao_c_somatorio_trib_zero ).
      ENDIF.

      "Verifica se a guia já está na tabela
      ASSIGN gt_gnre_header[ docguia = gs_gnre_header-docguia ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
      IF sy-subrc IS INITIAL.
        <fs_s_gnre_header> = gs_gnre_header.
      ELSE.
        gs_gnre_header-docguia = 1.
        APPEND gs_gnre_header TO gt_gnre_header.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD free.

    dequeue_nf( ).

    FREE: gv_docnum
        , gv_tpprocess
        , gs_j_1bnfe_active
        , gs_gnre_header
        , gt_gnre_header
        , gt_gnre_item
        , gt_gnre_log
        , gt_gnre_calc_log
        , gs_j_1bnfdoc
        , gt_j_1bnflin
        , gt_j_1bnfstx
        , gs_ztsd_gnret005
        , gt_ztsd_gnre_config.


  ENDMETHOD.


  METHOD generate_payment_cycle.

    DATA: lv_max_laufi TYPE regut-laufi,
          lr_bukrs     TYPE RANGE OF t001-bukrs,
          lr_sel_kred  TYPE RANGE OF lfa1-lifnr,
          lr_sel_var1  TYPE RANGE OF raldb_vari,
          ls_zgnret012 TYPE ztsd_gnret012,
          lv_par_neda  TYPE sy-datum,
          lv_zlsch     TYPE bseg-zlsch,
          lv_hbkid     TYPE bseg-hbkid,
          lv_hex_value TYPE x LENGTH 2.

    "Verifica se a guia está vencida
    IF cs_gnre_header-faedt IS NOT INITIAL AND cs_gnre_header-faedt < sy-datum.

      "Etapa: Guia Vencida
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-guia_vencida    ).

      cs_gnre_header-step = gc_step-guia_vencida.

      "Verifica e efetua o estorno
      check_effect_reversal( CHANGING cs_gnre_header = cs_gnre_header ).

      RETURN.

    ENDIF.

    SELECT SINGLE
           zlsch
           hbkid
      FROM bseg
      INTO (lv_zlsch,lv_hbkid)
      WHERE bukrs = cs_gnre_header-bukrs_doc
        AND belnr = cs_gnre_header-belnr
        AND gjahr = cs_gnre_header-gjahr
        AND shkzg = 'H'
        AND koart = 'K'.

    SELECT SINGLE *
      FROM ztsd_gnret012
      INTO ls_zgnret012
      WHERE bukrs   =  cs_gnre_header-bukrs_doc
        AND hbkid   =  lv_hbkid
        AND report  <> space
        AND variant <> space.

    IF sy-subrc IS NOT INITIAL.
      "Etapa: Erro ao gerar o ciclo de pagamento - Verificar variante banco empresa
      set_step( iv_docguia = cs_gnre_header-docguia
                iv_step    = gc_step-erro_ao_gerar_ciclo_pagamento ).
      RETURN.
    ENDIF.

    SELECT MAX( laufi )
      FROM reguv
      INTO lv_max_laufi
      WHERE laufd =    sy-datum
        AND laufi LIKE '____G'.

    IF lv_max_laufi IS INITIAL.
      lv_max_laufi = '0001G'.
    ELSE.
      lv_hex_value    = lv_max_laufi(4).
      lv_hex_value    = lv_hex_value + 1.
      lv_max_laufi(4) = lv_hex_value.
    ENDIF.

    cs_gnre_header-laufd = sy-datum.
    cs_gnre_header-laufi = lv_max_laufi.

    lr_bukrs = VALUE #( ( sign   = 'I'
                          option = 'EQ'
                          low    = cs_gnre_header-bukrs_doc ) ).

    lr_sel_kred = VALUE #( ( sign   = 'I'
                             option = 'EQ'
                             low    = cs_gnre_header-lifnr ) ).

    lr_sel_var1 = VALUE #( ( sign   = 'I'
                             option = 'EQ'
                             low    = ls_zgnret012-variant ) ).

    lv_par_neda = sy-datum + 1.

    SUBMIT rff110s
      WITH par_lfd  =  sy-datum
      WITH par_lfid =  lv_max_laufi
      WITH par_buda =  sy-datum
      WITH par_grda =  sy-datum
      WITH sel_bukr IN lr_bukrs
      WITH par_zwe  =  lv_zlsch
      WITH par_neda =  lv_par_neda
      WITH sel_kred IN lr_sel_kred
      WITH par_tex1 =  'BKPF-BELNR'
      WITH par_lis1 =  cs_gnre_header-belnr
      WITH par_tex2 =  'BKPF-GJAHR'
      WITH par_lis2 =  cs_gnre_header-gjahr
      WITH par_xfa  =  'X'
      WITH par_xze  =  'X'
      WITH par_xbl  =  'X'
      WITH par_mitd =  'X'
      WITH par_mitl =  'X'
      WITH sel_krep IN lr_sel_kred
      WITH par_prp1 =  ls_zgnret012-report
      WITH sel_var1 IN lr_sel_var1
      AND RETURN.

    "Verifica se o Job já foi executado
    DO 5 TIMES.
      SELECT COUNT(*)
        FROM reguv
        WHERE laufd = sy-datum
          AND laufi = lv_max_laufi
          AND xecht = 'X'.
      IF sy-subrc IS INITIAL.
        EXIT.
      ELSE.
        WAIT UP TO 1 SECONDS.
      ENDIF.
    ENDDO.

    "Etapa: Documento Enviado ao VAN FINNET
    set_step( iv_docguia = cs_gnre_header-docguia
              iv_step    = gc_step-documento_enviado
              iv_newdoc  = |{ sy-datum DATE = USER }/{ lv_max_laufi }| ).

  ENDMETHOD.


  METHOD send_to_integration.

    DATA(lr_integracao) = NEW zclsd_gnre_integracao(
     iv_docguia   = cs_gnre_header-docguia
     io_automacao = me
 ).

    DATA(ls_return) = lr_integracao->integrate( iv_type ).

    MOVE-CORRESPONDING ls_return TO cs_gnre_header.

    IF ls_return-new_credat IS NOT INITIAL.

      "Atribui a data de criação da guia
      cs_gnre_header-credat = ls_return-new_credat.
      cs_gnre_header-cretim = ls_return-new_cretim.
      cs_gnre_header-crenam = ls_return-new_crenam.
    ENDIF.

    "Atualiza os dados do item
    LOOP AT ls_return-mod_itens ASSIGNING FIELD-SYMBOL(<fs_s_mod_item>).

      ASSIGN gt_gnre_item[ docguia  = cs_gnre_header-docguia
                           itemguia = <fs_s_mod_item>-itemguia ] TO FIELD-SYMBOL(<fs_s_item_guia>).
      CHECK sy-subrc IS INITIAL.

      <fs_s_item_guia>-receita  = <fs_s_mod_item>-receita .
      <fs_s_item_guia>-convenio = <fs_s_mod_item>-convenio.
      <fs_s_item_guia>-produto  = <fs_s_mod_item>-produto .

    ENDLOOP.

    GET TIME.

    cs_gnre_header-chadat = sy-datum.
    cs_gnre_header-chatim = sy-uzeit.
    cs_gnre_header-chanam = sy-uname.

  ENDMETHOD.
ENDCLASS.
