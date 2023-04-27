CLASS zclsd_cockpit_agenda_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclsd_cockpit_agenda_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~create_stream
        REDEFINITION.

    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_cockpit_agenda_dpc_ext IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t.

    DATA(lo_manual) = NEW zclsd_cockpit_agenda_events( ).

* ----------------------------------------------------------------------
* Recupera chave
* ----------------------------------------------------------------------
    DATA(lt_headers)  = io_tech_request_context->get_request_headers( ).

    TRY.
        DATA(lv_guid_raw) = VALUE #( lt_headers[ name = 'guid' ]-value OPTIONAL ). "#EC CI_STDSEQ
        DATA(lv_guid)     = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_guid_raw ).
      CATCH cx_root.
    ENDTRY.

* ----------------------------------------------------------------------
* Adiciona arquivo no DMS
* ----------------------------------------------------------------------
    lo_manual->upload_file( EXPORTING iv_file     = is_media_resource-value
                                      iv_filename = iv_slug
                            IMPORTING et_agenda   = DATA(lt_agenda)
                                      et_return   = lt_return ).

    copy_data_to_ref( EXPORTING is_data = is_media_resource
                      CHANGING  cr_data = er_entity ).

* ----------------------------------------------------------------------
* Ativa exceção em casos de erro
* ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages          = lt_return
                                          iv_add_to_response_header = abap_true ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource.

    TRY.
        DATA(lv_guid_raw) = VALUE #( it_key_tab[ name = gc_fields-guid ]-value ). "#EC CI_STDSEQ
        DATA(lv_guid)     = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( lv_guid_raw ).
      CATCH cx_root.
    ENDTRY.

    DATA(lo_events) = NEW zclsd_cockpit_agenda_events( ).

    lo_events->get_layout( IMPORTING ev_file     = DATA(lv_file)
                                     ev_filename = DATA(lv_filename)
                                     ev_mimetype = DATA(lv_mimetype)
                                     et_return   = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
    ls_header-name  = |Content-Disposition| ##NO_TEXT.
    ls_header-value = |outline; filename="{ lv_filename }";|.

    set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
    ls_stream-mime_type = lv_mimetype.
    ls_stream-value     = lv_file.

    copy_data_to_ref( EXPORTING is_data = ls_stream
                      CHANGING  cr_data = er_stream ).

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
