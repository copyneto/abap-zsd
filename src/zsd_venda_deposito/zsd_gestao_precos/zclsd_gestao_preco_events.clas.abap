CLASS zclsd_gestao_preco_events DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES ty_header TYPE ztsd_preco_h .
    TYPES:
      ty_t_header       TYPE STANDARD TABLE OF ty_header .
    TYPES ty_item TYPE ztsd_preco_i .
    TYPES:
      ty_t_item         TYPE STANDARD TABLE OF ty_item .
    TYPES ty_minimum TYPE ztsd_preco_m .
    TYPES:
      ty_t_minimum      TYPE STANDARD TABLE OF ty_minimum .
    TYPES ty_invasion TYPE ztsd_preco_inv .
    TYPES:
      ty_t_invasion     TYPE STANDARD TABLE OF ty_invasion .
    TYPES ty_validation TYPE zssd_preco_validacao .
    TYPES ty_t_validation TYPE zctgsd_preco_validacao .
    TYPES ty_header_cds TYPE zi_sd_cockpit_gestao_preco .
    TYPES:
      ty_t_header_cds   TYPE STANDARD TABLE OF ty_header_cds .
    TYPES ty_item_cds TYPE zi_sd_cockpit_gestao_preco_itm .
    TYPES:
      ty_t_item_cds     TYPE STANDARD TABLE OF ty_item_cds .
    TYPES ty_minimum_cds TYPE zi_sd_cockpit_gestao_preco_min .
    TYPES:
      ty_t_minimum_cds  TYPE STANDARD TABLE OF ty_minimum_cds .
    TYPES ty_invasion_cds TYPE zi_sd_cockpit_gestao_preco_inv .
    TYPES:
      ty_t_invasion_cds TYPE STANDARD TABLE OF ty_invasion_cds .
    TYPES:
      BEGIN OF ty_parameter,
        kschl_zpr0 TYPE kschl,
        kschl_zvmc TYPE kschl,
        kschl_zalt TYPE kschl,
      END OF ty_parameter .

    CONSTANTS:
      BEGIN OF gc_status,
        rascunho         TYPE ztsd_preco_h-status VALUE '00',
        em_processamento TYPE ztsd_preco_h-status VALUE '01',
        pendente         TYPE ztsd_preco_h-status VALUE '02',
        erro             TYPE ztsd_preco_h-status VALUE '03',
        aprovado         TYPE ztsd_preco_h-status VALUE '04',
        alerta           TYPE ztsd_preco_h-status VALUE '05',
        divergencia      TYPE ztsd_preco_h-status VALUE '06',
        reprovado        TYPE ztsd_preco_h-status VALUE '07',
        eliminado        TYPE ztsd_preco_h-status VALUE '08',
        validado         TYPE ztsd_preco_h-status VALUE '09',
        alertaexp        TYPE ztsd_preco_h-status VALUE '10', "Alerta Exportação
      END OF gc_status .
    CONSTANTS:
      BEGIN OF gc_presentation_type,
        item     TYPE zi_sd_cockpit_gestao_preco-presentationtype VALUE 'ZPR0',
        minimum  TYPE zi_sd_cockpit_gestao_preco-presentationtype VALUE 'ZVMC',
        invasion TYPE zi_sd_cockpit_gestao_preco-presentationtype VALUE 'ZALT',
      END OF gc_presentation_type .
    CONSTANTS:
      BEGIN OF gc_level,
        header   TYPE string VALUE 'Header' ##NO_TEXT,
        item     TYPE string VALUE 'Item' ##NO_TEXT,
        minimum  TYPE string VALUE 'Minimum' ##NO_TEXT,
        invasion TYPE string VALUE 'Invasion' ##NO_TEXT,
      END OF gc_level .
    DATA gs_parameter TYPE ty_parameter .
    DATA gs_delete TYPE abap_bool .
    DATA gs_upload TYPE abap_bool .
    DATA gs_modify TYPE abap_bool .

    "! Recupera arquivo layout
    "! @parameter iv_tablename | Nome da tabela
    "! @parameter ev_file | Arquivo em binário
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_mimetype | Extensão do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS get_layout
      IMPORTING
        !iv_tablename TYPE tablename
      EXPORTING
        !ev_file      TYPE xstring
        !ev_filename  TYPE string
        !ev_mimetype  TYPE string
        !et_return    TYPE bapiret2_t .
    "! Realiza carga de arquivo
    "! @parameter iv_file | Arquivo em binário
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_file
      IMPORTING
        !iv_tablename TYPE tablename
        !iv_file      TYPE xstring
        !iv_filename  TYPE string
      EXPORTING
        !et_return    TYPE bapiret2_t .
    "! Realiza carga de arquivo com tabela de preço
    "! @parameter iv_file | Arquivo em binário
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_price_file
      IMPORTING
        !iv_file     TYPE xstring
        !iv_filename TYPE string
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Realiza carga de arquivo para alerta mínimo
    "! @parameter iv_file | Arquivo em binário
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_min_file
      IMPORTING
        !iv_file     TYPE xstring
        !iv_filename TYPE string
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Realiza carga de arquivo para invasão
    "! @parameter iv_file | Arquivo em binário
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS upload_inv_file
      IMPORTING
        !iv_file     TYPE xstring
        !iv_filename TYPE string
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Prepara arquivo de carga para salvar
    "! @parameter it_file | Arquivo de carga
    "! @parameter es_header | Dados de cabeçalho
    "! @parameter et_item | Dados de item
    "! @parameter et_return | Mensagens de retorno
    METHODS prepare_price_file
      IMPORTING
        !it_file   TYPE zctgsd_preco_arquivo
      EXPORTING
        !es_header TYPE ty_header
        !et_item   TYPE ty_t_item
        !et_return TYPE bapiret2_t .
    "! Prepara arquivo de carga (alerta mínimo) para salvar
    "! @parameter it_file | Arquivo de carga
    "! @parameter es_header | Dados de cabeçalho
    "! @parameter et_minimum | Dados de alerta mínimo
    "! @parameter et_return | Mensagens de retorno
    METHODS prepare_min_file
      IMPORTING
        !it_file    TYPE zctgsd_preco_arquivo_min
      EXPORTING
        !es_header  TYPE ty_header
        !et_minimum TYPE ty_t_minimum
        !et_return  TYPE bapiret2_t .
    "! Prepara arquivo de carga (invasão) para salvar
    "! @parameter it_file | Arquivo de carga
    "! @parameter es_header | Dados de cabeçalho
    "! @parameter et_invasion | Dados de alerta mínimo
    "! @parameter et_return | Mensagens de retorno
    METHODS prepare_inv_file
      IMPORTING
        !it_file     TYPE zctgsd_preco_arquivo_inv
      EXPORTING
        !es_header   TYPE ty_header
        !et_invasion TYPE ty_t_invasion
        !et_return   TYPE bapiret2_t .
    "! Salva dados de carga
    "! @parameter iv_level | Nome da CDS em processamento
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_item | Dados de item
    "! @parameter it_minimum | Dados de alerta mínimo
    "! @parameter it_invasion | Dados de invasão
    "! @parameter et_return | Mensagens de retorno
    METHODS save_file
      IMPORTING
        !iv_level    TYPE string
        !is_header   TYPE ty_header
        !it_item     TYPE ty_t_item OPTIONAL
        !it_minimum  TYPE ty_t_minimum OPTIONAL
        !it_invasion TYPE ty_t_invasion OPTIONAL
      EXPORTING
        !et_return   TYPE bapiret2_t .
    "! Valida se informações estão corretas
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter et_validation | Resultado da validação
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_item | Dados de item
    "! @parameter ct_minimum | Dados de alerta mínimo
    "! @parameter ct_invasion | Dados de invasão
    METHODS validate_info
      IMPORTING
        !iv_msgty      TYPE sy-msgty DEFAULT 'I'
      EXPORTING
        !et_validation TYPE ty_t_validation
        !et_return     TYPE bapiret2_t
      CHANGING
        !cs_header     TYPE ty_header
        !ct_item       TYPE ty_t_item OPTIONAL
        !ct_minimum    TYPE ty_t_minimum OPTIONAL
        !ct_invasion   TYPE ty_t_invasion OPTIONAL .
    "! Aplica avisos nos campos validados
    "! @parameter it_validation | Resultado da validação
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_item | Dados de item
    "! @parameter ct_minimum | Dados de alerta mínimo
    "! @parameter ct_invasion | Dados de invasão
    METHODS prepare_price_criticality
      IMPORTING
        !it_validation TYPE ty_t_validation
      CHANGING
        !cs_header     TYPE ty_header
        !ct_item       TYPE ty_t_item OPTIONAL
        !ct_minimum    TYPE ty_t_minimum OPTIONAL
        !ct_invasion   TYPE ty_t_invasion OPTIONAL .
    "! Formata as mensages de retorno
    "! @parameter ct_return | Mensagens de retorno
    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t .
    "! Recupera configurações cadastradas
    "! @parameter es_parameter | Parâmetros de configuração
    "! @parameter et_return | Mensagens de retorno
    METHODS get_configuration
      EXPORTING
        !es_parameter TYPE ty_parameter
        !et_return    TYPE bapiret2_t .
    "! Recupera parâmetro
    "! @parameter is_param | Parâmetro cadastrado
    "! @parameter ev_value | Valor cadastrado
    METHODS get_parameter
      IMPORTING
        !is_param TYPE ztca_param_val
      EXPORTING
        !ev_value TYPE any .
    "! Valida campos durante Determination
    "! @parameter iv_level | Nome da CDS em processamento
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter is_header_cds | Dados de cabeçalho
    "! @parameter it_item_cds | Dados de item
    "! @parameter it_minimum_cds | Dados de alerta mínimo
    "! @parameter it_invasion_cds | Dados de invasão
    "! @parameter es_header_cds | Dados de cabeçalho atualizados
    "! @parameter et_item_cds | Dados de item atualizados
    "! @parameter et_minimum_cds | Dados de alerta mínimo
    "! @parameter et_invasion_cds | Dados de invasão
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_request
      IMPORTING
        !iv_level        TYPE string
        !iv_msgty        TYPE sy-msgty DEFAULT 'I'
        !is_header_cds   TYPE ty_header_cds
        !it_item_cds     TYPE ty_t_item_cds OPTIONAL
        !it_minimum_cds  TYPE ty_t_minimum_cds OPTIONAL
        !it_invasion_cds TYPE ty_t_invasion_cds OPTIONAL
      EXPORTING
        !es_header_cds   TYPE ty_header_cds
        !et_item_cds     TYPE ty_t_item_cds
        !et_minimum_cds  TYPE ty_t_minimum_cds
        !et_invasion_cds TYPE ty_t_invasion_cds
        !et_return       TYPE bapiret2_t .
    "! Aprova solicitação
    "! @parameter iv_level | Nome da CDS em processamento
    "! @parameter is_header_cds | Dados de cabeçalho
    "! @parameter it_item_cds | Dados de item
    "! @parameter it_minimum_cds | Dados de alerta mínimo
    "! @parameter it_invasion_cds | Dados de invasão
    "! @parameter es_header_cds | Dados de cabeçalho atualizados
    "! @parameter et_item_cds | Dados de item atualizados
    "! @parameter et_minimum_cds | Dados de alerta mínimo
    "! @parameter et_invasion_cds | Dados de invasão
    "! @parameter et_return | Mensagens de retorno
    METHODS approve_request
      IMPORTING
        !iv_level        TYPE string
        !is_header_cds   TYPE ty_header_cds
        !it_item_cds     TYPE ty_t_item_cds
        !it_minimum_cds  TYPE ty_t_minimum_cds
        !it_invasion_cds TYPE ty_t_invasion_cds
      EXPORTING
        !es_header_cds   TYPE ty_header_cds
        !et_item_cds     TYPE ty_t_item_cds
        !et_minimum_cds  TYPE ty_t_minimum_cds
        !et_invasion_cds TYPE ty_t_invasion_cds
        !et_return       TYPE bapiret2_t .
    "! Converte campos CDS para campos da tabela
    "! @parameter is_header_cds | Dados de cabeçalho
    "! @parameter it_item_cds | Dados de item
    "! @parameter es_header | Dados de cabeçalho
    "! @parameter et_item | Dados de item
    "! @parameter et_minimum| Dados de alerta mínimo
    "! @parameter et_invasion| Dados de invasão
    METHODS convert_cds_to_table
      IMPORTING
        !is_header_cds   TYPE ty_header_cds OPTIONAL
        !it_item_cds     TYPE ty_t_item_cds OPTIONAL
        !it_minimum_cds  TYPE ty_t_minimum_cds OPTIONAL
        !it_invasion_cds TYPE ty_t_invasion_cds OPTIONAL
      EXPORTING
        !es_header       TYPE ty_header
        !et_item         TYPE ty_t_item
        !et_minimum      TYPE ty_t_minimum
        !et_invasion     TYPE ty_t_invasion .
    "! Converte campos de tabela para formato CDS
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_item | Dados de item
    "! @parameter it_minimum | Dados de alerta mínimo
    "! @parameter it_invasion | Dados de invasão
    "! @parameter es_header_cds | Dados de cabeçalho
    "! @parameter et_item_cds | Dados de item
    "! @parameter et_minimum_cds | Dados de alerta mínimo
    "! @parameter et_invasion_cds | Dados de invasão
    METHODS convert_table_to_cds
      IMPORTING
        !is_header       TYPE ty_header OPTIONAL
        !it_item         TYPE ty_t_item OPTIONAL
        !it_minimum      TYPE ty_t_minimum OPTIONAL
        !it_invasion     TYPE ty_t_invasion OPTIONAL
      EXPORTING
        !es_header_cds   TYPE ty_header_cds
        !et_item_cds     TYPE ty_t_item_cds
        !et_minimum_cds  TYPE ty_t_minimum_cds
        !et_invasion_cds TYPE ty_t_invasion_cds .
    "! Converte resultado da validação em mensagens de retorno
    "! @parameter it_validation | Resultado da validação
    "! @parameter et_return | Mensagens de retorno
    METHODS convert_validation_to_return
      IMPORTING
        !it_validation TYPE ty_t_validation
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Chama BAPI para criação de  condições de preço
    "! @parameter it_bapicondct | Tabela da BAPI
    "! @parameter it_bapicondhd | Tabela da BAPI
    "! @parameter it_bapicondit | Tabela da BAPI
    "! @parameter it_bapicondqs | Tabela da BAPI
    "! @parameter it_bapicondvs | Tabela da BAPI
    "! @parameter it_bapiknumhs | Tabela da BAPI
    "! @parameter it_mem_initial | Tabela da BAPI
    "! @parameter et_return | Mensagens de retorno
    METHODS call_bapi_prices_conditions
      IMPORTING
        !it_bapicondct  TYPE bbpt_cnd_mm_condct
        !it_bapicondhd  TYPE bbpt_cnd_mm_condhd
        !it_bapicondit  TYPE bbpt_cnd_mm_condit
        !it_bapicondqs  TYPE bbpt_cnd_mm_condqs
        !it_bapicondvs  TYPE bbpt_cnd_mm_condvs
        !it_bapiknumhs  TYPE zctgsd_bapiknumhs
        !it_mem_initial TYPE zctgsd_mem_initial
        !iv_cond_no     TYPE knumh
      EXPORTING
        !et_return      TYPE bapiret2_t .
    "! Determina campo linha
    "! @parameter ct_item | Dados de item
    "! @parameter ct_minimum | Dados de alerta mínimo
    "! @parameter ct_invasion | Dados de invasão
    METHODS determine_line
      CHANGING
        !ct_item     TYPE ty_t_item OPTIONAL
        !ct_minimum  TYPE ty_t_minimum OPTIONAL
        !ct_invasion TYPE ty_t_invasion OPTIONAL .
    METHODS cancel_request
      EXPORTING
        et_return   TYPE bapiret2_t
      CHANGING
        cs_header   TYPE ty_header
        ct_item     TYPE ty_t_item
        ct_minimum  TYPE ty_t_minimum
        ct_invasion TYPE ty_t_invasion.
    METHODS status_request
      IMPORTING
        !iv_status       TYPE ztsd_preco_h-status
        !is_header_cds   TYPE ty_header_cds
        !it_item_cds     TYPE ty_t_item_cds
        !it_minimum_cds  TYPE ty_t_minimum_cds
        !it_invasion_cds TYPE ty_t_invasion_cds
        !iv_level        TYPE string
      EXPORTING
        !es_header_cds   TYPE ty_header_cds
        !et_item_cds     TYPE ty_t_item_cds
        !et_minimum_cds  TYPE ty_t_minimum_cds
        !et_invasion_cds TYPE ty_t_invasion_cds
        !et_return       TYPE bapiret2_t .
    "! Recebe tabela de mensagens que retorna da função
    "! @parameter p_task |Identificador da task
    METHODS setup_messages
      IMPORTING
        !p_task TYPE clike .
    "! Recebe tabela de mensagens que retorna da função
    "! @parameter p_task |Identificador da task
    METHODS atuali_messages
      IMPORTING
        !p_task TYPE clike .
  PROTECTED SECTION.

private section.

  data GV_APROVAR type ABAP_BOOL .
  data GT_ITEM_UMB type TY_T_ITEM .
  data GV_VIGENCIA type ABAP_BOOL .
  data GV_PERIODO type ABAP_BOOL .
  class-data:
      "!Armazenamento das mensagens de processamento
    gt_messages TYPE STANDARD TABLE OF bapiret2 .
  class-data GT_MARM type TY_T_MARM .
    "!Flag para sincronizar o processamento da função de criação de ordens de produção
  class-data GV_WAIT_ASYNC type ABAP_BOOL .
  data GV_INCLUSAO type ABAP_BOOL .

    "! Recupera próximo número GUID
    "! @parameter ev_guid | Número GUID
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_guid | Número GUID
  methods GET_NEXT_GUID
    exporting
      !EV_GUID type SYSUUID_X16
      !ET_RETURN type BAPIRET2_T
    returning
      value(RV_GUID) type SYSUUID_X16 .
    "! Recupera próximo Número de documento
    "! @parameter ev_id | Número do documento
    "! @parameter et_return | Mensagens de retorno
    "! @parameter rv_id | Número do documento
  methods GET_NEXT_ID
    exporting
      !EV_ID type ZTSD_PRECO_H-ID
      !ET_RETURN type BAPIRET2_T
    returning
      value(RV_ID) type ZTSD_PRECO_H-ID .
    "! Recupera dados para futura validação
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_item | Dados de item
    "! @parameter et_t001w | Dados de centro
    "! @parameter et_a817 | Dados de preço (CanalDistr/Lst.preços/Centro/Material)
    "! @parameter et_a816 | Dados de preço (CanalDistr/Centro/Material )
    "! @parameter et_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter et_A626 | Dados de preço (Centro/Material)
    "! @parameter et_konp | Dados de Condição
    "! @parameter et_tvtw | Dados de Canal de distribuição
    "! @parameter et_t189 | Dados de Tipo de lista de preço
    "! @parameter et_mara | Dados de material
    "! @parameter et_mbew | Avaliação do material
  methods GET_INFO
    importing
      !IS_HEADER type TY_HEADER
      !IT_ITEM type TY_T_ITEM optional
      !IT_MINIMUM type TY_T_MINIMUM optional
      !IT_INVASION type TY_T_INVASION optional
    exporting
      !ET_USR21 type TY_T_USR21
      !ET_T001W type TY_T_T001W
      !ET_A817 type TY_T_A817
      !ET_A816 type TY_T_A816
      !ET_A627 type TY_T_A627
      !ET_A626 type TY_T_A626
      !ET_KONP type TY_T_KONP
      !ET_KNVV type TY_T_KNVV
      !ET_TVTW type TY_T_TVTW
      !ET_T189 type TY_T_T189
      !ET_MARA type TY_T_MARA
      !ET_MBEW type TY_T_MBEW .
    "! Validação a nível de campos - Cabeçalho
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_t001w | Dados de centro
    "! @parameter ct_validation | Resultado da validação
  methods VALIDATE_HEADER_FIELDS
    importing
      !IV_MSGTY type SY-MSGTY default 'I'
      !IS_HEADER type TY_HEADER
      !IT_USR21 type TY_T_USR21
      !IT_T001W type TY_T_T001W
    changing
      !CT_VALIDATION type TY_T_VALIDATION .
    "! Validação a nível de campos - Item
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_item | Dados de item
    "! @parameter it_a817 | Dados de preço (CanalDistr/Lst.preços/Centro/Material)
    "! @parameter it_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_tvtw | Dados de Canal de distribuição
    "! @parameter it_t189 | Dados de Tipo de lista de preço
    "! @parameter it_mara | Dados de material
    "! @parameter it_mbew | Avaliação do material
    "! @parameter ct_validation | Resultado da validação
  methods VALIDATE_ITEM_FIELDS
    importing
      !IV_MSGTY type SY-MSGTY default 'I'
      !IS_HEADER type TY_HEADER
      !IT_ITEM type TY_T_ITEM
      !IT_A817 type TY_T_A817
      !IT_A816 type TY_T_A816
      !IT_A627 type TY_T_A627
      !IT_A626 type TY_T_A626
      !IT_TVTW type TY_T_TVTW
      !IT_T189 type TY_T_T189
      !IT_MARA type TY_T_MARA
      !IT_MBEW type TY_T_MBEW
      !IT_T001W type TY_T_T001W
      !IT_KONP type TY_T_KONP
      !IT_KNVV type TY_T_KNVV
    changing
      !CT_VALIDATION type TY_T_VALIDATION .
    "! Validação a nível de campos - Alerta mínimo
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_minimum | Dados de alerta mínimo
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_mara | Dados de material
    "! @parameter ct_validation | Resultado da validação
  methods VALIDATE_MINIMUM_FIELDS
    importing
      !IV_MSGTY type SY-MSGTY default 'I'
      !IS_HEADER type TY_HEADER
      !IT_MINIMUM type TY_T_MINIMUM
      !IT_A626 type TY_T_A626
      !IT_MARA type TY_T_MARA
      !IT_T001W type TY_T_T001W
      !IT_TVTW type TY_T_TVTW
    changing
      !CT_VALIDATION type TY_T_VALIDATION .
    "! Validação a nível de campos - Invasão
    "! @parameter iv_msgty | Tipo da mensagem retornada
    "! @parameter is_header | Dados de cabeçalho
    "! @parameter it_invasion | Dados de invasão
    "! @parameter it_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter it_t189 | Dados de Tipo de lista de preço
    "! @parameter ct_validation | Resultado da validação
  methods VALIDATE_INVASION_FIELDS
    importing
      !IV_MSGTY type SY-MSGTY default 'I'
      !IS_HEADER type TY_HEADER
      !IT_INVASION type TY_T_INVASION
      !IT_A627 type TY_T_A627
      !IT_T189 type TY_T_T189
      !IT_KNVV type TY_T_KNVV
    changing
      !CT_VALIDATION type TY_T_VALIDATION .
    "! Atualiza dados após validações - Item
    "! @parameter it_a817 | Dados de preço (CanalDistr/Lst.preços/Centro/Material)
    "! @parameter it_a816 | Dados de preço (CanalDistr/Centro/Lst.preços)
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_konp | Dados de Condição
    "! @parameter it_mbew | Avaliação do material
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_item | Dados de item
  methods UPDATE_ITEM_FIELDS
    importing
      !IT_A817 type TY_T_A817
      !IT_A816 type TY_T_A816
      !IT_A626 type TY_T_A626
      !IT_KONP type TY_T_KONP
      !IT_MBEW type TY_T_MBEW
    changing
      !CS_HEADER type TY_HEADER
      !CT_ITEM type TY_T_ITEM .
    "! Atualiza dados após validações - Alerta mínimo
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_konp | Dados de Condição
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_minimum | Dados de alerta mínimo
  methods UPDATE_MINIMUM_FIELDS
    importing
      !IT_A626 type TY_T_A626
      !IT_KONP type TY_T_KONP
    changing
      !CS_HEADER type TY_HEADER
      !CT_MINIMUM type TY_T_MINIMUM .
    "! Atualiza dados após validações - Invasão
    "! @parameter it_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter it_konp | Dados de Condição
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_invasion | Dados de invasão
  methods UPDATE_INVASION_FIELDS
    importing
      !IT_A627 type TY_T_A627
      !IT_KONP type TY_T_KONP
      !IT_KNVV type TY_T_KNVV
    changing
      !CS_HEADER type TY_HEADER
      !CT_INVASION type TY_T_INVASION .
    "! Atualiza campo criticalidade
    "! @parameter is_validation | Resultado da validação
    "! @parameter cs_data | Dados de cabeçalho/item
  methods UPDATE_FIELD_CRITICALITY
    importing
      !IS_VALIDATION type TY_VALIDATION optional
    changing
      !CS_DATA type ANY .
    "! Ordena resultado da validação por ordem de prioridade
    "! @parameter ct_validation | Resultado da validação
  methods SORT_VALIDATION
    changing
      !CT_VALIDATION type TY_T_VALIDATION .
    "! Chama BAPI para lançar registros de condição de uso de preço
    "! @parameter it_a817 | Dados de preço (CanalDistr/Lst.preços/Centro/Material)
    "! @parameter it_a816 | Dados de preço (CanalDistr/Centro/Material)
    "! @parameter it_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_konp | Dados de Condição
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cs_header | Dados de cabeçalho
    "! @parameter ct_item | Dados de item
  methods CREATE_PRICE_CONDITION
    importing
      !IT_A817 type TY_T_A817 optional
      !IT_A816 type TY_T_A816 optional
      !IT_A627 type TY_T_A627 optional
      !IT_A626 type TY_T_A626 optional
      !IT_KONP type TY_T_KONP
    exporting
      !ET_RETURN type BAPIRET2_T
    changing
      !CS_HEADER type TY_HEADER
      !CT_ITEM type TY_T_ITEM optional
      !CT_MINIMUM type TY_T_MINIMUM optional
      !CT_INVASION type TY_T_INVASION optional .
    "! Monta configurações que serão utilizados na montagem da BAPI
    "! @parameter it_a817 | Dados de preço (CanalDistr/Lst.preços/Centro/Material)
    "! @parameter it_a816 | Dados de preço (CanalDistr/Centro/Material)
    "! @parameter it_a627 | Dados de preço (Centro/Lst.preços)
    "! @parameter it_A626 | Dados de preço (Centro/Material)
    "! @parameter it_item | Dados de item
    "! @parameter es_bapiconfig | Configurações
    "! @parameter et_item_qs | Itens que compõem o lançamento atual
  methods GET_PRICE_CONFIGURATION
    importing
      !IS_HEADER type TY_HEADER
      !IS_ITEM type TY_ITEM
      !IT_A817 type TY_T_A817 optional
      !IT_A816 type TY_T_A816 optional
      !IT_A627 type TY_T_A627 optional
      !IT_A626 type TY_T_A626 optional
      !IT_INVASION type TY_T_INVASION optional
      !IT_ITEM type TY_T_ITEM
    exporting
      !ES_BAPICONFIG type BAPICONDCT
      !ET_ITEM_QS type TY_T_ITEM .
  methods DELETE_PRICE_CONDITION
    importing
      !IT_A817 type TY_T_A817 optional
      !IT_A816 type TY_T_A816 optional
      !IT_A627 type TY_T_A627 optional
      !IT_A626 type TY_T_A626 optional
      !IT_KONP type TY_T_KONP
    exporting
      !ET_RETURN type BAPIRET2_T
    changing
      !CS_HEADER type TY_HEADER
      !CT_ITEM type TY_T_ITEM optional
      !CT_MINIMUM type TY_T_MINIMUM optional
      !CT_INVASION type TY_T_INVASION optional .
  methods COMPARE_DATA_GET_STATUS
    changing
      value(CV_STATUS_NEW) type ZTSD_PRECO_H-STATUS
      !CS_HEADER type TY_HEADER
      !CT_ITEM type TY_T_ITEM
      !CT_MINIMUM type TY_T_MINIMUM
      !CT_INVASION type TY_T_INVASION .
  methods UPDATE_FIELD_MESSAGE
    importing
      !IT_VALIDATION type TY_T_VALIDATION
    changing
      !CT_RETURN type BAPIRET2_T .
  methods CLEAR_MESSAGE
    importing
      !IS_HEADER_CDS type ZCLSD_GESTAO_PRECO_EVENTS=>TY_HEADER_CDS .
  methods VALIDATION_INITIAL_ITEM_FIELD
    importing
      !IV_MSGTY type SY-MSGTY
      !IS_ITEM type ZCLSD_GESTAO_PRECO_EVENTS=>TY_ITEM
    changing
      !CT_VALIDATION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_VALIDATION .
  methods VALIDATION_INITIAL_MIN_FIELD
    importing
      !IV_MSGTY type SY-MSGTY
      !IS_MINIMUM type ZCLSD_GESTAO_PRECO_EVENTS=>TY_MINIMUM
    changing
      !CT_VALIDATION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_VALIDATION .
  methods VALIDATION_INITIAL_INV_FIELD
    importing
      !IV_MSGTY type SY-MSGTY
      !IS_INVASION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_INVASION
    changing
      !CT_VALIDATION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_VALIDATION .
  methods DATA_CALCULATION
    importing
      !IV_DATA type BEGDA
      !IV_SINAL type CHAR1
    returning
      value(RV_DATA) type BEGDA .
  methods DELETE_PRICE_LIST
    changing
      !CT_ITEM_ELIM type TY_T_ITEM
      !CT_ITEM type TY_T_ITEM
      !CS_HEADER type TY_HEADER
      !CT_RETURN type BAPIRET2_T .
  methods DELETE_INVASION
    changing
      !CT_INV_ELIM type TY_T_INVASION
      !CT_INVASION type TY_T_INVASION
      !CS_HEADER type TY_HEADER
      !CT_RETURN type BAPIRET2_T .
  methods UPDATE_DATA
    importing
      !IS_ITEM_KEY type ZTSD_PRECO_I
      !IT_ITEM type TY_T_ITEM
    exporting
      !ET_RETURN type BAPIRET2_T .
  methods CONVERT_UMB
    importing
      !IS_ITEM_KEY type ZTSD_PRECO_I
    returning
      value(RV_KMEIN) type KONP-KMEIN .
  methods CHECK_DATA_SAP_FILE
    importing
      !IT_A817 type TY_T_A817
      !IT_A816 type TY_T_A816
      !IS_ITEM_KEY type ZCLSD_GESTAO_PRECO_EVENTS=>TY_ITEM
      !IT_KONP type TY_T_KONP .
  methods CONVERSION_UNIT
    importing
      !IV_BASE_UNIT type MEINS
    returning
      value(RV_MEINH) type MARM-MEINH .
  methods GET_FRAN
    importing
      !IS_ITEM type ZCLSD_GESTAO_PRECO_EVENTS=>TY_ITEM
    returning
      value(RV_DEC) type CHAR3 .
  methods VALIDATION_DATA
    importing
      !IV_MSGTY type SY-MSGTY
      !IV_FROM_DATA type SY-DATUM
      !IV_TO_DATA type SY-DATUM
      !IV_GUID type SYSUUID_X16
      !IV_LINE type BAPI_LINE
    changing
      !CT_VALIDATION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_VALIDATION .
  methods VALIDATION_DATA_UPDATE
    importing
      !IV_FROM_DATA type SY-DATUM
      !IV_TO_DATA type SY-DATUM
    changing
      !CT_RETURN type BAPIRET2_T .
  methods VALIDATION_FIELDS_ON_UPDATE
    importing
      !IV_MSGTY type SYST_MSGTY default 'I'
      !IT_INVASION type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_INVASION
      !IT_MINIMUM type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_MINIMUM
      !IT_ITEM type ZCLSD_GESTAO_PRECO_EVENTS=>TY_T_ITEM
    changing
      !CT_RETURN type BAPIRET2_T
      !CT_VALIDATION type TY_T_VALIDATION .
  methods UPDATE_LOG_BDCP2
    importing
      !IT_RETURN type BAPIRET2_T .
  methods GET_COND_NO
    changing
      !CS_BAPICONFIG type BAPICONDCT .
