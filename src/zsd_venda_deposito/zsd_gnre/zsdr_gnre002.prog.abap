***********************************************************************
***                      © 3 Corações                               ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: ZSDR_GNRE002                                           *
*** AUTOR    : Enio Jesus - Meta                                      *
*** FUNCIONAL:                                                        *
*** DATA     : 08/04/2022                                             *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA      | AUTOR        | DESCRIÇÃO                              *
***-------------------------------------------------------------------*
*** 08/04/22  | EJESUS       | Versão Inicial (Cópia ECC to S/4)      *
***********************************************************************

REPORT zsdr_gnre002.

TYPES:
  BEGIN OF ty_sel_screen,
    docnum  TYPE ztsd_gnret001-docnum,
    docguia TYPE ztsd_gnret001-docguia,
    chadat  TYPE ztsd_gnret001-chadat,
  END OF ty_sel_screen.

DATA gs_sel_screen      TYPE ty_sel_screen.
DATA gt_return_messages TYPE bapiret2_tab.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  SELECT-OPTIONS:
      s_docnum FOR gs_sel_screen-docnum,  "Nº documento
      s_dcguia FOR gs_sel_screen-docguia, "Nº interno de Guia
      s_chadat FOR gs_sel_screen-chadat.  "Data de Modificação
SELECTION-SCREEN END OF BLOCK b1.

CLASS lcl_process_gnre DEFINITION.
  PUBLIC SECTION.
    TYPES:
      ty_t_docguia TYPE TABLE OF ztsd_gnret001-docguia WITH EMPTY KEY,

      BEGIN OF ty_guias_processar,
        docnum     TYPE ztsd_gnret001-docnum,
        docguia    TYPE ztsd_gnret001-docguia,
        executando TYPE abap_bool,
      END OF ty_guias_processar,

      ty_r_docnum          TYPE RANGE OF ztsd_gnret001-docnum,
      ty_r_dcguia          TYPE RANGE OF ztsd_gnret001-docguia,
      ty_r_chadat          TYPE RANGE OF ztsd_gnret001-chadat,
      ty_t_guias_processar TYPE TABLE OF ty_guias_processar WITH DEFAULT KEY,
      ty_t_gnret011        TYPE TABLE OF ztsd_gnret011 WITH DEFAULT KEY.

    METHODS startup.

    METHODS set_local_log
      IMPORTING
        iv_text TYPE any
        iv_atr1 TYPE any OPTIONAL
        iv_atr2 TYPE any OPTIONAL.

  PRIVATE SECTION.
    METHODS get_notas_canceladas
      IMPORTING
        ir_docnum           TYPE ty_r_docnum
      RETURNING
        VALUE(rt_gnre_data) TYPE ty_t_gnret011
      EXCEPTIONS
        data_not_found.

    METHODS get_notas_processar
      IMPORTING
        ir_docnum           TYPE ty_r_docnum
        ir_docguia          TYPE ty_r_dcguia
        ir_chadat           TYPE ty_r_chadat
      RETURNING
        VALUE(rt_gnre_data) TYPE ty_t_guias_processar
      EXCEPTIONS
        data_not_found.

    METHODS processar_guias.

    DATA lt_gnret011        TYPE TABLE OF ty_sel_screen.
    DATA lt_return_messages TYPE bapiret2_tab.
ENDCLASS.

