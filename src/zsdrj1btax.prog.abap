*&---------------------------------------------------------------------*
*& Report ZSDRJ1BTAX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdrj1btax.

*--------------------------------------------------------------------*
*** Includes
*--------------------------------------------------------------------*
INCLUDE ole2incl.


*--------------------------------------------------------------------*
*** Type Pools
*--------------------------------------------------------------------*
TYPE-POOLS: kkblo.


*--------------------------------------------------------------------*
*** Tabelas
*--------------------------------------------------------------------*
TABLES: sscrfields, zsdt0002.

TABLES: j_1btxip1,
        j_1btxip2,
        j_1btxip3,
        j_1btxic1,
        j_1btxic2,
        j_1btxic3,
        j_1btxci1,
        j_1btxst1,
        j_1btxst2,
        j_1btxst3,
        j_1btxiss,
        j_1btxpis,
        j_1btxcof,
        j_1btxwith.


*--------------------------------------------------------------------*
*** Tabelas Internas
*--------------------------------------------------------------------*
DATA: wt_fcat TYPE lvc_t_fcat.
DATA: wt_z005 TYPE TABLE OF zsdt0002.
DATA: wt_bdc TYPE TABLE OF bdcdata,
      wt_msg TYPE TABLE OF bdcmsgcoll.

DATA: BEGIN OF wt_campos OCCURS 0,
        fieldname TYPE fieldname,
        position  TYPE tabfdpos,
        fieldtext TYPE as4text,
        inttype   TYPE inttype,
        key       TYPE keyflag,
        convexit  TYPE convexit,
        lowercase TYPE lowercase,
      END OF wt_campos.

DATA: lo_struct   TYPE REF TO cl_abap_structdescr,
      lo_element  TYPE REF TO cl_abap_elemdescr,
      lo_new_type TYPE REF TO cl_abap_structdescr,
      lo_new_tab  TYPE REF TO cl_abap_tabledescr,
      lo_data     TYPE REF TO data,
      lo_data2    TYPE REF TO data,
      lt_comp     TYPE cl_abap_structdescr=>component_table,
      la_comp     LIKE LINE OF lt_comp.


TYPES: BEGIN OF ty_fields,
         field TYPE char30,
       END   OF ty_fields.

DATA: lt_fields TYPE STANDARD TABLE OF ty_fields,
      la_fields TYPE ty_fields.

FIELD-SYMBOLS: <f_tab>   TYPE ANY TABLE,
               <f_line>  TYPE any,
               <f_field> TYPE any.

FIELD-SYMBOLS: <fs_tab_aux> TYPE ANY TABLE.


*--------------------------------------------------------------------*
*** Estruturas
*--------------------------------------------------------------------*
DATA: wf_layout TYPE lvc_s_layo.
DATA: wf_z005 TYPE zsdt0002.
DATA: wf_campos LIKE wt_campos.
DATA: wf_grp TYPE j_1btxgruop.
DATA: wf_bdc TYPE bdcdata,
      wf_msg TYPE bdcmsgcoll,
      wf_opt TYPE ctu_params.


*--------------------------------------------------------------------*
*** Field symbols
*--------------------------------------------------------------------*
FIELD-SYMBOLS: <campo>, <tabela>, <z005>.


*--------------------------------------------------------------------*
*** Variáveis Globais
*--------------------------------------------------------------------*
DATA: wv_repid LIKE sy-repid.
DATA: wv_tabix LIKE sy-tabix.
DATA: wv_linha TYPE i.
DATA: wv_comp TYPE i.
DATA: wv_grp TYPE c.
DATA: wv_tab TYPE tabname.
DATA: wv_campo TYPE domvalue_l.
DATA: wv_val TYPE xfeld.
DATA: wv_funcname TYPE rs38l_fnam.
DATA: wv_where TYPE string.
* Dados para Excel.
DATA: hexcel TYPE ole2_object. " Excel object
DATA: hworkbooks TYPE ole2_object. " list of workbooks
DATA: hworkbook TYPE ole2_object. " workbook
DATA: hsheet TYPE ole2_object. " worksheet object
DATA: hcell TYPE ole2_object. " cell
DATA: column TYPE ole2_object.



*--------------------------------------------------------------------*
*--------------------------------------------------------------------*
*** TELA DE SELEÇÃO
*--------------------------------------------------------------------*
*--------------------------------------------------------------------*

SELECTION-SCREEN FUNCTION KEY 1.
SELECTION-SCREEN FUNCTION KEY 2.
SELECTION-SCREEN FUNCTION KEY 3.
SELECTION-SCREEN FUNCTION KEY 4.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-001.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ip1 RADIOBUTTON GROUP g1 USER-COMMAND g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ip1 FOR FIELD p_ip1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ip2 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ip2 FOR FIELD p_ip2.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ip3 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ip3 FOR FIELD p_ip3.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ic1 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ic1 FOR FIELD p_ic1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ic2 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(62) TEXT-ic2 FOR FIELD p_ic2.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ic3 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ic3 FOR FIELD p_ic3.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_ci1 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-ci1 FOR FIELD p_ci1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_st2 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-st2 FOR FIELD p_st2.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_st1 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(79) TEXT-st1 FOR FIELD p_st1.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_st3 RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-st3 FOR FIELD p_st3.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_iss RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-iss FOR FIELD p_iss.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_pis RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-pis FOR FIELD p_pis.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_cof RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(60) TEXT-cof FOR FIELD p_cof.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN BEGIN OF LINE.
    PARAMETERS p_wit RADIOBUTTON GROUP g1.
    SELECTION-SCREEN COMMENT 5(79) TEXT-wit FOR FIELD p_wit.
  SELECTION-SCREEN END OF LINE.

  SELECTION-SCREEN SKIP.
  PARAMETERS p_grp TYPE j_1btxgrp.
SELECTION-SCREEN END OF BLOCK bl2.

"Tipo Processamento
SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_inc RADIOBUTTON GROUP g3.
  PARAMETERS p_alt RADIOBUTTON GROUP g3.
SELECTION-SCREEN END OF BLOCK bl3.

"Tipo Execução
SELECTION-SCREEN BEGIN OF BLOCK bl4 WITH FRAME TITLE TEXT-003.
  PARAMETERS p_teste RADIOBUTTON GROUP g4 USER-COMMAND g4.
  PARAMETERS p_exec RADIOBUTTON GROUP g4.
  PARAMETERS p_req TYPE e070-trkorr. "Ordem Customizing
SELECTION-SCREEN END OF BLOCK bl4.

"Arquivo para carga
SELECTION-SCREEN BEGIN OF BLOCK bl5 WITH FRAME TITLE TEXT-005.
  PARAMETERS: p_file LIKE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK bl5.



*--------------------------------------------------------------------*
*** INITIALIZATION
*--------------------------------------------------------------------*
INITIALIZATION.

  PERFORM initialization.


*--------------------------------------------------------------------*
*** AT SELECTION-SCREEN OUTPUT
*--------------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.

  PERFORM selecion_screen_output.



*--------------------------------------------------------------------*
*** AT SELECTION-SCREEN ON VALUE-REQUEST
*--------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  PERFORM busca_arquivo.


*--------------------------------------------------------------------*
*** AT SELECTION-SCREEN
*--------------------------------------------------------------------*
AT SELECTION-SCREEN.

  PERFORM at_selection_screen.



*--------------------------------------------------------------------*
*** START-OF-SELECTION
*--------------------------------------------------------------------*
START-OF-SELECTION.

* Geração dos Campos
  IF wt_campos[] IS INITIAL.
    PERFORM gera_campos.
  ENDIF.

* Importa o Arquivo
  PERFORM importa_arquivo.

* Execução do B.Input de Inclusão ou Alteração
  IF p_inc = 'X'.
    PERFORM batch_input_inc.
  ELSE.
    PERFORM batch_input_alt.
  ENDIF.

* Grava LOG Dicionário de Dados
  PERFORM gravar_log.

*--------------------------------------------------------------------*
*** END-OF-SELECTION
*--------------------------------------------------------------------*
END-OF-SELECTION.

* Tratamento dos dados e exibição do LOG
  PERFORM exibir_log.






*&---------------------------------------------------------------------*
*&      Form  EXCEL
*&---------------------------------------------------------------------*
FORM excel .

  DATA: vl_campo TYPE char50.
  DATA: vl_fname TYPE rs38l_fnam.
  DATA: vl_tabix TYPE i.