ENDCLASS.



CLASS ZCLSD_GESTAO_PRECO_EVENTS IMPLEMENTATION.


  METHOD get_layout.

    DATA: lt_file      TYPE zctgsd_preco_arquivo,
          lt_file_min  TYPE zctgsd_preco_arquivo_min,
          lt_file_inv  TYPE zctgsd_preco_arquivo_inv,
          lv_extension TYPE char10,
          lv_mimetype  TYPE w3conttype.

    FREE: ev_file, ev_filename, ev_mimetype, et_return.

* ----------------------------------------------------------------------
* Criar arquivo excel
* ----------------------------------------------------------------------

    CASE iv_tablename.

      WHEN 'A817' OR 'A816'.    " Preços

        "Verifica a Autorização do User - Baixar Layout - Preço
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_01' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        ev_filename = 'layout_preco.xlsx'.

        DATA(lo_excel) = NEW zclca_excel( iv_filename = ev_filename ).
        lo_excel->create_document( EXPORTING it_table  = lt_file
                                   IMPORTING ev_file   = ev_file
                                             et_return = et_return ).

      WHEN 'A626'.              " Alerta mínimo

        "Verifica a Autorização do User - Baixar Layout - Alerta mínimo
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_07' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        ev_filename = 'layout_minimo.xlsx'.

        lo_excel = NEW zclca_excel( iv_filename = ev_filename ).
        lo_excel->create_document( EXPORTING it_table  = lt_file_min
                                   IMPORTING ev_file   = ev_file
                                             et_return = et_return ).

      WHEN 'A627'.   " Invasão

        "Verifica a Autorização do User - Baixar Layout - Invasão
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_13' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        ev_filename = 'layout_invasao.xlsx'.

        lo_excel = NEW zclca_excel( iv_filename = ev_filename ).
        lo_excel->create_document( EXPORTING it_table  = lt_file_inv
                                   IMPORTING ev_file   = ev_file
                                             et_return = et_return ).

      WHEN OTHERS.
        " Layout indisponível.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '027' ) ).

    ENDCASE.

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

    SPLIT ev_filename AT '.' INTO DATA(lv_name) lv_extension.

    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = lv_extension
      IMPORTING
        mimetype  = lv_mimetype.

    ev_mimetype = lv_mimetype.

  ENDMETHOD.


  METHOD upload_file.

    FREE: et_return.

    gs_upload = abap_true.

    CASE iv_tablename.

      WHEN 'A817' OR 'A816'.    " Preços

        "Verifica a Autorização do User - Carga de Dados - Preço
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_02' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        me->upload_price_file( EXPORTING iv_file      = iv_file
                                         iv_filename  = iv_filename
                               IMPORTING et_return    = et_return ).

      WHEN 'A626'.              " Alerta mínimo

        "Verifica a Autorização do User - Carga de Dados - Alerta mínimo
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_08' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        me->upload_min_file( EXPORTING iv_file      = iv_file
                                       iv_filename  = iv_filename
                             IMPORTING et_return    = et_return ).

      WHEN 'A627'.              " Invasão

        "Verifica a Autorização do User - Carga de Dados - Invasão
        AUTHORITY-CHECK OBJECT 'ZSD_CGP_14' FOR USER sy-uname
          ID 'ACTVT' FIELD '01'.
        IF sy-subrc NE 0.
          "Usuário não autorizado!
          et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '071' ) ).
          IF line_exists( et_return[ type = 'E' ] ).
            me->format_return( CHANGING ct_return = et_return ).
          ENDIF.
          RETURN.
        ENDIF.

        me->upload_inv_file( EXPORTING iv_file      = iv_file
                                       iv_filename  = iv_filename
                             IMPORTING et_return    = et_return ).
    ENDCASE.
    CLEAR: gs_upload.

  ENDMETHOD.


  METHOD upload_price_file.

    DATA: lt_file   TYPE zctgsd_preco_arquivo.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = me->gs_parameter
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.
* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    DATA(lo_excel) = NEW zclca_excel( iv_filename = iv_filename
                                      iv_file     = iv_file ).
    lo_excel->gv_quant = abap_true.
    lo_excel->get_sheet( IMPORTING et_return = DATA(lt_return)              " Ignorar validação durante carga
                         CHANGING  ct_table  = lt_file[] ).

    IF line_exists( lt_return[ number = '008' ] ) OR line_exists( lt_return[ number = '009' ] ). "#EC CI_STDSEQ
      et_return = lt_return.
      RETURN.
    ENDIF.
* ---------------------------------------------------------------------------
* Prepara dados para salvar
* ---------------------------------------------------------------------------
    me->prepare_price_file( EXPORTING it_file   = lt_file[]
                            IMPORTING es_header = DATA(ls_header)
                                      et_item   = DATA(lt_item)
                                      et_return = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida dados importados
* ---------------------------------------------------------------------------
    me->validate_info( IMPORTING et_validation = DATA(lt_validation)
                                 et_return     = et_return
                       CHANGING  cs_header     = ls_header
                                 ct_item       = lt_item ).

* ---------------------------------------------------------------------------
* Aplica avisos nos campos validados
* ---------------------------------------------------------------------------
    me->prepare_price_criticality( EXPORTING it_validation = lt_validation
                                   CHANGING  cs_header     = ls_header
                                             ct_item       = lt_item ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.
* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
    me->save_file( EXPORTING iv_level  = space
                             is_header = ls_header
                             it_item   = lt_item
                   IMPORTING et_return = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Prepara mensagens
* ---------------------------------------------------------------------------
    me->convert_validation_to_return( EXPORTING it_validation = lt_validation
                                      IMPORTING et_return     = lt_return ).

    me->update_field_message( EXPORTING it_validation = lt_validation CHANGING ct_return = lt_return ).

  ENDMETHOD.


  METHOD upload_min_file.

    DATA: lt_file   TYPE zctgsd_preco_arquivo_min.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = me->gs_parameter
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    DATA(lo_excel) = NEW zclca_excel( iv_filename = iv_filename
                                      iv_file     = iv_file ).

    lo_excel->get_sheet( IMPORTING et_return = DATA(lt_return)              " Ignorar validação durante carga
                         CHANGING  ct_table  = lt_file[] ).

* ---------------------------------------------------------------------------
* Prepara dados para salvar
* ---------------------------------------------------------------------------
    me->prepare_min_file( EXPORTING it_file    = lt_file[]
                          IMPORTING es_header  = DATA(ls_header)
                                    et_minimum = DATA(lt_minimum)
                                    et_return = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida dados importados
* ---------------------------------------------------------------------------
    me->validate_info( IMPORTING et_validation = DATA(lt_validation)
                       CHANGING  cs_header     = ls_header
                                 ct_minimum    = lt_minimum ).

* ---------------------------------------------------------------------------
* Aplica avisos nos campos validados
* ---------------------------------------------------------------------------
    me->prepare_price_criticality( EXPORTING it_validation = lt_validation
                                   CHANGING  cs_header     = ls_header
                                             ct_minimum    = lt_minimum ).

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
    me->save_file( EXPORTING iv_level   = space
                             is_header  = ls_header
                             it_minimum = lt_minimum
                   IMPORTING et_return  = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD upload_inv_file.

    DATA: lt_file   TYPE zctgsd_preco_arquivo_inv.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = me->gs_parameter
                                     et_return    = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Converte arquivo excel para tabela
* ---------------------------------------------------------------------------
    DATA(lo_excel) = NEW zclca_excel( iv_filename = iv_filename
                                      iv_file     = iv_file ).

    lo_excel->get_sheet( IMPORTING et_return = DATA(lt_return)              " Ignorar validação durante carga
                         CHANGING  ct_table  = lt_file[] ).

* ---------------------------------------------------------------------------
* Prepara dados para salvar
* ---------------------------------------------------------------------------
    me->prepare_inv_file( EXPORTING it_file     = lt_file[]
                          IMPORTING es_header   = DATA(ls_header)
                                    et_invasion = DATA(lt_invasion)
                                    et_return  = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Valida dados importados
* ---------------------------------------------------------------------------
    me->validate_info( IMPORTING et_validation = DATA(lt_validation)
                       CHANGING  cs_header     = ls_header
                                 ct_invasion   = lt_invasion ).

* ---------------------------------------------------------------------------
* Aplica avisos nos campos validados
* ---------------------------------------------------------------------------
    me->prepare_price_criticality( EXPORTING it_validation = lt_validation
                                   CHANGING  cs_header     = ls_header
                                             ct_invasion   = lt_invasion ).

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
    me->save_file( EXPORTING iv_level    = space
                             is_header   = ls_header
                             it_invasion = lt_invasion
                   IMPORTING et_return   = et_return ).

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD prepare_price_file.

    DATA: lt_return TYPE bapiret2_t.

    FREE: es_header, et_item, et_return.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Monta dados de cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_file REFERENCE INTO DATA(ls_file).

      DATA(lv_index) = sy-tabix.

      IF es_header IS INITIAL.

        es_header-guid                   = me->get_next_guid( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-id                     = me->get_next_id( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-status                 = gc_status-rascunho.
        es_header-condition_type         = me->gs_parameter-kschl_zpr0.
        es_header-request_user           = sy-uname.
*        es_header-plant                  = ls_file->plant.
        es_header-created_by             = sy-uname.
        es_header-created_at             = lv_timestamp.
        es_header-local_last_changed_at  = lv_timestamp.
        es_header-import_time            = sy-timlo.
      ENDIF.

* ---------------------------------------------------------------------------
* Monta dados de item
* ---------------------------------------------------------------------------
      et_item = VALUE #( BASE et_item (
                guid                  = es_header-guid
                guid_line             = me->get_next_guid( IMPORTING et_return = et_return )
                line                  = lv_index
                status                = gc_status-rascunho
                dist_channel          = ls_file->dist_channel
                price_list            = ls_file->price_list
                material              = ls_file->material
                plant                 = ls_file->plant
                scale                 = ls_file->scale
                base_unit             = ls_file->base_unit
                min_value             = ls_file->min_value
                sug_value             = ls_file->sug_value
                max_value             = ls_file->max_value
                currency              = 'BRL'
                date_from             = ls_file->date_from
                date_to               = ls_file->date_to
                zzdelete              = ls_file->delete
                created_by            = es_header-created_by
                created_at            = es_header-created_at
                last_changed_by       = es_header-last_changed_by
                last_changed_at       = es_header-last_changed_at
                local_last_changed_at = es_header-local_last_changed_at
                ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_min_file.

    DATA: lt_return TYPE bapiret2_t.

    FREE: es_header, et_minimum, et_return.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Monta dados de cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_file REFERENCE INTO DATA(ls_file).

      DATA(lv_index) = sy-tabix.

      IF es_header IS INITIAL.

        es_header-guid                   = me->get_next_guid( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-id                     = me->get_next_id( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-status                 = gc_status-rascunho.
        es_header-condition_type         = me->gs_parameter-kschl_zvmc.
        es_header-request_user           = sy-uname.
*        es_header-plant                  = ls_file->plant.
        es_header-created_by             = sy-uname.
        es_header-created_at             = lv_timestamp.
        es_header-local_last_changed_at  = lv_timestamp.
        es_header-import_time            = sy-timlo.
      ENDIF.

* ---------------------------------------------------------------------------
* Monta dados de item
* ---------------------------------------------------------------------------
      et_minimum = VALUE #( BASE et_minimum (
                   guid                  = es_header-guid
                   guid_line             = me->get_next_guid( IMPORTING et_return = et_return )
                   line                  = lv_index
                   status                = gc_status-rascunho
                   material              = ls_file->material
                   dist_channel          = ls_file->dist_channel
                   plant                 = ls_file->plant
                   min_value             = ls_file->min_value
                   currency              = 'BRL'
                   date_from             = ls_file->date_from
                   date_to               = ls_file->date_to
                   created_by            = es_header-created_by
                   created_at            = es_header-created_at
                   last_changed_by       = es_header-last_changed_by
                   last_changed_at       = es_header-last_changed_at
                   local_last_changed_at = es_header-local_last_changed_at
                   ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD prepare_inv_file.

    DATA: lt_return TYPE bapiret2_t.

    FREE: es_header, et_invasion, et_return.

    GET TIME STAMP FIELD DATA(lv_timestamp).

* ---------------------------------------------------------------------------
* Monta dados de cabeçalho
* ---------------------------------------------------------------------------
    LOOP AT it_file REFERENCE INTO DATA(ls_file).

      DATA(lv_index) = sy-tabix.

      IF es_header IS INITIAL.

        es_header-guid                   = me->get_next_guid( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-id                     = me->get_next_id( IMPORTING et_return = et_return ).

        IF line_exists( et_return[ type = 'E' ] ).       "#EC CI_STDSEQ
          me->format_return( CHANGING ct_return = et_return ).
          RETURN.
        ENDIF.

        es_header-status                 = gc_status-rascunho.
        es_header-condition_type         = me->gs_parameter-kschl_zalt.
        es_header-request_user           = sy-uname.
        "es_header-plant                  = ls_file->plant.
        es_header-created_by             = sy-uname.
        es_header-created_at             = lv_timestamp.
        es_header-local_last_changed_at  = lv_timestamp.
        es_header-import_time            = sy-timlo.
      ENDIF.

* ---------------------------------------------------------------------------
* Monta dados de item
* ---------------------------------------------------------------------------
      et_invasion = VALUE #( BASE et_invasion (
                     guid                  = es_header-guid
                     guid_line             = me->get_next_guid( IMPORTING et_return = et_return )
                     line                  = lv_index
                     status                = gc_status-rascunho
                     "price_list            = ls_file->price_list
*                     min_value             = ls_file->min_value
                     kunnr                 = ls_file->kunnr
                     currency              = 'BRL'
                     date_from             = ls_file->date_from
                     date_to               = ls_file->date_to
                     zzdelete              = ls_file->delete
                     created_by            = es_header-created_by
                     created_at            = es_header-created_at
                     last_changed_by       = es_header-last_changed_by
                     last_changed_at       = es_header-last_changed_at
                     local_last_changed_at = es_header-local_last_changed_at
                     ) ).
    ENDLOOP.

  ENDMETHOD.


  METHOD save_file.

* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------
* OBS: não salvar a tabela quando a CDS estiver manipulando
* ---------------------------------------------------------------------------
* ---------------------------------------------------------------------------

    FREE: et_return.

    IF  it_item IS INITIAL
    AND it_minimum IS INITIAL
    AND it_invasion IS INITIAL.
      " Arquivo de carga vazio.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '001' ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de Cabeçalho
* ---------------------------------------------------------------------------
    IF iv_level NE gc_level-header.
      MODIFY ztsd_preco_h FROM is_header.

      IF sy-subrc NE 0.
        " Falha ao salvar arquivo de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de Item
* ---------------------------------------------------------------------------
    IF iv_level NE gc_level-item AND it_item[] IS NOT INITIAL.

      MODIFY ztsd_preco_i FROM TABLE it_item[].

      IF sy-subrc NE 0.
        " Falha ao salvar arquivo de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de Alerta mínimo
* ---------------------------------------------------------------------------
    IF iv_level NE gc_level-minimum AND it_minimum[] IS NOT INITIAL.

      MODIFY ztsd_preco_m FROM TABLE it_minimum[].

      IF sy-subrc NE 0.
        " Falha ao salvar arquivo de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Salva dados de Invasão
* ---------------------------------------------------------------------------
    IF iv_level NE gc_level-invasion AND it_invasion[] IS NOT INITIAL.

      MODIFY ztsd_preco_inv FROM TABLE it_invasion[].

      IF sy-subrc NE 0.
        " Falha ao salvar arquivo de carga.
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '002' ) ).
        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
      ENDIF.
    ENDIF.

    " Carga realizada com sucesso.
    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '030' ) ).
    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD get_next_guid.

    FREE: ev_guid, et_return.

    TRY.
        rv_guid = ev_guid = cl_system_uuid=>create_uuid_x16_static( ).

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
        et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '000'
                                                message_v1 = lv_message+0(50)
                                                message_v2 = lv_message+50(50)
                                                message_v3 = lv_message+100(50)
                                                message_v4 = lv_message+150(50) ) ).

        me->format_return( CHANGING ct_return = et_return ).
        RETURN.
    ENDTRY.

  ENDMETHOD.


  METHOD get_next_id.

    DATA: ls_return TYPE bapiret2,
          lv_object TYPE nrobj VALUE 'ZSD_PRECO',
          lv_range  TYPE nrnr  VALUE '01'.

    FREE: et_return, ev_id.

* ---------------------------------------------------------------------------
* Travar objeto de numeração
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING
        object           = lv_object
      EXCEPTIONS
        foreign_lock     = 1
        object_not_found = 2
        system_failure   = 3
        OTHERS           = 4.

    IF sy-subrc NE 0.
      " Objeto de numeração ZSD_PRECO não existe. Cadastrar na SNRO.
      et_return[] =  VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '003' message_v1 = lv_object ) ).
      me->format_return( CHANGING ct_return = et_return ).
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Recuperar novo número da requisição
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = lv_range
        object                  = lv_object
      IMPORTING
        number                  = ev_id
      EXCEPTIONS
        interval_not_found      = 1
        number_range_not_intern = 2
        object_not_found        = 3
        quantity_is_0           = 4
        quantity_is_not_1       = 5
        interval_overflow       = 6
        buffer_overflow         = 7
        OTHERS                  = 8.

    IF sy-subrc NE 0.
      et_return[] =  VALUE #( BASE et_return ( type = sy-msgty id = sy-msgid number = sy-msgno
                                               message_v1 = sy-msgv1
                                               message_v2 = sy-msgv2
                                               message_v3 = sy-msgv3
                                               message_v4 = sy-msgv4 ) ).

      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.

* ---------------------------------------------------------------------------
* Destravar objeto de numeração
* ---------------------------------------------------------------------------
    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING
        object           = lv_object
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    IF sy-subrc NE 0.
      et_return[] =  VALUE #( BASE et_return ( type = sy-msgty id = sy-msgid number = sy-msgno
                                               message_v1 = sy-msgv1
                                               message_v2 = sy-msgv2
                                               message_v3 = sy-msgv3
                                               message_v4 = sy-msgv4 ) ).

      me->format_return( CHANGING ct_return = et_return ).
    ENDIF.

    rv_id = ev_id.

  ENDMETHOD.


  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      CHECK ls_return->message IS INITIAL.

      TRY.
          CALL FUNCTION 'FORMAT_MESSAGE'
            EXPORTING
              id        = ls_return->id
              lang      = sy-langu
              no        = ls_return->number
              v1        = ls_return->message_v1
              v2        = ls_return->message_v2
              v3        = ls_return->message_v3
              v4        = ls_return->message_v4
            IMPORTING
              msg       = ls_return->message
            EXCEPTIONS
              not_found = 1
              OTHERS    = 2.

          IF sy-subrc <> 0.
            CLEAR ls_return->message.
          ENDIF.

        CATCH cx_root INTO DATA(lo_root).
          DATA(lv_message) = lo_root->get_longtext( ).
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.


  METHOD validate_info.

    FREE: et_validation, et_return.

* ---------------------------------------------------------------------------
* Recupera parâmetros de configuração
* ---------------------------------------------------------------------------
    me->get_configuration( IMPORTING es_parameter = DATA(ls_parameter)
                                     et_return    = et_return ).

    " Armazena erros a nível de cabeçalho
    et_validation = VALUE #( BASE et_validation FOR ls_return IN et_return (
                    guid       = cs_header-guid
                    line       = 0
                    status     = gc_status-alerta
                    type       = ls_return-type
                    id         = ls_return-id
                    number     = ls_return-number
                    message    = ls_return-message
                    log_no     = ls_return-log_no
                    log_msg_no = ls_return-log_msg_no
                    message_v1 = ls_return-message_v1
                    message_v2 = ls_return-message_v2
                    message_v3 = ls_return-message_v3
                    message_v4 = ls_return-message_v4
                    parameter  = ls_return-parameter
                    row        = 0
                    field      = ls_return-field
                    system     = ls_return-system ) ).

* ---------------------------------------------------------------------------
* Recupera dados para validação
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING is_header   = cs_header
                            it_item     = ct_item
                            it_minimum  = ct_minimum
                            it_invasion = ct_invasion
                  IMPORTING et_usr21    = DATA(lt_usr21)
                            et_t001w    = DATA(lt_t001w)
                            et_a817     = DATA(lt_a817)
                            et_a816     = DATA(lt_a816)
                            et_a627     = DATA(lt_a627)
                            et_a626     = DATA(lt_a626)
                            et_konp     = DATA(lt_konp)
                            et_knvv     = DATA(lt_knvv)
                            et_tvtw     = DATA(lt_tvtw)
                            et_t189     = DATA(lt_t189)
                            et_mara     = DATA(lt_mara)
                            et_mbew     = DATA(lt_mbew) ).

* ---------------------------------------------------------------------------
* Aplica validação a nível de campo
* ---------------------------------------------------------------------------
    IF gs_upload NE abap_true AND gs_modify NE abap_true.
*      me->validate_header_fields( EXPORTING iv_msgty      = iv_msgty
*                                            is_header     = cs_header
*                                            it_usr21      = lt_usr21
*                                            it_t001w      = lt_t001w
*                                  CHANGING  ct_validation = et_validation ).

      me->validate_item_fields( EXPORTING iv_msgty      = iv_msgty
                                          is_header     = cs_header
                                          it_item       = ct_item
                                          it_a817       = lt_a817
                                          it_a816       = lt_a816
                                          it_a627       = lt_a627
                                          it_a626       = lt_a626
                                          it_tvtw       = lt_tvtw
                                          it_t189       = lt_t189
                                          it_mara       = lt_mara
                                          it_mbew       = lt_mbew
                                          it_t001w      = lt_t001w
                                          it_konp       = lt_konp
                                          it_knvv       = lt_knvv
                                CHANGING  ct_validation = et_validation ).

      me->validate_minimum_fields( EXPORTING iv_msgty      = iv_msgty
                                             is_header     = cs_header
                                             it_minimum    = ct_minimum
                                             it_a626       = lt_a626
                                             it_mara       = lt_mara
                                             it_t001w      = lt_t001w
                                             it_tvtw       = lt_tvtw
                                   CHANGING  ct_validation = et_validation ).

      me->validate_invasion_fields( EXPORTING iv_msgty      = iv_msgty
                                              is_header     = cs_header
                                              it_invasion   = ct_invasion
                                              it_a627       = lt_a627
                                              it_t189       = lt_t189
                                              it_knvv       = lt_knvv
                                    CHANGING  ct_validation = et_validation ).

    ELSEIF gs_upload EQ abap_true.

      validation_fields_on_update( EXPORTING
                                    iv_msgty      = iv_msgty
                                    it_invasion   = ct_invasion
                                    it_minimum    = ct_minimum
                                    it_item       = ct_item
                                   CHANGING
                                    ct_return     = et_return
                                    ct_validation = et_validation ).
    ENDIF.
* ---------------------------------------------------------------------------
* Atualizar campos informativos
* ---------------------------------------------------------------------------
    me->update_item_fields( EXPORTING it_a817     = lt_a817
                                      it_a816     = lt_a816
                                      it_a626     = lt_a626
                                      it_konp     = lt_konp
                                      it_mbew     = lt_mbew
                            CHANGING  cs_header   = cs_header
                                      ct_item     = ct_item ).

    me->update_minimum_fields( EXPORTING it_a626     = lt_a626
                                         it_konp     = lt_konp
                               CHANGING  cs_header   = cs_header
                                         ct_minimum  = ct_minimum ).

    me->update_invasion_fields( EXPORTING it_a627     = lt_a627
                                          it_konp     = lt_konp
                                          it_knvv     = lt_knvv
                                CHANGING  cs_header   = cs_header
                                          ct_invasion = ct_invasion ).

* ---------------------------------------------------------------------------
* Ordena validação pelo mais prioritário
* ---------------------------------------------------------------------------
    me->sort_validation( CHANGING ct_validation = et_validation ).

  ENDMETHOD.


  METHOD validation_fields_on_update.

    " ---------------------------------------------------------------------
    " Valida dados itens ao realizar carga
    " ---------------------------------------------------------------------
    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      " ---------------------------------------------------------------------
      " Valida se a Data Desde e Data Até são válidas
      " ---------------------------------------------------------------------
      IF <fs_item>-dist_channel = '13' AND gv_aprovar NE abap_true.

        " Verificar moeda para canal de exportação.
        ct_validation = VALUE #( BASE ct_validation ( guid       = <fs_item>-guid
                                                      line       = <fs_item>-line
                                                      row        = <fs_item>-line
                                                      status     = gc_status-alertaexp
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '058'
                                                      message_v1 = <fs_item>-currency
                                                      field      = 'CURRENCY' ) ).
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida se a Data Desde e Data Até são válidas
      " ---------------------------------------------------------------------
      validation_data_update( EXPORTING
                               iv_from_data = <fs_item>-date_from
                               iv_to_data   = <fs_item>-date_to
                              CHANGING
                               ct_return = ct_return ).
      IF ct_return IS NOT INITIAL.
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Data Desde e Data Até
      " ---------------------------------------------------------------------
      IF <fs_item>-date_from > <fs_item>-date_to.

        " Data início é superior à Data fim.
        ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '053' ) ).
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.
    ENDLOOP.

    " ---------------------------------------------------------------------
    " Valida dados mínimo ao realizar carga
    " ---------------------------------------------------------------------
    LOOP AT it_minimum ASSIGNING FIELD-SYMBOL(<fs_minimum>).

      " ---------------------------------------------------------------------
      " Valida se a Data Desde e Data Até são válidas
      " ---------------------------------------------------------------------
      validation_data_update( EXPORTING
                               iv_from_data = <fs_minimum>-date_from
                               iv_to_data   = <fs_minimum>-date_to
                              CHANGING
                               ct_return = ct_return ).
      IF ct_return IS NOT INITIAL.
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Data Desde e Data Até
      " ---------------------------------------------------------------------
      IF <fs_minimum>-date_from > <fs_minimum>-date_to.
        ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '053' ) ).
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.

    ENDLOOP.

    " ---------------------------------------------------------------------
    " Valida dados invasão ao realizar carga
    " ---------------------------------------------------------------------
    LOOP AT it_invasion ASSIGNING FIELD-SYMBOL(<fs_invasion>).

      " ---------------------------------------------------------------------
      " Valida se a Data Desde e Data Até são válidas
      " ---------------------------------------------------------------------
      validation_data_update( EXPORTING
                               iv_from_data = <fs_invasion>-date_from
                               iv_to_data   = <fs_invasion>-date_to
                              CHANGING
                               ct_return = ct_return ).

      IF ct_return IS NOT INITIAL.
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Data Desde e Data Até
      " ---------------------------------------------------------------------
      IF <fs_invasion>-date_from > <fs_invasion>-date_to.
        " Data início é superior à Data fim.
        ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '053') ).
        me->format_return( CHANGING ct_return = ct_return ).
        RETURN.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD validation_data_update.

    DATA: lv_flag      TYPE char5,
          lv_from_date TYPE char10,
          lv_to_date   TYPE char10.

    lv_from_date = |{ iv_from_data+6(2) }.{ iv_from_data+4(2) }.{ iv_from_data(4) }|.
    lv_to_date   = |{ iv_to_data+6(2) }.{ iv_to_data+4(2) }.{ iv_to_data(4) }|.

    CALL FUNCTION 'CRM_MA_VALID_DATE_CHECK'
      EXPORTING
        iv_from_date                   = lv_from_date
        iv_to_date                     = lv_to_date
      IMPORTING
        ev_flag                        = lv_flag
      EXCEPTIONS
        from_date_is_not_valid         = 1
        to_date_is_not_valid           = 2
        from_date_greater_than_to_date = 3
        OTHERS                         = 4.

    IF sy-subrc = 1.
      ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '054' ) ).
    ELSEIF sy-subrc = 2.
      ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '054' ) ).
    ELSEIF sy-subrc = 3.
      ct_return[] = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '055' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD get_info.

    DATA: lt_item      TYPE ty_t_item,
          lt_usr21_key TYPE ty_t_usr21_key,
          lt_knumh_key TYPE ty_t_knumh_key.

    FREE: et_usr21,
          et_t001w,
          et_a817,
          et_a627,
          et_a626,
          et_konp,
          et_tvtw,
          et_t189,
          et_mara,
          et_mbew.

    " Monta tabela de chaves
    INSERT is_header-request_user INTO TABLE lt_usr21_key[].
    INSERT is_header-approve_user INTO TABLE lt_usr21_key[].
    SORT lt_usr21_key BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_usr21_key COMPARING table_line.

