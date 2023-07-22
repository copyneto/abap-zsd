CLASS zclsd_nf_mass_download DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: gt_mdfe_printed TYPE SORTED TABLE OF zttm_mdf-mdfenum
                          WITH UNIQUE KEY table_line.

    DATA gv_pdf_file TYPE xstring .
    DATA gt_return TYPE bapiret2_t .
    DATA gt_otf TYPE tsfotf.

    CLASS-DATA go_instance TYPE REF TO zclsd_nf_mass_download.

    CLASS-METHODS:
      "! Cria instancia
      get_instance
        RETURNING
          VALUE(ro_instance) TYPE REF TO zclsd_nf_mass_download.

    "! Responsável por imprimir o formulário
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter iv_doctype | Tipo de documento (NFE,CCE,BOLETO,MDFE)
    "! @parameter is_parameters | Parâmetros
    "! @parameter et_return | Mensagens de retorno
    METHODS imprime_pdf
      IMPORTING
        !iv_docnum     TYPE any
        !iv_doctype    TYPE any
        !is_parameters TYPE zc_sd_nf_imp_massa_printer
      EXPORTING
        !et_return     TYPE bapiret2_t .
    "! Responsável por gerenciar o tipo de documento solicitado
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter iv_doctype | Tipo de documento (NFE,CCE,BOLETO,MDFE)
    "! @parameter et_pdf | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filename | Nome do arquivo
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter ev_doctype_txt | Descriçãodo tipo escolhido
    "! @parameter et_return | Mensagens de retorno
    METHODS gera_pdf
      IMPORTING
        !iv_docnum      TYPE any
        !iv_doctype     TYPE any
        !iv_printer     TYPE rspopname OPTIONAL
      EXPORTING
        !et_pdf         TYPE tline_t
        !et_otf         TYPE tsfotf
        !ev_filename    TYPE string
        !ev_filesize    TYPE int4
        !ev_file        TYPE xstring
        !ev_doctype_txt TYPE string
        !et_return      TYPE bapiret2_t .

    "! Responsável por verificar se NF já foi impressa em outra MDF-e
    METHODS verifica_mdfe_impressa
      IMPORTING
        !iv_docnum       TYPE j_1bdocnum
        !iv_mdfenum      TYPE zttm_mdf-mdfenum
      EXPORTING
        !et_return       TYPE bapiret2_t
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t.

    "! Recupera o formulário NFE do documento solicitado
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter et_pdf | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS gera_pdf_nfe
      IMPORTING
        !iv_docnum   TYPE j_1bdocnum
        !iv_printer  TYPE rspopname
      EXPORTING
        !et_pdf      TYPE tline_t
        !et_otf      TYPE tsfotf
        !ev_filesize TYPE int4
        !ev_file     TYPE xstring
        !et_return   TYPE bapiret2_t .
    "! Recupera o formulário CCE do documento solicitado
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter et_pdf | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS gera_pdf_cce
      IMPORTING
        !iv_docnum   TYPE j_1bdocnum
        !iv_printer  TYPE rspopname
      EXPORTING
        !et_pdf      TYPE tline_t
        !et_otf      TYPE tsfotf
        !ev_filesize TYPE int4
        !ev_file     TYPE xstring
        !et_return   TYPE bapiret2_t .
    "! Recupera o BOLET do documento solicitado
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter et_pdf | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter et_return | Mensagens de retorno
    METHODS gera_pdf_boleto
      IMPORTING
        !iv_docnum   TYPE j_1bdocnum
        !iv_printer  TYPE rspopname
      EXPORTING
        !et_pdf      TYPE tline_t
        !et_otf      TYPE tsfotf
        !ev_filesize TYPE int4
        !ev_file     TYPE xstring
        !et_return   TYPE bapiret2_t .
    "! Recupera o formulário MDF-E do documento solicitado
    "! @parameter iv_docnum | Nº Documento NF
    "! @parameter et_lines | Tabela de valores
    "! @parameter et_otf | Tabela OTF
    "! @parameter ev_filesize | Tamanho do arquivo
    "! @parameter ev_file | Binário do arquivo
    "! @parameter et_return | Mensagens de retorno
    "! @parameter cv_filename | Nome do arquivo
    METHODS gera_pdf_mdfe
      IMPORTING
        !iv_docnum      TYPE j_1bdocnum
        !iv_printer     TYPE rspopname
        !iv_doctype_txt TYPE string
      EXPORTING
        !et_lines       TYPE tline_t
        !et_otf         TYPE tsfotf
        !ev_filesize    TYPE int4
        !ev_file        TYPE xstring
        !et_return      TYPE bapiret2_t
      CHANGING
        !cv_filename    TYPE string.
    "! Método executado após chamada da função background
    "! @parameter p_task | Parametro obrigatório do método
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Adiciona mensagens
    "! @parameter io_context |Objeto com o conteudo
    "! @parameter it_return  |Tabela com as mensagens
    "! @parameter ro_message_container | Retorna objeto preecnhido
    METHODS add_message_to_container
      IMPORTING
        !io_context                 TYPE REF TO /iwbep/if_mgw_context
        !it_return                  TYPE bapiret2_t OPTIONAL
      RETURNING
        VALUE(ro_message_container) TYPE REF TO /iwbep/if_message_container .
    METHODS set_filter_str
      IMPORTING
        !iv_filter_string         TYPE string
      EXPORTING
        !et_filter_select_options TYPE /iwbep/t_mgw_select_option .
    "! Preenche mensagens
    "! @parameter rv_message |Retorna mensagens
    METHODS fill_message
      RETURNING
        VALUE(rv_message) TYPE bapi_msg .
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS check_messages
      IMPORTING
        iv_print  TYPE rspopname
      CHANGING
        ct_return TYPE bapiret2_t.


