"!<p><h2>Criação de Ordem de Frete a partir de pedidos</h2></p>
"!<p><strong>Autor:</strong>Bruno Costa</p>
"!<p><strong>Data:</strong>15 de jan de 2022</p>
CLASS zclsd_process_of DEFINITION
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
      ty_ordem_frete_t TYPE SORTED TABLE OF ty_ordem_frete WITH NON-UNIQUE KEY primary_key COMPONENTS transportationordertype creationdate carrier
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
        lfart                    TYPE lfart,
        motorista                TYPE pernr,
      END OF ty_unidade_frete .
    TYPES:
              "!Tipo de tabela para <em>TY_UNIDADE_FRETE</em>
      ty_unidade_frete_t TYPE SORTED TABLE OF ty_unidade_frete WITH NON-UNIQUE KEY primary_key COMPONENTS transportationordertype creationdate carrier
                                                                                                                  sourcelocation destinationlocation .
    TYPES:
      "!Tipo para correlação entre unidade de frete e ordem
      BEGIN OF ty_fu_types,
        fu_type TYPE /scmtms/c_torty-type,
        fo_type TYPE /scmtms/c_torty-ds_for_type,
      END OF ty_fu_types .
    TYPES:
              "!Tipo de tabela para <em>TY_FU_TYPES</em>
      ty_types_fu_t TYPE SORTED TABLE OF ty_fu_types WITH UNIQUE KEY primary_key COMPONENTS fu_type
                                                             WITH NON-UNIQUE SORTED KEY secondary_key COMPONENTS fo_type .
    TYPES:
      ty_pedidos  TYPE RANGE OF ebeln .
    TYPES:
      ty_coligados TYPE TABLE OF zi_sd_01_cockpit .
    TYPES:
      ty_remessas  TYPE RANGE OF vbeln_vl .
    TYPES:
      ty_reported TYPE RESPONSE FOR REPORTED EARLY zi_sd_01_cockpit .

    CONSTANTS gc_classe_mensagem TYPE char15 VALUE 'ZTM_ORDEM_FRETE' ##NO_TEXT.
    CONSTANTS gc_s TYPE char1 VALUE 'S' ##NO_TEXT.
    CONSTANTS gc_e TYPE char1 VALUE 'E' ##NO_TEXT.

    METHODS constructor .
    "! Execução da rotina principal do job.
    METHODS execute
      IMPORTING
                !it_coligados TYPE ty_coligados OPTIONAL
      RETURNING VALUE(rt_log) TYPE bapiret2_tab.
  PRIVATE SECTION.

    "!Ordens de frete que podem receber unidades de frete
    DATA gt_ordens TYPE ty_ordem_frete_t .
    "!Unidades de frete sem atribuição em alguma ordem de frete
    DATA gt_unidades TYPE ty_unidade_frete_t .
    "!Objeto de gerenciamento do log de execução
    DATA go_log TYPE REF TO zclca_save_log .
    "!Tabela com os valores de equivalência entre unidade de frete e ordem
    DATA gt_fu_fo_translation TYPE ty_types_fu_t .
    DATA gt_log TYPE bapiret2_tab .

    METHODS validate_po
      IMPORTING
        !it_coligados TYPE ty_coligados
      EXPORTING
        !ev_ok        TYPE flag .
    "! Ler as unidades de frete órfãs para criação/inclusão em ordens de frete
    METHODS read_fu
      IMPORTING
        !ir_remessas TYPE ty_remessas .
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
        !is_unit  TYPE zclsd_process_of=>ty_unidade_frete
        !is_ordem TYPE zclsd_process_of=>ty_ordem_frete .
ENDCLASS.



