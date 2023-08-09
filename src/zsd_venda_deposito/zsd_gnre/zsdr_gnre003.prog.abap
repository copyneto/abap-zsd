***********************************************************************
***                         © 3corações                             ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: GNRE: Job para a geração dos documentos                *
*** AUTOR : Lyon Freitas – Meta                                       *
*** FUNCIONAL: Sandro – Meta                                          *
*** DATA : 08/04/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR          | DESCRIÇÃO                            *
***-------------------------------------------------------------------*
*** 08/04/22  | LFREITAS       | Cópia ECC to S4                      *
***********************************************************************
REPORT zsdr_gnre003 MESSAGE-ID zsd_gnre.

* Tipos Internos
*-----------------------------------------------------------------------
TYPES: BEGIN OF ty_s_gnret001,
         docnum  TYPE ztsd_gnret001-docnum,
         docguia TYPE ztsd_gnret001-docguia,
         chadat  TYPE ztsd_gnret001-chadat,
       END OF ty_s_gnret001.

* Variáveis
*-----------------------------------------------------------------------
DATA: gv_docnum_error            TYPE ztsd_gnret001-docnum,
      gv_eventid                 TYPE tbtcm-eventid,
      gv_eventparm               TYPE tbtcm-eventparm,
      gv_external_program_active TYPE tbtcm-xpgactive,
      gv_jobcount                TYPE tbtcm-jobcount,
      gv_jobname                 TYPE tbtcm-jobname,
      gv_stepcount               TYPE tbtcm-stepcount.

* Tabelas Internas e Work Area
*-----------------------------------------------------------------------
DATA: ls_ztsd_gnret001 TYPE ty_s_gnret001,
      ls_gnret011      TYPE ztsd_gnret011,
      gt_ztsd_gnret001 TYPE TABLE OF ty_s_gnret001,
      gt_gnret011_ins  TYPE TABLE OF ztsd_gnret011,
      gt_gnret011_del  TYPE TABLE OF ztsd_gnret011.