ENDCLASS.



CLASS zclsd_nf_mass_download IMPLEMENTATION.


  METHOD get_instance.

    IF ( go_instance IS INITIAL ).
      go_instance = NEW zclsd_nf_mass_download( ).
    ENDIF.

    ro_instance = go_instance.

  ENDMETHOD.


  METHOD imprime_pdf.
    CONSTANTS lc_locl TYPE string VALUE 'LOCL' ##NO_TEXT.
    CONSTANTS lc_lp01 TYPE string VALUE 'LP01' ##NO_TEXT.

    DATA: lt_return_form  TYPE bapiret2_t,
          lv_spoolid      TYPE rspoid,
          ls_printoptions TYPE itcpo,
          lt_otf          TYPE tsfotf.
    FREE: et_return.

* ----------------------------------------------------------------------
* Recupera impressora padrão do usuário
* ----------------------------------------------------------------------
    IF is_parameters-printer IS INITIAL.

      SELECT SINGLE spld
        FROM usr01
        INTO @DATA(lv_dest)
        WHERE bname = @sy-uname.

      IF sy-subrc NE 0 OR lv_dest IS INITIAL.
        lv_dest = lc_locl.
      ENDIF.

* ----------------------------------------------------------------------
* Verifica se impressora solicita existe
* ----------------------------------------------------------------------
    ELSE.

      SELECT SINGLE padest
        FROM tsp03
        INTO @lv_dest
        WHERE padest  = @is_parameters-printer.

      IF sy-subrc NE 0.

        " Impressora &1 não existe.
        et_return[] =  VALUE #( BASE et_return ( type       = 'E'
                                                 id         = 'ZSD_IMPRESSAO_NF'
                                                 number     = '005'
                                                 message_v1 = is_parameters-printer ) ).
        RETURN.
      ENDIF.
    ENDIF.

    DO 4 TIMES.

**** ----------------------------------------------------------------------
**** Recupera formulário
**** ----------------------------------------------------------------------
* ----------------------------------------------------------------------
* Imprime formulário
* ----------------------------------------------------------------------
      me->gera_pdf( EXPORTING iv_docnum      = iv_docnum
                              iv_doctype     = sy-index
                              iv_printer     = lv_dest
                    IMPORTING et_otf         = lt_otf
                              ev_file        = DATA(lv_file)
                              ev_doctype_txt = DATA(lv_doctype_txt)
                              et_return      = DATA(lt_return) ).

      INSERT LINES OF lt_return[] INTO TABLE et_return[].

