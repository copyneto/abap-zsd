*&---------------------------------------------------------------------*
*& Include          ZFIIBANCARIO_002CL1
*&---------------------------------------------------------------------*

CLASS lcl_main_report DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.

    DATA: gt_directory_to_import TYPE TABLE OF ztfi_autbanc_dir.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(ro_result) TYPE REF TO lcl_main_report.

    CLASS-METHODS handle_error
      IMPORTING
        iv_popup TYPE flag OPTIONAL
        iv_cx    TYPE REF TO lcl_exceptions.
    METHODS:
      check_job,
      main.
  PRIVATE SECTION.
    TYPES: ty_t_directorys TYPE STANDARD TABLE OF ztfi_autbanc_dir WITH DEFAULT KEY.

    METHODS get_directorys_to_import
      RETURNING
        VALUE(rt_direcotrys) TYPE ty_t_directorys
      RAISING
        lcl_exceptions.
    METHODS get_files
      IMPORTING
        iv_path         TYPE ztfi_autbanc_dir-diretorio
      RETURNING
        VALUE(rt_files) TYPE eps2filis
      RAISING
        lcl_exceptions.
ENDCLASS.

CLASS lcl_bank_file DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create_instance
      RETURNING
        VALUE(ro_result) TYPE REF TO lcl_bank_file.

    METHODS process
      IMPORTING
                iv_directory    TYPE ztfi_autbanc_dir
                iv_file_name    TYPE eps2filnam
      RETURNING VALUE(rv_chave) TYPE kukey_eb
      RAISING
                lcl_exceptions.

    METHODS check_file
      IMPORTING
        iv_file_name TYPE eps2filnam
      RAISING
        lcl_exceptions.

    METHODS execute_batch.

  PRIVATE SECTION.

    DATA: gv_path TYPE ztfi_autbanc_dir-diretorio.


    DATA: gt_bdcdata TYPE TABLE OF bdcdata.

    METHODS bdc_dynpro
      IMPORTING
        iv_program TYPE bdcdata-program
        iv_dynpro  TYPE bdcdata-dynpro.

    METHODS bdc_field
      IMPORTING
        iv_fnam TYPE bdcdata-fnam
        iv_fval TYPE bdcdata-fval.

ENDCLASS.

CLASS lcl_log DEFINITION CREATE PRIVATE FINAL.
  PUBLIC SECTION.

    CLASS-METHODS create_instance
      RETURNING
        VALUE(ro_result) TYPE REF TO lcl_log.

    METHODS insert_log
      IMPORTING
        iv_codigo    TYPE any OPTIONAL
        iv_diretorio TYPE ztfi_autbanc_log-diretorio
        iv_nome      TYPE ztfi_autbanc_log-nome
        iv_tipo      TYPE ztfi_autbanc_log-tipo
        iv_message   TYPE bapi_msg
        iv_type      TYPE bapi_mtype
        iv_chave     TYPE kukey_eb OPTIONAL
      RAISING
        lcl_exceptions.



  PRIVATE SECTION.
    DATA: gt_log TYPE TABLE OF ztfi_autbanc_log.

    DATA: gv_path TYPE ztfi_autbanc_log-diretorio.
ENDCLASS.

CLASS lcl_log IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_result.
  ENDMETHOD.

  METHOD insert_log.
    APPEND INITIAL LINE TO gt_log ASSIGNING FIELD-SYMBOL(<fs_s_log>).
    TRY.
        <fs_s_log>-codigo = cl_system_uuid=>create_uuid_x16_static( ).
      CATCH cx_uuid_error INTO DATA(ls_error).
        DATA(lv_dummy) = abap_true.
      CATCH cx_static_check INTO DATA(ls_static_error).
        lv_dummy = abap_true.
    ENDTRY.
    <fs_s_log>-created_at   = |{ sy-datum }{ sy-uzeit }|.
    <fs_s_log>-created_by   = sy-uname.
    <fs_s_log>-message      = iv_message.
    REPLACE ALL OCCURRENCES OF '&' IN <fs_s_log>-message WITH ''.
    <fs_s_log>-diretorio    = iv_diretorio.
    <fs_s_log>-nome         = iv_nome.
    <fs_s_log>-tipo         = iv_tipo.
    <fs_s_log>-msgtype      = iv_type.
    <fs_s_log>-chave_breve  = iv_chave.



    DO.

      "Verifica se já existe um registro inserido na tabela
      SELECT COUNT(*)
        FROM ztfi_autbanc_log
        WHERE codigo = <fs_s_log>-codigo.

      "Se sim gera um novo código aleatório
      IF sy-subrc = 0.

        TRY.
            <fs_s_log>-codigo = cl_system_uuid=>create_uuid_x16_static( ).
          CATCH cx_uuid_error INTO DATA(ls_error_aux).
            DATA(lv_dummy_aux) = abap_true.
          CATCH cx_static_check INTO DATA(ls_static_error_aux).
            lv_dummy_aux = abap_true.
        ENDTRY.

      ELSE.

        EXIT.

      ENDIF.

    ENDDO.


    INSERT ztfi_autbanc_log FROM TABLE gt_log.

    IF sy-subrc IS NOT INITIAL.
      "Erro ao salvar log de execução
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_log_save_erro.
    ELSE.
      REFRESH: gt_log.
    ENDIF.
  ENDMETHOD.


ENDCLASS.