CLASS zclsd_process_of IMPLEMENTATION.


  METHOD constructor.

    FREE gt_log.

  ENDMETHOD.


  METHOD execute.

    "Validar Pedidos
    me->validate_po(
      EXPORTING
        it_coligados = it_coligados
      IMPORTING
        ev_ok        = DATA(lv_ok)
    ).

    IF lv_ok EQ abap_true.
      me->log( VALUE #( type = gc_s id = gc_classe_mensagem number = '007' ) ). "Selecionar ordens com informações idênticas de transporte
      APPEND LINES OF gt_log TO rt_log.
      RETURN.
    ENDIF.

    DATA lr_remessas TYPE ty_remessas.
    LOOP AT it_coligados ASSIGNING FIELD-SYMBOL(<fs_coligados>).
      APPEND INITIAL LINE TO lr_remessas ASSIGNING FIELD-SYMBOL(<fs_remessas>).
      <fs_remessas>-sign   = 'I'.
      <fs_remessas>-option = 'EQ'.
      <fs_remessas>-low    = <fs_coligados>-docnuv.
    ENDLOOP.

    "Ler as unidades de frete
    me->read_fu( ir_remessas = lr_remessas ).

    IF lines( gt_unidades ) = 0.
      me->log( VALUE #( type = gc_s id = gc_classe_mensagem number = '001' ) ). "Não há unidades de frete para anexar à ordens de frete
      APPEND LINES OF gt_log TO rt_log.
      RETURN.
    ENDIF.
    "Ler as ordens de frete já criadas
    me->read_fo( ).
*    "Para cada unidade de frete,
*    LOOP AT gt_unidades ASSIGNING FIELD-SYMBOL(<fs_funit>).
    READ TABLE gt_unidades ASSIGNING FIELD-SYMBOL(<fs_funit>) INDEX 1.
    "Realizar o de-para do tipo de unidade de frete para o tipo de ordem de frete
    me->determine_freightorder_type( EXPORTING iv_fu_type = <fs_funit>-transportationordertype
                                     IMPORTING ev_fo_type = DATA(lv_tipo_ordem) ).
    IF lv_tipo_ordem IS INITIAL.
      me->log( VALUE #( type = gc_e id = gc_classe_mensagem number = '006' message_v1 = |{ <fs_funit>-freightunit ALPHA = OUT }| ) ).
      APPEND LINES OF gt_log TO rt_log.
      RETURN.
    ENDIF.
    "verificar se há ordem de frete já disponível
    TRY.

        DATA(ls_ordem) = gt_ordens[ transportationordertype = lv_tipo_ordem
                                    creationdate            = <fs_funit>-creationdate
                                    carrier                 = <fs_funit>-carrier
                                    sourcelocation          = <fs_funit>-sourcelocation
                                    destinationlocation     = <fs_funit>-destinationlocation ].

      CATCH cx_sy_itab_line_not_found.
        "Se não houver ordem aberta, criar uma nova
        create_fo( EXPORTING iv_order_type   = lv_tipo_ordem
                             is_freight_unit = <fs_funit>
                   IMPORTING es_ordem        = ls_ordem ).

    ENDTRY.
    "Inserir unidade na ordem selecionada
    LOOP AT gt_unidades ASSIGNING <fs_funit>.
      IF ls_ordem IS NOT INITIAL.
        insert_into_fo( EXPORTING is_unit  = <fs_funit>
                                  is_ordem = ls_ordem ).
      ENDIF.
    ENDLOOP.

    APPEND LINES OF gt_log TO rt_log.

  ENDMETHOD.


  METHOD create_fo.

    DATA: lo_message  TYPE REF TO /bobf/if_frw_message,
          lt_result   TYPE /bobf/t_frw_keyindex,
          lt_loc_item TYPE /scmtms/t_loc_alt_id,
          lt_mod_root TYPE /bobf/t_frw_modification,
          lt_mod      TYPE /bobf/t_frw_modification,
          lo_srv_tor  TYPE REF TO /bobf/if_tra_service_manager,
          lo_tra_tor  TYPE REF TO /bobf/if_tra_transaction_mgr,
          lt_root     TYPE /scmtms/t_tor_root_k,
          lt_changed  TYPE /bobf/t_frw_name.

    lo_tra_tor = /bobf/cl_tra_trans_mgr_factory=>get_transaction_manager( ).
    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    "Criar ordem de frete
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
      CHANGING
         co_message              = lo_message ).

    "Converter origem e destino
    /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_location_c=>sc_bo_key )->convert_altern_key(
      EXPORTING
        iv_node_key   = /scmtms/if_location_c=>sc_node-root
        iv_altkey_key = /scmtms/if_location_c=>sc_alternative_key-root-location_id
        it_key        = VALUE /scmtms/t_loc_alt_id( ( is_freight_unit-sourcelocation ) ( is_freight_unit-destinationlocation ) )
      IMPORTING
        et_result     = lt_result ).

    "Definir os pontos de origem e destino
    LOOP AT lt_stop ASSIGNING FIELD-SYMBOL(<fs_stop>).
      IF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-outbound.
        <fs_stop>-log_locid    = is_freight_unit-sourcelocation.
        <fs_stop>-log_loc_uuid = lt_result[ 1 ]-key.
        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

      ELSEIF <fs_stop>-stop_cat EQ /scmtms/if_tor_const=>sc_tor_stop_cat-inbound.
        <fs_stop>-log_locid    = is_freight_unit-destinationlocation.
        <fs_stop>-log_loc_uuid = lt_result[ 2 ]-key.
        CONVERT DATE sy-datum INTO TIME STAMP <fs_stop>-plan_trans_time TIME ZONE 'BRT'.

      ELSE.
        CONTINUE.
      ENDIF.

      "Preparar as atualizações das paradas
      INSERT VALUE #( change_mode = /bobf/if_frw_c=>sc_modify_update
                      node = /scmtms/if_tor_c=>sc_node-stop
                      key  = <fs_stop>-key
                      data = REF #( <fs_stop> ) ) INTO TABLE lt_mod.
    ENDLOOP.

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

      " Atualiza campos da Ordem de Frete
      TRY.
          zcltm_manage_of=>change_of( CHANGING  cs_root      = ls_tor_root
                                                ct_changed   = lt_changed ).
        CATCH cx_root.
      ENDTRY.

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

    "Gravar Ordem de Frete
    CALL METHOD lo_srv_tor->modify
      EXPORTING
        it_modification = lt_mod
      IMPORTING
        eo_message      = lo_message.

    IF lo_message IS BOUND.
      lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = DATA(lt_messages1) ).
    ENDIF.

    IF lines( lt_messages1 ) > 0.
      lo_tra_tor->cleanup( ).

    ELSE.
      lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                        IMPORTING ev_rejected         = DATA(lv_rejected)
                                  eo_change           = DATA(lo_change)
                                  eo_message          = lo_message
                                  et_rejecting_bo_key = DATA(lt_rej_bo_key) ).

      /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key )->retrieve(
        EXPORTING
          iv_node_key             = /scmtms/if_tor_c=>sc_node-root
          it_key                  = VALUE #( ( key = ls_tor_root-key ) )
          iv_fill_data            = abap_true
        IMPORTING
          et_data                 = lt_root ).

      IF lo_message IS BOUND.
        lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
                                  IMPORTING et_message  = DATA(lt_messages2) ).
      ENDIF.
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
      es_ordem-creationdate            = sy-datum.
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
    SELECT FROM i_freightordervh
        FIELDS transportationorderuuid, freightorder, transportationordertype,
               CAST( left( CAST( creationdatetime AS CHAR ), 8 ) AS DATS ) AS creationdate,
               transpordlifecyclestatus, carrier, transpordplanningstatus, sourcelocation, destinationlocation
        WHERE transpordlifecyclestatus = '01' OR "Ordem nova
              transpordlifecyclestatus = '02'    "Ordem em execução
        INTO TABLE @gt_ordens.

  ENDMETHOD.


  METHOD read_fu.
    "Ler unidades de frete
    SELECT FROM i_freightunitvh AS a
        INNER JOIN likp AS b ON b~vbeln = right( a~businesstransactiondocument, 10 )
        LEFT  JOIN vbpa AS c ON c~vbeln = b~vbeln  AND
                                c~posnr = '000000' AND "Parceiros de cabeçalho
                                c~parvw = 'YM'         "Motorista
        FIELDS a~transportationorderuuid, a~freightunit, a~transportationordertype,
               CAST( left( CAST( a~creationdatetime AS CHAR ), 8 ) AS DATS ) AS creationdate,
               a~transpordlifecyclestatus, a~sourcelocation, a~destinationlocation,
               a~carrier, b~lfart, c~pernr
        WHERE b~vbeln IN @ir_remessas
        INTO TABLE @gt_unidades.

  ENDMETHOD.


  METHOD log.

    gt_log  = VALUE bapiret2_tab( ( CORRESPONDING #( is_message ) ) ).

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
      lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
                                IMPORTING et_message  = DATA(lt_messages) ).
    ENDIF.

    IF lines( lt_messages ) = 0.

      lo_tra_tor->save( EXPORTING iv_transaction_pattern = /bobf/if_tra_c=>gc_tp_save_and_continue
                        IMPORTING ev_rejected         = DATA(lv_rejected)
                                  eo_change           = lo_change
                                  eo_message          = lo_message
                                  et_rejecting_bo_key = DATA(lt_rej_bo_key) ).
      IF lo_message IS BOUND.
        lo_message->get_messages( EXPORTING iv_severity =  /bobf/cm_frw=>co_severity_error
                                  IMPORTING et_message  = lt_messages ).
      ENDIF.

      WAIT UP TO 2 SECONDS. "Aguardar gravação da OF e liberação do objeto

    ELSE.

      lo_tra_tor->cleanup( ).

    ENDIF.

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
        et_obj_ids    = DATA(lt_guid_func) ).

    CHECK lines( lt_guid_func ) > 0.

    DATA(lv_guid) = lt_guid_func[ 1 ]-id.

    TRY.

        cl_fdt_factory=>get_instance_generic(
          EXPORTING
            iv_id         = lv_guid
          IMPORTING
            eo_instance   = DATA(lo_instance) ).

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


  METHOD validate_po.

    DATA(lt_tpfrete) = it_coligados[].
    SORT lt_tpfrete BY tpfrete.
    DELETE ADJACENT DUPLICATES FROM lt_tpfrete COMPARING tpfrete.
    DESCRIBE TABLE lt_tpfrete LINES DATA(lv_lines).
    IF lv_lines > 1.
      ev_ok = abap_true.
    ENDIF.

    DATA(lt_tpexp) = it_coligados[].
    SORT lt_tpexp BY tpexp.
    DELETE ADJACENT DUPLICATES FROM lt_tpexp COMPARING tpexp.
    DESCRIBE TABLE lt_tpexp LINES lv_lines.
    IF lv_lines > 1.
      ev_ok = abap_true.
    ENDIF.

    "Condição de Expedição
    "Placa

    DATA(lt_agfrete) = it_coligados[].
    SORT lt_agfrete BY agfrete.
    DELETE ADJACENT DUPLICATES FROM lt_agfrete COMPARING agfrete.
    DESCRIBE TABLE lt_agfrete LINES lv_lines.
    IF lv_lines > 1.
      ev_ok = abap_true.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
