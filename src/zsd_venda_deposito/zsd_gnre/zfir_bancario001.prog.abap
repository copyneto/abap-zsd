***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Exportação de arquivos bancários para VAN              *
*** AUTOR : Everthon Costa – Meta                                     *
*** FUNCIONAL: Sandro – Meta                                          *
*** DATA : 27/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR          | DESCRIÇÃO                            *
***-------------------------------------------------------------------*
*** 27/04/22  | ECOSTA         | Cópia ECC to S4                      *
***********************************************************************
REPORT zfir_bancario001.

TABLES: ztfi_autbanc_log,  "Automatização Bancária - Log processamento
        ztfi_autbanc_prc. "Automatização Bancária - Registros processados

DATA: gt_in  TYPE STANDARD TABLE OF ztfi_autbanc_log, "Log processamento entrada
      gt_out TYPE STANDARD TABLE OF ztfi_autbanc_prc. "Log processamento saída

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
    SELECT-OPTIONS: s_nome  FOR ztfi_autbanc_log-nome  MODIF ID in NO INTERVALS NO-EXTENSION, "Nome do arquivo importado
                    s_tipo  FOR ztfi_autbanc_log-tipo  MODIF ID in NO INTERVALS NO-EXTENSION, "Tipo do logal de busca
                    s_type  FOR ztfi_autbanc_log-msgtype  MODIF ID in NO INTERVALS NO-EXTENSION, "Tipo da mensagem (Sucesso ou Erro)
                    s_datum FOR sy-datum MODIF ID in, "Data do processamento
                    s_uzeit FOR sy-uzeit MODIF ID in, "Hora do processamento
                    s_uname FOR sy-uname MODIF ID in. "Usuário do processamento
  SELECTION-SCREEN END OF BLOCK b2.
*
  SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-004.
    SELECT-OPTIONS: s_laufd  FOR ztfi_autbanc_prc-laufd MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_laufi  FOR ztfi_autbanc_prc-laufi MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_zbukr  FOR ztfi_autbanc_prc-zbukr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_lifnr  FOR ztfi_autbanc_prc-lifnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_kunnr  FOR ztfi_autbanc_prc-kunnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_empfg  FOR ztfi_autbanc_prc-empfg MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_vblnr  FOR ztfi_autbanc_prc-vblnr MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_type1  FOR ztfi_autbanc_prc-type  MODIF ID out NO INTERVALS NO-EXTENSION,
                    s_datum1 FOR sy-datum MODIF ID out,
                    s_uzeit1 FOR sy-uzeit MODIF ID out,
                    s_uname1 FOR sy-uname MODIF ID out.
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
*&      Form  ENTRADA
*&---------------------------------------------------------------------*
*       Efetua a geração do relatório ALV para o processamento dos
*       arquivos de entrada (Recebidos da VAN).
*----------------------------------------------------------------------*
FORM f_entrada .
  CLEAR: gt_in, gv_salv, gv_functions, gv_columns, gv_column.
  FREE: gv_salv, gv_functions, gv_columns, gv_column.

  DATA: lr_created_at TYPE RANGE OF ztfi_autbanc_log-created_at,
        lr_created_by TYPE RANGE OF ztfi_autbanc_log-created_by.

  DATA: ls_created_at LIKE LINE OF lr_created_at,
        ls_created_by LIKE LINE OF lr_created_by.

  LOOP AT s_uname ASSIGNING FIELD-SYMBOL(<fs_uname>).
    ls_created_by-low    = <fs_uname>-low.
    ls_created_by-high   = <fs_uname>-high .
    ls_created_by-option = <fs_uname>-option.
    ls_created_by-sign   = <fs_uname>-sign.

    APPEND ls_created_by TO lr_created_by.
  ENDLOOP.


  LOOP AT s_datum ASSIGNING FIELD-SYMBOL(<fs_datum>).

    READ TABLE s_uzeit1 ASSIGNING FIELD-SYMBOL(<fs_uzeit>) INDEX 1.
    IF sy-subrc IS INITIAL.

      ls_created_at-low    = |{ <fs_datum>-low }{ <fs_uzeit>-low }|.
      ls_created_at-high   = |{ <fs_datum>-high }{ <fs_uzeit>-high }|.
      ls_created_at-option = |{ <fs_datum>-option }{ <fs_uzeit>-option }|.
      ls_created_at-sign   = |{ <fs_datum>-sign }{ <fs_uzeit>-sign }|.

    ELSE.

      ls_created_at-low    = <fs_datum>-low.
      ls_created_at-high   = <fs_datum>-high.
      ls_created_at-option = <fs_datum>-option.
      ls_created_at-sign   = <fs_datum>-sign.

    ENDIF.

    APPEND ls_created_at TO lr_created_at.
  ENDLOOP.

  "Busca os registros de log para saída.
  SELECT * INTO TABLE gt_in                             "#EC CI_NOFIELD
    FROM ztfi_autbanc_log
   WHERE nome       IN s_nome
     AND tipo       IN s_tipo
     AND msgtype    IN s_type
     AND created_at IN lr_created_at
     AND created_by IN lr_created_by.
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
ENDFORM.                    " ENTRADA