CLASS lcl_bank_file IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_result.
  ENDMETHOD.

  METHOD check_file.
    DATA: lv_data TYPE ztfi_autbanc_log-created_at.

    SELECT SINGLE created_at INTO lv_data
      FROM ztfi_autbanc_log
     WHERE nome EQ iv_file_name                         "#EC CI_NOFIELD
       AND msgtype EQ 'S'.
    IF sy-subrc EQ 0.
      "Erro ao importar o arquivo & na FF.5
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_file_exist
          iv_type   = 'E'
          iv_msgv1  = CONV #( iv_file_name )
          iv_msgv2  = CONV #( lv_data ).
    ENDIF.
  ENDMETHOD.

  METHOD execute_batch.

    DATA: lt_apqi TYPE STANDARD TABLE OF apqi.

    DATA: lv_jobcount TYPE tbtcjob-jobcount,
          lv_jobname  TYPE tbtcjob-jobname.

    " Selecionar nome da pasta - SM35
    DATA(lv_datai) = sy-datum - 1.
    DATA(lv_dataf) = sy-datum.

    SELECT groupid qid
      FROM apqi
      INTO TABLE lt_apqi
      WHERE mandant = sy-mandt
        AND progid  = 'RFEBBU00'
        AND qstate  = abap_false
        AND userid  = sy-uname
        AND credate BETWEEN lv_datai AND lv_dataf.

    " Processar pasta automaticamente - SM35
    IF sy-subrc IS INITIAL.

      LOOP AT lt_apqi ASSIGNING FIELD-SYMBOL(<fs_apqi>).
        lv_jobname = <fs_apqi>-groupid.

        CALL FUNCTION 'JOB_OPEN'
          EXPORTING
            jobname          = lv_jobname
          IMPORTING
            jobcount         = lv_jobcount
          EXCEPTIONS
            cant_create_job  = 1
            invalid_job_data = 2
            jobname_missing  = 3
            OTHERS           = 99.
*
        IF sy-subrc EQ 0.              "Job_open OK
*
          SUBMIT rsbdcbtc_sub WITH queue_id  EQ <fs_apqi>-qid
                              WITH modus     EQ 'N'
                              WITH logall    EQ abap_false
                              VIA JOB lv_jobname NUMBER lv_jobcount AND RETURN.
*
          IF sy-subrc EQ 0.            "submit OK
