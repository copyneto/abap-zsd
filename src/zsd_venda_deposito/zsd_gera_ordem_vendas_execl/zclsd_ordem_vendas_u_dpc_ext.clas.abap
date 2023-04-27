class ZCLSD_ORDEM_VENDAS_U_DPC_EXT definition
  public
  inheriting from ZCLSD_ORDEM_VENDAS_U_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_STREAM
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZCLSD_ORDEM_VENDAS_U_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_stream.

    DATA: lt_arquivo TYPE TABLE OF zssd_arq_ordvend.

    DATA: ls_entity TYPE zssd_gateway_upload.

    DATA(lo_preenche_tabelas) = NEW zclsd_preenche_tabelas( ).

*    DATA: ls_file TYPE ypoc_excel.

    DATA: lv_filetype TYPE ze_producao_filetype,
          lv_nome_arq TYPE rsfilenm,
          lv_guid     TYPE guid_16.

    DATA lv_mime_type TYPE char100 VALUE 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'.

    IF is_media_resource-mime_type = lv_mime_type.

      SPLIT iv_slug AT ';' INTO lv_nome_arq lv_filetype.

      TRY.
          lv_guid = cl_system_uuid=>create_uuid_x16_static( ).
        CATCH cx_uuid_error.
      ENDTRY.

      lo_preenche_tabelas->converte_xstring_para_it(
        EXPORTING
          iv_xstring  = is_media_resource-value
          iv_nome_arq = lv_nome_arq
        CHANGING
          ct_tabela   = lt_arquivo
      ).

      IF lt_arquivo IS NOT INITIAL.
        lo_preenche_tabelas->insert_ztsd_arq_ordvend( iv_guid = lv_guid it_tabela = lt_arquivo ).
      ENDIF.

      ls_entity-filename     = lv_nome_arq.
      ls_entity-mimetype     = is_media_resource-mime_type.
      ls_entity-type_message = 'S'.

    ELSE.

      ls_entity-filename     = lv_nome_arq.
      ls_entity-mimetype     = is_media_resource-mime_type.
      ls_entity-type_message = 'E'.

    ENDIF.

    copy_data_to_ref( EXPORTING is_data = ls_entity
                      CHANGING  cr_data = er_entity ).

  ENDMETHOD.
ENDCLASS.