* ---------------------------------------------------------------------------
* Recupera dados de usuário
* ---------------------------------------------------------------------------
    IF lt_usr21_key[] IS NOT INITIAL.

      SELECT usr21~bname usr21~persnumber adrp~name_text
          FROM usr21
          LEFT OUTER JOIN adrp
          ON adrp~persnumber = usr21~persnumber
          INTO TABLE et_usr21
          FOR ALL ENTRIES IN lt_usr21_key
          WHERE usr21~bname = lt_usr21_key-table_line.

      IF sy-subrc NE 0.
        FREE et_usr21.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera dados de centros
* ---------------------------------------------------------------------------
    DATA(lt_item_plant) = it_item[].
    SORT lt_item_plant[] BY plant.
    DELETE ADJACENT DUPLICATES FROM lt_item_plant[] COMPARING plant.

    IF lt_item_plant[] IS NOT INITIAL.
      SELECT werks name1
          FROM t001w
          INTO TABLE et_t001w
        FOR ALL ENTRIES IN lt_item_plant[]
          WHERE werks = lt_item_plant-plant.

      IF sy-subrc NE 0.
        FREE et_t001w.
      ENDIF.
    ELSE.

      DATA(lt_minimum_plant) = it_minimum[].
      SORT lt_minimum_plant[] BY plant.
      DELETE ADJACENT DUPLICATES FROM lt_minimum_plant[] COMPARING plant.

      IF lt_minimum_plant[] IS NOT INITIAL.
        SELECT werks name1
            FROM t001w
            INTO TABLE et_t001w
          FOR ALL ENTRIES IN lt_minimum_plant[]
            WHERE werks = lt_minimum_plant-plant.

        IF sy-subrc NE 0.
          FREE et_t001w.
        ENDIF.
      ENDIF.

    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY dist_channel price_list material.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING dist_channel price_list material.

* ---------------------------------------------------------------------------
* Recupera lista de preço CanalDistr/Lst.preços/Centro/Material
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT *
          FROM a817
          INTO TABLE et_a817
          FOR ALL ENTRIES IN lt_item
          WHERE kappl EQ gc_preco-aplicacao_sd
            AND kschl EQ gs_parameter-kschl_zpr0
            AND vtweg EQ lt_item-dist_channel
            AND pltyp EQ lt_item-price_list
            AND matnr EQ lt_item-material.
*            AND datab <= is_header-process_date
*            AND datbi >= is_header-process_date.

      IF sy-subrc NE 0.
        SELECT *
      FROM a817
      INTO TABLE et_a817
      FOR ALL ENTRIES IN lt_item
      WHERE kappl EQ gc_preco-aplicacao_sd
        AND kschl EQ gs_parameter-kschl_zpr0
        AND vtweg EQ lt_item-dist_channel
        AND pltyp EQ lt_item-price_list.
        IF sy-subrc NE 0.
          FREE et_a817.
        ENDIF.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY dist_channel material.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING dist_channel material.

* ---------------------------------------------------------------------------
* Recupera lista de preço CanalDistr/Centro/Material
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT *
          FROM a816
          INTO TABLE et_a816
          FOR ALL ENTRIES IN lt_item
          WHERE kappl EQ gc_preco-aplicacao_sd
            AND kschl EQ gs_parameter-kschl_zpr0
            AND vtweg EQ lt_item-dist_channel
            AND matnr EQ lt_item-material.
*            AND datab <= is_header-process_date
*            AND datbi >= is_header-process_date.

      IF sy-subrc NE 0.
        FREE et_a816.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY price_list.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING price_list.

* ---------------------------------------------------------------------------
* Recupera lista de preço CanalDistr/Lst.preços/Centro/Material
* ---------------------------------------------------------------------------
    IF it_invasion[] IS NOT INITIAL.

      SELECT kunnr vtweg pltyp
          FROM knvv
          INTO TABLE et_knvv
          FOR ALL ENTRIES IN it_invasion
          WHERE kunnr = it_invasion-kunnr.

      SELECT *
          FROM a627
          INTO TABLE et_a627
          FOR ALL ENTRIES IN it_invasion
          WHERE kappl EQ gc_preco-aplicacao_sd
            AND kschl EQ gs_parameter-kschl_zalt
            AND kunnr EQ it_invasion-kunnr
            AND datab <= sy-datum
            AND datbi >= sy-datum.

      IF sy-subrc NE 0.
        FREE et_a627.
      ENDIF.

    ELSE.

      SELECT *
  FROM a627
  INTO TABLE et_a627
  WHERE kappl EQ gc_preco-aplicacao_sd
    AND kschl EQ gs_parameter-kschl_zalt
    AND datab <= sy-datum
    AND datbi >= sy-datum.

      IF et_a627[] IS NOT INITIAL.

        SELECT kunnr vtweg pltyp
     FROM knvv
     INTO TABLE et_knvv
     FOR ALL ENTRIES IN et_a627
     WHERE kunnr = et_a627-kunnr.

      ENDIF.

    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY plant material.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING  dist_channel plant material.

* ---------------------------------------------------------------------------
* Recupera lista de preço Canal Distribuição/Centro/Material
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT *
          FROM a626
          INTO TABLE et_a626
          FOR ALL ENTRIES IN lt_item
          WHERE kappl EQ gc_preco-aplicacao_sd
            AND kschl EQ gs_parameter-kschl_zvmc
            AND vtweg EQ lt_item-dist_channel
            AND werks EQ lt_item-plant "is_header-plant
            AND matnr EQ lt_item-material
            AND datab <= sy-datum
            AND datbi >= sy-datum.

      IF sy-subrc NE 0.
        FREE et_a626.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    lt_knumh_key  = VALUE #( FOR ls_a817 IN et_a817 ( ls_a817-knumh ) ).
    lt_knumh_key  = VALUE #( BASE lt_knumh_key FOR ls_a816 IN et_a816 ( ls_a816-knumh ) ).
    lt_knumh_key  = VALUE #( BASE lt_knumh_key FOR ls_a627 IN et_a627 ( ls_a627-knumh ) ).
    lt_knumh_key  = VALUE #( BASE lt_knumh_key FOR ls_a626 IN et_a626 ( ls_a626-knumh ) ).
    SORT lt_knumh_key BY table_line.
    DELETE ADJACENT DUPLICATES FROM lt_knumh_key COMPARING table_line.

* ---------------------------------------------------------------------------
* Recupera Condições (item)
* ---------------------------------------------------------------------------
    IF lt_knumh_key[] IS NOT INITIAL.

      SELECT knumh kopos kbetr konwa kmein mxwrt gkwrt loevm_ko
          FROM konp
          INTO TABLE et_konp
          FOR ALL ENTRIES IN lt_knumh_key
          WHERE knumh EQ lt_knumh_key-table_line
          AND kappl EQ gc_preco-aplicacao_sd
          AND kschl EQ gs_parameter-kschl_zvmc.

      SELECT knumh kopos kbetr konwa kmein mxwrt gkwrt loevm_ko
       FROM konp
       APPENDING CORRESPONDING FIELDS OF TABLE et_konp
       FOR ALL ENTRIES IN lt_knumh_key
       WHERE knumh EQ lt_knumh_key-table_line
       AND kappl EQ gc_preco-aplicacao_sd
       AND kschl EQ gs_parameter-kschl_zpr0.


      SELECT knumh kopos kbetr konwa kmein mxwrt gkwrt loevm_ko
      FROM konp
      APPENDING CORRESPONDING FIELDS OF TABLE et_konp
      FOR ALL ENTRIES IN lt_knumh_key
      WHERE knumh EQ lt_knumh_key-table_line
      AND kappl EQ gc_preco-aplicacao_sd
      AND kschl EQ gs_parameter-kschl_zalt.

    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY dist_channel.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING dist_channel.

* ---------------------------------------------------------------------------
* Recupera Canal de distribuição
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT vtweg
          FROM tvtw
          INTO TABLE et_tvtw
          FOR ALL ENTRIES IN lt_item
          WHERE vtweg EQ lt_item-dist_channel.

      IF sy-subrc NE 0.
        FREE et_tvtw.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY price_list.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING price_list.

* ---------------------------------------------------------------------------
* Recupera Tipo de Lista de Preço
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT pltyp
          FROM t189
          INTO TABLE et_t189
          FOR ALL ENTRIES IN lt_item
          WHERE pltyp EQ lt_item-price_list.

      IF sy-subrc NE 0.
        FREE et_t189.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY  plant material.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING  plant material.

* ---------------------------------------------------------------------------
* Recupera Material
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT mara~matnr mara~meins marm~meinh
          FROM mara
          LEFT OUTER JOIN marm
          ON marm~matnr = mara~matnr
          INTO TABLE et_mara
          FOR ALL ENTRIES IN lt_item
          WHERE mara~matnr EQ lt_item-material.

      IF sy-subrc NE 0.
        FREE et_mara.
      ENDIF.
    ENDIF.

    " Monta tabela de chaves
    FREE lt_item.
    lt_item = VALUE #( BASE lt_item FOR ls_item IN it_item ( CORRESPONDING #( ls_item ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_minimum IN it_minimum ( CORRESPONDING #( ls_minimum ) ) ).
    lt_item = VALUE #( BASE lt_item FOR ls_invasion IN it_invasion ( CORRESPONDING #( ls_invasion ) ) ).
    SORT lt_item BY  plant material.
    DELETE ADJACENT DUPLICATES FROM lt_item COMPARING  plant material.

* ---------------------------------------------------------------------------
* Recupera Avaliação do material
* ---------------------------------------------------------------------------
    IF lt_item[] IS NOT INITIAL.

      SELECT matnr bwkey bwtar lfgja lfmon stprs
          FROM mbew
          INTO TABLE et_mbew
          FOR ALL ENTRIES IN lt_item
          WHERE matnr EQ lt_item-material
            AND bwkey EQ lt_item-plant. "is_header-plant.
*            AND lfgja EQ is_header-process_date+0(4)
*            AND lfmon EQ is_header-process_date+0(2).

      IF sy-subrc NE 0.
        FREE et_mbew.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_header_fields.

    " -----------------------------------------------------------------------
    " Valida usuário aprovador
    " -----------------------------------------------------------------------
    IF is_header-approve_user IS INITIAL.
      " Usuário aprovador em branco.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_header-guid
                                                    line       = 0
                                                    row        = 0
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '033'
                                                    field      = 'APPROVE_USER' ) ).
    ELSE.

      TRY.
          DATA(ls_usr21) = it_usr21[ bname = is_header-approve_user ].
        CATCH cx_root.
          " Usuário aprovador '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = is_header-guid
                                                        line       = 0
                                                        row        = 0
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '034'
                                                        message_v1 = is_header-approve_user
                                                        field      = 'APPROVE_USER' ) ).
      ENDTRY.

    ENDIF.

    " -----------------------------------------------------------------------
    " Valida código da filial
    " -----------------------------------------------------------------------
    TRY.

        "Arquivo de invasão não possui Centro
        IF is_header-condition_type <> me->gs_parameter-kschl_zalt.
          DATA(ls_t001w) = it_t001w[ werks = is_header-plant ].
        ENDIF.

      CATCH cx_root.
        " Centro '&1' não existe.
        ct_validation = VALUE #( BASE ct_validation ( guid       = is_header-guid
                                                      line       = 0
                                                      row        = 0
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '008'
                                                      message_v1 = is_header-plant
                                                      field      = 'PLANT' ) ).
    ENDTRY.

    " -----------------------------------------------------------------------
    " Valida data de processamento
    " -----------------------------------------------------------------------
    IF is_header-process_date IS INITIAL.
      " Informar data de processamento.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_header-guid
                                                    line       = 0
                                                    row        = 0
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '036' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD validate_item_fields.

    DATA: lt_item_key TYPE ty_t_item.
    DATA: lv_scale_0 TYPE  kstbm.
    DATA: lv_scale_1 TYPE  kstbm VALUE 1.
    DATA lv_meinh TYPE marm-meinh.
    DATA(lt_item) = it_item.
    SORT lt_item BY guid line dist_channel price_list plant material scale.

* ---------------------------------------------------------------------------
*   Aplica validações
* ---------------------------------------------------------------------------
    LOOP AT lt_item INTO DATA(ls_item).            "#EC CI_LOOP_INTO_WA

      DATA(lv_index) = sy-tabix.
      " ---------------------------------------------------------------------
      " Valida campos vazios
      " ---------------------------------------------------------------------
      validation_initial_item_field( EXPORTING iv_msgty      = iv_msgty
                                               is_item       = ls_item
                                      CHANGING ct_validation = ct_validation ).


      " ---------------------------------------------------------------------
      " Valida se existe linha repetida
      " ---------------------------------------------------------------------
      lt_item_key[] = VALUE #( FOR ls_it IN lt_item FROM lv_index WHERE (     guid         EQ ls_item-guid
                                                                          AND line         <> ls_item-line
                                                                          AND dist_channel EQ ls_item-dist_channel
                                                                          AND price_list   EQ ls_item-price_list
                                                                          AND plant        EQ ls_item-plant
                                                                          AND material     EQ ls_item-material
                                                                          AND scale        EQ ls_item-scale )
                                                                          ( CORRESPONDING #( ls_it ) ) ).
      IF lines( lt_item_key ) = 0.
        DATA(lv_old_index) = lv_index - 1.
        lt_item_key[] = VALUE #( FOR ls_it IN lt_item FROM lv_old_index WHERE ( guid         EQ ls_item-guid
                                                                            AND line         <> ls_item-line
                                                                            AND dist_channel EQ ls_item-dist_channel
                                                                            AND price_list   EQ ls_item-price_list
                                                                            AND plant        EQ ls_item-plant
                                                                            AND material     EQ ls_item-material
                                                                            AND scale        EQ ls_item-scale )
                                                                            ( CORRESPONDING #( ls_it ) ) ).
      ENDIF.

      IF lines( lt_item_key ) > 0.
        " Existe outra linha com os mesmos dados
        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                      line       = ls_item-line
                                                      row        = ls_item-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '005'
                                                      message_v1 = ls_item-line
                                                      field      = 'LINE' ) ).
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Centro
      " ---------------------------------------------------------------------
      TRY.

          "Arquivo de invasão não possui Centro
          IF is_header-condition_type <> me->gs_parameter-kschl_zalt.
            DATA(ls_t001w) = it_t001w[ werks = ls_item-plant ].
          ENDIF.

        CATCH cx_root.
          " Centro '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '008'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-plant
                                                        field      = 'PLANT' ) ).
      ENDTRY.

      " ---------------------------------------------------------------------
      " Valida código do produto
      " ---------------------------------------------------------------------
      TRY.
          DATA(ls_mara) = it_mara[ matnr = ls_item-material ].
        CATCH cx_root.
          " Código do produto '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '010'
                                                        message_v1 = ls_item-line
                                                        message_v2 = |{ ls_item-material ALPHA = OUT }|
                                                        field      = 'MATERIAL' ) ).
      ENDTRY.


      " ---------------------------------------------------------------------
      " Valida canal de distribuição
      " ---------------------------------------------------------------------
      TRY.
          DATA(ls_tvtw) = it_tvtw[ vtweg = ls_item-dist_channel ].
        CATCH cx_root.
          " Canal de distribuição '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '007'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-dist_channel
                                                        field      = 'DIST_CHANNEL' ) ).
      ENDTRY.

      " ---------------------------------------------------------------------
      " Valida Exclusão
      " ---------------------------------------------------------------------
      IF ls_item-zzdelete NE 'x' AND ls_item-zzdelete NE 'X' AND ls_item-zzdelete NE ' '.
        " Linha &1:Valor não permitido para coluna "Exclusão".

        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                      line       = ls_item-line
                                                      row        = ls_item-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '044'
                                                      message_v1 = ls_item-line
                                                      field      = 'ZZDELETE' ) ).
      ENDIF.

      IF ( ls_item-zzdelete EQ 'x' OR ls_item-zzdelete EQ 'X' )
     AND ( ls_item-date_from NE ls_item-date_to ).

        " Linha &1:'Data desde' e 'Data até' devem ser iguais para exclusão.

        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                      line       = ls_item-line
                                                      row        = ls_item-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '045'
                                                      message_v1 = ls_item-line
                                                      field      = 'ZZDELETE' ) ).
      ENDIF.

      IF ls_item-zzdelete EQ 'x' OR ls_item-zzdelete EQ 'X'.
        TRY.
            IF ls_item-price_list IS NOT INITIAL.
              DATA(ls_a817_del) = it_a817[ kappl = gc_preco-aplicacao_sd
                                           kschl = gs_parameter-kschl_zpr0
                                           vtweg = ls_item-dist_channel
                                           pltyp = ls_item-price_list
                                           matnr = ls_item-material ].
            ELSE.
              DATA(ls_a816_del) = it_a816[ kappl = gc_preco-aplicacao_sd
                                           kschl = gs_parameter-kschl_zpr0
                                           vtweg = ls_item-dist_channel
                                           matnr = ls_item-material ].
            ENDIF.

          CATCH cx_root.
            " Linha &1:Registro não exite na tabela &2.
            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                          line       = ls_item-line
                                                          row        = ls_item-line
                                                          status     = gc_status-erro
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '046'
                                                          message_v1 = ls_item-line
                                                          field      = 'LINE' ) ).
        ENDTRY.

      ENDIF.

      IF ls_item-zzdelete EQ ' '.

        " ---------------------------------------------------------------------
        " Valida se é exportação
        " ---------------------------------------------------------------------
        IF ls_item-dist_channel = '13' AND gv_aprovar NE abap_true.

          " Verificar moeda para canal de exportação.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-alerta
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '058'
                                                        message_v1 = ls_item-currency
                                                        field      = 'CURRENCY' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Verifica se a moeda é válida
        " ---------------------------------------------------------------------
        SELECT SINGLE waers
          FROM tcurc
          INTO @DATA(lv_moeda)
          WHERE waers EQ @ls_item-currency.

        IF lv_moeda IS INITIAL.
          "Linha &1: Moeda '&2' é inválida.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '066'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-currency
                                                        field      = 'CURRENCY' ) ).
        ENDIF.
        CLEAR lv_moeda.

        " ---------------------------------------------------------------------
        " Valida se preço existe em mais de uma filial
        " ---------------------------------------------------------------------

        IF gv_aprovar NE abap_true.
          DATA(lt_a817_key) = VALUE ty_t_a817( FOR ls_a817 IN it_a817 WHERE (     vtweg EQ ls_item-dist_channel
                                                                              AND pltyp EQ ls_item-price_list
                                                                              AND werks <> ls_item-plant  )
                                                                              ( CORRESPONDING #( ls_a817 ) ) ).
          IF lines( lt_a817_key ) > 0.
            " Linha &1:Lista de preço existe em mais de um centro.
            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                          line       = ls_item-line
                                                          row        = ls_item-line
                                                          status     = gc_status-alerta
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '006'
                                                          message_v1 = ls_item-line
                                                          field      = 'LINE' ) ).
          ENDIF.
        ENDIF.




        " ---------------------------------------------------------------------
        " Valida tipo de lista de preço
        " ---------------------------------------------------------------------
        TRY.
            IF ls_item-price_list IS NOT INITIAL.
              DATA(ls_t189) = it_t189[ pltyp = ls_item-price_list ].
            ENDIF.

          CATCH cx_root.
            " Tipo de lista de preço '&1' não existe.
            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                          line       = ls_item-line
                                                          row        = ls_item-line
                                                          status     = gc_status-erro
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '009'
                                                          message_v1 = ls_item-line
                                                          message_v2 = ls_item-price_list
                                                          field      = 'PRICE_LIST' ) ).
        ENDTRY.


        " ---------------------------------------------------------------------
        " Valida unidade de medida
        " ---------------------------------------------------------------------
        TRY.
            lv_meinh = conversion_unit( ls_item-base_unit ).

            DATA(ls_mara_unit) = it_mara[ matnr = ls_item-material
                                          meinh = ls_item-base_unit ].


          CATCH cx_root.
            " Unidade de medida '&1' não existe para produto '&2'.
            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                          line       = ls_item-line
                                                          row        = ls_item-line
                                                          status     = gc_status-erro
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '011'
                                                          message_v1 = ls_item-line
                                                          message_v2 = lv_meinh
                                                          message_v3 = |{ ls_item-material ALPHA = OUT }|
                                                          field      = 'BASE_UNIT' ) ).
        ENDTRY.

        " ---------------------------------------------------------------------
        " Valida Faixa Volume
        " ---------------------------------------------------------------------
        DATA lv_dec TYPE char3.

        lv_dec = get_fran( ls_item ).

        IF lv_dec NE '000'.
          " Escala possui valor fracionado '&1'.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '012'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-scale
                                                        field      = 'SCALE' ) ).
        ENDIF.


        " ---------------------------------------------------------------------
        " Valida Preço sugerido
        " ---------------------------------------------------------------------
        IF ls_item-sug_value < ls_item-min_value.
          " Preço sugerido é inferior ao Preço mínimo.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '013'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-scale
                                                        field      = 'SUG_VALUE' ) ).
        ENDIF.
        IF ls_item-sug_value > ls_item-max_value.
          " Preço sugerido é superior ao Preço máximo.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '041'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-scale
                                                        field      = 'SUG_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida Preço máximo
        " ---------------------------------------------------------------------
        IF ls_item-max_value < ls_item-min_value.
          " Preço máximo é inferior ao Preço mínimo.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '014'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-scale
                                                        field      = 'MAX_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida composição - Valor mínimo
        " ---------------------------------------------------------------------
        lt_item_key[] = VALUE #( FOR ls_it IN lt_item FROM lv_index WHERE (     guid         EQ ls_item-guid
                                                                            AND dist_channel EQ ls_item-dist_channel
                                                                            AND price_list   EQ ls_item-price_list
                                                                            AND material     EQ ls_item-material )
*                                                                            AND scale        EQ ls_item-scale )
                                                                            ( CORRESPONDING #( ls_it ) ) ).

        IF NOT line_exists( lt_item_key[ min_value = ls_item-min_value ] ). "#EC CI_STDSEQ
          " Valor Mínimo difere para linhas com mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '015'
                                                        message_v1 = ls_item-line
                                                        field      = 'MIN_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida composição - Valor máximo
        " ---------------------------------------------------------------------
        IF NOT line_exists( lt_item_key[ max_value = ls_item-max_value ] ). "#EC CI_STDSEQ
          " Valor Máximo difere para linhas com mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '016'
                                                        message_v1 = ls_item-line
                                                        field      = 'MAX_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida composição - Escala e Valor Sugerido
        " ---------------------------------------------------------------------
        DATA(lv_scale_ok)     = abap_true.
        DATA(lv_sug_value_ok) = abap_true.
        DATA(lv_min_value)    = abap_true.
        DATA(lv_max_value)    = abap_true.

        lt_item_key[] = VALUE #( FOR ls_it IN lt_item FROM lv_index WHERE (    guid         EQ ls_item-guid
                                                                           AND dist_channel EQ ls_item-dist_channel
                                                                           AND price_list   EQ ls_item-price_list
                                                                           AND plant        EQ ls_item-plant
                                                                           AND material     EQ ls_item-material )
                                                                            ( CORRESPONDING #( ls_it ) ) ).

        IF lines( lt_item_key ) = 1.
          lv_old_index = lv_index - 1.
          lt_item_key[] = VALUE #( FOR ls_it IN lt_item FROM lv_old_index WHERE ( guid         EQ ls_item-guid
                                                                              AND dist_channel EQ ls_item-dist_channel
                                                                              AND price_list   EQ ls_item-price_list
                                                                              AND plant        EQ ls_item-plant
                                                                              AND material     EQ ls_item-material )
                                                                              ( CORRESPONDING #( ls_it ) ) ).
        ENDIF.

        IF lines( lt_item_key ) > 1.
          LOOP AT lt_item_key INTO DATA(ls_item_key) FROM 1. "#EC CI_LOOP_INTO_WA #EC CI_STDSEQ #EC CI_NESTED

            IF sy-tabix = 1.
              DATA(ls_item_key_prev) = ls_item_key.
              CONTINUE.
            ENDIF.
*          AT FIRST.
*            DATA(ls_item_key_prev) = ls_item_key.
*            CONTINUE.
*          ENDAT.

            IF ls_item_key-scale < ls_item_key_prev-scale AND lv_scale_ok EQ abap_true.
              lv_scale_ok = abap_false.
            ENDIF.

            IF ls_item_key-sug_value > ls_item_key_prev-sug_value AND lv_sug_value_ok EQ abap_true.
              lv_sug_value_ok = abap_false.
            ENDIF.

            IF ls_item_key-min_value <> ls_item_key_prev-min_value.
              lv_min_value = abap_false.
            ENDIF.

            IF ls_item_key-max_value <> ls_item_key_prev-max_value.
              lv_max_value = abap_false.
            ENDIF.

            ls_item_key_prev = ls_item_key.
          ENDLOOP.
        ENDIF.

        IF lv_min_value NE abap_true.
          " Preço mínimo deve ser igual para linhas com a mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '056'
                                                        message_v1 = ls_item-line
                                                        field      = 'MIN_VALUE' ) ).

        ENDIF.

        IF lv_max_value NE abap_true.
          " Preço máximo deve ser igual para linhas com a mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '057'
                                                        message_v1 = ls_item-line
                                                        field      = 'MAX_VALUE' ) ).

        ENDIF.

        IF lv_scale_ok NE abap_true.
          " Escala não é crescente para linhas com mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '017'
                                                        message_v1 = ls_item-line
                                                        field      = 'SCALE' ) ).
        ELSE.
          IF gv_aprovar NE abap_true.
            TRY.
                DATA(lv_first_scale) = it_item[ guid         = ls_item-guid
                                                dist_channel = ls_item-dist_channel
                                                price_list   = ls_item-price_list
                                                plant        = ls_item-plant
                                                material     = ls_item-material ]-scale.
              CATCH cx_root.
                lv_first_scale = ls_item-scale.
            ENDTRY.

            IF lv_first_scale NE lv_scale_0 AND lv_first_scale NE lv_scale_1.
              " Linha &1:Meterial &2, tabela &3 verificar faixa de escala inicial.
              ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                            line       = ls_item-line
                                                            row        = ls_item-line
                                                            status     = gc_status-alerta
                                                            type       = iv_msgty
                                                            id         = 'ZSD_GESTAO_PRECOS'
                                                            number     = '050'
                                                            message_v1 = ls_item-line
                                                            message_v2 = |{ ls_item-material ALPHA = OUT }|
                                                            message_v3 = ls_item-price_list
                                                            field      = 'SCALE' ) ).

            ENDIF.
          ENDIF.
        ENDIF.


        IF ls_item-scale < 0.
          "Linha &1: Escala não pode ser inferior à zero.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '065'
                                                        message_v1 = ls_item-line
                                                        field      = 'SCALE' ) ).
        ENDIF.

*        IF ls_item-sug_value > ls_item-min_value AND ls_item-sug_value < ls_item-max_value.
*          lv_sug_value_ok = abap_true.
*        ELSE.
*          lv_sug_value_ok = abap_false.
*        ENDIF.
*
        IF lv_sug_value_ok NE abap_true.
          " Valor Sugerido não é decrescente para linhas com mesma composição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '018'
                                                        message_v1 =  ls_item-line
                                                        field      = 'SUG_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida Invasão
        " ---------------------------------------------------------------------
        IF gv_aprovar NE abap_true.
          TRY.
              DATA(ls_knvv) = it_knvv[ vtweg = ls_item-dist_channel
                                       pltyp = ls_item-price_list ].
              TRY.
                  DATA(ls_a627) = it_a627[ kunnr = ls_knvv-kunnr ].

                  "Linha &1:Cliente &2, tabela &3 com risco de invasão.
                  ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                                line       = ls_item-line
                                                                row        = ls_item-line
                                                                status     = gc_status-alerta
                                                                type       = iv_msgty
                                                                id         = 'ZSD_GESTAO_PRECOS'
                                                                number     = '049'
                                                                message_v1 = ls_item-line
                                                                message_v2 = ls_a627-kunnr
                                                                message_v3 = ls_item-price_list
                                                                field      = 'PRICE_LIST' ) ).
                CATCH cx_root.
              ENDTRY.
            CATCH cx_root.
          ENDTRY.
        ENDIF.
        " ---------------------------------------------------------------------
        " Valida Data Desde e Data Até
        " ---------------------------------------------------------------------
        IF ls_item-date_from > ls_item-date_to.
          " Data início é superior à Data fim.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '020'
                                                        message_v1 = ls_item-line
                                                        field      = 'DATE_TO' ) ).
        ENDIF.
        " ---------------------------------------------------------------------
        " Valida se a Data Desde e Data Até são válidas
        " ---------------------------------------------------------------------
        validation_data( EXPORTING
                          iv_msgty     = iv_msgty
                          iv_from_data = ls_item-date_from
                          iv_to_data   = ls_item-date_to
                          iv_guid      = ls_item-guid
                          iv_line      = ls_item-line
                         CHANGING
                          ct_validation = ct_validation ).
