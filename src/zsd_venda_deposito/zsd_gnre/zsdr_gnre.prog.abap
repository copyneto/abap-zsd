*&---------------------------------------------------------------------*
*& Report ZSDR_GNRE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_gnre.

TABLES: j_1binnad, j_1bnfdoc.", bseg.

*-----------------------------------------------------------------------
* Variáveis Globais
*-----------------------------------------------------------------------
DATA: gv_partner_type TYPE j_1bnfnad-partyp,
      gv_partner_id   TYPE j_1bnfnad-parid,
      gv_doc_number   TYPE j_1bnfdoc-docnum.

DATA: gv_smartforms TYPE string,
      gv_fnnumb(8)  TYPE n.

*-----------------------------------------------------------------------
* TABELAS INTERNAS
*-----------------------------------------------------------------------
DATA: gs_ztsd_024             TYPE ztsd_024,
      gs_zssd_gnre_smartforms TYPE zssd_gnre_smartforms.

DATA: gs_control_parameters TYPE ssfctrlop,
      gs_job_output_info    TYPE ssfcrescl.

*-----------------------------------------------------------------------
* PARAMETROS DE SELEÇÃO
*-----------------------------------------------------------------------
SELECTION-SCREEN: BEGIN OF BLOCK bloco WITH FRAME TITLE TEXT-001.

  PARAMETERS: p_vbeln TYPE ztsd_024-vbeln.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS: p_visua AS CHECKBOX.
    SELECTION-SCREEN COMMENT (15) TEXT-003.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    SELECTION-SCREEN POSITION 1.
    PARAMETERS :p_pdf AS CHECKBOX.
    SELECTION-SCREEN COMMENT (10) TEXT-002.
    SELECTION-SCREEN POSITION 13.
    PARAMETERS: p_file TYPE string DEFAULT 'C:\TEMP\'.
  SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN: END OF BLOCK bloco.


*-----------------------------------------------------------------------
* INICIO DA SELEÇÃO
*-----------------------------------------------------------------------
START-OF-SELECTION.

  PERFORM f_monta_tabelas_interna.  "Montagem da Tabela Interna.