***      IF lv_file IS INITIAL.
***      INSERT LINES OF lt_return[] INTO TABLE lt_return_form[].
***        CONTINUE.
***      ENDIF.

      "Trecho comentado pois precisa imprimir em massa para a impressora e
      "não somente gerar nº Spool
**** ----------------------------------------------------------------------
**** Imprime formulário
**** ----------------------------------------------------------------------
***
***      IF lv_dest NE lc_lp01.
***
***        ls_printoptions-tddest        = lv_dest.
***        ls_printoptions-tdnewid       = abap_true.
***
***        CALL FUNCTION 'PRINT_OTF'
***          EXPORTING
***            printoptions = ls_printoptions
***          IMPORTING
***            otf_printer  = lv_dest
***            spoolid      = lv_spoolid
***          TABLES
***            otf          = lt_otf.
***
***
***        IF lv_spoolid IS INITIAL.
***          et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
***                                                   id         = sy-msgid
***                                                   number     = sy-msgno
***                                                   message_v1 = sy-msgv1
***                                                   message_v2 = sy-msgv2
***                                                   message_v3 = sy-msgv3
***                                                   message_v4 = sy-msgv4 ) ).
***          CONTINUE.
***        ENDIF.
***
***      ELSE.
***
***
***        CALL FUNCTION 'ADS_CREATE_PDF_SPOOLJOB'
***          EXPORTING
***            dest              = lv_dest
***            pages             = 1
***            pdf_data          = lv_file
***            immediate_print   = abap_true
***          IMPORTING
***            spoolid           = lv_spoolid
***          EXCEPTIONS
***            no_data           = 1
***            not_pdf           = 2
***            wrong_devtype     = 3
***            operation_failed  = 4
***            cannot_write_file = 5
***            device_missing    = 6
***            no_such_device    = 7
***            OTHERS            = 8.
***
***        IF sy-subrc <> 0.
***          et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
***                                                   id         = sy-msgid
***                                                   number     = sy-msgno
***                                                   message_v1 = sy-msgv1
***                                                   message_v2 = sy-msgv2
***                                                   message_v3 = sy-msgv3
***                                                   message_v4 = sy-msgv4 ) ).
***          CONTINUE.
***        ENDIF.
***      ENDIF.
***
***
***      " Doc &1: Form. &2 impresso no spool &3.
***      et_return[] =  VALUE #( BASE et_return ( type       = 'S'
***                                               id         = 'ZSD_IMPRESSAO_NF'
***                                               number     = '003'
***                                               message_v1 = iv_docnum
***                                               message_v2 = lv_doctype_txt
***                                               message_v3 = lv_spoolid ) ).


    ENDDO.

    check_messages(
         EXPORTING
            iv_print = lv_dest
         CHANGING
            ct_return = et_return ).

***    " Caso nenhum documento impresso, mostrar todos os erros
***    IF et_return IS INITIAL.
***      INSERT LINES OF lt_return_form[] INTO TABLE et_return[].
***    ENDIF.

  ENDMETHOD.


  METHOD gera_pdf.

    DATA: lt_return  TYPE bapiret2_t,
          lv_docnum  TYPE j_1bdocnum,
          lv_doctype TYPE ze_doctype_pdf.

    FREE: et_pdf, ev_filename, ev_filesize, ev_file, ev_doctype_txt, et_return.

    lv_docnum  = |{ iv_docnum ALPHA = IN }|.
    lv_doctype = iv_doctype.

* ----------------------------------------------------------------------
* Recupera descrição
* ----------------------------------------------------------------------
    SELECT SINGLE ddtext
      FROM dd07t
      INTO @ev_doctype_txt
      WHERE domname = 'ZD_DOCTYPE_PDF'
        AND ddlanguage = @sy-langu
        AND domvalue_l = @lv_doctype.

    IF sy-subrc NE 0.
      CLEAR ev_doctype_txt.
    ENDIF.

    " Nome do arquivo
    ev_filename = |{ lv_docnum }_{ ev_doctype_txt }_{ sy-datum }{ sy-uzeit }.pdf|.

