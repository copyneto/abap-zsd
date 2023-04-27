CLASS zclsd_ionz_criar_ov DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "! Types referência data para select options
      BEGIN OF ty_refdata,
        id TYPE REF TO data,
      END OF ty_refdata .

    "!  Parâmetro de retorno BAPI
    DATA gt_message     TYPE bapiret2_tab.
    "!  Parâmetro de retorno BAPI Auxiliar
    DATA gt_message_aux     TYPE bapiret2_tab.

    DATA:
          "! Tabela referência data para select options
          gs_refdata TYPE ty_refdata .

    "! Método principal que inicia a execução do programa
    METHODS executar.
    "!Seleciona clientes que não foram processados
    METHODS seleciona_dados.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:
      "! Constantes
      BEGIN OF gc_constante,
        cc_id     TYPE char2             VALUE 'ID',
        cc_0      TYPE c                 VALUE '0',
        cc_e      TYPE c                 VALUE '3',
        cc_i      TYPE c                 VALUE 'I',
        cc_n      TYPE c                 VALUE 'N',
        cc_s      TYPE c                 VALUE '2',
        cc_x      TYPE c                 VALUE 'X',
        cc_motivo TYPE char3             VALUE 'Z01',
      END OF gc_constante.

    CONSTANTS:
      "! Constantes para tabela de parâmetros Nome JOB
      BEGIN OF gc_parametros_job,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'NOME_JOB',
      END OF gc_parametros_job.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ AG
      BEGIN OF gc_parametros_ag,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_AG',
      END OF gc_parametros_ag.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ AUART
      BEGIN OF gc_parametros_auart,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_AUART',
      END OF gc_parametros_auart.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ PLANT_SPO
      BEGIN OF gc_parametros_plant_spo,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_PLANT_SPO',
      END OF gc_parametros_plant_spo.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ PLANT_SPST
      BEGIN OF gc_parametros_plant_spst,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_PLANT_SPST',
      END OF gc_parametros_plant_spst.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ SPART
      BEGIN OF gc_parametros_spart,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_SPART',
      END OF gc_parametros_spart.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ VKORG_SPO
      BEGIN OF gc_parametros_vkorg_spo,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_VKORG_SPO',
      END OF gc_parametros_vkorg_spo.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ VKORG_SPST
      BEGIN OF gc_parametros_vkorg_spst,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_VKORG_SPST',
      END OF gc_parametros_vkorg_spst.

    CONSTANTS:
      "! Constantes para tabela de parâmetros OV IONZ VTWEG
      BEGIN OF gc_parametros_vtweg,
        modulo TYPE ze_param_modulo VALUE 'SD',
        chave1 TYPE ztca_param_par-chave1 VALUE 'IONZ',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CC_VTWEG',
      END OF gc_parametros_vtweg.

    TYPES:
      "! Types para select options
      BEGIN OF ty_selopt,
        id TYPE RANGE OF ztsd_sint_proces-id,
      END OF ty_selopt.

    "! Tabela para select options
    DATA gs_selopt TYPE ty_selopt.
    "! Incremento do nº item de documentos SD
    DATA gs_incpo  TYPE tvak-incpo.
    "! Tipo de documento de vendas
    DATA gs_auart  TYPE RANGE OF tvak-auart.
    "! Canal de distribuição
    DATA gs_vtweg  TYPE RANGE OF vbak-vtweg.
    "! Centro
    DATA gs_plant_spst  TYPE RANGE OF bapisditm-plant.
    "! Setor de atividade
    DATA gs_spart  TYPE RANGE OF vbak-spart.
    "! Organização de vendas
    DATA gs_vkorg_spst TYPE RANGE OF bapisdhd1-sales_org.
    "! Função do parceiro
    DATA gs_partn_role TYPE RANGE OF bapiparnr-partn_role.
    "!Nome de um job em background
    DATA gs_nome_job TYPE RANGE OF tbtco-jobname.
    "! Código Modelo Máquina
    DATA gs_modelo TYPE ztsd_sint_proces-codigo.
    "! Centro
    DATA gs_plant  TYPE bapisditm-plant.
    "! Campos de comunicação: cabeçalho doc.SD
    DATA gs_header  TYPE bapisdhd1.
    "! Campos de seleção cabeçalho doc.SD
    DATA gs_headerx TYPE bapisdhd1x.
    "! Cadastro WEB - SAP
    DATA gt_zionz TYPE SORTED TABLE OF ztsd_sint_proces WITH NON-UNIQUE KEY id.
    "! Material para Campanha Promocional
    DATA gt_material TYPE SORTED TABLE OF ztsd_mat_promo WITH NON-UNIQUE KEY modelo.
    "! Tabela Campos de comunicação: item doc.SD
    DATA gt_item          TYPE TABLE OF bapisditm.
    "! Tabela Campos de comunicação: item doc.SD
    DATA gt_itemx         TYPE TABLE OF bapisditmx.
    "! Tabela Campos de comunicação para atualizar uma divisão de doc.SD
    DATA gt_schedules_in  TYPE TABLE OF bapischdl.
    "! Tabela Barra de seleção p/a atualização de uma divisão rem.doc.SD
    DATA gt_schedules_inx TYPE TABLE OF bapischdlx.
    "! Tabela Campos de comunicação: parceiro doc.SD: WWW
    DATA gt_partner     TYPE TABLE OF bapiparnr.
    "! Tabela Campos de comunicação: parceiro doc.SD: Auxiliar
    DATA gt_partner_aux TYPE TABLE OF bapiparnr.
    "!  Parâmetro de retorno BAPI
    DATA gt_return      TYPE TABLE OF bapiret2.
    "! Documento de vendas
    DATA gs_vbeln TYPE vbeln_va.

    "!Método trata select options
    METHODS trata_select_options.

    "! Seleciona dados da tabela ZIONZ
    METHODS seleciona_dados_zionz.

    "!Seleciona material para gravar nos itens
    METHODS seleciona_dados_material.

    "! Processa Mensagens
    "! @parameter iv_msg  |Tipo e numero mensagem
    "! @parameter iv_text | Texto Mensagem
    METHODS processa_msg
      IMPORTING
        iv_msg  TYPE string
        iv_text TYPE char255.

    "!Selecionar incremento do nº item no documento de venda/distribuição
    METHODS seleciona_dados_tvak.

    "! Obtém os valores dos parâmetros da Tabela de Parâmetros e os retorna em RANGE
    "! @parameter iv_modulo | Módulo cadastrado
    "! @parameter iv_chave1 | Chave1 cadastrado
    "! @parameter iv_chave2 | Chave2 cadastrado
    "! @parameter et_range  | Valores dos parâmetros
    METHODS get_param
      IMPORTING
                iv_modulo TYPE ztca_param_par-modulo
                iv_chave1 TYPE ztca_param_par-chave1
                iv_chave2 TYPE ztca_param_par-chave2
      EXPORTING et_range  TYPE table.

    "! Seleciona Tipo de documento de vendas
    "! @parameter rv_auart | Tipo de documento de vendas
    METHODS seleciona_tipo_ov
      RETURNING
        VALUE(rv_auart) TYPE tvak-auart.

    "! Verifica se já tem um Job em execução
    METHODS verifica_job_execucao.

    "! Processar dados e executrar a bapi
    METHODS processa_dados.

    "! Bapi - dados de cabeçalho - dados fixos do cabeçalho
    METHODS header_fixo.

    "! Seleciona Canal de distribuição
    "! @parameter rv_vtweg | Canal de distribuição
    METHODS seleciona_canal_distribuicao
      RETURNING
        VALUE(rv_vtweg) TYPE vbak-vtweg.

    "! Seleciona Setor de atividade
    "! @parameter rv_spart | Setor de atividade
    METHODS seleciona_setor_atividade
      RETURNING
        VALUE(rv_spart) TYPE vbak-spart.

    "! Seleciona  Organização de vendas
    "! @parameter rv_sales_org |  Organização de vendas
    METHODS seleciona_org_vendas
      RETURNING
        VALUE(rv_sales_org) TYPE bapisdhd1-sales_org.

    "! Seleciona Centro
    "! @parameter rv_plant | Centro
    METHODS seleciona_centro
      RETURNING
        VALUE(rv_plant) TYPE bapisditm-plant.

    "! bapi - dados do item e schedules
    METHODS item_schedules
      RETURNING VALUE(rv_erro) TYPE char1.

    "! Elimina os registros da tabela de log erros
    "! @parameter iv_id | ID
    METHODS delete_log
      IMPORTING iv_id TYPE ztsd_ionzlogerro-id.

    "! bapi - dados de cabeçalho - dados variáveis
    "! @parameter iv_id | ID
    METHODS header_variavel
      IMPORTING iv_id TYPE ztsd_ionzlogerro-id.

    "! Converte texto referência do pedido
    "! @parameter iv_id       | ID
    "! @parameter ev_id_alpha | ID Alpha
    METHODS converte_alpha
      IMPORTING
        iv_id       TYPE ztsd_sint_proces-id
      EXPORTING
        ev_id_alpha TYPE ztsd_sint_proces-id.

    "! bapi - dados do parceiro
    "! @parameter is_zionz | Cadastro WEB - SAP
    METHODS parceiro
      IMPORTING
        is_zionz TYPE ztsd_sint_proces.

    "! Seleciona Função do parceiro
    "! @parameter rv_partn_role | Função do parceiro
    METHODS seleciona_tp_parceiro
      RETURNING
        VALUE(rv_partn_role) TYPE bapiparnr-partn_role.

    "! Seleciona Parceiro
    METHODS seleciona_parceiro.

    "! Executa Bapi
    "! @parameter iv_id |  ID de cadastro
    METHODS executa_bapi
      IMPORTING iv_id TYPE ztsd_sint_proces-id.

    "! Atualiza dados do zionz e log
    "! @parameter is_zionz | Cadastro WEB - SAP
    METHODS atualiza_zionz_e_log
      IMPORTING is_zionz TYPE ztsd_sint_proces.

    "! Atualiza Log
    "! @parameter iv_id |  ID de cadastro
    METHODS append_log
      IMPORTING
        iv_id TYPE ztsd_sint_proces-id.

    "! Adiciona mensagem standard
    "! @parameter is_return       | Parâmetro de retorno
    "! @parameter rv_message_text | Campo sistema ABAP: conteúdo de uma linha lista selecionada
    METHODS add_msg_standard
      IMPORTING
        is_return              TYPE bapiret2
      RETURNING
        VALUE(rv_message_text) TYPE sy-lisel.

    "! Atualiza log erro
    "! @parameter iv_id           | ID de cadastro
    "! @parameter iv_msg_compl    | Campo sistema ABAP: conteúdo de uma linha lista selecionada
    "! @parameter iv_contador     | Campo do sistema ABAP: índice de linhas das tabelas internas
    "! @parameter iv_message_text | Campo sistema ABAP: conteúdo de uma linha lista selecionada
    METHODS atualiza_log_erro
      IMPORTING
        iv_id           TYPE ztsd_sint_proces-id
        iv_msg_compl    TYPE syst_lisel
        iv_contador     TYPE syst-tabix
        iv_message_text TYPE sy-lisel.

    "! Limpa tabelas
    METHODS limpa_tabelas.

    "! Seleciona JOB
    METHODS seleciona_job.

    "! Adiciona Log de Sucesso
    "! @parameter iv_id |  ID de cadastro
    METHODS add_log_sucesso
      IMPORTING
        iv_id TYPE ztsd_sint_proces-id.