*&---------------------------------------------------------------------*
*&      Form  F_MONTA_TABELAS_INTERNA
*&---------------------------------------------------------------------*
FORM f_monta_tabelas_interna.
  DATA: lv_bankl  TYPE t012-bankl,
        lv_bankn  TYPE t012k-bankn,
        lv_bkont  TYPE t012k-bkont,
        lv_strlen TYPE i.

  SELECT * FROM ztsd_024
    INTO TABLE @DATA(lt_ztsd_024)
      WHERE vbeln EQ @p_vbeln
      ORDER BY vbeln, fkdat, promocao.

  IF sy-subrc EQ 0.
    LOOP AT lt_ztsd_024 INTO gs_ztsd_024. ENDLOOP.
  ENDIF.

  IF gs_ztsd_024 IS INITIAL.
    MESSAGE TEXT-m01 TYPE 'I'.
    STOP.
  ENDIF.

  SELECT SINGLE * FROM j_1bnfdoc
   INTO j_1bnfdoc
      WHERE docnum EQ gs_ztsd_024-docnum.

  IF sy-subrc EQ 0.
    gv_partner_type = 'B'.
    gv_partner_id   = j_1bnfdoc-bukrs.
    gv_partner_id+4 = j_1bnfdoc-branch.
    gv_doc_number   = j_1bnfdoc-docnum.

    CALL FUNCTION 'J_1B_NF_PARTNER_READ'
      EXPORTING
        partner_type           = gv_partner_type
        partner_id             = gv_partner_id
        doc_number             = gv_doc_number
      IMPORTING
        parnad                 = j_1binnad
      EXCEPTIONS
        partner_not_found      = 1
        partner_type_not_found = 2
        OTHERS                 = 3.

    IF sy-subrc EQ 0.

      CALL FUNCTION 'SSF_READ_FMNUMBER'
        EXPORTING
          i_formname = 'ZGNRE'
        IMPORTING
          o_fmnumb   = gv_fnnumb.

      CONCATENATE '/1BCDWB/SF'
               gv_fnnumb
               INTO gv_smartforms.

      IF p_visua EQ 'X'.
        gs_control_parameters-no_dialog = ' '.
      ELSE.
        gs_control_parameters-no_dialog = 'X'.
      ENDIF.

      IF gs_ztsd_024-nftot_icap IS NOT INITIAL.

        PERFORM f_busca_banco USING gs_ztsd_024-belnr_icap
                                  gs_ztsd_024-augbl_icap
                                  gs_ztsd_024-bukrs
                                  gs_ztsd_024-gjahr CHANGING gs_zssd_gnre_smartforms.

        gs_zssd_gnre_smartforms-data_venc     = gs_ztsd_024-data_guia_icap.
        gs_zssd_gnre_smartforms-cod_receita   = '100102'.
        gs_zssd_gnre_smartforms-num_controle  = gs_ztsd_024-guia_icap.
        gs_zssd_gnre_smartforms-valor         = gs_ztsd_024-nftot_icap.
        gs_zssd_gnre_smartforms-cod_barras    = gs_ztsd_024-brcde_icap.
        gs_zssd_gnre_smartforms-cod_barras_dv = gs_ztsd_024-ldig_icap.

        PERFORM f_chama_smartforms.
      ENDIF.

      IF gs_ztsd_024-nftot_fcop IS NOT INITIAL.
        CLEAR: gs_zssd_gnre_smartforms.
        PERFORM f_busca_banco USING gs_ztsd_024-belnr_fcop
                                  gs_ztsd_024-augbl_fcop
                                  gs_ztsd_024-bukrs
                                  gs_ztsd_024-gjahr CHANGING gs_zssd_gnre_smartforms.

        gs_zssd_gnre_smartforms-data_venc     = gs_ztsd_024-data_guia_fcop.
        gs_zssd_gnre_smartforms-cod_receita   = '100129'.
        gs_zssd_gnre_smartforms-num_controle  = gs_ztsd_024-guia_fcop.
        gs_zssd_gnre_smartforms-valor         = gs_ztsd_024-nftot_fcop.
        gs_zssd_gnre_smartforms-cod_barras    = gs_ztsd_024-brcde_fcop.
        gs_zssd_gnre_smartforms-cod_barras_dv = gs_ztsd_024-ldig_fcop.

        PERFORM f_chama_smartforms.
      ENDIF.

    ENDIF.
  ENDIF.
ENDFORM.                    " MONTA_TABELAS_INTERNA

