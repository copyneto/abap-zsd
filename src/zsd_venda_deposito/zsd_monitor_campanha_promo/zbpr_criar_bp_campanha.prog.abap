*&---------------------------------------------------------------------*
***                      © 3corações                                 ***
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*** DESCRIÇÃO: Criar/Alterar BP IONZ                                   *
*** AUTOR    : Emilio Matheus – [META]                                 *
*** FUNCIONAL: Vanderleison Pinheiro –[META]                           *
*** DATA     : 14.02.2023                                              *
*&---------------------------------------------------------------------*
*** HISTÓRICO DAS MODIFICAÇÕES                                         *
*&---------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                               *
*&---------------------------------------------------------------------*
***           |              |                                         *
*&---------------------------------------------------------------------*
REPORT zbpr_criar_bp_campanha.

TABLES: ztsd_sint_proces.

*----------------------------------------------------------------------*
* TELA DE SELEÇÃO
*----------------------------------------------------------------------*
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
    SELECT-OPTIONS: s_id FOR ztsd_sint_proces-id,
                    s_pr FOR ztsd_sint_proces-promocao.
  SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  SELECT id, promocao FROM ztsd_sint_proces
  WHERE id        IN @s_id
    AND promocao  IN @s_pr
    AND status_bp EQ 1
     OR status_bp EQ 3
  INTO TABLE @DATA(lt_sint_proces).

  IF lt_sint_proces IS NOT INITIAL.

    LOOP AT lt_sint_proces ASSIGNING FIELD-SYMBOL(<fs_sint>).

      DATA(lt_return) = NEW zclbp_criar_bp_app( )->executar( iv_id       = <fs_sint>-id
                                                             iv_promocao = <fs_sint>-promocao ).

      IF lt_return IS NOT INITIAL.

        CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
          EXPORTING
            is_log  = VALUE bal_s_log(
                        aluser    = sy-uname
                        alprog    = sy-repid
                        object    = 'ZBP_JOB_IONZ'
                        subobject = 'IONZ_BP'
                        extnumber = sy-timlo )
            it_msgs = lt_return.


        REFRESH: lt_return.

      ENDIF.

    ENDLOOP.

  ELSE.

    CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
      EXPORTING
        is_log = VALUE bal_s_log(
                   aluser    = sy-uname
                   alprog    = sy-repid
                   object    = 'ZBP_JOB_IONZ'
                   subobject = 'IONZ_BP'
                   extnumber = sy-timlo )
        is_msg = VALUE bapiret2( type       = 'W'
                                 id         = 'ZBP_IF_IONZ'
                                 number     = 000
                                 message_v1 = TEXT-002 ).

  ENDIF.

  IF sy-batch EQ abap_false.
    MESSAGE TEXT-003 TYPE 'W'.
  ENDIF.
