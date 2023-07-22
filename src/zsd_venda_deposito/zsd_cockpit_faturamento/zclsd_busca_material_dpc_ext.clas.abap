class ZCLSD_BUSCA_MATERIAL_DPC_EXT definition
  public
  inheriting from ZCLSD_BUSCA_MATERIAL_DPC
  create public .

public section.
protected section.

  methods BUSCAMATERIALSET_GET_ENTITY
    redefinition .
  methods BUSCAMATERIALSET_GET_ENTITYSET
    redefinition .
  methods BUSCAMATERIANFSE_GET_ENTITYSET
    redefinition .
  methods BUSCAMATERIANFSE_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCLSD_BUSCA_MATERIAL_DPC_EXT IMPLEMENTATION.


  METHOD buscamaterialset_get_entity.

    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = text-001 ]-value DEFAULT ' ' ).

    IF lv_vbeln IS NOT INITIAL.
      SELECT SINGLE * FROM vbap INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = lv_vbeln.
    ENDIF.

  ENDMETHOD.


  METHOD buscamaterialset_get_entityset.

    DATA: lr_vbeln     TYPE RANGE OF vbeln_va.
    DATA: lo_msg       TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.
    DATA: ls_msg       TYPE bapiret2.
    DATA: lt_msg       TYPE bapiret2_t.

    IF line_exists( it_filter_select_options[ 1 ] ).
      DATA(lt_filters) = it_filter_select_options[ 1 ]-select_options.
    ENDIF.

    IF lt_filters[] IS INITIAL.
      TRY.
          DATA(lr_filter) = cl_clb2_tools=>odata_filter2select_option( EXPORTING iv_filter_string = iv_filter_string ).
          IF line_exists( lr_filter[ 1 ] ).
            lt_filters = lr_filter[ 1 ]-select_options.
          ENDIF.
        CATCH cx_clb2_parse INTO DATA(lo_message).
          DATA(lv_message) = lo_message->get_text( ).
      ENDTRY.
    ENDIF.


    IF lt_filters IS NOT INITIAL.

      LOOP AT lt_filters ASSIGNING FIELD-SYMBOL(<fs_filter>).
        APPEND VALUE #( sign = 'I'
                        option = 'EQ'
                        low = |{ <fs_filter>-low ALPHA = IN }|
                        high = |{ <fs_filter>-high ALPHA = IN }| ) TO lr_vbeln.
      ENDLOOP.

      CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
                 lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
                 lc_chave2 TYPE ztca_param_par-chave2 VALUE 'STATUS_GLOBAL_OV',
                 lc_chave3 TYPE ztca_param_par-chave3 VALUE ''.

** Seleçao dos parametros
      DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
      DATA: lr_gbsta   TYPE RANGE OF gbsta.
      CLEAR: lr_gbsta .

