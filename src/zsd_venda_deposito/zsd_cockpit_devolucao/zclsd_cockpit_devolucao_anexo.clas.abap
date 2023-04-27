"!<p><h1>Solicitação para Novos Projetos e PEP: Gerencia lógica dos serviços gateway</h1></p>
"!<p><strong>Autor:</strong>Jong Wan Silva</p>
"!<p><strong>Data:</strong>03 de setembro de 2021</p>
CLASS zclsd_cockpit_devolucao_anexo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Salva arquivo na tabela do banco de dados
    "! @parameter iv_filename | Nome do arquivo
    "! @parameter iv_mimetype | Tipo do arquivo
    "! @parameter iv_value | Conteúdo do arquivo em binário
    "! @parameter es_arq_dev | Estrutura de retorno com os dados do arquivo
    "! @parameter et_return | Tabela de retorno
    CLASS-METHODS save_file
      IMPORTING
        !iv_filename TYPE string
        !iv_mimetype TYPE string
        !iv_value    TYPE xstring
        !iv_guid     TYPE any
      EXPORTING
        !es_arq_dev  TYPE ztsd_anexo_dev
        !et_return   TYPE bapiret2_t .
    "! Recupera arquivo do banco de dados
    "! @parameter iv_line | Número do arquivo
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_mimetype | Tipo do arquivo
    "! @parameter ev_value | Conteúdo do arquivo em binário
    "! @parameter et_return | Tabela de retorno
    CLASS-METHODS get_file
      IMPORTING
        !iv_guid     TYPE any
        !iv_line     TYPE integer
        !iv_showfile TYPE string OPTIONAL
      EXPORTING
        !ev_filename TYPE any
        !ev_mimetype TYPE any
        !ev_value    TYPE xstring
        !et_return   TYPE bapiret2_t .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclsd_cockpit_devolucao_anexo IMPLEMENTATION.


  METHOD get_file.
* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_FILE' FOR USER sy-uname
      ID 'ACTVT' FIELD '03'.    "Criar

    IF sy-subrc IS INITIAL.
* ======================================================================
* Recupera arquivo solicitado via serviço
* ======================================================================

    DATA: ls_arquivo TYPE  ztsd_anexo_dev.

    FREE: ev_filename, ev_mimetype, ev_value, et_return.

* ---------------------------------------------------------------------------
* Recupera arquivo
* ---------------------------------------------------------------------------

    DATA(lv_guid) = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( iv_guid ).

    ls_arquivo-guid = lv_guid.
    ls_arquivo-line = iv_line.

    SELECT SINGLE *
        FROM ztsd_anexo_dev
        INTO ls_arquivo
        WHERE guid  =  ls_arquivo-guid
          AND line  =  ls_arquivo-line.       "#EC CI_ALL_FIELDS_NEEDED

    IF sy-subrc NE 0.
      " Nenhum arquivo encontrado
      et_return = VALUE #( ( type       = 'E'
                             id         = 'ZSD_COCKPIT_DEVOL'
                             number     = '006' ) ).
      RETURN.
    ENDIF.

    ev_filename = ls_arquivo-filename.
    ev_mimetype = ls_arquivo-mimetype.
    ev_value    = ls_arquivo-value.

    IF iv_showfile = TEXT-001 AND ls_arquivo-mimetype NE TEXT-002 .
      "Ação permitida apenas para aquivos PDF.
      et_return = VALUE #( ( type       = 'E'
                             id         = 'ZSD_COCKPIT_DEVOL'
                             number     = '017' ) ).

    ENDIF.


    ELSE.

      et_return = VALUE #( (     type     = 'E'
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'  ) ).

    ENDIF.

  ENDMETHOD.


  METHOD save_file.

* Verificando a Autorização do User!
    AUTHORITY-CHECK OBJECT 'ZDEV_ANEXA' FOR USER sy-uname
      ID 'ACTVT' FIELD '01'.    "Criar

    IF sy-subrc IS INITIAL.
* ======================================================================
* Salva arquivo enviado via serviço
* ======================================================================

      DATA: ls_arquivo TYPE  ztsd_anexo_dev.

      FREE: es_arq_dev, et_return.

* ---------------------------------------------------------------------------
* Verifica se solicitação existe
* ---------------------------------------------------------------------------

      DATA(lv_guid) = cl_soap_wsrmb_helper=>convert_uuid_hyphened_to_raw( iv_guid ).

      SELECT SINGLE local_negocio, tipo_devolucao, regiao, ano, mes, cnpj, modelo, serie, numero_nfe, digito_verific
          FROM ztsd_devolucao
          INTO @DATA(ls_devolucao)
          WHERE guid =  @lv_guid.

      IF sy-subrc NE 0.
        " Devolução não encontrada.
        et_return = VALUE #( ( type       = 'E'
                               id         = 'ZSD_COCKPIT_DEVOL'
                               number     = '004' ) ).
        RETURN.
      ENDIF.

* ---------------------------------------------------------------------------
* Prepara arquivo
* ---------------------------------------------------------------------------

      SELECT *
          FROM ztsd_anexo_dev
         INTO TABLE @DATA(lt_anexo)
          WHERE guid =  @lv_guid.             "#EC CI_ALL_FIELDS_NEEDED

      DATA(lv_count) = lines( lt_anexo ).
      MOVE-CORRESPONDING ls_devolucao TO ls_arquivo.
      ls_arquivo-guid         = lv_guid.
      ls_arquivo-line         = lv_count + 1.
      ls_arquivo-filename     = iv_filename.
      ls_arquivo-mimetype     = iv_mimetype.
      ls_arquivo-value        = iv_value.
      ls_arquivo-created_by   = sy-uname.
      GET TIME STAMP FIELD ls_arquivo-created_at.

* ---------------------------------------------------------------------------
* Salva arquivo
* ---------------------------------------------------------------------------
      IF ls_arquivo IS NOT INITIAL.
        MODIFY ztsd_anexo_dev FROM ls_arquivo.

        IF sy-subrc NE 0.
          " Falha ao salvar arquivo &1.
          et_return = VALUE #( ( type       = 'E'
                                 id         = 'ZSD_COCKPIT_DEVOL'
                                 number     = '005'
                                 message_v1 = iv_filename ) ).
          RETURN.
        ENDIF.

      ENDIF.

      es_arq_dev = ls_arquivo.

    ELSE.

      et_return = VALUE #( (     type     = 'E'
                                 id       = 'ZSD_COCKPIT_DEVOL'
                                 number   = '001'  ) ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
