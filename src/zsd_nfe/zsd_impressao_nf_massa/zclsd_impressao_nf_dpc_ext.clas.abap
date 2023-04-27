class ZCLSD_IMPRESSAO_NF_DPC_EXT definition
  public
  inheriting from ZCLSD_IMPRESSAO_NF_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~GET_STREAM
    redefinition .
protected section.

  methods DOWNLOADCHECKSET_GET_ENTITY
    redefinition .
  methods DOWNLOADCHECKSET_GET_ENTITYSET
    redefinition .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLSD_IMPRESSAO_NF_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~get_stream.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key_tab   TYPE ty_t_key_tab,
          ls_header    TYPE ihttpnvp,
          ls_stream    TYPE ty_s_media_resource.

    lt_key_tab = it_key_tab[].

    CASE iv_entity_name.

* ----------------------------------------------------------------------
* Entidade responsável pelo envio do binário do arquivo
* ----------------------------------------------------------------------
      WHEN gc_entity-download.

        TRY.
            DATA(lv_docnum)  = VALUE string( lt_key_tab[ name = gc_name-docnum ]-value ).
            DATA(lv_doctype) = VALUE string( lt_key_tab[ name = gc_name-doctype ]-value ).
          CATCH cx_root.
        ENDTRY.

        " Recupera PDF da nota fiscal
        DATA(lo_impressao) = NEW zclsd_nf_mass_download( ).
        lo_impressao->gera_pdf( EXPORTING iv_docnum   = lv_docnum
                                          iv_doctype  = lv_doctype
                                IMPORTING ev_filename = DATA(lv_filename)
                                          ev_file     = DATA(lv_file)
                                          et_return   = DATA(lt_return) ).

* ----------------------------------------------------------------------
* Muda nome do arquivo
* ----------------------------------------------------------------------
* Tipo comportamento:
* - inline: Não fará download automático
* - outline: Download automático
* ----------------------------------------------------------------------
        ls_header-name  = |Content-Disposition|.
        ls_header-value = |outline; filename="{ lv_filename }";|.

        set_header( is_header = ls_header ).

* ----------------------------------------------------------------------
* Retorna binário do PDF
* ----------------------------------------------------------------------
        ls_stream-mime_type = 'application/pdf'.
        ls_stream-value     = lv_file.

        copy_data_to_ref( EXPORTING is_data = ls_stream
                          CHANGING  cr_data = er_stream ).

      WHEN OTHERS.
    ENDCASE.

** ----------------------------------------------------------------------
** Ativa exceção em casos de erro
** ----------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'E' ] ).
      lo_message = mo_context->get_message_container( ).
      lo_message->add_messages_from_bapi( it_bapi_messages = lt_return ).
      CREATE OBJECT lo_exception EXPORTING message_container = lo_message.
      RAISE EXCEPTION lo_exception.
    ENDIF.

  ENDMETHOD.


  METHOD downloadcheckset_get_entity.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception,
          lt_key_tab   TYPE ty_t_key_tab.

    lt_key_tab = it_key_tab[].

    CASE iv_entity_name.

* ----------------------------------------------------------------------
* Entidade para verificar se arquivo de download existe
* ----------------------------------------------------------------------
      WHEN gc_entity-downloadcheck.

        TRY.
            DATA(lv_docnum)  = VALUE string( lt_key_tab[ name = gc_name-docnum ]-value ).
            DATA(lv_doctype) = VALUE string( lt_key_tab[ name = gc_name-doctype ]-value ).
          CATCH cx_root.
        ENDTRY.

        " Recupera PDF da nota fiscal
        DATA(lo_impressao) = NEW zclsd_nf_mass_download( ).
        lo_impressao->gera_pdf( EXPORTING iv_docnum   = lv_docnum
                                          iv_doctype  = lv_doctype
                                IMPORTING ev_file     = DATA(lv_file)
                                          et_return   = DATA(lt_return) ).

      WHEN OTHERS.
    ENDCASE.

    er_entity-docnum   = lv_docnum.
    er_entity-doctype  = lv_doctype.
    er_entity-mimetype = 'application/pdf'.
    er_entity-value    = lv_file.

  ENDMETHOD.


  METHOD downloadcheckset_get_entityset.
**TRY.
*CALL METHOD SUPER->DOWNLOADCHECKSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA: lo_message   TYPE REF TO /iwbep/if_message_container,
          lo_exception TYPE REF TO /iwbep/cx_mgw_busi_exception.

    CASE iv_entity_name.

      WHEN gc_entity-downloadcheck.
        DATA(lo_impressao) = NEW zclsd_nf_mass_download( ).

        IF it_filter_select_options IS INITIAL.

          lo_impressao->set_filter_str(
                  EXPORTING
                     iv_filter_string = iv_filter_string
                  IMPORTING
                     et_filter_select_options = DATA(lt_filter_select_options)  ).
        ELSE.
          lt_filter_select_options = it_filter_select_options.
        ENDIF.



        LOOP AT lt_filter_select_options ASSIGNING FIELD-SYMBOL(<fs_select_options>).
          READ TABLE  <fs_select_options>-select_options ASSIGNING FIELD-SYMBOL(<fs_docnum>) INDEX 1.

          IF sy-subrc = 0.

*---------->NF-E
            lo_impressao->gera_pdf( EXPORTING iv_docnum   = <fs_docnum>-low
                                              iv_doctype  = 1
                                    IMPORTING ev_file     = DATA(lv_file)
                                              et_return   = DATA(lt_return) ).


            APPEND VALUE #(  docnum   = <fs_docnum>-low
                             doctype  = 1
                             mimetype = 'application/pdf'
                             value    = lv_file ) TO et_entityset.
            CLEAR:lv_file.


*---------->CC-E
            lo_impressao->gera_pdf( EXPORTING iv_docnum   = <fs_docnum>-low
                                              iv_doctype  = 2
                                    IMPORTING ev_file     = lv_file
                                              et_return   = lt_return ).


            APPEND VALUE #(  docnum   = <fs_docnum>-low
                             doctype  = 2
                             mimetype = 'application/pdf'
                             value    = lv_file ) TO et_entityset.
            CLEAR:lv_file.




*---------->BOLETO
            lo_impressao->gera_pdf( EXPORTING iv_docnum   = <fs_docnum>-low
                                              iv_doctype  = 3
                                    IMPORTING ev_file     = lv_file
                                              et_return   = lt_return ).

            APPEND VALUE #(  docnum   = <fs_docnum>-low
                             doctype  = 3
                             mimetype = 'application/pdf'
                             value    = lv_file ) TO et_entityset.
            CLEAR:lv_file.

*---------->MDF-E
            lo_impressao->gera_pdf( EXPORTING iv_docnum   = <fs_docnum>-low
                                              iv_doctype  = 4
                                    IMPORTING ev_file     = lv_file
                                              et_return   = lt_return ).

            APPEND VALUE #(  docnum   = <fs_docnum>-low
                             doctype  = 4
                             mimetype = 'application/pdf'
                             value    = lv_file ) TO et_entityset.
            CLEAR:lv_file.

          ENDIF.
        ENDLOOP.

      WHEN OTHERS.
    ENDCASE.


  ENDMETHOD.
ENDCLASS.
