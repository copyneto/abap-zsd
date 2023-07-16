***********************************************************************
***                      © 3corações                                ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: SD-164 - Envio de títulos do cliente para SIRIUS       *
*** AUTOR : Anderson Miazato - META                                   *
*** FUNCIONAL: Cleverson Faria - META                                 *
*** DATA : 05.11.2021                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR              | DESCRIÇÃO                       *
***-------------------------------------------------------------------*
*** 05.11.2021 | Anderson Miazato   | Desenvolvimento inicial         *
*** 16.07.2023 | Luís Gustavo Schepp | Desativação do desenvolvimento *
* inicial e cópia e adaptação do report ZSIRIUS2_TITULO do ECC        *
***********************************************************************

*&---------------------------------------------------------------------*
*& Report zsdi_envio_titulos_sirius
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdi_envio_titulos_sirius MESSAGE-ID zsd_ordem_sirius.

* CÓDIGO COMENTADO EM 16/07/2023. ESTA SOLUÇÃO NÃO ATENDEU A VOLUMETRIA
* EXIGIDA POIS ONEROU EXTRETAMENTE A PERFORMANCE EM AMBIENTE PRODUTIVO

***INCLUDE zsdi_envio_titulos_sirius_top.
***
***SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
***  SELECT-OPTIONS: s_perio FOR sy-datum.
***SELECTION-SCREEN END OF BLOCK b1.
***
***
***
***START-OF-SELECTION.
***
***  gs_selscreen-s_perio = s_perio[].
***
***  NEW zclsd_envio_titulos_sirius( gs_selscreen )->main( ).


* O CÓDIGO ABAIXO VEIO DO AMBIENTE ECC -> REPORT ZSIRIUS2_TITULO
* A CODIFICAÇÃO FOI SOMENTE ADAPTADA PARA ATENDER O PADRÃO DE DESENVOLVIMENTO

************************************************************************
* Programa..: ZSIRIUS2_TITULO
* Descricao.: Palm-Top: Exportação dos titulos do cliente
* Criado por: Victor Almeida
* Data......: 18/12/2012
* Lista de Modificações:
* Data         Autor               Corr. #     Descrição
************************************************************************

TABLES knvv.

DATA: gv_sqlerr_ref TYPE REF TO cx_sql_exception,
      gv_exc_ref    TYPE REF TO cx_sy_native_sql_error,
      gv_error_text TYPE string.

TYPES: BEGIN OF ty_titaux,
         bukrs(04),                         " Empresa
         gjahr(04),                         " Exercício contábil
         kunnr(10),                         " Nº cliente
         zlsch(01),                         " Meio de pagamento
         belnr(10),                         " Nº documento (nº título)
         buzei(03),                         " Item
         wrbtr     TYPE bsid_view-wrbtr,    " Valor
         budat     TYPE bsid_view-budat,    " Data de emissão
         zfbdt     TYPE bsid_view-zfbdt,    " Data de vencimento
         zbd1t     TYPE bsid_view-zbd1t,    " Valor (campo auxiliar)
         zbd2t     TYPE bsid_view-zbd2t,    " Valor (campo auxiliar)
         zbd3t     TYPE bsid_view-zbd3t,    " Valor (campo auxiliar)
         umsks     TYPE bsid_view-umsks,
         umskz     TYPE bsid_view-umskz,
         xblnr     TYPE bsid_view-xblnr,    " Nº documento de referência
         bschl     TYPE bsid_view-bschl,
         rebzg     TYPE bsid_view-rebzg,
       END OF ty_titaux,

       BEGIN OF ty_titcom,
         bukrs(04),                       " Empresa
         kunnr(10),                       " Nº cliente
         augdt     TYPE bsad_view-augdt,  " Data de compensação
         gjahr(04),                       " Exercício contábil
         belnr(10),                       " Nº documento (nº título)
         buzei(03),                       " Item
         xblnr     TYPE bsad_view-xblnr,  " Referencia
         zlsch(01),                       " Meio de pagamento
       END OF ty_titcom,

       BEGIN OF ty_titulo,
         belnr(18),                        " Nº documento (nº título)
         kunnr(10),                        " Nº cliente
         belnr2(10),                       " Nº documento (nº título)
         budat(10),                        " Data de emissão
         wrbtr(15),                        " Valor
         zfbdt(10),                        " Data de vencimento
         zlsch(01),                        " Meio de pagamento
         augdt(10),                        " Data de compensação
         buzei(03),                        " Item
         xblnr      TYPE bsad_view-xblnr,  " Referencia
       END OF ty_titulo.