*Buscar Tipo de Ordem Saída
      TRY.
          lo_parametros->m_get_range(
            EXPORTING
              iv_modulo = lc_modulo
              iv_chave1 = lc_chave1
              iv_chave2 = lc_chave2
              iv_chave3 = lc_chave3
            IMPORTING
              et_range  = lr_gbsta ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.


      IF lr_vbeln IS NOT INITIAL.
        SELECT matnr, werks, lgort
          INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          FROM vbap
          WHERE vbeln IN @lr_vbeln
            AND abgru EQ @space
            AND gbsta NOT IN @lr_gbsta .

        SORT et_entityset BY matnr werks lgort.
        DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING matnr werks lgort.

      ENDIF.


    ENDIF.
    IF et_entityset[] IS INITIAL.

      ls_msg-id     = 'ZSD_CKPT_FATURAMENTO'.
      ls_msg-number = '015'.
      ls_msg-type   = 'E'.
      APPEND ls_msg TO lt_msg.
      CLEAR  ls_msg.
      lo_msg = mo_context->get_message_container( ).
      lo_msg->add_messages_from_bapi( it_bapi_messages = lt_msg ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_msg.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  method BUSCAMATERIANFSE_GET_ENTITY.

    DATA(lv_vbeln) = VALUE #( it_key_tab[ name = text-001 ]-value DEFAULT ' ' ).

    IF lv_vbeln IS NOT INITIAL.
      SELECT SINGLE * FROM vbap INTO CORRESPONDING FIELDS OF er_entity WHERE vbeln = lv_vbeln.
    ENDIF.


  endmethod.


  METHOD buscamaterianfse_get_entityset.

    DATA: lr_vbeln     TYPE RANGE OF vbeln_va.
    DATA: lo_msg       TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.
    DATA: ls_msg       TYPE bapiret2.
    DATA: lt_msg       TYPE bapiret2_t.

    IF line_exists( it_filter_select_options[ 1 ] ).
      DATA(lt_filters) = it_filter_select_options[ 1 ]-select_options.
    ENDIF.

    IF lt_filters[] IS INITIAL.
      TRY.
          DATA(lr_filter) = cl_clb2_tools=>odata_filter2select_option( EXPORTING iv_filter_string = iv_filter_string ).
          IF line_exists( lr_filter[ 1 ] ).
            lt_filters = lr_filter[ 1 ]-select_options.
          ENDIF.
        CATCH cx_clb2_parse INTO DATA(lo_message).
          DATA(lv_message) = lo_message->get_text( ).
      ENDTRY.
    ENDIF.


    IF lt_filters IS NOT INITIAL.

      LOOP AT lt_filters ASSIGNING FIELD-SYMBOL(<fs_filter>).
        APPEND VALUE #( sign = 'I'
                        option = 'EQ'
                        low = |{ <fs_filter>-low ALPHA = IN }|
                        high = |{ <fs_filter>-high ALPHA = IN }| ) TO lr_vbeln.
      ENDLOOP.

      CONSTANTS: lc_modulo TYPE ztca_param_mod-modulo VALUE 'SD',
                 lc_chave1 TYPE ztca_param_par-chave1 VALUE 'ADM_FATURAMENTO',
                 lc_chave2 TYPE ztca_param_par-chave2 VALUE 'STATUS_GLOBAL_OV',
                 lc_chave3 TYPE ztca_param_par-chave3 VALUE ''.

** Seleçao dos parametros
      DATA(lo_parametros) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
      DATA: lr_gbsta   TYPE RANGE OF gbsta.
      CLEAR: lr_gbsta .

*Buscar Tipo de Ordem Saída
      TRY.
          lo_parametros->m_get_range(
            EXPORTING
              iv_modulo = lc_modulo
              iv_chave1 = lc_chave1
              iv_chave2 = lc_chave2
              iv_chave3 = lc_chave3
            IMPORTING
              et_range  = lr_gbsta ).
        CATCH zcxca_tabela_parametros.
          "handle exception
      ENDTRY.


      IF lr_vbeln IS NOT INITIAL.
        SELECT a~matnr, a~werks, a~lgort, b~centrodepfechado
          INTO CORRESPONDING FIELDS OF TABLE @et_entityset
          FROM vbap AS a
          LEFT OUTER JOIN ztsd_centrofatdf AS b
          ON a~werks = b~centrofaturamento
          WHERE vbeln IN @lr_vbeln
            AND abgru EQ @space
            AND gbsta NOT IN @lr_gbsta .

        SORT et_entityset BY matnr werks lgort.
        DELETE ADJACENT DUPLICATES FROM et_entityset COMPARING matnr werks lgort.

      ENDIF.


    ENDIF.
    IF et_entityset[] IS INITIAL.

      ls_msg-id     = 'ZSD_CKPT_FATURAMENTO'.
      ls_msg-number = '015'.
      ls_msg-type   = 'E'.
      APPEND ls_msg TO lt_msg.
      CLEAR  ls_msg.
      lo_msg = mo_context->get_message_container( ).
      lo_msg->add_messages_from_bapi( it_bapi_messages = lt_msg ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_msg.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