*      IF  is_header-process_date IS NOT INITIAL
*      AND NOT ( ls_item-date_from <= is_header-process_date AND is_header-process_date <= ls_item-date_to ).
*        " Data de processamento deve estar entre a 'Data Desde' e 'Data Até'.
*        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
*                                                      line       = ls_item-line
*                                                      row        = ls_item-line
*                                                      status     = gc_status-erro
*                                                      type       = iv_msgty
*                                                      id         = 'ZSD_GESTAO_PRECOS'
*                                                      number     = '037'
*                                                      message_v1 = ls_item-line
*                                                      field      = 'DATE_FROM' ) ).
*      ENDIF.

        " ---------------------------------------------------------------------
        " Valida mínimo (campo calculado)
        " ---------------------------------------------------------------------
        TRY.
            DATA(ls_a626) = it_a626[ vtweg = ls_item-dist_channel
                                     werks = ls_item-plant "is_header-plant
                                     matnr = ls_item-material ].

          CATCH cx_root.
            " Condição de Centro &2/Produto &1 não cadastrada para cálculo do Mínimo.

            IF NOT line_exists( ct_validation[ id = 'ZSD_GESTAO_PRECOS' number = '025' message_v1 = ls_item-line message_v2 = |{ ls_item-material ALPHA = OUT }|  message_v3 = ls_item-plant ] ).

              ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                            line       = ls_item-line
                                                            row        = ls_item-line
                                                            status     = gc_status-erro
                                                            type       = iv_msgty
                                                            id         = 'ZSD_GESTAO_PRECOS'
                                                            number     = '025'
                                                            message_v1 = ls_item-line
                                                            message_v2 = |{ ls_item-material ALPHA = OUT }|
                                                            message_v3 = ls_item-plant "is_header-plant
                                                            field      = 'MINIMUM' ) ).
            ENDIF.
        ENDTRY.


        " ---------------------------------------------------------------------
        " Valida se UMB é uma unidade de venda
        " ---------------------------------------------------------------------


        SELECT SINGLE matnr, meinh, umrez, ean11
            FROM marm
            INTO @DATA(ls_marm)
            WHERE matnr EQ @ls_item-material
              AND meinh EQ @ls_item-base_unit
              AND ean11 NE @space.

        IF ls_marm IS INITIAL.
          " Linha &1:Unidade de venda &2 não permitida para SKU

          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '042'
                                                        message_v1 = ls_item-line
                                                        message_v2 = lv_meinh
                                                        message_v3 = |{ ls_item-material ALPHA = OUT }|
                                                        field      = 'BASE_UNIT' ) ).
        ELSE.
          APPEND ls_marm TO gt_marm.

        ENDIF.


        " ---------------------------------------------------------------------
        " Valida se Valor mínimo é menor que Mínimo(ZVMC)
        " ---------------------------------------------------------------------
        READ TABLE it_a626 INTO ls_a626 WITH TABLE KEY  vtweg = ls_item-dist_channel
                                                        werks = ls_item-plant
                                                        matnr = ls_item-material.
        IF sy-subrc NE 0.
          CLEAR ls_a626.
        ENDIF.

        " Recupera condição A626
        READ TABLE it_konp INTO DATA(ls_konp_a626) WITH TABLE KEY knumh = ls_a626-knumh.

        IF sy-subrc NE 0.
          DATA(lv_minimum) = ls_konp_a626-kbetr.
        ELSE.
          lv_minimum  = ls_konp_a626-kbetr * ls_marm-umrez.
        ENDIF.


        IF ls_item-min_value < lv_minimum.
          "Linha &1:Valor mínimo menor que o permitido.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '048'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-min_value
                                                        message_v3 = lv_minimum
                                                        field      = 'MIN_VALUE' ) ).
        ENDIF.
        CLEAR: lv_minimum, ls_marm.

        " ---------------------------------------------------------------------
        " Verifica se os valores não são negativos
        " ---------------------------------------------------------------------

        IF ls_item-min_value < 0.
          "Linha &1:Preço mínimo não pode ser inferior à zero.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '067'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-min_value
                                                        field      = 'MIN_VALUE' ) ).
        ENDIF.

        IF ls_item-max_value < 0.
          "Linha &1:Preço máximo não pode ser inferior à zero.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '068'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-max_value
                                                        field      = 'MAX_VALUE' ) ).
        ENDIF.

        IF ls_item-sug_value < 0.
          "Linha &1:Sugerido não pode ser inferior à zero.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '069'
                                                        message_v1 = ls_item-line
                                                        message_v2 = ls_item-sug_value
                                                        field      = 'SUG_VALUE' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Verifica se já existe a vigência na condição
        " ---------------------------------------------------------------------

        TRY.
            DATA(ls_a817_data) = it_a817[ kappl = gc_preco-aplicacao_sd
                                         kschl = gs_parameter-kschl_zpr0
                                         pltyp = ls_item-price_list
                                         vtweg = ls_item-dist_channel
                                         werks = ls_item-plant
                                         matnr = ls_item-material
                                         datab = ls_item-date_from
                                         datbi = ls_item-date_to ].

            TRY.
                DATA(lv_loevm_ko_817) = it_konp[ knumh = ls_a817_data-knumh ]-loevm_ko.
              CATCH cx_root.
            ENDTRY.
            IF lv_loevm_ko_817 IS INITIAL.
              DATA(lv_dado_existe) = abap_true.
            ENDIF.

          CATCH cx_root.
            IF ls_item-price_list IS INITIAL.
              TRY.
                  DATA(ls_a816_data) = it_a816[ kappl = gc_preco-aplicacao_sd
                                               kschl = gs_parameter-kschl_zpr0
                                               vtweg = ls_item-dist_channel
                                               werks = ls_item-plant
                                               matnr = ls_item-material
                                               datab = ls_item-date_from
                                               datbi = ls_item-date_to ].

                  TRY.
                      DATA(lv_loevm_ko_816) = it_konp[ knumh = ls_a816_data-knumh ]-loevm_ko.
                    CATCH cx_root.
                  ENDTRY.
                  IF lv_loevm_ko_816 IS INITIAL.
                    lv_dado_existe = abap_true.
                  ENDIF.

                CATCH cx_root.

              ENDTRY.
            ENDIF.
        ENDTRY.

        IF lv_dado_existe = abap_true.
          " Linha &1:Vigência já exite na condição.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                        line       = ls_item-line
                                                        row        = ls_item-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '064'
                                                        message_v1 = ls_item-line
                                                        field      = 'LINE' ) ).
          CLEAR lv_dado_existe.
        ENDIF.

      ENDIF.



      " ---------------------------------------------------------------------
      " Valida se não houve erro para linha
      " ---------------------------------------------------------------------
      IF gv_aprovar NE abap_true.
        TRY.
            DATA(ls_validation) = ct_validation[ guid = ls_item-guid
                                                 line = ls_item-line ].
          CATCH cx_root.

            " Linha &1:Registro validado.

            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_item-guid
                                                          line       = ls_item-line
                                                          row        = ls_item-line
                                                          status     = gc_status-validado
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '047'
                                                          message_v1 = ls_item-line
                                                          field      = 'LINE' ) ).


        ENDTRY.
      ENDIF.
      CLEAR lv_meinh.
    ENDLOOP.


  ENDMETHOD.


  METHOD validation_data.

    DATA: lv_flag      TYPE char5,
          lv_from_date TYPE char10,
          lv_to_date   TYPE char10.

    lv_from_date = |{ iv_from_data+6(2) }.{ iv_from_data+4(2) }.{ iv_from_data(4) }|.
    lv_to_date   = |{ iv_to_data+6(2) }.{ iv_to_data+4(2) }.{ iv_to_data(4) }|.

    CALL FUNCTION 'CRM_MA_VALID_DATE_CHECK'
      EXPORTING
        iv_from_date                   = lv_from_date
        iv_to_date                     = lv_to_date
      IMPORTING
        ev_flag                        = lv_flag
      EXCEPTIONS
        from_date_is_not_valid         = 1
        to_date_is_not_valid           = 2
        from_date_greater_than_to_date = 3
        OTHERS                         = 4.

    IF sy-subrc = 1.
      ct_validation = VALUE #( BASE ct_validation ( guid       = iv_guid
                                                    line       = iv_line
                                                    row        = iv_line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '051'
                                                    field      = 'DATE_FROM' ) ).
    ELSEIF sy-subrc = 2.

      ct_validation = VALUE #( BASE ct_validation ( guid       = iv_guid
                                                    line       = iv_line
                                                    row        = iv_line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '051'
                                                    field      = 'DATE_TO' ) ).
    ELSEIF sy-subrc = 3.

      ct_validation = VALUE #( BASE ct_validation ( guid       = iv_guid
                                                    line       = iv_line
                                                    row        = iv_line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '052'
                                                    message_v1 = iv_line
                                                    field      = 'DATE_TO' ) ).
    ENDIF.


  ENDMETHOD.


  METHOD get_fran.

    DATA: lv_scale TYPE char18,
          lv_int   TYPE char15,
          lv_dec   TYPE char3.

    lv_scale = is_item-scale.
    CONDENSE lv_scale.
    SPLIT lv_scale AT '.' INTO lv_int rv_dec.

  ENDMETHOD.


  METHOD conversion_unit.

    DATA lv_meinh TYPE marm-meinh.
    CLEAR rv_meinh.
    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = iv_base_unit
        language       = sy-langu
      IMPORTING
        output         = rv_meinh
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc NE 0 OR rv_meinh IS INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
        EXPORTING
          input          = iv_base_unit
          language       = sy-langu
        IMPORTING
          output         = rv_meinh
        EXCEPTIONS
          unit_not_found = 1
          OTHERS         = 2.
      IF sy-subrc NE 0.
        rv_meinh = iv_base_unit.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD validation_initial_item_field.
*    IF is_item-zzdelete EQ ' '.
    IF is_item-dist_channel  IS INITIAL.
      " Linha &1:Campo Canal de distribuição está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-001 "'Canal de distribuição'
                                                    field      = 'DIST_CHANNEL' ) ).

    ENDIF.
    IF is_item-plant IS INITIAL.
      " Linha &1:Campo Centro está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-002 "Centro
                                                    field      = 'PLANT' ) ).

    ENDIF.
    IF is_item-material IS INITIAL.
      " Linha &1:Campo Nº do material está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-003 "Nº do material
                                                    field      = 'MATERIAL' ) ).

    ENDIF.
    IF is_item-base_unit IS INITIAL.
      " Linha &1:Campo Unidade de medida básica está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-004 "Unidade de medida básica
                                                    field      = 'BASE_UNIT' ) ).

    ENDIF.
    IF is_item-scale EQ space AND is_item-scale NE '0.000'.
      " Linha &1:Campo Quantidade da escala de condição está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-005 "Quantidade da escala de condição
                                                    field      = 'SCALE' ) ).

    ENDIF.
    IF is_item-min_value IS INITIAL.
      " Linha &1:Campo Preço mínimo está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-006 "Preço mínimo
                                                    field      = 'MIN_VALUE' ) ).

    ENDIF.
    IF is_item-sug_value IS INITIAL.
      " Linha &1:Campo Preço sugerido está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-007 "Preço sugerido
                                                    field      = 'SUG_VALUE' ) ).

    ENDIF.
    IF is_item-max_value IS INITIAL.
      " Linha &1:Campo Preço máximo está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-008 "Preço máximo
                                                    field      = 'MAX_VALUE' ) ).

    ENDIF.
    IF is_item-date_from IS INITIAL.
      " Linha &1:Campo Data desde está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-009 "Data desde
                                                    field      = 'DATE_FROM' ) ).

    ENDIF.
    IF is_item-date_to IS INITIAL.
      " Linha &1:Campo Data até está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_item-guid
                                                    line       = is_item-line
                                                    row        = is_item-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_item-line
                                                    message_v2 = TEXT-010 "Data até
                                                    field      = 'DATE_TO' ) ).

    ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD validate_minimum_fields.

    DATA: lt_minimum_key TYPE ty_t_minimum.

    DATA(lt_minimum) = it_minimum.
    SORT lt_minimum BY guid line.

* ---------------------------------------------------------------------------
*   Aplica validações
* ---------------------------------------------------------------------------
    LOOP AT lt_minimum INTO DATA(ls_minimum).      "#EC CI_LOOP_INTO_WA

      DATA(lv_index) = sy-tabix.
      " ---------------------------------------------------------------------
      " Valida campos vazios
      " ---------------------------------------------------------------------
      validation_initial_min_field( EXPORTING iv_msgty      = iv_msgty
                                              is_minimum    = ls_minimum
                                     CHANGING ct_validation = ct_validation ).
      " ---------------------------------------------------------------------
      " Valida se existe linha repetida
      " ---------------------------------------------------------------------
      lt_minimum_key[] = VALUE #( FOR ls_min IN lt_minimum FROM lv_index WHERE (     guid         EQ ls_minimum-guid
                                                                                 AND line         <> ls_minimum-line
                                                                                 AND dist_channel EQ ls_minimum-dist_channel
                                                                                 AND plant        EQ ls_minimum-plant
                                                                                 AND material     EQ ls_minimum-material )
                                                                                 ( CORRESPONDING #( ls_min ) ) ).
      IF lines( lt_minimum_key ) = 0.
        DATA(lv_old_index) = lv_index - 1.
        lt_minimum_key[] = VALUE #( FOR ls_min IN lt_minimum FROM lv_old_index WHERE ( guid         EQ ls_minimum-guid
                                                                                   AND line         <> ls_minimum-line
                                                                                   AND dist_channel EQ ls_minimum-dist_channel
                                                                                   AND plant        EQ ls_minimum-plant
                                                                                   AND material     EQ ls_minimum-material )
                                                                                   ( CORRESPONDING #( ls_min ) ) ).
      ENDIF.

      IF lines( lt_minimum_key ) > 0.
        " Existe outra linha com os mesmos dados
        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                      line       = ls_minimum-line
                                                      row        = ls_minimum-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '005'
                                                      message_v1 = ls_minimum-line
                                                      field      = 'LINE' ) ).
      ENDIF.

      IF ls_minimum-min_value < 0.
        " Linha &1:Valor não pode ser inferior à zero.
        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                      line       = ls_minimum-line
                                                      row        = ls_minimum-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '070'
                                                      message_v1 = ls_minimum-line
                                                      message_v2 = ls_minimum-min_value
                                                      field      = 'MIN_VALUE' ) ).
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Centro
      " ---------------------------------------------------------------------
      TRY.

          "Arquivo de invasão não possui Centro
          IF is_header-condition_type <> me->gs_parameter-kschl_zalt.
            DATA(ls_t001w) = it_t001w[ werks = ls_minimum-plant ].
          ENDIF.

        CATCH cx_root.
          " Centro '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                        line       = ls_minimum-line
                                                        row        = ls_minimum-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '008'
                                                        message_v1 = ls_minimum-line
                                                        message_v2 = ls_minimum-plant
                                                        field      = 'PLANT' ) ).
      ENDTRY.

      " ---------------------------------------------------------------------
      " Valida código do produto
      " ---------------------------------------------------------------------
      TRY.
          DATA(ls_mara) = it_mara[ matnr = ls_minimum-material ].
        CATCH cx_root.
          " Código do produto '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                        line       = ls_minimum-line
                                                        row        = ls_minimum-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '010'
                                                        message_v1 = ls_minimum-line
                                                        message_v2 = ls_minimum-material
                                                        field      = 'MATERIAL' ) ).
      ENDTRY.

      " ---------------------------------------------------------------------
      " Valida se a Data Desde e Data Até são válidas
      " ---------------------------------------------------------------------
      validation_data( EXPORTING
                        iv_msgty     = iv_msgty
                        iv_from_data = ls_minimum-date_from
                        iv_to_data   = ls_minimum-date_to
                        iv_guid      = ls_minimum-guid
                        iv_line      = ls_minimum-line
                       CHANGING
                        ct_validation = ct_validation ).
      " ---------------------------------------------------------------------
      " Valida canal de distribuição
      " ---------------------------------------------------------------------
      TRY.
          DATA(ls_tvtw) = it_tvtw[ vtweg = ls_minimum-dist_channel ].
        CATCH cx_root.
          " Canal de distribuição '&1' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                        line       = ls_minimum-line
                                                        row        = ls_minimum-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '007'
                                                        message_v1 = ls_minimum-line
                                                        message_v2 = ls_minimum-dist_channel
                                                        field      = 'DIST_CHANNEL' ) ).
      ENDTRY.
      " ---------------------------------------------------------------------
      " Valida Data Desde e Data Até
      " ---------------------------------------------------------------------
*      IF ls_minimum-date_from > ls_minimum-date_to.
*        " Data início é superior à Data fim.
*        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
*                                                      line       = ls_minimum-line
*                                                      row        = ls_minimum-line
*                                                      status     = gc_status-erro
*                                                      type       = iv_msgty
*                                                      id         = 'ZSD_GESTAO_PRECOS'
*                                                      number     = '020'
*                                                      field      = 'DATE_TO' ) ).
*      ENDIF.

*      IF  is_header-process_date IS NOT INITIAL
*      AND NOT ( ls_minimum-date_from <= is_header-process_date AND is_header-process_date <= ls_minimum-date_to ).
*        " Data de processamento deve estar entre a 'Data Desde' e 'Data Até'.
*        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
*                                                      line       = ls_minimum-line
*                                                      row        = ls_minimum-line
*                                                      status     = gc_status-erro
*                                                      type       = iv_msgty
*                                                      id         = 'ZSD_GESTAO_PRECOS'
*                                                      number     = '037'
*                                                      field      = 'DATE_FROM' ) ).
*      ENDIF.

      " ---------------------------------------------------------------------
      " Valida se não houve erro para linha
      " ---------------------------------------------------------------------
      IF gv_aprovar NE abap_true.
        TRY.
            DATA(ls_validation) = ct_validation[ guid = ls_minimum-guid
                                                 line = ls_minimum-line ].
          CATCH cx_root.

            " Linha &1:Registro validado.

            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_minimum-guid
                                                          line       = ls_minimum-line
                                                          row        = ls_minimum-line
                                                          status     = gc_status-validado
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '047'
                                                          message_v1 = ls_minimum-line
                                                          field      = 'LINE' ) ).


        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD validation_initial_min_field.

    IF is_minimum-dist_channel  IS INITIAL.
      " Linha &1:Campo Centro está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-001 "Canal de distribuição
                                                    field      = 'DIST_CHANNEL' ) ).

    ENDIF.

    IF is_minimum-plant  IS INITIAL.
      " Linha &1:Campo Centro está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-002 "Centro
                                                    field      = 'PLANT' ) ).

    ENDIF.
    IF is_minimum-material  IS INITIAL.
      " Linha &1:Campo Cód Material está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-011 "Cód Material
                                                    field      = 'MATERIAL' ) ).

    ENDIF.
    IF is_minimum-min_value IS INITIAL.
      " Linha &1:Campo Preço mínimo está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-006 "Preço mínimo
                                                    field      = 'MIN_VALUE' ) ).

    ENDIF.
    IF is_minimum-date_from IS INITIAL.
      " Linha &1:Campo Data desde está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-009 "Data desde
                                                    field      = 'DATE_FROM' ) ).

    ENDIF.
    IF is_minimum-date_to IS INITIAL.
      " Linha &1:Campo Data até está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_minimum-guid
                                                    line       = is_minimum-line
                                                    row        = is_minimum-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_minimum-line
                                                    message_v2 = TEXT-010 "Data até
                                                    field      = 'DATE_TO' ) ).

    ENDIF.
  ENDMETHOD.


  METHOD validate_invasion_fields.


    DATA: lt_invasion_key TYPE ty_t_invasion.

    DATA(lt_invasion) = it_invasion.
    SORT lt_invasion BY guid line.

* ---------------------------------------------------------------------------
*   Aplica validações
* ---------------------------------------------------------------------------
    LOOP AT lt_invasion INTO DATA(ls_invasion).    "#EC CI_LOOP_INTO_WA

      DATA(lv_index) = sy-tabix.
      " ---------------------------------------------------------------------
      " Valida campos vazios
      " ---------------------------------------------------------------------
      validation_initial_inv_field( EXPORTING  iv_msgty     = iv_msgty
                                               is_invasion  = ls_invasion
                                     CHANGING ct_validation = ct_validation ).
      " ---------------------------------------------------------------------
      " Valida se existe linha repetida
      " ---------------------------------------------------------------------
      lt_invasion_key[] = VALUE #( FOR ls_inv IN lt_invasion FROM lv_index WHERE (     guid         EQ ls_invasion-guid
                                                                                   AND line         <> ls_invasion-line
                                                                                   AND kunnr        EQ ls_invasion-kunnr )
                                                                                   "AND price_list   EQ ls_invasion-price_list )
                                                                                   ( CORRESPONDING #( ls_inv ) ) ).
      IF lines( lt_invasion_key ) = 0.
        DATA(lv_old_index) = lv_index - 1.
        lt_invasion_key[] = VALUE #( FOR ls_inv IN lt_invasion FROM lv_old_index WHERE ( guid         EQ ls_invasion-guid
                                                                                     AND line         <> ls_invasion-line
                                                                                     AND kunnr        EQ ls_invasion-kunnr )
                                                                                     "AND price_list   EQ ls_invasion-price_list )
                                                                                     ( CORRESPONDING #( ls_inv ) ) ).
      ENDIF.

      IF lines( lt_invasion_key ) > 0.
        " Existe outra linha com os mesmos dados
        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                      line       = ls_invasion-line
                                                      row        = ls_invasion-line
                                                      status     = gc_status-erro
                                                      type       = iv_msgty
                                                      id         = 'ZSD_GESTAO_PRECOS'
                                                      number     = '005'
                                                      message_v1 = ls_invasion-line
                                                      field      = 'LINE' ) ).
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida Cliente
      " ---------------------------------------------------------------------
      TRY.

          DATA(ls_knvv) = it_knvv[ kunnr = ls_invasion-kunnr ].

        CATCH cx_root.
          " Linha &1:Cliente '&2' não existe.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                        line       = ls_invasion-line
                                                        row        = ls_invasion-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '059'
                                                        message_v1 = ls_invasion-line
                                                        message_v2 = ls_invasion-kunnr
                                                        field      = 'KUNNR' ) ).
      ENDTRY.

      " ---------------------------------------------------------------------
      " Valida tipo de lista de preço
      " ---------------------------------------------------------------------
*      TRY.
*          IF ls_invasion-price_list IS NOT INITIAL.
*            DATA(ls_t189) = it_t189[ pltyp = ls_invasion-price_list ].
*          ENDIF.
*
*        CATCH cx_root.
*          " Tipo de lista de preço '&1' não existe.
*          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
*                                                        line       = ls_invasion-line
*                                                        row        = ls_invasion-line
*                                                        status     = gc_status-erro
*                                                        type       = iv_msgty
*                                                        id         = 'ZSD_GESTAO_PRECOS'
*                                                        number     = '009'
*                                                        message_v1 = ls_invasion-price_list
*                                                        field      = 'PRICE_LIST' ) ).
*      ENDTRY.

      IF ls_invasion-zzdelete EQ 'x' OR ls_invasion-zzdelete EQ 'X'.
        TRY.

            DATA(ls_a627_del) = it_a627[ knumh = ls_invasion-condition_record ].

          CATCH cx_root.
            " Linha &1:Registro não exite na tabela &2.
            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                          line       = ls_invasion-line
                                                          row        = ls_invasion-line
                                                          status     = gc_status-erro
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '046'
                                                          message_v1 = ls_invasion-line
                                                          field      = 'LINE' ) ).
        ENDTRY.

      ENDIF.
      IF ls_invasion-zzdelete EQ ' '.
        " ---------------------------------------------------------------------
        " Valida Data Desde e Data Até
        " ---------------------------------------------------------------------
        IF ls_invasion-date_from > ls_invasion-date_to.
          " Data início é superior à Data fim.
          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                        line       = ls_invasion-line
                                                        row        = ls_invasion-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '020'
                                                        message_v1 = ls_invasion-line
                                                        field      = 'DATE_TO' ) ).
        ENDIF.

        " ---------------------------------------------------------------------
        " Valida Exclusão
        " ---------------------------------------------------------------------
        IF ls_invasion-zzdelete NE 'x' AND ls_invasion-zzdelete NE 'X' AND  ls_invasion-zzdelete NE ' '.
          " Linha &1:Valor não permitido para coluna "Exclusão".

          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                        line       = ls_invasion-line
                                                        row        = ls_invasion-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '044'
                                                        message_v1 = ls_invasion-line
                                                        field      = 'ZZDELETE' ) ).
        ENDIF.
        IF ( ls_invasion-zzdelete EQ 'x' OR ls_invasion-zzdelete EQ 'X' )
        AND ( ls_invasion-date_from NE ls_invasion-date_to ).

          " Linha &1:'Data desde' e 'Data até' devem ser iguais para exclusão.

          ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                        line       = ls_invasion-line
                                                        row        = ls_invasion-line
                                                        status     = gc_status-erro
                                                        type       = iv_msgty
                                                        id         = 'ZSD_GESTAO_PRECOS'
                                                        number     = '045'
                                                        message_v1 = ls_invasion-line
                                                        field      = 'ZZDELETE' ) ).

        ENDIF.

        " ---------------------------------------------------------------------
        " Valida se a Data Desde e Data Até são válidas
        " ---------------------------------------------------------------------
        validation_data( EXPORTING
                          iv_msgty     = iv_msgty
                          iv_from_data = ls_invasion-date_from
                          iv_to_data   = ls_invasion-date_to
                          iv_guid      = ls_invasion-guid
                          iv_line      = ls_invasion-line
                         CHANGING
                          ct_validation = ct_validation ).
        " -----------------------------------------------------------
*      IF  is_header-process_date IS NOT INITIAL
*      AND NOT ( ls_invasion-date_from <= is_header-process_date AND is_header-process_date <= ls_invasion-date_to ).
*        " Data de processamento deve estar entre a 'Data Desde' e 'Data Até'.
*        ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
*                                                      line       = ls_invasion-line
*                                                      row        = ls_invasion-line
*                                                      status     = gc_status-erro
*                                                      type       = iv_msgty
*                                                      id         = 'ZSD_GESTAO_PRECOS'
*                                                      number     = '037'
*                                                      message_v1 = ls_invasion-line
*                                                      field      = 'DATE_FROM' ) ).
*      ENDIF.
      ENDIF.

      " ---------------------------------------------------------------------
      " Valida se não houve erro para linha
      " ---------------------------------------------------------------------
      IF gv_aprovar NE abap_true.
        TRY.
            DATA(ls_validation) = ct_validation[ guid = ls_invasion-guid
                                                 line = ls_invasion-line ].
          CATCH cx_root.

            " Linha &1:Registro validado.

            ct_validation = VALUE #( BASE ct_validation ( guid       = ls_invasion-guid
                                                          line       = ls_invasion-line
                                                          row        = ls_invasion-line
                                                          status     = gc_status-validado
                                                          type       = iv_msgty
                                                          id         = 'ZSD_GESTAO_PRECOS'
                                                          number     = '047'
                                                          message_v1 = ls_invasion-line
                                                          field      = 'LINE' ) ).


        ENDTRY.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD validation_initial_inv_field.
*    IF is_invasion-zzdelete EQ ' '.
    IF is_invasion-kunnr IS INITIAL.
      " Linha &1:Campo Nº cliente está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_invasion-guid
                                                    line       = is_invasion-line
                                                    row        = is_invasion-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_invasion-line
                                                    message_v2 = TEXT-012 "Nº cliente
                                                    field      = 'KUNNR' ) ).

    ENDIF.
    IF is_invasion-date_from IS INITIAL.
      " Linha &1:Campo Data desde está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_invasion-guid
                                                    line       = is_invasion-line
                                                    row        = is_invasion-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_invasion-line
                                                    message_v2 = TEXT-009 "Data desde
                                                    field      = 'DATE_FROM' ) ).

    ENDIF.
    IF is_invasion-date_to IS INITIAL.
      " Linha &1:Campo Data até está vazio.
      ct_validation = VALUE #( BASE ct_validation ( guid       = is_invasion-guid
                                                    line       = is_invasion-line
                                                    row        = is_invasion-line
                                                    status     = gc_status-erro
                                                    type       = iv_msgty
                                                    id         = 'ZSD_GESTAO_PRECOS'
                                                    number     = '043'
                                                    message_v1 = is_invasion-line
                                                    message_v2 = TEXT-010 "Data até
                                                    field      = 'DATE_TO' ) ).

    ENDIF.
*    ENDIF.

  ENDMETHOD.


  METHOD prepare_price_criticality.

    DATA: lv_status TYPE ztsd_preco_h-status.
    lv_status = gc_status-pendente.
* ---------------------------------------------------------------------------
* Atualiza campos status e criticalidade do cabeçalho
* ---------------------------------------------------------------------------
    CLEAR: cs_header-approve_user_criticality,
           cs_header-plant_criticality.

    "Caso algum valor foi alterado iremos setar o status para rascunho.
    IF gs_modify EQ abap_true.
      me->compare_data_get_status(
          CHANGING
          cv_status_new = lv_status
          cs_header     = cs_header
          ct_item       = ct_item
          ct_minimum    = ct_minimum
          ct_invasion   = ct_invasion
      ).
    ELSE.

      READ TABLE it_validation INTO DATA(ls_validation) WITH KEY guid = cs_header-guid status = gc_status-erro. "#EC CI_STDSEQ

      IF sy-subrc EQ 0.
        cs_header-status = ls_validation-status.
      ELSE.

        READ TABLE it_validation INTO ls_validation WITH KEY guid = cs_header-guid status = gc_status-alerta.
        IF sy-subrc EQ 0.
          cs_header-status = ls_validation-status.
        ELSE.

          READ TABLE it_validation INTO ls_validation WITH KEY guid = cs_header-guid status = gc_status-validado.
          IF sy-subrc EQ 0.
            cs_header-status = ls_validation-status.
          ELSE.

            READ TABLE it_validation INTO ls_validation WITH KEY guid = cs_header-guid.
            IF sy-subrc EQ 0.
              cs_header-status = ls_validation-status.
            ELSE.
              cs_header-status = lv_status.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.

      LOOP AT it_validation INTO ls_validation WHERE guid = cs_header-guid
                                                 AND line = 0. "#EC CI_STDSEQ

        me->update_field_criticality( EXPORTING is_validation = ls_validation
                                      CHANGING  cs_data       = cs_header ).
      ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos status e criticalidade do item
