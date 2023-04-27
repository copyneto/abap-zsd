CLASS zclsd_carga_contratos DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES:
      ty_r_vbeln TYPE RANGE OF vbak-vbeln,     " Contrato

** ======================================================================
** Types - Arquivo CSV
** ======================================================================

      BEGIN OF ty_file,
        sernr TYPE objk-sernr,
        matnr TYPE vbap-matnr,
        vbeln TYPE vbap-vbeln,
        posnr TYPE vbap-posnr,
        kunnr TYPE vbak-kunnr,
        auart TYPE vbak-auart,
        pstyv TYPE vbap-pstyv,
      END OF ty_file,

      ty_t_file TYPE STANDARD TABLE OF ty_file,

      ty_data   TYPE text8192,

      ty_t_data TYPE STANDARD TABLE OF ty_data.

    "! Cria instancia
    CLASS-METHODS get_instance
      RETURNING
        VALUE(ro_instance) TYPE REF TO zclsd_carga_contratos.

    "! Evento F4 para escolher o diretório
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter ev_filename   | Nome do arquivo
    "! @parameter et_return         | Mensagens de retorno
    METHODS search_directory_f4
      IMPORTING iv_locl     TYPE flag
                iv_serv     TYPE flag
      EXPORTING ev_filename TYPE any
                et_return   TYPE bapiret2_t.

    "! Evento F4 para escolher o arquivo
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter ev_filename   | Nome do arquivo
    "! @parameter et_return     | Mensagens de retorno
    METHODS search_file_f4
      IMPORTING iv_locl     TYPE flag
                iv_serv     TYPE flag
      EXPORTING ev_filename TYPE any
                et_return   TYPE bapiret2_t.

    "! Monta o arquivo de download
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter ir_vbeln      | Contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS download_contract
      IMPORTING iv_locl     TYPE flag
                iv_serv     TYPE flag
                iv_filename TYPE any
                ir_vbeln    TYPE ty_r_vbeln
      EXPORTING et_return   TYPE bapiret2_t.


    "! Seleciona dados de contrato
    "! @parameter ir_vbeln      | Contrato
    "! @parameter et_file        | Dados de contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS get_contract
      IMPORTING ir_vbeln  TYPE ty_r_vbeln
      EXPORTING et_file   TYPE ty_t_file
                et_return TYPE bapiret2_t.

    "! Cria arquivo CSV
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter it_table      | Dados de contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS create_file
      IMPORTING iv_filename TYPE any
                iv_locl     TYPE flag
                iv_serv     TYPE flag
                it_table    TYPE ty_t_file
      EXPORTING et_return   TYPE bapiret2_t.

    "! Recupera campos da tabela informada
    "! @parameter it_table  | Tabela
    "! @parameter et_fields | Campos
    METHODS get_table_fieldnames
      IMPORTING it_table  TYPE ANY TABLE
      EXPORTING et_fields TYPE ddfields.

    METHODS save_file
      IMPORTING iv_filename TYPE any
                iv_locl     TYPE flag
                iv_serv     TYPE flag
                it_data     TYPE ty_t_data
      EXPORTING et_return   TYPE bapiret2_t.

    "! Realiza carga de contrato
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter et_return     | Mensagens de retorno
    METHODS upload_contract
      IMPORTING iv_locl     TYPE flag
                iv_serv     TYPE flag
                iv_filename TYPE any
      EXPORTING et_return   TYPE bapiret2_t.

    "! Monta o arquivo de upload
    "! @parameter iv_locl       | Local
    "! @parameter iv_serv       | Servidor
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter et_file        | Dados de contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS upload_file
      IMPORTING iv_locl     TYPE flag
                iv_serv     TYPE flag
                iv_filename TYPE any
      EXPORTING et_file     TYPE ty_t_file
                et_return   TYPE bapiret2_t.

    "! Monta o arquivo de upload (local)
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter et_csv        | Dados de contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS upload_file_locl
      IMPORTING iv_filename TYPE any
      EXPORTING et_csv      TYPE string_table
                et_return   TYPE bapiret2_t.

    "! Monta o arquivo de upload (servidor)
    "! @parameter iv_filename   | Nome do arquivo
    "! @parameter et_csv        | Dados de contrato
    "! @parameter et_return     | Mensagens de retorno
    METHODS upload_file_serv
      IMPORTING iv_filename TYPE any
      EXPORTING et_csv      TYPE string_table
                et_return   TYPE bapiret2_t.

    "! Validações necessarias
    "! @parameter et_return | Mensagens de retorno
    METHODS validate_file
      IMPORTING iv_filename TYPE any
      EXPORTING et_return   TYPE bapiret2_t.

    "! Chamada da BAPI para atualização do contrato
    "! @parameter it_file | Dados de contrato
    "! @parameter et_return | Mensagens de retorno
    METHODS call_bapi
      IMPORTING it_file   TYPE ty_t_file
      EXPORTING et_return TYPE bapiret2_t.

    "! Exibe mensagens de retorno
    "! @parameter it_return | Mensagens de retorno
    METHODS show_log
      IMPORTING it_return TYPE bapiret2_t.

    "! Exibe progresso do processametno
    METHODS show_progress
      IMPORTING iv_current_line TYPE i
                iv_total_line   TYPE i.

  PROTECTED SECTION.

  PRIVATE SECTION.

    CLASS-DATA go_instance TYPE REF TO zclsd_carga_contratos.

    DATA: gv_progress TYPE i.

