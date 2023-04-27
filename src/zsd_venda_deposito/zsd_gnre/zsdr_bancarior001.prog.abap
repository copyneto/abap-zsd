*&---------------------------------------------------------------------*
*& Report ZSDR_BANCARIOR001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_bancarior001.

TABLES: ztsd_aut_ban_log,  "Automatização Bancária - Log processamento
        ztsd_aut_ban_pro. "Automatização Bancária - Registros processados

DATA: gt_in  TYPE STANDARD TABLE OF ztsd_aut_ban_log WITH NON-UNIQUE DEFAULT KEY,  "Log processamento entrada
      gt_out TYPE STANDARD TABLE OF ztsd_aut_ban_pro WITH NON-UNIQUE DEFAULT KEY. "Log processamento saída

DATA: gv_salv      TYPE REF TO cl_salv_table, "Objeto para exibição do ALV.
      gv_functions TYPE REF TO cl_salv_functions, "Objeto que controla funções do ALV.
      gv_columns   TYPE REF TO cl_salv_columns_table, "Objeto que contrala as colunas.
      gv_column    TYPE REF TO cl_salv_column. "Caracteristica da coluna.

*&---------------------------------------------------------------------*
*&      SELECTION SCREEN
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_in  RADIOBUTTON GROUP gr1 DEFAULT 'X' USER-COMMAND opc , "Relatório de importação
              p_out RADIOBUTTON GROUP gr1 .                              "Relatório de exportação

  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-003.
    SELECT-OPTIONS: s_nome  FOR ztsd_aut_ban_log-nome  MODIF ID in NO INTERVALS NO-EXTENSION, "Nome do arquivo importado
                    s_tipo  FOR ztsd_aut_ban_log-tipo  MODIF ID in NO INTERVALS NO-EXTENSION, "Tipo do logal de busca
                    s_type  FOR ztsd_aut_ban_log-type  MODIF ID in NO INTERVALS NO-EXTENSION, "Tipo da mensagem (Sucesso ou Erro)
                    s_datum FOR ztsd_aut_ban_log-datum MODIF ID in, "Data do processamento
                    s_uzeit FOR ztsd_aut_ban_log-uzeit MODIF ID in, "Hora do processamento
                    s_uname FOR ztsd_aut_ban_log-uname MODIF ID in. "Usuário do processamento
  SELECTION-SCREEN END OF BLOCK b2.

  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
    SELECT-OPTIONS: s_laufd  FOR ztsd_aut_ban_pro-laufd MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_laufi  FOR ztsd_aut_ban_pro-laufi MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_zbukr  FOR ztsd_aut_ban_pro-zbukr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_lifnr  FOR ztsd_aut_ban_pro-lifnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_kunnr  FOR ztsd_aut_ban_pro-kunnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_empfg  FOR ztsd_aut_ban_pro-empfg MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_vblnr  FOR ztsd_aut_ban_pro-vblnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_type1  FOR ztsd_aut_ban_pro-type  MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_datum1 FOR ztsd_aut_ban_pro-datum MODIF ID out,
                    s_uzeit1 FOR ztsd_aut_ban_pro-uzeit MODIF ID out,
                    s_uname1 FOR ztsd_aut_ban_pro-uname MODIF ID out.
  SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN END OF BLOCK b1.

*Efetua modificações nos campos da tela de seleção.
AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    "Oculta todos os campos de saída, caso o relatório de entrada seja selecionado.
    IF NOT p_in IS INITIAL.
      IF screen-group1 = 'OUT'.
        screen-input = 0.
        screen-invisible = 1.
      ELSE.
        screen-input = 1.
        screen-invisible = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
    "Oculta todos os campos de entrada, caso o relatório de saída seja selecionado.
    IF NOT p_out IS INITIAL.
      IF screen-group1 = 'IN'.
        screen-input = 0.
        screen-invisible = 1.
      ELSE.
        screen-input = 1.
        screen-invisible = 0.
      ENDIF.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.
  "Dados de log para arquivos de entrada.
  IF NOT p_in IS INITIAL.
    PERFORM f_entrada.
  ENDIF.
  "Dados de log para arquivos de saída.
  IF NOT p_out IS INITIAL.
    PERFORM f_saida.
  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  F_ENTRADA