* ---------------------------------------------------------------------------
      LOOP AT ct_item REFERENCE INTO DATA(ls_item).

        CLEAR: ls_item->line_criticality,
               ls_item->dist_channel_criticality,
               ls_item->price_list_criticality,
               ls_item->material_criticality,
               ls_item->scale_criticality,
               ls_item->base_unit_criticality,
               ls_item->min_value_criticality,
               ls_item->sug_value_criticality,
               ls_item->max_value_criticality,
               ls_item->currency_criticality,
               ls_item->date_from_criticality,
               ls_item->date_to_criticality.

        READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_item->guid
                                                             line = ls_item->line
                                                             status = gc_status-erro.
        IF sy-subrc EQ 0.
          ls_item->status = ls_validation-status.
        ELSE.

          READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_item->guid
                                                               line = ls_item->line
                                                               status = gc_status-alerta.
          IF sy-subrc EQ 0.
            ls_item->status = ls_validation-status.
          ELSE.

            READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_item->guid
                                                                 line = ls_item->line
                                                                 status = gc_status-validado.
            IF sy-subrc EQ 0.
              ls_item->status = ls_validation-status.
            ELSE.

              READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_item->guid line = ls_item->line.
              IF sy-subrc EQ 0.
                ls_item->status = ls_validation-status.
              ELSE.
                ls_item->status = lv_status.
              ENDIF.
            ENDIF.
          ENDIF.

        ENDIF.

        LOOP AT it_validation INTO ls_validation WHERE guid = ls_item->guid
                                                   AND line = ls_item->line. "#EC CI_STDSEQ #EC CI_NESTED

          me->update_field_criticality( EXPORTING is_validation = ls_validation
                                        CHANGING  cs_data       = ls_item->* ).
        ENDLOOP.
      ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos status e criticalidade do alerta mínimo
* ---------------------------------------------------------------------------
      LOOP AT ct_minimum REFERENCE INTO DATA(ls_minimum).

        CLEAR: ls_minimum->line_criticality,
               ls_minimum->material_criticality,
               ls_minimum->min_value_criticality,
               ls_minimum->currency_criticality,
               ls_minimum->date_from_criticality.

        READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_minimum->guid
                                                             line = ls_minimum->line. "#EC CI_STDSEQ
        IF sy-subrc EQ 0.
          ls_minimum->status = ls_validation-status.
        ELSE.
          READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_minimum->guid
                                                               line = ls_minimum->line
                                                               status = gc_status-alerta.
          IF sy-subrc EQ 0.
            ls_minimum->status = ls_validation-status.
          ELSE.

            READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_minimum->guid
                                                                 line = ls_minimum->line
                                                                 status = gc_status-validado.
            IF sy-subrc EQ 0.
              ls_minimum->status = ls_validation-status.
            ELSE.

              READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_minimum->guid line = ls_minimum->line.
              IF sy-subrc EQ 0.
                ls_minimum->status = ls_validation-status.
              ELSE.
                ls_minimum->status = lv_status.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.

        LOOP AT it_validation INTO ls_validation WHERE guid = ls_minimum->guid
                                                   AND line = ls_minimum->line. "#EC CI_STDSEQ #EC CI_NESTED

          me->update_field_criticality( EXPORTING is_validation = ls_validation
                                        CHANGING  cs_data       = ls_minimum->* ).
        ENDLOOP.
      ENDLOOP.

* ---------------------------------------------------------------------------
* Atualiza campos status e criticalidade de invasão
* ---------------------------------------------------------------------------
      LOOP AT ct_invasion REFERENCE INTO DATA(ls_invasion).

        CLEAR: ls_invasion->line_criticality,
               "ls_invasion->price_list_criticality,
               ls_invasion->min_value_criticality,
               ls_invasion->currency_criticality,
               ls_invasion->date_from_criticality,
               ls_invasion->date_to_criticality.

        READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_invasion->guid
                                                             line = ls_invasion->line. "#EC CI_STDSEQ
        IF sy-subrc EQ 0.
          ls_invasion->status = ls_validation-status.
        ELSE.
          READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_invasion->guid
                                                               line = ls_invasion->line
                                                               status = gc_status-alerta.
          IF sy-subrc EQ 0.
            ls_invasion->status = ls_validation-status.
          ELSE.

            READ TABLE it_validation INTO ls_validation WITH KEY guid = ls_invasion->guid line = ls_invasion->line.
            IF sy-subrc EQ 0.
              ls_invasion->status = ls_validation-status.
            ELSE.
              ls_invasion->status = lv_status.
            ENDIF.
          ENDIF.
        ENDIF.

        LOOP AT it_validation INTO ls_validation WHERE guid = ls_invasion->guid
                                                   AND line = ls_invasion->line. "#EC CI_STDSEQ #EC CI_NESTED

          me->update_field_criticality( EXPORTING is_validation = ls_validation
                                        CHANGING  cs_data       = ls_invasion->* ).
        ENDLOOP.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD get_parameter.

    FREE ev_value.

    TRY.
        DATA(lo_param) = NEW zclca_tabela_parametros( ).

        lo_param->m_get_single( EXPORTING iv_modulo = is_param-modulo
                                          iv_chave1 = is_param-chave1
                                          iv_chave2 = is_param-chave2
                                          iv_chave3 = is_param-chave3
                                IMPORTING ev_param  = ev_value ).
      CATCH zcxca_tabela_parametros.
        FREE ev_value.
    ENDTRY.

  ENDMETHOD.


  METHOD get_configuration.

    FREE: et_return, es_parameter.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de Tipo condição - Preço
* ---------------------------------------------------------------------------
    IF me->gs_parameter-kschl_zpr0 IS INITIAL.

      DATA(ls_parametro) = VALUE ztca_param_val( modulo = gc_param_kschl_zpr0-modulo
                                                 chave1 = gc_param_kschl_zpr0-chave1
                                                 chave2 = gc_param_kschl_zpr0-chave2
                                                 chave3 = gc_param_kschl_zpr0-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-kschl_zpr0 ).

    ENDIF.

    IF me->gs_parameter-kschl_zpr0 IS INITIAL.
      " Tp. Condição 'Preço' não configurado em parâmetro (&1/&2/&3/&4)
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZSD_GESTAO_PRECOS' number = '023'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3
                                            field      = 'CONDITION_TYPE'
                                            ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de Tipo condição - Valor Mínimo Crivo
* ---------------------------------------------------------------------------
    IF me->gs_parameter-kschl_zvmc IS INITIAL.

      ls_parametro = VALUE ztca_param_val( modulo = gc_param_kschl_zvmc-modulo
                                           chave1 = gc_param_kschl_zvmc-chave1
                                           chave2 = gc_param_kschl_zvmc-chave2
                                           chave3 = gc_param_kschl_zvmc-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-kschl_zvmc ).

    ENDIF.

    IF me->gs_parameter-kschl_zvmc IS INITIAL.
      " Tp. Condição 'Valor Mínimo Crivo' não configurado em parâm. (&1/&2/&3/&4)
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZSD_GESTAO_PRECOS' number = '024'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3
                                            field      = 'CONDITION_TYPE'
                                            ) ).
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera Parâmetro de Tipo condição - Invasão
* ---------------------------------------------------------------------------
    IF me->gs_parameter-kschl_zalt IS INITIAL.

      ls_parametro = VALUE ztca_param_val( modulo = gc_param_kschl_zalt-modulo
                                           chave1 = gc_param_kschl_zalt-chave1
                                           chave2 = gc_param_kschl_zalt-chave2
                                           chave3 = gc_param_kschl_zalt-chave3 ).

      me->get_parameter( EXPORTING is_param = ls_parametro
                         IMPORTING ev_value = me->gs_parameter-kschl_zalt ).

    ENDIF.

    IF me->gs_parameter-kschl_zalt IS INITIAL.
      " Tp. Condição 'Invasão' não configurado em parâm. (&1/&2/&3/&4).
      et_return = VALUE #( BASE et_return ( type = 'I' id = 'ZSD_GESTAO_PRECOS' number = '029'
                                            message_v1 = ls_parametro-modulo
                                            message_v2 = ls_parametro-chave1
                                            message_v3 = ls_parametro-chave2
                                            message_v4 = ls_parametro-chave3
                                            field      = 'CONDITION_TYPE'
                                            ) ).
    ENDIF.

    me->format_return( CHANGING ct_return = et_return ).

    es_parameter = me->gs_parameter.

  ENDMETHOD.


  METHOD update_field_criticality.


    IF gs_upload NE abap_true AND is_validation-field IS NOT INITIAL.
      DATA(lv_field) = |{ is_validation-field }_CRITICALITY|.

      ASSIGN COMPONENT lv_field OF STRUCTURE cs_data TO FIELD-SYMBOL(<fs_v_field>).

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      TRY.
          <fs_v_field> =  SWITCH #( is_validation-status
                          WHEN gc_status-rascunho         THEN gc_criticalidade-branco
                          WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                          WHEN gc_status-pendente         THEN gc_criticalidade-verde
                          WHEN gc_status-erro             THEN gc_criticalidade-vermelho
                          WHEN gc_status-aprovado         THEN gc_criticalidade-verde
                          WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                          WHEN gc_status-divergencia      THEN gc_criticalidade-vermelho ).

        CATCH cx_root.
      ENDTRY.

    ELSE.
      lv_field = |{ 'LINE' }_CRITICALITY|.
      ASSIGN COMPONENT lv_field OF STRUCTURE cs_data TO <fs_v_field>.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

      TRY.
          <fs_v_field> =  SWITCH #( gc_status-pendente
                          WHEN gc_status-rascunho        THEN gc_criticalidade-branco
                          WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                          WHEN gc_status-pendente               THEN gc_criticalidade-verde
                          WHEN gc_status-erro           THEN gc_criticalidade-vermelho
                          WHEN gc_status-aprovado       THEN gc_criticalidade-verde
                          WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                          WHEN gc_status-divergencia          THEN gc_criticalidade-vermelho ).

        CATCH cx_root.
      ENDTRY.
    ENDIF.

  ENDMETHOD.


  METHOD sort_validation.
    SORT ct_validation BY guid line.

    DATA(lt_validation_00) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-rascunho ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_01) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-em_processamento ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_02) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-pendente ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_03) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-erro ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_04) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-aprovado ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_05) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-alerta ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_06) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-divergencia ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_07) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-reprovado ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_08) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-eliminado ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_09) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-validado ) ( ls_validation ) ). "#EC CI_STDSEQ
    DATA(lt_validation_10) = VALUE ty_t_validation( FOR ls_validation IN ct_validation WHERE ( status = gc_status-alertaexp ) ( ls_validation ) ). "#EC CI_STDSEQ

    FREE ct_validation.
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_03 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_05 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_10 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_09 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_06 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_07 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_04 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_02 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_01 ( ls_validation ) ).
    ct_validation[] = VALUE #( BASE ct_validation FOR ls_validation IN lt_validation_04 ( ls_validation ) ).

    SORT ct_validation BY line.
  ENDMETHOD.


  METHOD validate_request.

    FREE: es_header_cds, et_item_cds, et_minimum_cds, et_invasion_cds, et_return.

* ---------------------------------------------------------------------------
* Elimina mensagens de erro
* ---------------------------------------------------------------------------
    me->clear_message( is_header_cds ).

* ---------------------------------------------------------------------------
* Converte CDS para tabela
* ---------------------------------------------------------------------------
    me->convert_cds_to_table( EXPORTING is_header_cds   = is_header_cds
                                        it_item_cds     = it_item_cds
                                        it_minimum_cds  = it_minimum_cds
                                        it_invasion_cds = it_invasion_cds
                              IMPORTING es_header       = DATA(ls_header)
                                        et_item         = DATA(lt_item)
                                        et_minimum      = DATA(lt_minimum)
                                        et_invasion     = DATA(lt_invasion) ).

    me->determine_line( CHANGING  ct_item     = lt_item
                                  ct_minimum  = lt_minimum
                                  ct_invasion = lt_invasion ).

* ---------------------------------------------------------------------------
* Valida dados importados
* ---------------------------------------------------------------------------
    me->validate_info( EXPORTING iv_msgty      = iv_msgty
                       IMPORTING et_validation = DATA(lt_validation)
                       CHANGING  cs_header     = ls_header
                                 ct_item       = lt_item
                                 ct_minimum    = lt_minimum
                                 ct_invasion   = lt_invasion ).

* ---------------------------------------------------------------------------
* Aplica avisos nos campos validados
* ---------------------------------------------------------------------------
    me->prepare_price_criticality( EXPORTING it_validation = lt_validation
                                   CHANGING  cs_header     = ls_header
                                             ct_item       = lt_item
                                             ct_minimum    = lt_minimum
                                             ct_invasion   = lt_invasion ).

* ---------------------------------------------------------------------------
* Converte tabela para CDS
* ---------------------------------------------------------------------------
    me->convert_table_to_cds( EXPORTING is_header       = ls_header
                                        it_item         = lt_item
                                        it_minimum      = lt_minimum
                                        it_invasion     = lt_invasion
                              IMPORTING es_header_cds   = es_header_cds
                                        et_item_cds     = et_item_cds
                                        et_minimum_cds  = et_minimum_cds
                                        et_invasion_cds = et_invasion_cds ).

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
    me->save_file( EXPORTING iv_level    = iv_level
                             is_header   = ls_header
                             it_item     = lt_item
                             it_minimum  = lt_minimum
                             it_invasion = lt_invasion ).

* ---------------------------------------------------------------------------
* Prepara mensagens
* ---------------------------------------------------------------------------
    me->convert_validation_to_return( EXPORTING it_validation = lt_validation
                                      IMPORTING et_return     = et_return ).

* ---------------------------------------------------------------------------
* Salva mensagens de erro
* ---------------------------------------------------------------------------
    me->update_field_message( EXPORTING it_validation = lt_validation  CHANGING ct_return = et_return ).

    IF et_return[] IS NOT INITIAL.
      RETURN.
    ENDIF.

*  IF it_item_cds IS NOT SUPPLIED.
*    " Cabeçalho validado com sucesso.
*    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '021' ) ).
*  ELSEIF it_item_cds IS NOT INITIAL.
*    " Itens validados com sucesso.
*    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '022' ) ).
*  ELSEIF it_minimum_cds IS NOT INITIAL.
*    " Mínimo validado com sucesso.
*    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '026' ) ).
*  ELSEIF it_invasion_cds IS NOT INITIAL.
*    " Invasão validado com sucesso.
*    et_return[] = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '028' ) ).
*  ENDIF.

  ENDMETHOD.


  METHOD clear_message.

    SELECT *
    FROM ztsd_preco_msg
    INTO TABLE @DATA(lt_msg)
    WHERE guid = @is_header_cds-guid.

    IF lt_msg[] IS NOT INITIAL.
      DELETE ztsd_preco_msg FROM TABLE lt_msg[].
    ENDIF.


  ENDMETHOD.


  METHOD update_field_message.

    DATA lt_msg  TYPE TABLE OF ztsd_preco_msg.
    DATA ls_msg  TYPE ztsd_preco_msg.
    DATA lv_line TYPE string.

    DATA(lt_return) =  ct_return[].
    SORT lt_return BY id number row field.

    GET TIME STAMP FIELD DATA(lv_timestamp).


    LOOP AT it_validation ASSIGNING FIELD-SYMBOL(<fs_validation>).
      READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WITH KEY id     = <fs_validation>-id
                                                                        number = <fs_validation>-number
                                                                        row    = <fs_validation>-line
                                                                        field  = <fs_validation>-field BINARY SEARCH.

      IF <fs_return> IS ASSIGNED AND  <fs_return>-type NE 'S'.
        IF ls_msg-line > 0 AND ls_msg-line NE <fs_return>-row.
          CLEAR: ls_msg.
        ENDIF.

        ls_msg-guid                  = <fs_validation>-guid.
        ls_msg-line                  = <fs_validation>-line.
        ls_msg-mandt                 = sy-mandt.
        ls_msg-msg_line              = ls_msg-msg_line + 1.
        SPLIT <fs_return>-message AT ':' INTO lv_line ls_msg-message.
        ls_msg-created_by            = sy-uname.
        ls_msg-created_at            = sy-datum.
        ls_msg-last_changed_by       = sy-uname.
        ls_msg-last_changed_at       = sy-datum.
        ls_msg-local_last_changed_at = lv_timestamp.
        CASE <fs_validation>-status.
          WHEN gc_status-alerta.
            ls_msg-line_criticality = 2.
          WHEN gc_status-alertaexp.
            ls_msg-line_criticality = 2.
          WHEN gc_status-validado.
            ls_msg-line_criticality = 3.
          WHEN gc_status-eliminado.
            ls_msg-line_criticality = 1.
          WHEN gc_status-reprovado.
            ls_msg-line_criticality = 1.
          WHEN gc_status-erro.
            ls_msg-line_criticality = 1.
          WHEN OTHERS.
            ls_msg-line_criticality = 0.
        ENDCASE.

        APPEND ls_msg TO lt_msg.
        UNASSIGN <fs_return>.
      ENDIF.

    ENDLOOP.

    IF lt_msg[] IS NOT INITIAL.
      MODIFY ztsd_preco_msg FROM TABLE lt_msg[].

      IF line_exists( it_validation[ status = gc_status-erro ] ).

        TRY.
            DATA(lv_type) = it_validation[ status = gc_status-erro ]-type.
            CLEAR ct_return[].
            "Erro! Consulte o campo de mensagens abaixo e providencie as correções.
            APPEND VALUE #( type   = lv_type
                            id     = 'ZSD_GESTAO_PRECOS'
                            number = '060'  ) TO ct_return[].
            me->format_return( CHANGING ct_return = ct_return ).
          CATCH cx_root.
        ENDTRY.

      ELSEIF line_exists( it_validation[ status = gc_status-alerta ] ) OR line_exists( it_validation[ status = gc_status-alertaexp ] ) .

        TRY.
            lv_type = it_validation[ status = gc_status-alerta ]-type.
            CLEAR ct_return[].

            "Alerta! Consulte o campo de mensagens abaixo e acompanhe sua solicitação pelo Cockpit.
            APPEND VALUE #( type   = lv_type
                            id     = 'ZSD_GESTAO_PRECOS'
                            number = '061'  ) TO ct_return[].
            me->format_return( CHANGING ct_return = ct_return ).
          CATCH cx_root.
            lv_type = it_validation[ status = gc_status-alertaexp ]-type.
            CLEAR ct_return[].

            "Alerta! Consulte o campo de mensagens abaixo e acompanhe sua solicitação pelo Cockpit.
            APPEND VALUE #( type   = lv_type
                            id     = 'ZSD_GESTAO_PRECOS'
                            number = '061'  ) TO ct_return[].
            me->format_return( CHANGING ct_return = ct_return ).
        ENDTRY.

      ELSEIF line_exists( it_validation[ status = gc_status-validado ] ).

        TRY.
            lv_type = it_validation[ status = gc_status-validado ]-type.
            CLEAR ct_return[].

            "Registros Validados! Acompanhe sua solicitação pelo Cockpit.
            APPEND VALUE #( type   = lv_type
                            id     = 'ZSD_GESTAO_PRECOS'
                            number = '062'  ) TO ct_return[].
            me->format_return( CHANGING ct_return = ct_return ).
          CATCH cx_root.
        ENDTRY.

      ENDIF.


    ENDIF.

  ENDMETHOD.


  METHOD approve_request.
    DATA lt_item_elim TYPE ty_t_item.
    DATA lt_inv_elim TYPE ty_t_invasion.

    FREE: es_header_cds, et_item_cds, et_minimum_cds, et_invasion_cds, et_return.
    gv_aprovar = abap_true.
* ---------------------------------------------------------------------------
* Valida campos antes de prosseguir
* ---------------------------------------------------------------------------
    me->validate_request( EXPORTING iv_level        = iv_level
                                    iv_msgty        = 'E'
                                    is_header_cds   = is_header_cds
                                    it_item_cds     = it_item_cds
                                    it_minimum_cds  = it_minimum_cds
                                    it_invasion_cds = it_invasion_cds
                          IMPORTING es_header_cds   = es_header_cds
                                    et_item_cds     = et_item_cds
                                    et_minimum_cds  = et_minimum_cds
                                    et_invasion_cds = et_invasion_cds
                                    et_return       = DATA(lt_return) ).

    IF line_exists( lt_return[ type = 'I' ] )            "#EC CI_STDSEQ
    OR line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      INSERT LINES OF lt_return INTO TABLE et_return.
      RETURN.
    ENDIF.

* ---------------------------------------------------------------------------
* Converte CDS para tabela
* ---------------------------------------------------------------------------
    me->convert_cds_to_table( EXPORTING is_header_cds   = is_header_cds
                                        it_item_cds     = it_item_cds
                                        it_minimum_cds  = it_minimum_cds
                                        it_invasion_cds = it_invasion_cds
                              IMPORTING es_header       = DATA(ls_header)
                                        et_item         = DATA(lt_item)
                                        et_minimum      = DATA(lt_minimum)
                                        et_invasion     = DATA(lt_invasion) ).

* ---------------------------------------------------------------------------
* Recupera dados para lançamento
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING is_header   = ls_header
                            it_item     = lt_item
                            it_minimum  = lt_minimum
                            it_invasion = lt_invasion
                  IMPORTING et_a817     = DATA(lt_a817)
                            et_a816     = DATA(lt_a816)
                            et_a627     = DATA(lt_a627)
                            et_a626     = DATA(lt_a626)
                            et_konp     = DATA(lt_konp) ).

* ---------------------------------------------------------------------------
* Verifica se há registros para esclusão
* ---------------------------------------------------------------------------
    lt_item_elim = VALUE #( FOR ls_it IN lt_item WHERE (  (  status = gc_status-validado OR status = gc_status-alerta )
                                                   AND    (  zzdelete EQ 'X' OR zzdelete EQ 'x' ) )
                                                       ( CORRESPONDING #( ls_it ) ) ).

    lt_inv_elim = VALUE #( FOR ls_inv IN lt_invasion WHERE ( (  status = gc_status-validado OR status = gc_status-alerta )
                                                      AND    (  zzdelete EQ 'X' OR zzdelete EQ 'x' ) )
                                                          ( CORRESPONDING #( ls_inv ) ) ).
* ---------------------------------------------------------------------------
* Chama BAPI para realizar exclusão
* ---------------------------------------------------------------------------
    IF lt_item_elim IS NOT INITIAL .



      delete_price_list( CHANGING ct_item_elim = lt_item_elim
                                  ct_item      = lt_item
                                  cs_header    = ls_header
                                  ct_return    = lt_return ).

    ELSEIF lt_inv_elim IS NOT INITIAL.

      delete_invasion( CHANGING ct_inv_elim = lt_inv_elim
                                ct_invasion = lt_invasion
                                cs_header   = ls_header
                                ct_return   = lt_return ).
    ELSE.
* ---------------------------------------------------------------------------
* Chama BAPI para lançar registros de condição de uso de preço
* ---------------------------------------------------------------------------
      me->create_price_condition( EXPORTING it_a817        = lt_a817
                                            it_a816        = lt_a816
                                            it_a627        = lt_a627
                                            it_a626        = lt_a626
                                            it_konp        = lt_konp
                                  IMPORTING et_return      = lt_return
                                  CHANGING  cs_header      = ls_header
                                            ct_item        = lt_item
                                            ct_minimum     = lt_minimum
                                            ct_invasion    = lt_invasion ).
    ENDIF.



    INSERT LINES OF lt_return INTO TABLE et_return[].

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
    me->save_file( EXPORTING iv_level    = iv_level
                             is_header   = ls_header
                             it_item     = lt_item
                             it_minimum  = lt_minimum
                             it_invasion = lt_invasion
                   IMPORTING et_return   = lt_return ).

    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      INSERT LINES OF lt_return INTO TABLE et_return[].
    ENDIF.

* ---------------------------------------------------------------------------
* Converte tabela para CDS
* ---------------------------------------------------------------------------
    me->convert_table_to_cds( EXPORTING is_header       = ls_header
                                        it_item         = lt_item
                                        it_minimum      = lt_minimum
                                        it_invasion     = lt_invasion
                              IMPORTING es_header_cds   = es_header_cds
                                        et_item_cds     = et_item_cds
                                        et_minimum_cds  = et_minimum_cds
                                        et_invasion_cds = et_invasion_cds ).

    CLEAR gv_aprovar.
  ENDMETHOD.


  METHOD delete_invasion.

    DATA lv_record TYPE zi_sd_lista_de_preco.

    SELECT  *
          FROM zi_sd_invasao
          FOR ALL ENTRIES IN @ct_inv_elim
             WHERE kappl    EQ @gc_preco-aplicacao_sd
               AND kschl    EQ @gs_parameter-kschl_zalt
               AND knumh    EQ @ct_inv_elim-condition_record
               AND loevm_ko EQ @space
               INTO TABLE @DATA(lt_invasao_del).

    SORT lt_invasao_del BY knumh.
    LOOP AT ct_inv_elim ASSIGNING FIELD-SYMBOL(<fs_inv>) .


      READ TABLE lt_invasao_del ASSIGNING FIELD-SYMBOL(<fs_invasao_del>) WITH KEY knumh = <fs_inv>-condition_record BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        lv_record = CORRESPONDING #( <fs_invasao_del>  ).

        CALL FUNCTION 'ZFMSD_GESTAO_PRECO_EXCLUSAO'
          STARTING NEW TASK 'EXCLUSAO'
          CALLING atuali_messages ON END OF TASK
          EXPORTING
            iv_data_in  = <fs_inv>-date_from
            iv_data_fim = <fs_inv>-date_to
            iv_op_type  = <fs_inv>-operation_type
            is_record   = lv_record.

        WAIT UNTIL gv_wait_async = abap_true.
        DATA(lt_return) = gt_messages.
        CLEAR gv_wait_async.

        IF lt_return[] IS INITIAL.
          " Linha &1: Nenhuma operação realizada, revisar lançamento da BAPI.
          ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '031' message_v1 = <fs_inv>-line ) ).
          CONTINUE.
        ENDIF.

        TRY.
            " Mensagem de sucesso
            DATA(lv_knumh) = CONV knumh( lt_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ
          CATCH cx_root.
            INSERT LINES OF lt_return[] INTO TABLE ct_return[].
            CONTINUE.
        ENDTRY.

        " Linha &1: Condição &2 excluída com sucesso.
        ct_return = VALUE #( BASE ct_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '040'
                                              message_v1 = <fs_inv>-line
                                              message_v2 = lv_knumh ) ).

        READ TABLE ct_invasion REFERENCE INTO DATA(ls_inv) WITH KEY guid = <fs_inv>-guid
                                                                    line = <fs_inv>-line. "#EC CI_STDSEQ #EC CI_NESTED
        IF sy-subrc EQ 0.
          cs_header-status          = gc_status-aprovado.
          ls_inv->status           = gc_status-aprovado.
          ls_inv->condition_record = lv_knumh.
        ENDIF.

      ELSE.
        " Linha &1:Registro não exite na tabela &2.
        ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '046'
                                              message_v1 = <fs_inv>-line ) ).

      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD delete_price_list.

    DATA: ls_record  TYPE zi_sd_lista_de_preco.
    DATA: ls_newitem TYPE zi_sd_lista_de_preco.

***Inicio - Inclusão para ajuste card 8000007283
    DATA: lt_new_scale TYPE ty_t_item .
    DATA: lt_old_scale TYPE ty_t_item .
***Fim - Inclusão para ajuste card 8000007283

    SELECT  *
      FROM zi_sd_lista_de_preco
      FOR ALL ENTRIES IN @ct_item_elim
         WHERE kappl    EQ @gc_preco-aplicacao_sd
           AND kschl    EQ @gs_parameter-kschl_zpr0
           AND vtweg    EQ @ct_item_elim-dist_channel
           AND pltyp    EQ @ct_item_elim-price_list
           AND werks    EQ @ct_item_elim-plant
           AND matnr    EQ @ct_item_elim-material
           AND loevm_ko EQ @space
           INTO TABLE @DATA(lt_lista_preco_del).

    SORT lt_lista_preco_del BY vtweg pltyp werks  matnr  kstbm.

    LOOP AT ct_item_elim ASSIGNING FIELD-SYMBOL(<fs_item_del>).



      READ TABLE lt_lista_preco_del ASSIGNING FIELD-SYMBOL(<fs_lista>) WITH KEY  vtweg = <fs_item_del>-dist_channel
                                                                                 pltyp = <fs_item_del>-price_list
                                                                                 werks = <fs_item_del>-plant
                                                                                 matnr = <fs_item_del>-material
                                                                                 kstbm = <fs_item_del>-scale BINARY SEARCH.
      IF sy-subrc IS INITIAL.

        ls_record  = CORRESPONDING #( <fs_lista>  ).
        ls_newitem = CORRESPONDING #( <fs_lista>  ).