ENDCLASS.



CLASS zclsd_carga_contratos IMPLEMENTATION.

  METHOD get_instance.

    go_instance = COND #( WHEN go_instance IS NOT INITIAL
                          THEN go_instance
                          ELSE NEW zclsd_carga_contratos( ) ).

    ro_instance = go_instance.

  ENDMETHOD.

  METHOD search_directory_f4.

    DATA: lv_file TYPE string.

    FREE: ev_filename, et_return.

* ----------------------------------------------------------------------
* Recupera o diretório do arquivo local
* ----------------------------------------------------------------------
    IF iv_locl IS NOT INITIAL .

      CALL METHOD cl_gui_frontend_services=>directory_browse
        EXPORTING
          initial_folder       = 'C:'
        CHANGING
          selected_folder      = lv_file
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.

      IF sy-subrc NE 0.
        et_return[] = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        RETURN.

      ELSEIF lv_file IS INITIAL.
        " Operação cancelada.
        et_return[] = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                                id         = 'ZSD_CARGA_CONTRATOS'
                                                number     = '001' ) ).
        RETURN.

      ELSE.
        lv_file = lv_file && '\'.
      ENDIF.

* ----------------------------------------------------------------------
* Recupera o diretório do arquivo no servidor
* ----------------------------------------------------------------------
    ELSEIF iv_serv IS NOT INITIAL.

      CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
        IMPORTING
          serverfile       = lv_file
        EXCEPTIONS
          canceled_by_user = 1
          OTHERS           = 2.

      IF sy-subrc NE 0.
        et_return[] = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        RETURN.

      ELSEIF lv_file IS INITIAL.
        " Operação cancelada.
        et_return[] = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                                id         = 'ZSD_CARGA_CONTRATOS'
                                                number     = '001' ) ).
        RETURN.

      ELSE.
        lv_file = lv_file && '/'.

      ENDIF.

    ENDIF.

* ----------------------------------------------------------------------
* Devolve diretório com nome de arquivo sugerido
* ----------------------------------------------------------------------
    DATA(lv_filename) = |{ gc_contratos }{ sy-datum }_{ sy-uzeit }{ gc_csv }|.

    ev_filename = |{ lv_file }{ lv_filename }|.

  ENDMETHOD.

  METHOD search_file_f4.

    DATA : lt_filetable TYPE filetable,
           lv_rc        TYPE i,
           lv_path      TYPE dxlpath.

    FREE: ev_filename, et_return.

* ----------------------------------------------------------------------
* Recupera o nome do arquivo local
* ----------------------------------------------------------------------
    IF iv_locl IS NOT INITIAL .

      CALL METHOD cl_gui_frontend_services=>file_open_dialog
        EXPORTING
          multiselection          = ' '           " Sel. apenas 1 arquivo
          default_extension       = gc_upld-default_extension
          file_filter             = gc_upld-file_filter
        CHANGING
          file_table              = lt_filetable
          rc                      = lv_rc
        EXCEPTIONS
          file_open_dialog_failed = 1
          cntl_error              = 2
          error_no_gui            = 3
          not_supported_by_gui    = 4
          OTHERS                  = 5.

      IF sy-subrc NE 0.
        et_return[] = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        RETURN.
      ENDIF .

      " Determinar o nome do arquivo selecionado
      TRY.
          ev_filename = lt_filetable[ 1 ]-filename.
        CATCH cx_root.
      ENDTRY.