* Abrindo o excel
  CREATE OBJECT hexcel 'EXCEL.APPLICATION'.
  CALL METHOD OF
    hexcel
      'Workbooks' = hworkbooks.
  CALL METHOD OF
    hworkbooks
      'Add' = hworkbook.
  GET PROPERTY OF hworkbook 'ActiveSheet' = hsheet.

  LOOP AT wt_campos INTO wf_campos.
    wv_tabix = sy-tabix.

    CALL METHOD OF
        hsheet
        'Columns' = column
      EXPORTING
        #1        = wv_tabix.

    IF wf_campos-convexit IS NOT INITIAL.
      SET PROPERTY OF column 'NumberFormat' = '@'.
    ENDIF.

    IF wf_campos-inttype = 'D'.
      SET PROPERTY OF column 'NumberFormat' = 'dd/mm/yyyy;@'.
    ENDIF.

    IF wf_campos-inttype = 'P'.
      SET PROPERTY OF column 'NumberFormat' = '0.00'.
    ENDIF.

    FREE OBJECT column.

    PERFORM formatar_celulas USING:
      1 wv_tabix wf_campos-fieldtext,
      2 wv_tabix wf_campos-fieldname.
    vl_tabix = 2.
    LOOP AT <f_tab> ASSIGNING <f_line>.
      ADD 1 TO vl_tabix.
      ASSIGN COMPONENT wf_campos-fieldname OF STRUCTURE <f_line> TO <f_field>.
      IF <f_field> IS ASSIGNED.
        IF wf_campos-convexit IS NOT INITIAL.
          CONCATENATE 'CONVERSION_EXIT_' wf_campos-convexit '_OUTPUT' INTO vl_fname.
          TRY .
              CALL FUNCTION vl_fname
                EXPORTING
                  input  = <f_field>
                IMPORTING
                  output = vl_campo.
            CATCH cx_root.
              vl_campo = <f_field>.
          ENDTRY.

        ELSE.

          vl_campo = <f_field>.
        ENDIF.
        PERFORM formatar_celulas USING:
                                        vl_tabix wv_tabix vl_campo.
      ENDIF.

    ENDLOOP.
  ENDLOOP.

  SET PROPERTY OF hexcel 'Visible' = 1.

***********************************************
* Set Columns to auto fit to width of text    *
***********************************************
  CALL METHOD OF
    hsheet
      'Columns' = column.
  CALL METHOD OF
    column
    'Autofit'.
  FREE OBJECT column.

ENDFORM. " EXCEL

*&---------------------------------------------------------------------*
*&      Form  formatar_celulas
*&---------------------------------------------------------------------*
FORM formatar_celulas
  USING p_i   TYPE i
        p_j   TYPE i
        p_val TYPE c.


  CALL METHOD OF
      hexcel
      'Cells' = hcell
    EXPORTING
      #1      = p_i
      #2      = p_j.

  SET PROPERTY OF hcell 'Value' = p_val.

ENDFORM. "FORMATAR_CELULAS

*&---------------------------------------------------------------------*
*&      Form  IMPORTA_ARQUIVO
*&---------------------------------------------------------------------*
FORM importa_arquivo .

  DATA: lt_excel TYPE TABLE OF alsmex_tabline.
  DATA: lf_excel TYPE alsmex_tabline.


  IF p_file IS INITIAL.
    "Informar o arquivo
    MESSAGE TEXT-006 TYPE 'E'.
  ENDIF.

  CHECK p_file IS NOT INITIAL.

  REFRESH: lt_excel. "wt_z005.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = 1
      i_begin_row             = 2
      i_end_col               = 30
      i_end_row               = 999999
    TABLES
      intern                  = lt_excel
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

  IF sy-subrc = 0.

    CLEAR wv_linha.

    LOOP AT lt_excel INTO lf_excel.

      AT NEW row.
        CLEAR wf_z005.
      ENDAT.

*      IF lf_excel-row = '1'.
*        CLEAR wf_campos.
*        READ TABLE wt_campos INTO wf_campos INDEX lf_excel-col.
*        IF wf_campos-fieldname <> lf_excel-value.
*          "Formato do arquivo diferente da tabela/grupo selecionada
*          MESSAGE TEXT-007 TYPE 'E'.
*        ENDIF.
*      ENDIF.

      ADD 7 TO lf_excel-col.
      ASSIGN COMPONENT lf_excel-col OF STRUCTURE wf_z005 TO <campo>.
      IF sy-subrc = 0.
        <campo> = lf_excel-value.
      ENDIF.

      AT END OF row.
        wf_z005-linha = wv_linha.
        APPEND wf_z005 TO wt_z005.
        ADD 1 TO wv_linha.
      ENDAT.

    ENDLOOP.

  ELSE.
    "Erro ao abrir arquivo
    MESSAGE TEXT-008 TYPE 'E'.
  ENDIF.

ENDFORM. " IMPORTA_ARQUIVO

*&---------------------------------------------------------------------*
*&      Form  GERA_CAMPOS
*&---------------------------------------------------------------------*
FORM gera_campos.

  DATA: lt_nametab TYPE TABLE OF dntab.

  DATA: lf_name TYPE dntab.

  DATA: vl_tabix TYPE sy-tabix.


  IF p_ip3 = 'X' OR
     p_ic3 = 'X' OR
     p_st3 = 'X' OR
     p_iss = 'X' OR
     p_pis = 'X' OR
     p_cof = 'X' OR
     p_wit = 'X'.
    wv_grp = 'X'.
  ELSE.
    CLEAR wv_grp.
  ENDIF.


  IF wv_grp = 'X'.
    CLEAR wf_grp.
    SELECT SINGLE *
      FROM j_1btxgruop
      INTO wf_grp
      WHERE gruop = p_grp.
  ENDIF.

  CLEAR: wv_tab, wv_val.

  CASE 'X'.

    WHEN p_ip1. wv_tab = 'J_1BTXIP1'.
    WHEN p_ip2. wv_tab = 'J_1BTXIP2'.
    WHEN p_ip3. wv_tab = 'J_1BTXIP3'.
    WHEN p_ic1. wv_tab = 'J_1BTXIC1'.
    WHEN p_ic2. wv_tab = 'J_1BTXIC2'.
    WHEN p_ic3. wv_tab = 'J_1BTXIC3'.
    WHEN p_ci1. wv_tab = 'J_1BTXCI1'.
    WHEN p_st2. wv_tab = 'J_1BTXST2'.
    WHEN p_st1. wv_tab = 'J_1BTXST1'.
    WHEN p_st3. wv_tab = 'J_1BTXST3'.
    WHEN p_iss. wv_tab = 'J_1BTXISS'.
    WHEN p_pis. wv_tab = 'J_1BTXPIS'.
    WHEN p_cof. wv_tab = 'J_1BTXCOF'.
    WHEN p_wit. wv_tab = 'J_1BTXWITH'.

    WHEN OTHERS.

  ENDCASE.

  CHECK wv_tab IS NOT INITIAL.

  REFRESH: lt_nametab, wt_campos.

  CALL FUNCTION 'NAMETAB_GET'
    EXPORTING
      langu               = sy-langu
      only                = ' '
      tabname             = wv_tab
    TABLES
      nametab             = lt_nametab
    EXCEPTIONS
      internal_error      = 1
      table_has_no_fields = 2
      table_not_activ     = 3
      no_texts_found      = 4
      OTHERS              = 5.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  DELETE lt_nametab WHERE fieldname = 'MANDT'.
  DELETE lt_nametab WHERE fieldname = 'CLIENT'.

  CHECK lt_nametab[] IS NOT INITIAL.

  LOOP AT lt_nametab INTO lf_name.
    CLEAR wf_campos.
    wf_campos-fieldname = lf_name-fieldname.
    wf_campos-fieldtext = lf_name-fieldtext.
    wf_campos-position  = lf_name-position.
    wf_campos-inttype   = lf_name-inttype.
    wf_campos-key       = lf_name-keyflag.
    wf_campos-convexit  = lf_name-convexit.
    wf_campos-lowercase = lf_name-lowercase.

    IF wf_campos-fieldname = 'NBMCODE'.
      wf_campos-convexit  = 'X'.
    ENDIF.

    IF wf_campos-fieldname = 'VALIDTO'.
      wv_val = 'X'.
    ENDIF.

    IF wv_grp = 'X'.
      CLEAR wv_campo.

      IF wf_campos-fieldname = 'VALUE'.
        IF wf_grp-field IS INITIAL.
          wf_campos-fieldtext = TEXT-009. "Não Preencher
        ELSE.
          wv_campo = wf_grp-field.
        ENDIF.
      ENDIF.

      IF wf_campos-fieldname = 'VALUE2'.
        IF wf_grp-field2 IS INITIAL.
          wf_campos-fieldtext = TEXT-009. "Não Preencher
        ELSE.
          wv_campo = wf_grp-field2.
        ENDIF.
      ENDIF.

      IF wf_campos-fieldname = 'VALUE3'.
        IF wf_grp-field3 IS INITIAL.
          wf_campos-fieldtext = TEXT-009. "Não Preencher
        ELSE.
          wv_campo = wf_grp-field3.
        ENDIF.
      ENDIF.

      IF wv_campo IS NOT INITIAL.

        SELECT ddtext UP TO 1 ROWS
          FROM dd07t
          INTO wf_campos-fieldtext
         WHERE domname    EQ 'J_1BTXFIELDS'
           AND ddlanguage EQ 'P'
           AND as4local   EQ 'A'
           AND domvalue_l EQ wv_campo.                  "#EC CI_NOORDER
        ENDSELECT.

      ENDIF.

    ENDIF.

    APPEND wf_campos TO wt_campos.
  ENDLOOP.

  IF p_alt EQ 'X'.
    IF wv_val IS INITIAL.
      "Não é posível modificar esta tabela
      MESSAGE TEXT-010 TYPE 'E'.
    ELSE.
      "Só é posível modificar a data de validade
      MESSAGE TEXT-011 TYPE 'S'.
      DELETE wt_campos WHERE key IS INITIAL AND fieldname <> 'VALIDTO'.
    ENDIF.
  ENDIF.

  "1Monta tabela dinamica
  lo_struct ?= cl_abap_typedescr=>describe_by_name( wv_tab ).
  lt_comp  = lo_struct->get_components( ).

* Cria tipo
  lo_new_type = cl_abap_structdescr=>create( lt_comp ).