*        ls_newitem-knumh  = ls_newitem-knumh + '1'.
*        ls_newitem-knumh  = |{ ls_newitem-knumh ALPHA = IN  }|.
        ls_newitem-vtweg  = <fs_item_del>-dist_channel.
        ls_newitem-pltyp  = <fs_item_del>-price_list.
        ls_newitem-werks  = <fs_item_del>-plant.
        ls_newitem-matnr  = <fs_item_del>-material.
        ls_newitem-datab  = <fs_item_del>-date_from.
        ls_newitem-datbi  = <fs_item_del>-date_to.
        ls_newitem-konwa  = <fs_item_del>-currency.
        ls_newitem-kbetr  = <fs_item_del>-sug_value.
        ls_newitem-kmein  = <fs_item_del>-base_unit.
        ls_newitem-mxwrt  = <fs_item_del>-min_value.
        ls_newitem-gkwrt  = <fs_item_del>-max_value.
        ls_newitem-kstbm  = <fs_item_del>-scale.

*** Inicio - Inclusão para ajuste card 8000007283
        lt_new_scale = VALUE #( FOR ls_it IN ct_item WHERE (  guid         EQ <fs_item_del>-guid
                                                        AND   dist_channel EQ <fs_item_del>-dist_channel
                                                        AND   price_list   EQ <fs_item_del>-price_list
                                                        AND   plant        EQ <fs_item_del>-plant
                                                        AND   material     EQ <fs_item_del>-material )
                                                                   ( CORRESPONDING #( ls_it ) )   ).



        LOOP AT lt_lista_preco_del ASSIGNING FIELD-SYMBOL(<fs_lp>). "#EC CI_NESTED

          IF <fs_lp>-vtweg  = <fs_item_del>-dist_channel
         AND <fs_lp>-pltyp  = <fs_item_del>-price_list
         AND <fs_lp>-werks  = <fs_item_del>-plant
         AND <fs_lp>-matnr  = <fs_item_del>-material
         AND <fs_lp>-datab <= <fs_item_del>-date_from
         AND <fs_lp>-datbi >= <fs_item_del>-date_to.

            APPEND  VALUE #(   scale     = <fs_lp>-kstbm
                               base_unit = <fs_lp>-kmein
                               sug_value = <fs_lp>-kbetr
                               currency  = <fs_lp>-konwa
                               line      = <fs_lp>-klfn1 ) TO lt_old_scale.

          ENDIF.
        ENDLOOP."#EC CI_NESTED
***Fim - Inclusão para ajuste card 8000007283

        CALL FUNCTION 'ZFMSD_GESTAO_PRECO_EXCLUSAO'
          STARTING NEW TASK 'EXCLUSAO'
          CALLING atuali_messages ON END OF TASK
          EXPORTING
            iv_data_in   = <fs_item_del>-date_from
            iv_data_fim  = <fs_item_del>-date_to
            iv_op_type   = <fs_item_del>-operation_type
            is_record    = ls_record
            is_newitem   = ls_newitem
          TABLES "Inicio - Inclusão para ajuste card 8000007283
            it_new_scale = lt_new_scale
            it_old_scale = lt_old_scale.
***Fim - Inclusão para ajuste card 8000007283

        WAIT UNTIL gv_wait_async = abap_true.
        DATA(lt_return) = gt_messages.
        CLEAR gv_wait_async.

        IF lt_return[] IS INITIAL.
          " Linha &1: Nenhuma operação realizada, revisar lançamento da BAPI.
          ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '031' message_v1 = <fs_item_del>-line ) ).
          CONTINUE.
        ENDIF.

        TRY.
            " Mensagem de sucesso
            DATA(lv_knumh) = CONV knumh( lt_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ
          CATCH cx_root.
            INSERT LINES OF lt_return[] INTO TABLE ct_return[].
            CONTINUE.
        ENDTRY.

        " Linha &1: Condição &2 excluída com sucesso.
        ct_return = VALUE #( BASE ct_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '040'
                                              message_v1 = <fs_item_del>-line
                                              message_v2 = lv_knumh ) ).

        READ TABLE ct_item REFERENCE INTO DATA(ls_item) WITH KEY guid = <fs_item_del>-guid
                                                                 line = <fs_item_del>-line. "#EC CI_STDSEQ #EC CI_NESTED
        IF sy-subrc EQ 0.
          cs_header-status          = gc_status-aprovado.
          ls_item->status           = gc_status-aprovado.
          ls_item->condition_record = lv_knumh.
        ENDIF.

      ELSE.
        " Linha &1:Registro não exite na tabela &2.
        ct_return = VALUE #( BASE ct_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '046'
                                              message_v1 = <fs_item_del>-line ) ).

      ENDIF.



    ENDLOOP.

  ENDMETHOD.


  METHOD atuali_messages.
    " Obter as mensagens de retorno da função que executa a Bapi.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_GESTAO_PRECO_EXCLUSAO'
          IMPORTING
            et_return = gt_messages.

    gv_wait_async = abap_true.
  ENDMETHOD.


  METHOD convert_cds_to_table.

    FREE: es_header, et_item, et_minimum, et_invasion.

* ---------------------------------------------------------------------------
* Converte dados de cabeçalho
* ---------------------------------------------------------------------------
    IF is_header_cds IS SUPPLIED.
      es_header-mandt                       = sy-mandt.
      es_header-guid                        = is_header_cds-guid.
      es_header-id                          = is_header_cds-id.
      es_header-status                      = is_header_cds-status.
      es_header-condition_type              = is_header_cds-conditiontype.
      es_header-request_user                = is_header_cds-requestuser.
*      es_header-approve_user                = is_header_cds-ApproveUser.
*      es_header-approve_user_criticality    = is_header_cds-ApproveUserCriticality.
*      es_header-plant                       = is_header_cds-plant.
*      es_header-plant_criticality           = is_header_cds-plantcriticality.
      IF gv_aprovar EQ abap_true.
        es_header-process_date                = sy-datum.
        es_header-process_time                = sy-uzeit.
        es_header-import_time                 = sy-uzeit.
      ELSE.
        es_header-process_date                = is_header_cds-processdate.
        es_header-process_time                = is_header_cds-processtime.
        es_header-import_time                 = is_header_cds-importtime.
      ENDIF.
      es_header-created_by                  = is_header_cds-createdby.
      es_header-created_at                  = is_header_cds-createdat.
      es_header-last_changed_by             = is_header_cds-lastchangedby.
      es_header-last_changed_at             = is_header_cds-lastchangedat.
      es_header-local_last_changed_at       = is_header_cds-locallastchangedat.
    ENDIF.

* ---------------------------------------------------------------------------
* Converte dados de item
* ---------------------------------------------------------------------------
    et_item[] = VALUE #( BASE et_item FOR ls_item_cds IN it_item_cds (
                mandt                      = sy-mandt
                guid                       = ls_item_cds-guid
                guid_line                  = ls_item_cds-guidline
                line                       = ls_item_cds-line
                line_criticality           = ls_item_cds-linecriticality
                status                     = ls_item_cds-status
                operation_type             = ls_item_cds-operationtype
                dist_channel               = ls_item_cds-distchannel
                dist_channel_criticality   = ls_item_cds-distchannelcriticality
                price_list                 = ls_item_cds-pricelist
                price_list_criticality     = ls_item_cds-pricelistcriticality
                plant                      = ls_item_cds-plant
                plant_criticality          = ls_item_cds-plantcriticality
                material                   = ls_item_cds-material
                material_criticality       = ls_item_cds-materialcriticality
                scale                      = ls_item_cds-scale
                scale_criticality          = ls_item_cds-scalecriticality
                base_unit                  = ls_item_cds-baseunit
                base_unit_criticality      = ls_item_cds-baseunitcriticality
                min_value                  = ls_item_cds-minvalue
                min_value_criticality      = ls_item_cds-minvaluecriticality
                sug_value                  = ls_item_cds-sugvalue
                sug_value_criticality      = ls_item_cds-sugvaluecriticality
                max_value                  = ls_item_cds-maxvalue
                max_value_criticality      = ls_item_cds-maxvaluecriticality
                currency                   = ls_item_cds-currency
                currency_criticality       = ls_item_cds-currencycriticality
                condition_record           = ls_item_cds-conditionrecord
                date_from                  = ls_item_cds-datefrom
                date_from_criticality      = ls_item_cds-datefromcriticality
                date_to                    = ls_item_cds-dateto
                date_to_criticality        = ls_item_cds-datetocriticality
                minimum                    = ls_item_cds-minimum
                minimum_criticality        = ls_item_cds-minimumcriticality
                minimum_perc               = ls_item_cds-minimumperc
                minimum_perc_criticality   = ls_item_cds-minimumperccriticality
                active_min_value           = ls_item_cds-activeminvalue
                active_sug_value           = ls_item_cds-activesugvalue
                active_max_value           = ls_item_cds-activemaxvalue
                active_currency            = ls_item_cds-activecurrency
                active_condition_record    = ls_item_cds-activeconditionrecord
                zzdelete                   = ls_item_cds-deleteitem
                created_by                 = ls_item_cds-createdby
                created_at                 = ls_item_cds-createdat
                last_changed_by            = ls_item_cds-lastchangedby
                last_changed_at            = ls_item_cds-lastchangedat
                local_last_changed_at      = ls_item_cds-locallastchangedat ) ).

    SORT et_item BY guid line.

* ---------------------------------------------------------------------------
* Converte dados de alerta mínimo
* ---------------------------------------------------------------------------
    et_minimum[] = VALUE #( BASE et_minimum FOR ls_minimum_cds IN it_minimum_cds (
                  mandt                      = sy-mandt
                  guid                       = ls_minimum_cds-guid
                  guid_line                  = ls_minimum_cds-guidline
                  line                       = ls_minimum_cds-line
                  line_criticality           = ls_minimum_cds-linecriticality
                  status                     = ls_minimum_cds-status
                  operation_type             = ls_minimum_cds-operationtype
                  dist_channel               = ls_minimum_cds-distchannel
                  dist_channel_criticality   = ls_minimum_cds-distchannelcriticality
                  material                   = ls_minimum_cds-material
                  material_criticality       = ls_minimum_cds-materialcriticality
                  plant                      = ls_minimum_cds-plant
                  plant_criticality          = ls_minimum_cds-plantcriticality
                  min_value                  = ls_minimum_cds-minvalue
                  min_value_criticality      = ls_minimum_cds-minvaluecriticality
                  currency                   = ls_minimum_cds-currency
                  currency_criticality       = ls_minimum_cds-currencycriticality
                  date_from                  = ls_minimum_cds-datefrom
                  date_from_criticality      = ls_minimum_cds-datefromcriticality
                  date_to                    = ls_minimum_cds-dateto
                  date_to_criticality        = ls_minimum_cds-datetocriticality
                  condition_record           = ls_minimum_cds-conditionrecord
                  created_by                 = ls_minimum_cds-createdby
                  created_at                 = ls_minimum_cds-createdat
                  last_changed_by            = ls_minimum_cds-lastchangedby
                  last_changed_at            = ls_minimum_cds-lastchangedat
                  local_last_changed_at      = ls_minimum_cds-locallastchangedat ) ).

    SORT et_minimum BY guid line.

* ---------------------------------------------------------------------------
* Converte dados de invasão
* ---------------------------------------------------------------------------
    et_invasion[] = VALUE #( BASE et_invasion FOR ls_invasion_cds IN it_invasion_cds (
                  mandt                      = sy-mandt
                  guid                       = ls_invasion_cds-guid
                  guid_line                  = ls_invasion_cds-guidline
                  line                       = ls_invasion_cds-line
                  line_criticality           = ls_invasion_cds-linecriticality
                  status                     = ls_invasion_cds-status
                  operation_type             = ls_invasion_cds-operationtype
                  "price_list                 = ls_invasion_cds-PriceList
                  "price_list_criticality     = ls_invasion_cds-PriceListCriticality
                  min_value                  = ls_invasion_cds-minvalue
                  min_value_criticality      = ls_invasion_cds-minvaluecriticality
                  currency                   = ls_invasion_cds-currency
                  currency_criticality       = ls_invasion_cds-currencycriticality
                  date_from                  = ls_invasion_cds-datefrom
                  date_from_criticality      = ls_invasion_cds-datefromcriticality
                  date_to                    = ls_invasion_cds-dateto
                  date_to_criticality        = ls_invasion_cds-datetocriticality
                  condition_record           = ls_invasion_cds-conditionrecord
                  kunnr                      = ls_invasion_cds-kunnr
                  zzdelete                   = ls_invasion_cds-deleteinv
                  created_by                 = ls_invasion_cds-createdby
                  created_at                 = ls_invasion_cds-createdat
                  last_changed_by            = ls_invasion_cds-lastchangedby
                  last_changed_at            = ls_invasion_cds-lastchangedat
                  local_last_changed_at      = ls_invasion_cds-locallastchangedat ) ).

    SORT et_invasion BY guid line.

  ENDMETHOD.


  METHOD convert_table_to_cds.

    FREE: es_header_cds, et_item_cds, et_minimum_cds, et_invasion_cds.

* ---------------------------------------------------------------------------
* Converte dados de cabeçalho
* ---------------------------------------------------------------------------
    IF is_header IS SUPPLIED.
      es_header_cds-guid                    = is_header-guid.
      es_header_cds-id                      = is_header-id.
      es_header_cds-status                  = is_header-status.
      es_header_cds-statuscriticality       = SWITCH #( is_header-status
                                              WHEN gc_status-rascunho        THEN gc_criticalidade-branco
                                              WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                                              WHEN gc_status-pendente               THEN gc_criticalidade-verde
                                              WHEN gc_status-erro           THEN gc_criticalidade-vermelho
                                              WHEN gc_status-aprovado       THEN gc_criticalidade-verde
                                              WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                                              WHEN gc_status-divergencia          THEN gc_criticalidade-vermelho ).
      es_header_cds-requestuser             = is_header-request_user.
*      es_header_cds-ApproveUser             = is_header-approve_user.
*      es_header_cds-ApproveUserCriticality  = is_header-approve_user_criticality.
*      es_header_cds-plant                   = is_header-plant.
*      es_header_cds-plantcriticality        = is_header-plant_criticality.
      es_header_cds-processdate             = is_header-process_date.
      es_header_cds-processtime             = is_header-process_time.
      es_header_cds-importtime              = is_header-import_time.
      es_header_cds-createdby               = is_header-created_by.
      es_header_cds-createdat               = is_header-created_at.
      es_header_cds-lastchangedby           = is_header-last_changed_by.
      es_header_cds-lastchangedat           = is_header-last_changed_at.
      es_header_cds-locallastchangedat      = is_header-local_last_changed_at.
    ENDIF.

* ---------------------------------------------------------------------------
* Converte dados de item
* ---------------------------------------------------------------------------
    et_item_cds[] = VALUE #( BASE et_item_cds FOR ls_item IN it_item (
                    guid                         = ls_item-guid
                    guidline                     = ls_item-guid_line
                    line                         = ls_item-line
                    linecriticality              = ls_item-line_criticality
                    status                       = ls_item-status
                    statuscriticality            = SWITCH #( ls_item-status
                                                   WHEN gc_status-rascunho        THEN gc_criticalidade-branco
                                                   WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                                                   WHEN gc_status-pendente               THEN gc_criticalidade-verde
                                                   WHEN gc_status-erro           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-aprovado       THEN gc_criticalidade-verde
                                                   WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-divergencia          THEN gc_criticalidade-vermelho )
                    operationtype                = ls_item-operation_type
                    operationtypecriticality     = SWITCH #( ls_item-operation_type+0(1)
                                                   WHEN gc_tipo_operacao-inclusao  THEN gc_criticalidade-verde
                                                   WHEN gc_tipo_operacao-alteracao THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-exclusao  THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-troca_umb THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-rebaixa   THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-aumento   THEN gc_criticalidade-verde    )
                    distchannel                  = ls_item-dist_channel
                    distchannelcriticality       = ls_item-dist_channel_criticality
                    pricelist                    = ls_item-price_list
                    pricelistcriticality         = ls_item-price_list_criticality
                    material                     = ls_item-material
                    materialcriticality          = ls_item-material_criticality
                    plant                        = ls_item-plant
                    plantcriticality             = ls_item-plant_criticality
                    scale                        = ls_item-scale
                    scalecriticality             = ls_item-scale_criticality
                    baseunit                     = ls_item-base_unit
                    baseunitcriticality          = ls_item-base_unit_criticality
                    minvalue                     = ls_item-min_value
                    minvaluecriticality          = ls_item-min_value_criticality
                    sugvalue                     = ls_item-sug_value
                    sugvaluecriticality          = ls_item-sug_value_criticality
                    maxvalue                     = ls_item-max_value
                    maxvaluecriticality          = ls_item-max_value_criticality
                    currency                     = ls_item-currency
                    currencycriticality          = ls_item-currency_criticality
                    conditionrecord              = ls_item-condition_record
                    datefrom                     = ls_item-date_from
                    datefromcriticality          = ls_item-date_from_criticality
                    dateto                       = ls_item-date_to
                    datetocriticality            = ls_item-date_to_criticality
                    minimum                      = ls_item-minimum
                    minimumcriticality           = ls_item-minimum_criticality
                    minimumperc                  = ls_item-minimum_perc
                    minimumperccriticality       = ls_item-minimum_perc_criticality
                    activeminvalue               = ls_item-active_min_value
                    activesugvalue               = ls_item-active_sug_value
                    activemaxvalue               = ls_item-active_max_value
                    activecurrency               = ls_item-active_currency
                    activeconditionrecord        = ls_item-active_condition_record
                    deleteitem                   = ls_item-zzdelete
                    createdby                    = ls_item-created_by
                    createdat                    = ls_item-created_at
                    lastchangedby                = ls_item-last_changed_by
                    lastchangedat                = ls_item-last_changed_at
                    locallastchangedat           = ls_item-local_last_changed_at ) ).

* ---------------------------------------------------------------------------
* Converte dados de alerta mínimo
* ---------------------------------------------------------------------------
    et_minimum_cds[] = VALUE #( BASE et_minimum_cds FOR ls_minimum IN it_minimum (
                    guid                         = ls_minimum-guid
                    guidline                     = ls_minimum-guid_line
                    line                         = ls_minimum-line
                    linecriticality              = ls_minimum-line_criticality
                    status                       = ls_minimum-status
                    statuscriticality            = SWITCH #( ls_minimum-status
                                                   WHEN gc_status-rascunho        THEN gc_criticalidade-branco
                                                   WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                                                   WHEN gc_status-pendente               THEN gc_criticalidade-verde
                                                   WHEN gc_status-erro           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-aprovado       THEN gc_criticalidade-verde
                                                   WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-divergencia          THEN gc_criticalidade-vermelho )
                    operationtype                = ls_minimum-operation_type
                    operationtypecriticality     = SWITCH #( ls_minimum-operation_type+0(1)
                                                   WHEN gc_tipo_operacao-inclusao  THEN gc_criticalidade-verde
                                                   WHEN gc_tipo_operacao-alteracao THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-exclusao  THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-troca_umb THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-rebaixa   THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-aumento   THEN gc_criticalidade-verde    )
                    distchannel                  = ls_minimum-dist_channel
                    distchannelcriticality       = ls_minimum-dist_channel_criticality
                    material                     = ls_minimum-material
                    materialcriticality          = ls_minimum-material_criticality
                    plant                        = ls_minimum-plant
                    plantcriticality             = ls_minimum-plant_criticality
                    minvalue                     = ls_minimum-min_value
                    minvaluecriticality          = ls_minimum-min_value_criticality
                    currency                     = ls_minimum-currency
                    currencycriticality          = ls_minimum-currency_criticality
                    datefrom                     = ls_minimum-date_from
                    datefromcriticality          = ls_minimum-date_from_criticality
                    dateto                       = ls_minimum-date_to
                    datetocriticality            = ls_minimum-date_to_criticality
                    conditionrecord              = ls_minimum-condition_record
                    createdby                    = ls_minimum-created_by
                    createdat                    = ls_minimum-created_at
                    lastchangedby                = ls_minimum-last_changed_by
                    lastchangedat                = ls_minimum-last_changed_at
                    locallastchangedat           = ls_minimum-local_last_changed_at ) ).


* ---------------------------------------------------------------------------
* Converte dados de alerta mínimo
* ---------------------------------------------------------------------------
    et_invasion_cds[] = VALUE #( BASE et_invasion_cds FOR ls_invasion IN it_invasion (
                    guid                         = ls_invasion-guid
                    guidline                     = ls_invasion-guid_line
                    line                         = ls_invasion-line
                    linecriticality              = ls_invasion-line_criticality
                    status                       = ls_invasion-status
                    statuscriticality            = SWITCH #( ls_invasion-status
                                                   WHEN gc_status-rascunho        THEN gc_criticalidade-branco
                                                   WHEN gc_status-em_processamento THEN gc_criticalidade-amarelo
                                                   WHEN gc_status-pendente               THEN gc_criticalidade-verde
                                                   WHEN gc_status-erro           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-aprovado       THEN gc_criticalidade-verde
                                                   WHEN gc_status-alerta           THEN gc_criticalidade-vermelho
                                                   WHEN gc_status-divergencia          THEN gc_criticalidade-vermelho )
                    operationtype                = ls_invasion-operation_type
                    operationtypecriticality     = SWITCH #( ls_invasion-operation_type+0(1)
                                                   WHEN gc_tipo_operacao-inclusao  THEN gc_criticalidade-verde
                                                   WHEN gc_tipo_operacao-alteracao THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-exclusao  THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-troca_umb THEN gc_criticalidade-amarelo
                                                   WHEN gc_tipo_operacao-rebaixa   THEN gc_criticalidade-vermelho
                                                   WHEN gc_tipo_operacao-aumento   THEN gc_criticalidade-verde    )
                    "PriceList                    = ls_invasion-price_list
                    "PriceListCriticality         = ls_invasion-price_list_criticality
                    minvalue                     = ls_invasion-min_value
                    minvaluecriticality          = ls_invasion-min_value_criticality
                    currency                     = ls_invasion-currency
                    currencycriticality          = ls_invasion-currency_criticality
                    datefrom                     = ls_invasion-date_from
                    datefromcriticality          = ls_invasion-date_from_criticality
                    dateto                       = ls_invasion-date_to
                    datetocriticality            = ls_invasion-date_to_criticality
                    conditionrecord              = ls_invasion-condition_record
                    kunnr                        = ls_invasion-kunnr
                    deleteinv                    = ls_invasion-zzdelete
                    createdby                    = ls_invasion-created_by
                    createdat                    = ls_invasion-created_at
                    lastchangedby                = ls_invasion-last_changed_by
                    lastchangedat                = ls_invasion-last_changed_at
                    locallastchangedat           = ls_invasion-local_last_changed_at ) ).

  ENDMETHOD.


  METHOD convert_validation_to_return.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
    et_return = VALUE #( BASE et_return FOR ls_validation IN it_validation (  CORRESPONDING #( ls_validation )  ) ).
    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD update_item_fields.

    TYPES: BEGIN OF ty_material_base,
             line     TYPE bapi_line,
             material TYPE matnr,
             umb      TYPE kmein,
           END OF ty_material_base.

    DATA lv_meinh TYPE marm-meinh.
    DATA: lv_min_value TYPE p DECIMALS 6,
          lv_sug_value TYPE p DECIMALS 6,
          lv_max_value TYPE p DECIMALS 6.

    DATA: lt_material_base TYPE TABLE OF ty_material_base.

    CHECK cs_header-status NE gc_status-aprovado.

    DATA(lt_a816_valid) = it_a816[].
    DATA(lt_a817_valid) = it_a817[].

    DELETE lt_a816_valid WHERE datbi < sy-datum.
    DELETE lt_a817_valid WHERE datbi < sy-datum.
* ---------------------------------------------------------------------------
* Atualiza condição atualmente ativa
* ---------------------------------------------------------------------------
    LOOP AT ct_item REFERENCE INTO DATA(ls_item) WHERE guid = cs_header-guid. "#EC CI_STDSEQ

      " Recupera condição A817 - CanalDistr/Lst.preços/Centro/Material
      READ TABLE lt_a817_valid INTO DATA(ls_a817) WITH TABLE KEY vtweg = ls_item->dist_channel
                                                                 pltyp = ls_item->price_list
                                                                 matnr = ls_item->material
                                                                 werks = ls_item->plant."cs_header-plant.
      IF sy-subrc NE 0.

        READ TABLE it_a817 INTO ls_a817 WITH TABLE KEY vtweg = ls_item->dist_channel
                                                       pltyp = ls_item->price_list
                                                       matnr = ls_item->material
                                                       werks = ls_item->plant."cs_header-plant.
        IF sy-subrc NE 0.
          CLEAR ls_a817.
        ENDIF.
      ENDIF.

      " Recupera condição A817
      READ TABLE it_konp INTO DATA(ls_konp_a817) WITH TABLE KEY knumh = ls_a817-knumh.

      IF sy-subrc NE 0.
        CLEAR ls_konp_a817.
      ENDIF.

      IF ls_konp_a817 IS NOT INITIAL.
        IF  ls_item->zzdelete = 'X' OR ls_item->zzdelete = 'x'.
          ls_item->operation_type  =  gc_tipo_operacao-exclusao_a817.
        ELSE.
          ls_item->operation_type  = gc_tipo_operacao-alteracao_a817.
        ENDIF.

        IF ls_item->base_unit NE ls_konp_a817-kmein.
          ls_item->operation_type  = gc_tipo_operacao-troca_umb_a817.

          APPEND VALUE #(  line     = ls_item->line
                           material = ls_item->material
                           umb      = ls_konp_a817-kmein ) TO lt_material_base.

        ENDIF.

        ls_item->active_min_value        = ls_konp_a817-mxwrt.
        ls_item->active_sug_value        = ls_konp_a817-kbetr.
        ls_item->active_max_value        = ls_konp_a817-gkwrt.
        ls_item->active_currency         = ls_konp_a817-konwa.
        ls_item->active_condition_record = ls_konp_a817-knumh.
        CONTINUE.
      ENDIF.

      " Recupera condição A816 - CanalDistr/Centro/Material
      IF ls_item->price_list IS INITIAL.
        READ TABLE lt_a816_valid INTO DATA(ls_a816) WITH TABLE KEY vtweg = ls_item->dist_channel
                                                                   matnr = ls_item->material
                                                                   werks = ls_item->plant."cs_header-plant.
        IF sy-subrc NE 0.
          READ TABLE it_a816 INTO ls_a816 WITH TABLE KEY vtweg = ls_item->dist_channel
                                                         matnr = ls_item->material
                                                         werks = ls_item->plant."cs_header-plant.
          IF sy-subrc NE 0.
            CLEAR ls_a816.
          ENDIF.
        ENDIF.
      ELSE.
        CLEAR ls_a816.
      ENDIF.

      " Recupera condição A816
      READ TABLE it_konp INTO DATA(ls_konp_a816) WITH TABLE KEY knumh = ls_a816-knumh.

      IF sy-subrc NE 0.
        CLEAR ls_konp_a816.
      ENDIF.

      IF ls_konp_a816 IS NOT INITIAL.
        IF  ls_item->zzdelete = 'X' OR ls_item->zzdelete = 'x'.
          ls_item->operation_type =  gc_tipo_operacao-exclusao_a816.
        ELSE.
          ls_item->operation_type = gc_tipo_operacao-alteracao_a816.
        ENDIF.

        IF ls_item->base_unit NE ls_konp_a816-kmein.
          ls_item->operation_type  = gc_tipo_operacao-troca_umb_a816.

          APPEND VALUE #(  line     = ls_item->line
                           material = ls_item->material
                           umb      = ls_konp_a816-kmein ) TO lt_material_base.


        ENDIF.

        ls_item->active_min_value        = ls_konp_a816-mxwrt.
        ls_item->active_sug_value        = ls_konp_a816-kbetr.
        ls_item->active_max_value        = ls_konp_a816-gkwrt.
        ls_item->active_currency         = ls_konp_a816-konwa.
        ls_item->active_condition_record = ls_konp_a816-knumh.
        CONTINUE.
      ENDIF.

      IF  ls_item->zzdelete = ' '.
        ls_item->operation_type            = COND #( WHEN ls_item->price_list IS NOT INITIAL
                                                     THEN gc_tipo_operacao-inclusao_a817
                                                     ELSE gc_tipo_operacao-inclusao_a816 ).
      ELSEIF ls_item->zzdelete = 'X' OR ls_item->zzdelete = 'x'.
        ls_item->operation_type            = COND #( WHEN ls_item->price_list IS NOT INITIAL
                                                     THEN gc_tipo_operacao-exclusao_a817
                                                     ELSE gc_tipo_operacao-exclusao_a816 ).
      ENDIF.

      CLEAR: ls_item->active_min_value,
             ls_item->active_sug_value,
             ls_item->active_max_value,
             ls_item->active_currency,
             ls_item->active_condition_record.

    ENDLOOP.

    IF gt_marm IS INITIAL.
      SELECT matnr, meinh, umrez, ean11
          FROM marm
          INTO TABLE @gt_marm
          FOR ALL ENTRIES IN @ct_item
          WHERE matnr EQ @ct_item-material
            AND meinh EQ @ct_item-base_unit
            AND ean11 NE @space.
    ENDIF.

    IF lt_material_base IS NOT INITIAL.
      SELECT matnr, meinh, umrez, ean11
      FROM marm
      INTO TABLE @DATA(lt_marm_base)
      FOR ALL ENTRIES IN @lt_material_base
      WHERE matnr EQ @lt_material_base-material
        AND meinh EQ @lt_material_base-umb
        AND ean11 NE @space.
      SORT lt_marm_base BY matnr meinh.
    ENDIF.

    SELECT matnr, meins
    FROM mara
    INTO TABLE @DATA(lt_mara)
    FOR ALL ENTRIES IN @ct_item
    WHERE matnr EQ @ct_item-material.
    SORT lt_mara BY matnr.

    SORT lt_material_base BY line material.