ENDCLASS.



CLASS zclsd_ionz_criar_ov IMPLEMENTATION.


  METHOD trata_select_options.

    DATA: lo_ref_descr   TYPE REF TO cl_abap_structdescr.
    DATA: lt_detail      TYPE abap_compdescr_tab.

    FIELD-SYMBOLS: <fs_table> TYPE STANDARD TABLE,
                   <fs_ref>   TYPE REF TO data.

    lo_ref_descr ?= cl_abap_typedescr=>describe_by_data( me->gs_refdata ).
    lt_detail[] = lo_ref_descr->components.

    LOOP AT lt_detail ASSIGNING FIELD-SYMBOL(<fs_det>).

      ASSIGN COMPONENT <fs_det>-name OF STRUCTURE me->gs_refdata TO <fs_ref>.
      ASSIGN COMPONENT <fs_det>-name OF STRUCTURE me->gs_selopt  TO FIELD-SYMBOL(<fs_selopt>).

      ASSIGN <fs_ref>->* TO <fs_table>.
      IF <fs_table> IS ASSIGNED.
        <fs_selopt> = <fs_table>.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD seleciona_dados.

    trata_select_options(  ).
    seleciona_dados_zionz(  ).

  ENDMETHOD.


  METHOD executar.

    CHECK gs_incpo IS NOT INITIAL.
    verifica_job_execucao(  ).

    CHECK gt_message IS INITIAL.
    processa_dados(  ).

  ENDMETHOD.


  METHOD seleciona_dados_zionz.