TYPES: BEGIN OF ty_tit_abertos,
         kunnr TYPE bsad_view-kunnr,
         belnr TYPE bsad_view-belnr,
         buzei TYPE bsad_view-buzei,
       END OF ty_tit_abertos.

DATA: gt_titaux      TYPE STANDARD TABLE OF ty_titaux,
      gt_titcom      TYPE STANDARD TABLE OF ty_titcom,
      gt_titulo      TYPE STANDARD TABLE OF ty_titulo,
      gt_tit_abertos TYPE STANDARD TABLE OF ty_tit_abertos.

DATA: gs_titulo      TYPE ty_titulo,
      gs_tit_abertos TYPE ty_tit_abertos.

DATA: BEGIN OF gt_faede OCCURS 1.
        INCLUDE STRUCTURE faede.
DATA: END OF gt_faede.

DATA: BEGIN OF gt_result OCCURS 1.
        INCLUDE STRUCTURE faede.
DATA: END OF gt_result.

*--> Início
START-OF-SELECTION.
  PERFORM f_sel_titulos.
  PERFORM f_exporta_titulos.
  PERFORM f_tit_abertos_sirius.
  PERFORM f_sel_compensados.
  PERFORM f_exporta_compensados.

*&---------------------------------------------------------------------*
*&      Form  F_SEL_TITULOS
*&---------------------------------------------------------------------*
FORM f_sel_titulos.

* Selecionando as informações
  SELECT  a~bukrs, a~gjahr, b~kunnr, a~zlsch, a~belnr, a~buzei, a~wrbtr,
          a~budat, a~zfbdt, a~zbd1t, a~zbd2t, a~zbd3t, a~umsks, a~umskz,
          a~xblnr, a~bschl, a~rebzg
    FROM bsid_view AS a
    INNER JOIN
          kna1 AS b ON a~kunnr EQ b~kunnr
    WHERE a~saknr NOT IN ('1130000012', '1130000010') "Exclui exportação e coligadas
      AND a~bstat NOT IN ('M', 'S', 'V', 'W', 'Z')
      AND a~shkzg EQ 'S'
      AND b~konzs EQ 'CLIENTE'
      INTO TABLE @gt_titaux.

  LOOP AT gt_titaux ASSIGNING FIELD-SYMBOL(<fs_titaux>).
* Verifica se há area selecionadas de vendas
    SELECT COUNT( * ) FROM knvv
    WHERE kunnr EQ <fs_titaux>-kunnr.
    CHECK: sy-subrc EQ 0.

    IF <fs_titaux>-zlsch IS INITIAL.
* Se estiver em branco só continua se for cheque devolvido
      CHECK: <fs_titaux>-umsks EQ 'D' AND <fs_titaux>-umskz EQ 'D'.
    ENDIF.

    REFRESH: gt_faede, gt_result.
    CLEAR: gt_faede, gt_result.
    MOVE-CORRESPONDING <fs_titaux> TO gt_faede.
    gt_faede-koart = 'D'.
    APPEND gt_faede.
    CALL FUNCTION 'DETERMINE_DUE_DATE'
      EXPORTING
        i_faede = gt_faede
      IMPORTING
        e_faede = gt_result.

* Se o título está vencido - exportar
    gs_titulo-kunnr = <fs_titaux>-kunnr.
    IF <fs_titaux>-zlsch IS INITIAL.
      gs_titulo-zlsch = 'D'.
    ELSE.
      gs_titulo-zlsch = <fs_titaux>-zlsch.
    ENDIF.

    gs_titulo-belnr2 = <fs_titaux>-belnr.

    CONCATENATE <fs_titaux>-kunnr+3 <fs_titaux>-belnr INTO gs_titulo-belnr.

    gs_titulo-wrbtr = <fs_titaux>-wrbtr.

    IF <fs_titaux>-bschl EQ '06' AND <fs_titaux>-rebzg NE space.
      gs_titulo-xblnr = <fs_titaux>-rebzg.
    ELSE.
      gs_titulo-xblnr = <fs_titaux>-xblnr.
    ENDIF.

* Lançamento : formato AAAA-MM-DD
    CONCATENATE <fs_titaux>-budat(4) '-' <fs_titaux>-budat+4(2) '-'
                <fs_titaux>-budat+6(2) INTO gs_titulo-budat.
* Vencimento : formato AAAA-MM-DD
    CONCATENATE gt_result-netdt(4) '-' gt_result-netdt+4(2) '-'
                gt_result-netdt+6(2) INTO gs_titulo-zfbdt.
    gs_titulo-buzei = <fs_titaux>-buzei.
    APPEND gs_titulo TO gt_titulo.

  ENDLOOP.

ENDFORM.                    " F_SEL_TITULOS