*
* Cria tipo tabela
  lo_new_tab = cl_abap_tabledescr=>create(
                  p_line_type  = lo_new_type
                  p_table_kind = cl_abap_tabledescr=>tablekind_std
                  p_unique     = abap_false ).
*
* cria obj dinamico do novo tipo
  CREATE DATA lo_data TYPE HANDLE lo_new_tab.
*
* Cria tabela via field symbol
  ASSIGN lo_data->* TO <f_tab>.

* cria obj dinamico do novo tipo
  CREATE DATA lo_data2 TYPE HANDLE lo_new_tab.
*
* Cria tabela via field symbol
  ASSIGN lo_data2->* TO <fs_tab_aux>.
*
* Monta campos para seleção
  REFRESH lt_fields.
  LOOP AT lt_comp INTO la_comp.
    la_fields-field = la_comp-name.
    APPEND la_fields TO lt_fields.
    CLEAR: la_comp, la_fields.
  ENDLOOP.

*  SELECT (lt_fields)
*       INTO  TABLE <f_tab>
*       FROM  (wv_tab).
*  IF wv_grp IS NOT INITIAL.
*    LOOP AT <f_tab> ASSIGNING <f_line>.
*      vl_tabix = sy-tabix.
*      ASSIGN COMPONENT 'GRUOP' OF STRUCTURE <f_line> TO <f_field>.
*      IF <f_field> = p_grp.
*        INSERT <f_line> INTO TABLE <fs_tab_aux>.
*      ENDIF.
*    ENDLOOP.
*    <f_tab> = <fs_tab_aux>.
*  ENDIF.

ENDFORM. " GERA_CAMPOS

*&---------------------------------------------------------------------*
*&      Form  EXIBIR_LOG
*&---------------------------------------------------------------------*
FORM exibir_log .

  wv_repid = sy-repid.

  CLEAR wf_layout.
  wf_layout-zebra      = 'X'.
  wf_layout-cwidth_opt = 'X'.

* fieldcat
  REFRESH wt_fcat.

* Converte a tabela interna em fieldcat
  PERFORM fieldcat TABLES wt_fcat USING 'ZSDT0002'.

* Exibe o ALV
  PERFORM exibe_alv.

ENDFORM. " EXIBIR_LOG

*&---------------------------------------------------------------------*
*&      Form  FIELDCAT
*&---------------------------------------------------------------------*
FORM fieldcat TABLES pt_fcat STRUCTURE lvc_s_fcat
                USING  pv_tab  TYPE c.

  DATA: lt_fcat TYPE  kkblo_t_fieldcat.

  REFRESH: pt_fcat, lt_fcat.

* busca tabela fieldcat para tabela interna
  CALL FUNCTION 'K_KKB_FIELDCAT_MERGE'
    EXPORTING
      i_callback_program     = wv_repid
      i_bypassing_buffer     = abap_true
      i_inclname             = wv_repid
      i_strucname            = pv_tab
    CHANGING
      ct_fieldcat            = lt_fcat[]
    EXCEPTIONS
      inconsistent_interface = 1
      OTHERS                 = 2.

  CASE sy-subrc.
    WHEN 0.
* converte tabela fieldcat
      CALL FUNCTION 'LVC_TRANSFER_FROM_KKBLO'
        EXPORTING
          it_fieldcat_kkblo = lt_fcat[]
        IMPORTING
          et_fieldcat_lvc   = pt_fcat[].
  ENDCASE.

  DELETE pt_fcat WHERE fieldname = 'MANDT'.

  LOOP AT pt_fcat FROM 7 TO 32.
    wv_tabix = sy-tabix - 6.

    READ TABLE wt_campos INTO wf_campos INDEX wv_tabix.

    IF sy-subrc = 0.
      IF wf_campos-fieldname CS 'VALUE'.
        CLEAR pt_fcat-fieldname.
      ELSE.
        pt_fcat-reptext = wf_campos-fieldtext.
      ENDIF.
    ELSE.
      CLEAR pt_fcat-fieldname.
    ENDIF.

    wv_tabix = wv_tabix + 6.
    MODIFY pt_fcat INDEX wv_tabix.

  ENDLOOP.
  DELETE pt_fcat WHERE fieldname IS INITIAL.

ENDFORM. " FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  BATCH_INPUT_INC - Inclusão
*&---------------------------------------------------------------------*
FORM batch_input_inc.

  CLEAR wf_opt.
  wf_opt-dismode  = 'N'.
  wf_opt-updmode  = 'S'.
  wf_opt-racommit = 'X'.
  wf_opt-nobinpt  = 'X'.
  wf_opt-nobiend  = 'X'.

  LOOP AT wt_z005 INTO wf_z005 FROM 2.
    wv_tabix = sy-tabix.

    REFRESH: wt_bdc, wt_msg.

    CASE 'X'.

      WHEN p_ip1. PERFORM ip1.
      WHEN p_ip2. PERFORM ip2.
      WHEN p_ip3. PERFORM ip3.
      WHEN p_ic1. PERFORM ic1.
      WHEN p_ic2. PERFORM ic2.
      WHEN p_ic3. PERFORM ic3.
      WHEN p_ci1. PERFORM ci1.
      WHEN p_st2. PERFORM st2.
      WHEN p_st1. PERFORM st1.
      WHEN p_st3. PERFORM st3.
      WHEN p_iss. PERFORM iss.
      WHEN p_pis. PERFORM pis.
      WHEN p_cof. PERFORM cof.
      WHEN p_wit. PERFORM wit.

      WHEN OTHERS.

    ENDCASE.

* Inclui a Request no Batch Input
    PERFORM bdc_inclui_request.

* Chama transação
    CALL TRANSACTION 'J1BTAX'
               USING wt_bdc
        OPTIONS FROM wf_opt
       MESSAGES INTO wt_msg.

* Trata Mensagens de Retorno
    PERFORM trata_mensagem_retorno_inc.

  ENDLOOP.

ENDFORM. " BATCH_INPUT_INC

*&---------------------------------------------------------------------*
*&      Form  BDC
*&---------------------------------------------------------------------*
FORM bdc USING p_1 TYPE c p_2 TYPE c p_3 TYPE c.
  CLEAR wf_bdc.
  IF p_1 = 'X'.
    wf_bdc-dynbegin = p_1.
    wf_bdc-program  = p_2.
    wf_bdc-dynpro   = p_3.
  ELSE.
    wf_bdc-fnam = p_2.
    wf_bdc-fval = p_3.
  ENDIF.
  APPEND wf_bdc TO wt_bdc.
ENDFORM. " BDC

*&---------------------------------------------------------------------*
*&      Form  IP1
*&---------------------------------------------------------------------*
FORM ip1 .

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(02)',
        ' ' 'WA_TAX_TABLES-MARKED(02)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0007',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0007',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXIP1-NBMCODE(01)'   wf_z005-a,
        ' ' 'J_1BTXIP1-VALIDFROM(01)' wf_z005-b,
        ' ' 'J_1BTXIP1-RATE(01)'      wf_z005-c,
        ' ' 'J_1BTXIP1-BASE(01)'      wf_z005-d,
        ' ' 'J_1BTXIP1-EXEMPT(01)'    wf_z005-e,
        ' ' 'J_1BTXIP1-TAXLAW(01)'    wf_z005-f,
        ' ' 'J_1BTXIP1-AMOUNT(01)'    wf_z005-g,
        ' ' 'J_1BTXIP1-FACTOR(01)'    wf_z005-h,
        ' ' 'J_1BTXIP1-UNIT(01)'      wf_z005-i,
        ' ' 'J_1BTXIP1-WAERS(01)'     wf_z005-j.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0007',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IP1

*&---------------------------------------------------------------------*
*&      Form  IP2
*&---------------------------------------------------------------------*
FORM ip2.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(03)',
        ' ' 'WA_TAX_TABLES-MARKED(03)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0014',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0014',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXIP2-MATNR(01)'     wf_z005-a,
        ' ' 'J_1BTXIP2-VALIDFROM(01)' wf_z005-b,
        ' ' 'J_1BTXIP2-RATE(01)'      wf_z005-c,
        ' ' 'J_1BTXIP2-BASE(01)'      wf_z005-d,
        ' ' 'J_1BTXIP2-EXEMPT(01)'    wf_z005-e,
        ' ' 'J_1BTXIP2-TAXLAW(01)'    wf_z005-f,
        ' ' 'J_1BTXIP2-AMOUNT(01)'    wf_z005-g,
        ' ' 'J_1BTXIP2-FACTOR(01)'    wf_z005-h,
        ' ' 'J_1BTXIP2-UNIT(01)'      wf_z005-i,
        ' ' 'J_1BTXIP2-WAERS(01)'     wf_z005-j.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0014',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IP2