* selecionar clientes que não foram processados
    SELECT * FROM ztsd_sint_proces INTO TABLE gt_zionz
           WHERE id             IN gs_selopt-id
           AND   bp             NE space
           AND   cod_maq_sap    NE space
           AND   doc_ov         EQ space
           AND   cod_eliminacao EQ space.

    IF sy-subrc NE 0.
      "Sem dados a serem processados !
      processa_msg( iv_msg = 'I001' iv_text = TEXT-e01 ).
    ELSE.
      seleciona_dados_material( ).
    ENDIF.

  ENDMETHOD.


  METHOD processa_msg.

    MESSAGE ID '00' TYPE iv_msg(1) NUMBER iv_msg+1(3) WITH iv_text.

    CASE iv_msg(1).
      WHEN 'I'.
        DATA(lv_type)    = 'E'.
      WHEN OTHERS.
        lv_type    = iv_msg(1).
    ENDCASE.

    APPEND VALUE #( type       = lv_type
                    id         = '00'
                    number     = iv_msg+1(3)
                    message_v1 = iv_text     ) TO gt_message.

  ENDMETHOD.


  METHOD seleciona_dados_material.

* selecionar clientes que não foram processados
    SELECT * FROM ztsd_mat_promo INTO TABLE gt_material
             WHERE zloevm EQ space.

    IF sy-subrc <> 0.
