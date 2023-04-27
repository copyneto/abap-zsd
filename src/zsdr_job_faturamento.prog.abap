***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: JOB Faturamento                                        *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 22/02/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************
*&---------------------------------------------------------------------*
*& Report ZSDR_JOB_FATURAMENTO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_job_faturamento.

************************************************************************
* Declarações
************************************************************************

TABLES: vkdfs,
        /scmtms/d_torrot.

*-Types-----------------------------------------------------------*
TYPES: BEGIN OF ty_output,
         vbeln    TYPE vkdfs-vbeln,
         tor_id   TYPE /scmtms/d_torrot-tor_id,
         fkart    TYPE vkdfs-fkart,
         fkdat    TYPE vkdfs-fkdat,
         vkorg    TYPE vkdfs-vkorg,
         vtweg    TYPE vkdfs-vtweg,
         spart    TYPE vkdfs-spart,
         vstel    TYPE vkdfs-vstel,
         kunnr    TYPE vkdfs-kunnr,
         name1    TYPE vkdfif-name1,
         ort01    TYPE vkdfif-ort01,
         lland    TYPE vkdfs-lland,
         sortkri  TYPE vkdfs-sortkri,
         netwr    TYPE vkdfif-netwr,
         waerk    TYPE vkdfif-waerk,
         vbartbez TYPE vkdfif-vbartbez,
       END OF ty_output,

       ty_output_t TYPE STANDARD TABLE OF ty_output,

       BEGIN OF ty_remessa,
         vbeln TYPE likp-vbeln,
       END OF ty_remessa,

       BEGIN OF ty_intercompany,
         vbelv TYPE vbfa-vbelv,
         vbeln TYPE vbfa-vbeln,
         bstkd TYPE vbkd-bstkd,
       END OF ty_intercompany,

       BEGIN OF ty_log,
         remessa(30),
         tipo_msg(1),
         msg(100),
       END OF ty_log.

*-Tabelas internas------------------------------------------------------*
DATA: gt_output TYPE ty_output_t,
      gt_bdc    TYPE tab_bdcdata,
      gt_msg    TYPE tab_bdcmsgcoll,
      gt_log    TYPE TABLE OF ty_log.

*-Structures------------------------------------------------------*
DATA gs_options TYPE ctu_params.

*-References----------------------------------------------------------*
DATA: go_alv    TYPE REF TO cl_salv_table,
      go_events TYPE REF TO cl_salv_events_table.

*-Constants------------------------------------------------------*
CONSTANTS gc_vf01 TYPE tcode VALUE 'VF01'.

CONSTANTS: BEGIN OF gc_param,
             modulo TYPE ztca_param_par-modulo VALUE 'SD',
             chave1 TYPE ztca_param_par-chave1 VALUE 'JOB_FATURAMENTO',
             chave2 TYPE ztca_param_par-chave2 VALUE 'INTERCOMPANY',
             chave3 TYPE ztca_param_par-chave3 VALUE 'FKART',
           END OF gc_param.

*-----------------------------------------------------------------------*
* Classe do Report
*-----------------------------------------------------------------------*
CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

    CLASS-METHODS:
      main,
      display_alv,
      on_user_command FOR EVENT added_function OF cl_salv_events
        IMPORTING e_salv_function,
      show_log.

  PRIVATE SECTION.

    CLASS-METHODS:
      clear,
      select_data,
      filter_freight_order,
      get_freight_order,
      process_data IMPORTING it_output TYPE ty_output_t,
      bdc_dynpro IMPORTING iv_program  TYPE bdc_prog
                           iv_dynpro   TYPE bdc_dynr
                           iv_dynbegin TYPE bdc_start OPTIONAL,
      bdc_fieldvalue IMPORTING iv_fnam TYPE fnam_____4
                               iv_fval TYPE bdc_fval.

ENDCLASS.

*-Screen parameters----------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_vbeln FOR vkdfs-vbeln,
                  s_tor_id FOR /scmtms/d_torrot-tor_id,
                  s_fkart FOR vkdfs-fkart,
                  s_fkdat FOR vkdfs-fkdat NO-EXTENSION.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-006.
  SELECT-OPTIONS: s_vkorg FOR vkdfs-vkorg,
                  s_vtweg FOR vkdfs-vtweg,
                  s_spart FOR vkdfs-spart,
                  s_vstel FOR vkdfs-vstel.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-007.
  SELECT-OPTIONS: s_kunnr FOR vkdfs-kunnr,
                  s_lland FOR vkdfs-lland,
                  s_sort FOR vkdfs-sortkri.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-005.
  PARAMETERS: p_allea LIKE vbco7-allea AS CHECKBOX,
              p_allel LIKE vbco7-allel AS CHECKBOX DEFAULT abap_true.