* ----------------------------------------------------------------------
* Recupera PDF do tipo solicitado
* ----------------------------------------------------------------------
    CASE lv_doctype.

      WHEN gc_doctype-nfe.

        me->gera_pdf_nfe( EXPORTING iv_docnum   = lv_docnum
                                    iv_printer  = iv_printer
                          IMPORTING et_pdf      = et_pdf
                                    et_otf      = et_otf
                                    ev_filesize = ev_filesize
                                    ev_file     = ev_file
                                    et_return   = lt_return ).

      WHEN gc_doctype-cce.

        me->gera_pdf_cce( EXPORTING iv_docnum   = lv_docnum
                                    iv_printer  = iv_printer
                          IMPORTING et_pdf      = et_pdf
                                    et_otf      = et_otf
                                    ev_filesize = ev_filesize
                                    ev_file     = ev_file
                                    et_return   = lt_return ).

      WHEN gc_doctype-boleto.

        me->gera_pdf_boleto( EXPORTING iv_docnum   = lv_docnum
                                       iv_printer  = iv_printer
                             IMPORTING et_pdf      = et_pdf
                                       et_otf      = et_otf
                                       ev_filesize = ev_filesize
                                       ev_file     = ev_file
                                       et_return   = lt_return ).

      WHEN gc_doctype-mdfe.

        me->gera_pdf_mdfe( EXPORTING iv_docnum      = lv_docnum
                                     iv_printer     = iv_printer
                                     iv_doctype_txt = ev_doctype_txt    " INSERT - JWSILVA - 14.07.2023
                           IMPORTING et_lines       = et_pdf
                                     et_otf         = et_otf
                                     ev_filesize    = ev_filesize
                                     ev_file        = ev_file
                                     et_return      = lt_return
                           CHANGING  cv_filename    = ev_filename ).    " INSERT - JWSILVA - 14.07.2023
    ENDCASE.


***    IF ev_file IS INITIAL.

    IF lt_return IS INITIAL.
***        " Doc &1: Formulário &2 não encontrado.
***        et_return[] =  VALUE #( BASE et_return ( type       = 'E'
***                                                 id         = 'ZSD_IMPRESSAO_NF'
***                                                 number     = '001'
***                                                 message_v1 = iv_docnum
***                                                 message_v2 = ev_doctype_txt ) ).
      " Doc &1: Formulário &2 gerado.
      et_return[] =  VALUE #( BASE et_return ( type       = 'S'
                                               id         = 'ZSD_IMPRESSAO_NF'
                                               number     = '002'
                                               message_v1 = iv_docnum
                                               message_v2 = ev_doctype_txt ) ).
    ELSE.
      APPEND LINES OF lt_return[] TO et_return[].
    ENDIF.

***    ELSE.

***      " Doc &1: Formulário &2 gerado.
***      et_return[] =  VALUE #( BASE et_return ( type       = 'S'
***                                               id         = 'ZSD_IMPRESSAO_NF'
***                                               number     = '002'
***                                               message_v1 = iv_docnum
***                                               message_v2 = ev_doctype_txt ) ).