*   mensagem -> Não existe material cadastrado para O.V.
      processa_msg( iv_msg = 'I001' iv_text = TEXT-e02 ).
    ELSE.
      seleciona_dados_tvak( ).
    ENDIF.

  ENDMETHOD.


  METHOD seleciona_dados_tvak.

    SELECT SINGLE incpo FROM tvak INTO gs_incpo
           WHERE auart IN gs_auart.


    IF sy-subrc NE 0.

      DATA(lv_auart) = seleciona_tipo_ov( ).

*   mensagem -> Documento de vendas não existe
      processa_msg( iv_msg = 'I001' iv_text = |{ lv_auart }-{ TEXT-e03 }| ).
    ENDIF.
  ENDMETHOD.


  METHOD seleciona_tipo_ov.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_auart-modulo
      iv_chave1 = gc_parametros_auart-chave1
      iv_chave2 = gc_parametros_auart-chave2
    IMPORTING
      et_range  = gs_auart
  ).

    READ TABLE gs_auart ASSIGNING FIELD-SYMBOL(<fs_auart>) INDEX 1.
    IF sy-subrc = 0.
      rv_auart  = <fs_auart>-low.
    ENDIF.

  ENDMETHOD.


  METHOD get_param.

    DATA(lo_tabela_parametros) = NEW  zclca_tabela_parametros( ).

    TRY.
        lo_tabela_parametros->m_get_range(
          EXPORTING
      iv_modulo = iv_modulo
      iv_chave1 = iv_chave1
      iv_chave2 = iv_chave2
          IMPORTING
            et_range  = et_range
        ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.


  ENDMETHOD.


  METHOD seleciona_job.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_job-modulo
      iv_chave1 = gc_parametros_job-chave1
      iv_chave2 = gc_parametros_job-chave2
    IMPORTING
      et_range  = gs_nome_job
  ).

  ENDMETHOD.


  METHOD verifica_job_execucao.

    DATA: lt_jobcount TYPE TABLE OF tbtco.

    seleciona_job(  ).

    SELECT tbtco~jobname
           tbtco~jobcount
    INTO CORRESPONDING FIELDS OF TABLE lt_jobcount
    FROM tbtco
    WHERE tbtco~jobname IN gs_nome_job
    AND   tbtco~status  EQ 'R'.

    IF sy-batch EQ 'X'.

      IF lines( lt_jobcount ) GT 1.
        processa_msg( iv_msg = 'I001' iv_text = TEXT-i01 ).
      ENDIF.
    ELSE.
      IF lines( lt_jobcount ) GT 0.
        processa_msg( iv_msg = 'I001' iv_text = TEXT-i02 ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD processa_dados.

    seleciona_parceiro(  ).

    LOOP AT gt_zionz ASSIGNING FIELD-SYMBOL(<fs_zionz>).
      CLEAR gs_modelo.
      gs_modelo = <fs_zionz>-codigo.
      DATA(lv_tabix) = sy-tabix.
*   executar somente uma vez
      AT FIRST.
        header_fixo(  ).
      ENDAT.

      gs_header-ref_1  = <fs_zionz>-promocao.
      gs_headerx-ref_1 = gc_constante-cc_x.

*   bapi - dados do item e schedules
      CHECK item_schedules(  ) IS INITIAL.

*   apagar os registros da tab.tranparente de log
      delete_log( iv_id = <fs_zionz>-id ).

*   bapi - dados de cabeçalho - dados variáveis
      header_variavel( iv_id = <fs_zionz>-id ).

*   bapi - dados do parceiro
      parceiro( is_zionz = <fs_zionz> ).

*   executar a bapi
      executa_bapi( iv_id = <fs_zionz>-id ).

*   atualizar tabela transparente
      atualiza_zionz_e_log( is_zionz = <fs_zionz> ).

      limpa_tabelas( ).

    ENDLOOP.

* mensagem -> Registros processados.
    gt_message = gt_message_aux.
    processa_msg( iv_msg = 'S001' iv_text = TEXT-s01 ).

  ENDMETHOD.


  METHOD limpa_tabelas.

    CLEAR: gt_material, gt_item, gt_itemx , gt_partner , gt_schedules_inx, gt_schedules_in, gt_return, gs_modelo.

  ENDMETHOD.


  METHOD header_fixo.

* HEADER DATA
    CLEAR: gs_header, gs_headerx.

* tipo de documento
    gs_header-doc_type      = seleciona_tipo_ov( ).
    gs_headerx-doc_type     = gc_constante-cc_x.

* canal de distribuição
    gs_header-distr_chan    = seleciona_canal_distribuicao( ).
    gs_headerx-distr_chan   = gc_constante-cc_x.

* setor de atividade
    gs_header-division      = seleciona_setor_atividade( ).
    gs_headerx-division     = gc_constante-cc_x.

* data do pedido
    gs_header-purch_date    = sy-datum.
    gs_headerx-purch_date   = gc_constante-cc_x.

* Fornecimento completo por ordem
    gs_header-compl_dlv     = gc_constante-cc_x.
    gs_headerx-compl_dlv    = gc_constante-cc_x.

* flag de atualização
    gs_headerx-updateflag   = gc_constante-cc_i.

* Organização de vendas
    gs_header-sales_org     = seleciona_org_vendas( ).
    gs_headerx-sales_org    = gc_constante-cc_x.

*Motivo da ordem
    gs_header-ord_reason     = gc_constante-cc_motivo.
    gs_headerx-ord_reason    = gc_constante-cc_x.

* Centro
    gs_plant                = seleciona_centro( ).

  ENDMETHOD.


  METHOD seleciona_canal_distribuicao.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_vtweg-modulo
      iv_chave1 = gc_parametros_vtweg-chave1
      iv_chave2 = gc_parametros_vtweg-chave2
    IMPORTING
      et_range  = gs_vtweg
  ).

    READ TABLE gs_vtweg ASSIGNING FIELD-SYMBOL(<fs_vtweg>) INDEX 1.
    IF sy-subrc = 0.
      rv_vtweg  = <fs_vtweg>-low.
    ENDIF.

  ENDMETHOD.


  METHOD seleciona_setor_atividade.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_spart-modulo
      iv_chave1 = gc_parametros_spart-chave1
      iv_chave2 = gc_parametros_spart-chave2
    IMPORTING
      et_range  = gs_spart
  ).

    READ TABLE gs_spart ASSIGNING FIELD-SYMBOL(<fs_spart>) INDEX 1.
    IF sy-subrc = 0.
      rv_spart  = <fs_spart>-low.
    ENDIF.

  ENDMETHOD.


  METHOD seleciona_org_vendas.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_vkorg_spst-modulo
      iv_chave1 = gc_parametros_vkorg_spst-chave1
      iv_chave2 = gc_parametros_vkorg_spst-chave2
    IMPORTING
      et_range  = gs_vkorg_spst
  ).

    READ TABLE gs_vkorg_spst ASSIGNING FIELD-SYMBOL(<fs_vkorg_spst>) INDEX 1.
    IF sy-subrc = 0.
      rv_sales_org  = <fs_vkorg_spst>-low.
    ENDIF.

  ENDMETHOD.


  METHOD seleciona_centro.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_plant_spst-modulo
      iv_chave1 = gc_parametros_plant_spst-chave1
      iv_chave2 = gc_parametros_plant_spst-chave2
    IMPORTING
      et_range  = gs_plant_spst
  ).

    READ TABLE gs_plant_spst ASSIGNING FIELD-SYMBOL(<fs_plant_spst>) INDEX 1.
    IF sy-subrc = 0.
      rv_plant  = <fs_plant_spst>-low.
    ENDIF.

  ENDMETHOD.


  METHOD item_schedules.

    DATA: lv_cont      TYPE tvak-incpo,
          lv_cont_line TYPE bapischdl-sched_line.

