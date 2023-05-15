"!<p><h2>Criação de Ordem de Frete a partir das unidades de frete</h2></p>
"!<p><strong>Autor:</strong>Marcos Roberto de Souza</p>
"!<p><strong>Data:</strong>12 de jan de 2022</p>
CLASS zcltm_process_of_intercompany DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      "!Campos necessários para o processamento da ordem de frete
      BEGIN OF ty_ordem_frete,
        transportationorderuuid  TYPE i_freightordervh-transportationorderuuid,
        freightorder             TYPE i_freightordervh-freightorder,
        transportationordertype  TYPE i_freightordervh-transportationordertype,
        creationdate             TYPE d,
        transpordlifecyclestatus TYPE i_freightordervh-transpordlifecyclestatus,
        carrier                  TYPE i_freightordervh-carrier,
        transpordplanningstatus  TYPE i_freightordervh-transpordplanningstatus,
        sourcelocation           TYPE i_freightordervh-sourcelocation,
        destinationlocation      TYPE i_freightordervh-destinationlocation,
      END OF ty_ordem_frete .
    TYPES:
          "!Tipo de tabela para o tipo <em>TY_ORDEM_FRETE</em>
      ty_ordem_frete_t TYPE SORTED TABLE OF ty_ordem_frete WITH NON-UNIQUE KEY primary_key COMPONENTS transportationordertype carrier
                                                                                                          sourcelocation destinationlocation .
    TYPES:
      "!Campos necessários para o proessamento das unidades de frete
      BEGIN OF ty_unidade_frete,
        transportationorderuuid  TYPE i_freightunitvh-transportationorderuuid,
        freightunit              TYPE i_freightunitvh-freightunit,
        transportationordertype  TYPE i_freightunitvh-transportationordertype,
        creationdate             TYPE d,
        transpordlifecyclestatus TYPE i_freightunitvh-transpordlifecyclestatus,
        sourcelocation           TYPE i_freightunitvh-sourcelocation,
        destinationlocation      TYPE i_freightunitvh-destinationlocation,
        carrier                  TYPE i_freightunitvh-carrier,
        vbeln                    TYPE likp-vbeln,
        lfart                    TYPE lfart,
        block                    TYPE /scmtms/block_planning,
        motorista                TYPE p_pernr,                      " CHANGE - JWSILVA - 27.02.2023
        freightorder             TYPE /scmtms/d_torrot-tor_id,      " INSERT - JWSILVA - 27.02.2023
        of_i_freightordervh      TYPE i_freightordervh-transpordlifecyclestatus, " INSERT - RPORTES - 22.03.2023
      END OF ty_unidade_frete .
    TYPES:
          "!Tipo de tabela para <em>TY_UNIDADE_FRETE</em>
      ty_unidade_frete_t TYPE SORTED TABLE OF ty_unidade_frete WITH NON-UNIQUE KEY primary_key COMPONENTS transportationordertype carrier
                                                                                                              sourcelocation destinationlocation .
    TYPES:
      "!Tipo para correlação entre unidade de frete e ordem
      BEGIN OF ty_fu_types,
        fu_type TYPE /scmtms/c_torty-type,
        fo_type TYPE /scmtms/c_torty-ds_for_type,
      END OF ty_fu_types .
    TYPES:
          "!Tipo de tabela para <em>TY_FU_TYPES</em>
      ty_types_fu_t     TYPE SORTED TABLE OF ty_fu_types WITH UNIQUE KEY primary_key COMPONENTS fu_type
                                                         WITH NON-UNIQUE SORTED KEY secondary_key COMPONENTS fo_type .
    TYPES:
      ty_tipos_fu       TYPE RANGE OF /scmtms/c_torty-type .
    TYPES:
      ty_tipos_num_fu   TYPE RANGE OF /scmtms/d_torrot-tor_id .
    TYPES:
      ty_tipos_remessas TYPE RANGE OF likp-vbeln .
    TYPES:
      ty_tipos_tsp      TYPE RANGE OF /scmtms/d_torrot-tspid .
    TYPES:
      ty_tipos_driver   TYPE RANGE OF /scmtms/d_torrot-zz_motorista .

    CONSTANTS gc_classe_mensagem TYPE char15 VALUE 'ZTM_ORDEM_FRETE' ##NO_TEXT.
    CONSTANTS gc_s TYPE char1 VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_e TYPE char1 VALUE 'E' ##NO_TEXT.

    "! Exibir o log gerado pelo processamento
    METHODS show_log .
    "! Retornar log gerado pelo processamento
    "! @parameter rt_messages | Log no formato da tabela de mensagens
    METHODS read_log
      RETURNING
        VALUE(rt_messages) TYPE bal_t_msgr .
    "! Retornar numero Ordem de Frete
    "! @parameter rt_return | numero Ordem de Frete
    METHODS get_freightorder
      RETURNING
        VALUE(rt_return) TYPE i_freightordervh-freightorder .
    METHODS process_documents
      IMPORTING
        !ir_tipos_fu TYPE ty_tipos_fu OPTIONAL
        !ir_num_fu   TYPE ty_tipos_num_fu OPTIONAL
        !ir_remessas TYPE ty_tipos_remessas OPTIONAL
        !ir_driver   TYPE /scmtms/d_torrot-zz_motorista OPTIONAL
        !ir_tsp      TYPE /scmtms/d_torrot-tspid OPTIONAL
        !ir_plctrk   TYPE /scmtms/d_torite-platenumber OPTIONAL
        !ir_plctr1   TYPE /scmtms/d_torite-ztrailer1 OPTIONAL
        !ir_plctr2   TYPE /scmtms/d_torite-ztrailer2 OPTIONAL
        !ir_plctr3   TYPE /scmtms/d_torite-ztrailer3 OPTIONAL
        !iv_event    TYPE /scmtms/tor_event DEFAULT 'LIBERADO P/CARREGAR'.
    METHODS fu_type_ecommerce
      RETURNING
        VALUE(rr_fu_types) TYPE ty_tipos_fu .
    METHODS create_fo_plan_auto
      IMPORTING
        !iv_order_type   TYPE /scmtms/tor_type
        !is_freight_unit TYPE ty_unidade_frete
        !ir_driver       TYPE /scmtms/d_torrot-zz_motorista OPTIONAL
        !ir_tsp          TYPE /scmtms/d_torrot-tspid OPTIONAL
        !ir_plctrk       TYPE /scmtms/d_torite-platenumber OPTIONAL
        !ir_plctr1       TYPE /scmtms/d_torite-ztrailer1 OPTIONAL
        !ir_plctr2       TYPE /scmtms/d_torite-ztrailer2 OPTIONAL
        !ir_plctr3       TYPE /scmtms/d_torite-ztrailer3 OPTIONAL
      EXPORTING
        !es_ordem        TYPE ty_ordem_frete .
    METHODS create_event
      IMPORTING
        !is_tor            TYPE /scmtms/s_tor_root_k
        !is_dados          TYPE ztms_input_rodnet
        !iv_event          TYPE /scmtms/tor_event DEFAULT 'LIBERADO P/CARREGAR'
      RETURNING
        VALUE(rt_messages) TYPE bapiret2_t .
  PRIVATE SECTION.

    "!Ordens de frete que podem receber unidades de frete
    DATA gt_ordens TYPE ty_ordem_frete_t .
    "!Unidades de frete sem atribuição em alguma ordem de frete
    DATA gt_unidades TYPE ty_unidade_frete_t .
    "!Objeto de gerenciamento do log de execução
    DATA go_log TYPE REF TO zclca_save_log .
    "!Número Ordens de frete
    DATA gv_freightorder TYPE i_freightordervh-freightorder .

    "! Ler as unidades de frete órfãs para criação/inclusão em ordens de frete
    "! @parameter ir_tipos_fu | Tipos de unidades de frete para geração de OVs
    "! @parameter ir_num_fu | Número das unidades a serem consideradas
    "! @parameter ir_remessas | Número das remessas a serem consideradas
    METHODS read_fu
      IMPORTING
        !ir_tipos_fu TYPE ty_tipos_fu
        !ir_num_fu   TYPE ty_tipos_num_fu
        !ir_remessas TYPE ty_tipos_remessas .
    "! Ler as ordens de frete abertas
    METHODS read_fo .
    "! Realizar log do job
    "! @parameter is_message | Mensagem a ser logada
    METHODS log
      IMPORTING
        !is_message TYPE bapiret2 .
    "! Fechar o log e ralizar a gravação do banco
    METHODS close_log .
    "! Determinar o tipo de ordem de frete baseado no tipo da remessa
    "! @parameter iv_fu_type | Tipo da remessa de origem
    "! @parameter ev_fo_type | Tipo da ordem de frete correspondente
    METHODS determine_freightorder_type
      IMPORTING
        !iv_fu_type TYPE /scmtms/tor_type
      EXPORTING
        !ev_fo_type TYPE /scmtms/tor_type .
    "! Criar ordem de frete nova para acomodar a unidade de frete
    "! @parameter iv_order_type | Tipo de ordem de frete a ser criada
    "! @parameter is_freight_unit | Estrutura com os dados da unidade de frete de origem
    "! @parameter es_ordem | Estrutura com os dados da ordem de frete criada. Se vazia, houve erro na criação da ordem de frete
    METHODS create_fo
      IMPORTING
        !iv_order_type   TYPE /scmtms/tor_type
        !is_freight_unit TYPE ty_unidade_frete
      EXPORTING
        !es_ordem        TYPE ty_ordem_frete .
    "! Inserir a unidade de frete na ordem de frete selecionada
    "! @parameter is_unit | Dados da unidade de frete
    "! @parameter is_ordem | Dados da ordem de frete
    METHODS insert_into_fo
      IMPORTING
        !is_unit  TYPE zcltm_process_of=>ty_unidade_frete
        !is_ordem TYPE zcltm_process_of=>ty_ordem_frete .
    METHODS prepare_param_job
      RETURNING
        VALUE(rv_num_fu) TYPE ty_tipos_num_fu .
    "! Atualizar as Referências
    "! @parameter iv_referencia | ID Saga
    "! @parameter rt_messages | Mensagens do processamento
    METHODS atualiza_referencia IMPORTING !iv_tor_id         TYPE /scmtms/tor_id
                                          !iv_referencia     TYPE ze_idsaga
                                RETURNING VALUE(rt_messages) TYPE bapiret2_t .