*&---------------------------------------------------------------------*
*&      Form  SAIDA
*&---------------------------------------------------------------------*
*       Efetua a geração do relatório ALV para o processamento dos
*       arquivos de saída (Entregues para a VAN "remessa").
*----------------------------------------------------------------------*
FORM f_saida .
  CLEAR: gt_out, gv_salv, gv_functions, gv_columns, gv_column.
  FREE: gv_salv, gv_functions, gv_columns, gv_column.

  DATA: lr_created_at TYPE RANGE OF ztfi_autbanc_log-created_at,
        lr_created_by TYPE RANGE OF ztfi_autbanc_log-created_by.

  DATA: ls_created_at LIKE LINE OF lr_created_at,
        ls_created_by LIKE LINE OF lr_created_by.

  LOOP AT s_datum1 ASSIGNING FIELD-SYMBOL(<fs_datum>).

    READ TABLE s_uzeit1 ASSIGNING FIELD-SYMBOL(<fs_uzeit>) INDEX 1.

    IF sy-subrc IS INITIAL.

      ls_created_at-low    = |{ <fs_datum>-low }{ <fs_uzeit>-low }|.
      ls_created_at-high   = |{ <fs_datum>-high }{ <fs_uzeit>-high }|.
      ls_created_at-option = |{ <fs_datum>-option }{ <fs_uzeit>-option }|.
      ls_created_at-sign   = |{ <fs_datum>-sign }{ <fs_uzeit>-sign }|.

    ELSE.

      ls_created_at-low    = <fs_datum>-low.
      ls_created_at-high   = <fs_datum>-high.
      ls_created_at-option = <fs_datum>-option.
      ls_created_at-sign   = <fs_datum>-sign.

    ENDIF.

    APPEND ls_created_at TO lr_created_at.
  ENDLOOP.

  LOOP AT s_uname1 ASSIGNING FIELD-SYMBOL(<fs_uname>).
    ls_created_by-low    = <fs_uname>-low.
    ls_created_by-high   = <fs_uname>-high .
    ls_created_by-option = <fs_uname>-option.
    ls_created_by-sign   = <fs_uname>-sign.

    APPEND ls_created_by TO lr_created_by.
  ENDLOOP.


  "Busca os registros de log para saída.
  SELECT * INTO TABLE gt_out                            "#EC CI_NOFIELD
    FROM ztfi_autbanc_prc
   WHERE laufd IN s_laufd
     AND laufi IN s_laufi
     AND zbukr IN s_zbukr
     AND lifnr IN s_lifnr
     AND kunnr IN s_kunnr
     AND empfg IN s_empfg
     AND vblnr IN s_vblnr
     AND type  IN s_type1
     AND created_at IN lr_created_at
     AND created_by IN lr_created_by.
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
ENDFORM.                    " SAIDA