* processar todos os materiais da tabela
* WC_INCPO - incremento de item da tabela TVAK
    READ TABLE gt_material WITH KEY modelo = gs_modelo TRANSPORTING NO FIELDS BINARY SEARCH.
    CHECK sy-subrc = 0.

    LOOP AT gt_material ASSIGNING FIELD-SYMBOL(<fs_mat>) FROM sy-tabix.

      IF <fs_mat>-modelo NE gs_modelo.
        EXIT.
      ELSE.

        lv_cont = lv_cont + gs_incpo.

        APPEND VALUE #( itm_number  = lv_cont
                        material    = <fs_mat>-zmatnr
                        target_qty  = <fs_mat>-zmenge
                        sales_unit  = <fs_mat>-zmeins
                        store_loc   = <fs_mat>-zlgort
                        plant       = gs_plant        ) TO gt_item.

        APPEND VALUE #(  itm_number = lv_cont
                         material   = gc_constante-cc_x
                         target_qty = gc_constante-cc_x
                         sales_unit = gc_constante-cc_x
                         store_loc  = gc_constante-cc_x
                         plant      = gc_constante-cc_x
                         updateflag = gc_constante-cc_i ) TO gt_itemx.

        ADD 1 TO lv_cont_line.

        APPEND VALUE #( itm_number  = lv_cont
                        sched_line  = lv_cont_line
                        req_qty     = <fs_mat>-zmenge ) TO gt_schedules_in.

        APPEND VALUE #( itm_number  = lv_cont
                        sched_line  = lv_cont_line
                        updateflag  = gc_constante-cc_x
                        req_qty     = gc_constante-cc_x ) TO gt_schedules_inx.

      ENDIF.

    ENDLOOP.

    IF gt_item IS INITIAL.

      rv_erro = abap_true.

      gt_message = VALUE #( (
                            type   = 'E'
                            id     = 'ZSD_INTERFACE_IONZ'
                            number = 009
                           ) ).

    ENDIF.

  ENDMETHOD.


  METHOD delete_log.

    CHECK NOT iv_id IS INITIAL.
    DELETE FROM ztsd_ionzlogerro WHERE id       = iv_id
                                  AND  log_xd01 = ' '
                                  AND  log_ie08 = ' '
                                  AND  log_va01 = gc_constante-cc_x.

  ENDMETHOD.


  METHOD header_variavel.