* ----------------------------------------------------------------------
* Recupera o nome do arquivo no servidor
* ----------------------------------------------------------------------
    ELSEIF iv_serv IS NOT INITIAL.

      CALL FUNCTION 'F4_DXFILENAME_TOPRECURSION'
        EXPORTING
          i_location_flag = 'A'
        IMPORTING
          o_path          = lv_path
        EXCEPTIONS
          OTHERS          = 1.

      IF sy-subrc NE 0.
        et_return[] = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        RETURN.
      ENDIF .

      ev_filename = lv_path.

    ENDIF.

  ENDMETHOD.


  METHOD download_contract.

    FREE: et_return.

* ----------------------------------------------------------------------
* Validação inicial
* ----------------------------------------------------------------------
    IF iv_filename IS INITIAL.
      " Favor informar diretório do arquivo.
      et_return[] = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                              id         = 'ZSD_CARGA_CONTRATOS'
                                              number     = '004' ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Seleciona as Empresas e Transações
* ----------------------------------------------------------------------
    me->get_contract( EXPORTING ir_vbeln  = ir_vbeln
                      IMPORTING et_file   = DATA(lt_file)
                                et_return = DATA(lt_return) ).

    INSERT LINES OF lt_return INTO TABLE et_return.

    IF line_exists( et_return[ type = 'E' ] ).           "#EC CI_STDSEQ
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Cria documento .CSV
* ----------------------------------------------------------------------
    me->create_file( EXPORTING iv_locl     = iv_locl
                               iv_serv     = iv_serv
                               iv_filename = iv_filename
                               it_table    = lt_file
                     IMPORTING et_return   = lt_return ).

    INSERT LINES OF lt_return INTO TABLE et_return.

  ENDMETHOD.


  METHOD get_contract.

    FREE: et_file, et_return.

    SELECT objk~sernr,
           vbap~matnr,
           vbap~vbeln,
           vbap~posnr,
           vbak~kunnr,
           vbak~auart,
           vbap~pstyv
      FROM vbak
      INNER JOIN vbap
        ON  vbap~vbeln = vbak~vbeln
      LEFT OUTER JOIN ser02
        ON  ser02~sdaufnr = vbap~vbeln
        AND ser02~posnr   = vbap~posnr
      LEFT OUTER JOIN objk
        ON  objk~obknr    = ser02~obknr
        AND objk~obzae    = 1               " Está configurado para sempre ter um item
      INTO TABLE @et_file
      WHERE vbak~vbeln IN @ir_vbeln.

    IF sy-subrc NE 0.
      " Nenhum registro encontrado para os parâmetros informados.
      et_return[] = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                              id         = 'ZSD_CARGA_CONTRATOS'
                                              number     = '002' ) ).
      RETURN.
    ENDIF.

    SORT et_file BY vbeln posnr sernr.

  ENDMETHOD.


  METHOD create_file.

    DATA: lt_data   TYPE ty_t_data,
          lv_data   TYPE ty_data,
          lv_column TYPE i,
          lv_value  TYPE text100.

    FREE: et_return.

    CONSTANTS lc_delimitador TYPE string VALUE ';'.

* ----------------------------------------------------------------------
* Recupera o nome dos campos
* ----------------------------------------------------------------------
    me->get_table_fieldnames( EXPORTING it_table  = it_table
                              IMPORTING et_fields = DATA(lt_fields) ).

* ----------------------------------------------------------------------
* A primeira linha terá a descrição das colunas
* ----------------------------------------------------------------------
    CLEAR: lv_data, lv_column.

    LOOP AT lt_fields REFERENCE INTO DATA(ls_fields).

      ADD 1 TO lv_column.

      lv_data = COND #( WHEN lv_column EQ 1
                        THEN |{ ls_fields->fieldname }|
                        ELSE |{ lv_data }{ lc_delimitador }{ ls_fields->fieldname }| ).
    ENDLOOP.

    APPEND lv_data TO lt_data.