ENDCLASS.



CLASS ZCLTM_PROCESS_OF_INTERCOMPANY IMPLEMENTATION.


  METHOD create_fo.

    DATA: lo_message  TYPE REF TO /bobf/if_frw_message,
          lt_result   TYPE /bobf/t_frw_keyindex,
          lt_loc_item TYPE /scmtms/t_loc_alt_id,
          lt_mod_root TYPE /bobf/t_frw_modification,
          lt_mod      TYPE /bobf/t_frw_modification,
          lo_srv_tor  TYPE REF TO /bobf/if_tra_service_manager,
          lo_tra_tor  TYPE REF TO /bobf/if_tra_transaction_mgr,
          lt_root     TYPE /scmtms/t_tor_root_k,
          lt_changed  TYPE /bobf/t_frw_name,
          ls_fo_info  TYPE /scmtms/s_tor_fo_info,
          lt_key      TYPE /bobf/t_frw_key,
          lt_stop_new TYPE /scmtms/t_tor_stop_k.

    lo_tra_tor = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_freight_unit-sourcelocation ) ( is_freight_unit-destinationlocation ) )
      IMPORTING
        et_result     = lt_result ).

    IF lt_result IS NOT INITIAL.
      ls_fo_info-loc_src_key = lt_result[ 1 ]-key. " Source
      ls_fo_info-loc_dst_key = lt_result[ 2 ]-key. " Destination
    ENDIF.

** INICIO - WMDO - 25-08-22 - Inclusão de uma nova etapa para a ordem de frete
    /scmtms/cl_tor_factory=>create_tor_tour(
      EXPORTING
        iv_do_modify            = abap_true
        iv_tor_type             = iv_order_type
        iv_create_initial_stage = abap_true
        iv_creation_type        = /scmtms/if_tor_const=>sc_creation_type-manual
      IMPORTING
        es_tor_root             = DATA(ls_tor_root)
        et_tor_item             = DATA(lt_item)
        et_tor_stop             = DATA(lt_stop)
        et_tor_stop_succ        = DATA(lt_stop_succ)
      CHANGING
        co_message              = lo_message ).
** FIM - WMDO - 25-08-22 - Inclusão de uma nova etapa para a ordem de frete

    SELECT SINGLE vbeln,
                  wadat,
                  lfdat,
                  lfuhr,
                  wauhr
      FROM likp
      INTO @DATA(ls_likp)
    WHERE vbeln = @is_freight_unit-vbeln.

    IF sy-subrc IS INITIAL.
      SELECT SINGLE vbeln,
                    vgbel
        FROM lips
        INTO @DATA(ls_lips)
      WHERE vbeln = @is_freight_unit-vbeln.

      IF sy-subrc IS INITIAL.
        SELECT SINGLE vbeln,
                      bukrs_vf
          FROM vbak
          INTO @DATA(ls_vbak)
        WHERE vbeln = @ls_lips-vgbel.

        IF sy-subrc IS NOT INITIAL.
          SELECT SINGLE ebeln,
                        bukrs
            FROM ekko
            INTO @DATA(ls_ekko)
          WHERE ebeln = @ls_lips-vgbel.
        ENDIF.
      ENDIF.
    ENDIF.
** INICIO - WMDO - 02-12-22 - Inclusão de dados da empresa
    IF ls_likp IS NOT INITIAL.
      IF ls_vbak-bukrs_vf IS NOT INITIAL.
        ls_tor_root-purch_company_code   = ls_vbak-bukrs_vf.
      ELSEIF ls_ekko-bukrs IS NOT INITIAL.
        ls_tor_root-purch_company_code   = ls_ekko-bukrs.
      ENDIF.

      IF ls_tor_root-purch_company_code IS NOT INITIAL.
        SELECT SINGLE internal_id
          FROM /scmb/dv_orgunit
          INTO ls_tor_root-purch_company_org_id
        WHERE short = ls_tor_root-purch_company_code.
      ENDIF.

      APPEND: 'PURCH_COMPANY_CODE'   TO lt_changed,
              'PURCH_COMPANY_ORG_ID' TO lt_changed.

*      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
*                      node           = /scmtms/if_tor_c=>sc_node-root
*                      key            = ls_tor_root-key
*                      changed_fields = lt_changed
*                      data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.
*
*      CALL METHOD lo_srv_tor->modify
*        EXPORTING
*          it_modification = lt_mod_root
*        IMPORTING
*          eo_message      = lo_message.
*
*      CLEAR lt_mod_root.
    ENDIF.
** FIM - WMDO - 02-12-22 - Inclusão de dados da empresa

** INICIO - WMDO - 13-12-2022 - Inclusão da transportadora do FLUIG na ordem de frete
    SELECT SINGLE remessa, transportadora
      FROM ztm_infos_fluig
      INTO @DATA(ls_infos_fluig)
    WHERE remessa = @is_freight_unit-vbeln.

    IF sy-subrc IS INITIAL.
* Verifica se a ordem de frete é oriunda da interface do FLUIG
      DATA(lv_fluig) = abap_true.

      ls_tor_root-tspid = ls_infos_fluig-transportadora.

      SELECT SINGLE FROM i_businesspartnersupplier
        FIELDS businesspartneruuid
        WHERE supplier = @ls_tor_root-tspid
        INTO @ls_tor_root-tsp.

      APPEND: 'TSPID' TO lt_changed,
              'TSP'   TO lt_changed.