*&---------------------------------------------------------------------*
*&      Form  F_EXPORTA_TITULOS
*&---------------------------------------------------------------------*
FORM f_exporta_titulos.

*--> CONECTA COM O BANCO DE DADOS EXTERNO.
  EXEC SQL.
    CONNECT TO 'PSIRIUS2' AS 'A'
  ENDEXEC.

*--> Inseri TITULOS no SAV
  LOOP AT gt_titulo ASSIGNING FIELD-SYMBOL(<fs_titulo>).

    TRY.
        EXEC SQL.

          INSERT INTO TITULO

                 (CODIGO,
                  ITEM,
                  CLIENTE,
                  DOCUMENTO,
                  DATALANCAMENTO,
                  VALOR,
                  DATAVENCIMENTO,
                  MEIOPAGAMENTO,
                  REFERENCIA)

          VALUES (:<fs_titulo>-BELNR,
                  :<fs_titulo>-BUZEI,
                  :<fs_titulo>-KUNNR,
                  :<fs_titulo>-BELNR2,
                  :<fs_titulo>-BUDAT,
                  :<fs_titulo>-WRBTR,
                  :<fs_titulo>-ZFBDT,
                  :<fs_titulo>-ZLSCH,
                  :<fs_titulo>-XBLNR)

        ENDEXEC.

      CATCH cx_sy_native_sql_error.
        EXEC SQL.
*          ROLLBACK CONNECTION 'A'
*          SET CONNECTION DEFAULT
*          DISCONNECT 'A'
        ENDEXEC.

    ENDTRY.

  ENDLOOP.

  COMMIT WORK.

* Deleta titulos compensados com mais de 90 dias de compensação.
  TRY.
      EXEC SQL.
        DELETE FROM DBO.TITULO WHERE DATACOMPENSACAO IS NOT NULL AND DATACONTROLE < getdate() - 90
      ENDEXEC.

    CATCH cx_sy_native_sql_error INTO gv_exc_ref.
      EXEC SQL.
        ROLLBACK CONNECTION 'A'
        SET CONNECTION DEFAULT
        DISCONNECT 'A'
      ENDEXEC.
      gv_error_text = gv_exc_ref->get_text( ).
      MESSAGE e000(zsd_ordem_sirius) WITH gv_error_text.
    CATCH cx_sql_exception INTO gv_sqlerr_ref.
      PERFORM f_handle_sql_exception USING gv_sqlerr_ref.
  ENDTRY.

  COMMIT WORK.
*--> DESCONECTAR.
  EXEC SQL.
    DISCONNECT 'A'
  ENDEXEC.

*--> VOLTA PARA OS ACESSOS AO BD DEFAULT DO R3.
  EXEC SQL.
    SET CONNECTION DEFAULT
  ENDEXEC.

ENDFORM.                    " F_EXPORTA_TITULOS

*&---------------------------------------------------------------------*
*&      Form  F_SEL_COMPENSADOS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_sel_compensados .

* Selecionando as informações
  CHECK gt_tit_abertos[] IS NOT INITIAL.
  SELECT a~bukrs, b~kunnr, a~augdt, a~gjahr, a~belnr, a~buzei, a~xblnr, a~zlsch
    FROM bsad_view AS a
    INNER JOIN
          kna1 AS b ON a~kunnr EQ b~kunnr
    FOR ALL ENTRIES IN @gt_tit_abertos
    WHERE a~kunnr EQ @gt_tit_abertos-kunnr
      AND a~belnr EQ @gt_tit_abertos-belnr
      AND a~buzei EQ @gt_tit_abertos-buzei
      AND a~saknr NOT IN ('1130000012', '1130000010') "Exclui exportação e coligadas
      AND a~bstat NOT IN ('M', 'S', 'V', 'W', 'Z')
      AND a~shkzg EQ 'S'
      AND b~konzs EQ 'CLIENTE'
      INTO TABLE @gt_titcom.

  REFRESH gt_titulo.
  CLEAR gs_titulo.

  LOOP AT gt_titcom ASSIGNING FIELD-SYMBOL(<fs_titcom>).
    CONCATENATE <fs_titcom>-kunnr+3 <fs_titcom>-belnr INTO gs_titulo-belnr.
    gs_titulo-buzei = <fs_titcom>-buzei.
    gs_titulo-belnr2 = <fs_titcom>-belnr.
* Compensação : formato AAAA-MM-DD
    gs_titulo-augdt = <fs_titcom>-augdt.
    APPEND gs_titulo TO gt_titulo.
  ENDLOOP.

ENDFORM.                    " F_SEL_COMPENSADOS

*&---------------------------------------------------------------------*
*&      Form  F_EXPORTA_COMPENSADOS
*&---------------------------------------------------------------------*
FORM f_exporta_compensados .

  DATA lv_item TYPE i.