*&---------------------------------------------------------------------*
*&      Form  IP3
*&---------------------------------------------------------------------*
FORM ip3.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(04)',
        ' ' 'WA_TAX_TABLES-MARKED(04)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                       '0100',
        ' ' 'BDC_OKCODE'                     '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'   '0019',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'                 '0019',
        ' ' 'BDC_OKCODE'               '/00',
        ' ' 'J_1BTXIP3V-VALIDFROM(01)' wf_z005-e,
        ' ' 'J_1BTXIP3V-RATE(01)'      wf_z005-f,
        ' ' 'J_1BTXIP3V-BASE(01)'      wf_z005-g,
        ' ' 'J_1BTXIP3V-EXEMPT(01)'    wf_z005-h,
        ' ' 'J_1BTXIP3V-TAXLAW(01)'    wf_z005-i,
        ' ' 'J_1BTXIP3V-AMOUNT(01)'    wf_z005-j,
        ' ' 'J_1BTXIP3V-FACTOR(01)'    wf_z005-k,
        ' ' 'J_1BTXIP3V-UNIT(01)'      wf_z005-l,
        ' ' 'J_1BTXIP3V-WAERS(01)'     wf_z005-m.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIP3V-VALUE(01)' wf_z005-b.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIP3V-VALUE2(01)' wf_z005-c.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIP3V-VALUE3(01)' wf_z005-d.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BW'   '0019',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IP3

*&---------------------------------------------------------------------*
*&      Form  IC1
*&---------------------------------------------------------------------*
FORM ic1 .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(05)',
        ' ' 'WA_TAX_TABLES-MARKED(05)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0002',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0002',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXIC1-LAND1(01)'     wf_z005-a,
        ' ' 'J_1BTXIC1-SHIPFROM(01)'  wf_z005-b,
        ' ' 'J_1BTXIC1-SHIPTO(01)'    wf_z005-c,
        ' ' 'J_1BTXIC1-VALIDFROM(01)' wf_z005-d,
        ' ' 'J_1BTXIC1-RATE(01)'      wf_z005-e,
        ' ' 'J_1BTXIC1-RATE_F(01)'    wf_z005-f.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0002',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IC1

*&---------------------------------------------------------------------*
*&      Form  IC2
*&---------------------------------------------------------------------*
FORM ic2.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(06)',
        ' ' 'WA_TAX_TABLES-MARKED(06)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0003',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0003',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXIC2-LAND1(01)'     wf_z005-a,
        ' ' 'J_1BTXIC2-SHIPFROM(01)'  wf_z005-b,
        ' ' 'J_1BTXIC2-SHIPTO(01)'    wf_z005-c,
        ' ' 'J_1BTXIC2-MATNR(01)'     wf_z005-d,
        ' ' 'J_1BTXIC2-VALIDFROM(01)' wf_z005-e,
        ' ' 'J_1BTXIC2-VALIDTO(01)'   wf_z005-f,
        ' ' 'J_1BTXIC2-RATE(01)'      wf_z005-g,
        ' ' 'J_1BTXIC2-BASE(01)'      wf_z005-h,
        ' ' 'J_1BTXIC2-EXEMPT(01)'    wf_z005-i,
        ' ' 'J_1BTXIC2-TAXLAW(01)'    wf_z005-j,
        ' ' 'J_1BTXIC2-CONVEN100(01)' wf_z005-k.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0003',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IC2
*&---------------------------------------------------------------------*
*&      Form  IC3
*&---------------------------------------------------------------------*
FORM ic3 .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(07)',
        ' ' 'WA_TAX_TABLES-MARKED(07)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-d.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'   '0018',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW' '0018',
        ' ' 'BDC_OKCODE' '/00',
        ' ' 'J_1BTXIC3V-SHIPFROM(01)'   wf_z005-b,
        ' ' 'J_1BTXIC3V-SHIPTO(01)'     wf_z005-c,
*        ' ' 'J_1BTXIC3V-VALUE(01)'      wf_z005-E,
*        ' ' 'J_1BTXIC3V-VALUE2(01)'     wf_z005-F,
*        ' ' 'J_1BTXIC3V-VALUE3(01)'     wf_z005-G,
        ' ' 'J_1BTXIC3V-VALIDFROM(01)'  wf_z005-h,
        ' ' 'J_1BTXIC3V-VALIDTO(01)'    wf_z005-i,
        ' ' 'J_1BTXIC3V-RATE(01)'       wf_z005-j,
        ' ' 'J_1BTXIC3V-BASE(01)'       wf_z005-k,
        ' ' 'J_1BTXIC3V-EXEMPT(01)'     wf_z005-l,
        ' ' 'J_1BTXIC3V-TAXLAW(01)'     wf_z005-m,
        ' ' 'J_1BTXIC3V-CONVEN100(01)'  wf_z005-n,
        ' ' 'J_1BTXIC3V-SPECF_RATE(01)' wf_z005-o,
        ' ' 'J_1BTXIC3V-SPECF_BASE(01)' wf_z005-p,
        ' ' 'J_1BTXIC3V-PARTILHA_EXEMPT(01)' wf_z005-q,
        ' ' 'J_1BTXIC3V-SPECF_RESALE(01)'    wf_z005-r.


  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIC3V-VALUE(01)' wf_z005-e.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIC3V-VALUE2(01)' wf_z005-f.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXIC3V-VALUE3(01)' wf_z005-g.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BW'   '0018',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " IC3

*&---------------------------------------------------------------------*
*&      Form  CI1
*&---------------------------------------------------------------------*
FORM ci1 .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(08)',
        ' ' 'WA_TAX_TABLES-MARKED(08)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0006',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0006',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXCI1-LAND1(01)'     wf_z005-a,
        ' ' 'J_1BTXCI1-SHIPTO(01)'    wf_z005-b,
        ' ' 'J_1BTXCI1-MATNR(01)'     wf_z005-c,
        ' ' 'J_1BTXCI1-VALIDFROM(01)' wf_z005-d,
        ' ' 'J_1BTXCI1-VALIDTO(01)'   wf_z005-e,
        ' ' 'J_1BTXCI1-BASE(01)'      wf_z005-f,
        ' ' 'J_1BTXCI1-EXEMPT(01)'    wf_z005-g.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0006',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " CI1

*&---------------------------------------------------------------------*
*&      Form  ST1
*&---------------------------------------------------------------------*
FORM st1.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(10)',
        ' ' 'WA_TAX_TABLES-MARKED(10)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0008',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'             '0009',
        ' ' 'BDC_OKCODE'           '/00',
        ' ' 'J_1BTXST1-LAND1'      wf_z005-a,
        ' ' 'J_1BTXST1-SHIPFROM'   wf_z005-b,
        ' ' 'J_1BTXST1-SHIPTO'     wf_z005-c,
        ' ' 'J_1BTXST1-MATNR'      wf_z005-d,
        ' ' 'J_1BTXST1-STGRP'      wf_z005-e,
        ' ' 'J_1BTXST1-VALIDFROM'  wf_z005-f,
        ' ' 'J_1BTXST1-VALIDTO'    wf_z005-g.

  CASE wf_z005-h. "SURTYPE

    WHEN '0'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' 'X',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

    WHEN '1'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' 'X',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BQ'            '0009',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST1-RATE'       wf_z005-i,
            ' ' 'J_1BTXST1-BASERED1'   wf_z005-m,
            ' ' 'J_1BTXST1-BASERED2'   wf_z005-n,
            ' ' 'J_1BTXST1-ICMSBASER'  wf_z005-o.

    WHEN '2'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' 'X',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BQ'            '0009',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST1-RATE'       wf_z005-i,
            ' ' 'J_1BTXST1-BASERED1'   wf_z005-m,
            ' ' 'J_1BTXST1-BASERED2'   wf_z005-n,
            ' ' 'J_1BTXST1-ICMSBASER'  wf_z005-o,
            ' ' 'J_1BTXST1-PRICE'      wf_z005-j,
            ' ' 'J_1BTXST1-WAERS'      wf_z005-q,
            ' ' 'J_1BTXST1-FACTOR'     wf_z005-k,
            ' ' 'J_1BTXST1-UNIT'       wf_z005-l.

    WHEN '3'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' 'X',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BQ'            '0009',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST1-RATE'       wf_z005-i,
            ' ' 'J_1BTXST1-BASERED1'   wf_z005-m,
            ' ' 'J_1BTXST1-BASERED2'   wf_z005-n,
            ' ' 'J_1BTXST1-ICMSBASER'  wf_z005-o,
            ' ' 'J_1BTXST1-MINPRICE'   wf_z005-p,
            ' ' 'J_1BTXST1-WAERS'      wf_z005-q,
            ' ' 'J_1BTXST1-FACTOR'     wf_z005-k,
            ' ' 'J_1BTXST1-UNIT'       wf_z005-l,
            ' ' 'J_1BTXST1-MINFACT'    wf_z005-r,
            ' ' 'J_1BTXST1-SURCHIN'    wf_z005-s.

    WHEN '4'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' 'X'.

      PERFORM bdc USING:
            'X' 'SAPLJ1BQ'            '0009',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST1-RATE'       wf_z005-i,
            ' ' 'J_1BTXST1-BASERED1'   wf_z005-m,
            ' ' 'J_1BTXST1-BASERED2'   wf_z005-n,
            ' ' 'J_1BTXST1-ICMSBASER'  wf_z005-o.

    WHEN OTHERS.

  ENDCASE.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0009',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST1

*&---------------------------------------------------------------------*
*&      Form  ST2
*&---------------------------------------------------------------------*
FORM st2.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(09)',
        ' ' 'WA_TAX_TABLES-MARKED(09)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1B0'   '0002',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1B0'             '0003',
        ' ' 'BDC_OKCODE'           '/00',
        ' ' 'J_1BTXST2-LAND1'      wf_z005-a,
        ' ' 'J_1BTXST2-SHIPFROM'   wf_z005-b,
        ' ' 'J_1BTXST2-SHIPTO'     wf_z005-c,
        ' ' 'J_1BTXST2-STGRP'      wf_z005-d,
        ' ' 'J_1BTXST2-VALIDFROM'  wf_z005-e,
        ' ' 'J_1BTXST2-VALIDTO'    wf_z005-f.

  CASE wf_z005-g. "SURTYPE

    WHEN '1'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP1' 'X',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1B0'            '0003',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST2-RATE'       wf_z005-h,