* ----------------------------------------------------------------------
* Preenche as próximas linhas com os dados do contrato
* ----------------------------------------------------------------------
    LOOP AT it_table ASSIGNING FIELD-SYMBOL(<fs_wa>).

      CLEAR: lv_data, lv_column.

      LOOP AT lt_fields REFERENCE INTO ls_fields.        "#EC CI_NESTED

        ASSIGN COMPONENT ls_fields->fieldname OF STRUCTURE <fs_wa> TO FIELD-SYMBOL(<fs_field>).
        CHECK sy-subrc EQ 0.

        TRY.
            lv_value = <fs_field>.
            SHIFT lv_value LEFT DELETING LEADING space.
          CATCH cx_root.
            CLEAR lv_value.
        ENDTRY.

        ADD 1 TO lv_column.

        lv_data = COND #( WHEN lv_column EQ 1
                          THEN |{ lv_value }|
                          ELSE |{ lv_data }{ lc_delimitador }{ lv_value }| ).
      ENDLOOP.

      APPEND lv_data TO lt_data.
    ENDLOOP.

    me->save_file( EXPORTING iv_filename = iv_filename
                            iv_locl     = iv_locl
                            iv_serv     = iv_serv
                            it_data     = lt_data
                  IMPORTING et_return   = et_return ).

  ENDMETHOD.


  METHOD get_table_fieldnames.

    DATA: lo_describe TYPE REF TO cl_abap_structdescr,
          ls_table    TYPE REF TO data.

    FREE: et_fields.

* ----------------------------------------------------------------------
* Recupera campos da tabela de destino e seus tipos
* ----------------------------------------------------------------------
    CREATE DATA ls_table LIKE LINE OF it_table.
    lo_describe ?= cl_abap_structdescr=>describe_by_data_ref( ls_table ).
    et_fields = cl_salv_data_descr=>read_structdescr( lo_describe ).

  ENDMETHOD.


  METHOD save_file.

    DATA lv_filename TYPE string.

    FREE: et_return.

    lv_filename = iv_filename.

* ----------------------------------------------------------------------
* Finaliza e salva arquivo excel (local)
* ----------------------------------------------------------------------
    CASE abap_true.

      WHEN iv_locl.

        CALL FUNCTION 'GUI_DOWNLOAD'
          EXPORTING
            filename                = lv_filename
            filetype                = 'ASC'
          TABLES
            data_tab                = it_data
          EXCEPTIONS
            file_write_error        = 1
            no_batch                = 2
            gui_refuse_filetransfer = 3
            invalid_type            = 4
            no_authority            = 5
            unknown_error           = 6
            header_not_allowed      = 7
            separator_not_allowed   = 8
            filesize_not_allowed    = 9
            header_too_long         = 10
            dp_error_create         = 11
            dp_error_send           = 12
            dp_error_write          = 13
            unknown_dp_error        = 14
            access_denied           = 15
            dp_out_of_memory        = 16
            disk_full               = 17
            dp_timeout              = 18
            file_not_found          = 19
            dataprovider_exception  = 20
            control_flush_error     = 21
            OTHERS                  = 22.

        IF sy-subrc <> 0.
          et_return = VALUE #( BASE et_return ( type       = sy-msgty
                                                id         = sy-msgid
                                                number     = sy-msgno
                                                message_v1 = sy-msgv1
                                                message_v2 = sy-msgv2
                                                message_v3 = sy-msgv3
                                                message_v4 = sy-msgv4 ) ).
        ENDIF.

* ----------------------------------------------------------------------
* Finaliza e salva arquivo excel (servidor)
* ----------------------------------------------------------------------
      WHEN iv_serv.

        OPEN DATASET lv_filename FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.

        IF sy-subrc NE 0.

          "Erro ao copiar arquivo para pasta de destino
          et_return = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                                id         = 'ZSD_CARGA_CONTRATOS'
                                                number     = '008' ) ).
          RETURN.

        ENDIF.

        LOOP AT it_data ASSIGNING FIELD-SYMBOL(<fs_data>). " recuperando dados do arquivo para passar para outro destino

          TRANSFER <fs_data> TO lv_filename .

        ENDLOOP.

        CLOSE DATASET lv_filename.

    ENDCASE.

  ENDMETHOD.



  METHOD upload_contract.