***    ENDIF.

  ENDMETHOD.


  METHOD verifica_mdfe_impressa.

    FREE: et_return.

    READ TABLE gt_mdfe_printed TRANSPORTING NO FIELDS WITH TABLE KEY table_line = iv_mdfenum.

    IF sy-subrc EQ 0.
      " Doc &1: MDF-e &2 já foi impresso.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                               id         = gc_msg_class
                                               number     = gc_msg_mdfe_ja_impresso
                                               message_v1 = iv_docnum
                                               message_v2 = iv_mdfenum ) ).
      rt_return[] = et_return[].
      RETURN.
    ENDIF.

    INSERT iv_mdfenum INTO TABLE gt_mdfe_printed.

  ENDMETHOD.


  METHOD gera_pdf_nfe.

    DATA: lv_pdf_nfe TYPE char1,
          lv_buf_id  TYPE indx_srtfd.

    CONSTANTS: lc_nfe TYPE j_1bnfdoc-model VALUE '55'.

    FREE: et_pdf,
          ev_filesize,
          ev_file,
          et_return.

    SELECT SINGLE code
      FROM j_1bnfdoc
     WHERE docnum = @iv_docnum
       AND model  = @lc_nfe
      INTO @DATA(lv_code).

    IF lv_code EQ 100.

      IF iv_printer IS INITIAL.
        " Import no report ZNFE_PRINT_DANFE
        lv_pdf_nfe = abap_true.
        lv_buf_id = 'NFE_PDF_' && iv_docnum.
        EXPORT lv_pdf_nfe = lv_pdf_nfe TO MEMORY ID lv_buf_id.
      ELSE.
        sy-tcode = 'ZZ1_NF_MASSA'.
      ENDIF.

      CALL FUNCTION 'ZFMSD_GET_DANFE_PDF'
        EXPORTING
          iv_docnum            = iv_docnum
          iv_printer           = iv_printer
        IMPORTING
          et_file              = et_pdf
          ev_filesize          = ev_filesize
          ev_file              = ev_file
        TABLES
          et_otf               = et_otf
        EXCEPTIONS
          document_not_found   = 1
          nfe_not_approved     = 2
          nfe_not_printed      = 3
          conversion_exception = 4
          print_program_error  = 5
          OTHERS               = 6.

      IF sy-subrc <> 0.
        et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
                                                 id         = sy-msgid
                                                 number     = sy-msgno
                                                 message_v1 = sy-msgv1
                                                 message_v2 = sy-msgv2
                                                 message_v3 = sy-msgv3
                                                 message_v4 = sy-msgv4 ) ).
      ENDIF.
    ELSE.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                               id         = gc_msg_class
                                               number     = gc_msg_nt_auth
                                               message_v1 = iv_docnum ) ).
    ENDIF.

  ENDMETHOD.


  METHOD gera_pdf_boleto.

    TYPES: BEGIN OF ty_documento,
             vbeln TYPE vbrk-vbeln,
           END OF ty_documento.

    DATA: lo_gerar_boleto TYPE REF TO zclfi_gerar_boleto.

    DATA: lt_key       TYPE zctgfi_post_key,
          lt_documento TYPE STANDARD TABLE OF ty_documento,
          lt_return    TYPE bapiret2_t.

    DATA: ls_param     TYPE ssfctrlop,
          ls_documento TYPE ty_documento,
          ls_process   TYPE zsfi_boleto_process.

    DATA: lv_pdf_file	TYPE xstring,
          lv_key      TYPE ze_key.

    CONSTANTS: lc_reftyp TYPE j_1bnflin-reftyp VALUE 'BI'.

    FREE: et_pdf, ev_filesize, ev_file, et_return.

    SELECT SINGLE code
      FROM j_1bnfdoc
     WHERE docnum = @iv_docnum
      INTO @DATA(lv_code).

    IF lv_code EQ 100.

      SELECT docnum,
             refkey
        FROM j_1bnflin
       WHERE docnum = @iv_docnum
         AND reftyp = @lc_reftyp
        INTO TABLE @DATA(lt_lin).                    "#EC CI_SEL_NESTED

      IF sy-subrc IS INITIAL.

        LOOP AT lt_lin ASSIGNING FIELD-SYMBOL(<fs_lin>).

          ls_documento-vbeln = <fs_lin>-refkey.
          APPEND ls_documento TO lt_documento.
          CLEAR ls_documento.

        ENDLOOP.

        SELECT a~vbeln,
               b~empresa,
               b~documento,
               b~ano,
               b~item
          FROM vbrk AS a
         INNER JOIN zi_fi_boleto AS b
                 ON b~empresa   = a~bukrs
                AND b~documento = a~belnr
                AND b~ano       = a~gjahr
           FOR ALL ENTRIES IN @lt_documento
         WHERE vbeln = @lt_documento-vbeln
          INTO TABLE @DATA(lt_boleto).               "#EC CI_SEL_NESTED

        IF sy-subrc IS INITIAL.

