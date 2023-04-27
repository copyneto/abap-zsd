***********************************************************************
***                     © 3corações                                 ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Criar contrato de distrato                             *
*** AUTOR    : Carlos Adriano - META                                  *
*** FUNCIONAL: Jana Toledo de Castilhos - META                        *
*** DATA     : 10.09.2021                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** 12.10.2022 | Jong Silva | Ajuste nos filtros de seleção, para     *
*** processamento em massa                                            *
***********************************************************************
*** 24.10.2022 | Alysson Anjos | Atualização do Nro de Série          *
***********************************************************************
REPORT zsdr_autom_contrato_distrato MESSAGE-ID zsd_auto_cont_dis.

TABLES: vbak, vbap.

DATA: gt_t_log_handle TYPE  bal_t_logh.

CONSTANTS: gc_msg_error TYPE sy-msgty  VALUE 'E',
           gc_prog_name TYPE btcprog   VALUE 'ZSDR_AUTOM_CONTRATO_DISTRATO',
           gc_job_exec  TYPE btcstatus VALUE 'R'.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS: s_erdat FOR vbak-erdat,
                  s_werks FOR vbap-werks,
                  s_auart FOR vbak-auart,
                  s_vbeln FOR vbak-vbeln.
SELECTION-SCREEN END OF BLOCK b01.

*-------------------------------------------------------------------*
*                       START-OF-SELECTION                          *
*-------------------------------------------------------------------*
START-OF-SELECTION.
  PERFORM f_main.

*-------------------------------------------------------------------*
* FORM F_MAIN                                                       *
*-------------------------------------------------------------------*
FORM f_main.

  DATA: ls_erdat LIKE LINE OF s_erdat.

  DATA: lv_nw_salesdoc TYPE vbeln_va,
        lv_lines       TYPE i.

  CONSTANTS: lc_sign   TYPE char1 VALUE 'I',
             lc_option_eq TYPE char2 VALUE 'EQ',
             lc_option_bt TYPE char2 VALUE 'BT'.

  " Verifica se existe JOB processando
  PERFORM f_vrfc_job_execucao.

  IF s_erdat IS INITIAL.
    DATA: lv_dat_calc TYPE sy-datum.
              .

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date            = sy-datum
        days            = '3'
        months          = '00'
        years           = '00'
        signum          = '-'
     IMPORTING
       calc_date        = lv_dat_calc.


    ls_erdat-sign   = lc_sign.
    ls_erdat-option = lc_option_bt.
    ls_erdat-low    = lv_dat_calc.
    ls_erdat-high   = sy-datum.
    APPEND ls_erdat TO s_erdat.
    CLEAR ls_erdat.
  ENDIF.

  SELECT DISTINCT vbak~erdat,
                  vbap~werks,
*                  vbkd~ihrez,
*                  vbkd~bsark,
                  vbak~auart,
                  vbak~vbeln,
                  vbak~vtweg
    FROM vbak
   INNER JOIN vbap ON vbap~vbeln = vbak~vbeln
*   INNER JOIN vbkd ON vbkd~vbeln = vbak~vbeln AND vbkd~posnr = vbap~posnr
   WHERE vbak~erdat IN @s_erdat
     AND vbap~werks IN @s_werks
     AND vbak~auart IN @s_auart
     AND vbak~vbeln IN @s_vbeln
     AND vbak~bsark <> 'CARG'