*        ' ' 'J_1BTXST2-PRICE'      wf_z005-i,
            ' ' 'J_1BTXST2-FACTOR'     wf_z005-j,
            ' ' 'J_1BTXST2-UNIT'       wf_z005-k,
            ' ' 'J_1BTXST2-BASERED1'   wf_z005-l,
            ' ' 'J_1BTXST2-BASERED2'   wf_z005-m,
            ' ' 'J_1BTXST2-ICMSBASER'  wf_z005-n,
            ' ' 'J_1BTXST2-MINPRICE'   wf_z005-o,
            ' ' 'J_1BTXST2-WAERS'      wf_z005-p.

    WHEN '2'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' 'X',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1B0'            '0003',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST2-RATE'       wf_z005-h,
            ' ' 'J_1BTXST2-PRICE'      wf_z005-i,
            ' ' 'J_1BTXST2-FACTOR'     wf_z005-j,
            ' ' 'J_1BTXST2-UNIT'       wf_z005-k,
            ' ' 'J_1BTXST2-BASERED1'   wf_z005-l,
            ' ' 'J_1BTXST2-BASERED2'   wf_z005-m,
            ' ' 'J_1BTXST2-ICMSBASER'  wf_z005-n,
            ' ' 'J_1BTXST2-MINPRICE'   wf_z005-o,
            ' ' 'J_1BTXST2-WAERS'      wf_z005-p.

    WHEN '4'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' 'X'.

      PERFORM bdc USING:
            'X' 'SAPLJ1B0'            '0003',
            ' ' 'BDC_OKCODE'          '/00',
            ' ' 'J_1BTXST2-RATE'       wf_z005-h,
*        ' ' 'J_1BTXST2-PRICE'      wf_z005-i,
            ' ' 'J_1BTXST2-FACTOR'     wf_z005-j,
            ' ' 'J_1BTXST2-UNIT'       wf_z005-k,
            ' ' 'J_1BTXST2-BASERED1'   wf_z005-l,
            ' ' 'J_1BTXST2-BASERED2'   wf_z005-m,
            ' ' 'J_1BTXST2-ICMSBASER'  wf_z005-n,
            ' ' 'J_1BTXST2-MINPRICE'   wf_z005-o,
            ' ' 'J_1BTXST2-WAERS'      wf_z005-p.

    WHEN OTHERS.

  ENDCASE.


  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1B0'   '0003',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST2

*&---------------------------------------------------------------------*
*&      Form  ST3
*&---------------------------------------------------------------------*
FORM st3.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(11)',
        ' ' 'WA_TAX_TABLES-MARKED(11)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                       '0100',
        ' ' 'BDC_OKCODE'                     '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-d.

*  Se existe somente um registro é necessário voltar na tela
* anterior para criar um novo registro.
  PERFORM valida_registro_unico USING 'J_1BTXST3'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'   '0021',
        ' ' 'BDC_OKCODE' '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'              '0022',
        ' ' 'BDC_OKCODE'            '/00',
*        ' ' 'J_1BTXST3V-LAND1'      wf_z005-a,
        ' ' 'J_1BTXST3V-SHIPFROM'   wf_z005-b,
        ' ' 'J_1BTXST3V-SHIPTO'     wf_z005-c,
        ' ' 'J_1BTXST3V-STGRP'      wf_z005-h,
        ' ' 'J_1BTXST3V-VALIDFROM'  wf_z005-i,
        ' ' 'J_1BTXST3V-VALIDTO'    wf_z005-j.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXST3V-VALUE' wf_z005-e.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXST3V-VALUE2' wf_z005-f.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXST3V-VALUE3' wf_z005-g.
  ENDIF.

  CASE wf_z005-k. "SURTYPE

    WHEN '0'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' 'X',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

    WHEN '1'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' 'X',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BW'              '0022',
            ' ' 'BDC_OKCODE'            '/00',
            ' ' 'J_1BTXST3V-RATE'       wf_z005-l,
            ' ' 'J_1BTXST3V-BASERED1'   wf_z005-p,
            ' ' 'J_1BTXST3V-BASERED2'   wf_z005-q,
            ' ' 'J_1BTXST3V-ICMSBASER'  wf_z005-r.

    WHEN '2'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' 'X',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BW'              '0022',
            ' ' 'BDC_OKCODE'            '/00',
            ' ' 'J_1BTXST3V-RATE'       wf_z005-l,
            ' ' 'J_1BTXST3V-PRICE'      wf_z005-m,
            ' ' 'J_1BTXST3V-FACTOR'     wf_z005-n,
            ' ' 'J_1BTXST3V-UNIT'       wf_z005-o,
            ' ' 'J_1BTXST3V-BASERED1'   wf_z005-p,
            ' ' 'J_1BTXST3V-BASERED2'   wf_z005-q,
            ' ' 'J_1BTXST3V-ICMSBASER'  wf_z005-r,
*            ' ' 'J_1BTXST3V-MINPRICE'   wf_z005-S,
            ' ' 'J_1BTXST3V-WAERS'      wf_z005-t.
*            ' ' 'J_1BTXST3V-MINFACT'    wf_z005-U,
*            ' ' 'J_1BTXST3V-SURCHIN'    wf_z005-V.

    WHEN '3'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' 'X',
            ' ' 'J_1BRADIO-CALC_TYP4' ' '.

      PERFORM bdc USING:
            'X' 'SAPLJ1BW'              '0022',
            ' ' 'BDC_OKCODE'            '/00',
            ' ' 'J_1BTXST3V-RATE'       wf_z005-l,
*            ' ' 'J_1BTXST3V-PRICE'      wf_z005-M,
            ' ' 'J_1BTXST3V-FACTOR'     wf_z005-n,
            ' ' 'J_1BTXST3V-UNIT'       wf_z005-o,
            ' ' 'J_1BTXST3V-BASERED1'   wf_z005-p,
            ' ' 'J_1BTXST3V-BASERED2'   wf_z005-q,
            ' ' 'J_1BTXST3V-ICMSBASER'  wf_z005-r,
            ' ' 'J_1BTXST3V-MINPRICE'   wf_z005-s,
            ' ' 'J_1BTXST3V-WAERS'      wf_z005-t,
            ' ' 'J_1BTXST3V-MINFACT'    wf_z005-u,
            ' ' 'J_1BTXST3V-SURCHIN'    wf_z005-v.

    WHEN '4'.
      PERFORM bdc USING:
            ' ' 'J_1BRADIO-CALC_TYP0' ' ',
            ' ' 'J_1BRADIO-CALC_TYP1' ' ',
            ' ' 'J_1BRADIO-CALC_TYP2' ' ',
            ' ' 'J_1BRADIO-CALC_TYP3' ' ',
            ' ' 'J_1BRADIO-CALC_TYP4' 'X'.

      PERFORM bdc USING:
            'X' 'SAPLJ1BW'              '0022',
            ' ' 'BDC_OKCODE'            '/00',
            ' ' 'J_1BTXST3V-RATE'       wf_z005-l,
            ' ' 'J_1BTXST3V-BASERED1'   wf_z005-p,
            ' ' 'J_1BTXST3V-BASERED2'   wf_z005-q,
            ' ' 'J_1BTXST3V-ICMSBASER'  wf_z005-r.

    WHEN OTHERS.

  ENDCASE.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BW'   '0022',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST3

*&---------------------------------------------------------------------*
*&      Form  ISS
*&---------------------------------------------------------------------*
FORM iss .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(12)',
        ' ' 'WA_TAX_TABLES-MARKED(12)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

*  Se existe somente um registro é necessário voltar na tela
* anterior para criar um novo registro.
  PERFORM valida_registro_unico USING 'J_1BTXISS'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0011',
        ' ' 'BDC_OKCODE'       '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'        '0012',
        ' ' 'BDC_OKCODE'            '/00',
        ' ' 'J_1BTXISSV-TAXJURCODE' wf_z005-c,
        ' ' 'J_1BTXISSV-VALIDFROM'  wf_z005-g,
        ' ' 'J_1BTXISSV-VALIDTO'    wf_z005-h,
        ' ' 'J_1BTXISSV-RATE'       wf_z005-i,
        ' ' 'J_1BTXISSV-BASE'       wf_z005-j,
        ' ' 'J_1BTXISSV-TAXLAW'     wf_z005-k,
        ' ' 'J_1BTXISSV-TAXRELLOC'  wf_z005-l,
        ' ' 'J_1BTXISSV-WITHHOLD'   wf_z005-m,
        ' ' 'J_1BTXISSV-MINVAL_WT'  wf_z005-n,
        ' ' 'J_1BTXISSV-WAERS'      wf_z005-o.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXISSV-VALUE' wf_z005-d.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXISSV-VALUE2' wf_z005-e.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXISSV-VALUE3' wf_z005-f.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0012',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " ISS