*      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
*                      node           = /scmtms/if_tor_c=>sc_node-root
*                      key            = ls_tor_root-key
*                      changed_fields = lt_changed
*                      data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.
*
*      CALL METHOD lo_srv_tor->modify
*        EXPORTING
*          it_modification = lt_mod_root
*        IMPORTING
*          eo_message      = lo_message.
    ENDIF.
** FIM - WMDO - 13-12-2022 - Inclusão da transportadora do FLUIG na ordem de frete

    "Atualizar a transportadora na OF
    IF is_freight_unit-carrier IS NOT INITIAL.
      ls_tor_root-tspid = is_freight_unit-carrier.
      SELECT SINGLE FROM i_businesspartnersupplier
        FIELDS businesspartneruuid
        WHERE supplier = @is_freight_unit-carrier
        INTO @ls_tor_root-tsp.                       "#EC CI_SEL_NESTED

      APPEND: 'TSPID' TO lt_changed,
              'TSP'   TO lt_changed.

      IF is_freight_unit-motorista IS NOT INITIAL.
        SELECT partner FROM but0id
            INTO @ls_tor_root-zz_motorista
            UP TO 1 ROWS
            WHERE idnumber = @is_freight_unit-motorista.

          APPEND 'ZZ_MOTORISTA' TO lt_changed.
        ENDSELECT.
      ENDIF.

*      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
*                      node           = /scmtms/if_tor_c=>sc_node-root
*                      key            = ls_tor_root-key
*                      changed_fields = lt_changed
*                      data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.
*
*      CALL METHOD lo_srv_tor->modify
*        EXPORTING
*          it_modification = lt_mod_root
*        IMPORTING
*          eo_message      = lo_message.
    ENDIF.

    " Atualiza campos da Ordem de Frete
    TRY.
        zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-intercompany
                                    CHANGING  cs_root      = ls_tor_root
                                              ct_changed   = lt_changed ).
      CATCH cx_root.
    ENDTRY.

    IF lt_changed IS NOT INITIAL.

      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                      node           = /scmtms/if_tor_c=>sc_node-root
                      key            = ls_tor_root-key
                      changed_fields = lt_changed
                      data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.

      CALL METHOD lo_srv_tor->modify
        EXPORTING
          it_modification = lt_mod_root
        IMPORTING
          eo_message      = lo_message.

    ENDIF.

** INICIO - WMDO - 25-08-22 - Inclusão de uma nova etapa para a ordem de frete
    IF lt_stop_succ IS NOT INITIAL.
      INSERT VALUE #( key = lt_stop_succ[ 1 ]-key  ) INTO TABLE lt_key.

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->do_action(
        EXPORTING
          iv_act_key = /scmtms/if_tor_c=>sc_action-stop_successor-insert_after
          it_key     = lt_key
        IMPORTING
          eo_message = lo_message  ).

      IF lo_message IS NOT INITIAL.
        lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                  IMPORTING et_message  = DATA(lt_messages3) ).
      ENDIF.

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
        EXPORTING
          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
          it_key         = VALUE #( ( key = ls_tor_root-key ) )
          iv_association = /scmtms/if_tor_c=>sc_association-root-stop
          iv_fill_data   = abap_true
        IMPORTING
          et_data        = lt_stop_new ).

      "Definir os pontos de origem e destino
      LOOP AT lt_stop_new ASSIGNING FIELD-SYMBOL(<fs_stop_new>).
        IF <fs_stop_new>-stop_id EQ '0000000010'. " Origem
          <fs_stop_new>-log_locid    = is_freight_unit-sourcelocation.
          <fs_stop_new>-log_loc_uuid = lt_result[ 1 ]-key.

          IF ls_likp IS NOT INITIAL.
            CONVERT DATE ls_likp-wadat TIME ls_likp-wauhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
          ENDIF.
        ELSEIF <fs_stop_new>-stop_id EQ '0000000020'. " Destino.
          <fs_stop_new>-log_locid    = is_freight_unit-destinationlocation.
          <fs_stop_new>-log_loc_uuid = lt_result[ 2 ]-key.

          IF ls_likp IS NOT INITIAL.
            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
          ENDIF.
        ELSEIF <fs_stop_new>-stop_id EQ '0000000030'. " Segunda Origem
          <fs_stop_new>-log_locid    = is_freight_unit-sourcelocation.
          <fs_stop_new>-log_loc_uuid = lt_result[ 1 ]-key.

          IF ls_likp IS NOT INITIAL.
            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
          ENDIF.
        ELSEIF <fs_stop_new>-stop_id EQ '0000000040'. " Destino final.
          <fs_stop_new>-log_locid    = is_freight_unit-destinationlocation.
          <fs_stop_new>-log_loc_uuid = lt_result[ 2 ]-key.

          IF ls_likp IS NOT INITIAL.
            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
          ENDIF.
        ELSE.
          CONTINUE.
        ENDIF.

        "Preparar as atualizações das paradas
        INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
                        node = /scmtms/if_tor_c=>sc_node-stop
                        key  = <fs_stop_new>-key
                        data = REF #( <fs_stop_new> ) ) INTO TABLE lt_mod.
      ENDLOOP.

      "Gravar Ordem de Frete
      CALL METHOD lo_srv_tor->modify
        EXPORTING
          it_modification = lt_mod
        IMPORTING
          eo_message      = lo_message.

      IF lo_message IS BOUND.
        lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                  IMPORTING et_message  = DATA(lt_messages1) ).
      ENDIF.
    ENDIF.
** FIM - WMDO - 25-08-22 - Inclusão de uma nova etapa para a ordem de frete

    lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected            = DATA(lv_rejected)
                                eo_change              = DATA(lo_change)
                                eo_message             = lo_message
                                et_rejecting_bo_key    = DATA(lt_rej_bo_key) ).

    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
      EXPORTING
        iv_node_key             = /scmtms/if_tor_c=>sc_node-root
        it_key                  = VALUE #( ( key = ls_tor_root-key ) )
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_root ).

    IF lo_message IS BOUND.
      lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = DATA(lt_messages2) ).
    ENDIF.

    "Logar o resultado da criação
    IF lines( lt_root ) > 0.
      DATA(lv_tor_id) = lt_root[ 1 ]-tor_id.
    ENDIF.

    IF lv_tor_id IS INITIAL.
      "Erro na criação da OF.
      CLEAR es_ordem.
      DATA(ls_msg) = VALUE bapiret2( id = gc_classe_mensagem number = '002' type = gc_e message_v1 = |{ is_freight_unit-freightunit ALPHA = OUT }| ).

    ELSE.
      "Armazenar OF na tabela de ordens
      es_ordem = CORRESPONDING #( is_freight_unit ).
      es_ordem-freightorder            = lv_tor_id.
      es_ordem-transportationorderuuid = ls_tor_root-key.
      es_ordem-transportationordertype = iv_order_type.