*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_BANCO
*&---------------------------------------------------------------------*
FORM f_busca_banco  USING    uv_belnr
                           uv_augbl
                           uv_bukrs
                           uv_gjahr
                  CHANGING cs_gs_zssd_gnre_smartforms TYPE zssd_gnre_smartforms.

  DATA: lv_bankl  TYPE t012-bankl,
        lv_bankn  TYPE t012k-bankn,
        lv_bkont  TYPE t012k-bkont,
        lv_strlen TYPE i.

  SELECT hbkid, dmbtr, augdt FROM bseg
    INTO TABLE @DATA(lt_bseg)
    WHERE bukrs EQ @uv_bukrs AND
          belnr EQ @uv_belnr AND
          gjahr EQ @uv_gjahr AND
          koart EQ 'K'
      ORDER BY bukrs,
               belnr,
               gjahr,
               buzei.

  IF sy-subrc EQ 0.

    LOOP AT lt_bseg ASSIGNING FIELD-SYMBOL(<fs_bseg>). ENDLOOP.

    CLEAR: lv_bankl, lv_bankl, lv_bkont.

    SELECT SINGLE bankl FROM t012
      INTO lv_bankl
        WHERE bukrs EQ uv_bukrs AND
              hbkid EQ <fs_bseg>-hbkid.

    lv_strlen = strlen( lv_bankl ).
    lv_strlen = lv_strlen - 4.
    lv_bankl = lv_bankl+lv_strlen.

    SELECT bankn, bkont FROM t012k
      INTO TABLE @DATA(lt_t012k)
        WHERE bukrs EQ @uv_bukrs AND
              hbkid EQ @<fs_bseg>-hbkid
        ORDER BY bukrs, hbkid, hktid.

    IF sy-subrc EQ 0.
      LOOP AT lt_t012k ASSIGNING FIELD-SYMBOL(<fs_t012k>).
        lv_bankn = <fs_t012k>-bankn.
        lv_bkont = <fs_t012k>-bkont.
      ENDLOOP.
    ENDIF.

    SELECT SINGLE cod_aut FROM ztfi_036
      INTO gs_zssd_gnre_smartforms-cod_aut
        WHERE gjahr EQ uv_gjahr AND
              augbl EQ uv_augbl AND
              bukrs EQ uv_bukrs.

    CONCATENATE lv_bankl '-' lv_bkont(1) INTO cs_gs_zssd_gnre_smartforms-agencia.
    CONCATENATE lv_bankn '-' lv_bkont+1(1) INTO cs_gs_zssd_gnre_smartforms-conta.

    cs_gs_zssd_gnre_smartforms-valor_pgto    = <fs_bseg>-dmbtr.
    cs_gs_zssd_gnre_smartforms-data_pgto     = <fs_bseg>-augdt.

  ENDIF.

ENDFORM.                    " BUSCA_BANCO

*&---------------------------------------------------------------------*
*&      Form  F_CHAMA_SMARTFORMS
*&---------------------------------------------------------------------*
FORM f_chama_smartforms.

  IF p_pdf IS NOT INITIAL.
    gs_control_parameters-getotf = abap_true.
    gs_control_parameters-no_dialog = abap_true.
  ENDIF.

  CALL FUNCTION gv_smartforms
    EXPORTING
      gs_control_parameters = gs_control_parameters
      j_1bnfdoc             = j_1bnfdoc
      j_1binnad             = j_1binnad
      ztsd_024              = gs_ztsd_024
      v_codbar44            = gs_ztsd_024-brcde_icap
      v_codbar48            = gs_ztsd_024-brcde_fcop
      zssd_gnre_smartforms  = gs_zssd_gnre_smartforms
    IMPORTING
      job_output_info       = gs_job_output_info
    EXCEPTIONS
      formatting_error      = 1
      internal_error        = 2
      send_error            = 3
      user_canceled         = 4
      OTHERS                = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF gs_job_output_info IS NOT INITIAL AND p_pdf IS NOT INITIAL.
    PERFORM f_imprimir_pdf.
  ENDIF.

ENDFORM.                    " CHAMA_SMARTFORMS
*&---------------------------------------------------------------------*
*&      Form  F_IMPRIMIR_PDF
*&---------------------------------------------------------------------*
FORM f_imprimir_pdf .
  DATA: lt_tab_archive TYPE STANDARD TABLE OF  docs,
        lt_tlines      TYPE STANDARD TABLE OF  tline.

  DATA: lv_bin_filesize TYPE i.

  CALL FUNCTION 'CONVERT_OTF_2_PDF'
    IMPORTING
      bin_filesize           = lv_bin_filesize
    TABLES
      otf                    = gs_job_output_info-otfdata[]
      doctab_archive         = lt_tab_archive[]
      lines                  = lt_tlines[]
    EXCEPTIONS
      err_conv_not_possible  = 1
      err_otf_mc_noendmarker = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DATA(lv_filename) = |{ p_file }{ p_vbeln }.pdf|.
* Create PDF file
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      bin_filesize            = lv_bin_filesize
      filename                = lv_filename
      filetype                = 'BIN'
    TABLES
      data_tab                = lt_tlines[]
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
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
ENDFORM.                    " IMPRIMIR_PDF