*&---------------------------------------------------------------------*
*&      Form  PIS
*&---------------------------------------------------------------------*
FORM pis.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(13)',
        ' ' 'WA_TAX_TABLES-MARKED(13)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0015',
        ' ' 'BDC_OKCODE'       '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0015',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXPISV-VALIDFROM(01)'  wf_z005-f,
        ' ' 'J_1BTXPISV-VALIDTO(01)'    wf_z005-g,
        ' ' 'J_1BTXPISV-RATE(01)'       wf_z005-h,
        ' ' 'J_1BTXPISV-BASE(01)'       wf_z005-i,
        ' ' 'J_1BTXPISV-AMOUNT(01)'     wf_z005-j,
        ' ' 'J_1BTXPISV-FACTOR(01)'     wf_z005-k,
        ' ' 'J_1BTXPISV-UNIT(01)'       wf_z005-l,
        ' ' 'J_1BTXPISV-WAERS(01)'      wf_z005-m,
        ' ' 'J_1BTXPISV-TAXLAW(01)'     wf_z005-n.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXPISV-VALUE(01)' wf_z005-c.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXPISV-VALUE2(01)' wf_z005-d.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXPISV-VALUE3(01)' wf_z005-e.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0015',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " PIS

*&---------------------------------------------------------------------*
*&      Form  COF
*&---------------------------------------------------------------------*
FORM cof.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(14)',
        ' ' 'WA_TAX_TABLES-MARKED(14)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0016',
        ' ' 'BDC_OKCODE'       '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0016',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXCOFV-VALIDFROM(01)'  wf_z005-f,
        ' ' 'J_1BTXCOFV-VALIDTO(01)'    wf_z005-g,
        ' ' 'J_1BTXCOFV-RATE(01)'       wf_z005-h,
        ' ' 'J_1BTXCOFV-BASE(01)'       wf_z005-i,
        ' ' 'J_1BTXCOFV-AMOUNT(01)'     wf_z005-j,
        ' ' 'J_1BTXCOFV-FACTOR(01)'     wf_z005-k,
        ' ' 'J_1BTXCOFV-UNIT(01)'       wf_z005-l,
        ' ' 'J_1BTXCOFV-WAERS(01)'      wf_z005-m,
        ' ' 'J_1BTXCOFV-TAXLAW(01)'     wf_z005-n.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXCOFV-VALUE(01)' wf_z005-c.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXCOFV-VALUE2(01)' wf_z005-d.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXCOFV-VALUE3(01)' wf_z005-e.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0016',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " COF

*&---------------------------------------------------------------------*
*&      Form  WIT
*&---------------------------------------------------------------------*
FORM wit.

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(15)',
        ' ' 'WA_TAX_TABLES-MARKED(15)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

*  Se existe somente um registro é necessário voltar na tela
* anterior para criar um novo registro.
  PERFORM valida_registro_unico USING 'J_1BTXWITH'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0017',
        ' ' 'BDC_OKCODE'       '=NEWL'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0018',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXWITHV-VALIDFROM'     wf_z005-f,
        ' ' 'J_1BTXWITHV-VALIDTO'       wf_z005-g,
        ' ' 'J_1BTXWITHV-COLL_GEN'      wf_z005-h,
        ' ' 'J_1BTXWITHV-RATE_GEN'      wf_z005-i,
        ' ' 'J_1BTXWITHV-COLL_PIS'      wf_z005-j,
        ' ' 'J_1BTXWITHV-RATE_PIS'      wf_z005-k,
        ' ' 'J_1BTXWITHV-COLL_COFINS'   wf_z005-l,
        ' ' 'J_1BTXWITHV-RATE_COFINS'   wf_z005-m,
        ' ' 'J_1BTXWITHV-COLL_CSLL'     wf_z005-n,
        ' ' 'J_1BTXWITHV-RATE_CSLL'     wf_z005-o,
        ' ' 'J_1BTXWITHV-COLL_IR'       wf_z005-p,
        ' ' 'J_1BTXWITHV-RATE_IR'       wf_z005-q,
        ' ' 'J_1BTXWITHV-J_1BWHTACC_RB' wf_z005-r.

  IF wf_grp-field IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXWITHV-VALUE' wf_z005-c.
  ENDIF.

  IF wf_grp-field2 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXWITHV-VALUE2' wf_z005-d.
  ENDIF.

  IF wf_grp-field3 IS NOT INITIAL.
    PERFORM bdc USING:
      ' ' 'J_1BTXWITHV-VALUE3' wf_z005-e.
  ENDIF.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0018',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " WIT

*&---------------------------------------------------------------------*
*&      Form  GRAVAR_LOG
*&---------------------------------------------------------------------*
FORM gravar_log .

  DELETE wt_z005 INDEX 1.

  CLEAR wf_z005.
  wf_z005-tabela = wv_tab.
  wf_z005-grupo  = wf_grp-gruop.
  wf_z005-uname  = sy-uname.
  wf_z005-datum  = sy-datum.
  wf_z005-uzeit  = sy-uzeit.

  MODIFY wt_z005 FROM wf_z005
    TRANSPORTING tabela grupo uname datum uzeit
    WHERE uname IS INITIAL.

  IF p_exec = 'X'.
*    INSERT /fherp/tsdt0001 FROM TABLE wt_z005.
  ENDIF.

ENDFORM. " GRAVAR_LOG

*&---------------------------------------------------------------------*
*&      Form  BATCH_INPUT_ALT
*&---------------------------------------------------------------------*
*       alteração
*----------------------------------------------------------------------*
FORM batch_input_alt .

  CLEAR wf_opt.
  wf_opt-dismode  = 'N'.
  wf_opt-updmode  = 'S'.
  wf_opt-racommit = 'X'.
  wf_opt-nobinpt  = 'X'.
  wf_opt-nobiend  = 'X'.

  CLEAR wv_where.
*  LOOP AT wt_campos INTO wf_campos.
*    CHECK wf_campos-key = 'X'.
*    IF wv_where IS NOT INITIAL.
*      CONCATENATE wv_where '#AND#' INTO wv_where.
*    ENDIF.
*    CONCATENATE wv_where
*                wf_campos-fieldname
*                '#=#'
*                wv_tab
*                '-'
*                wf_campos-fieldname
*           INTO wv_where.
*  ENDLOOP.

*  TRANSLATE wv_where USING '# '.

  ASSIGN (wv_tab) TO <tabela>.
  CHECK sy-subrc = 0.

  LOOP AT wt_z005 INTO wf_z005 FROM 2.
    CLEAR wv_where.
    wv_tabix = sy-tabix.

    LOOP AT wt_campos INTO wf_campos.
      wv_comp = sy-tabix + 1.
      ASSIGN COMPONENT wv_comp OF STRUCTURE <tabela> TO <campo>.
      CHECK sy-subrc = 0.
      wv_comp = wv_comp + 6.
      ASSIGN COMPONENT wv_comp OF STRUCTURE wf_z005 TO <z005>.
      CHECK sy-subrc = 0.

      IF wf_campos-inttype = 'C' AND wf_campos-lowercase IS INITIAL.
        TRANSLATE <z005> TO UPPER CASE.
      ENDIF.

      IF wf_campos-fieldname = 'VALIDFROM'.
        TRANSLATE <z005> USING '/.'.
      ENDIF.

      IF wf_campos-inttype = 'P'.
        TRANSLATE <z005> USING '. '.
        TRANSLATE <z005> USING ',.'.
        CONDENSE <z005> NO-GAPS.
      ENDIF.


      IF wf_campos-convexit IS NOT INITIAL AND <z005> IS NOT INITIAL.

        CONCATENATE 'CONVERSION' 'EXIT' wf_campos-convexit 'INPUT'
          INTO wv_funcname SEPARATED BY '_'.

        SELECT COUNT( * )
          FROM tfdir
          WHERE funcname = wv_funcname.                  "#EC CI_BYPASS

        IF sy-dbcnt = 1.

          CALL FUNCTION wv_funcname
            EXPORTING
              input         = <z005>
            IMPORTING
              output        = <campo>
            EXCEPTIONS
              error_message = 1.

          IF sy-subrc <> 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ELSE.
          <campo> = <z005>.
        ENDIF.
      ELSE.
        <campo> = <z005>.
      ENDIF.

      CHECK wf_campos-key = 'X'.
      IF wv_where IS NOT INITIAL.
        wv_where = |{ wv_where } AND |.
      ENDIF.
      wv_where = |{ wv_where }{ wf_campos-fieldname } = '{ <campo> }'|.

    ENDLOOP.

* Valida se o Registro realmente existe
    SELECT COUNT( * )
      FROM (wv_tab)
      WHERE (wv_where).

    IF sy-dbcnt = 1.

      REFRESH: wt_bdc, wt_msg.

      CASE 'X'.
        WHEN p_ic2. PERFORM ic2_alt.
        WHEN p_ic3. PERFORM ic3_alt.
        WHEN p_ci1. PERFORM ci1_alt.
        WHEN p_st2. PERFORM st2_alt.
        WHEN p_st1. PERFORM st1_alt.
        WHEN p_st3. PERFORM st3_alt.
        WHEN p_iss. PERFORM iss_alt.
        WHEN p_pis. PERFORM pis_alt.
        WHEN p_cof. PERFORM cof_alt.
        WHEN p_wit. PERFORM wit_alt.
        WHEN OTHERS.
          EXIT.
      ENDCASE.


* Inclui a Request no Batch Input
      PERFORM bdc_inclui_request.

* Chama transação
      CALL TRANSACTION 'J1BTAX'
                 USING wt_bdc
          OPTIONS FROM wf_opt
         MESSAGES INTO wt_msg.

