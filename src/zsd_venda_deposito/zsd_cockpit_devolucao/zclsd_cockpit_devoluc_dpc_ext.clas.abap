class ZCLSD_COCKPIT_DEVOLUC_DPC_EXT definition
  public
  inheriting from ZCLSD_COCKPIT_DEVOLUC_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_COCKPIT_DEVOLUC_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.
    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lv_filename  TYPE string,
          lv_guid      TYPE string.

* ----------------------------------------------------------------------
* Recupera ID
* ----------------------------------------------------------------------
    SPLIT iv_slug AT ';' INTO lv_filename
                              lv_guid.



* ----------------------------------------------------------------------
* Salva arquivo
* ----------------------------------------------------------------------
    zclsd_cockpit_devolucao_anexo=>save_file( EXPORTING iv_guid     = lv_guid
                                                        iv_filename = lv_filename
                                                        iv_mimetype = is_media_resource-mime_type
                                                        iv_value    = is_media_resource-value
                                          IMPORTING es_arq_dev  = DATA(ls_arquivo)
                                                    et_return   = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Prepara informações de retorno
* ----------------------------------------------------------------------
    copy_data_to_ref( EXPORTING is_data = ls_arquivo
                      CHANGING  cr_data = er_entity ).

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


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_return    TYPE bapiret2_t,
          ls_stream    TYPE ty_s_media_resource,
          ls_lheader   TYPE ihttpnvp,
          lv_filename  TYPE string,
          lv_file      TYPE xstring,
          lv_mimetype  TYPE w3conttype,
          lv_extension TYPE char40.

    CASE iv_entity_set_name.

* ===========================================================================
* Gerencia Botão do aplicativo "Baixar" e "Exibir PDF"
* ===========================================================================
      WHEN gc_entity-file OR
           gc_entity-fileshow.

        TRY.
            DATA(lv_guid)  = CONV string( it_key_tab[ name = gc_fields-guid ]-value ). "#EC CI_STDSEQ
            DATA(lv_line)  = CONV integer( it_key_tab[ name = gc_fields-line ]-value ). "#EC CI_STDSEQ
          CATCH cx_root.
        ENDTRY.

* ----------------------------------------------------------------------
* Recupera arquivo
* ----------------------------------------------------------------------
        zclsd_cockpit_devolucao_anexo=>get_file( EXPORTING iv_guid              = lv_guid
                                                           iv_line              = lv_line
                                                           iv_showfile          = iv_entity_set_name
                                                 IMPORTING ev_filename          = lv_filename
                                                           ev_mimetype          = lv_mimetype
                                                           ev_value             = lv_file
                                                           et_return            = lt_return ).

      WHEN OTHERS.
        RETURN.

    ENDCASE.

* ----------------------------------------------------------------------
* Retorna binário do arquivo
* ----------------------------------------------------------------------
    SPLIT lv_filename AT '.' INTO DATA(lv_name) lv_extension.

    CALL FUNCTION 'SDOK_MIMETYPE_GET'
      EXPORTING
        extension = lv_extension
      IMPORTING
        mimetype  = lv_mimetype.

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

    CASE iv_entity_set_name.
      WHEN gc_entity-file.
        ls_lheader-value = |outline; filename="{ lv_filename }";| ##NO_TEXT.
      WHEN gc_entity-fileshow.
        ls_lheader-value = |inline; filename="{ lv_filename }";| ##NO_TEXT.
      WHEN OTHERS.
    ENDCASE.

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
ENDCLASS.