*--> CONECTA COM O BANCO DE DADOS EXTERNO.
  EXEC SQL.
    CONNECT TO 'PSIRIUS2' AS 'A'
  ENDEXEC.


  LOOP AT gt_titulo ASSIGNING FIELD-SYMBOL(<fs_titulo>).
    lv_item = <fs_titulo>-buzei.
    TRY.
        EXEC SQL.
          UPDATE TITULO SET DATACOMPENSACAO = :<fs_titulo>-AUGDT, DATACONTROLE = GETDATE()
                                                         WHERE CODIGO = :<fs_titulo>-BELNR AND
                                                               ITEM   = :lv_item AND
                                                               DATACOMPENSACAO IS NULL
        ENDEXEC.
      CATCH cx_sy_native_sql_error INTO gv_exc_ref.
        EXEC SQL.
          ROLLBACK CONNECTION 'A'
          SET CONNECTION DEFAULT
          DISCONNECT 'A'
        ENDEXEC.
        gv_error_text = gv_exc_ref->get_text( ).
        MESSAGE e000(zsd_ordem_sirius) WITH gv_error_text.
      CATCH cx_sql_exception INTO gv_sqlerr_ref.
        PERFORM f_handle_sql_exception USING gv_sqlerr_ref.
    ENDTRY.

  ENDLOOP.

  COMMIT WORK.

*--> DESCONECTAR.
  EXEC SQL.
    DISCONNECT 'A'
  ENDEXEC.

*--> VOLTA PARA OS ACESSOS AO BD DEFAULT DO R3.
  EXEC SQL.
    SET CONNECTION DEFAULT
  ENDEXEC.

ENDFORM.                    " F_EXPORTA_COMPENSADOS

*&---------------------------------------------------------------------*
*&      Form  F_TIT_ABERTOS_SIRIUS
*&---------------------------------------------------------------------*
FORM f_tit_abertos_sirius .

  EXEC SQL.
    CONNECT TO 'PSIRIUS2' AS 'A'
  ENDEXEC.

  IF sy-subrc NE 0.
    MESSAGE 'Sem conexão com o BD Sírius2.' TYPE 'E'.
  ENDIF.

  TRY.
      EXEC SQL PERFORMING f_grava_result_select.
        SELECT ITEM, CLIENTE, DOCUMENTO
          INTO :gs_tit_abertos-BUZEI, :gs_tit_abertos-KUNNR, :gs_tit_abertos-BELNR
          FROM TITULO
        WHERE DATACOMPENSACAO IS NULL
      ENDEXEC.
    CATCH cx_sy_native_sql_error INTO gv_exc_ref.
      EXEC SQL.
        ROLLBACK CONNECTION 'A'
        SET CONNECTION DEFAULT
        DISCONNECT 'A'
      ENDEXEC.
      gv_error_text = gv_exc_ref->get_text( ).
      MESSAGE e000(zsd_ordem_sirius) WITH gv_error_text.
  ENDTRY.

  EXEC SQL.
    COMMIT CONNECTION 'A'
    DISCONNECT 'A'
  ENDEXEC.

ENDFORM.                    " F_TIT_ABERTOS_SIRIUS

*&---------------------------------------------------------------------*
*&      Form  F_GRAVA_RESULT_SELECT
*&---------------------------------------------------------------------*
*       Grava registro do select
*----------------------------------------------------------------------*
FORM f_grava_result_select.

  UNPACK gs_tit_abertos-kunnr TO gs_tit_abertos-kunnr.
  UNPACK gs_tit_abertos-buzei TO gs_tit_abertos-buzei.
  APPEND gs_tit_abertos TO gt_tit_abertos.
  CLEAR gs_tit_abertos.

ENDFORM.

*&      Form  F_HANDLE_SQL_EXCEPTION
*&---------------------------------------------------------------------*
*       Exibe erros SQL...
*&---------------------------------------------------------------------*
FORM f_handle_sql_exception USING us_sqlerr_ref TYPE REF TO cx_sql_exception.

  FORMAT COLOR COL_NEGATIVE.
  IF us_sqlerr_ref->db_error = 'X'.
    WRITE: / 'SQL error occured:', us_sqlerr_ref->sql_code,
           / us_sqlerr_ref->sql_message.                    "#EC NOTEXT
  ELSE.
    WRITE:
      / 'Error from DBI (details in dev-trace):',
        us_sqlerr_ref->internal_error.                      "#EC NOTEXT
  ENDIF.
  MESSAGE e000(zsd_ordem_sirius) WITH 'ERRO'.

ENDFORM.                    "F_HANDLE_SQL_EXCEPTION