* Trata Mensagens de Retorno
      PERFORM trata_mensagem_retorno_alt.

    ELSE.
      "Registro não existe
      wf_z005-msg = TEXT-016.
      MODIFY wt_z005 FROM wf_z005 INDEX wv_tabix.
    ENDIF.

  ENDLOOP.

ENDFORM. " BATCH_INPUT_ALT

*&---------------------------------------------------------------------*
*&      Form  IC2_ALT
*&---------------------------------------------------------------------*
FORM ic2_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(06)',
        ' ' 'WA_TAX_TABLES-MARKED(06)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0003',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-a,
        ' ' 'SVALD-VALUE(02)'  wf_z005-b,
        ' ' 'SVALD-VALUE(03)'  wf_z005-c,
        ' ' 'SVALD-VALUE(04)'  wf_z005-d,
        ' ' 'SVALD-VALUE(05)'  wf_z005-e.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0003',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXIC2-VALIDTO(01)'   wf_z005-f.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0003',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.


ENDFORM. " IC2_ALT

*&---------------------------------------------------------------------*
*&      Form  IC3_ALT
*&---------------------------------------------------------------------*
FORM ic3_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(07)',
        ' ' 'WA_TAX_TABLES-MARKED(07)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-d.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'   '0018',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-b,
        ' ' 'SVALD-VALUE(02)'  wf_z005-c,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f,
        ' ' 'SVALD-VALUE(05)'  wf_z005-g,
        ' ' 'SVALD-VALUE(06)'  wf_z005-h.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW' '0018',
        ' ' 'BDC_OKCODE' '/00',
        ' ' 'J_1BTXIC3V-VALIDTO(01)'   wf_z005-i.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BW'   '0018',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.


ENDFORM. " IC3_ALT

*&---------------------------------------------------------------------*
*&      Form  CI1_ALT
*&---------------------------------------------------------------------*
FORM ci1_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(08)',
        ' ' 'WA_TAX_TABLES-MARKED(08)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0006',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-a,
        ' ' 'SVALD-VALUE(02)'  wf_z005-b,
        ' ' 'SVALD-VALUE(03)'  wf_z005-c,
        ' ' 'SVALD-VALUE(04)'  wf_z005-d.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'                '0006',
        ' ' 'BDC_OKCODE'              '/00',
        ' ' 'J_1BTXCI1-VALIDTO(01)'   wf_z005-e.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0006',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " CI1_ALT

*&---------------------------------------------------------------------*
*&      Form  ST2_ALT
*&---------------------------------------------------------------------*
FORM st2_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(09)',
        ' ' 'WA_TAX_TABLES-MARKED(09)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1B0'   '0002',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-a,
        ' ' 'SVALD-VALUE(02)'  wf_z005-b,
        ' ' 'SVALD-VALUE(03)'  wf_z005-c,
        ' ' 'SVALD-VALUE(04)'  wf_z005-d,
        ' ' 'SVALD-VALUE(05)'  wf_z005-e.

  PERFORM bdc USING:
        'X' 'SAPLJ1B0'             '0002',
        ' ' 'BDC_OKCODE'           '=DETM',
        ' ' 'VIM_MARKED(01)'       'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1B0'             '0003',
        ' ' 'BDC_OKCODE'           '/00',
        ' ' 'J_1BTXST2-VALIDTO'    wf_z005-f.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1B0'   '0003',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST2_ALT

*&---------------------------------------------------------------------*
*&      Form  ST1_ALT
*&---------------------------------------------------------------------*
FORM st1_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(10)',
        ' ' 'WA_TAX_TABLES-MARKED(10)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'   '0008',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-a,
        ' ' 'SVALD-VALUE(02)'  wf_z005-b,
        ' ' 'SVALD-VALUE(03)'  wf_z005-c,
        ' ' 'SVALD-VALUE(04)'  wf_z005-d,
        ' ' 'SVALD-VALUE(05)'  wf_z005-e,
        ' ' 'SVALD-VALUE(06)'  wf_z005-f.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'             '0008',
        ' ' 'BDC_OKCODE'           '=DETM',
        ' ' 'VIM_MARKED(01)'       'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BQ'             '0009',
        ' ' 'BDC_OKCODE'           '/00',
        ' ' 'J_1BTXST1-VALIDTO'    wf_z005-g.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BQ'   '0009',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST1_ALT

*&---------------------------------------------------------------------*
*&      Form  ST3_ALT
*&---------------------------------------------------------------------*
FORM st3_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(11)',
        ' ' 'WA_TAX_TABLES-MARKED(11)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                       '0100',
        ' ' 'BDC_OKCODE'                     '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-d.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'   '0021',
        ' ' 'BDC_OKCODE' '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-b,
        ' ' 'SVALD-VALUE(02)'  wf_z005-c,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f,
        ' ' 'SVALD-VALUE(05)'  wf_z005-g,
        ' ' 'SVALD-VALUE(06)'  wf_z005-h,
        ' ' 'SVALD-VALUE(07)'  wf_z005-i.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'              '0021',
        ' ' 'BDC_OKCODE'            '=DETM',
        ' ' 'VIM_MARKED(01)'        'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BW'              '0022',
        ' ' 'BDC_OKCODE'            '/00',
        ' ' 'J_1BTXST3V-VALIDTO'    wf_z005-j.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BW'   '0022',
      ' ' 'BDC_OKCODE' '=SAVE'.
  ENDIF.

ENDFORM. " ST3_ALT

*&---------------------------------------------------------------------*
*&      Form  ISS_ALT
*&---------------------------------------------------------------------*
FORM iss_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(12)',
        ' ' 'WA_TAX_TABLES-MARKED(12)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0011',
        ' ' 'BDC_OKCODE'       '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-c,
        ' ' 'SVALD-VALUE(02)'  wf_z005-d,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f,
        ' ' 'SVALD-VALUE(05)'  wf_z005-g.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'        '0011',
        ' ' 'BDC_OKCODE'            '=DETM',
        ' ' 'VIM_MARKED(01)'        'X'.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'        '0012',
        ' ' 'BDC_OKCODE'            '/00',
        ' ' 'J_1BTXISSV-VALIDTO'    wf_z005-h.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0012',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " ISS_ALT
*&---------------------------------------------------------------------*
*&      Form  PIS_ALT
*&---------------------------------------------------------------------*
FORM pis_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(13)',
        ' ' 'WA_TAX_TABLES-MARKED(13)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0015',
        ' ' 'BDC_OKCODE'       '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-c,
        ' ' 'SVALD-VALUE(02)'  wf_z005-d,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0015',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXPISV-VALIDTO(01)'    wf_z005-g.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0015',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " PIS_ALT

*&---------------------------------------------------------------------*
*&      Form  COF_ALT
*&---------------------------------------------------------------------*
FORM cof_alt .

  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(14)',
        ' ' 'WA_TAX_TABLES-MARKED(14)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0016',
        ' ' 'BDC_OKCODE'       '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-c,
        ' ' 'SVALD-VALUE(02)'  wf_z005-d,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0016',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXCOFV-VALIDTO(01)'    wf_z005-g.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0016',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " COF_ALT

*&---------------------------------------------------------------------*
*&      Form  WIT_ALT
*&---------------------------------------------------------------------*
FORM wit_alt .


  SET PARAMETER ID 'LND' FIELD wf_z005-a.

  PERFORM bdc USING:
        'X' 'J_1B_MIGRATE_TAX_RATES'   '0010',
        ' ' 'BDC_OKCODE'               '=TAXRATE',
        ' ' 'BDC_CURSOR'               'WA_TAX_TABLES-TEXT(15)',
        ' ' 'WA_TAX_TABLES-MARKED(15)' 'X'.

  PERFORM bdc USING:
        'X' 'SAPLSVIX'                        '0100',
        ' ' 'BDC_OKCODE'                      '=OKAY',
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(01)' wf_z005-a,
        ' ' 'D0100_FIELD_TAB-LOWER_LIMIT(02)' wf_z005-b.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'   '0017',
        ' ' 'BDC_OKCODE'       '=POSI'.

  PERFORM bdc USING:
        'X' 'SAPLSPO4'         '0300',
        ' ' 'BDC_OKCODE'       '=FURT',
        ' ' 'SVALD-VALUE(01)'  wf_z005-c,
        ' ' 'SVALD-VALUE(02)'  wf_z005-d,
        ' ' 'SVALD-VALUE(03)'  wf_z005-e,
        ' ' 'SVALD-VALUE(04)'  wf_z005-f.

  PERFORM bdc USING:
        'X' 'SAPLJ1BISSCUST'            '0017',
        ' ' 'BDC_OKCODE'                '/00',
        ' ' 'J_1BTXWITHV-VALIDTO(01)'   wf_z005-g.

  IF p_exec = 'X'.
    PERFORM bdc USING:
      'X' 'SAPLJ1BISSCUST' '0017',
      ' ' 'BDC_OKCODE'     '=SAVE'.
  ENDIF.

ENDFORM. " WIT_ALT


*&---------------------------------------------------------------------*
*&      Form  SELECION_SCREEN_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM selecion_screen_output.

  DATA l_input TYPE screen-input.


  IF  p_ip3 = 'X' OR
      p_ic3 = 'X' OR
      p_st3 = 'X' OR
      p_iss = 'X' OR
      p_pis = 'X' OR
      p_cof = 'X' OR
      p_wit = 'X'.
    wv_grp = 'X'.
  ELSE.
    CLEAR wv_grp.
  ENDIF.

  IF wv_grp = 'X'.
    LOOP AT SCREEN.
      IF screen-name = 'P_GRP'.
        screen-required = 2.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ELSE.
    CLEAR p_grp.
    LOOP AT SCREEN.
      IF screen-name = 'P_GRP'.
        screen-input = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
  ENDIF.