* ---------------------------------------------------------------------------
* Atualiza outros campos informativos
* ---------------------------------------------------------------------------
    SORT gt_marm BY matnr meinh.
    LOOP AT ct_item REFERENCE INTO ls_item WHERE guid = cs_header-guid. "#EC CI_STDSEQ

      " Recupera avaliação do material
      READ TABLE it_mbew INTO DATA(ls_mbew) WITH TABLE KEY matnr = ls_item->material
                                                           bwkey = ls_item->plant."cs_header-plant.
      IF sy-subrc NE 0.
        CLEAR ls_mbew.
      ENDIF.

      " Recupera condição A626 - Canal Distribuição/Centro/Material
      READ TABLE it_a626 INTO DATA(ls_a626) WITH TABLE KEY vtweg = ls_item->dist_channel
                                                           werks = ls_item->plant "cs_header-plant.
                                                           matnr = ls_item->material.
      IF sy-subrc NE 0.
        CLEAR ls_a626.
      ENDIF.

      " Recupera condição A626
      READ TABLE it_konp INTO DATA(ls_konp_a626) WITH TABLE KEY knumh = ls_a626-knumh.

      IF sy-subrc NE 0.
        CLEAR ls_konp_a626.
      ENDIF.

      READ TABLE gt_marm INTO DATA(ls_marm) WITH KEY matnr = ls_item->material
                                                     meinh = ls_item->base_unit BINARY SEARCH.

      IF sy-subrc NE 0.
        ls_item->minimum      = ls_konp_a626-kbetr.
      ELSE.
        ls_item->minimum      = ls_konp_a626-kbetr * ls_marm-umrez.

        IF ls_item->operation_type(1)  = gc_tipo_operacao-troca_umb.

          READ TABLE lt_material_base  INTO DATA(ls_base) WITH KEY line = ls_item->line
                                                               material = ls_item->material BINARY SEARCH.
          IF sy-subrc EQ 0.
            READ TABLE lt_mara INTO DATA(ls_mara) WITH KEY matnr = ls_item->material BINARY SEARCH.
            "Se a UMB do S4 for igual da UMB Base do material, converte o valor para a unidade do arquivo
            IF sy-subrc EQ 0 AND ls_base-umb = ls_mara-meins.
              ls_item->active_min_value        = ls_item->active_min_value * ls_marm-umrez.
              ls_item->active_sug_value        = ls_item->active_sug_value * ls_marm-umrez.
              ls_item->active_max_value        = ls_item->active_max_value * ls_marm-umrez.
            ELSEIF  ls_base-umb <> ls_mara-meins.

              READ TABLE lt_marm_base INTO DATA(ls_marm_base) WITH KEY matnr = ls_base-material
                                                                       meinh = ls_base-umb BINARY SEARCH.

              IF sy-subrc EQ 0.
                "Se a UMB do arquivo for deferente da UMB Base do material, converte o valor para a unidade do arquivo
                IF ls_mara-meins <> ls_marm-meinh.
                  lv_min_value                     = ls_item->active_min_value / ls_marm_base-umrez.
                  lv_sug_value                     = ls_item->active_sug_value / ls_marm_base-umrez.
                  lv_max_value                     = ls_item->active_max_value / ls_marm_base-umrez.

                  ls_item->active_min_value        = lv_min_value * ls_marm-umrez.
                  ls_item->active_sug_value        = lv_sug_value * ls_marm-umrez.
                  ls_item->active_max_value        = lv_max_value * ls_marm-umrez.
                ELSE.
                  "Se a UMB do S4 for deferente da UMB Base do material, converte o valor para a unidade base
                  ls_item->active_min_value        = ls_item->active_min_value / ls_marm_base-umrez.
                  ls_item->active_sug_value        = ls_item->active_sug_value / ls_marm_base-umrez.
                  ls_item->active_max_value        = ls_item->active_max_value / ls_marm_base-umrez.
                ENDIF.

              ENDIF.

            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.

      ls_item->minimum_perc = COND #( WHEN ls_item->minimum IS NOT INITIAL
                                      THEN ( ( ls_item->min_value / ls_item->minimum ) - 1 ) * 100
                                      ELSE 0 ).
      ls_item->minimum_perc_criticality = COND #( WHEN ls_item->minimum_perc <= 0
                                                  THEN 1
                                                  ELSE 3 ).


      ls_item->min_value_perc = COND #( WHEN ls_item->active_min_value IS NOT INITIAL
                                  THEN ( ( ls_item->min_value / ls_item->active_min_value ) - 1 ) * 100
                                  ELSE 0 ).

      ls_item->min_value_perc_criticality = COND #( WHEN ls_item->min_value_perc < 0
                                                    THEN 1
                                                    WHEN ls_item->min_value_perc > 0
                                                    THEN 3
                                                    ELSE 0 ).

      ls_item->max_value_perc = COND #( WHEN ls_item->active_max_value IS NOT INITIAL
                              THEN ( ( ls_item->max_value / ls_item->active_max_value ) - 1 ) * 100
                              ELSE 0 ).

      ls_item->max_value_perc_criticality = COND #( WHEN ls_item->max_value_perc < 0
                                                    THEN 1
                                                    WHEN ls_item->max_value_perc > 0
                                                    THEN 3
                                                    ELSE 0 ).

      ls_item->sug_value_perc = COND #( WHEN ls_item->active_sug_value IS NOT INITIAL
                                  THEN ( ( ls_item->sug_value / ls_item->active_sug_value ) - 1 ) * 100
                                  ELSE 0 ).

      ls_item->sug_value_perc_criticality = COND #( WHEN ls_item->sug_value_perc < 0
                                                    THEN 1
                                                    WHEN ls_item->sug_value_perc > 0
                                                    THEN 3
                                                    ELSE 0 ).



      IF ls_item->operation_type(1)  NE gc_tipo_operacao-inclusao.

      " Tipo Operação Exclusão
        IF  ls_item->zzdelete = 'X' OR ls_item->zzdelete = 'x'.
          ls_item->operation_type  =  gc_tipo_operacao-exclusao_a817.
        ELSE.

      " Tipo Operação Aumento
          IF ls_item->min_value > ls_item->active_min_value.
            IF ls_item->operation_type+2(3) = gc_tipo_operacao-aumento_a817+2(3).
              ls_item->operation_type  = gc_tipo_operacao-aumento_a817.
            ELSE.
              ls_item->operation_type  = gc_tipo_operacao-aumento_a816.
            ENDIF.
          ELSEIF ls_item->sug_value > ls_item->active_sug_value.
            IF ls_item->operation_type+2(3) = gc_tipo_operacao-aumento_a817+2(3).
              ls_item->operation_type  = gc_tipo_operacao-aumento_a817.
            ELSE.
              ls_item->operation_type  = gc_tipo_operacao-aumento_a816.
            ENDIF.
          ENDIF.


          " Tipo Operação Rebaixa
          IF ls_item->min_value < ls_item->active_min_value.
            IF ls_item->operation_type+2(3) = gc_tipo_operacao-rebaixa_a817+2(3).
              ls_item->operation_type  = gc_tipo_operacao-rebaixa_a817.
            ELSE.
              ls_item->operation_type  = gc_tipo_operacao-rebaixa_a816.
            ENDIF.
          ELSEIF ls_item->sug_value < ls_item->active_sug_value.
            IF ls_item->operation_type+2(3) = gc_tipo_operacao-rebaixa_a817+2(3).
              ls_item->operation_type  = gc_tipo_operacao-rebaixa_a817.
            ELSE.
              ls_item->operation_type  = gc_tipo_operacao-rebaixa_a816.
            ENDIF.
          ENDIF.

        ENDIF.

      ENDIF.



    ENDLOOP.

  ENDMETHOD.


  METHOD update_minimum_fields.

    CHECK cs_header-status NE gc_status-aprovado.

* ---------------------------------------------------------------------------
* Atualiza condição atualmente ativa
* ---------------------------------------------------------------------------
    LOOP AT ct_minimum REFERENCE INTO DATA(ls_minimum) WHERE guid = cs_header-guid. "#EC CI_STDSEQ

      " Recupera condição A626 - Canal/Centro/Material
      READ TABLE it_a626 INTO DATA(ls_a626) WITH TABLE KEY vtweg = ls_minimum->dist_channel
                                                           werks = ls_minimum->plant "cs_header-plant.
                                                           matnr = ls_minimum->material.
      IF sy-subrc NE 0.
        CLEAR ls_a626.
      ENDIF.

      " Recupera condição A817
      READ TABLE it_konp INTO DATA(ls_konp_a626) WITH TABLE KEY knumh = ls_a626-knumh.

      IF sy-subrc NE 0.
        CLEAR ls_konp_a626.
      ENDIF.

      IF ls_konp_a626 IS NOT INITIAL.
        ls_minimum->operation_type          = gc_tipo_operacao-alteracao_a626.
        CONTINUE.
      ENDIF.

      ls_minimum->operation_type            = gc_tipo_operacao-inclusao_a626.

    ENDLOOP.

  ENDMETHOD.


  METHOD update_invasion_fields.
    CHECK cs_header-status NE gc_status-aprovado.

* ---------------------------------------------------------------------------
* Atualiza condição atualmente ativa
* ---------------------------------------------------------------------------
    LOOP AT ct_invasion REFERENCE INTO DATA(ls_invasion) WHERE guid = cs_header-guid. "#EC CI_STDSEQ

      " Recupera condição A627
      TRY.
          DATA(ls_a627) = it_a627[ kunnr = ls_invasion->kunnr ].
        CATCH cx_root.
      ENDTRY.

      " Recupera condição A817
      READ TABLE it_konp INTO DATA(ls_konp_a627) WITH TABLE KEY knumh = ls_a627-knumh.

      IF sy-subrc NE 0.
        CLEAR ls_konp_a627.
      ENDIF.

      IF ls_konp_a627 IS NOT INITIAL.
        IF  ls_invasion->zzdelete = 'X' OR ls_invasion->zzdelete = 'x'.
          ls_invasion->operation_type =  gc_tipo_operacao-exclusao_a627.
        ELSE.
          ls_invasion->operation_type = gc_tipo_operacao-alteracao_a627.
        ENDIF.
        CONTINUE.
      ENDIF.

      IF  ls_invasion->zzdelete = ' '.
        ls_invasion->operation_type = gc_tipo_operacao-inclusao_a627.
      ELSEIF  ls_invasion->zzdelete = 'X' OR ls_invasion->zzdelete = 'x'.
        ls_invasion->operation_type =  gc_tipo_operacao-exclusao_a627.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD create_price_condition.

    DATA: lt_bapicondct  TYPE STANDARD TABLE OF bapicondct,
          lt_bapicondhd  TYPE STANDARD TABLE OF bapicondhd,
          lt_bapicondit  TYPE STANDARD TABLE OF bapicondit,
          lt_bapicondqs  TYPE STANDARD TABLE OF bapicondqs,
          lt_bapicondvs  TYPE STANDARD TABLE OF bapicondvs,
          lt_bapiknumhs  TYPE STANDARD TABLE OF bapiknumhs,
          lt_mem_initial TYPE STANDARD TABLE OF cnd_mem_initial,
          lt_item_qs     TYPE ty_t_item,
          ls_bapicondct  TYPE bapicondct,
          ls_bapicondhd  TYPE bapicondhd,
          ls_bapicondit  TYPE bapicondit,
          ls_bapicondqs  TYPE bapicondqs,
          ls_bapicondvs  TYPE bapicondvs,
          ls_bapiknumhs  TYPE bapiknumhs,
          ls_mem_initial TYPE cnd_mem_initial.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Agrupa informações
* ---------------------------------------------------------------------------
    DATA(lt_item)     = ct_item[].
    DATA(lt_item_key) = ct_item[].

    CASE cs_header-condition_type.

      WHEN me->gs_parameter-kschl_zpr0.
        " Agrupa linhas por Canal de distribuição, Lista de preço, Centro, Material
        SORT lt_item_key BY dist_channel price_list plant material line.
        DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING dist_channel price_list plant material.

      WHEN me->gs_parameter-kschl_zvmc.
        " Agrupa linhas por Canal de distribuição,Centro, Material
        lt_item_key[] = lt_item[] = VALUE #( FOR ls_min IN ct_minimum ( CORRESPONDING #( ls_min ) ) ).
        SORT lt_item_key BY  dist_channel plant material line.
        DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING dist_channel plant material.

      WHEN me->gs_parameter-kschl_zalt.
        " Agrupa linhas por Cliente.
        DATA(lt_invasion) = ct_invasion.
        SORT lt_invasion BY kunnr line.
        DELETE ADJACENT DUPLICATES FROM lt_invasion COMPARING kunnr.
        lt_item_key[] = lt_item[] = VALUE #( FOR ls_inv IN lt_invasion ( CORRESPONDING #( ls_inv ) ) ).


    ENDCASE.

    DELETE lt_item_key WHERE status NE gc_status-validado AND status NE gc_status-alerta AND zzdelete NE 'X' AND zzdelete NE 'x'. "#EC CI_STDSEQ
    DELETE lt_item WHERE status NE gc_status-validado AND status NE gc_status-alerta AND zzdelete NE 'X' AND zzdelete NE 'x'. "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Prepara informações da BAPI
* ---------------------------------------------------------------------------
    LOOP AT lt_item_key INTO DATA(ls_item_key).    "#EC CI_LOOP_INTO_WA

      FREE: lt_bapicondct,
            lt_bapicondhd,
            lt_bapicondit,
            lt_bapicondqs,
            lt_bapicondvs,
            lt_bapiknumhs,
            gs_delete,
            gv_inclusao,
            lt_mem_initial.


** ---------------------------------------------------------------------------
** Verifica se há alteração de vigência ou período da lista de preço e atualiza
** ---------------------------------------------------------------------------
      IF cs_header-condition_type =  me->gs_parameter-kschl_zpr0.
        check_data_sap_file( it_a817 = it_a817
                             it_a816 = it_a816
                             it_konp = it_konp
                             is_item_key = ls_item_key ).

        IF gv_vigencia EQ abap_true OR gv_periodo EQ abap_true.
          update_data( EXPORTING is_item_key = ls_item_key it_item = lt_item IMPORTING et_return = DATA(lt_return) ).
          APPEND ls_item_key TO lt_item_qs.
        ENDIF.
      ENDIF.

** ---------------------------------------------------------------------------
** Verifica se há mudança de UMB
** ---------------------------------------------------------------------------
*      IF ls_item_key-base_unit IS NOT INITIAL.
*        TRY.
*            DATA(lv_kmein) = convert_umb( EXPORTING is_item_key = ls_item_key ).
*            TRY.
*                DATA(lv_cond)   = it_a817[ vtweg = ls_item_key-dist_channel
*                                           pltyp = ls_item_key-price_list
*                                           werks = ls_item_key-plant
*                                           matnr = ls_item_key-material ]-knumh.
*
*              CATCH cx_root.
*                lv_cond = it_a816[ vtweg = ls_item_key-dist_channel
*                                   werks = ls_item_key-plant
*                                   matnr = ls_item_key-material ]-knumh.
*
*            ENDTRY.
*
*            DATA(ls_konp) = it_konp[ knumh = lv_cond
*                                     kmein = lv_kmein ].
*          CATCH cx_root.
*
*
*            update_data( EXPORTING is_item_key = ls_item_key IMPORTING et_return = DATA(lt_return) ).
*
*            APPEND ls_item_key TO lt_item_qs.
*
*        ENDTRY.
*      ENDIF.

* ---------------------------------------------------------------------------
* Verifica se não há mudança de UMB, segue processamento normalmente
* ---------------------------------------------------------------------------
      IF lt_return IS INITIAL.
        me->get_price_configuration( EXPORTING is_header     = cs_header
                                               is_item       = ls_item_key
                                               it_a817       = it_a817
                                               it_a816       = it_a816
                                               it_a627       = it_a627
                                               it_a626       = it_a626
                                               it_invasion   = ct_invasion
                                               it_item       = lt_item
                                     IMPORTING es_bapiconfig = DATA(ls_bapiconfig)
                                               et_item_qs    = lt_item_qs ).

        CLEAR ls_bapicondct.
        ls_bapicondct-operation   = ls_bapiconfig-operation.
        ls_bapicondct-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondct-cond_usage  = ls_bapiconfig-cond_usage.
        ls_bapicondct-table_no    = ls_bapiconfig-table_no.
        ls_bapicondct-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondct-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondct-varkey      = ls_bapiconfig-varkey.
        ls_bapicondct-valid_to    = ls_item_key-date_to.
        ls_bapicondct-valid_from  = ls_item_key-date_from.
        APPEND ls_bapicondct TO lt_bapicondct[].

        CLEAR ls_bapicondhd.
        ls_bapicondhd-operation   = ls_bapiconfig-operation.
        ls_bapicondhd-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondhd-cond_usage  = ls_bapiconfig-cond_usage.
        ls_bapicondhd-table_no    = ls_bapiconfig-table_no.
        ls_bapicondhd-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondhd-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondhd-varkey      = ls_bapiconfig-varkey.
        ls_bapicondhd-created_by  = sy-uname.
        ls_bapicondhd-creat_date  = sy-datum.
        ls_bapicondhd-valid_to    = ls_item_key-date_to.
        ls_bapicondhd-valid_from  = ls_item_key-date_from.
        APPEND ls_bapicondhd TO lt_bapicondhd[].


        CLEAR ls_bapicondit.
        ls_bapicondit-operation   = ls_bapiconfig-operation.
        ls_bapicondit-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondit-cond_count  = 1.
        ls_bapicondit-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondit-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondit-scaletype   = gc_tipo_escala-escala_inicial.
        ls_bapicondit-calctypcon  = gc_regra_calc_cond-quantidade.
        IF ls_bapiconfig-table_no ='626'.
          ls_bapicondit-cond_value  = ls_item_key-min_value.
        ELSE.
          ls_bapicondit-cond_value  = ls_item_key-sug_value.
        ENDIF.
        ls_bapicondit-condcurr    = ls_item_key-currency.
        ls_bapicondit-cond_p_unt  = 1.
        ls_bapicondit-cond_unit   = ls_item_key-base_unit.
        ls_bapicondit-lowerlimit  = ls_item_key-min_value.
        ls_bapicondit-upperlimit  = ls_item_key-max_value.
        IF lines( lt_item_qs ) > 1.
          ls_bapicondit-scalebasin  = 'C'.
        ENDIF.
        APPEND ls_bapicondit TO lt_bapicondit[].

        DATA(lv_index) = 0.

        LOOP AT lt_item_qs[] INTO DATA(ls_item_qs). "#EC CI_LOOP_INTO_WA #EC CI_STDSEQ #EC CI_NESTED
          CLEAR ls_bapicondqs.
          ls_bapicondqs-operation   = ls_bapiconfig-operation.
          ls_bapicondqs-cond_no     = ls_bapiconfig-cond_no.
          ls_bapicondqs-cond_count  = 1.
          ls_bapicondqs-line_no     = lv_index = lv_index + 1.
          ls_bapicondqs-scale_qty   = ls_item_qs-scale.
          ls_bapicondqs-cond_unit   = ls_item_qs-base_unit.
          ls_bapicondqs-currency    = ls_item_qs-sug_value.
          ls_bapicondqs-condcurr  = ls_item_qs-currency.
          APPEND ls_bapicondqs TO lt_bapicondqs[].
        ENDLOOP.

* ---------------------------------------------------------------------------
* Chama BAPI de criação de preço
* ---------------------------------------------------------------------------
        FREE: gt_messages, gv_wait_async.

        CALL FUNCTION 'ZFMSD_BAPI_PRICES_CONDITIONS'
          STARTING NEW TASK 'BAPI_PRICES_CONDITIONS'
          CALLING setup_messages ON END OF TASK
          EXPORTING
            it_bapicondct  = lt_bapicondct
            it_bapicondhd  = lt_bapicondhd
            it_bapicondit  = lt_bapicondit
            it_bapicondqs  = lt_bapicondqs
            it_bapicondvs  = lt_bapicondvs
            it_bapiknumhs  = lt_bapiknumhs
            it_mem_initial = lt_mem_initial
            iv_cond_no     = ls_bapiconfig-cond_no.

        WAIT UNTIL gv_wait_async = abap_true.
        lt_return = gt_messages.
        CLEAR gv_wait_async.

      ENDIF.

      IF lt_return[] IS INITIAL.
        " Linha &1: Nenhuma operação realizada, revisar lançamento da BAPI.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '031' message_v1 = ls_item_key-line ) ).
        CONTINUE.
      ENDIF.

      TRY.
          " Mensagem de sucesso
          DATA(lv_knumh) = CONV knumh( lt_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ
        CATCH cx_root.
          INSERT LINES OF lt_return[] INTO TABLE et_return[].
          CONTINUE.
      ENDTRY.

      " Linha &1: Condição &2 criada com sucesso.
      et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '032'
                                            row        = ls_item_key-line
                                            message_v1 = ls_item_key-line
                                            message_v2 = lv_knumh ) ).

* ---------------------------------------------------------------------------
* Atualiza tabela com a condição criada
* ---------------------------------------------------------------------------
      LOOP AT lt_item_qs INTO ls_item_qs. "#EC CI_LOOP_INTO_WA #EC CI_STDSEQ #EC CI_NESTED

        READ TABLE ct_item REFERENCE INTO DATA(ls_item) WITH KEY guid = ls_item_qs-guid
                                                                 line = ls_item_qs-line. "#EC CI_STDSEQ #EC CI_NESTED
        IF sy-subrc EQ 0.
          ls_item->status           = gc_status-aprovado.
          ls_item->condition_record = lv_knumh.
        ENDIF.

        READ TABLE ct_minimum REFERENCE INTO DATA(ls_minimum) WITH KEY guid = ls_item_qs-guid
                                                                       line = ls_item_qs-line. "#EC CI_STDSEQ
        IF sy-subrc EQ 0.
          ls_minimum->status           = gc_status-aprovado.
          ls_minimum->condition_record = lv_knumh.
        ENDIF.

        READ TABLE ct_invasion REFERENCE INTO DATA(ls_invasion) WITH KEY guid = ls_item_qs-guid
                                                                         line = ls_item_qs-line. "#EC CI_STDSEQ
        IF sy-subrc EQ 0.
          ls_invasion->status           = gc_status-aprovado.
          ls_invasion->condition_record = lv_knumh.
        ENDIF.

      ENDLOOP.

      CLEAR lt_return.
    ENDLOOP.


* ---------------------------------------------------------------------------
* Atualiza status do cabeçalho
* ---------------------------------------------------------------------------
    IF ( ct_item[] IS NOT INITIAL AND NOT line_exists( ct_item[ status = gc_status-aprovado ] ) )
    OR ( ct_minimum[] IS NOT INITIAL AND NOT line_exists( ct_minimum[ status = gc_status-aprovado ] ) )
    OR ( ct_invasion[] IS NOT INITIAL AND NOT line_exists( ct_invasion[ status = gc_status-aprovado ] ) ). "#EC CI_STDSEQ
      cs_header-status           = cs_header-status.
    ELSE.
      cs_header-status           = gc_status-aprovado.
    ENDIF.

    me->format_return( CHANGING ct_return = et_return ).

  ENDMETHOD.


  METHOD check_data_sap_file.

    DATA lt_a817 TYPE ty_t_a817.
    DATA lt_a816 TYPE ty_t_a816.

    CLEAR:gv_vigencia, gv_periodo.

    lt_a817  = VALUE #( FOR ls_a817 IN it_a817  WHERE ( vtweg = is_item_key-dist_channel
                                                   AND  pltyp = is_item_key-price_list
                                                   AND  werks = is_item_key-plant
                                                   AND  matnr = is_item_key-material )
                                                      ( CORRESPONDING #( ls_a817 ) ) ).

    IF lt_a817 IS INITIAL.
      lt_a816 = VALUE #( FOR ls_a816 IN it_a816  WHERE ( vtweg = is_item_key-dist_channel
                                                    AND  werks = is_item_key-plant
                                                    AND  matnr = is_item_key-material )
                                                       ( CORRESPONDING #( ls_a816 ) ) ).
    ENDIF.

    TRY.

        DATA(ls_data) = lt_a817[ vtweg = is_item_key-dist_channel
                                 pltyp = is_item_key-price_list
                                 werks = is_item_key-plant
                                 matnr = is_item_key-material ].


        IF ls_data-datab = ls_data-datbi.
          gv_inclusao =  abap_true.
          EXIT.
        ELSE.
          TRY.
              DATA(ls_konp_a817) = it_konp[ knumh = ls_data-knumh loevm_ko = 'X' ].
              gv_inclusao =  abap_true.
              EXIT.
            CATCH cx_root.
          ENDTRY.
        ENDIF.

      CATCH cx_root.

        TRY.

            ls_data = lt_a816[ vtweg = is_item_key-dist_channel
                               werks = is_item_key-plant
                               matnr = is_item_key-material ].

            IF ls_data-datab = ls_data-datbi.
              gv_inclusao =  abap_true.
              EXIT.
            ELSE.
              TRY.
                  DATA(ls_konp_a816) = it_konp[ knumh = ls_data-knumh loevm_ko = 'X' ].
                  gv_inclusao =  abap_true.
                  EXIT.
                CATCH cx_root.
              ENDTRY.
            ENDIF.

          CATCH cx_root.
            CLEAR: ls_data.
        ENDTRY.

    ENDTRY.

*    IF ( lines( lt_a817 ) > 1 OR lines( lt_a816 ) > 1 ) AND is_item_key-date_to <> '99991231'.
    IF is_item_key-date_to <> '99991231'.
      gv_periodo =  abap_true.
    ELSE.
      IF ls_data  IS NOT INITIAL.
        IF is_item_key-date_to >= ls_data-datbi
        OR is_item_key-date_from >= ls_data-datab.
          gv_vigencia = abap_true.
        ELSEIF is_item_key-date_to <= ls_data-datbi.
          gv_periodo =  abap_true.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_price_configuration.

    FREE: es_bapiconfig, et_item_qs.

    CASE is_header-condition_type.

* ---------------------------------------------------------------------------
* Configuração para A817
* ---------------------------------------------------------------------------
      WHEN me->gs_parameter-kschl_zpr0.

        IF is_item-price_list IS NOT INITIAL.

          IF gv_inclusao NE abap_true.
            TRY.
                es_bapiconfig-cond_no   = it_a817[ vtweg = is_item-dist_channel
                                                   pltyp = is_item-price_list
                                                   werks = is_item-plant "is_header-plant
                                                   matnr = is_item-material ]-knumh.
                es_bapiconfig-operation = gc_operacao-modificar.

              CATCH cx_root.

*              es_bapiconfig-cond_no   = gc_preco-cond_no.
                get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
                es_bapiconfig-operation = gc_operacao-original.

            ENDTRY.
          ELSE.
            get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
            es_bapiconfig-operation = gc_operacao-original.
          ENDIF.

          es_bapiconfig-cond_usage = is_item-operation_type+1(1).
          es_bapiconfig-table_no   = is_item-operation_type+2(3).
          es_bapiconfig-cond_type  = me->gs_parameter-kschl_zpr0.
          es_bapiconfig-varkey     = is_item-dist_channel && is_item-price_list && is_item-plant && is_item-material.
          et_item_qs[]             = VALUE #( FOR ls_it IN it_item WHERE (     guid         EQ is_item-guid
                                                                          AND dist_channel EQ is_item-dist_channel
                                                                          AND price_list   EQ is_item-price_list
                                                                          AND material     EQ is_item-material )
                                                                          ( CORRESPONDING #( ls_it ) )   ). "#EC CI_STDSEQ


* ---------------------------------------------------------------------------
* Configuração para A816
* ---------------------------------------------------------------------------
        ELSE.
          IF gv_inclusao NE abap_true.
            TRY.
                es_bapiconfig-cond_no   = it_a816[ vtweg = is_item-dist_channel
                                                   werks = is_item-plant "is_header-plant
                                                   matnr = is_item-material ]-knumh.
                es_bapiconfig-operation = gc_operacao-modificar.

              CATCH cx_root.
*              es_bapiconfig-cond_no   = gc_preco-cond_no.
                get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
                es_bapiconfig-operation = gc_operacao-original.

            ENDTRY.
          ELSE.
            get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
            es_bapiconfig-operation = gc_operacao-original.
          ENDIF.

          es_bapiconfig-cond_usage = is_item-operation_type+1(1).
          es_bapiconfig-table_no   = is_item-operation_type+2(3).
          es_bapiconfig-cond_type  = me->gs_parameter-kschl_zpr0.
          es_bapiconfig-varkey     = is_item-dist_channel && is_item-plant && is_item-material.
          et_item_qs[]             = VALUE #( FOR ls_it IN it_item WHERE (    guid         EQ is_item-guid
                                                                          AND dist_channel EQ is_item-dist_channel
                                                                          AND price_list   EQ space
                                                                          AND material     EQ is_item-material )
                                                                          ( CORRESPONDING #( ls_it ) ) ). "#EC CI_STDSEQ


        ENDIF.

* ---------------------------------------------------------------------------
* Configuração para A626
* ---------------------------------------------------------------------------
      WHEN me->gs_parameter-kschl_zvmc.

        IF gv_inclusao NE abap_true.
          TRY.
              es_bapiconfig-cond_no   = it_a626[ vtweg = is_item-dist_channel
                                                 werks = is_item-plant "is_header-plant
                                                 matnr = is_item-material ]-knumh.
              es_bapiconfig-operation = gc_operacao-modificar.

            CATCH cx_root.
*              es_bapiconfig-cond_no   = gc_preco-cond_no.
              get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
              es_bapiconfig-operation = gc_operacao-original.

          ENDTRY.
        ELSE.
          get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
          es_bapiconfig-operation = gc_operacao-original.
        ENDIF.

        es_bapiconfig-cond_usage = is_item-operation_type+1(1).
        es_bapiconfig-table_no   = is_item-operation_type+2(3).
        es_bapiconfig-cond_type  = me->gs_parameter-kschl_zvmc.
        es_bapiconfig-valid_to   = is_item-date_to.
        es_bapiconfig-varkey     = is_item-dist_channel && is_item-plant && is_item-material.
        et_item_qs[]             = VALUE #( FOR ls_it IN it_item WHERE (        guid     EQ is_item-guid
                                                                        AND dist_channel EQ is_item-dist_channel
                                                                        AND plant        EQ is_item-plant
                                                                        AND material     EQ is_item-material )
                                                                        ( CORRESPONDING #( ls_it ) ) ). "#EC CI_STDSEQ



* ---------------------------------------------------------------------------
* Configuração para a627
* ---------------------------------------------------------------------------
      WHEN me->gs_parameter-kschl_zalt.

        IF gv_inclusao NE abap_true.
          TRY.
              es_bapiconfig-varkey = it_invasion[ guid = is_item-guid
                                                  guid_line = is_item-guid_line ]-kunnr.

            CATCH cx_root.
          ENDTRY.

          TRY.

              es_bapiconfig-cond_no   = it_a627[ kunnr = es_bapiconfig-varkey ]-knumh.
              es_bapiconfig-operation = gc_operacao-modificar.
            CATCH cx_root.
*              es_bapiconfig-cond_no   = gc_preco-cond_no.
              get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
              es_bapiconfig-operation = gc_operacao-original.

          ENDTRY.
        ELSE.
          get_cond_no( CHANGING cs_bapiconfig = es_bapiconfig ).
          es_bapiconfig-operation = gc_operacao-original.
        ENDIF.

        es_bapiconfig-cond_usage = is_item-operation_type+1(1).
        es_bapiconfig-table_no   = is_item-operation_type+2(3).
        es_bapiconfig-cond_type  = me->gs_parameter-kschl_zalt.
        et_item_qs[]             = VALUE #( FOR ls_invasion IN it_invasion WHERE (   guid       EQ is_item-guid
                                                                                  AND kunnr     EQ es_bapiconfig-varkey  )
                                                                                 ( CORRESPONDING #( ls_invasion ) ) ). "#EC CI_STDSEQ

    ENDCASE.

    SORT et_item_qs BY guid line.

  ENDMETHOD.


  METHOD get_cond_no.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING
        nr_range_nr             = '01'
        object                  = 'KONH'
        ignore_buffer           = 'X'
      IMPORTING
        number                  = cs_bapiconfig-cond_no
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
      cs_bapiconfig-cond_no   = gc_preco-cond_no.
    ENDIF.

    CALL FUNCTION 'ENQUEUE_E_KONH_KKS'
      EXPORTING
        mode_konh_kks  = 'E'
        knumh          = cs_bapiconfig-cond_no
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.
    IF sy-subrc <> 0.
      cs_bapiconfig-cond_no   = gc_preco-cond_no.
    ENDIF.

  ENDMETHOD.


  METHOD call_bapi_prices_conditions.

    FREE: et_return.
    DATA lt_nriv TYPE nriv_tt.

    DATA(lt_bapicondct)  = it_bapicondct.
    DATA(lt_bapicondhd)  = it_bapicondhd.
    DATA(lt_bapicondit)  = it_bapicondit.
    DATA(lt_bapicondqs)  = it_bapicondqs.
    DATA(lt_bapicondvs)  = it_bapicondvs.
    DATA(lt_bapiknumhs)  = it_bapiknumhs.
    DATA(lt_mem_initial) = it_mem_initial.

    CALL FUNCTION 'BAPI_PRICES_CONDITIONS'
*      EXPORTING
*        pi_initialmode       = ' '
*        pi_blocknumber       =
*        pi_physical_deletion =
      TABLES
        ti_bapicondct  = lt_bapicondct[]
        ti_bapicondhd  = lt_bapicondhd[]
        ti_bapicondit  = lt_bapicondit[]
        ti_bapicondqs  = lt_bapicondqs[]
        ti_bapicondvs  = lt_bapicondvs[]
        to_bapiret2    = et_return[]
        to_bapiknumhs  = lt_bapiknumhs[]
        to_mem_initial = lt_mem_initial[]
      EXCEPTIONS
        update_error   = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      et_return = VALUE #( BASE et_return ( id         = sy-msgid
                                            type       = sy-msgty
                                            number     = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
    ENDIF.

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      APPEND VALUE #(
        client    = sy-mandt
        object    = 'KONH'
        nrrangenr = '01'
        nrlevel   = iv_cond_no ) TO lt_nriv.

      "Atualiza o Range de Numeração
      CALL FUNCTION 'CNV_RN_ADJUST_NRIV'
        TABLES
          it_nriv          = lt_nriv
        EXCEPTIONS
          no_authorization = 1
          OTHERS           = 2.
      IF sy-subrc <> 0.
        CLEAR lt_nriv.
      ENDIF.


      CALL FUNCTION 'DEQUEUE_E_KONH_KKS'
        EXPORTING
          mode_konh_kks = 'E'
          knumh         = iv_cond_no.

      update_log_bdcp2( et_return ).
    ENDIF.


  ENDMETHOD.


  METHOD update_log_bdcp2.

    CONSTANTS: lc_tabname TYPE bdi_chptr-tabname VALUE 'KONPAE',
               lc_fldname TYPE bdi_chptr-fldname VALUE 'KBETR',
               lc_cdchgid TYPE bdi_chptr-cdchgid VALUE 'U',
               lc_cond_a  TYPE edidc-mestyp      VALUE 'COND_A'.

    DATA  lt_cp_data TYPE TABLE OF bdi_chptr.

    TRY.

        DATA(lv_knumh) = CONV knumh( it_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ

        APPEND VALUE #( tabname = lc_tabname
                        fldname = lc_fldname
                        cdobjcl = lc_cond_a
                        cdobjid = lv_knumh
                        cdchgid = lc_cdchgid    ) TO lt_cp_data.

        CALL FUNCTION 'CHANGE_POINTERS_CREATE_DIRECT'
          EXPORTING
            message_type          = lc_cond_a
          TABLES
            t_cp_data             = lt_cp_data
          EXCEPTIONS
            number_range_problems = 1
            OTHERS                = 2.

        IF sy-subrc <> 0.
          CLEAR lt_cp_data.
        ENDIF.

      CATCH cx_root.
    ENDTRY.

  ENDMETHOD.


  METHOD data_calculation.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = iv_data
        days      = 01
        months    = 00
        signum    = iv_sinal
        years     = 00
      IMPORTING
        calc_date = rv_data.

  ENDMETHOD.


  METHOD  setup_messages.

    CASE p_task.

      WHEN 'BAPI_PRICES_CONDITIONS'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMSD_BAPI_PRICES_CONDITIONS'
            IMPORTING
                et_messages = gt_messages.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD determine_line.

