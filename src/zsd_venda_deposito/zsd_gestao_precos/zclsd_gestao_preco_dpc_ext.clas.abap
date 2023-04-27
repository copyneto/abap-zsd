CLASS zclsd_gestao_preco_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclsd_gestao_preco_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_gestao_preco_dpc_ext IMPLEMENTATION.

  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_stream    TYPE ty_s_media_resource,
          ls_lheader   TYPE ihttpnvp.

    TRY.
        DATA(lv_tablename) = CONV tablename( it_key_tab[ name = gc_fields-tablename ]-value ). "#EC CI_STDSEQ
      CATCH cx_root.
    ENDTRY.

    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

* ----------------------------------------------------------------------
* Gerencia Botão do aplicativo "Baixar layout"
* ----------------------------------------------------------------------
    CASE iv_entity_name.

      WHEN gc_entity-layout.

        lo_events->get_layout( EXPORTING iv_tablename = lv_tablename
                               IMPORTING ev_file      = DATA(lv_file)
                                         ev_filename  = DATA(lv_filename)
                                         ev_mimetype  = DATA(lv_mimetype)
                                         et_return    = DATA(lt_return) ).

    ENDCASE.


* ----------------------------------------------------------------------
* Retorna binário do arquivo
* ----------------------------------------------------------------------
    ls_stream-mime_type = lv_mimetype.
    ls_stream-value     = lv_file.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline : Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_lheader-name  = |Content-Disposition| ##NO_TEXT.
    ls_lheader-value = |outline; filename="{ lv_filename }";| ##NO_TEXT.

    set_header( is_header = ls_lheader ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF lt_return[] IS NOT INITIAL.
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    TYPES: BEGIN OF ty_entity,
             tablename TYPE string,
             message   TYPE string,
           END OF ty_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_entity    TYPE ty_entity,
          lv_filename  TYPE string,
          lv_tablename TYPE tablename.

    DATA(lo_events) = NEW zclsd_gestao_preco_events( ).

    SPLIT iv_slug AT ';' INTO lv_filename lv_tablename.

    CASE iv_entity_name.
* ----------------------------------------------------------------------
* Gerencia Botão do aplicativo "Carga de Preço"
* ----------------------------------------------------------------------
      WHEN gc_entity-upload_price.
        lo_events->upload_file( EXPORTING iv_tablename = lv_tablename
                                          iv_file      = is_media_resource-value
                                          iv_filename  = lv_filename
                                IMPORTING et_return    = DATA(lt_return) ).
    ENDCASE.

    TRY.
        ls_entity-Tablename = lv_tablename.
        ls_entity-Message   = lt_return[ 1 ]-Message.
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Prepara informações de retorno
* ----------------------------------------------------------------------
    copy_data_to_ref( EXPORTING is_data = ls_entity
                      CHANGING  cr_data = er_entity ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'S' ] ).       "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


ENDCLASS.