SELECTION-SCREEN END OF BLOCK b4.

*----------------------------------------------------------------------*
*START-OF-SELECTION.
*----------------------------------------------------------------------*
START-OF-SELECTION.
  lcl_report=>main( ).

*-----------------------------------------------------------------------*
* Classe do report
*-----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.

  METHOD main.

    clear( ).

    select_data( ).

    IF NOT sy-batch IS INITIAL.
      process_data( gt_output ).
    ELSE.
      IF NOT gt_output IS INITIAL.
        display_alv( ).
      ELSE.
        MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD clear.

    CLEAR gs_options.

    REFRESH: gt_output,
             gt_bdc,
             gt_msg,
             gt_log.

  ENDMETHOD.

  METHOD select_data.

    DATA: lt_lvkdfi       TYPE TABLE OF vkdfif,
          lt_intercompany TYPE TABLE OF ty_intercompany,
          lt_fkart        TYPE RANGE OF fkart.

    DATA ls_comwa TYPE vbco7.


    IF s_fkdat-low IS INITIAL.
      ls_comwa-fkdat = '00000000'.
    ELSE.
      ls_comwa-fkdat = s_fkdat-low.
    ENDIF.

    IF s_fkdat-high IS INITIAL AND
       s_fkdat-low IS INITIAL.
      ls_comwa-fkdat_bis = sy-datum.
    ELSE.
      ls_comwa-fkdat_bis = s_fkdat-high.
    ENDIF.

    ls_comwa-name_dazu = abap_true.
    ls_comwa-allel     = p_allel.
    ls_comwa-allea     = p_allea.

    IF NOT p_allel IS INITIAL.
      "Filtra remessas das ordens de frete informadas
      filter_freight_order( ).

      "Não encontrou nenhuma remessa x ordem de frete
      IF NOT s_tor_id[] IS INITIAL AND
         s_vbeln[] IS INITIAL.
        RETURN.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'RV_READ_INVOICE_INDEX'
      EXPORTING
        comwa       = ls_comwa
        opt_enabled = abap_true
      TABLES
        lvkdfi      = lt_lvkdfi
        s_kunnr     = s_kunnr
        s_vbeln     = s_vbeln
        s_lland     = s_lland
        s_fkart     = s_fkart
        s_sortkri   = s_sort
        s_vtweg     = s_vtweg
        s_spart     = s_spart
        s_vstel     = s_vstel.

    SORT lt_lvkdfi BY vbeln.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = gc_param-modulo
                                         iv_chave1 = gc_param-chave1
                                         iv_chave2 = gc_param-chave2
                                         iv_chave3 = gc_param-chave3
                               IMPORTING et_range  = lt_fkart ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    IF NOT p_allel IS INITIAL AND
       NOT lt_lvkdfi IS INITIAL.

      "Filtra remessas não processadas
      SELECT vbeln
        FROM likp
        INTO TABLE @DATA(lt_remessa)
        FOR ALL ENTRIES IN @lt_lvkdfi
        WHERE vbeln EQ @lt_lvkdfi-vbeln
          AND ( fkstk NE 'B' AND fkstk NE 'C' ).

      IF NOT lt_remessa IS INITIAL.
        SORT lt_remessa BY vbeln.
      ENDIF.

      LOOP AT lt_lvkdfi ASSIGNING FIELD-SYMBOL(<fs_lvkdfi>).
        DATA(lv_tabix) = sy-tabix.
        READ TABLE lt_remessa TRANSPORTING NO FIELDS WITH KEY vbeln = <fs_lvkdfi>-vbeln BINARY SEARCH.
        IF sy-subrc NE 0.
          DELETE lt_lvkdfi INDEX lv_tabix.
        ENDIF.
      ENDLOOP.

      "Filtra remessas com pedidos de compra - Intercompany
      DATA(lt_remessa_int) = lt_lvkdfi.
      DELETE lt_remessa_int WHERE fkart NOT IN lt_fkart.
      IF NOT lt_remessa_int IS INITIAL.
        SELECT a~vbelv, a~vbeln, b~bstkd
          FROM vbfa AS a
          INNER JOIN vbkd AS b ON a~vbelv = b~vbeln
                              AND a~vbtyp_n = 'J'
                              AND a~vbtyp_v = 'C'
          INTO TABLE @lt_intercompany
          FOR ALL ENTRIES IN @lt_remessa_int
          WHERE a~vbeln EQ @lt_remessa_int-vbeln
            AND b~bstkd NE @space
            AND b~bstkd NE '0000000000'.
        IF sy-subrc EQ 0.
          SORT lt_intercompany BY vbeln.
        ENDIF.
      ENDIF.

    ENDIF.

    SORT lt_lvkdfi BY vbeln.

    LOOP AT lt_lvkdfi ASSIGNING <fs_lvkdfi>.
      "Tratamento Intercompany
      IF <fs_lvkdfi>-fkart IN lt_fkart.
        READ TABLE lt_intercompany TRANSPORTING NO FIELDS WITH KEY vbeln = <fs_lvkdfi>-vbeln BINARY SEARCH.
        IF sy-subrc NE 0.
          CONTINUE.
        ENDIF.
      ENDIF.
      APPEND INITIAL LINE TO gt_output ASSIGNING FIELD-SYMBOL(<fs_output>).
      MOVE-CORRESPONDING <fs_lvkdfi> TO <fs_output>.
    ENDLOOP.

  ENDMETHOD.

  METHOD filter_freight_order.

    DATA lv_vbeln  TYPE vbeln_vl.

    DATA: lo_srv_mgr_tor  TYPE REF TO /bobf/if_tra_service_manager,
          lt_fo_root_key  TYPE /bobf/t_frw_key,
          lt_tor_root     TYPE /scmtms/t_tor_root_k,
          lt_tcc_root_key TYPE /bobf/t_frw_key,
          lt_assigned_fus TYPE /scmtms/t_tor_root_k.


    IF NOT s_tor_id IS INITIAL.

      SELECT db_key
        FROM /scmtms/d_torrot
        INTO TABLE @lt_fo_root_key
        WHERE tor_id  IN @s_tor_id
          AND tor_cat EQ 'TO'.
      IF sy-subrc EQ 0.

        lo_srv_mgr_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

        lo_srv_mgr_tor->retrieve(
                           EXPORTING
                             iv_node_key  = /scmtms/if_tor_c=>sc_node-root
                             it_key       = lt_fo_root_key
                             iv_fill_data = abap_true
                           IMPORTING
                             et_data      = lt_tor_root ).

        lo_srv_mgr_tor->retrieve_by_association(
                                      EXPORTING
                                        iv_node_key    = /scmtms/if_tor_c=>sc_node-root
                                        it_key         = lt_fo_root_key
                                        iv_association = /scmtms/if_tor_c=>sc_association-root-assigned_fus
                                        iv_edit_mode   = /bobf/if_conf_c=>sc_edit_read_only
                                      IMPORTING
                                        et_target_key  = lt_tcc_root_key ).

        lo_srv_mgr_tor->retrieve(
                           EXPORTING
                             iv_node_key  = /scmtms/if_tor_c=>sc_node-root
                             it_key       = lt_tcc_root_key
                             iv_fill_data = abap_true
                           IMPORTING
                             et_data      = lt_assigned_fus ).

        LOOP AT lt_assigned_fus ASSIGNING FIELD-SYMBOL(<fs_assigned_fus>).
          CASE <fs_assigned_fus>-base_btd_tco.
            WHEN '73'.
              CLEAR lv_vbeln.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <fs_assigned_fus>-base_btd_id
                IMPORTING
                  output = lv_vbeln.
              APPEND VALUE #( sign = 'I' option = 'EQ' low = lv_vbeln ) TO s_vbeln.
          ENDCASE.
        ENDLOOP.

      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD get_freight_order.

    DATA: lt_parameters  TYPE /bobf/t_frw_query_selparam,
          lt_tor_root    TYPE /scmtms/t_tor_root_k,
          lt_mod         TYPE /bobf/t_frw_modification,
          lt_tor_doc_ref TYPE /scmtms/t_tor_docref_k,
          lt_return      TYPE bapiret2_tab,
          ls_tor_doc_ref TYPE /scmtms/s_tor_docref_k,
          lo_srv_tor     TYPE REF TO /bobf/if_tra_service_manager,
          ls_parameter   TYPE /bobf/s_frw_query_selparam.


    lo_srv_tor = /bobf/cl_tra_serv_mgr_factory=>get_service_manager( /scmtms/if_tor_c=>sc_bo_key ).

    LOOP AT gt_output ASSIGNING FIELD-SYMBOL(<fs_output>).

      CLEAR ls_parameter.
      REFRESH: lt_parameters,
               lt_tor_root.

      APPEND INITIAL LINE TO lt_parameters ASSIGNING FIELD-SYMBOL(<fs_parameters>).
      <fs_parameters>-attribute_name =  /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-trq_base_btd_id.
      <fs_parameters>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
      <fs_parameters>-option         = /bobf/if_conf_c=>sc_sign_equal.
      <fs_parameters>-low            = <fs_output>-vbeln.
      APPEND INITIAL LINE TO lt_parameters ASSIGNING <fs_parameters>.
      <fs_parameters>-attribute_name = /scmtms/if_tor_c=>sc_query_attribute-root-planning_attributes-tor_cat.
      <fs_parameters>-sign           = /bobf/if_conf_c=>sc_sign_option_including.
      <fs_parameters>-option         = /bobf/if_conf_c=>sc_sign_equal.
      <fs_parameters>-low            = /scmtms/if_tor_const=>sc_tor_category-active.

      TRY.
          lo_srv_tor->query(
                  EXPORTING
                    iv_query_key            = /scmtms/if_tor_c=>sc_query-root-planning_attributes
                    it_selection_parameters = lt_parameters
                    iv_fill_data            = abap_true
                  IMPORTING
                    et_data                 = lt_tor_root ).

          TRY.
              <fs_output>-tor_id = lt_tor_root[ 1 ]-tor_id.
            CATCH cx_sy_itab_line_not_found.
          ENDTRY.

        CATCH /bobf/cx_frw_contrct_violation.
      ENDTRY.

    ENDLOOP.

  ENDMETHOD.

  METHOD process_data.

    DATA: lv_error_log TYPE xfeld VALUE abap_true,
          lv_message   TYPE t100-text.

    REFRESH gt_log.

    gs_options-dismode = 'N'.
    gs_options-updmode = 'S'.

    LOOP AT it_output ASSIGNING FIELD-SYMBOL(<fs_output>).

      REFRESH: gt_bdc,
               gt_msg.

      bdc_dynpro( EXPORTING iv_program = 'SAPMV60A'          iv_dynpro = '0102'  iv_dynbegin = abap_true ).
      bdc_fieldvalue( EXPORTING iv_fnam = 'BDC_CURSOR'       iv_fval = 'KOMFK-VBELN(01)' ).
      bdc_fieldvalue( EXPORTING iv_fnam = 'BDC_OKCODE'       iv_fval = '=SICH' ).
      bdc_fieldvalue( EXPORTING iv_fnam = 'KOMFK-VBELN(01)'  iv_fval = CONV #( <fs_output>-vbeln ) ).

      "Exporta a variável "lv_error_log" para a USEREXIT_SET_STATUS_VBUK (include RV45PFZA)
      "para exibir a mensagem de erro do log (caso não tenha efetivado o faturamento)
      EXPORT lv_error_log FROM lv_error_log TO MEMORY ID 'ZSDR_JOB_FATURAMENTO'.

      CALL TRANSACTION gc_vf01
                 USING gt_bdc
          OPTIONS FROM gs_options
         MESSAGES INTO gt_msg.

      LOOP AT gt_msg INTO DATA(ls_msg).

        CLEAR lv_message.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = ls_msg-msgid
            msgnr               = ls_msg-msgnr
            msgv1               = ls_msg-msgv1
            msgv2               = ls_msg-msgv2
            msgv3               = ls_msg-msgv3
            msgv4               = ls_msg-msgv4
          IMPORTING
            message_text_output = lv_message.

        APPEND VALUE #(
          remessa = <fs_output>-vbeln
          tipo_msg = ls_msg-msgtyp
          msg      = lv_message
                      ) TO gt_log.
      ENDLOOP.

    ENDLOOP.

    show_log( ).

  ENDMETHOD.

  METHOD display_alv.

    IF NOT p_allel IS INITIAL.
      "Busca a ordem de frete associada(s) a(s) remessa(s)
      get_freight_order( ).
    ENDIF.

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = go_alv
          CHANGING
            t_table      = gt_output.
      CATCH cx_salv_msg INTO DATA(lx_error).
        DATA(ls_message) = lx_error->get_message( ).
        MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno
          WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
    ENDTRY.

    "Define o Status GUI
    go_alv->set_screen_status(
      pfstatus      =  'ZSTANDARD_FULLSCREEN'
      report        =  sy-repid
      set_functions =  go_alv->c_functions_all ).

    "Deixa o ALV zebrado
    go_alv->get_display_settings( )->set_striped_pattern( abap_true ).

    "Ativa as funções
    go_alv->get_functions( )->set_all( abap_true ).
    go_events = go_alv->get_event(  ).
    SET HANDLER on_user_command FOR go_events.
    go_alv->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column ).

    "Define Layout
    DATA(lo_layout) = go_alv->get_layout( ).
    lo_layout->set_key( VALUE #( report = sy-repid ) ).
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_user_dependant ).
    lo_layout->set_default( abap_true ).

    "Otimiza as colunas
    DATA(lo_columns) = go_alv->get_columns( ).
    lo_columns->set_optimize( ).

    TRY.
        DATA(lo_column) = CAST cl_salv_column_table( lo_columns->get_column('TOR_ID') ).
        lo_column->set_long_text( value = CONV #( TEXT-008 ) ).
        lo_column->set_medium_text( value = CONV #( TEXT-008 ) ).
        lo_column->set_short_text( value = CONV #( TEXT-009 ) ).

      CATCH cx_salv_data_error INTO DATA(lx_salv_error1).
        ls_message = lx_salv_error1->get_message( ).
        MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno
          WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
      CATCH cx_salv_not_found INTO DATA(lx_error2).
        ls_message = lx_error2->get_message( ).
        MESSAGE ID ls_message-msgid TYPE 'E' NUMBER ls_message-msgno
          WITH ls_message-msgv1 ls_message-msgv2 ls_message-msgv3 ls_message-msgv4.
    ENDTRY.

    "Exibe Relatório ALV
    go_alv->display( ).


  ENDMETHOD.

  METHOD on_user_command.

    DATA lt_output TYPE ty_output_t.


    IF e_salv_function = 'ZPROCESS'.

      DATA(lt_rows) = go_alv->get_selections( )->get_selected_rows(  ).

      IF NOT lt_rows IS INITIAL.
        LOOP AT lt_rows ASSIGNING FIELD-SYMBOL(<fs_rows>).
          READ TABLE gt_output INDEX <fs_rows> ASSIGNING FIELD-SYMBOL(<fs_output>).
          IF sy-subrc = 0.
            APPEND <fs_output> TO lt_output.
          ENDIF.
        ENDLOOP.
      ELSE.
        lt_output = gt_output.
      ENDIF.

      process_data( lt_output ).

    ENDIF.

  ENDMETHOD.

  METHOD bdc_dynpro.

    APPEND VALUE #(
      program  = iv_program
      dynpro   = iv_dynpro
      dynbegin = iv_dynbegin
                  ) TO gt_bdc.

  ENDMETHOD.

  METHOD bdc_fieldvalue.

    APPEND VALUE #(
      fnam = iv_fnam
      fval = iv_fval
                  ) TO gt_bdc.

  ENDMETHOD.

  METHOD show_log.

    DATA: lo_log       TYPE REF TO cl_salv_table,
          lo_functions TYPE REF TO cl_salv_functions,
          lo_columns   TYPE REF TO cl_salv_columns_table,
          lo_column    TYPE REF TO cl_salv_column,
          lo_display   TYPE REF TO cl_salv_display_settings.


    IF NOT gt_log IS INITIAL.

      TRY.
          cl_salv_table=>factory(
                            EXPORTING
                              list_display = if_salv_c_bool_sap=>false
                            IMPORTING
                              r_salv_table = lo_log
                            CHANGING
                              t_table      = gt_log ).

          lo_columns = lo_log->get_columns( ).
          lo_columns->set_optimize( ).
          lo_column = lo_columns->get_column( columnname = 'REMESSA' ).
          lo_column->set_medium_text( value = CONV #( TEXT-002 ) ).
          lo_column->set_alignment( if_salv_c_alignment=>centered ).
          lo_column = lo_columns->get_column( columnname = 'TIPO_MSG' ).
          lo_column->set_short_text( value = CONV #( TEXT-003 ) ).
          lo_column->set_alignment( if_salv_c_alignment=>centered ).
          lo_column = lo_columns->get_column( columnname = 'MSG' ).
          lo_column->set_short_text( value = CONV #( TEXT-004 ) ).
        CATCH cx_salv_msg.
        CATCH cx_salv_not_found.
      ENDTRY.

      lo_display = lo_log->get_display_settings( ).
      lo_display->set_striped_pattern( cl_salv_display_settings=>true ).

      lo_functions = lo_log->get_functions( ).
      lo_functions->set_all( abap_true ).
      lo_log->display( ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