* Lógica para desbloquear o campo de Request Customizing
  LOOP AT SCREEN.

    IF screen-name = 'P_REQ'.
      IF p_exec EQ abap_true.
        l_input = 1.
      ELSE.
        l_input = 0.
      ENDIF.
      screen-input = l_input.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

ENDFORM. "selecion_screen_output


*&---------------------------------------------------------------------*
*&      Form  INITIALIZATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM initialization.

  "Gerar Planilha
  MOVE TEXT-004 TO sscrfields-functxt_01.

ENDFORM. "initialization


*&---------------------------------------------------------------------*
*&      Form  BUSCA_ARQUIVO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM busca_arquivo.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

ENDFORM. "busca_arquivo


*&---------------------------------------------------------------------*
*&      Form  AT_SELECTION_SCREEN
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM at_selection_screen .

  IF  p_ip3 = 'X' OR
      p_ic3 = 'X' OR
      p_st3 = 'X' OR
      p_iss = 'X' OR
      p_pis = 'X' OR
      p_cof = 'X' OR
      p_wit = 'X'.
    wv_grp = 'X'.
  ELSE.
    CLEAR wv_grp.
  ENDIF.

  IF wv_grp = 'X'.
    CLEAR wf_grp.
    SELECT SINGLE *
      FROM j_1btxgruop
      INTO wf_grp
     WHERE gruop = p_grp.
  ENDIF.

  CASE sy-ucomm.

    WHEN 'FC01'.
      IF wv_grp = 'X' AND wf_grp IS INITIAL.
        "Informar grupo de imposto válido
        MESSAGE TEXT-017 TYPE 'E'.
      ENDIF.

      PERFORM gera_campos.

      PERFORM excel.

    WHEN OTHERS.
  ENDCASE.

ENDFORM. "at_selection_screen


*&---------------------------------------------------------------------*
*&      Form  EXIBE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM exibe_alv .

* Exibe ALV
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = wv_repid
      is_layout_lvc      = wf_layout
      it_fieldcat_lvc    = wt_fcat
    TABLES
      t_outtab           = wt_z005
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM. "exibe_alv


*&---------------------------------------------------------------------*
*&      Form  BDC_INCLUI_REQUEST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM bdc_inclui_request.

  CHECK p_req IS NOT INITIAL.

  PERFORM bdc USING:
        'X'  'SAPLSTRD'     '0300',
        ' '  'BDC_OKCODE'   '=LOCK',
        ' '  'KO008-TRKORR' p_req.

ENDFORM. "bdc_inclui_request


*&---------------------------------------------------------------------*
*&      Form  TRATA_MENSAGEM_RETORNO_INC
*&---------------------------------------------------------------------*
FORM trata_mensagem_retorno_inc.

* Falta telas de batch input
  DELETE wt_msg WHERE msgid = '00' AND msgnr = '344'.
* Não foram encontrados registros
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '004'.
* Um registro encontrado
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '005'.
* N registros encontrados
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '006'.

  IF p_exec = 'X'.
* dados gravados
    READ TABLE wt_msg INTO wf_msg
    WITH KEY msgid = 'SV' msgnr = '018'.

    IF sy-subrc = 0.
      MESSAGE ID wf_msg-msgid
            TYPE wf_msg-msgtyp
          NUMBER wf_msg-msgnr
            WITH wf_msg-msgv1
                 wf_msg-msgv2
                 wf_msg-msgv3
                 wf_msg-msgv4
            INTO wf_z005-msg.

    ELSE.
      DESCRIBE TABLE wt_msg.
      READ TABLE wt_msg INTO wf_msg INDEX sy-tfill.

      IF sy-subrc = 0.
        MESSAGE ID wf_msg-msgid
              TYPE wf_msg-msgtyp
            NUMBER wf_msg-msgnr
              WITH wf_msg-msgv1
                   wf_msg-msgv2
                   wf_msg-msgv3
                   wf_msg-msgv4
              INTO wf_z005-msg.
      ELSE.
        "Erro ao inserir registro
        wf_z005-msg = TEXT-012.
      ENDIF.
    ENDIF.

  ELSE.

    DESCRIBE TABLE wt_msg.
    READ TABLE wt_msg INTO wf_msg INDEX sy-tfill.

    IF sy-subrc = 0.
      MESSAGE ID wf_msg-msgid
            TYPE wf_msg-msgtyp
          NUMBER wf_msg-msgnr
            WITH wf_msg-msgv1
                 wf_msg-msgv2
                 wf_msg-msgv3
                 wf_msg-msgv4
            INTO wf_z005-msg.
    ELSE.
      "Sem erros na verificação
      wf_z005-msg = TEXT-013.
    ENDIF.

  ENDIF.

  MODIFY wt_z005 FROM wf_z005 INDEX wv_tabix.

ENDFORM. "trata_mensagem_retorno_inc


*&---------------------------------------------------------------------*
*&      Form  TRATA_MENSAGEM_RETORNO_ALT
*&---------------------------------------------------------------------*
FORM trata_mensagem_retorno_alt.

* Falta telas de batch input
  DELETE wt_msg WHERE msgid = '00' AND msgnr = '344'.
* Não foram encontrados registros
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '004'.
* Um registro encontrado
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '005'.
* N registros encontrados
  DELETE wt_msg WHERE msgid = 'SV' AND msgnr = '006'.

  IF p_exec = 'X'.
* dados gravados
    READ TABLE wt_msg INTO wf_msg
    WITH KEY msgid = 'SV' msgnr = '018'.

    IF sy-subrc = 0.
      MESSAGE ID wf_msg-msgid
            TYPE wf_msg-msgtyp
          NUMBER wf_msg-msgnr
            WITH wf_msg-msgv1
                 wf_msg-msgv2
                 wf_msg-msgv3
                 wf_msg-msgv4
            INTO wf_z005-msg.
    ELSE.
      DESCRIBE TABLE wt_msg.
      READ TABLE wt_msg INTO wf_msg INDEX sy-tfill.

      IF sy-subrc = 0.
        MESSAGE ID wf_msg-msgid
              TYPE wf_msg-msgtyp
            NUMBER wf_msg-msgnr
              WITH wf_msg-msgv1
                   wf_msg-msgv2
                   wf_msg-msgv3
                   wf_msg-msgv4
              INTO wf_z005-msg.
      ELSE.
        "Erro ao alterar registro
        wf_z005-msg = TEXT-014.
      ENDIF.
    ENDIF.

  ELSE.

    DESCRIBE TABLE wt_msg.
    READ TABLE wt_msg INTO wf_msg INDEX sy-tfill.

    IF sy-subrc = 0.
      MESSAGE ID wf_msg-msgid
            TYPE wf_msg-msgtyp
          NUMBER wf_msg-msgnr
            WITH wf_msg-msgv1
                 wf_msg-msgv2
                 wf_msg-msgv3
                 wf_msg-msgv4
            INTO wf_z005-msg.
    ELSE.
      "Sem erros na verificação
      wf_z005-msg = TEXT-015.
    ENDIF.

  ENDIF.


  MODIFY wt_z005 FROM wf_z005 INDEX wv_tabix.

ENDFORM. "trata_mensagem_retorno_alt


*&---------------------------------------------------------------------*
*&      Form  VALIDA_REGISTRO_UNICO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_4616   text
*----------------------------------------------------------------------*
FORM valida_registro_unico USING p_tab TYPE tabname.

  DATA l_count   TYPE sy-tabix.
  DATA l_country TYPE land1.
  DATA l_tab     TYPE tabname.


  CHECK wf_z005-a IS NOT INITIAL AND
        p_tab     IS NOT INITIAL AND
        p_grp     IS NOT INITIAL.

  l_country = wf_z005-a.

  CASE p_tab.
    WHEN 'J_1BTXWITH'.
      SELECT COUNT(*)
              INTO l_count
              FROM (p_tab)
             WHERE country EQ l_country
               AND gruop   EQ p_grp.
      IF  l_count EQ 1.
        PERFORM bdc USING:
              'X' 'SAPLJ1BISSCUST'   '0018',
              ' ' 'BDC_OKCODE'       '=UEBE'.
      ENDIF.

*J_1BTXST3
    WHEN 'J_1BTXST3'.
      SELECT COUNT(*)
              INTO l_count
              FROM (p_tab)
             WHERE land1 EQ l_country
               AND gruop EQ p_grp.
      IF  l_count EQ 1.
        PERFORM bdc USING:
              'X' 'SAPLJ1BW'    '0022',
              ' ' 'BDC_OKCODE'  '=UEBE'.
      ENDIF.

*ISS
    WHEN 'J_1BTXISS'.
      SELECT COUNT(*)
              INTO l_count
              FROM (p_tab)
             WHERE country EQ l_country
               AND gruop   EQ p_grp.
      IF  l_count EQ 1.
        PERFORM bdc USING:
              'X' 'SAPLJ1BISSCUST' '0012',
              ' ' 'BDC_OKCODE'     '=UEBE'.
      ENDIF.

    WHEN OTHERS.
  ENDCASE.

ENDFORM. "valida_registro_unico