CLASS lcl_process_gnre IMPLEMENTATION.
  METHOD startup.
    me->processar_guias( ).
  ENDMETHOD.

  METHOD get_notas_canceladas.
    SELECT docnum
      FROM ztsd_gnret011
      INTO CORRESPONDING FIELDS OF TABLE rt_gnre_data
     WHERE docnum IN s_docnum
       AND acao   EQ  zclsd_gnre_automacao=>gc_acao_at-cancelamento_nota.

    IF sy-subrc IS NOT INITIAL.
      MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
      RAISE data_not_found.
    ENDIF.
  ENDMETHOD.

  METHOD set_local_log.
    DATA(lv_text) = CONV string( iv_text ).

    REPLACE '&1' IN lv_text WITH iv_atr1.
    REPLACE '&2' IN lv_text WITH iv_atr2.

    WRITE: / lv_text.
  ENDMETHOD.

  METHOD get_notas_processar.
    DATA ls_gnre_data TYPE ty_guias_processar.

    SELECT a~docnum,
           a~docguia,
           CASE WHEN b~docnum IS NOT INITIAL THEN 'X' ELSE ' ' END AS executando
      FROM ztsd_gnret001 AS a
 LEFT JOIN ztsd_gnret011 AS b ON b~docnum = a~docnum AND b~acao = @zclsd_gnre_automacao=>gc_acao_at-job
     WHERE   a~docnum  IN @s_docnum
       AND   a~docguia IN @s_dcguia
       AND ( a~chadat  IN @s_chadat
        OR   a~chadat  IS NULL
        OR   a~chadat  EQ '00000000' )
       AND   a~step    IN ( @zclsd_gnre_automacao=>gc_step-aguardando_preenchimento_dados,
                            @zclsd_gnre_automacao=>gc_step-aguardando_envio,
                            @zclsd_gnre_automacao=>gc_step-guia_solicitada,
                            @zclsd_gnre_automacao=>gc_step-documento_enviado,
                            @zclsd_gnre_automacao=>gc_step-pagamento_enviado,
                            @zclsd_gnre_automacao=>gc_step-impossivel_ident_fornecedor_cr,
                            @zclsd_gnre_automacao=>gc_step-erro_ao_gerar_o_documento_fi,
                            @zclsd_gnre_automacao=>gc_step-erro_ao_incluir_codigo_barras,
                            @zclsd_gnre_automacao=>gc_step-erro_ao_gerar_ciclo_pagamento,
                            @zclsd_gnre_automacao=>gc_step-pagamento_rejeitado
                          )
      INTO TABLE @rt_gnre_data.

    IF sy-subrc IS NOT INITIAL.
      MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
      RAISE data_not_found.
    ENDIF.

    SORT rt_gnre_data BY docnum.
  ENDMETHOD.

  METHOD processar_guias.
    CALL METHOD me->get_notas_canceladas
      EXPORTING
        ir_docnum      = s_docnum[]
      RECEIVING
        rt_gnre_data   = DATA(lt_notas_canceladas)
      EXCEPTIONS
        data_not_found = 1
        OTHERS         = 2.

    LOOP AT lt_notas_canceladas ASSIGNING FIELD-SYMBOL(<fs_guia_cancelada>).
      me->set_local_log( iv_text = TEXT-s01 iv_atr1 = <fs_guia_cancelada>-docnum ).

      TRY.
          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao( <fs_guia_cancelada>-docnum ).

          lr_gnre_automacao->set_cancel( ).
          lr_gnre_automacao->persist( ).
          lr_gnre_automacao->free( ).

          zclsd_gnre_automacao=>dequeue_docnum_cancel( <fs_guia_cancelada>-docnum ).
          COMMIT WORK.

          me->set_local_log( iv_text = TEXT-s02 iv_atr1 = <fs_guia_cancelada>-docnum ).

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          me->set_local_log( iv_text = TEXT-e02 iv_atr1 = <fs_guia_cancelada>-docnum ).
          lr_cx_gnre_automacao->display( iv_using_write = abap_true ).
      ENDTRY.

    ENDLOOP.

    CALL METHOD me->get_notas_processar
      EXPORTING
        ir_docnum      = s_docnum[]
        ir_docguia     = s_dcguia[]
        ir_chadat      = s_chadat[]
      RECEIVING
        rt_gnre_data   = DATA(lt_guias_processar)
      EXCEPTIONS
        data_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    DATA(lt_gnret011) = VALUE ty_t_gnret011(
        FOR ls_guia IN lt_guias_processar (
            COND #( WHEN ls_guia-executando = abap_false
                    THEN VALUE #(
                        docnum = ls_guia-docnum
                        acao   = zclsd_gnre_automacao=>gc_acao_at-job
                        credat = sy-datum
                        cretim = sy-uzeit
                        crenam = sy-uname
                    ) ) ) ).

    SORT lt_gnret011 BY docnum acao.
    DELETE ADJACENT DUPLICATES FROM lt_gnret011 COMPARING docnum acao.
    DELETE lt_gnret011 WHERE docnum IS INITIAL.

    IF NOT lt_gnret011[] IS INITIAL.
      INSERT ztsd_gnret011 FROM TABLE lt_gnret011.
      COMMIT WORK AND WAIT.
    ENDIF.

    LOOP AT lt_guias_processar ASSIGNING FIELD-SYMBOL(<fs_guias_processar>).
      IF <fs_guias_processar>-executando = abap_true.
        me->set_local_log( iv_text = TEXT-s03 iv_atr1 = <fs_guias_processar>-docnum ).
        CONTINUE.
      ENDIF.

      TRY.
          AT NEW docnum.
            me->set_local_log( iv_text = TEXT-s04 iv_atr1 = <fs_guias_processar>-docnum ).

            lr_gnre_automacao = NEW zclsd_gnre_automacao(
              iv_docnum          = <fs_guias_processar>-docnum
              iv_ignore_job_lock = abap_true
            ).
          ENDAT.

          me->set_local_log( iv_text = TEXT-s05 iv_atr1 = <fs_guias_processar>-docguia ).

          CALL METHOD lr_gnre_automacao->process
            EXPORTING
              ir_docguia  = VALUE #( ( sign = 'I' option = 'EQ' low = <fs_guias_processar>-docguia ) )
            RECEIVING
              rv_continue = DATA(lv_continue).

          lr_gnre_automacao->persist( ).
          COMMIT WORK AND WAIT.

          WHILE ( lv_continue = abap_true ).
            lr_gnre_automacao->get_gnre_data(
              IMPORTING
                et_header   = DATA(lt_gnre_header)
            ).

            "//Não efetua o processamento do próximo Job
            READ TABLE lt_gnre_header ASSIGNING FIELD-SYMBOL(<fs_s_gnre_header>)
            WITH KEY docguia = <fs_guias_processar>-docguia BINARY SEARCH.