*      es_ordem-creationdate            = sy-datum.
      INSERT es_ordem INTO TABLE gt_ordens.

      ls_msg = VALUE bapiret2( id = gc_classe_mensagem number = '003' type = gc_s message_v1 = |{ es_ordem-freightorder ALPHA = OUT }| ).
    ENDIF.

    log( is_message = ls_msg ).

    APPEND LINES OF lt_messages2 TO lt_messages1.
    LOOP AT lt_messages1 ASSIGNING FIELD-SYMBOL(<fs_message>).
      DATA(ls_erro) = <fs_message>-message->if_t100_message~t100key.
      ls_msg = VALUE #( id = ls_erro-msgid number = ls_erro-msgno type = gc_e ).
      log( is_message = ls_msg ).
    ENDLOOP.

  ENDMETHOD.


  METHOD read_fo.

    "Ler ordens de frete
    SELECT FROM i_freightordervh AS a
        INNER JOIN i_transportationorder AS b ON b~transportationorderuuid = a~transportationorderuuid
        FIELDS a~transportationorderuuid, a~freightorder, a~transportationordertype,
               CAST( left( CAST( a~creationdatetime AS CHAR ), 8 ) AS DATS ) AS creationdate,
               a~transpordlifecyclestatus, a~carrier, a~transpordplanningstatus, a~sourcelocation, a~destinationlocation
        WHERE ( a~transpordlifecyclestatus = '01' OR    "Ordem nova
                a~transpordlifecyclestatus = '02' ) AND "Ordem em execução
              b~transportationorderexecsts = '03'       "Status de execução
        INTO TABLE @gt_ordens.
  ENDMETHOD.


  METHOD read_fu.

    "Ler unidades de frete
    SELECT FROM i_freightunitvh AS a
        INNER JOIN likp AS b ON b~vbeln = right( a~businesstransactiondocument, 10 )
        INNER JOIN i_transportationorder AS block ON block~transportationorderuuid = a~transportationorderuuid
        LEFT  JOIN vbpa AS c ON c~vbeln = b~vbeln  AND
                                c~posnr = '000000' AND "Parceiros de cabeçalho
                                c~parvw = 'YM'         "Motorista
        FIELDS a~transportationorderuuid, a~freightunit, a~transportationordertype,
               CAST( left( CAST( a~creationdatetime AS CHAR ), 8 ) AS DATS ) AS creationdate,
               a~transpordlifecyclestatus, a~sourcelocation, a~destinationlocation,
               a~carrier, b~vbeln, b~lfart, block~transpordplanningblock, c~pernr
        WHERE a~transpordplanningstatus EQ '01'         AND "Transporte não planejado
              ( a~transpordlifecyclestatus EQ '01'      OR
                a~transpordlifecyclestatus EQ '02' )    AND "Status Unidade de Frete - Novo ou Em Processamento
              a~transportationordertype IN @ir_tipos_fu AND "Tipos de unidade de frete
              a~freightunit             IN @ir_num_fu   AND "Números das unidades de frete
              b~vbeln                   IN @ir_remessas AND "Números das remessas
              block~transpordplanningblock EQ @space        "Não está bloqueada para planejamento
        INTO TABLE @gt_unidades.
  ENDMETHOD.


  METHOD log.

    IF go_log IS NOT BOUND.
      go_log = NEW zclca_save_log( iv_object = 'ZTM' ).
      go_log->create_log( iv_subobject = 'ZOF' ).
    ENDIF.

    DATA(lt_msg) = VALUE bapiret2_tab( ( CORRESPONDING #( is_message ) ) ).
    go_log->add_msgs( it_msg = lt_msg ).
  ENDMETHOD.


  METHOD close_log.

    IF go_log IS BOUND.
      go_log->save( ).
      CLEAR go_log.
    ENDIF.
  ENDMETHOD.


  METHOD insert_into_fo.

    DATA: ls_params TYPE /scmtms/s_tor_a_add_elements,
          lt_root   TYPE /scmtms/t_tor_root_k.

    ls_params-string           = is_unit-freightunit.
    ls_params-target_item_keys = VALUE #( ( key = is_unit-transportationorderuuid ) ).
    ls_params-abort_when_error = abap_true.

    DATA(lo_tra_tor) = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    DATA(lo_srv_tor) = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    "Inserir Unidade de frete na ordem
    lo_srv_tor->do_action( EXPORTING iv_act_key           = /scmtms/if_tor_c=>sc_action-root-add_fu_by_fuid
                                     it_key               = VALUE #( ( key = is_ordem-transportationorderuuid ) )
                                     is_parameters        = REF #( ls_params )
                           IMPORTING eo_change            = DATA(lo_change)
                                     eo_message           = DATA(lo_message)
                                     et_failed_key        = DATA(lt_failed_key)
                                     et_failed_action_key = DATA(lt_failed_action_key) ).

    IF lo_message IS BOUND.
      lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = DATA(lt_messages) ).
    ENDIF.

*    IF lines( lt_messages ) = 0.
    lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                      IMPORTING ev_rejected            = DATA(lv_rejected)
                                eo_change              = lo_change
                                eo_message             = lo_message
                                et_rejecting_bo_key    = DATA(lt_rej_bo_key) ).
    IF lo_message IS BOUND.
      lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = lt_messages ).
    ENDIF.

    WAIT UP TO 5 SECONDS. "Aguardar gravação da OF e liberação do objeto

*    ELSE.
*      lo_tra_tor->cleanup( ).
*    ENDIF.

    IF lines( lt_messages ) > 0 OR lv_rejected = abap_true.
      DATA(ls_msg) = VALUE bapiret2( id = gc_classe_mensagem number = '005' type = gc_e message_v1 = |{ is_unit-freightunit   ALPHA = OUT }|
                                                                                        message_v2 = |{ is_ordem-freightorder ALPHA = OUT }| ).

    ELSE.
      ls_msg = VALUE bapiret2( id = gc_classe_mensagem number = '004' type = gc_s message_v1 = |{ is_unit-freightunit   ALPHA = OUT }|
                                                                                  message_v2 = |{ is_ordem-freightorder ALPHA = OUT }| ).
    ENDIF.

    log( is_message = ls_msg ).

    LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_message>).
      DATA(ls_erro) = <fs_message>-message->if_t100_message~t100key.
      ls_msg = VALUE #( id = ls_erro-msgid number = ls_erro-msgno type = gc_e ).
      log( is_message = ls_msg ).
    ENDLOOP.
  ENDMETHOD.


  METHOD determine_freightorder_type.

    DATA lo_function TYPE REF TO if_fdt_function.

    CLEAR ev_fo_type.
    "Leitura de Id da função BRF+
    cacsbr_cl_icm_fdt_helper=>get_fdt_guid(
      EXPORTING
        id_obj_name = 'FU_DET_TIPO_OF'
        id_obj_type = 'FU'
      IMPORTING
        et_obj_ids  = DATA(lt_guid_func) ).
    CHECK lines( lt_guid_func ) > 0.

    DATA(lv_guid) = lt_guid_func[ 1 ]-id.

    TRY.
        cl_fdt_factory=>get_instance_generic(
          EXPORTING
            iv_id       = lv_guid
          IMPORTING
            eo_instance = DATA(lo_instance) ).
        lo_function ?= lo_instance.

        DATA(lo_context) = lo_function->get_process_context( ).
        lo_context->set_value( iv_name  = 'SCMTMSTOR_TYPE'
                               ia_value = iv_fu_type ).

        lo_function->process( EXPORTING io_context = lo_context
                              IMPORTING eo_result  = DATA(lo_result) ).

        lo_result->get_value( IMPORTING ea_value = ev_fo_type ).

      CATCH cx_fdt_input cx_fdt_config cx_fdt INTO DATA(lo_error).
    ENDTRY.
  ENDMETHOD.


  METHOD show_log.

    DATA(lt_handler) = VALUE bal_t_logh( ( go_log->gv_log_handle ) ).
    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_t_log_handle       = lt_handler
      EXCEPTIONS
        profile_inconsistent = 1
        internal_error       = 2
        no_data_available    = 3
        no_authority         = 4
        OTHERS               = 5.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD read_log.
    CALL FUNCTION 'BAL_LOG_READ'
      EXPORTING
        i_log_handle  = go_log->gv_log_handle
        i_read_texts  = abap_true
      IMPORTING
        et_msg        = rt_messages
      EXCEPTIONS
        log_not_found = 1
        OTHERS        = 2.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
  ENDMETHOD.


  METHOD fu_type_ecommerce.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'OF_ECOMMERCE'
                               IMPORTING et_range  = rr_fu_types ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD prepare_param_job.

    DATA: lr_perfil_selecao TYPE RANGE OF /scmtms/vsr_sel_profile_id,
          lt_fu_key         TYPE /bobf/t_frw_key,
          lt_fu_data        TYPE /scmtms/t_tor_root_k.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = 'TM'
                                         iv_chave1 = 'PLANAUTOMATICO'
                                         iv_chave2 = 'PERFISSELECAO'
                               IMPORTING et_range  = lr_perfil_selecao ).
      CATCH zcxca_tabela_parametros.

    ENDTRY.

    IF lr_perfil_selecao[] IS NOT INITIAL.
      LOOP AT lr_perfil_selecao ASSIGNING FIELD-SYMBOL(<fs_perfil_selecao>).
        TRY.
            /scmtms/cl_batch_helper_80=>get_node_keys_by_sel_prof(
              EXPORTING
                iv_sel_profile_id  = <fs_perfil_selecao>-low                    " Requirements Profile ID (alt. param. below)
                iv_seltype_tor     = /scmtms/cl_prof_acc=>c_seltype-torfu      " Single-Character Flag
                iv_msg_nof_entries = 'BOTH'                                     " '','NO', 'BOTH' , 'APPLOG'
              IMPORTING
                et_root_keys_tor   = DATA(lt_root_keys_tor) ).

            IF lt_root_keys_tor[] IS NOT INITIAL.
              lt_fu_key = CORRESPONDING #( BASE ( lt_fu_key ) lt_root_keys_tor ).
            ENDIF.

            CLEAR: lt_root_keys_tor.

          CATCH /scmtms/cx_batch.
        ENDTRY.
      ENDLOOP.

      IF lt_fu_key[] IS NOT INITIAL.
        TRY.
            /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
              EXPORTING
                iv_node_key             = /scmtms/if_tor_c=>sc_node-root                " Node
                it_key                  = lt_fu_key                                     " Key Table
              IMPORTING
                et_data                 = lt_fu_data ).                                 " Return Data

            IF lt_fu_data[] IS NOT INITIAL.
              rv_num_fu = VALUE #( FOR <fs_num_fu> IN lt_fu_data
                                 ( sign   = /bobf/if_conf_c=>sc_sign_option_including
                                   option = /bobf/if_conf_c=>sc_sign_equal
                                   low    = <fs_num_fu>-tor_id ) ).
            ENDIF.
          CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract
        ENDTRY.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_freightorder.
    rt_return = gv_freightorder.
  ENDMETHOD.


  METHOD create_fo_plan_auto.

    DATA: lo_message      TYPE REF TO /bobf/if_frw_message,
          lt_result       TYPE /bobf/t_frw_keyindex,
          lt_loc_item     TYPE /scmtms/t_loc_alt_id,
          lt_mod_root     TYPE /bobf/t_frw_modification,
          lt_mod_item     TYPE /bobf/t_frw_modification,
          lt_mod          TYPE /bobf/t_frw_modification,
          lt_root         TYPE /scmtms/t_tor_root_k,
          lt_item         TYPE /scmtms/t_tor_item_tr_k,
          lt_changed      TYPE /bobf/t_frw_name,
          lt_changed_item TYPE /bobf/t_frw_name,
          ls_fo_info      TYPE /scmtms/s_tor_fo_info,
          lt_key          TYPE /bobf/t_frw_key,
          lt_messages1    TYPE /bobf/t_frw_message_k,
          lt_stop_new     TYPE /scmtms/t_tor_stop_k.

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_freight_unit-sourcelocation ) ( is_freight_unit-destinationlocation ) )
      IMPORTING
        et_result     = lt_result ).

    IF lt_result IS NOT INITIAL.
      ls_fo_info-loc_src_key = lt_result[ 1 ]-key. " Source
      ls_fo_info-loc_dst_key = lt_result[ 2 ]-key. " Destination
    ENDIF.

    /scmtms/cl_tor_factory=>create_tor_tour(
      EXPORTING
        iv_do_modify            = abap_true
        iv_tor_type             = iv_order_type
        iv_create_initial_stage = abap_true
        iv_creation_type        = /scmtms/if_tor_const=>sc_creation_type-manual
      IMPORTING
        es_tor_root             = DATA(ls_tor_root)
        et_tor_stop             = DATA(lt_stop)
        et_tor_stop_succ        = DATA(lt_stop_succ)
      CHANGING
        co_message              = lo_message ).