* pferraz 8000008279- App Emissão de Boletos GAP 002 - inicio
          CLEAR: lv_key.
          LOOP AT lt_boleto ASSIGNING FIELD-SYMBOL(<fs_boleto>).

            IF sy-tabix = 1.
              CONCATENATE <fs_boleto>-empresa
                        <fs_boleto>-documento
                        <fs_boleto>-ano
                        <fs_boleto>-item
                   INTO lv_key.
            ELSE.
              CONCATENATE lv_key
                        ';'
                        <fs_boleto>-empresa
                        <fs_boleto>-documento
                        <fs_boleto>-ano
                        <fs_boleto>-item
                   INTO lv_key.
            ENDIF.

          ENDLOOP.
          APPEND lv_key TO lt_key.
* pferraz 8000008279- App Emissão de Boletos GAP 002 - Fim

          IF lt_key[] IS NOT INITIAL.

            ls_process-app     = abap_true.
            ls_param-no_dialog = abap_true.
            ls_param-device    = iv_printer.

*            lo_gerar_boleto = NEW zclfi_gerar_boleto( is_process = ls_process
*                                                      is_param   = ls_param ).
*
*            lo_gerar_boleto->process(
*              EXPORTING
*                it_key      = lt_key
*              IMPORTING
*                ev_pdf_file = lv_pdf_file ).
*
*            ev_file = lv_pdf_file.

            CALL FUNCTION 'ZFMSD_GERAR_BOLETO'
              STARTING NEW TASK 'GERA_BOLETO' CALLING task_finish ON END OF TASK
              EXPORTING
                is_process = ls_process
                is_param   = ls_param
                it_key     = lt_key
              TABLES
                et_return  = lt_return.

            WAIT FOR ASYNCHRONOUS TASKS UNTIL lt_return IS NOT INITIAL.

            ev_file = gv_pdf_file.
            et_otf  = gt_otf.
            IF ev_file IS INITIAL.
              APPEND LINES OF gt_return[] TO et_return[].
            ENDIF.
          ENDIF.
        ELSE.
          et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                                   id         = gc_msg_class
                                                   number     = gc_msg_boleto
                                                   message_v1 = iv_docnum ) ).
        ENDIF.
      ENDIF.
    ELSE.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                               id         = gc_msg_class
                                               number     = gc_msg_nt_auth
                                               message_v1 = iv_docnum ) ).
    ENDIF.

  ENDMETHOD.


  METHOD task_finish.
    RECEIVE RESULTS FROM FUNCTION 'ZFMSD_GERAR_BOLETO'
    IMPORTING
     ev_pdf_file = gv_pdf_file
     TABLES
     et_otf      = gt_otf
     et_return   = gt_return.
    RETURN.
  ENDMETHOD.


  METHOD gera_pdf_cce.

    DATA: lv_pdf_nfe TYPE char1,
          lv_buf_id  TYPE indx_srtfd.