* ---------------------------------------------------------------------------
* Recupera última linha
* ---------------------------------------------------------------------------
    DATA(lv_item_line)      = REDUCE i( INIT lv_line TYPE i FOR ls_itm IN ct_item
                                        NEXT lv_line = COND #( WHEN ls_itm-line > lv_line
                                                               THEN ls_itm-line
                                                               ELSE lv_line ) ).

    DATA(lv_minimum_line)   = REDUCE i( INIT lv_line TYPE i FOR ls_min IN ct_minimum
                                        NEXT lv_line = COND #( WHEN ls_min-line > lv_line
                                                               THEN ls_min-line
                                                               ELSE lv_line ) ).

    DATA(lv_invasion_line)  = REDUCE i( INIT lv_line TYPE i FOR ls_inv IN ct_invasion
                                        NEXT lv_line = COND #( WHEN ls_inv-line > lv_line
                                                               THEN ls_inv-line
                                                               ELSE lv_line ) ).

* ---------------------------------------------------------------------------
* Atualiza campos linha em branco
* ---------------------------------------------------------------------------
    LOOP AT ct_item REFERENCE INTO DATA(ls_item).
      CHECK ls_item->line IS INITIAL.
      ls_item->line = lv_item_line = lv_item_line + 1.
    ENDLOOP.

    LOOP AT ct_minimum REFERENCE INTO DATA(ls_minimum).
      CHECK ls_minimum->line IS INITIAL.
      ls_minimum->line = lv_minimum_line = lv_minimum_line + 1.
    ENDLOOP.

    LOOP AT ct_invasion REFERENCE INTO DATA(ls_invasion).
      CHECK ls_invasion->line IS INITIAL.
      ls_invasion->line = lv_invasion_line = lv_invasion_line + 1.
    ENDLOOP.

  ENDMETHOD.


  METHOD cancel_request.

* ---------------------------------------------------------------------------
* Valida dados
* ---------------------------------------------------------------------------
    me->validate_info( EXPORTING iv_msgty      = 'E'
                       IMPORTING et_validation = DATA(lt_validation)
                       CHANGING  cs_header     = cs_header ).


    me->convert_validation_to_return( EXPORTING it_validation = lt_validation
                                      IMPORTING et_return     = et_return ).

* ---------------------------------------------------------------------------
* Recupera dados para lançamento
* ---------------------------------------------------------------------------
    me->get_info( EXPORTING is_header   = cs_header
                            it_item     = ct_item
                            it_minimum  = ct_minimum
                            it_invasion = ct_invasion
                  IMPORTING et_a817     = DATA(lt_a817)
                            et_a816     = DATA(lt_a816)
                            et_a627     = DATA(lt_a627)
                            et_a626     = DATA(lt_a626)
                            et_knvv     = DATA(lt_knvv)
                            et_konp     = DATA(lt_konp) ).


* ---------------------------------------------------------------------------
* Chama BAPI para lançar registros de condição de uso de preço
* ---------------------------------------------------------------------------
    me->delete_price_condition( EXPORTING it_a817        = lt_a817
                                          it_a816        = lt_a816
                                          it_a627        = lt_a627
                                          it_a626        = lt_a626
                                          it_konp        = lt_konp
                                IMPORTING et_return      = DATA(lt_return)
                                CHANGING  cs_header      = cs_header
                                          ct_item        = ct_item
                                          ct_minimum     = ct_minimum
                                          ct_invasion    = ct_invasion ).

    INSERT LINES OF lt_return INTO TABLE et_return[].

  ENDMETHOD.


  METHOD delete_price_condition.

    DATA: lt_bapicondct  TYPE STANDARD TABLE OF bapicondct,
          lt_bapicondhd  TYPE STANDARD TABLE OF bapicondhd,
          lt_bapicondit  TYPE STANDARD TABLE OF bapicondit,
          lt_bapicondqs  TYPE STANDARD TABLE OF bapicondqs,
          lt_bapicondvs  TYPE STANDARD TABLE OF bapicondvs,
          lt_bapiknumhs  TYPE STANDARD TABLE OF bapiknumhs,
          lt_mem_initial TYPE STANDARD TABLE OF cnd_mem_initial,

          ls_bapicondct  TYPE bapicondct,
          ls_bapicondhd  TYPE bapicondhd,
          ls_bapicondit  TYPE bapicondit,
          ls_bapicondqs  TYPE bapicondqs,
          ls_bapicondvs  TYPE bapicondvs,
          ls_bapiknumhs  TYPE bapiknumhs,
          ls_mem_initial TYPE cnd_mem_initial.

    FREE: et_return.

* ---------------------------------------------------------------------------
* Agrupa informações
* ---------------------------------------------------------------------------
    DATA(lt_item)     = ct_item[].
    DATA(lt_item_key) = ct_item[].

    CASE cs_header-condition_type.

      WHEN me->gs_parameter-kschl_zpr0.
        " Agrupa linhas por Canal de distribuição, Lista de preço, Centro, Material
        SORT lt_item_key BY dist_channel price_list material line.
        DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING dist_channel price_list material.

      WHEN me->gs_parameter-kschl_zvmc.
        " Agrupa linhas por Centro, Material
        lt_item_key[] = lt_item[] = VALUE #( FOR ls_min IN ct_minimum ( CORRESPONDING #( ls_min ) ) ).
        SORT lt_item_key BY  plant material line.
        DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING  plant material.

      WHEN me->gs_parameter-kschl_zalt.
        " Agrupa linhas por Centro, Lista de preço
        lt_item_key[] = lt_item[] = VALUE #( FOR ls_inv IN ct_invasion ( CORRESPONDING #( ls_inv ) ) ).
        SORT lt_item_key BY price_list line.
        DELETE ADJACENT DUPLICATES FROM lt_item_key COMPARING price_list.

    ENDCASE.

    DELETE lt_item_key WHERE status NE gc_status-validado AND status NE gc_status-alerta. "#EC CI_STDSEQ
    DELETE lt_item WHERE status NE gc_status-validado AND status NE gc_status-alerta. "#EC CI_STDSEQ

* ---------------------------------------------------------------------------
* Prepara informações da BAPI
* ---------------------------------------------------------------------------
    LOOP AT lt_item_key INTO DATA(ls_item_key).    "#EC CI_LOOP_INTO_WA

      FREE: lt_bapicondct,
            lt_bapicondhd,
            lt_bapicondit,
            lt_bapicondqs,
            lt_bapicondvs,
            lt_bapiknumhs,
            gs_delete,
            lt_mem_initial.

      me->get_price_configuration( EXPORTING is_header     = cs_header
                                             is_item       = ls_item_key
                                             it_a817       = it_a817
                                             it_a816       = it_a816
                                             it_a627       = it_a627
                                             it_a626       = it_a626
                                             it_item       = lt_item
                                   IMPORTING es_bapiconfig = DATA(ls_bapiconfig)
                                             et_item_qs    = DATA(lt_item_qs) ).

      IF lt_item_qs[] IS NOT INITIAL AND ls_bapiconfig IS NOT INITIAL.


        CLEAR ls_bapicondct.
        ls_bapicondct-operation   = gc_operacao-eliminar.
        ls_bapicondct-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondct-cond_usage  = ls_bapiconfig-cond_usage.
        ls_bapicondct-table_no    = ls_bapiconfig-table_no.
        ls_bapicondct-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondct-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondct-varkey      = ls_bapiconfig-varkey.
        ls_bapicondct-valid_to    = ls_item_key-date_to.
        ls_bapicondct-valid_from  = ls_item_key-date_from.
        APPEND ls_bapicondct TO lt_bapicondct[].

        CLEAR ls_bapicondhd.
        ls_bapicondhd-operation   = gc_operacao-eliminar.
        ls_bapicondhd-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondhd-cond_usage  = ls_bapiconfig-cond_usage.
        ls_bapicondhd-table_no    = ls_bapiconfig-table_no.
        ls_bapicondhd-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondhd-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondhd-varkey      = ls_bapiconfig-varkey.
        ls_bapicondhd-created_by  = sy-uname.
        ls_bapicondhd-creat_date  = sy-datum.
        ls_bapicondhd-valid_to    = ls_item_key-date_to.
        ls_bapicondhd-valid_from  = ls_item_key-date_from.
        APPEND ls_bapicondhd TO lt_bapicondhd[].

        CLEAR ls_bapicondit.
        ls_bapicondit-operation   = gc_operacao-eliminar.
        ls_bapicondit-cond_no     = ls_bapiconfig-cond_no.
        ls_bapicondit-cond_count  = 1.
        ls_bapicondit-applicatio  = gc_preco-aplicacao_sd.
        ls_bapicondit-cond_type   = ls_bapiconfig-cond_type.
        ls_bapicondit-scaletype   = gc_tipo_escala-escala_inicial.
        ls_bapicondit-calctypcon  = gc_regra_calc_cond-quantidade.
        ls_bapicondit-cond_value  = ls_item_key-sug_value.
        ls_bapicondit-condcurr    = ls_item_key-currency.
        ls_bapicondit-cond_p_unt  = 1.
        ls_bapicondit-cond_unit   = ls_item_key-base_unit.
        ls_bapicondit-lowerlimit  = ls_item_key-min_value.
        ls_bapicondit-upperlimit  = ls_item_key-max_value.
        ls_bapicondit-indidelete  = 'X'.
        APPEND ls_bapicondit TO lt_bapicondit[].

        DATA(lv_index) = 0.

        LOOP AT lt_item_qs[] INTO DATA(ls_item_qs). "#EC CI_LOOP_INTO_WA #EC CI_STDSEQ #EC CI_NESTED
          CLEAR ls_bapicondqs.
          ls_bapicondqs-operation   = gc_operacao-eliminar.
          ls_bapicondqs-cond_no     = ls_bapiconfig-cond_no.
          ls_bapicondqs-cond_count  = 1.
          ls_bapicondqs-line_no     = lv_index = lv_index + 1.
          ls_bapicondqs-scale_qty   = ls_item_qs-scale.
          ls_bapicondqs-cond_unit   = ls_item_qs-base_unit.
          ls_bapicondqs-currency    = ls_item_qs-sug_value.
          ls_bapicondqs-condcurr    = ls_item_qs-currency.
          APPEND ls_bapicondqs TO lt_bapicondqs[].
        ENDLOOP.

* ---------------------------------------------------------------------------
* Chama BAPI de criação/exclusão de preço
* ---------------------------------------------------------------------------
        FREE: gt_messages, gv_wait_async.

        CALL FUNCTION 'ZFMSD_BAPI_PRICES_CONDITIONS'
          STARTING NEW TASK 'BAPI_PRICES_CONDITIONS'
          CALLING setup_messages ON END OF TASK
          EXPORTING
            it_bapicondct  = lt_bapicondct
            it_bapicondhd  = lt_bapicondhd
            it_bapicondit  = lt_bapicondit
            it_bapicondqs  = lt_bapicondqs
            it_bapicondvs  = lt_bapicondvs
            it_bapiknumhs  = lt_bapiknumhs
            it_mem_initial = lt_mem_initial
            iv_cond_no     = ls_bapiconfig-cond_no.

        WAIT UNTIL gv_wait_async = abap_true.
        DATA(lt_return) = gt_messages.
        CLEAR gv_wait_async.

        IF lt_return[] IS INITIAL.
          " Linha &1: Nenhuma operação realizada, revisar lançamento da BAPI.
          et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '031' message_v1 = ls_item_key-line ) ).
          CONTINUE.
        ENDIF.

        TRY.
            " Mensagem de sucesso
            DATA(lv_knumh) = CONV knumh( lt_return[ type   = 'S' id = 'CND_EXCHANGE' ]-message_v1 ). "#EC CI_STDSEQ
          CATCH cx_root.
            INSERT LINES OF lt_return[] INTO TABLE et_return[].
            CONTINUE.
        ENDTRY.

        " Linha &1: Condição &2 excluída com sucesso.
        et_return = VALUE #( BASE et_return ( type = 'S' id = 'ZSD_GESTAO_PRECOS' number = '040'
                                              message_v1 = ls_item_key-line
                                              message_v2 = lv_knumh ) ).
      ELSE.
        " Linha &1:Registro não exite na tabela &2.
        et_return = VALUE #( BASE et_return ( type = 'E' id = 'ZSD_GESTAO_PRECOS' number = '046'
                                              message_v1 = ls_item_key-line ) ).
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD status_request.

* ---------------------------------------------------------------------------
* Converte CDS para tabela
* ---------------------------------------------------------------------------
    me->convert_cds_to_table( EXPORTING is_header_cds   = is_header_cds
                                        it_item_cds     = it_item_cds
                                        it_minimum_cds  = it_minimum_cds
                                        it_invasion_cds = it_invasion_cds
                              IMPORTING es_header       = DATA(ls_header)
                                        et_item         = DATA(lt_item)
                                        et_minimum      = DATA(lt_minimum)
                                        et_invasion     = DATA(lt_invasion) ).

*    IF ( ls_header-status EQ gc_status-validado OR ls_header-status EQ gc_status-alerta OR ls_header-status EQ gc_status-reprovado )
*    AND iv_status EQ gc_status-eliminado.
*
*      me->cancel_request(
*        EXPORTING
*          is_header   = ls_header
*          it_item     = lt_item
*          it_minimum  = lt_minimum
*          it_invasion = lt_invasion
*        IMPORTING
*          et_return   = et_return
*      ).
*
*    ENDIF.

    IF ls_header-status EQ gc_status-validado OR ls_header-status EQ gc_status-alerta
    OR ls_header-status EQ gc_status-reprovado OR ls_header-status EQ gc_status-erro OR gs_modify = abap_true.
      IF ls_header IS NOT INITIAL.
        ls_header-status = iv_status.
      ENDIF.

      LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WHERE guid EQ ls_header-guid.
        <fs_item>-status = iv_status.
      ENDLOOP.

      LOOP AT lt_minimum ASSIGNING FIELD-SYMBOL(<fs_minimum>) WHERE guid EQ ls_header-guid.
        <fs_minimum>-status = iv_status.
      ENDLOOP.

      LOOP AT lt_invasion ASSIGNING FIELD-SYMBOL(<fs_invasion>) WHERE guid EQ ls_header-guid.
        <fs_invasion>-status = iv_status.
      ENDLOOP.


      me->convert_table_to_cds( EXPORTING is_header       = ls_header
                                          it_item         = lt_item
                                          it_minimum      = lt_minimum
                                          it_invasion     = lt_invasion
                                IMPORTING es_header_cds   = es_header_cds
                                          et_item_cds     = et_item_cds
                                          et_minimum_cds  = et_minimum_cds
                                          et_invasion_cds = et_invasion_cds ).

* ---------------------------------------------------------------------------
* Salvar dados
* ---------------------------------------------------------------------------
      me->save_file( EXPORTING iv_level    = iv_level
                               is_header   = ls_header
                               it_item     = lt_item
                               it_minimum  = lt_minimum
                               it_invasion = lt_invasion ).
    ENDIF.

  ENDMETHOD.


  METHOD compare_data_get_status.

    SELECT SINGLE *
    FROM ztsd_preco_h
    WHERE guid = @cs_header-guid
    INTO @DATA(ls_header).

    SELECT *
    FROM ztsd_preco_i
    FOR ALL ENTRIES IN @ct_item
    WHERE guid = @ct_item-guid
    AND guid_line = @ct_item-guid_line
    INTO TABLE @DATA(lt_item).

    SELECT *
    FROM ztsd_preco_m
    FOR ALL ENTRIES IN @ct_minimum
    WHERE guid = @ct_minimum-guid
    AND guid_line = @ct_minimum-guid_line
    INTO TABLE @DATA(lt_minimo).

    SELECT *
    FROM ztsd_preco_inv
    FOR ALL ENTRIES IN @ct_invasion
    WHERE guid = @ct_invasion-guid
    AND guid_line = @ct_invasion-guid_line
    INTO TABLE @DATA(lt_invasao).

    IF cs_header IS NOT INITIAL AND ls_header IS NOT INITIAL AND cs_header NE ls_header.
      cv_status_new = gc_status-pendente.
    ELSEIF ct_item[] IS NOT INITIAL AND lt_item[] IS NOT INITIAL AND ct_item[] NE lt_item[].
      cv_status_new = gc_status-pendente.
    ELSEIF ct_minimum[] IS NOT INITIAL AND lt_minimo[] IS NOT INITIAL AND ct_minimum[] NE lt_minimo[].
      cv_status_new = gc_status-pendente.
    ELSEIF ct_invasion[] IS NOT INITIAL AND lt_invasao[] IS NOT INITIAL AND ct_invasion[] NE lt_invasao[].
      cv_status_new = gc_status-pendente.
    ENDIF.

    IF cv_status_new = gc_status-pendente.
      cs_header-status = gc_status-pendente.
      LOOP AT ct_item ASSIGNING FIELD-SYMBOL(<fs_item>).
        <fs_item>-status = gc_status-pendente.
      ENDLOOP.

      LOOP AT ct_minimum ASSIGNING FIELD-SYMBOL(<fs_minimum>).
        <fs_minimum>-status = gc_status-pendente.
      ENDLOOP.

      LOOP AT ct_invasion ASSIGNING FIELD-SYMBOL(<fs_invasion>).
        <fs_invasion>-status = gc_status-pendente.
      ENDLOOP.
    ENDIF.

    me->update_field_criticality( CHANGING  cs_data     = cs_header ).
    me->update_field_criticality( CHANGING  cs_data     = ct_item ).
    me->update_field_criticality( CHANGING  cs_data     = ct_minimum ).
    me->update_field_criticality( CHANGING  cs_data     = ct_invasion ).

  ENDMETHOD.


  METHOD update_data.
    DATA: ls_record  TYPE zi_sd_lista_de_preco.
    DATA: ls_newitem TYPE zi_sd_lista_de_preco.
    DATA: lt_new_scale TYPE ty_t_item .
    DATA: lt_old_scale TYPE ty_t_item .


    SELECT  *
      FROM zi_sd_lista_de_preco
         WHERE kappl    EQ @gc_preco-aplicacao_sd
           AND kschl    EQ @gs_parameter-kschl_zpr0
           AND vtweg    EQ @is_item_key-dist_channel
           AND pltyp    EQ @is_item_key-price_list
           AND werks    EQ @is_item_key-plant
           AND matnr    EQ @is_item_key-material
           AND datbi    >= @is_item_key-date_to
           AND datab    <= @is_item_key-date_from
           INTO TABLE @DATA(lt_lista_preco_del).

    IF gv_vigencia EQ abap_true.
      SELECT  *
        FROM zi_sd_lista_de_preco
           WHERE kappl    EQ @gc_preco-aplicacao_sd
             AND kschl    EQ @gs_parameter-kschl_zpr0
             AND vtweg    EQ @is_item_key-dist_channel
             AND pltyp    EQ @is_item_key-price_list
             AND werks    EQ @is_item_key-plant
             AND matnr    EQ @is_item_key-material
             AND ( datbi    <= @is_item_key-date_to
             OR datab     <= @is_item_key-date_from )
           INTO TABLE @lt_lista_preco_del.
    ENDIF.

    SORT lt_lista_preco_del DESCENDING BY vtweg pltyp werks matnr kopos datbi.

    READ TABLE lt_lista_preco_del ASSIGNING FIELD-SYMBOL(<fs_lista>) WITH KEY  vtweg = is_item_key-dist_channel
                                                                               pltyp = is_item_key-price_list
                                                                               werks = is_item_key-plant
                                                                               matnr = is_item_key-material
                                                                               kopos = 0 BINARY SEARCH.

    IF <fs_lista> IS NOT ASSIGNED.
      READ TABLE lt_lista_preco_del ASSIGNING <fs_lista> WITH KEY  vtweg = is_item_key-dist_channel
                                                                   pltyp = is_item_key-price_list
                                                                   werks = is_item_key-plant
                                                                   matnr = is_item_key-material
                                                                   kopos = 1 BINARY SEARCH.
    ENDIF.

    IF <fs_lista> IS ASSIGNED.

      ls_record  = CORRESPONDING #( <fs_lista>  ).
      ls_newitem = CORRESPONDING #( <fs_lista>  ).

*      ls_newitem-knumh  = ls_newitem-knumh + '1'.
*      ls_newitem-knumh  = |{ ls_newitem-knumh ALPHA = IN  }|.
      ls_newitem-vtweg  = is_item_key-dist_channel.
      ls_newitem-pltyp  = is_item_key-price_list.
      ls_newitem-werks  = is_item_key-plant.
      ls_newitem-matnr  = is_item_key-material.
      ls_newitem-datab  = is_item_key-date_from.
      ls_newitem-datbi  = is_item_key-date_to.
      ls_newitem-konwa  = is_item_key-currency.
      ls_newitem-kbetr  = is_item_key-sug_value.
      ls_newitem-mxwrt  = is_item_key-min_value.
      ls_newitem-gkwrt  = is_item_key-max_value.
      ls_newitem-kmein  = is_item_key-base_unit.
      ls_newitem-kstbm  = is_item_key-scale.

      lt_new_scale = VALUE #( FOR ls_it IN it_item WHERE (  guid         EQ is_item_key-guid
                                                      AND   dist_channel EQ is_item_key-dist_channel
                                                      AND   price_list   EQ is_item_key-price_list
                                                      AND   plant        EQ is_item_key-plant
                                                      AND   material     EQ is_item_key-material )
                                                                 ( CORRESPONDING #( ls_it ) )   ).


      LOOP AT lt_lista_preco_del ASSIGNING FIELD-SYMBOL(<fs_lp>) FROM sy-tabix.

        IF <fs_lp>-vtweg  = is_item_key-dist_channel
       AND <fs_lp>-pltyp  = is_item_key-price_list
       AND <fs_lp>-werks  = is_item_key-plant
       AND <fs_lp>-matnr  = is_item_key-material
       AND <fs_lp>-datab <= is_item_key-date_from
       AND <fs_lp>-datbi >= is_item_key-date_to.

          APPEND  VALUE #(   scale     = <fs_lp>-kstbm
                             base_unit = <fs_lp>-kmein
                             sug_value = <fs_lp>-kbetr
                             currency  = <fs_lp>-konwa
                             line      = <fs_lp>-klfn1 ) TO lt_old_scale.
        ELSE.
          EXIT.
        ENDIF.
      ENDLOOP.

      CALL FUNCTION 'ZFMSD_GESTAO_PRECO_EXCLUSAO'
        STARTING NEW TASK 'EXCLUSAO'
        CALLING atuali_messages ON END OF TASK
        EXPORTING
          iv_data_in         = is_item_key-date_from
          iv_data_fim        = is_item_key-date_to
          iv_op_type         = is_item_key-operation_type
          is_record          = ls_record
          is_newitem         = ls_newitem
          iv_altera_vigencia = gv_vigencia
          iv_altera_periodo  = gv_periodo
        TABLES
          it_new_scale       = lt_new_scale
          it_old_scale       = lt_old_scale.

      WAIT UNTIL gv_wait_async = abap_true.
      et_return = gt_messages.
      CLEAR gv_wait_async.

    ENDIF.

  ENDMETHOD.


  METHOD convert_umb.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
      EXPORTING
        input          = is_item_key-base_unit
        language       = sy-langu
      IMPORTING
        output         = rv_kmein
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      rv_kmein = is_item_key-base_unit.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