** INICIO - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES
    SELECT SINGLE vbeln,
                  wadat,
                  lfdat,
                  vsbed,
                  lfuhr,
                  wauhr,
                  vsart
      FROM likp
      INTO @DATA(ls_likp)
    WHERE vbeln = @is_freight_unit-vbeln.

    IF sy-subrc IS INITIAL.
      SELECT SINGLE vbeln,
                    vgbel
        FROM lips
        INTO @DATA(ls_lips)
      WHERE vbeln = @is_freight_unit-vbeln.

      IF sy-subrc IS INITIAL.
        SELECT SINGLE vbeln,
                      bukrs_vf
          FROM vbak
          INTO @DATA(ls_vbak)
        WHERE vbeln = @ls_lips-vgbel.

        IF sy-subrc IS NOT INITIAL.
          SELECT SINGLE ebeln,
                        bukrs
            FROM ekko
            INTO @DATA(ls_ekko)
          WHERE ebeln = @ls_lips-vgbel.
        ENDIF.
      ENDIF.
    ENDIF.
** FIM - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES

    "Atualizar a transportadora na OF
    IF ir_tsp IS NOT INITIAL.
      ls_tor_root-tspid = ir_tsp.

      SELECT SINGLE FROM i_businesspartnersupplier
        FIELDS businesspartneruuid
      WHERE supplier = @ls_tor_root-tspid
        INTO @ls_tor_root-tsp.

      APPEND: 'TSPID' TO lt_changed,
              'TSP'   TO lt_changed.

      SELECT partner
        FROM but0id
        INTO ls_tor_root-zz_motorista
        UP TO 1 ROWS
      WHERE partner EQ ir_driver.

        APPEND 'ZZ_MOTORISTA' TO lt_changed.
      ENDSELECT.

** INICIO - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES
      IF ls_likp IS NOT INITIAL.

        IF ls_likp-vsbed IS NOT INITIAL.
          ls_tor_root-zz1_cond_exped = ls_likp-vsbed.
          APPEND: 'ZZ1_COND_EXPED'       TO lt_changed.
        ENDIF.

*        IF ls_likp-vsart IS NOT INITIAL.
*          ls_tor_root-zz1_tipo_exped = ls_likp-vsart.
        ls_tor_root-zz1_tipo_exped = '01'.
        APPEND: 'ZZ1_TIPO_EXPED'       TO lt_changed.
*        ENDIF.

        IF ls_vbak-bukrs_vf IS NOT INITIAL.
          ls_tor_root-purch_company_code   = ls_vbak-bukrs_vf.
        ELSEIF ls_ekko-bukrs IS NOT INITIAL.
          ls_tor_root-purch_company_code   = ls_ekko-bukrs.
        ENDIF.

        IF ls_tor_root-purch_company_code IS NOT INITIAL.
          SELECT SINGLE internal_id
            FROM /scmb/dv_orgunit
            INTO ls_tor_root-purch_company_org_id
          WHERE short = ls_tor_root-purch_company_code.
        ENDIF.

        IF ls_tor_root-purch_company_code   IS NOT INITIAL AND
           ls_tor_root-purch_company_org_id IS NOT INITIAL.

          APPEND: 'PURCH_COMPANY_CODE'   TO lt_changed,
                  'PURCH_COMPANY_ORG_ID' TO lt_changed.

        ENDIF.
      ENDIF.
** FIM - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES

      " Atualiza campos da Ordem de Frete
      TRY.
          zcltm_manage_of=>change_of( EXPORTING iv_interface = zcltm_manage_of=>gc_interface-intercompany
                                                iv_vbeln     = is_freight_unit-vbeln  " CHANGE - JWSILVA - 11.05.2023
                                      CHANGING  cs_root      = ls_tor_root
                                                ct_changed   = lt_changed ).
        CATCH cx_root.
      ENDTRY.

      INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                      node           = /scmtms/if_tor_c=>sc_node-root
                      key            = ls_tor_root-key
                      changed_fields = lt_changed
                      data           = REF #( ls_tor_root ) ) INTO TABLE lt_mod_root.

      CALL METHOD /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify(
        EXPORTING
          it_modification = lt_mod_root
        IMPORTING
          eo_message      = lo_message ).
    ENDIF.