* Parâmetros de seleção
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01. "Critérios de seleção
  SELECT-OPTIONS: s_docnum FOR ls_ztsd_gnret001-docnum,     "Nº documento
                  s_dcguia FOR ls_ztsd_gnret001-docguia,    "Nº interno de Guia
                  s_chadat FOR ls_ztsd_gnret001-chadat.     "Modificado em
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

  IF sy-batch IS INITIAL.
    "Só é possível a execução em background.
    MESSAGE s033 DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  "Obtêm os dados do Job
  CALL FUNCTION 'GET_JOB_RUNTIME_INFO'
    IMPORTING
      eventid                 = gv_eventid
      eventparm               = gv_eventparm
      external_program_active = gv_external_program_active
      jobcount                = gv_jobcount
      jobname                 = gv_jobname
      stepcount               = gv_stepcount
    EXCEPTIONS
      no_runtime_info         = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  "Verifica se possui outro Job em execução
  SELECT COUNT(*)
    FROM tbtco
    WHERE jobname  =  gv_jobname
      AND jobcount <> gv_jobcount
      AND status   =  'R'.
  IF sy-subrc IS INITIAL.

    "Já existe um Job em execução.
    MESSAGE s034 DISPLAY LIKE 'E'.
    RETURN.

  ENDIF.

  "Obtêm os registros a serem processados
  SELECT docnum
         docguia
         chadat
    FROM ztsd_gnret001
    INTO TABLE gt_ztsd_gnret001
    WHERE docnum  IN s_docnum
      AND docguia IN s_dcguia
      AND chadat  IN s_chadat
      AND step    IN ( zclsd_gnre_automacao=>gc_step-guia_criada,              "Guia Criada - Aguardando Criação do Doc. FI
                       zclsd_gnre_automacao=>gc_step-documento_criado,         "Doc. FI Criado - Aguardando Preenchimento do Código de Barras
                       zclsd_gnre_automacao=>gc_step-cod_barras_preenchido ).  "Código de Barras preenchido - Aguardando Envio ao VAN FINNET

  IF sy-subrc IS NOT INITIAL.
    "Nenhum registro encontrado.
    MESSAGE s001 DISPLAY LIKE 'E'.
  ENDIF.

  SELECT docnum, acao FROM ztsd_gnret011
    WHERE acao   = @zclsd_gnre_automacao=>gc_acao_at-job
      AND credat = @sy-datum
      AND cretim = @sy-uzeit
      AND crenam = @sy-uname
    INTO TABLE @DATA(lt_gnret011).

  SORT gt_ztsd_gnret001 BY docnum.
  SORT lt_gnret011 BY docnum.

  CLEAR: gt_gnret011_ins[], gt_gnret011_del[].

  LOOP AT gt_ztsd_gnret001 ASSIGNING FIELD-SYMBOL(<fs_gnret001>).

    TRY.
        AT NEW docnum.

          FREE: gv_docnum_error.

          GET TIME.

          ls_gnret011 = VALUE #( docnum = <fs_gnret001>-docnum
                                  acao   = zclsd_gnre_automacao=>gc_acao_at-job
                                  credat = sy-datum
                                  cretim = sy-uzeit
                                  crenam = sy-uname ).

          READ TABLE lt_gnret011 TRANSPORTING NO FIELDS
            WITH KEY docnum = <fs_gnret001>-docnum BINARY SEARCH.

          IF sy-subrc <> 0.
            APPEND ls_gnret011 TO gt_gnret011_ins.
          ELSE.

            "-- Nota & já está em processamento.
            MESSAGE s037 INTO DATA(gv_msg) WITH <fs_gnret001>-docnum.

            WRITE: / gv_msg.
            gv_docnum_error = <fs_gnret001>-docnum.
            CONTINUE.
          ENDIF.

          "-- Iniciando o processamento da Nota &.
          MESSAGE s038 INTO gv_msg WITH <fs_gnret001>-docnum.

          WRITE: / gv_msg.

          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao( iv_docnum          = <fs_gnret001>-docnum
                                                            iv_ignore_job_lock = abap_true               ).

        ENDAT.

        IF gv_docnum_error IS INITIAL.

          "--- Iniciando o processamento da Guia &.
          MESSAGE s039 INTO gv_msg WITH <fs_gnret001>-docguia.

          WRITE: / gv_msg.

          DATA(gv_continue) = lr_gnre_automacao->process( VALUE #( ( sign   = 'I'
                                                                     option = 'EQ'
                                                                     low    = <fs_gnret001>-docguia ) ) ).
          lr_gnre_automacao->persist( ).
          COMMIT WORK AND WAIT.

          IF gv_continue EQ abap_true.

            DO 60 TIMES.
              gv_continue = lr_gnre_automacao->process( VALUE #( ( sign   = 'I'
                                                                   option = 'EQ'
                                                                   low    = <fs_gnret001>-docguia ) ) ).
              lr_gnre_automacao->persist( ).
              COMMIT WORK AND WAIT.

              IF gv_continue <> abap_true.
                EXIT.
              ENDIF.

              WAIT UP TO 1 SECONDS.
            ENDDO.

          ENDIF.

        ENDIF.

        AT END OF docnum.

          IF gv_docnum_error IS INITIAL.

            APPEND ls_gnret011 TO gt_gnret011_del.


            "-- Nota & processada, verificar logs.
            MESSAGE s040 INTO gv_msg WITH <fs_gnret001>-docnum.
            WRITE: / gv_msg.

            lr_gnre_automacao->persist( ).
            lr_gnre_automacao->free( ).

            COMMIT WORK AND WAIT.

          ELSE.

            FREE: gv_docnum_error.

          ENDIF.

        ENDAT.

      CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).

        APPEND ls_gnret011 TO gt_gnret011_del.

        "-- Erro ao processar a Nota &.
        MESSAGE s041 INTO gv_msg WITH <fs_gnret001>-docnum.
        WRITE: / gv_msg.

        lr_cx_gnre_automacao->display( iv_using_write = abap_true ).

        gv_docnum_error = <fs_gnret001>-docnum.

    ENDTRY.

  ENDLOOP.

  " INSERT - LSCHEPP - 07.08.2023
  SORT gt_gnret011_ins BY docnum acao.
  DELETE ADJACENT DUPLICATES FROM gt_gnret011_ins COMPARING docnum acao.
  DELETE gt_gnret011_ins WHERE docnum IS INITIAL.
  IF gt_gnret011_ins[] IS NOT INITIAL.
    SELECT *
      FROM ztsd_gnret011
      INTO TABLE @DATA(lt_gnret011_check)
      FOR ALL ENTRIES IN @gt_gnret011_ins
      WHERE docnum EQ @gt_gnret011_ins-docnum
        AND acao   EQ @gt_gnret011_ins-acao.
    IF sy-subrc EQ 0.
      SORT lt_gnret011_check BY docnum acao.
      LOOP AT gt_gnret011_ins ASSIGNING FIELD-SYMBOL(<fs_gnret011_ins>).
        DATA(lv_tabix) = sy-tabix.
        READ TABLE lt_gnret011_check TRANSPORTING NO FIELDS WITH KEY docnum = <fs_gnret011_ins>-docnum
                                                                     acao   = <fs_gnret011_ins>-acao BINARY SEARCH.
        IF sy-subrc EQ 0.
          DELETE gt_gnret011_ins INDEX lv_tabix.
        ENDIF.
      ENDLOOP.
    ENDIF.
    " INSERT - LSCHEPP - 07.08.2023

    IF gt_gnret011_ins[] IS NOT INITIAL.
      INSERT ztsd_gnret011 FROM TABLE gt_gnret011_ins.
      COMMIT WORK AND WAIT.
    ENDIF.
  ENDIF.

  IF gt_gnret011_del[] IS NOT INITIAL.
    DELETE ztsd_gnret011 FROM TABLE gt_gnret011_del.
    COMMIT WORK AND WAIT.
  ENDIF.