* texto referência do pedido
    converte_alpha( EXPORTING iv_id = iv_id IMPORTING ev_id_alpha = DATA(lv_id_alpha)  ).

    DATA(lv_purch_no_c) = |{ gc_constante-cc_id }| & | | & |{ lv_id_alpha }|.

    gs_header-purch_no_c    = lv_purch_no_c.
    gs_headerx-purch_no_c   = gc_constante-cc_x.

  ENDMETHOD.


  METHOD converte_alpha.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = iv_id
      IMPORTING
        output = ev_id_alpha.

  ENDMETHOD.


  METHOD seleciona_tp_parceiro.

    get_param(
    EXPORTING
      iv_modulo = gc_parametros_ag-modulo
      iv_chave1 = gc_parametros_ag-chave1
      iv_chave2 = gc_parametros_ag-chave2
    IMPORTING
      et_range  = gs_partn_role
  ).

    READ TABLE gs_partn_role ASSIGNING FIELD-SYMBOL(<fs_partn_role>) INDEX 1.
    IF sy-subrc = 0.
      rv_partn_role  = <fs_partn_role>-low.
    ENDIF.

  ENDMETHOD.


  METHOD parceiro.

* PARTNER DATA

    gt_partner = gt_partner_aux.

    APPEND VALUE #( partn_role = seleciona_tp_parceiro(  )
                    partn_numb = is_zionz-bp      ) TO gt_partner.


  ENDMETHOD.


  METHOD seleciona_parceiro.

    DATA: ls_zionz_parceiros TYPE ztsd_ionz_parcei,
          ls_partner_aux     TYPE bapiparnr.

    SELECT * FROM ztsd_ionz_parcei
      INTO ls_zionz_parceiros
      WHERE partn_role NE space.
      ls_partner_aux =  CORRESPONDING #( ls_zionz_parceiros ).
      APPEND ls_partner_aux TO gt_partner_aux.
    ENDSELECT.

  ENDMETHOD.


  METHOD executa_bapi.

    CALL FUNCTION 'BAPI_SALESORDER_CREATEFROMDAT2'
      EXPORTING
        order_header_in     = gs_header
        order_header_inx    = gs_headerx
      IMPORTING
        salesdocument       = gs_vbeln
      TABLES
        return              = gt_return
        order_items_in      = gt_item
        order_items_inx     = gt_itemx
        order_schedules_in  = gt_schedules_in
        order_schedules_inx = gt_schedules_inx
        order_partners      = gt_partner.

    APPEND LINES OF gt_return TO gt_message_aux.

    IF NOT gs_vbeln IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      add_log_sucesso( iv_id = iv_id ).
    ENDIF.

  ENDMETHOD.


  METHOD add_log_sucesso.

    DATA ls_log TYPE ztsd_ionz_id_log.

    ls_log = VALUE #( id     = iv_id
                      data   = sy-datum
                      hora   = sy-uzeit
                      doc    = gs_vbeln
                      client = sy-uname ).

    MODIFY ztsd_ionz_id_log FROM ls_log.

  ENDMETHOD.


  METHOD atualiza_zionz_e_log.

    DATA(ls_zionz) = is_zionz.

    IF gs_vbeln IS INITIAL.
      ls_zionz-status_ov = gc_constante-cc_e .
      append_log( iv_id = ls_zionz-id ).
    ELSE.