*    CONSTANTS: lc_cce TYPE c VALUE 'ZCCE'.

    FREE: et_pdf,
          ev_filesize,
          ev_file,
          et_return.

    SELECT SINGLE * FROM j_1bnfe_event
            INTO @DATA(ls_event)
            WHERE docnum    EQ @iv_docnum
            AND int_event EQ 'EV_CCE'
            AND ( code EQ '100' OR code EQ '135' ).

    IF ls_event IS NOT INITIAL.

      SELECT SINGLE code
        FROM j_1bnfdoc
       WHERE docnum = @iv_docnum
        INTO @DATA(lv_code).

      IF lv_code EQ 100.

        IF iv_printer IS INITIAL.
          " Import no report ZNFE_PRINT_DANFE
          lv_pdf_nfe = abap_true.
          lv_buf_id = 'NFE_PDF_' && iv_docnum.
          EXPORT lv_pdf_nfe = lv_pdf_nfe TO MEMORY ID lv_buf_id.
        ELSE.
          sy-tcode = 'ZZ1_NF_MASSA'.
        ENDIF.

        CALL FUNCTION 'ZFMSD_GET_CCE_PDF'
          EXPORTING
            iv_docnum            = iv_docnum
            iv_printer           = iv_printer
          IMPORTING
            et_file              = et_pdf
            ev_filesize          = ev_filesize
            ev_file              = ev_file
          TABLES
            et_otf               = et_otf
          EXCEPTIONS
            document_not_found   = 1
            nfe_not_approved     = 2
            nfe_not_printed      = 3
            conversion_exception = 4
            print_program_error  = 5
            OTHERS               = 6.

        IF sy-subrc <> 0.
          et_return[] =  VALUE #( BASE et_return ( type       = sy-msgty
                                                   id         = sy-msgid
                                                   number     = sy-msgno
                                                   message_v1 = sy-msgv1
                                                   message_v2 = sy-msgv2
                                                   message_v3 = sy-msgv3
                                                   message_v4 = sy-msgv4 ) ).
        ENDIF.
      ELSE.
        et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_error
                                                 id         = gc_msg_class
                                                 number     = gc_msg_nt_auth
                                                 message_v1 = iv_docnum ) ).
      ENDIF.
    ELSE.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                               id         = gc_msg_class
                                               number     = gc_msg_cce
                                               message_v1 = iv_docnum ) ).
    ENDIF.

  ENDMETHOD.


  METHOD gera_pdf_mdfe.

    DATA lt_id TYPE zcltm_monitor_mdf=>ty_t_id.

    FREE: et_lines[],
          ev_filesize,
          ev_file,
          et_return.

    SELECT SINGLE a~guid, a~BR_MDFeNumber, a~statuscode, a~statustext
      FROM zi_tm_mdf AS a
      INNER JOIN zi_tm_mdf_municipio AS b ON a~guid = b~guid
      WHERE b~br_notafiscal EQ @iv_docnum
      INTO @DATA(ls_nfe_data).

    IF sy-subrc NE 0.
      " Doc &1: MDF-e inexistente.
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                               id         = gc_msg_class
                                               number     = gc_msg_mdfe_nf
                                               message_v1 = iv_docnum ) ).
      RETURN.
    ENDIF.

    IF ls_nfe_data-statuscode NE '100'.
      " Doc &1: MDF-e - &2
      et_return[] =  VALUE #( BASE et_return ( type       = gc_msg_warnig
                                               id         = gc_msg_class
                                               number     = gc_msg_nt_auth
                                               message_v1 = iv_docnum
                                               message_v2 = ls_nfe_data-statustext ) ).
      RETURN.
    ENDIF.

* BEGIN OF INSERT - JWSILVA - 14.07.2023
* ----------------------------------------------------------------------
* Verifica se a MDF-e já foi impressa por outra NF na fila
* ----------------------------------------------------------------------
    et_return = me->verifica_mdfe_impressa( EXPORTING iv_docnum  = iv_docnum
                                                      iv_mdfenum = ls_nfe_data-BR_MDFeNumber ).

    IF et_return IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Muda nome do arquivo
    cv_filename = |{ ls_nfe_data-BR_MDFeNumber }_{ iv_doctype_txt }_{ sy-datum }{ sy-uzeit }.pdf|.
* END OF INSERT - JWSILVA - 14.07.2023


    DATA(lo_pdf) = zcltm_monitor_mdf=>get_instance( ).
    APPEND VALUE #( guid = ls_nfe_data-guid ) TO lt_id.

    lo_pdf->print_pdf( EXPORTING it_id       = lt_id
                                 iv_printer  = iv_printer
                       IMPORTING ev_pdf_file = ev_file
                                 et_return   = et_return ).

  ENDMETHOD.


  METHOD set_filter_str.

    DATA:
      lt_filter_string          TYPE TABLE OF string,
      lt_key_value              TYPE /iwbep/t_mgw_name_value_pair,
      lv_input                  TYPE string,
      lv_name                   TYPE string,
      lv_doctype                TYPE string,
      lv_value                  TYPE string,
      lv_value2                 TYPE string,
      lv_sign                   TYPE string,
      lv_sign2                  TYPE string,

      lt_filter_select_options  TYPE TABLE OF /iwbep/s_mgw_select_option,
      ls_filter_select_options  TYPE /iwbep/s_mgw_select_option,
      lt_select_options         TYPE /iwbep/t_cod_select_options,
      ls_select_options         TYPE /iwbep/s_cod_select_option,
      lt_filter_select_options2 TYPE /iwbep/t_mgw_select_option,
      ls_filter_select_options2 TYPE /iwbep/s_mgw_select_option.

    FIELD-SYMBOLS:
      <fs_range_tab>     LIKE LINE OF lt_filter_select_options,
      <fs_select_option> TYPE /iwbep/s_cod_select_option,
      <fs_key_value>     LIKE LINE OF lt_key_value.