*      CLEAR jobrele.
            CALL FUNCTION 'JOB_CLOSE'
              EXPORTING
                jobcount             = lv_jobcount
                jobname              = lv_jobname
                strtimmed            = abap_true
              EXCEPTIONS
                cant_start_immediate = 1
                invalid_startdate    = 2
                jobname_missing      = 3
                job_close_failed     = 4
                job_nosteps          = 5
                job_notex            = 6
                lock_failed          = 7
                invalid_target       = 8
                OTHERS               = 99.

            IF sy-subrc <> 0.
              DATA(lv_erro) = abap_true.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD process.
    TYPES: BEGIN OF ty_text,
             data TYPE c LENGTH 2000,
           END OF ty_text,
           BEGIN OF ty_febep,
             kukey TYPE febep-kukey,
             esnum TYPE febep-esnum,
             gjahr TYPE febep-gjahr,
             vgext TYPE febep-vgext,
             xblnr TYPE febep-xblnr,
             pnota TYPE febep-pnota,
             pform TYPE febep-pform,
             kidno TYPE febep-kidno,
             anwnd TYPE febko-anwnd,
             azidt TYPE febko-azidt,
             emkey TYPE febko-emkey,
             bukrs TYPE febko-bukrs,
           END OF ty_febep,
           BEGIN OF ty_bsid,
             bukrs TYPE bseg-bukrs,
             kunnr TYPE bseg-kunnr,
             augdt TYPE bseg-augdt,
             gjahr TYPE bseg-gjahr,
             belnr TYPE bseg-belnr,
             buzei TYPE bseg-buzei,
             waers TYPE bkpf-waers,
             zterm TYPE bseg-zterm,
             zlsch TYPE bseg-zlsch,
             zlspr TYPE bseg-zlspr,
             anfbn TYPE bseg-anfbn,
             anfbj TYPE bseg-anfbj,
             anfbu TYPE bseg-anfbu,
             manst TYPE bseg-manst,
             dtws1 TYPE bseg-dtws1,
             dtws2 TYPE bseg-dtws2,
             dtws3 TYPE bseg-dtws3,
           END OF ty_bsid.

    DATA: lt_text  TYPE STANDARD TABLE OF ty_text,
          lt_febep TYPE STANDARD TABLE OF ty_febep,
          lt_bsid  TYPE STANDARD TABLE OF ty_bsid,
          lt_mem   TYPE STANDARD TABLE OF abaplist,
          lr_xref3 TYPE RANGE OF xref3,
          lv_spool TYPE btclistid,
          lv_mode.

    DATA: lv_modo         VALUE 'N',
          lv_msg(500),
          lv_path(128)    TYPE c,
          lv_jobcount     TYPE tbtcjob-jobcount,
          lv_jobname      TYPE tbtcjob-jobname,
          lv_cont         TYPE numc4,
          lv_finish       TYPE tbtcjob-status,
          lv_tempo_max(4) TYPE n,
          lv_tam          TYPE i,
          lv_dummy        TYPE c,
          lv_banco        TYPE c LENGTH 3.

    DATA: lt_job_log TYPE STANDARD TABLE OF tbtc5,
          ls_job_log TYPE tbtc5.

    DATA: lv_einlesen TYPE rfpdo1-febeinles VALUE 'X',  " Importar dados
          lv_format   TYPE rfpdo1-febformat,            " Formato
          lv_x_format TYPE febformat_long,              " XML ou formato específ.banco
          lv_auszfile TYPE rfpdo1-febauszf,             " File Dump
          lv_xcall    TYPE febpdo-xcall     VALUE 'X',  " Lançar imediatamente
          lv_binpt    TYPE febpdo-xbinpt    VALUE 'X',  " Criar pastas batch-input
          lv_pcupload TYPE rfpdo1-febpcupld VALUE '',  " Estação de trabalho-upload
          lv_batch    TYPE rfpdo2-febbatch  VALUE 'X',  " Execução em batch-job
          lv_p_koausz TYPE rfpdo1-febpausz  VALUE 'X',  " Imprimir extrato de conta
          lv_p_bupro  TYPE rfpdo2-febbupro  VALUE 'X',  " Imprimir log de lançamento
          lv_p_statik TYPE rfpdo2-febstat   VALUE 'X',  " Imprimir estatística
          lv_pa_lsepa TYPE febpdo-lsepa     VALUE 'X'.  " Separação de lista


    "Busca o número do banco no nome do arquivo.
    CLEAR: lv_banco.
    IF iv_file_name+3(1) CO '0123456789' AND iv_file_name+3(3) CO '0123456789'.
      lv_banco = iv_file_name+3(3).
    ELSE.
      IF iv_file_name+4(1) CO '0123456789' AND iv_file_name+4(3) CO '0123456789'.
        lv_banco = iv_file_name+4(3).
      ELSE.
        "Erro ao iniciar o JOB de processamento do arquivo &
        RAISE EXCEPTION TYPE lcl_exceptions
          EXPORTING
            iv_textid = lcl_exceptions=>gc_erro_name_file
            iv_msgv1  = CONV #( iv_file_name ).
      ENDIF.
    ENDIF.
    "Verifica o tipo de arquivo para gerar ou não pasta Batch-Input
    CASE iv_file_name(3).
      WHEN 'COB'.
        "Verifica o tipo de formato do arquivo.
        CASE iv_file_name+3(3).
          WHEN 237.
            lv_format = '1'.
          WHEN OTHERS.
            lv_format = 'B'.
        ENDCASE.
        CLEAR: lv_xcall.
      WHEN OTHERS.
        lv_format = 'B'.
        CLEAR: lv_binpt.
    ENDCASE.
    "Determinando caminho do arquivo para executar a FF.5
    lv_auszfile = |{ iv_directory-diretorio }\\{ iv_file_name }|.

    "Definindo nome do JOB
    CONCATENATE 'IMPORT' iv_file_name INTO lv_jobname SEPARATED BY '_'.

    "Iniciando JOB de execução
    CALL FUNCTION 'JOB_OPEN'
      EXPORTING
        jobname          = lv_jobname
      IMPORTING
        jobcount         = lv_jobcount
      EXCEPTIONS
        cant_create_job  = 1
        invalid_job_data = 2
        jobname_missing  = 3
        OTHERS           = 4.
    IF sy-subrc IS NOT INITIAL.
      "Erro ao iniciar o JOB de processamento do arquivo &
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_job_start_erro
          iv_msgv1  = CONV #( iv_file_name ).
    ENDIF.

    "Executando a FF.5
    SUBMIT rfebka00 WITH  einlesen = lv_einlesen
                    WITH  format   = lv_format
                    WITH  x_format = lv_x_format
                    WITH  auszfile = lv_auszfile
                    WITH  pa_xcall = lv_xcall
                    WITH  pa_xbdc  = lv_binpt
                    WITH  pcupload = lv_pcupload
                    WITH  batch    = lv_batch
                    WITH  p_koausz = lv_p_koausz
                    WITH  p_bupro  = lv_p_bupro
                    WITH  p_statik = lv_p_statik
                    WITH  pa_lsepa = lv_pa_lsepa
                    VIA JOB lv_jobname NUMBER lv_jobcount AND RETURN. "#EC CI_SUBMIT

    CALL FUNCTION 'JOB_CLOSE'
      EXPORTING
        jobcount             = lv_jobcount
        jobname              = lv_jobname
        strtimmed            = 'X'
      EXCEPTIONS
        cant_start_immediate = 1
        invalid_startdate    = 2
        jobname_missing      = 3
        job_close_failed     = 4
        job_nosteps          = 5
        job_notex            = 6
        lock_failed          = 7
        invalid_target       = 8
        OTHERS               = 9.
    IF sy-subrc IS NOT INITIAL.
      "Erro ao iniciar o JOB de processamento do arquivo &
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_job_start_erro
          iv_type   = 'E'
          iv_msgv1  = CONV #( iv_file_name ).
    ENDIF.


    "Verifica a execução até que o mesmo seja concluído com sucesso ou erro
    WHILE lv_finish <> 'F' AND "Diferente de Finalizado
          lv_finish <> 'A'.    "Diferente de Finalizado com erro

      WAIT UP TO 1 SECONDS.

      CLEAR lv_finish.
      CALL FUNCTION 'BP_JOB_STATUS_GET'
        EXPORTING
          jobcount                   = lv_jobcount
          jobname                    = lv_jobname
        IMPORTING
          status                     = lv_finish
        EXCEPTIONS
          job_doesnt_exist           = 1
          unknown_error              = 2
          parent_child_inconsistency = 3
          OTHERS                     = 4.

      IF sy-subrc <> 0.
        lv_dummy = abap_true.
      ENDIF.

    ENDWHILE.

    "Aguarda um segundo para atualizar as mensagens dos jobs.
    WAIT UP TO 1 SECONDS.

    "Verificando se deu sucesso
    CALL FUNCTION 'BP_JOBLOG_READ'
      EXPORTING
        jobcount              = lv_jobcount
        jobname               = lv_jobname
      TABLES
        joblogtbl             = lt_job_log
      EXCEPTIONS
        cant_read_joblog      = 1
        jobcount_missing      = 2
        joblog_does_not_exist = 3
        joblog_is_empty       = 4
        joblog_name_missing   = 5
        jobname_missing       = 6
        job_does_not_exist    = 7
        OTHERS                = 8.
    IF sy-subrc IS NOT INITIAL.
      "Erro ao importar o arquivo & na FF.5
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_ff5_import_erro
          iv_type   = 'E'
          iv_msgv1  = CONV #( iv_file_name ).
    ENDIF.

    DESCRIBE TABLE lt_job_log LINES lv_tam.

    WHILE lv_tam < 3.
      CLEAR: lt_job_log, lv_tam.
      WAIT UP TO 1 SECONDS.
      "Verificando se deu sucesso
      CALL FUNCTION 'BP_JOBLOG_READ'
        EXPORTING
          jobcount              = lv_jobcount
          jobname               = lv_jobname
        TABLES
          joblogtbl             = lt_job_log
        EXCEPTIONS
          cant_read_joblog      = 1
          jobcount_missing      = 2
          joblog_does_not_exist = 3
          joblog_is_empty       = 4
          joblog_name_missing   = 5
          jobname_missing       = 6
          job_does_not_exist    = 7
          OTHERS                = 8.
      IF sy-subrc NE 0. lv_dummy = abap_true. ENDIF.
      DESCRIBE TABLE lt_job_log LINES lv_tam.
    ENDWHILE.


    IF iv_file_name(3) EQ 'COB'.

      FREE: lv_spool, lt_mem, lt_text.
      SELECT SINGLE listident
        FROM tbtcp
        INTO lv_spool
        WHERE jobname  = lv_jobname
          AND jobcount = lv_jobcount.

      IF lv_spool IS NOT INITIAL.

        SUBMIT rspolst2 EXPORTING LIST TO MEMORY AND RETURN
          WITH rqident = lv_spool
          WITH first = '1'.

        CALL FUNCTION 'LIST_FROM_MEMORY'
          TABLES
            listobject = lt_mem.

        IF lt_mem[] IS NOT INITIAL.

          CALL FUNCTION 'LIST_TO_ASCI'
            EXPORTING
              list_index = -1
            TABLES
              listasci   = lt_text
              listobject = lt_mem.


          LOOP AT lt_text ASSIGNING FIELD-SYMBOL(<fs_text>).
            FIND text-f01 IN <fs_text> MATCH OFFSET DATA(lv_offset).
            IF sy-subrc EQ 0.
              ADD 12 TO lv_offset.
              rv_chave = <fs_text>+lv_offset.
              CONDENSE rv_chave.
              EXIT.
            ENDIF.
          ENDLOOP.

          IF rv_chave IS NOT INITIAL.

            SELECT a~kukey a~esnum a~gjahr a~vgext
                   a~xblnr a~pnota a~pform a~kidno b~anwnd
                   b~azidt b~emkey b~bukrs
              FROM febep AS a
              INNER JOIN febko AS b ON ( a~kukey EQ b~kukey )
              INTO CORRESPONDING FIELDS OF TABLE lt_febep
              WHERE a~kukey EQ rv_chave
                AND a~vgext IN ( '09', '27' )
                AND a~pform EQ 11
                AND b~anwnd EQ '0001'.

            CHECK sy-subrc IS INITIAL AND lt_febep IS NOT INITIAL.

            LOOP AT lt_febep ASSIGNING FIELD-SYMBOL(<fs_febep>).
              SELECT bukrs kunnr augdt gjahr belnr buzei
                     waers zterm zlsch zlspr anfbn anfbj
                     anfbu manst dtws1 dtws2 dtws3
                FROM ('BSID')
                APPENDING CORRESPONDING FIELDS OF TABLE lt_bsid
                WHERE bukrs = <fs_febep>-bukrs
                  AND gjahr = <fs_febep>-gjahr
                  AND belnr = <fs_febep>-pnota
                  AND buzei = <fs_febep>-kidno+8(1)
                  AND anfbn <> ''
                  AND anfbj <> ''
                  AND anfbu <> ''.
            ENDLOOP.

            DATA(lv_data) = sy-datum+6(2) && sy-datum+4(2) && sy-datum(4).

            LOOP AT lt_bsid ASSIGNING FIELD-SYMBOL(<fs_bsid>).

              "Inicio do preenchimento do SHDB para a Transação FB1D
              FREE gt_bdcdata.
              bdc_dynpro( iv_program = 'SAPMF05A' iv_dynpro  = '0131' ).
              bdc_field( iv_fnam = 'BDC_CURSOR'      iv_fval = 'RF05A-XPOS1(04)' ).
              bdc_field( iv_fnam = 'BDC_OKCODE'      iv_fval = '/00' ).
              bdc_field( iv_fnam = 'RF05A-AGKON'     iv_fval = CONV #( <fs_bsid>-kunnr ) ).
              bdc_field( iv_fnam = 'BKPF-BUDAT'      iv_fval = CONV #( lv_data ) ).
              bdc_field( iv_fnam = 'BKPF-MONAT'      iv_fval = CONV #( lv_data+2(2) ) ).
              bdc_field( iv_fnam = 'BKPF-BUKRS'      iv_fval = CONV #( <fs_bsid>-anfbu ) ).
              bdc_field( iv_fnam = 'BKPF-WAERS'      iv_fval = CONV #( <fs_bsid>-waers ) ).
              bdc_field( iv_fnam = 'RF05A-AGUMS'     iv_fval = 'R' ).
              bdc_field( iv_fnam = 'RF05A-XNOPS'     iv_fval = ' ' ).
              bdc_field( iv_fnam = 'RF05A-XPOS1(01)' iv_fval = ' ' ).
              bdc_field( iv_fnam = 'RF05A-XPOS1(04)' iv_fval = 'X' ).

              bdc_dynpro( iv_program = 'SAPMF05A' iv_dynpro  = '0731' ).
              bdc_field( iv_fnam = 'BDC_CURSOR'      iv_fval = 'RF05A-SEL01(01)' ).
              bdc_field( iv_fnam = 'BDC_OKCODE'      iv_fval = '=PA' ).
              bdc_field( iv_fnam = 'RF05A-SEL01(01)' iv_fval = CONV #( <fs_bsid>-anfbn ) ).

              bdc_dynpro( iv_program = 'SAPDF05X' iv_dynpro  = '3100' ).
              bdc_field( iv_fnam = 'BDC_OKCODE'  iv_fval = '=BU' ).
              bdc_field( iv_fnam = 'BDC_SUBSCR'  iv_fval = 'SAPDF05X' ).
              bdc_field( iv_fnam = 'BDC_CURSOR'  iv_fval = 'RF05A-ABPOS' ).
              bdc_field( iv_fnam = 'RF05A-ABPOS' iv_fval = '1' ).
              "Fim do preenchimento do SHDB para a Transação FB1D

              "Chamada da Função FB1D
              lv_mode = 'N'.
              CALL TRANSACTION 'FB1D' USING  gt_bdcdata
                                      MODE   lv_mode
                                      UPDATE 'S'.
              FREE gt_bdcdata.

              "Inicio do preenchimento do SHDB para a Transação FB09
              bdc_dynpro( iv_program = 'SAPMF05L' iv_dynpro  = '0102' ).
              bdc_field( iv_fnam = 'BDC_CURSOR' iv_fval = 'RF05L-BELNR' ).
              bdc_field( iv_fnam = 'BDC_OKCODE' iv_fval = '/00' ).
              bdc_field( iv_fnam = 'RF05L-BELNR' iv_fval = CONV #( <fs_bsid>-belnr ) ).
              bdc_field( iv_fnam = 'RF05L-BUKRS' iv_fval = CONV #( <fs_bsid>-bukrs ) ).
              bdc_field( iv_fnam = 'RF05L-GJAHR' iv_fval = CONV #( <fs_bsid>-gjahr ) ).
              bdc_field( iv_fnam = 'RF05L-BUZEI' iv_fval = CONV #( <fs_bsid>-buzei ) ).

              bdc_dynpro( iv_program = 'SAPMF05L' iv_dynpro  = '0301' ).
              bdc_field( iv_fnam = 'BDC_CURSOR' iv_fval = 'BSEG-ZTERM' ).
              bdc_field( iv_fnam = 'BDC_OKCODE' iv_fval = '=ZK' ).

              bdc_dynpro( iv_program = 'SAPMF05L' iv_dynpro  = '1301' ).
              bdc_field( iv_fnam = 'BDC_CURSOR' iv_fval = 'BSEG-DTWS3' ).
              bdc_field( iv_fnam = 'BDC_OKCODE' iv_fval = '=ENTR' ).
              bdc_field( iv_fnam = 'BSEG-ZLSCH' iv_fval = CONV #( <fs_bsid>-zlsch ) ).
              bdc_field( iv_fnam = 'BSEG-DTWS1' iv_fval = CONV #( <fs_bsid>-dtws1 ) ).
              bdc_field( iv_fnam = 'BSEG-DTWS2' iv_fval = CONV #( <fs_bsid>-dtws2 ) ).
              bdc_field( iv_fnam = 'BSEG-DTWS3' iv_fval = CONV #( <fs_bsid>-dtws3 ) ).
              bdc_field( iv_fnam = 'BSEG-DTWS4' iv_fval = '0' ).

              bdc_dynpro( iv_program = 'SAPMF05L' iv_dynpro  = '0301' ).
              bdc_field( iv_fnam = 'BDC_CURSOR' iv_fval = 'BSEG-ZTERM' ).
              bdc_field( iv_fnam = 'BSEG-ZLSPR' iv_fval = '9' ).
              bdc_field( iv_fnam = 'BDC_OKCODE' iv_fval = '=AE' ).
              "Fim do preenchimento do SHDB para a Transação FB09

              "Chamada da Função FB09
              lv_mode = 'N'.
              CALL TRANSACTION 'FB09' USING  gt_bdcdata
                                      MODE   lv_mode
                                      UPDATE 'S'.
              FREE gt_bdcdata.

            ENDLOOP.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.


    "Verificando se a importação realmente aconteceu.
    READ TABLE lt_job_log INTO ls_job_log WITH KEY msgid = 'FB' msgno = '773'.
    IF sy-subrc = 0.
      "Erro ao importar o arquivo & na FF.5
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_ff5_import_erro
          iv_type   = 'E'
          iv_msgv1  = CONV #( iv_file_name ).
*      RETURN.
    ENDIF.
    "Verificando se a importação realmente aconteceu.
    READ TABLE lt_job_log INTO ls_job_log WITH KEY msgtype = 'I'.
    IF sy-subrc EQ 0.
      "Erro ao importar o arquivo & na FF.5
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = VALUE #( msgid = ls_job_log-msgid
                               msgno = ls_job_log-msgno
                               attr1 = ls_job_log-msgv1
                               attr2 = ls_job_log-msgv2
                               attr3 = ls_job_log-msgv3
                               attr4 = ls_job_log-msgv4 )
          iv_type   = 'E'.
    ENDIF.
    "Verificando se tem algum registro com erro. Caso sim, enviar como erro
    LOOP AT lt_job_log INTO ls_job_log WHERE msgtype NE 'S'.
      EXIT.
    ENDLOOP.
    IF sy-subrc EQ 0.
      READ TABLE lt_job_log INTO ls_job_log WITH KEY msgtype = 'I'.
      IF sy-subrc EQ 0.
        "Erro ao importar o arquivo & na FF.5
        RAISE EXCEPTION TYPE lcl_exceptions
          EXPORTING
            iv_textid = VALUE #( msgid = ls_job_log-msgid
                                 msgno = ls_job_log-msgno
                                 attr1 = ls_job_log-msgv1
                                 attr2 = ls_job_log-msgv2
                                 attr3 = ls_job_log-msgv3
                                 attr4 = ls_job_log-msgv4 )
            iv_type   = 'E'.
      ELSE.
        READ TABLE lt_job_log INTO ls_job_log WITH KEY msgtype = 'E'.
        IF sy-subrc EQ 0.
          "Erro ao importar o arquivo & na FF.5
          RAISE EXCEPTION TYPE lcl_exceptions
            EXPORTING
              iv_textid = VALUE #( msgid = ls_job_log-msgid
                                   msgno = ls_job_log-msgno
                                   attr1 = ls_job_log-msgv1
                                   attr2 = ls_job_log-msgv2
                                   attr3 = ls_job_log-msgv3
                                   attr4 = ls_job_log-msgv4 )
              iv_type   = 'E'.
        ELSE.
          READ TABLE lt_job_log INTO ls_job_log WITH KEY msgtype = 'A'.
          IF sy-subrc EQ 0.
            "Erro ao importar o arquivo & na FF.5
            RAISE EXCEPTION TYPE lcl_exceptions
              EXPORTING
                iv_textid = VALUE #( msgid = ls_job_log-msgid
                                     msgno = ls_job_log-msgno
                                     attr1 = ls_job_log-msgv1
                                     attr2 = ls_job_log-msgv2
                                     attr3 = ls_job_log-msgv3
                                     attr4 = ls_job_log-msgv4 )
                iv_type   = 'E'.
          ELSE.
            "Erro ao importar o arquivo & na FF.5
            RAISE EXCEPTION TYPE lcl_exceptions
              EXPORTING
                iv_textid = lcl_exceptions=>gc_ff5_import_erro
                iv_type   = 'E'
                iv_msgv1  = CONV #( iv_file_name ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD bdc_dynpro.

    APPEND INITIAL LINE TO gt_bdcdata ASSIGNING FIELD-SYMBOL(<fs_dynpro>).
    <fs_dynpro>-program  = iv_program.
    <fs_dynpro>-dynpro   = iv_dynpro.
    <fs_dynpro>-dynbegin = 'X'.

  ENDMETHOD.

  METHOD bdc_field.

    APPEND INITIAL LINE TO gt_bdcdata ASSIGNING FIELD-SYMBOL(<fs_field>).
    <fs_field>-fnam = iv_fnam.
    <fs_field>-fval = iv_fval.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_main_report IMPLEMENTATION.

  METHOD create_instance.
    CREATE OBJECT ro_result.
  ENDMETHOD.

  METHOD check_job.
    DATA: lv_jobname  TYPE tbtcp-jobname,
          lv_jobcount TYPE tbtcp-jobcount,
          lv_status   TYPE tbtcp-status,
          lv_qtd      TYPE i.

    SELECT COUNT(*) FROM tbtcp INTO lv_qtd
     WHERE progname = sy-cprog
       AND status = 'R'.
    CHECK lv_qtd > 1.
    MESSAGE TEXT-E02 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE TO LIST-PROCESSING.
    LEAVE LIST-PROCESSING.
  ENDMETHOD.

  METHOD main.
    DATA: lv_fileread TYPE string,
          lv_fileproc TYPE string,
          lv_file     TYPE string,
          lv_tipo     TYPE ztfi_autbanc_log-tipo,
          lt_file     TYPE STANDARD TABLE OF x,
          ls_file     LIKE LINE OF lt_file.
    DATA(lv_log) = lcl_log=>create_instance( ).
    DATA: lv_msg_erro  TYPE   bapi_msg.

    "Verifica se existe algum JOB rodando em background.
    check_job( ).

    TRY.
        LOOP AT get_directorys_to_import( ) ASSIGNING FIELD-SYMBOL(<fs_s_directory>).
          TRY.
              "Processando os arquivos
              LOOP AT get_files( <fs_s_directory>-diretorio ) ASSIGNING FIELD-SYMBOL(<fs_s_file>).
                TRY.
                    "Verifica o tipo de arquivo a ser processado.
                    IF <fs_s_file>-name(3) NE 'EXT' AND
                       <fs_s_file>-name(3) NE 'COB' AND
                       <fs_s_file>-name(3) NE 'PAG' AND
                       <fs_s_file>-name(3) NE 'PGF'.
                      CONTINUE.
                    ENDIF.
                    DATA(lv_bank_file) = lcl_bank_file=>create_instance( ).
                    lv_bank_file->check_file( iv_file_name = <fs_s_file>-name ).

                    DATA(lv_chave) = lv_bank_file->process( iv_directory = <fs_s_directory>
                                                            iv_file_name = <fs_s_file>-name ).
                    "Arquivo importado com sucesso
                    MESSAGE s007 INTO DATA(lv_msg) WITH <fs_s_file>-name.
                    lv_log->insert_log( iv_diretorio        = <fs_s_directory>-diretorio
                                        iv_nome             = CONV char50( <fs_s_file>-name )
                                        iv_tipo             = <fs_s_directory>-tipo
                                        iv_message          = CONV #( lv_msg )
                                        iv_type             = 'S'
                                        iv_chave            = lv_chave ).

                    "Move o arquivo processado com sucesso para a pasta de processado.
                    CLEAR: lt_file, ls_file, lv_file.
                    DATA(lv_tam) = strlen( <fs_s_directory>-diretorio ) - 1.
                    IF <fs_s_directory>-diretorio+lv_tam CS '\'.
                      lv_fileread = |{ <fs_s_directory>-diretorio }{ <fs_s_file>-name }|.
                    ELSE.
                      lv_fileread = |{ <fs_s_directory>-diretorio }\\{ <fs_s_file>-name }|.
                    ENDIF.
                    "Efetuando a leitura do arquivo.
                    OPEN DATASET lv_fileread FOR INPUT IN BINARY MODE.
                    IF sy-subrc EQ 0.
                      DO.
                        READ DATASET lv_fileread INTO ls_file.
                        IF sy-subrc EQ 0.
                          APPEND ls_file TO lt_file.
                        ELSE.
                          EXIT.
                        ENDIF.
                      ENDDO.
                    ENDIF.

                    IF NOT lt_file IS INITIAL.
                      IF <fs_s_file>-name(3) = 'COB'.
                        lv_tipo = '6'.
                      ELSE.
                        lv_tipo = '5'.
                      ENDIF.
                      SELECT SINGLE diretorio INTO lv_fileproc
                        FROM ztfi_autbanc_dir
                       WHERE bukrs = <fs_s_directory>-bukrs
                         AND tipo = lv_tipo.
                      IF sy-subrc EQ 0.
                        IF <fs_s_directory>-diretorio+lv_tam CS '\'.
                          lv_fileproc = |{ lv_fileproc }{ <fs_s_file>-name }|.
                        ELSE.
                          lv_fileproc = |{ lv_fileproc }\\{ <fs_s_file>-name }|.
                        ENDIF.
                        "Efetuando a gravação do arquivo processado.
                        OPEN DATASET lv_fileproc FOR OUTPUT IN BINARY MODE.
                        IF sy-subrc EQ 0.
                          LOOP AT lt_file ASSIGNING FIELD-SYMBOL(<fs_file>).
                            TRANSFER <fs_file> TO lv_fileproc.
                          ENDLOOP.
                          IF sy-subrc EQ 0.
                            CLOSE DATASET lv_fileproc.
                            DELETE DATASET lv_fileread .
                          ENDIF.
                        ENDIF.
                      ENDIF.
                    ENDIF.

                  CATCH lcl_exceptions INTO DATA(lv_cx_erro).


                    "Tranferindo arquivo com erro para pasta de não processados
                    CLEAR: lt_file,  lv_file.
                    DATA(lv_tam_aux) = strlen( <fs_s_directory>-diretorio ) - 1.
                    IF <fs_s_directory>-diretorio+lv_tam_aux CS '\'.
                      lv_fileread = |{ <fs_s_directory>-diretorio }{ <fs_s_file>-name }|.
                    ELSE.
                      lv_fileread = |{ <fs_s_directory>-diretorio }\\{ <fs_s_file>-name }|.
                    ENDIF.

                    "Efetuando a leitura do arquivo.
                    OPEN DATASET lv_fileread FOR INPUT IN BINARY MODE.
                    IF sy-subrc EQ 0.
                      DO.
                        READ DATASET lv_fileread INTO ls_file.
                        IF sy-subrc EQ 0.
                          APPEND ls_file TO lt_file.
                        ELSE.
                          EXIT.
                        ENDIF.
                      ENDDO.
                    ENDIF.

                    IF NOT lt_file IS INITIAL.
                      IF <fs_s_file>-name(3) = 'COB'.
                        lv_tipo = '0'.
                      ELSE.
                        lv_tipo = '9'.
                      ENDIF.

                      SELECT SINGLE diretorio INTO lv_fileproc
                        FROM ztfi_autbanc_dir
                       WHERE bukrs = <fs_s_directory>-bukrs
                         AND tipo = lv_tipo.

                      IF sy-subrc EQ 0.
                        IF <fs_s_directory>-diretorio+lv_tam_aux CS '\'.
                          lv_fileproc = |{ lv_fileproc }{ <fs_s_file>-name }|.
                        ELSE.
                          lv_fileproc = |{ lv_fileproc }\\{ <fs_s_file>-name }|.
                        ENDIF.

                        "Efetuando a gravação do arquivo processado.
                        OPEN DATASET lv_fileproc FOR OUTPUT IN BINARY MODE.
                        IF sy-subrc EQ 0.
                          LOOP AT lt_file ASSIGNING <fs_file>.
                            TRANSFER <fs_file> TO lv_fileproc.
                          ENDLOOP.
                          IF sy-subrc EQ 0.
                            CLOSE DATASET lv_fileproc.
                            DELETE DATASET lv_fileread .
                          ENDIF.
                        ENDIF.
                      ENDIF.
                    ENDIF.

                    lv_msg_erro =  lv_cx_erro->get_text( ).

                    CONCATENATE TEXT-e01 lv_msg_erro INTO lv_msg_erro SEPARATED BY space.


                    lv_log->insert_log( iv_diretorio        = <fs_s_directory>-diretorio
                                        iv_nome             = CONV char50( <fs_s_file>-name )
                                        iv_tipo             = <fs_s_directory>-tipo
                                        iv_message          = lv_msg_erro
                                        iv_type             = lv_cx_erro->gv_type
                                        iv_chave            = lv_chave ).
                ENDTRY.
              ENDLOOP.
            CATCH lcl_exceptions INTO lv_cx_erro.
              lcl_main_report=>handle_error( iv_cx = lv_cx_erro iv_popup = 'A' ).
          ENDTRY.
        ENDLOOP.
      CATCH lcl_exceptions INTO lv_cx_erro.
        lcl_main_report=>handle_error( iv_cx = lv_cx_erro iv_popup = 'A' ).
    ENDTRY.

    IF lv_bank_file IS INITIAL.
      lv_bank_file = lcl_bank_file=>create_instance( ).
    ENDIF.

    lv_bank_file->execute_batch( ).

  ENDMETHOD.

  METHOD handle_error.
    DATA: lt_return TYPE bapiret2_t.

    lt_return = iv_cx->get_bapin_return( ).
    READ TABLE lt_return INTO DATA(ls_return) INDEX 1.
    CHECK sy-subrc = 0.

    "Mensagem footer
    IF iv_popup = 'A'.
      RETURN.
    ELSEIF iv_popup EQ abap_false.
      MESSAGE ID     ls_return-id
              TYPE   'S'
              NUMBER ls_return-number WITH ls_return-message_v1
                                           ls_return-message_v2
                                           ls_return-message_v3
                                           ls_return-message_v4 DISPLAY LIKE 'E'.

    ELSE.

      "Message in pop-up
      CALL FUNCTION 'FB_MESSAGES_DISPLAY_POPUP'
        EXPORTING
          it_return       = lt_return
        EXCEPTIONS
          no_messages     = 1
          popup_cancelled = 2
          OTHERS          = 3.
      IF sy-subrc NE 0. DATA(lv_dummy) = abap_true. ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD get_directorys_to_import.
    "Selecionando os diretórios para importação
    SELECT *
      FROM ztfi_autbanc_dir
      INTO TABLE rt_direcotrys
      WHERE tipo EQ '3'
         OR tipo EQ '4'.
    IF sy-subrc IS NOT INITIAL.
      "Nenhum diretório para importação configurado na transação ZBANCARIO001
      RAISE EXCEPTION TYPE lcl_exceptions
        EXPORTING
          iv_textid = lcl_exceptions=>gc_import_directorys_not_found.
    ELSE.
      SORT rt_direcotrys ASCENDING BY diretorio.
      DELETE ADJACENT DUPLICATES FROM rt_direcotrys COMPARING diretorio.
    ENDIF.
  ENDMETHOD.


  METHOD get_files.
    DATA: lv_dir TYPE eps2filnam.

    lv_dir = iv_path.
    CLEAR: rt_files.
    CALL FUNCTION 'EPS2_GET_DIRECTORY_LISTING'
      EXPORTING
        iv_dir_name            = lv_dir
        file_mask              = '*.*'
      TABLES
        dir_list               = rt_files
      EXCEPTIONS
        invalid_eps_subdir     = 1
        sapgparam_failed       = 2
        build_directory_failed = 3
        no_authorization       = 4
        read_directory_failed  = 5
        too_many_read_errors   = 6
        empty_directory_list   = 7
        OTHERS                 = 8.

    IF sy-subrc <> 0.
      CASE sy-subrc.
        WHEN 7.
          "Diretório Vazio
          RAISE EXCEPTION TYPE lcl_exceptions
            EXPORTING
              iv_textid = lcl_exceptions=>gc_directory_empty
              iv_msgv1  = lv_dir(50)
              iv_msgv2  = lv_dir+50(50)
              iv_type   = 'W'.
        WHEN OTHERS.
          "Erro ao tentar ler o diretório
          RAISE EXCEPTION TYPE lcl_exceptions
            EXPORTING
              iv_textid = lcl_exceptions=>gc_read_directory_failed
              iv_msgv1  = lv_dir(50)
              iv_msgv2  = lv_dir+50(50)
              iv_type   = 'W'.
      ENDCASE.
    ENDIF.
  ENDMETHOD.

ENDCLASS.