* ----------------------------------------------------------------------
* Validação inicial
* ----------------------------------------------------------------------
    IF iv_filename IS INITIAL.
      " Favor informar diretório do arquivo.
      et_return[] = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                              id         = 'ZSD_CARGA_CONTRATOS'
                                              number     = '004' ) ).
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Valida a extensão do excel
* ----------------------------------------------------------------------
    me->validate_file( EXPORTING iv_filename = iv_filename
                       IMPORTING et_return   = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Busca os dados do arquivo e converte para tabela interna tipo string
* ----------------------------------------------------------------------
    me->upload_file( EXPORTING iv_locl     = iv_locl
                               iv_serv     = iv_serv
                               iv_filename = iv_filename
                     IMPORTING et_file     = DATA(lt_file)
                               et_return   = et_return ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

** ----------------------------------------------------------------------
** Chama BAPI
** ----------------------------------------------------------------------
    me->call_bapi( EXPORTING it_file     = lt_file
                   IMPORTING et_return   = et_return ).

  ENDMETHOD.


  METHOD validate_file.

    DATA: lv_file TYPE string,
          lv_ext  TYPE string.

    FREE: et_return.

    lv_file =  iv_filename.

    CALL FUNCTION 'CRM_IC_WZ_SPLIT_FILE_EXTENSION'
      EXPORTING
        iv_filename_with_ext = lv_file
      IMPORTING
        ev_extension         = lv_ext.

    IF lv_ext NE 'csv' AND lv_ext NE 'txt'.
      " Arquivo deve ser .csv/.txt
      et_return = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                            id         = 'ZSD_CARGA_CONTRATOS'
                                            number     = '005' ) ).
    ENDIF.

  ENDMETHOD.


  METHOD upload_file.

    DATA: ls_file TYPE ty_file.

    FREE: et_file, et_return.

    CASE abap_true.

* ----------------------------------------------------------------------
* Passa dados do arquivo para tabela interna (local)
* ----------------------------------------------------------------------
      WHEN iv_locl.

        me->upload_file_locl( EXPORTING iv_filename = iv_filename
                              IMPORTING et_csv      = DATA(lt_csv)
                                        et_return   = et_return ).

* ----------------------------------------------------------------------
* Passa dados do arquivo para tabela interna (servidor)
* ----------------------------------------------------------------------
      WHEN iv_serv.

        me->upload_file_serv( EXPORTING iv_filename = iv_filename
                              IMPORTING et_csv      = lt_csv
                                        et_return   = et_return ).

    ENDCASE.

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

* ----------------------------------------------------------------------
* Transfere dados de arquivo para tabela de carga
* ----------------------------------------------------------------------
    LOOP AT lt_csv REFERENCE INTO DATA(ls_csv).

      CHECK sy-tabix NE 1.  " Ignora primeira linha de cabeçalho

      SPLIT ls_csv->* AT ';' INTO ls_file-sernr
                                  ls_file-matnr
                                  ls_file-vbeln
                                  ls_file-posnr
                                  ls_file-kunnr
                                  ls_file-auart
                                  ls_file-pstyv.

      ls_file-sernr     = |{ ls_file-sernr ALPHA = IN }|.
      ls_file-matnr     = CONV matnr18( |{ ls_file-matnr ALPHA = IN }| ).
      ls_file-vbeln     = |{ ls_file-vbeln ALPHA = IN }|.
      ls_file-posnr     = |{ ls_file-posnr ALPHA = IN }|.
      ls_file-kunnr     = |{ ls_file-kunnr ALPHA = IN }|.

      APPEND ls_file TO et_file.
    ENDLOOP.

    IF et_file IS INITIAL.
      " Não foram encontrados dados no arquivo.
      et_return = VALUE #( ( type       = if_abap_behv_message=>severity-error
                             id         = 'ZSD_CARGA_CONTRATOS'
                             number     = '007' ) ).
      RETURN .
    ENDIF.

  ENDMETHOD.


  METHOD call_bapi.

    DATA(lv_batch) = sy-batch.