*     AND vbkd~vbeln IN @s_vbeln
    INTO TABLE @DATA(lt_vbak).

  IF sy-subrc NE 0.
    " Nenhum registro encontrado para os parâmetros informados.
    MESSAGE s012 DISPLAY LIKE gc_msg_error.
    RETURN.
  ENDIF.

  DATA(lt_vbak_fae) = lt_vbak[].

  SORT lt_vbak_fae BY vbeln.
  DELETE ADJACENT DUPLICATES FROM lt_vbak_fae COMPARING vbeln.

  IF lt_vbak_fae[] IS NOT INITIAL.

    SELECT a~vbeln,
           a~posnr,
           a~matnr,
           a~pstyv,
           b~auart,
           b~kunnr
      FROM vbap AS a
     INNER JOIN vbak AS b ON b~vbeln = a~vbeln
       FOR ALL ENTRIES IN @lt_vbak_fae
     WHERE a~vbeln = @lt_vbak_fae-vbeln
      INTO TABLE @DATA(lt_itens).

    IF sy-subrc IS INITIAL.
      SORT lt_itens BY vbeln
                       posnr.

      DATA(lt_itens_fae) = lt_itens[].
      SORT lt_itens_fae BY vbeln
                           posnr.
      DELETE ADJACENT DUPLICATES FROM lt_itens_fae COMPARING vbeln
                                                             posnr.

      SELECT sdaufnr,
             posnr,
             sernr
        FROM ser02 AS a
       INNER JOIN objk AS b ON b~obknr = a~obknr
         FOR ALL ENTRIES IN @lt_itens
       WHERE sdaufnr = @lt_itens-vbeln
         AND posnr   = @lt_itens-posnr
        INTO TABLE @DATA(lt_objk).

      IF sy-subrc IS INITIAL.
        SORT lt_objk BY sdaufnr
                        posnr.
      ENDIF.

    ENDIF.
  ENDIF.

  DATA(lo_contrato) = NEW zclsd_autom_contrato_distrato( ).

  LOOP AT lt_vbak REFERENCE INTO DATA(ls_vbak).

    CLEAR: lv_nw_salesdoc,
           lv_lines.

    DATA(ls_log_handle) = lo_contrato->executar( EXPORTING iv_erdat        = ls_vbak->erdat
                                                           iv_werks        = ls_vbak->werks
                                                           iv_auart        = ls_vbak->auart
                                                           iv_vbeln        = ls_vbak->vbeln
                                                           iv_vtweg        = ls_vbak->vtweg
                                                 IMPORTING ev_new_salesdoc = lv_nw_salesdoc ).

    IF sy-batch = abap_false.
      APPEND ls_log_handle TO gt_t_log_handle.
      CLEAR ls_log_handle.
    ENDIF.

    IF lv_nw_salesdoc IS NOT INITIAL.

      WAIT UP TO 1 SECONDS.

      READ TABLE lt_itens TRANSPORTING NO FIELDS
                                        WITH KEY vbeln = ls_vbak->vbeln
                                        BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        LOOP AT lt_itens ASSIGNING FIELD-SYMBOL(<fs_itens>) FROM sy-tabix.
          IF <fs_itens>-vbeln NE ls_vbak->vbeln.
            EXIT.
          ENDIF.

          READ TABLE lt_objk ASSIGNING FIELD-SYMBOL(<fs_objk>)
                                           WITH KEY sdaufnr = <fs_itens>-vbeln
                                                    posnr   = <fs_itens>-posnr
                                                    BINARY SEARCH.

          IF sy-subrc IS INITIAL.
            lo_contrato->sernr_update( is_key = VALUE #( document   = lv_nw_salesdoc
                                                         itm_number = <fs_itens>-posnr
                                                         sernr      = <fs_objk>-sernr
                                                         matnr      = <fs_itens>-matnr
                                                         partn_numb = <fs_itens>-kunnr
                                                         auart      = <fs_itens>-auart
                                                         pstyv      = <fs_itens>-pstyv
                                                       ) ).

            ADD 1 TO lv_lines.

          ENDIF.
        ENDLOOP.

        lo_contrato->call_shdb_sernr( EXPORTING iv_vbeln = lv_nw_salesdoc
                                                iv_lines = lv_lines ).

      ENDIF.
    ENDIF.
  ENDLOOP.

  IF sy-batch = abap_false
 AND gt_t_log_handle[] IS NOT INITIAL.

    CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'
      EXPORTING
        i_t_log_handle       = gt_t_log_handle
      EXCEPTIONS
        profile_inconsistent = 1
        internal_error       = 2
        no_data_available    = 3
        no_authority         = 4
        OTHERS               = 5.

    IF sy-subrc <> 0.
      MESSAGE e001.
    ENDIF.
  ENDIF.

ENDFORM.
*-------------------------------------------------------------------*
* FORM F_VRFC_JOB_EXECUCAO                                          *
*-------------------------------------------------------------------*
FORM f_vrfc_job_execucao.

  IF sy-batch EQ abap_true.

    SELECT a~jobname,
           a~jobcount
      FROM tbtcp AS a
     INNER JOIN tbtco AS b ON b~jobname  = a~jobname
                          AND b~jobcount = a~jobcount
    WHERE a~progname EQ @gc_prog_name
      AND b~status   EQ @gc_job_exec
      AND a~variant  EQ @sy-slset
     INTO TABLE @DATA(lt_jobcount).

    IF lines( lt_jobcount ) GT 1.
      MESSAGE s013 DISPLAY LIKE gc_msg_error.
      LEAVE PROGRAM.
    ENDIF.

  ENDIF.

ENDFORM.
