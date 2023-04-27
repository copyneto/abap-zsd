*&---------------------------------------------------------------------*
*& Report ZSDR_CARGA_CONTRATO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsdr_carga_contrato.

* ======================================================================
* Tables
* ======================================================================

TABLES: vbak.

* ======================================================================
* Global variables
* ======================================================================

DATA: go_contrato TYPE REF TO zclsd_carga_contratos.

* ======================================================================
* Tela de seleção
* ======================================================================

SELECTION-SCREEN BEGIN OF BLOCK bl1 WITH FRAME TITLE TEXT-bl1.
  PARAMETERS: p_up   RADIOBUTTON GROUP ope DEFAULT 'X' USER-COMMAND ope MODIF ID ope,
              p_down RADIOBUTTON GROUP ope.
SELECTION-SCREEN END OF BLOCK bl1.

SELECTION-SCREEN BEGIN OF BLOCK bl2 WITH FRAME TITLE TEXT-bl2.
  PARAMETERS: p_file  TYPE ze_trm_filename MODIF ID arq,
              p_locl  RADIOBUTTON GROUP arq MODIF ID arq DEFAULT 'X' USER-COMMAND arq,
              p_serv  RADIOBUTTON GROUP arq MODIF ID arq.
SELECTION-SCREEN END OF BLOCK bl2.

SELECTION-SCREEN BEGIN OF BLOCK bl3 WITH FRAME TITLE TEXT-bl3.
  SELECT-OPTIONS: s_vbeln FOR vbak-vbeln MODIF ID sel.
SELECTION-SCREEN END OF BLOCK bl3.

* ======================================================================
* Events
* ======================================================================

AT SELECTION-SCREEN OUTPUT.
  PERFORM f_manage_screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  PERFORM f_search_file_f4 USING    p_locl
                                    p_serv
                           CHANGING p_file.

* ======================================================================
* Start program
* ======================================================================

INITIALIZATION.
  CREATE OBJECT go_contrato.

START-OF-SELECTION.
  PERFORM f_start.

* ======================================================================
* Form: F_START
* ======================================================================
* Start program
* ----------------------------------------------------------------------

FORM f_start.

  CASE abap_true.

    WHEN p_down.
      go_contrato->download_contract( EXPORTING iv_locl     = p_locl
                                                iv_serv     = p_serv
                                                iv_filename = p_file
                                                ir_vbeln    = s_vbeln[]
                                      IMPORTING et_return   = DATA(lt_return) ).

      go_contrato->show_log( EXPORTING it_return = lt_return ).

    WHEN p_up.
      go_contrato->upload_contract( EXPORTING iv_locl     = p_locl
                                              iv_serv     = p_serv
                                              iv_filename = p_file
                                    IMPORTING et_return   = lt_return ).

      go_contrato->show_log( EXPORTING it_return = lt_return ).

  ENDCASE.

ENDFORM.

* ======================================================================
* Form: F_SEARCH_FILE_F4
* ======================================================================
* Search and choose file
* ----------------------------------------------------------------------

FORM f_search_file_f4 USING    uv_locl TYPE flag
                               uv_serv TYPE flag
                      CHANGING cv_file TYPE any.

  CASE abap_true.

    WHEN p_down.
      go_contrato->search_directory_f4( EXPORTING iv_locl     = uv_locl
                                                  iv_serv     = uv_serv
                                        IMPORTING ev_filename = cv_file
                                                  et_return   = DATA(lt_return) ).

    WHEN p_up.
      go_contrato->search_file_f4( EXPORTING iv_locl     = uv_locl
                                             iv_serv     = uv_serv
                                   IMPORTING ev_filename = cv_file
                                             et_return   = lt_return ).

  ENDCASE.

  go_contrato->show_log( EXPORTING it_return = lt_return ).

ENDFORM.

* ======================================================================
* Form F_MANAGE_SCREEN
* ======================================================================
* Manage screen
* ----------------------------------------------------------------------

FORM f_manage_screen.

  LOOP AT SCREEN.
    CASE screen-group1.

      WHEN 'SEL'.
        screen-invisible = COND #( WHEN p_down IS NOT INITIAL
                                   THEN 0
                                   ELSE 1 ).
        screen-active    = COND #( WHEN p_down IS NOT INITIAL
                                   THEN 1
                                   ELSE 0 ).
        MODIFY SCREEN.

    ENDCASE.
  ENDLOOP.

ENDFORM.