*    IF lt_stop_succ IS NOT INITIAL.
*      INSERT VALUE #( key = lt_stop_succ[ 1 ]-key  ) INTO TABLE lt_key.
*
*      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->do_action(
*        EXPORTING
*          iv_act_key = /scmtms/if_tor_c=>sc_action-stop_successor-insert_after
*          it_key     = lt_key
*        IMPORTING
*          eo_message = lo_message  ).
*
*      IF lo_message IS NOT INITIAL.
*        lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
*                                  IMPORTING et_message  = DATA(lt_messages3) ).
*      ENDIF.
*
*      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
*        EXPORTING
*          iv_node_key    = /scmtms/if_tor_c=>sc_node-root
*          it_key         = VALUE #( ( key = ls_tor_root-key ) )
*          iv_association = /scmtms/if_tor_c=>sc_association-root-stop
*          iv_fill_data   = abap_true
*        IMPORTING
*          et_data        = lt_stop_new ).
*
*** INICIO - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES
**      SELECT SINGLE *
**        FROM likp
**        INTO @DATA(ls_likp)
**      WHERE vbeln = @is_freight_unit-vbeln.
*** FIM - RDSP - 28-12-22 - 8000004592 - OF CRIADA AUTOM SEM INFORMAÇÕES
*
*      "Definir os pontos de origem e destino
*      LOOP AT lt_stop_new ASSIGNING FIELD-SYMBOL(<fs_stop_new>).
*        IF <fs_stop_new>-stop_id EQ '0000000010'. " Origem
*          <fs_stop_new>-log_locid    = is_freight_unit-sourcelocation.
*          <fs_stop_new>-log_loc_uuid = lt_result[ 1 ]-key.
*
*          IF ls_likp IS NOT INITIAL.
*            CONVERT DATE ls_likp-wadat TIME ls_likp-wauhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
*          ENDIF.
*        ELSEIF <fs_stop_new>-stop_id EQ '0000000020'. " Destino.
*          <fs_stop_new>-log_locid    = is_freight_unit-destinationlocation.
*          <fs_stop_new>-log_loc_uuid = lt_result[ 2 ]-key.
*
*          IF ls_likp IS NOT INITIAL.
*            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
*          ENDIF.
*        ELSEIF <fs_stop_new>-stop_id EQ '0000000030'. " Segunda Origem
*          <fs_stop_new>-log_locid    = is_freight_unit-sourcelocation.
*          <fs_stop_new>-log_loc_uuid = lt_result[ 1 ]-key.
*
*          IF ls_likp IS NOT INITIAL.
*            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
*          ENDIF.
*        ELSEIF <fs_stop_new>-stop_id EQ '0000000040'. " Destino final.
*          <fs_stop_new>-log_locid    = is_freight_unit-destinationlocation.
*          <fs_stop_new>-log_loc_uuid = lt_result[ 2 ]-key.
*
*          IF ls_likp IS NOT INITIAL.
*            CONVERT DATE ls_likp-lfdat TIME ls_likp-lfuhr INTO TIME STAMP <fs_stop_new>-plan_trans_time TIME ZONE sy-zonlo.
*          ENDIF.
*        ELSE.
*          CONTINUE.
*        ENDIF.
*
*        "Preparar as atualizações das paradas
*        INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
*                        node = /scmtms/if_tor_c=>sc_node-stop
*                        key  = <fs_stop_new>-key
*                        data = REF #( <fs_stop_new> ) ) INTO TABLE lt_mod.
*      ENDLOOP.
*
*      "Gravar Ordem de Frete
*      CALL METHOD /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify(
*        EXPORTING
*          it_modification = lt_mod
*        IMPORTING
*          eo_message      = lo_message ).
*
*      IF lo_message IS BOUND.
*        lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
*                                  IMPORTING et_message  = DATA(lt_messages1) ).
*      ENDIF.
*    ENDIF.

* Gravação das placas
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
      EXPORTING
        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
        it_key         = VALUE #( ( key = ls_tor_root-key ) )
        iv_association = /scmtms/if_tor_c=>sc_association-root-item_tr
        iv_fill_data   = abap_true
      IMPORTING
        et_data        = lt_item ).

    IF lt_item IS NOT INITIAL.
      DELETE lt_item WHERE item_cat NE /scmtms/if_tor_const=>sc_tor_item_category-av_item. "#EC CI_SORTSEQ

      IF line_exists( lt_item[ item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item ] ). "#EC CI_SORTSEQ
        READ TABLE lt_item ASSIGNING FIELD-SYMBOL(<fs_item>) WITH KEY item_cat = /scmtms/if_tor_const=>sc_tor_item_category-av_item. "#EC CI_SORTSEQ

        <fs_item>-platenumber = ir_plctrk.
        <fs_item>-ztrailer1   = ir_plctr1.
        <fs_item>-ztrailer2   = ir_plctr2.
        <fs_item>-ztrailer3   = ir_plctr3.

        IF ir_plctrk IS NOT INITIAL.
          SELECT SINGLE *
            FROM equi
            INTO @DATA(ls_equi)
          WHERE equnr = @ir_plctrk.           "#EC CI_ALL_FIELDS_NEEDED

          IF sy-subrc IS INITIAL.
            SELECT SINGLE *
              FROM /scmb/equi_code
              INTO @DATA(ls_equi_code)
            WHERE equi_code = @ls_equi-eqart.

            IF sy-subrc IS INITIAL.
              <fs_item>-tures_cat = ls_equi_code-equi_type.
              <fs_item>-tures_tco = ls_equi_code-equi_code.
            ENDIF.
          ENDIF.
        ENDIF.

        APPEND: 'PLATENUMBER' TO lt_changed_item.
        APPEND: 'ZTRAILER1'   TO lt_changed_item.
        APPEND: 'ZTRAILER2'   TO lt_changed_item.
        APPEND: 'ZTRAILER3'   TO lt_changed_item.
        APPEND: 'TURES_CAT'   TO lt_changed_item.
        APPEND: 'TURES_TCO'   TO lt_changed_item.

        INSERT VALUE #( change_mode    = /bobf/if_frw_c=>sc_modify_update
                        node           = /scmtms/if_tor_c=>sc_node-item_tr
                        key            = <fs_item>-key
                        changed_fields = lt_changed_item
                        data           = REF #( <fs_item> ) ) INTO TABLE lt_mod_item.

        CALL METHOD /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify(
          EXPORTING
            it_modification = lt_mod_item
          IMPORTING
            eo_message      = lo_message ).
      ENDIF.
    ENDIF.

    /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save(
      EXPORTING
        iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
      IMPORTING
        ev_rejected            = DATA(lv_rejected)
        eo_change              = DATA(lo_change)
        eo_message             = lo_message
        et_rejecting_bo_key    = DATA(lt_rej_bo_key) ).

    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
      EXPORTING
        iv_node_key  = /scmtms/if_tor_c=>sc_node-root
        it_key       = VALUE #( ( key = ls_tor_root-key ) )
        iv_fill_data = abap_true
      IMPORTING
        et_data      = lt_root ).

    IF lo_message IS BOUND.
      lo_message->get_messages( EXPORTING iv_severity = /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = DATA(lt_messages2) ).
    ENDIF.

    "Logar o resultado da criação
    IF lines( lt_root ) > 0.
      DATA(lv_tor_id) = lt_root[ 1 ]-tor_id.
    ENDIF.

    IF lv_tor_id IS INITIAL.
      "Erro na criação da OF.
      CLEAR es_ordem.
      DATA(ls_msg) = VALUE bapiret2( id = gc_classe_mensagem number = '002' type = gc_e message_v1 = |{ is_freight_unit-freightunit ALPHA = OUT }| ).

    ELSE.
      "Armazenar OF na tabela de ordens
      es_ordem = CORRESPONDING #( is_freight_unit ).
      es_ordem-freightorder            = lv_tor_id.
      es_ordem-transportationorderuuid = ls_tor_root-key.
      es_ordem-transportationordertype = iv_order_type.