*******************************************************************************
    IF iv_filter_string IS NOT INITIAL.
      lv_input = iv_filter_string.

* *--- get rid of )( & ' and make AND's uppercase
      REPLACE ALL OCCURRENCES OF ')' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF '(' IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF `'` IN lv_input WITH ''.
      REPLACE ALL OCCURRENCES OF ' and ' IN lv_input WITH ' AND '.
      REPLACE ALL OCCURRENCES OF ' or ' IN lv_input WITH ' OR '.
      REPLACE ALL OCCURRENCES OF ' eq ' IN lv_input WITH ' EQ '.
      SPLIT lv_input AT 'AND' INTO TABLE lt_filter_string.

* *--- build a table of key value pairs based on filter string
      LOOP AT lt_filter_string ASSIGNING FIELD-SYMBOL(<fs_filter_string>).
        CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
        APPEND INITIAL LINE TO lt_key_value ASSIGNING <fs_key_value>.

        CONDENSE <fs_filter_string>.
*       Split at space, then split into 3 parts
        SPLIT <fs_filter_string> AT ' ' INTO lv_name lv_sign lv_value  .
        TRANSLATE lv_sign TO UPPER CASE.
        ls_select_options-sign = 'I'.
        ls_select_options-option = lv_sign.
        ls_select_options-low = lv_value.
        APPEND ls_select_options TO lt_select_options. CLEAR:ls_select_options.
        ls_filter_select_options-property = lv_name.
        ls_filter_select_options-select_options = lt_select_options.

        APPEND ls_filter_select_options TO lt_filter_select_options.
        CLEAR: ls_filter_select_options.
      ENDLOOP.
      CLEAR: ls_select_options, ls_filter_select_options, lt_select_options.
    ENDIF.

    et_filter_select_options = lt_filter_select_options.


  ENDMETHOD.


  METHOD add_message_to_container.
    ro_message_container = io_context->get_message_container( ).

    IF it_return IS SUPPLIED AND it_return IS NOT INITIAL.

      LOOP AT it_return INTO DATA(ls_return).

        IF ls_return-id     IS NOT INITIAL AND
           ls_return-type   IS NOT INITIAL.

          MESSAGE ID ls_return-id
             TYPE ls_return-type
           NUMBER ls_return-number
            WITH ls_return-message_v1
                 ls_return-message_v2
                 ls_return-message_v3
                 ls_return-message_v4
            INTO DATA(lv_dummy).

          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               = CONV #( fill_message( ) )
                            iv_add_to_response_header = abap_false ).

        ELSE.
          ro_message_container->add_message_text_only(
                  EXPORTING iv_msg_type               = ls_return-type
                            iv_msg_text               =  ls_return-message
                            iv_add_to_response_header = abap_false ).
        ENDIF.

      ENDLOOP.

    ELSE.
      ro_message_container->add_message_text_only(
              EXPORTING iv_msg_type               = sy-msgty
                        iv_msg_text               = CONV #( fill_message( ) )
                        iv_add_to_response_header = abap_true ).
    ENDIF.

  ENDMETHOD.


  METHOD fill_message.

    MESSAGE ID sy-msgid
      TYPE sy-msgty
    NUMBER sy-msgno
      INTO rv_message
      WITH sy-msgv1
           sy-msgv2
           sy-msgv3
           sy-msgv4.
  ENDMETHOD.

  METHOD check_messages.

    IF line_exists( ct_return[  type = 'S' ] ).
      APPEND VALUE bapiret2(
                                             type              = 'S'
                                             id                  = 'ZSD_IMPRESSAO_NF'
                                             number         = '011'
                                             message_v1 = iv_print
                                              ) TO ct_return.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