* ----------------------------------------------------------------------
* Prepara para atualizar o contrato
* ----------------------------------------------------------------------
    LOOP AT it_file REFERENCE INTO DATA(ls_file).

      sy-batch = lv_batch.

      " Exibe progresso da execução
      me->show_progress( EXPORTING iv_current_line = sy-tabix
                                   iv_total_line   = lines( it_file ) ).

      " Atualizando contrato &1/&2.
      et_return = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-information
                                            id         = 'ZSD_CARGA_CONTRATOS'
                                            number     = '011'
                                            message_v1 = ls_file->vbeln
                                            message_v2 = ls_file->posnr ) ).

      " Atualiza o número de série do Contrato
      TRY.
          sy-batch = abap_true. " Para simular uma execução em background e não dispar pop-ups de erro

          CALL FUNCTION 'SERNR_ADD_TO_AU'
            EXPORTING
              sernr                 = ls_file->sernr
              profile               = '0006'
              material              = ls_file->matnr
              quantity              = '1'
              j_vorgang             = space
              document              = ls_file->vbeln
              item                  = ls_file->posnr
              debitor               = ls_file->kunnr
              vbtyp                 = 'G'
              sd_auart              = ls_file->auart
              sd_postyp             = ls_file->pstyv
            EXCEPTIONS
              konfigurations_error  = 1
              serialnumber_errors   = 2
              serialnumber_warnings = 3
              no_profile_operation  = 4
              error_message         = 5
              OTHERS                = 6.
        CATCH cx_root.
      ENDTRY.

      IF sy-subrc NE 0.
        et_return = VALUE #( BASE et_return ( type       = sy-msgty
                                              id         = sy-msgid
                                              number     = sy-msgno
                                              message_v1 = sy-msgv1
                                              message_v2 = sy-msgv2
                                              message_v3 = sy-msgv3
                                              message_v4 = sy-msgv4 ) ).
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'SERIAL_LISTE_POST_AU'.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*          EXPORTING
*            wait   = abap_true.

      " Contrato atualizado.
      et_return = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-success
                                            id         = 'ZSD_CARGA_CONTRATOS'
                                            number     = '012' ) ).


    ENDLOOP.

    sy-batch = lv_batch.

  ENDMETHOD.


  METHOD upload_file_locl.

    DATA: lt_csv      TYPE string_table,
          lv_filename TYPE string.

    FREE: et_csv, et_return.

    lv_filename = CONV string( iv_filename ).

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = lv_filename
      CHANGING
        data_tab                = et_csv
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.

    IF sy-subrc NE 0 .
      et_return = VALUE #( BASE et_return ( type       = sy-msgty
                                            id         = sy-msgid
                                            number     = sy-msgno
                                            message_v1 = sy-msgv1
                                            message_v2 = sy-msgv2
                                            message_v3 = sy-msgv3
                                            message_v4 = sy-msgv4 ) ).
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD upload_file_serv.

    DATA: ls_csv  TYPE string,
          ls_file TYPE ty_file.

    FREE: et_csv, et_return.

    OPEN DATASET iv_filename FOR INPUT IN TEXT MODE ENCODING NON-UNICODE.

    IF sy-subrc NE 0.
      "Não foi possível abrir o file &.
      et_return = VALUE #( BASE et_return ( type       = if_abap_behv_message=>severity-error
                                            id         = 'ZSD_CARGA_CONTRATOS'
                                            number     = '009'
                                            message_v1 = iv_filename ) ).
      RETURN .
    ENDIF.

    DO.
      READ DATASET iv_filename INTO ls_csv.

      IF sy-subrc NE 0.
        EXIT.
      ENDIF.

      APPEND ls_csv TO et_csv.

    ENDDO.

    CLOSE DATASET iv_filename.

  ENDMETHOD.

  METHOD show_log.

    DATA: lt_message TYPE esp1_message_tab_type.

    CHECK it_return[] IS NOT INITIAL.

* ----------------------------------------------------------------------
* Prepara as mensagens
* ----------------------------------------------------------------------

    LOOP AT it_return REFERENCE INTO DATA(ls_return).

      lt_message = VALUE #( BASE lt_message ( msgid  = ls_return->id
                                              msgty  = ls_return->type
                                              msgno  = ls_return->number
                                              msgv1  = ls_return->message_v1
                                              msgv2  = ls_return->message_v2
                                              msgv3  = ls_return->message_v3
                                              msgv4  = ls_return->message_v4
                                              lineno = sy-tabix ) ).
    ENDLOOP.

* ----------------------------------------------------------------------
* Exibe apenas uma mensagem
* ----------------------------------------------------------------------
    IF lines( lt_message[] ) = 1.

      READ TABLE lt_message INTO DATA(ls_message) INDEX 1.

      MESSAGE ID ls_message-msgid
      TYPE 'S'
      NUMBER ls_message-msgno
      DISPLAY
      LIKE ls_message-msgty
      WITH ls_message-msgv1
      ls_message-msgv2
      ls_message-msgv3
      ls_message-msgv4.

* ----------------------------------------------------------------------
* Exibe múltiplas mensagens como pop-up
* ----------------------------------------------------------------------
    ELSE.

      CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
        TABLES
          i_message_tab = lt_message[].

    ENDIF.

  ENDMETHOD. " show_log


  METHOD show_progress.

    DATA: lv_perc      TYPE i.

    IF iv_current_line <= 1.
      gv_progress = 0.
    ENDIF.

    lv_perc = ( iv_current_line / iv_total_line ) * '100.0'.

    IF lv_perc <> gv_progress.

      " Atualizando número de série do contrato... [&1/&2]
      MESSAGE s013(zsd_carga_contratos)  WITH iv_current_line iv_total_line INTO DATA(lv_message).

      CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
        EXPORTING
          percentage = lv_perc
          text       = lv_message.

      gv_progress = lv_perc.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