*      es_ordem-creationdate            = sy-datum.
      INSERT es_ordem INTO TABLE gt_ordens.

      ls_msg = VALUE bapiret2( id = gc_classe_mensagem number = '003' type = gc_s message_v1 = |{ es_ordem-freightorder ALPHA = OUT }| ).
    ENDIF.

    log( is_message = ls_msg ).

    APPEND LINES OF lt_messages2 TO lt_messages1.
    LOOP AT lt_messages1 ASSIGNING FIELD-SYMBOL(<fs_message>).
      DATA(ls_erro) = <fs_message>-message->if_t100_message~t100key.
      ls_msg = VALUE #( id = ls_erro-msgid number = ls_erro-msgno type = gc_e ).
      log( is_message = ls_msg ).
    ENDLOOP.

    IF lv_tor_id IS NOT INITIAL.
*      SELECT SINGLE FROM ztsd_intercompan
      SELECT SINGLE FROM zi_sd_01_cockpit
        FIELDS idsaga
        WHERE remessa EQ @is_freight_unit-vbeln
        INTO @DATA(lv_3ca).

      DATA(lt_msg_upd_ref) = atualiza_referencia( iv_tor_id = lv_tor_id iv_referencia = lv_3ca ).

      LOOP AT lt_msg_upd_ref ASSIGNING FIELD-SYMBOL(<fs_msg_upd_ref>).
        log( is_message = <fs_msg_upd_ref> ).
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD process_documents.
    DATA:
      lr_num_fu        TYPE ty_tipos_num_fu,
      ls_freight_unit  TYPE ty_unidade_frete,
      ls_ordem         TYPE ty_ordem_frete,
      lt_root          TYPE /scmtms/t_tor_root_k,
      lt_root_fu       TYPE /scmtms/t_tor_root_k,
      lt_stop_first    TYPE /scmtms/t_tor_stop_k,
      lt_stop_first_fu TYPE /scmtms/t_tor_stop_k,
      lt_key           TYPE /bobf/t_frw_key,
      lt_key_fu        TYPE /bobf/t_frw_key,
      ls_dados         TYPE ztms_input_rodnet,
      lt_param         TYPE /bobf/t_frw_query_selparam.

    DATA(lr_tipos_fu_ecommerce) = me->fu_type_ecommerce( ).

** Tipo de Unidade de frete
*    IF ir_tipos_fu IS NOT INITIAL.
*      LOOP AT ir_tipos_fu INTO DATA(ls_tipos_fu).  "#EC CI_LOOP_INTO_WA
*        APPEND VALUE #( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_type
*                        sign           = ls_tipos_fu-sign
*                        option         = ls_tipos_fu-option
*                        low            = ls_tipos_fu-low
*                        high           = ls_tipos_fu-high ) TO lt_param.
*      ENDLOOP.
*    ENDIF.
*
** Numero de Unidade de frete
*    IF lr_num_fu IS NOT INITIAL.
*      LOOP AT lr_num_fu INTO DATA(ls_num_fu).      "#EC CI_LOOP_INTO_WA
*        APPEND VALUE #( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_id
*                        sign           = ls_num_fu-sign
*                        option         = ls_num_fu-option
*                        low            = ls_num_fu-low
*                        high           = ls_num_fu-high ) TO lt_param.
*      ENDLOOP.
*    ENDIF.
*
* Numero da remessa
    IF ir_remessas IS NOT INITIAL.
      LOOP AT ir_remessas INTO DATA(ls_remessas).  "#EC CI_LOOP_INTO_WA
        APPEND VALUE #( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-trq_base_btd_id
                        sign           = ls_remessas-sign
                        option         = ls_remessas-option
                        low            = ls_remessas-low
                        high           = ls_remessas-high ) TO lt_param.
      ENDLOOP.
    ENDIF.

