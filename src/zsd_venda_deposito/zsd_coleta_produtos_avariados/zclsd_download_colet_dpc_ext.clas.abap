CLASS zclsd_download_colet_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zclsd_download_colet_dpc
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS /iwbep/if_mgw_appl_srv_runtime~get_stream
        REDEFINITION .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_download_colet_dpc_ext IMPLEMENTATION.
  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.
    CONSTANTS lc_download  TYPE string VALUE 'download' ##NO_TEXT.
    CONSTANTS lc_salesorder  TYPE string VALUE 'SalesOrder' ##NO_TEXT.
    IF iv_entity_name = lc_download.
      DATA(lv_salesorder) = VALUE vbeln( it_key_tab[ name = lc_SalesOrder ]-value OPTIONAL ). "#EC CI_STDSEQ
      IF lv_salesorder IS INITIAL.
        RETURN.
      ENDIF.

      DATA(lv_filename) = |coleta_avaria_doc_{ lv_salesorder }.pdf|.
      set_header( VALUE #(
        name  = |Content-Disposition| ##NO_TEXT
        value = |outline; filename="{ lv_filename }";|
      ) ).

      DATA lv_file TYPE xstring.
      DATA ls_stream    TYPE ty_s_media_resource.
      ls_stream-mime_type = 'application/pdf'.
*      ls_stream-value     = NEW zclsd_form_coleta_avaria( )->execute( lv_salesorder ).

      copy_data_to_ref( EXPORTING is_data = ls_stream
                        CHANGING  cr_data = er_stream ).
    ENDIF.

*    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
*          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
*          ls_header    TYPE ihttpnvp,
*          ls_stream    TYPE ty_s_media_resource.
*
*    CASE iv_entity_name.
*
** ----------------------------------------------------------------------
** Entidade responsável pelo envio do binário do arquivo
** ----------------------------------------------------------------------
*      WHEN gc_entity-download.
*
*        TRY.
*            DATA(lv_docnum)  = VALUE string( it_key_tab[ name = gc_name-docnum ]-value ). "#EC CI_STDSEQ
*            DATA(lv_doctype) = VALUE string( it_key_tab[ name = gc_name-doctype ]-value ). "#EC CI_STDSEQ
*          CATCH cx_root.
*        ENDTRY.
*
*        " Recupera PDF da nota fiscal
*        DATA(lo_impressao) = NEW zclsd_nf_mass_download( ).
*        lo_impressao->gera_pdf( EXPORTING iv_docnum   = lv_docnum
*                                          iv_doctype  = lv_doctype
*                                IMPORTING ev_filename = DATA(lv_filename)
*                                          ev_file     = DATA(lv_file)
*                                          et_return   = DATA(lt_return) ).
*
** ----------------------------------------------------------------------
** Muda nome do arquivo
** ----------------------------------------------------------------------
** Tipo comportamento:
** - inline: Não fará download automático
** - outline: Download automático
** ----------------------------------------------------------------------
*        ls_header-name  = |Content-Disposition| ##NO_TEXT.
*        ls_header-value = |outline; filename="{ lv_filename }";|.
*
*        set_header( is_header = ls_header ).
*
** ----------------------------------------------------------------------
** Retorna binário do PDF
** ----------------------------------------------------------------------
*        ls_stream-mime_type = 'application/pdf'.
*        ls_stream-value     = lv_file.
*
*        copy_data_to_ref( EXPORTING is_data = ls_stream
*                          CHANGING  cr_data = er_stream ).
*
*      WHEN OTHERS.
*    ENDCASE.
*
*** ----------------------------------------------------------------------
*** Ativa exceção em casos de erro
*** ----------------------------------------------------------------------
*    IF line_exists( lt_return[ type = 'E' ] ).           "#EC CI_STDSEQ
*      lo_message = mo_context->get_message_container( ).
*      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
*      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
*      RAISE EXCEPTION lo_exception.
*    ENDIF.
  ENDMETHOD.
ENDCLASS.