*&---------------------------------------------------------------------*
*       Efetua a geração do relatório ALV para o processamento dos
*       arquivos de entrada (Recebidos da VAN).
*----------------------------------------------------------------------*
FORM f_entrada .
  CLEAR: gt_in, gv_salv, gv_functions, gv_columns, gv_column.
  FREE: gv_salv, gv_functions, gv_columns, gv_column.
  "Busca os registros de log para saída.
  SELECT * INTO TABLE gt_in
    FROM ztsd_aut_ban_log
   WHERE nome  IN s_nome
     AND tipo  IN s_tipo
     AND type  IN s_type
     AND datum IN s_datum
     AND uzeit IN s_uzeit
     AND uname IN s_uname
     ORDER BY codigo.
  IF sy-subrc EQ 0.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = gv_salv
                                 CHANGING t_table      = gt_in ).
        "Habilitam as funções do relatório ALV.
        gv_functions = gv_salv->get_functions( ).
        gv_functions->set_all( abap_true ).
        "Ajusta parametros de exibição das colunas.
        gv_columns = gv_salv->get_columns( ).
        gv_columns->set_optimize( abap_true ).
        TRY.
            gv_column = gv_columns->get_column( 'MANDT'(005) ).
            gv_column->set_visible( abap_false ).
            gv_column = gv_columns->get_column( 'CODIGO'(006) ).
            gv_column->set_visible( abap_false ).
          CATCH cx_salv_not_found INTO DATA(lv_not_found).
            LEAVE LIST-PROCESSING.
          CATCH cx_static_check INTO DATA(lv_static_check).
            LEAVE LIST-PROCESSING.
        ENDTRY.
        TRY.
            gv_column = gv_columns->get_column( 'NOME'(007) ).
            gv_column->set_short_text( CONV #( 'Nome Arquivo'(008) ) ).
          CATCH cx_salv_not_found INTO lv_not_found.
            LEAVE LIST-PROCESSING.
          CATCH cx_static_check INTO lv_static_check.
            LEAVE LIST-PROCESSING.
        ENDTRY.
        "Exibe o ALV.
        gv_salv->display( ).
      CATCH cx_salv_msg INTO DATA(lv_erro).
        LEAVE LIST-PROCESSING.
    ENDTRY.
  ELSE.
    MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " F_ENTRADA

*&---------------------------------------------------------------------*
*&      Form  F_SAIDA
*&---------------------------------------------------------------------*
*       Efetua a geração do relatório ALV para o processamento dos
*       arquivos de saída (Entregues para a VAN "remessa").
*----------------------------------------------------------------------*
FORM f_saida .
  CLEAR: gt_out, gv_salv, gv_functions, gv_columns, gv_column.
  FREE: gv_salv, gv_functions, gv_columns, gv_column.
  "Busca os registros de log para saída.
  SELECT * INTO TABLE gt_out
    FROM ztsd_aut_ban_pro
   WHERE laufd IN s_laufd
     AND laufi IN s_laufi
     AND zbukr IN s_zbukr
     AND lifnr IN s_lifnr
     AND kunnr IN s_kunnr
     AND empfg IN s_empfg
     AND vblnr IN s_vblnr
     AND type  IN s_type1
     AND datum IN s_datum1
     AND uzeit IN s_uzeit1
     AND uname IN s_uname1
     ORDER BY laufd
              laufi
              xvorl
              zbukr
              lifnr
              kunnr
              empfg
              vblnr.

  IF sy-subrc EQ 0.
    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = gv_salv
                                 CHANGING t_table      = gt_out ).
        "Habilitam as funções do relatório ALV.
        gv_functions = gv_salv->get_functions( ).
        gv_functions->set_all( abap_true ).
        "Ajusta parametros de exibição das colunas.
        gv_columns = gv_salv->get_columns( ).
        gv_columns->set_optimize( abap_true ).
        TRY.
            gv_column = gv_columns->get_column( 'MANDT'(005) ).
            gv_column->set_visible( abap_false ).
          CATCH cx_salv_not_found INTO DATA(lv_not_found).
            LEAVE LIST-PROCESSING.
          CATCH cx_static_check INTO DATA(lv_static_check).
            LEAVE LIST-PROCESSING.
        ENDTRY.
        "Exibe o ALV.
        gv_salv->display( ).
      CATCH cx_salv_msg INTO DATA(lv_erro).
        LEAVE LIST-PROCESSING.
    ENDTRY.
  ELSE.
    MESSAGE TEXT-e02 TYPE 'S' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.
ENDFORM.                    " F_SAIDA