* Tipo de documento
    APPEND VALUE #( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_cat
                    sign           = /bobf/if_conf_c=>sc_sign_option_including
                    option         = /bobf/if_conf_c=>sc_sign_equal
                    low            = 'FU' ) TO lt_param.

    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
      EXPORTING
        iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes
        it_selection_parameters = lt_param
        iv_fill_data            = abap_true
      IMPORTING
        et_key                  = lt_key_fu
        et_data                 = lt_root_fu ).

    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
      EXPORTING
        iv_node_key             = /scmtms/if_tor_c=>sc_node-root
        it_key                  = lt_key_fu
        iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first_and_last
        iv_fill_data            = abap_true
      IMPORTING
        et_data                 = lt_stop_first_fu  ).

    IF lines( lt_root_fu ) = 0.
      me->log( VALUE #( type = gc_s id = gc_classe_mensagem number = '001' ) ). "Não há unidades de frete para anexar à ordens de frete
      go_log->save( ).
      RETURN.
    ENDIF.

    "Para cada unidade de frete,
    LOOP AT lt_root_fu ASSIGNING FIELD-SYMBOL(<fs_funit>).
      "Realizar o de-para do tipo de unidade de frete para o tipo de ordem de frete
      me->determine_freightorder_type( EXPORTING iv_fu_type = <fs_funit>-tor_type
                                       IMPORTING ev_fo_type = DATA(lv_tipo_ordem) ).

      IF line_exists( lt_stop_first_fu[ stop_cat = 'O' ] ). "#EC CI_SORTSEQ
        ls_freight_unit-sourcelocation = lt_stop_first_fu[ stop_cat = 'O' ]-log_locid. "#EC CI_SORTSEQ
      ENDIF.

      IF line_exists( lt_stop_first_fu[ stop_cat = 'I' ] ). "#EC CI_SORTSEQ
        ls_freight_unit-destinationlocation = lt_stop_first_fu[ stop_cat = 'I' ]-log_locid. "#EC CI_SORTSEQ
      ENDIF.

      ls_freight_unit-transportationorderuuid  = <fs_funit>-key.
      ls_freight_unit-freightunit              = <fs_funit>-tor_id.
      ls_freight_unit-transportationordertype  = <fs_funit>-tor_type.
      ls_freight_unit-transpordlifecyclestatus = <fs_funit>-lifecycle.
      ls_freight_unit-carrier                  = <fs_funit>-tsp.

      IF <fs_funit>-base_btd_id IS ASSIGNED.
        SHIFT <fs_funit>-base_btd_id LEFT DELETING LEADING '0'.

        ls_freight_unit-vbeln                  = <fs_funit>-base_btd_id.
        ls_freight_unit-vbeln                  = |{ ls_freight_unit-vbeln ALPHA = IN } |.
      ENDIF.

*      IF lv_tipo_ordem IN lr_tipos_fu_ecommerce.
      IF ls_ordem IS INITIAL.
        "Criar uma nova FO
        create_fo_plan_auto( EXPORTING iv_order_type   = lv_tipo_ordem
                                       is_freight_unit = ls_freight_unit
                                       ir_driver       = ir_driver
                                       ir_tsp          = ir_tsp
                                       ir_plctrk       = ir_plctrk
                                       ir_plctr1       = ir_plctr1
                                       ir_plctr2       = ir_plctr2
                                       ir_plctr3       = ir_plctr3
                             IMPORTING es_ordem        = ls_ordem ).
      ENDIF.
*      ENDIF.

      "Inserir unidade na ordem selecionada
      IF ls_ordem IS NOT INITIAL.
        insert_into_fo( EXPORTING is_unit  = ls_freight_unit
                                  is_ordem = ls_ordem ).
      ENDIF.
    ENDLOOP.

* Realiza SET de eventos para a ordem de frete
    IF ls_ordem IS NOT INITIAL.
      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->query(
        EXPORTING
          iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes
          it_selection_parameters = VALUE #( ( attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_id
                                               sign           = /bobf/if_conf_c=>sc_sign_option_including
                                               option         = /bobf/if_conf_c=>sc_sign_equal
                                               low            = ls_ordem-freightorder ) )
          iv_fill_data            = abap_true
        IMPORTING
          et_key                  = lt_key
          et_data                 = lt_root ).

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = lt_key
          iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_stop_first  ).

      IF lt_root IS NOT INITIAL.
        IF line_exists( lt_stop_first[ stop_cat = 'O' ] ) . "#EC CI_SORTSEQ
          ls_dados-ori_locid = lt_stop_first[ stop_cat = 'O' ]-log_locid. "#EC CI_SORTSEQ
        ENDIF.

        READ TABLE lt_root INTO DATA(ls_tor) INDEX 1.

        create_event( EXPORTING is_dados = ls_dados
                                is_tor   = ls_tor
                                iv_event = iv_event ).

      ENDIF.
    ENDIF.

    gv_freightorder = ls_ordem-freightorder.

    me->go_log->save( ).

  ENDMETHOD.


  METHOD create_event.

    DATA: lt_stop_fist TYPE /scmtms/t_tor_stop_k,
          lt_mod       TYPE /bobf/t_frw_modification,
          lt_return    TYPE bapiret2_t.

    DATA: ls_mod  TYPE /bobf/s_frw_modification,
          ls_exec TYPE /scmtms/s_tor_exec_k.

    TRY.

        /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve_by_association(
          EXPORTING
            iv_node_key             = /scmtms/if_tor_c=>sc_node-root                                                                                   " Node
            it_key                  = VALUE #( ( key = is_tor-key ) )                                                                                  " Key Table
            iv_association          = /scmtms/if_tor_c=>sc_association-root-stop_first                                                                 " Association
            iv_fill_data            = abap_true                                                                                                        " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_stop_fist  ).

      CATCH /bobf/cx_frw_contrct_violation.                                                                                                            " Caller violates a BOPF contract

    ENDTRY.

    CHECK lt_stop_fist[] IS NOT INITIAL.

    IF line_exists( lt_stop_fist[ log_locid = is_dados-ori_locid ]  ). "#EC CI_SORTSEQ

      ls_exec-key           = /bobf/cl_frw_factory=>get_new_key( ).
      ls_exec-parent_key    = is_tor-key.
      ls_exec-root_key      = is_tor-key.
      ls_exec-event_code    = iv_event.                                    " CHANGE - JWSILVA - 06.03.2023
      ls_exec-torstopuuid   = lt_stop_fist[ log_locid = is_dados-ori_locid ]-key. "#EC CI_SORTSEQ
      ls_exec-ext_loc_id    = lt_stop_fist[ log_locid = is_dados-ori_locid ]-log_locid. "#EC CI_SORTSEQ
      ls_exec-ext_loc_uuid  = lt_stop_fist[ log_locid = is_dados-ori_locid ]-log_loc_uuid. "#EC CI_SORTSEQ

      /scmtms/cl_mod_helper=>mod_create_single(
        EXPORTING
          is_data        = ls_exec
          iv_key         = ls_exec-key                                                                                                                 " NodeID
          iv_parent_key  = ls_exec-parent_key                                                                                                          " NodeID
          iv_root_key    = ls_exec-root_key                                                                                                            " NodeID
          iv_node        = /scmtms/if_tor_c=>sc_node-executioninformation                                                                              " Node
          iv_source_node = /scmtms/if_tor_c=>sc_node-root                                                                                              " Node
          iv_association = /scmtms/if_tor_c=>sc_association-root-exec                                                                                  " Association
        CHANGING
          ct_mod         = lt_mod ).                                                                                                                   " Changes

      IF lt_mod[] IS NOT INITIAL.
        TRY.

            /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->modify( EXPORTING it_modification = lt_mod              " Changes
                                                                                                       IMPORTING eo_message      = DATA(lo_message) ). " Interface of Message Object

            IF NOT lo_message IS INITIAL.

              CLEAR lt_return.
              /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                     CHANGING  ct_bapiret2 = lt_return[] ).

              IF lt_return IS NOT INITIAL.
                APPEND LINES OF lt_return TO rt_messages.
                EXIT.
              ENDIF.

              CLEAR lo_message.

              /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = lo_message ).

              IF NOT lo_message IS INITIAL.

                CLEAR lt_return.
                /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                       CHANGING  ct_bapiret2 = lt_return[] ).

                IF lt_return IS NOT INITIAL.
                  APPEND LINES OF lt_return TO rt_messages.
                ENDIF.
              ENDIF.
            ENDIF.
          CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

        ENDTRY.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD atualiza_referencia.

    DATA:
      lt_parameters  TYPE /bobf/t_frw_query_selparam,
      lt_tor_root    TYPE /scmtms/t_tor_root_k,
      lt_mod         TYPE /bobf/t_frw_modification,
      lt_tor_doc_ref TYPE /scmtms/t_tor_docref_k,
      lt_return      TYPE bapiret2_tab,
      ls_tor_doc_ref TYPE /scmtms/s_tor_docref_k,
      lo_srv_tor     TYPE REF TO /bobf/if_tra_service_manager,
      ls_parameter   TYPE /bobf/s_frw_query_selparam.

    CONSTANTS: lc_3ca    TYPE /scmtms/btd_type_code VALUE '3CA'.

    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    CLEAR ls_parameter.
    APPEND VALUE #( sign           = /bobf/if_conf_c=>sc_sign_option_including
                    option         = /bobf/if_conf_c=>sc_sign_equal
                    attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_id
                    low            = iv_tor_id ) TO lt_parameters.

    APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_param_tco>).
    <fs_param_tco>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_cat.
    <fs_param_tco>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
    <fs_param_tco>-option         = /bobf/if_conf_c=>sc_sign_equal.
    <fs_param_tco>-low            = /scmtms/if_tor_const=>sc_tor_category-active.

    TRY.

        lo_srv_tor->query(
          EXPORTING
            iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes " Query
            it_selection_parameters = lt_parameters                                       " Query Selection Parameters
            iv_fill_data            = abap_true                                           " Data element for domain BOOLE: TRUE (='X') and FALSE (=' ')
          IMPORTING
            et_data                 = lt_tor_root ).

        LOOP AT lt_tor_root ASSIGNING FIELD-SYMBOL(<fs_of>).

          ls_tor_doc_ref-key          = lo_srv_tor->get_new_key( ).
          ls_tor_doc_ref-parent_key   = <fs_of>-key.
          ls_tor_doc_ref-root_key     = <fs_of>-key.
          ls_tor_doc_ref-btd_tco      = lc_3ca.
          ls_tor_doc_ref-btd_id       = iv_referencia.
          ls_tor_doc_ref-btd_date     = sy-datum.
          APPEND ls_tor_doc_ref TO lt_tor_doc_ref.

        ENDLOOP.

        CHECK lt_tor_doc_ref[] IS NOT INITIAL.

        CLEAR: lt_mod[].
        /scmtms/cl_mod_helper=>mod_create_multi( EXPORTING iv_node        = /scmtms/if_tor_c=>sc_node-docreference              " Node
                                                           it_data        = lt_tor_doc_ref
                                                           iv_association = /scmtms/if_tor_c=>sc_association-root-docreference  " Association
                                                           iv_source_node = /scmtms/if_tor_c=>sc_node-root                      " Node
                                                 CHANGING  ct_mod         = lt_mod ).                                           " Changes

        lo_srv_tor->modify( EXPORTING it_modification = lt_mod                                                                  " Changes
                            IMPORTING eo_message      = DATA(lo_message) ).                                                     " Interface of Message Object

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.
        ENDIF.

        CHECK lt_return[] IS INITIAL.

        /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( )->save( IMPORTING eo_message = lo_message ).

        IF NOT lo_message IS INITIAL.

          CLEAR lt_return.
          /scmtms/cl_common_helper=>msg_convert_bopf_2_bapiret2( EXPORTING io_message  = lo_message
                                                                 CHANGING  ct_bapiret2 = lt_return[] ).

          IF lt_return IS NOT INITIAL.
            APPEND LINES OF lt_return TO rt_messages.
          ENDIF.
        ENDIF.

      CATCH /bobf/cx_frw_contrct_violation. " Caller violates a BOPF contract

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