*    MOVE cc_i TO t_zionz-sts_ov.
      ls_zionz-status_ov = gc_constante-cc_s.
    ENDIF.

    CLEAR: gt_return.
    ls_zionz-doc_ov = gs_vbeln.

    CLEAR: ls_zionz-forn.

    SELECT SINGLE vbeln
      FROM lips
      INTO ls_zionz-forn
      WHERE vgbel EQ gs_vbeln
        AND posnr EQ '000010'.

    IF ls_zionz-forn IS NOT INITIAL.
*    MOVE cc_i TO t_zionz-sts_forn.
      ls_zionz-status_forn_sap = gc_constante-cc_s.
    ELSE.
      ls_zionz-status_forn_sap = gc_constante-cc_e.
      APPEND VALUE #( type    = 'E'
                      message = TEXT-e04 ) TO gt_return.

    ENDIF.

    MODIFY ztsd_sint_proces FROM ls_zionz.
    CLEAR ls_zionz.

    IF sy-subrc EQ 0.
      APPEND VALUE #(  type    = 'S'
                       message = TEXT-s02 ) TO gt_return.

    ELSE.
      APPEND VALUE #( type    = 'E'
                      message = TEXT-e05 ) TO gt_return.
    ENDIF.

  ENDMETHOD.


  METHOD append_log.

    DATA: lv_msg_compl    TYPE syst_lisel,
          lv_contador     TYPE sy-tabix,
          lv_message_text TYPE sy-lisel.

    DELETE gt_return WHERE type NE 'E'.

    LOOP AT gt_return ASSIGNING FIELD-SYMBOL(<fs_return>).

      sy-msgid     = <fs_return>-id.
      sy-msgno     = <fs_return>-number.
      sy-msgv1     = <fs_return>-message_v1.
      sy-msgv2     = <fs_return>-message_v2.
      sy-msgv3     = <fs_return>-message_v3.
      sy-msgv4     = <fs_return>-message_v4.
      lv_msg_compl = TEXT-e06.

      ADD 1 TO lv_contador.

      lv_message_text = add_msg_standard( <fs_return> ).

      atualiza_log_erro(  iv_id = iv_id
                          iv_msg_compl = lv_msg_compl
                          iv_contador = lv_contador
                          iv_message_text = lv_message_text ).

    ENDLOOP.

  ENDMETHOD.


  METHOD atualiza_log_erro.

    DATA  ls_zionz_log TYPE ztsd_ionzlogerro.

    ls_zionz_log-client         =  sy-mandt.
    ls_zionz_log-id             =  iv_id.
    ls_zionz_log-tabix          =  iv_contador.
    ls_zionz_log-language       =  sy-langu.
    ls_zionz_log-message_id     =  sy-msgid.
    ls_zionz_log-message_number =  sy-msgno.
    ls_zionz_log-message_var1   =  sy-msgv1.
    ls_zionz_log-message_var2   =  sy-msgv2.
    ls_zionz_log-message_var3   =  sy-msgv3.
    ls_zionz_log-message_var4   =  sy-msgv4.
    ls_zionz_log-message_text   =  iv_message_text.
    ls_zionz_log-message_compl  =  iv_msg_compl.
    ls_zionz_log-log_xd01       =  ' '.
    ls_zionz_log-log_ie08       =  ' '.
    ls_zionz_log-log_va01       =  gc_constante-cc_x.

    MODIFY ztsd_ionzlogerro FROM ls_zionz_log.

  ENDMETHOD.


  METHOD add_msg_standard.

    DATA: lv_message_text TYPE sy-lisel,
          lv_tabname      TYPE dd03l-tabname,
          lv_fieldname    TYPE dd03l-fieldname,
          lv_ddtext       TYPE dd04t-ddtext,
          lv_texto        TYPE sy-msgv1.

    lv_texto = is_return-message_v1.

    IF is_return-message_v1 CA '-'.
      SPLIT is_return-message_v1 AT '-' INTO lv_tabname
                                               lv_fieldname.
      SELECT SINGLE b~ddtext FROM dd03l AS a
             INNER JOIN dd04t AS b
             ON   a~rollname = b~rollname
             AND  a~as4local = b~as4local
          INTO lv_ddtext
            WHERE a~tabname   EQ lv_tabname   AND
                  a~fieldname EQ lv_fieldname AND
                  a~as4local  EQ 'A'          AND
                  b~ddlanguage EQ sy-langu.

      IF sy-subrc = 0.

        CONCATENATE lv_ddtext '(' is_return-message_v1 ')'
                    INTO lv_texto.
      ENDIF.
    ENDIF.

    IF NOT sy-msgid IS INITIAL.
      CALL FUNCTION 'RPY_MESSAGE_COMPOSE'
        EXPORTING
          language       = sy-langu
          message_id     = sy-msgid
          message_number = sy-msgno
          message_var1   = lv_texto
          message_var2   = sy-msgv2
          message_var3   = sy-msgv3
          message_var4   = sy-msgv4
        IMPORTING
          message_text   = rv_message_text.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