*              ASSIGN lt_gnre_header[ docguia = <fs_guia> ] TO FIELD-SYMBOL(<fs_s_gnre_header>).
            IF sy-subrc IS INITIAL AND ( <fs_s_gnre_header>-step = zclsd_gnre_automacao=>gc_step-guia_criada           OR
                                         <fs_s_gnre_header>-step = zclsd_gnre_automacao=>gc_step-documento_criado      OR
                                         <fs_s_gnre_header>-step = zclsd_gnre_automacao=>gc_step-cod_barras_preenchido    ).
              EXIT.
            ENDIF.

            CALL METHOD lr_gnre_automacao->process
              EXPORTING
                ir_docguia  = VALUE #( ( sign = 'I' option = 'EQ' low = <fs_guias_processar>-docguia ) )
              RECEIVING
                rv_continue = lv_continue.

            lr_gnre_automacao->persist( ).
            COMMIT WORK AND WAIT.
          ENDWHILE.

          AT END OF docnum.
            me->set_local_log( iv_text = TEXT-s06 iv_atr1 = <fs_guias_processar>-docnum ).

            lr_gnre_automacao->persist( ).
            lr_gnre_automacao->free( ).
          ENDAT.

        CATCH zcxsd_gnre_automacao INTO lr_cx_gnre_automacao.
          me->set_local_log( iv_text = TEXT-e03 iv_atr1 = <fs_guias_processar>-docnum ).
          lr_cx_gnre_automacao->display( iv_using_write = abap_true ).
      ENDTRY.
    ENDLOOP.

    DELETE ztsd_gnret011 FROM TABLE lt_gnret011.
    COMMIT WORK AND WAIT.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  NEW lcl_process_gnre(  )->startup(  ).
