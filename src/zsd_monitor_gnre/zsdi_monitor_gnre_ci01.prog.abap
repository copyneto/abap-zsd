CLASS lcl_cx_gnre_cockpit IMPLEMENTATION.

  METHOD constructor.
    CALL METHOD super->constructor
      EXPORTING
        previous = previous.
    CLEAR me->textid.
    me->textid = iv_textid-msgid.
    IF iv_textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key-msgid = textid.
      if_t100_message~t100key-msgno = iv_textid-msgno.
    ENDIF.
    me->gv_msgv1 = iv_msgv1.
    me->gv_msgv2 = iv_msgv2.
    me->gv_msgv3 = iv_msgv3.
    me->gv_msgv4 = iv_msgv4.
    me->gt_errors = it_errors.
    me->gt_bapi_return = it_bapi_return.
  ENDMETHOD.

  METHOD display.

    DATA: lt_return TYPE bapiret2_t.

    FIELD-SYMBOLS: <fs_s_return> LIKE LINE OF lt_return.

    lt_return = get_bapi_return( ).

    IF lines( lt_return ) = 1.

      READ TABLE lt_return ASSIGNING <fs_s_return> INDEX 1.

      MESSAGE ID     <fs_s_return>-id
              TYPE   'S'
              NUMBER <fs_s_return>-number
              WITH   <fs_s_return>-message_v1
                     <fs_s_return>-message_v2
                     <fs_s_return>-message_v3
                     <fs_s_return>-message_v4
              DISPLAY LIKE <fs_s_return>-type.

    ELSE.

      CALL FUNCTION 'FB_MESSAGES_DISPLAY_POPUP'
        EXPORTING
          it_return       = lt_return
        EXCEPTIONS
          no_messages     = 1
          popup_cancelled = 2
          OTHERS          = 3.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD get_bapi_return.

    FIELD-SYMBOLS: <fs_s_return>    LIKE LINE OF rt_return,
                   <fs_s_exception> LIKE LINE OF gt_errors.

    IF if_t100_message~t100key <> if_t100_message~default_textid.

      APPEND INITIAL LINE TO rt_return ASSIGNING <fs_s_return>.

      <fs_s_return>-type       = 'E'.
      <fs_s_return>-id         = if_t100_message~t100key-msgid.
      <fs_s_return>-number     = if_t100_message~t100key-msgno.
      <fs_s_return>-message_v1 = gv_msgv1.
      <fs_s_return>-message_v2 = gv_msgv2.
      <fs_s_return>-message_v3 = gv_msgv3.
      <fs_s_return>-message_v4 = gv_msgv4.

      MESSAGE ID     <fs_s_return>-id
              TYPE   <fs_s_return>-type
              NUMBER <fs_s_return>-number
              WITH   <fs_s_return>-message_v1
                     <fs_s_return>-message_v2
                     <fs_s_return>-message_v3
                     <fs_s_return>-message_v4
              INTO   <fs_s_return>-message.

    ENDIF.

    APPEND LINES OF gt_bapi_return TO rt_return.

    LOOP AT gt_errors ASSIGNING <fs_s_exception>.

      APPEND LINES OF <fs_s_exception>->get_bapi_return( ) TO rt_return.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_gnre_cockpit IMPLEMENTATION.

  METHOD create_instance.
    go_instance = NEW #( ).
    rt_instance = go_instance.
  ENDMETHOD.

  METHOD get_instance.

    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.

    rt_instance = go_instance.

  ENDMETHOD.

  METHOD check_auth_buttons_9000.

    "Reprocessar
    AUTHORITY-CHECK OBJECT 'ZGNRE_REPR'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'REPROCESS' TO rt_excluding.
    ENDIF.

    "Imprimir NFe + Guia
    AUTHORITY-CHECK OBJECT 'ZGNRE_IMPR'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'IMPRIMIR' TO rt_excluding.
    ENDIF.

    "Pagamento Manual
    AUTHORITY-CHECK OBJECT 'ZGNRE_PGTO'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'PGTOMANUAL' TO rt_excluding.
    ENDIF.

    "Incluir Guia Manual
    AUTHORITY-CHECK OBJECT 'ZGNRE_INGM'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'INCGUIAMAN' TO rt_excluding.
    ENDIF.

    "Criar Guia Complementar
    AUTHORITY-CHECK OBJECT 'ZGNRE_CRGC'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'GUIACOMPL' TO rt_excluding.
    ENDIF.

    "Inutilizar Guia
    AUTHORITY-CHECK OBJECT 'ZGNRE_INUT'
                        ID 'ACTVT' FIELD '16'.
    IF sy-subrc <> 0.
      APPEND 'INUTILIZAR' TO rt_excluding.
    ENDIF.

  ENDMETHOD.

  METHOD main.

    TRY.
        select_data( ).

        process_data( ).

        call_screen( ).

      CATCH lcl_cx_gnre_cockpit INTO DATA(lo_cx_gnre_cockpit).
        lo_cx_gnre_cockpit->display( ).

    ENDTRY.

  ENDMETHOD.

  METHOD add_guia_compl.

    FREE: gt_outtab_guia_compl.

    DO 10 TIMES.
      APPEND INITIAL LINE TO gt_outtab_guia_compl.
    ENDDO.

    CALL SCREEN 9003 STARTING AT 3   1
                     ENDING   AT 100 15.

  ENDMETHOD.

  METHOD select_data.

    DATA: lr_consumo TYPE RANGE OF ztsd_gnret001-consumo.

    IF s_credat[] IS INITIAL AND s_nfcdat[] IS INITIAL.
      "Favor informar ao menos uma das datas.
      RAISE EXCEPTION TYPE lcl_cx_gnre_cockpit
        EXPORTING
          iv_textid = zcxsd_gnre_automacao=>gc_inform_a_date.
    ENDIF.

    lr_consumo = COND #( WHEN p_cfinal = abap_true THEN
                           VALUE #( ( sign   = 'I'
                                      option = 'EQ'
                                      low    = 'X'  ) )
                         WHEN p_contri = abap_true THEN
                           VALUE #( ( sign   = 'I'
                                      option = 'EQ'
                                      low    = ''   ) )
                         ELSE
                           VALUE #( ) ).
    IF p_guia IS NOT INITIAL.
      DATA(lv_guia) = abap_true.
    ELSE.
      lv_guia = abap_false.
    ENDIF.

    SELECT ztsd_gnret001~docnum
           ztsd_gnret001~docguia
           ztsd_gnret001~tpguia
           ztsd_gnret001~step
           ztsd_gnret001~tpprocess
           ztsd_gnret001~consumo
           ztsd_gnret001~zsub
           ztsd_gnret001~guiacompl
           ztsd_gnret001~credat
           ztsd_gnret001~cretim
           ztsd_gnret001~crenam
           ztsd_gnret001~chadat
           ztsd_gnret001~chatim
           ztsd_gnret001~chanam
           ztsd_gnret001~bukrs
           ztsd_gnret001~branch
           ztsd_gnret001~lifnr
           ztsd_gnret001~num_guia
           ztsd_gnret001~prot_guia
           ztsd_gnret001~bukrs_doc
           ztsd_gnret001~branch_doc
           ztsd_gnret001~belnr
           ztsd_gnret001~gjahr
           ztsd_gnret001~augbl
           ztsd_gnret001~auggj
           ztsd_gnret001~dtpgto
           ztsd_gnret001~faedt
           ztsd_gnret001~brcde_guia
           ztsd_gnret001~ldig_guia
           ztsd_gnret001~codaut_guia
           ztsd_gnret001~vlrtot
           ztsd_gnret001~vlrpago
           ztsd_gnret001~laufd
           ztsd_gnret001~laufi
           j_1bnfdoc~docdat
           j_1bnfdoc~crenam
           j_1bnfdoc~credat
           j_1bnfdoc~cretim
           j_1bnfdoc~series
           j_1bnfdoc~nfenum
           j_1bnfdoc~regio
           j_1bnfdoc~parvw
           j_1bnfdoc~parid
           j_1bnfdoc~parxcpdk
           j_1bnfdoc~name1
           j_1bnfe_active~code
      FROM ztsd_gnret001
      INNER JOIN j_1bnfdoc
        ON ( j_1bnfdoc~docnum = ztsd_gnret001~docnum )
      INNER JOIN j_1bnfe_active
        ON ( j_1bnfe_active~docnum = ztsd_gnret001~docnum )
      INTO TABLE gt_result_select1
      WHERE ztsd_gnret001~docnum   IN s_docnum
        AND ztsd_gnret001~step     IN s_step
        AND ztsd_gnret001~consumo  IN lr_consumo
        AND ztsd_gnret001~credat   IN s_credat
        AND ztsd_gnret001~bukrs    IN s_bukrs
        AND ztsd_gnret001~branch   IN s_branc
        AND ztsd_gnret001~num_guia IN s_nguia
        AND ztsd_gnret001~dtpgto   IN s_dtpgto
        AND ztsd_gnret001~guia_manual EQ lv_guia
        AND j_1bnfdoc~credat   IN s_nfcdat
        AND j_1bnfdoc~series   IN s_serie
        AND j_1bnfdoc~nfenum   IN s_nfenum
        AND j_1bnfdoc~regio    IN s_regio
        AND EXISTS ( SELECT docnum
                       FROM j_1bnflin
                       WHERE docnum =  j_1bnfdoc~docnum
                         AND refkey IN s_refke          ).

    IF sy-subrc IS NOT INITIAL.

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE lcl_cx_gnre_cockpit
        EXPORTING
          iv_textid = lcl_cx_gnre_cockpit=>gc_data_not_found.
    ENDIF.

    DATA(lt_res_select1_aux) = gt_result_select1.
    DELETE lt_res_select1_aux WHERE parxcpdk <> abap_true.
    IF lt_res_select1_aux IS NOT INITIAL.

      SORT lt_res_select1_aux BY docnum parvw parxcpdk.
      DELETE ADJACENT DUPLICATES FROM lt_res_select1_aux COMPARING docnum parvw parxcpdk.

      "Obtêm os dados da conta ocasional
      SELECT docnum
             parvw
             regio
             name1
        FROM j_1bnfcpd
        INTO TABLE gt_j_1bnfcpd
        FOR ALL ENTRIES IN lt_res_select1_aux
        WHERE docnum = lt_res_select1_aux-docnum
          AND parvw  = lt_res_select1_aux-parvw.
    ENDIF.

    IF gt_result_select1 IS NOT INITIAL.
      SORT gt_result_select1 BY docnum docguia.

      SELECT *
        FROM ztsd_gnret003
        INTO TABLE gt_ztsd_gnret003
        FOR ALL ENTRIES IN gt_result_select1
        WHERE docnum  = gt_result_select1-docnum
          AND docguia = gt_result_select1-docguia.


      SORT gt_ztsd_gnret003 BY docnum docguia counter DESCENDING.

      SELECT ztsd_gnret002~docnum
             ztsd_gnret002~docguia
             ztsd_gnret002~itemguia
             ztsd_gnret002~taxtyp
             ztsd_gnret002~hkont
             ztsd_gnret002~taxval
             j_1baj~subdivision
        FROM ztsd_gnret002
        INNER JOIN j_1baj
          ON ( j_1baj~taxtyp = ztsd_gnret002~taxtyp )
        INTO TABLE gt_result_select2
        FOR ALL ENTRIES IN gt_result_select1
        WHERE ztsd_gnret002~docnum  =  gt_result_select1-docnum
          AND ztsd_gnret002~docguia =  gt_result_select1-docguia
          AND j_1baj~taxgrp     IN ( 'ICMS', 'ICST' ).

    ENDIF.


    DATA(lt_result_select1_aux) = gt_result_select1.
    SORT lt_result_select1_aux BY docnum.

    IF lt_result_select1_aux IS NOT INITIAL.
      DELETE ADJACENT DUPLICATES FROM lt_result_select1_aux COMPARING docnum.

      SELECT DISTINCT
             j_1bnflin~docnum
           , j_1bnflin~refkey
           , vbrk~fkart
           , vbfa_dt~vbeln
        FROM j_1bnflin
        LEFT JOIN vbrk
          ON ( vbrk~vbeln = j_1bnflin~refkey )
        LEFT JOIN vbfa AS vbfa_rem                "Obtêm a Remessa
          ON ( vbfa_rem~vbeln   = vbrk~vbeln
          AND  vbfa_rem~vbtyp_n = 'M'
          AND  vbfa_rem~vbtyp_v = 'J'      )
        LEFT JOIN vbfa AS vbfa_dt                 "Obtêm o Documento de transporte
          ON ( vbfa_dt~vbelv   = vbfa_rem~vbelv
          AND  vbfa_dt~vbtyp_n = '8'
          AND  vbfa_dt~vbtyp_v = 'J'      )
        INTO TABLE @gt_result_select3
        FOR ALL ENTRIES IN @lt_result_select1_aux
        WHERE docnum = @lt_result_select1_aux-docnum.

      IF s_fkart[] IS NOT INITIAL.

        "Caso o filtro esteja preenchido, remove os registros das demais tabelas
        LOOP AT gt_result_select3 ASSIGNING FIELD-SYMBOL(<fs_s_result_select3>) WHERE fkart NOT IN s_fkart.
          DATA(lv_tabix) = sy-tabix.
          DELETE gt_result_select1 WHERE docnum = <fs_s_result_select3>-docnum.
          DELETE gt_result_select2 WHERE docnum = <fs_s_result_select3>-docnum.
          DELETE gt_result_select3 INDEX lv_tabix.
        ENDLOOP.

      ENDIF.
    ENDIF.

    IF gt_result_select1 IS NOT INITIAL.

      lt_result_select1_aux = gt_result_select1.
      SORT lt_result_select1_aux BY docnum.
      DELETE ADJACENT DUPLICATES FROM lt_result_select1_aux COMPARING docnum.

      SELECT DISTINCT
             j_1bnflin~docnum
           , j_1bnflin~refkey
           , vbak~vbeln
           , vbak~auart
        FROM j_1bnflin
        LEFT JOIN vbfa AS vbfa_ov                "Obtêm a Ordem de Venda
          ON ( vbfa_ov~vbeln   = j_1bnflin~refkey
          AND  vbfa_ov~vbtyp_n = 'M'              )
        LEFT JOIN vbak                           "Obtêm os Dados da Ordem de Venda
          ON ( vbak~vbeln = vbfa_ov~vbelv )
        INTO TABLE @gt_result_select4
        FOR ALL ENTRIES IN @lt_result_select1_aux
        WHERE j_1bnflin~docnum = @lt_result_select1_aux-docnum
          AND vbfa_ov~vbtyp_v  IN ( 'C', 'I' ).

      IF s_auart[] IS NOT INITIAL.

        "Caso o filtro esteja preenchido, remove os registros das demais tabelas
        LOOP AT gt_result_select4 ASSIGNING FIELD-SYMBOL(<fs_s_result_select4>) WHERE auart NOT IN s_auart.
          lv_tabix = sy-tabix.
          DELETE gt_result_select1 WHERE docnum = <fs_s_result_select4>-docnum.
          DELETE gt_result_select2 WHERE docnum = <fs_s_result_select4>-docnum.
          DELETE gt_result_select4 INDEX lv_tabix.
        ENDLOOP.

      ENDIF.

    ENDIF.

    IF gt_result_select1 IS INITIAL.

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE lcl_cx_gnre_cockpit
        EXPORTING
          iv_textid = lcl_cx_gnre_cockpit=>gc_data_not_found.
    ENDIF.

* GFX - JECA - V-3COR34 - [911614]Pagamento de Guia com rejeição E21 - 14/06/2021
    SELECT *
      FROM ztsd_gnret009
      INTO TABLE gt_gnret009
      WHERE bukrs  IN s_bukrs
        AND branch IN s_branc.

    IF sy-subrc IS INITIAL.
      SORT gt_gnret009 BY bukrs
                          branch
                          shipto
                          taxtyp.
    ENDIF.

  ENDMETHOD.

  METHOD process_data.

    DATA: ls_parnad TYPE j_1binnad.

    FREE: gt_outtab_bottom.

    DATA(lt_result_select2) = gt_result_select2[].

    SORT lt_result_select2 BY docnum docguia.

    "Percorre os registros encontrados nas tabelas ZTSD_GNRET001, J_1BNFDOC e J_1BNFE_ACTIVE
    LOOP AT gt_result_select1 ASSIGNING FIELD-SYMBOL(<fs_s_result_select1>).

      APPEND INITIAL LINE TO gt_outtab_top ASSIGNING FIELD-SYMBOL(<fs_s_outtab_top>).

      MOVE-CORRESPONDING <fs_s_result_select1> TO <fs_s_outtab_top>.

      <fs_s_outtab_top>-status = zclsd_gnre_automacao=>get_icon_from_step( <fs_s_result_select1>-step ).

      "Obtêm os dados da conta ocasional
      IF <fs_s_result_select1>-parxcpdk = abap_true.
        ASSIGN gt_j_1bnfcpd[ docnum = <fs_s_result_select1>-docnum
                             parvw  = <fs_s_result_select1>-parvw  ] TO FIELD-SYMBOL(<fs_s_j_1bnfcpd>).
        IF sy-subrc IS INITIAL.
          <fs_s_outtab_top>-shipto = <fs_s_j_1bnfcpd>-regio.
          MOVE-CORRESPONDING <fs_s_j_1bnfcpd> TO <fs_s_outtab_top>.
        ENDIF.
      ELSE.
        <fs_s_outtab_top>-shipto = <fs_s_result_select1>-regio.
      ENDIF.

      "Obtêm a descrição da etapa
      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname  = 'ZD_GNRE_STEP'
          i_domvalue = CONV domvalue_l( <fs_s_result_select1>-step )
        IMPORTING
          e_ddtext   = <fs_s_outtab_top>-desc_step
        EXCEPTIONS
          not_exist  = 1
          OTHERS     = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      "Obtêm a descrição do tipo de guia
      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname  = 'ZD_GNRE_TPGUIA'
          i_domvalue = CONV domvalue_l( <fs_s_result_select1>-tpguia )
        IMPORTING
          e_ddtext   = <fs_s_outtab_top>-desc_tpguia
        EXCEPTIONS
          not_exist  = 1
          OTHERS     = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      "Obtêm os dados da filial
      CALL FUNCTION 'J_1B_NF_PARTNER_READ'
        EXPORTING
          partner_type           = 'B'
          partner_id             = CONV j_1bparid( |{ <fs_s_result_select1>-bukrs }{ <fs_s_result_select1>-branch }| )
        IMPORTING
          parnad                 = ls_parnad
        EXCEPTIONS
          partner_not_found      = 1
          partner_type_not_found = 2
          OTHERS                 = 3.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.


      IF sy-subrc IS INITIAL.
        <fs_s_outtab_top>-shipfrom = ls_parnad-regio.
      ENDIF.

      "Move os dados encontrados nas tabelas J_1BNFLIN e VBRK
      ASSIGN gt_result_select3[ docnum = <fs_s_result_select1>-docnum ] TO FIELD-SYMBOL(<fs_s_result_select3>).
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING <fs_s_result_select3> TO <fs_s_outtab_top>.
      ENDIF.

      "Move os dados encontrados nas tabelas J_1BNFLIN e VBAK
      ASSIGN gt_result_select4[ docnum = <fs_s_result_select1>-docnum ] TO FIELD-SYMBOL(<fs_s_result_select4>).
      IF sy-subrc IS INITIAL.
        MOVE-CORRESPONDING <fs_s_result_select4> TO <fs_s_outtab_top>.
      ENDIF.

      "Preenche o registro com a última mensagem do log
      ASSIGN gt_ztsd_gnret003[ docnum  = <fs_s_result_select1>-docnum
                           docguia = <fs_s_result_select1>-docguia ] TO FIELD-SYMBOL(<fs_s_ztsd_gnret003>).
      IF sy-subrc IS INITIAL.
        <fs_s_outtab_top>-status_guia  = <fs_s_ztsd_gnret003>-status_guia.
        <fs_s_outtab_top>-desc_st_guia = <fs_s_ztsd_gnret003>-desc_st_guia.
      ENDIF.



      READ TABLE lt_result_select2 TRANSPORTING NO FIELDS WITH KEY docnum  = <fs_s_result_select1>-docnum
                                                                   docguia = <fs_s_result_select1>-docguia BINARY SEARCH.
      IF sy-subrc IS INITIAL.
        "Percorre os registros encontrados na tabela ZTSD_GNRET002
        LOOP AT lt_result_select2 ASSIGNING FIELD-SYMBOL(<fs_s_result_select2>) FROM sy-tabix.
          IF <fs_s_result_select2>-docnum  <> <fs_s_result_select1>-docnum OR
             <fs_s_result_select2>-docguia <> <fs_s_result_select1>-docguia.
            EXIT.
          ENDIF.

          "Verifica se o imposto é FCP ou ICMS
          IF <fs_s_result_select2>-subdivision = '003' OR
             <fs_s_result_select2>-subdivision = '004'.

            "FCP
            <fs_s_outtab_top>-taxtyp_fcp = <fs_s_result_select2>-taxtyp.
            <fs_s_outtab_top>-hkont_fcp  = <fs_s_result_select2>-hkont.
            <fs_s_outtab_top>-taxval_fcp = <fs_s_outtab_top>-taxval_fcp + <fs_s_result_select2>-taxval.

          ELSE.

            "ICMS
            <fs_s_outtab_top>-taxtyp_icms = <fs_s_result_select2>-taxtyp.
            <fs_s_outtab_top>-hkont_icms  = <fs_s_result_select2>-hkont.
            <fs_s_outtab_top>-taxval_icms = <fs_s_outtab_top>-taxval_icms + <fs_s_result_select2>-taxval.

          ENDIF.

          READ TABLE gt_gnret009 INTO DATA(ls_gnret009) WITH KEY bukrs = <fs_s_result_select1>-bukrs
                                                                 branch = <fs_s_result_select1>-branch
                                                                 shipto = <fs_s_outtab_top>-shipto    "<fs_s_result_select1>-regio "GFX - JECA - V-3COR53 - 08.11.2021
                                                                 taxtyp = <fs_s_result_select2>-taxtyp
                                                                 BINARY SEARCH.


          <fs_s_outtab_top>-hbkid =  ls_gnret009-hbkid.
          CLEAR ls_gnret009.

        ENDLOOP.
      ENDIF.

    ENDLOOP.

    "Remove os registros de acordo com o tipo de documento
    DELETE gt_outtab_top WHERE fkart NOT IN s_fkart.
    DELETE gt_outtab_top WHERE auart NOT IN s_auart.

    FREE: gt_result_select1, gt_result_select2, gt_result_select3.

    IF gt_outtab_top IS INITIAL.

      "Nenhum registro encontrado.
      RAISE EXCEPTION TYPE lcl_cx_gnre_cockpit
        EXPORTING
          iv_textid = lcl_cx_gnre_cockpit=>gc_data_not_found.
    ENDIF.

  ENDMETHOD.

  METHOD call_screen.

    CALL SCREEN 9000.

  ENDMETHOD.

  METHOD set_data_9000.

    init_objects( ).

    display_alv( ).

  ENDMETHOD.

  METHOD user_command_9000.

    CASE iv_ucomm.

      WHEN 'BACK' OR 'CANC'.
        go_alv_grid_top->free( ).
        go_alv_grid_bottom->free( ).
        go_splitter_container->free( ).
        go_main_container->free( ).
        FREE: go_alv_grid_top, go_alv_grid_bottom, go_splitter_container, go_main_container.
        LEAVE TO SCREEN 0.

      WHEN 'EXIT'.
        LEAVE PROGRAM.

      WHEN 'ATUALIZAR'.  "Atualizar
        refresh( ).

      WHEN 'REPROCESS'.  "Reprocessar
        reprocess( ).
        refresh( ).

      WHEN 'IMPRIMIR'.   "Imprimir NFe + GNRE
        print( ).
        refresh( ).

      WHEN 'PGTOMANUAL'. "Pagamento Manual
        show_popup_manual_payment( ).
        refresh( ).

      WHEN 'INCGUIAMAN'. "Incluir Guia Manual
        show_popup_manual_guide( ).
        refresh( ).

      WHEN 'INUTILIZAR'.  "Inutilizar Guia
        disable_guia( ).
        refresh( ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD set_data_9001.

    init_objects_9001( ).

    display_alv_9001(  ).

  ENDMETHOD.

  METHOD user_command_9001.

    CASE iv_ucomm.

      WHEN 'BACK' OR 'CANC'.
        free_control_manual_payment( ).
        go_alv_grid_manual_payment->free( ).
        go_manual_payment_container->free( ).
        FREE: go_alv_grid_manual_payment, go_manual_payment_container.

        LEAVE TO SCREEN 0.

      WHEN 'NEXT'.
        CALL METHOD go_alv_grid_manual_payment->check_changed_data( ).
        manual_payment( ).

      WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.

  METHOD set_data_9002.

    init_objects_9002( ).

    display_alv_9002(  ).

  ENDMETHOD.

  METHOD user_command_9002.
    CASE iv_ucomm.

      WHEN 'BACK' OR 'CANC'.
        free_control_manual_guide( ).
        go_alv_grid_manual_guide->free( ).
        go_manual_guide_container->free( ).
        FREE: go_alv_grid_manual_guide, go_manual_guide_container.

        LEAVE TO SCREEN 0.

      WHEN 'NEXT'.
        CALL METHOD go_alv_grid_manual_guide->check_changed_data( ).
        manual_guide( ).

      WHEN OTHERS.

    ENDCASE.
  ENDMETHOD.

  METHOD set_data_9003.

    init_objects_9003( ).

    display_alv_9003( ).

  ENDMETHOD.

  METHOD user_command_9003.

    CASE iv_ucomm.

      WHEN 'CANC'.

        go_alv_grid_guia_compl->free( ).
        go_container_guia_compl->free( ).
        FREE: go_alv_grid_guia_compl, go_container_guia_compl.

        LEAVE TO SCREEN 0.

      WHEN 'NEXT'.

        go_alv_grid_guia_compl->check_changed_data( IMPORTING e_valid = DATA(lv_valid) ).
        CHECK lv_valid IS NOT INITIAL.

        TRY.
            process_guia_compl( ).

            "Guia(s) criada(s) com sucesso.
            MESSAGE s023.

            go_alv_grid_guia_compl->free( ).
            go_container_guia_compl->free( ).
            FREE: go_alv_grid_guia_compl, go_container_guia_compl.

            LEAVE TO SCREEN 0.

          CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
            lr_cx_gnre_automacao->display( ).
            go_alv_grid_guia_compl->refresh_table_display( ).

        ENDTRY.

    ENDCASE.

  ENDMETHOD.

  METHOD init_objects.

    "Container principal, que ocupa toda a tela
    IF go_main_container IS NOT BOUND.

      go_main_container = NEW #( container_name = 'MAIN_CONTAINER' ).

    ENDIF.

    "Container auxiliar que realiza a divisão do container principal
    IF go_splitter_container IS NOT BOUND.

      go_splitter_container = NEW #( parent  = go_main_container
                                     rows    = 2
                                     columns = 1                 ).

      go_container_top = go_splitter_container->get_container( row    = 1
                                                               column = 1 ).

      go_container_bottom = go_splitter_container->get_container( row    = 2
                                                                  column = 1 ).

      go_splitter_container->set_row_height( id     = 2
                                             height = 35 ).

    ENDIF.

    "Inicializa o objeto do ALV com seus respectivos containers
    IF go_alv_grid_top IS NOT BOUND.

      go_alv_grid_top = NEW #( i_parent = go_container_top ).

      gv_alv_top_displayed = abap_false.

    ENDIF.

    IF go_alv_grid_bottom IS NOT BOUND.

      go_alv_grid_bottom = NEW #( i_parent = go_container_bottom ).

      gv_alv_bottom_displayed = abap_false.

    ENDIF.

  ENDMETHOD.

  METHOD display_alv.

    IF gv_alv_top_displayed = abap_false.

      display_alv_top( ).

    ENDIF.

    IF gv_alv_bottom_displayed = abap_false.

      display_alv_bottom( ).

    ENDIF.

  ENDMETHOD.

  METHOD display_alv_top.

    DATA: ls_layout   TYPE lvc_s_layo,
          ls_variant  TYPE disvariant,
          lt_fieldcat TYPE lvc_t_fcat.

    ls_variant-report   = sy-repid.
    ls_variant-username = sy-uname.
    ls_variant-handle   = 'ALVT'.

    ls_layout-cwidth_opt = abap_true.
    ls_layout-zebra      = abap_true.
    ls_layout-sel_mode   = 'A'.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE001'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    change_fieldcat_top( CHANGING ct_fieldcat = lt_fieldcat ).

    SET HANDLER handle_hotspot_click_alv_top FOR go_alv_grid_top.

    go_alv_grid_top->set_table_for_first_display(
      EXPORTING
        is_variant      = ls_variant
        i_save          = 'A'
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_top
        it_fieldcatalog = lt_fieldcat
    ).

    gv_alv_top_displayed = abap_true.

  ENDMETHOD.

  METHOD display_alv_bottom.

    DATA: ls_layout   TYPE lvc_s_layo,
          ls_variant  TYPE disvariant,
          lt_fieldcat TYPE lvc_t_fcat.

    ls_variant-report   = sy-repid.
    ls_variant-username = sy-uname.
    ls_variant-handle   = 'ALVB'.

    ls_layout-cwidth_opt = abap_true.
    ls_layout-zebra      = abap_true.
    ls_layout-sel_mode   = 'A'.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE002'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    go_alv_grid_bottom->set_table_for_first_display(
      EXPORTING
        is_variant      = ls_variant
        i_save          = 'A'
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_bottom
        it_fieldcatalog = lt_fieldcat
    ).

    gv_alv_bottom_displayed = abap_true.

  ENDMETHOD.

  METHOD generate_fieldcat.

    DATA: lv_o_table TYPE REF TO data,
          lv_o_salv  TYPE REF TO cl_salv_table.

    FIELD-SYMBOLS: <fs_table> TYPE ANY TABLE.

    CREATE DATA lv_o_table LIKE it_table.
    ASSIGN lv_o_table->* TO <fs_table>.

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = lv_o_salv
                                CHANGING  t_table      = <fs_table> ).

        rt_fcat = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
            r_columns      = lv_o_salv->get_columns( )      " ALV Filter
            r_aggregations = lv_o_salv->get_aggregations( ) " ALV Aggregations
        ).
      CATCH cx_salv_msg.
        RETURN.
    ENDTRY.

    CALL FUNCTION 'LVC_FIELDCAT_COMPLETE'
      CHANGING
        ct_fieldcat = rt_fcat.

    DELETE rt_fcat WHERE fieldname = 'MANDT'.

  ENDMETHOD.

  METHOD change_fieldcat_top.

    LOOP AT ct_fieldcat ASSIGNING FIELD-SYMBOL(<fs_s_fieldcat>).

      CASE <fs_s_fieldcat>-fieldname.

        WHEN 'STATUS'.

          <fs_s_fieldcat>-icon = abap_true.
          <fs_s_fieldcat>-just = 'C'.

        WHEN 'DOCGUIA' OR 'DOCNUM' OR 'REFKEY' OR 'VBELN' OR 'TKNUM' OR 'BELNR' OR 'AUGBL'.

          <fs_s_fieldcat>-hotspot   = abap_true.
          <fs_s_fieldcat>-emphasize = abap_true.

        WHEN OTHERS.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.

  METHOD handle_hotspot_click_alv_top.

    ASSIGN gt_outtab_top[ e_row_id ] TO FIELD-SYMBOL(<fs_s_outtab>).
    CHECK sy-subrc IS INITIAL.

    CASE e_column_id.

      WHEN 'DOCGUIA'.
        display_log_for_docguia( <fs_s_outtab> ).

      WHEN 'DOCNUM'.

        CHECK <fs_s_outtab>-docnum IS NOT INITIAL.

        SET PARAMETER ID 'JEF' FIELD <fs_s_outtab>-docnum.
        CALL TRANSACTION 'J1B3N' AND SKIP FIRST SCREEN.

      WHEN 'REFKEY'.

        CHECK <fs_s_outtab>-refkey IS NOT INITIAL.

        SELECT COUNT(*)
          FROM vbrk
          WHERE vbeln = <fs_s_outtab>-refkey(10).
        CHECK sy-subrc IS INITIAL.

        SET PARAMETER ID 'VF'   FIELD <fs_s_outtab>-refkey.
        CALL TRANSACTION 'VF03' AND SKIP FIRST SCREEN.

      WHEN 'VBELN'.

        CHECK <fs_s_outtab>-vbeln IS NOT INITIAL.

        SET PARAMETER ID 'AUN'  FIELD <fs_s_outtab>-vbeln.
        CALL TRANSACTION 'VA03' AND SKIP FIRST SCREEN.

      WHEN 'TKNUM'.

        CHECK <fs_s_outtab>-tknum IS NOT INITIAL.

        SET PARAMETER ID 'TNR'   FIELD <fs_s_outtab>-tknum.
        CALL TRANSACTION 'VT03N' AND SKIP FIRST SCREEN.

      WHEN 'BELNR'.

        CHECK <fs_s_outtab>-belnr IS NOT INITIAL.

        SET PARAMETER ID 'BLN' FIELD <fs_s_outtab>-belnr.
        SET PARAMETER ID 'BUK' FIELD <fs_s_outtab>-bukrs_doc.
        SET PARAMETER ID 'GJR' FIELD <fs_s_outtab>-gjahr.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

      WHEN 'AUGBL'.

        CHECK <fs_s_outtab>-augbl IS NOT INITIAL.

        SET PARAMETER ID 'BLN' FIELD <fs_s_outtab>-augbl.
        SET PARAMETER ID 'BUK' FIELD <fs_s_outtab>-bukrs_doc.
        SET PARAMETER ID 'GJR' FIELD <fs_s_outtab>-auggj.
        CALL TRANSACTION 'FB03' AND SKIP FIRST SCREEN.

    ENDCASE.

  ENDMETHOD.

  METHOD display_log_for_docguia.

    FREE: gt_outtab_bottom.

    LOOP AT gt_ztsd_gnret003 ASSIGNING FIELD-SYMBOL(<fs_s_ztsd_gnret003>) WHERE docnum  = is_outtab_top-docnum
                                                                    AND docguia = is_outtab_top-docguia.

      APPEND CORRESPONDING #( <fs_s_ztsd_gnret003> ) TO gt_outtab_bottom ASSIGNING FIELD-SYMBOL(<fs_s_outtab_bottom>).

      "Obtêm a descrição do tipo de guia
      CALL FUNCTION 'DOMAIN_VALUE_GET'
        EXPORTING
          i_domname  = 'ZD_GNRE_STEP'
          i_domvalue = CONV domvalue_l( <fs_s_ztsd_gnret003>-step )
        IMPORTING
          e_ddtext   = <fs_s_outtab_bottom>-desc_step
        EXCEPTIONS
          not_exist  = 1
          OTHERS     = 2.

      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

    ENDLOOP.

    go_alv_grid_bottom->refresh_table_display( ).

  ENDMETHOD.

  METHOD refresh.

    FREE: gt_outtab_top, gt_outtab_bottom.

    TRY.
        select_data( ).
        process_data( ).
      CATCH lcl_cx_gnre_cockpit INTO DATA(lo_cx_gnre_cockpit).
        lo_cx_gnre_cockpit->display( ).
    ENDTRY.

    go_alv_grid_top->refresh_table_display( is_stable = VALUE #( row = 'X' col = 'X' ) ).
    go_alv_grid_bottom->refresh_table_display( is_stable = VALUE #( row = 'X' col = 'X' ) ).

  ENDMETHOD.

  METHOD reprocess.

    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors,
          lv_answer TYPE c.

    go_alv_grid_top->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(lt_index_rows)
    ).

    DELETE lt_index_rows WHERE rowtype IS NOT INITIAL.

    IF lt_index_rows IS INITIAL.
      "Nenhuma linha válida, foi selecionada.
      MESSAGE s007 DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    "Deseja reprocessar o(s) documento(s) selecionado(s)?
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = TEXT-002
        display_cancel_button = ''
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_answer <> '1'.
      RETURN.
    ENDIF.

    DATA(lt_outtab_top) = VALUE ty_t_outtab_top( FOR <fs_s_index_row> IN lt_index_rows
                                                   LET ls_outtab_top = gt_outtab_top[ <fs_s_index_row>-index ] IN
                                                     ( ls_outtab_top ) ).

    SORT lt_outtab_top BY docnum.
    DATA(lt_outtab_top_aux) = lt_outtab_top.
    DELETE ADJACENT DUPLICATES FROM lt_outtab_top_aux COMPARING docnum.

    LOOP AT lt_outtab_top_aux ASSIGNING FIELD-SYMBOL(<fs_s_outtab_aux>).

      TRY.
          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao(
            iv_docnum    = <fs_s_outtab_aux>-docnum
            iv_tpprocess = zclsd_gnre_automacao=>gc_tpprocess-manual ).

          lr_gnre_automacao->reprocess(
            ir_docguia = VALUE #( FOR <fs_s_outtab> IN lt_outtab_top WHERE ( docnum = <fs_s_outtab_aux>-docnum )
                                    ( sign   = 'I'
                                      option = 'EQ'
                                      low    = <fs_s_outtab>-docguia ) )
          ).

          lr_gnre_automacao->persist( ).
          lr_gnre_automacao->free( ).

          FREE: lr_gnre_automacao.

          COMMIT WORK AND WAIT.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).  " .

          IF lr_gnre_automacao IS BOUND.
            lr_gnre_automacao->free( ).
          ENDIF.

          APPEND lr_cx_gnre_automacao TO lt_errors.

      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

  ENDMETHOD.

  METHOD show_popup_manual_guide.
    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors.

    FREE: gt_outtab_manual_guide.

    go_alv_grid_top->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(lt_index_rows)
    ).

    DELETE lt_index_rows WHERE rowtype IS NOT INITIAL.

    IF lt_index_rows IS INITIAL.
      "Nenhuma linha válida, foi selecionada.
      MESSAGE s007 DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    DATA(lt_outtab_top) = VALUE ty_t_outtab_top( FOR <fs_s_index_row> IN lt_index_rows
                                                   LET ls_outtab_top = gt_outtab_top[ <fs_s_index_row>-index ] IN
                                                     ( ls_outtab_top ) ).

    SORT lt_outtab_top BY docnum.

    DATA(lt_outtab_manual_guide_aux) = CORRESPONDING ty_t_outtab_manual_guide( lt_outtab_top ).
    SORT lt_outtab_manual_guide_aux BY docnum.
    DELETE ADJACENT DUPLICATES FROM lt_outtab_manual_guide_aux COMPARING docnum.
    LOOP AT lt_outtab_manual_guide_aux ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_guide>).
      TRY.

          READ TABLE lt_outtab_top TRANSPORTING NO FIELDS WITH KEY docnum = <fs_s_outtab_manual_guide>-docnum BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_outtab_top ASSIGNING FIELD-SYMBOL(<fs_s_outtab_top>) FROM sy-tabix.
              IF <fs_s_outtab_top>-docnum <> <fs_s_outtab_manual_guide>-docnum.
                EXIT.
              ENDIF.
              DATA(lt_steps) = zclsd_gnre_automacao=>get_steps_guia_manual( ).

              IF NOT line_exists( lt_steps[ table_line = <fs_s_outtab_top>-step ] ).
                "A etapa & não permite a inclusão de guia manual.
                RAISE EXCEPTION TYPE zcxsd_gnre_automacao
                  EXPORTING
                    iv_textid = zcxsd_gnre_automacao=>gc_step_not_allow_for_guia_man
                    iv_msgv1  = CONV msgv1( <fs_s_outtab_top>-step ).
              ENDIF.
              <fs_s_outtab_manual_guide>-docguia   = <fs_s_outtab_top>-docguia.
              <fs_s_outtab_manual_guide>-automacao = NEW zclsd_gnre_automacao(
                iv_docnum    = <fs_s_outtab_manual_guide>-docnum
                iv_tpprocess = zclsd_gnre_automacao=>gc_tpprocess-manual ).
              APPEND <fs_s_outtab_manual_guide> TO gt_outtab_manual_guide.
            ENDLOOP.
          ENDIF.


        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

    CHECK gt_outtab_manual_guide IS NOT INITIAL.
    call_screen_manual_guide( ).
  ENDMETHOD.

  METHOD show_popup_manual_payment.
    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors.

    FREE: gt_outtab_manual_payment.

    go_alv_grid_top->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(lt_index_rows)
    ).

    DELETE lt_index_rows WHERE rowtype IS NOT INITIAL.

    IF lt_index_rows IS INITIAL.
      "Nenhuma linha válida, foi selecionada.
      MESSAGE s007 DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    DATA(lt_outtab_top) = VALUE ty_t_outtab_top( FOR <fs_s_index_row> IN lt_index_rows
                                                   LET ls_outtab_top = gt_outtab_top[ <fs_s_index_row>-index ] IN
                                                     ( ls_outtab_top ) ).

    SORT lt_outtab_top BY docnum.

    DATA(lt_outtab_manual_payment_aux) = CORRESPONDING ty_t_outtab_manual_payment( lt_outtab_top ).
    SORT lt_outtab_manual_payment_aux BY docnum.
    DELETE ADJACENT DUPLICATES FROM lt_outtab_manual_payment_aux COMPARING docnum.
    LOOP AT lt_outtab_manual_payment_aux ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_payment>).
      TRY.
          READ TABLE lt_outtab_top TRANSPORTING NO FIELDS WITH KEY docnum = <fs_s_outtab_manual_payment>-docnum BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            LOOP AT lt_outtab_top ASSIGNING FIELD-SYMBOL(<fs_s_outtab_top>) FROM sy-tabix.
              IF  <fs_s_outtab_top>-docnum <> <fs_s_outtab_manual_payment>-docnum.
                EXIT.
              ENDIF.
              DATA(lt_steps) = zclsd_gnre_automacao=>get_steps_manual_payment( ).

              IF NOT line_exists( lt_steps[ table_line = <fs_s_outtab_top>-step ] ).
                "A etapa & não permite a inclusão de guia manual.
                RAISE EXCEPTION TYPE zcxsd_gnre_automacao
                  EXPORTING
                    iv_textid = zcxsd_gnre_automacao=>gc_step_not_allow_for_man_pay
                    iv_msgv1  = CONV msgv1( <fs_s_outtab_top>-step ).
              ENDIF.
              <fs_s_outtab_manual_payment>-docguia   = <fs_s_outtab_top>-docguia.
              <fs_s_outtab_manual_payment>-automacao = NEW zclsd_gnre_automacao(
                iv_docnum    = <fs_s_outtab_manual_payment>-docnum
                iv_tpprocess = zclsd_gnre_automacao=>gc_tpprocess-manual ).
              APPEND <fs_s_outtab_manual_payment> TO gt_outtab_manual_payment.
            ENDLOOP.
          ENDIF.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

    CHECK gt_outtab_manual_payment IS NOT INITIAL.
    call_screen_manual_payment( ).
  ENDMETHOD.

  METHOD free_control_manual_guide.

    LOOP AT gt_outtab_manual_guide ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_guide>).
      <fs_s_outtab_manual_guide>-automacao->free( ).
      COMMIT WORK AND WAIT.
    ENDLOOP.
    FREE gt_outtab_manual_guide.

  ENDMETHOD.

  METHOD free_control_manual_payment.

    LOOP AT gt_outtab_manual_payment ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_payment>).
      <fs_s_outtab_manual_payment>-automacao->free( ).
      COMMIT WORK AND WAIT.
    ENDLOOP.
    FREE gt_outtab_manual_payment.

  ENDMETHOD.

  METHOD manual_guide.
    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors.

    LOOP AT gt_outtab_manual_guide ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_guide>).
      TRY.
          IF  <fs_s_outtab_manual_guide>-num_guia IS NOT INITIAL
          AND <fs_s_outtab_manual_guide>-ldig_guia IS NOT INITIAL.
            <fs_s_outtab_manual_guide>-automacao->add_guia_manual(
              EXPORTING
                iv_docguia   = <fs_s_outtab_manual_guide>-docguia
                iv_faedt     = <fs_s_outtab_manual_guide>-faedt
                iv_num_guia  = <fs_s_outtab_manual_guide>-num_guia
                iv_ldig_guia = <fs_s_outtab_manual_guide>-ldig_guia
            ).
            <fs_s_outtab_manual_guide>-automacao->persist( ).
          ENDIF.
        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).  " .
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.
    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ELSE.
      free_control_manual_guide( ).
      SET SCREEN 0.
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

  ENDMETHOD.

  METHOD manual_payment.
    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors.

    LOOP AT gt_outtab_manual_payment ASSIGNING FIELD-SYMBOL(<fs_s_outtab_manual_payment>).
      TRY.
          IF  <fs_s_outtab_manual_payment>-codaut IS NOT INITIAL
          AND ( <fs_s_outtab_manual_payment>-dtpgto IS NOT INITIAL
          OR    <fs_s_outtab_manual_payment>-vlrpago IS NOT INITIAL ).
            <fs_s_outtab_manual_payment>-automacao->add_manual_payment(
              EXPORTING
                iv_docguia = <fs_s_outtab_manual_payment>-docguia
                iv_codaut  = <fs_s_outtab_manual_payment>-codaut
                iv_dtpgto  = <fs_s_outtab_manual_payment>-dtpgto
                iv_vlrpago = <fs_s_outtab_manual_payment>-vlrpago
            ).
            <fs_s_outtab_manual_payment>-automacao->persist( ).
          ENDIF.
        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).  " .
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.
    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ELSE.
      free_control_manual_payment( ).
      SET SCREEN 0.
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

  ENDMETHOD.

  METHOD print.

    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors,
          lv_answer TYPE c,
          lv_pdf    TYPE abap_bool,
          lv_path   TYPE localfile.

    go_alv_grid_top->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(lt_index_rows)
    ).

    DELETE lt_index_rows WHERE rowtype IS NOT INITIAL.

    IF lt_index_rows IS INITIAL.
      "Nenhuma linha válida, foi selecionada.
      MESSAGE s007 DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    "Deseja gerar o PDF?
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question  = TEXT-001
      IMPORTING
        answer         = lv_answer
      EXCEPTIONS
        text_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_answer = 'A'.
      RETURN.
    ELSEIF lv_answer = '1'.
      lv_pdf  = abap_true.
      lv_path = 'C:\TEMP\'.
    ELSE.
      lv_pdf  = abap_false.
      lv_path = ''.
    ENDIF.

    DATA(lt_outtab_top) = VALUE ty_t_outtab_top( FOR <fs_s_index_row> IN lt_index_rows
                                                   LET ls_outtab_top = gt_outtab_top[ <fs_s_index_row>-index ] IN
                                                     ( ls_outtab_top ) ).

    SORT lt_outtab_top BY docnum.
    DATA(lt_outtab_top_aux) = lt_outtab_top.
    DELETE ADJACENT DUPLICATES FROM lt_outtab_top_aux COMPARING docnum.

    LOOP AT lt_outtab_top_aux ASSIGNING FIELD-SYMBOL(<fs_s_outtab_aux>).

      TRY.
          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao(
            iv_docnum    = <fs_s_outtab_aux>-docnum
            iv_tpprocess = zclsd_gnre_automacao=>gc_tpprocess-manual ).

          lr_gnre_automacao->print( iv_pdf  = lv_pdf
                                    iv_path = lv_path ).

          lr_gnre_automacao->persist( ).
          lr_gnre_automacao->free( ).

          COMMIT WORK AND WAIT.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).  " .
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      "Obtêm a tabela com os erros
      DATA(lt_return) = NEW zcxsd_gnre_automacao( it_errors = lt_errors )->get_bapi_return( ).
    ENDIF.

    "Verificar logs.
    APPEND VALUE #( id     = 'ZSD_GNRE'
                    type   = 'S'
                    number = '008'   ) TO lt_return.

    NEW zcxsd_gnre_automacao( it_bapi_return = lt_return )->display( ).

  ENDMETHOD.

  METHOD call_screen_manual_payment.
    CALL SCREEN 9001 STARTING AT 5 3 ENDING AT 170 15.
  ENDMETHOD.

  METHOD call_screen_manual_guide.
    CALL SCREEN 9002 STARTING AT 5 3 ENDING AT 125 15.
  ENDMETHOD.

  METHOD init_objects_9001.
    "Container do popup de pagamento manual
    IF go_manual_payment_container IS NOT BOUND.
      go_manual_payment_container = NEW #( container_name = 'CONTAINER_9001' ).
    ENDIF.

    "Inicializa o objeto do ALV com seus respectivos containers
    IF go_alv_grid_manual_payment IS NOT BOUND.
      go_alv_grid_manual_payment = NEW #( i_parent = go_manual_payment_container ).
    ENDIF.
  ENDMETHOD.

  METHOD init_objects_9002.
    "Container do popup de pagamento manual
    IF go_manual_guide_container IS NOT BOUND.
      go_manual_guide_container = NEW #( container_name = 'CONTAINER_9002' ).
    ENDIF.

    "Inicializa o objeto do ALV com seus respectivos containers
    IF go_alv_grid_manual_guide IS NOT BOUND.
      go_alv_grid_manual_guide = NEW #( i_parent = go_manual_guide_container ).
    ENDIF.
  ENDMETHOD.

  METHOD display_alv_9001.
    DATA: ls_layout   TYPE lvc_s_layo,
          lt_fieldcat TYPE lvc_t_fcat.

    ls_layout-zebra      = abap_true.
    ls_layout-no_rowins  = abap_true.
    ls_layout-no_rowmove = abap_true.
    ls_layout-sel_mode   = 'A'.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE004'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    change_fieldcat_manual_payment( CHANGING ct_fieldcat = lt_fieldcat ).

    go_alv_grid_manual_payment->set_table_for_first_display(
      EXPORTING
        i_save          = 'A'
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_manual_payment
        it_fieldcatalog = lt_fieldcat
    ).

    go_alv_grid_manual_payment->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
  ENDMETHOD.

  METHOD display_alv_9002.
    DATA: ls_layout   TYPE lvc_s_layo,
          lt_fieldcat TYPE lvc_t_fcat.

    ls_layout-zebra      = abap_true.
    ls_layout-no_rowins  = abap_true.
    ls_layout-no_rowmove = abap_true.
    ls_layout-sel_mode   = 'A'.

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE005'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    change_fieldcat_manual_guide( CHANGING ct_fieldcat = lt_fieldcat ).

    go_alv_grid_manual_guide->set_table_for_first_display(
      EXPORTING
        i_save          = 'A'
        is_layout       = ls_layout
      CHANGING
        it_outtab       = gt_outtab_manual_guide
        it_fieldcatalog = lt_fieldcat
    ).

    go_alv_grid_manual_guide->register_edit_event( cl_gui_alv_grid=>mc_evt_modified ).
  ENDMETHOD.

  METHOD change_fieldcat_manual_guide.

    LOOP AT ct_fieldcat ASSIGNING FIELD-SYMBOL(<fs_s_fieldcat>).
      CASE <fs_s_fieldcat>-fieldname.
        WHEN 'NUM_GUIA' OR 'LDIG_GUIA' OR 'FAEDT'.
          <fs_s_fieldcat>-edit = abap_true.
        WHEN 'AUTOMACAO'.
          <fs_s_fieldcat>-no_out = abap_true.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD change_fieldcat_manual_payment.

    LOOP AT ct_fieldcat ASSIGNING FIELD-SYMBOL(<fs_s_fieldcat>).
      CASE <fs_s_fieldcat>-fieldname.
        WHEN 'CODAUT' OR 'DTPGTO' OR 'VLRPAGO'.
          <fs_s_fieldcat>-edit = abap_true.
        WHEN 'AUTOMACAO'.
          <fs_s_fieldcat>-no_out = abap_true.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD init_objects_9003.

    IF go_container_guia_compl IS NOT BOUND.
      go_container_guia_compl = NEW #( container_name = 'CONTAINER_9003' ).
    ENDIF.

    IF go_alv_grid_guia_compl IS NOT BOUND.
      go_alv_grid_guia_compl = NEW #( i_parent = go_container_guia_compl ).
    ENDIF.

  ENDMETHOD.

  METHOD display_alv_9003.

    DATA: ls_layout    TYPE lvc_s_layo,
          lt_fieldcat  TYPE lvc_t_fcat,
          lt_excluding TYPE ui_functions.

    ls_layout-zebra    = abap_true.
    ls_layout-edit     = abap_true.
    ls_layout-sel_mode = 'A'.

    lt_excluding = VALUE #( ( cl_gui_alv_grid=>mc_fc_info  )
                            ( cl_gui_alv_grid=>mc_fc_graph )
                            ( cl_gui_alv_grid=>mc_fc_print )
                            ( cl_gui_alv_grid=>mc_fc_views ) ).

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE006'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    go_alv_grid_guia_compl->set_ready_for_input( ).

    go_alv_grid_guia_compl->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).

    go_alv_grid_guia_compl->set_table_for_first_display(
      EXPORTING
        i_save               = 'A'
        is_layout            = ls_layout
        it_toolbar_excluding = lt_excluding
      CHANGING
        it_outtab            = gt_outtab_guia_compl
        it_fieldcatalog      = lt_fieldcat
    ).

  ENDMETHOD.

  METHOD process_guia_compl.

    DATA: lv_error_docnum TYPE ztsd_gnret001-docnum,
          lv_new          TYPE abap_bool,
          lv_compl        TYPE abap_bool,
          lt_errors       TYPE zcxsd_gnre_automacao=>ty_t_errors,
          lt_docnum       TYPE TABLE OF ztsd_gnret001-docnum.

    CHECK gt_outtab_guia_compl IS NOT INITIAL.

    SORT gt_outtab_guia_compl BY docnum DESCENDING.

    SELECT docnum
      FROM ztsd_gnret001
      INTO TABLE lt_docnum
      FOR ALL ENTRIES IN gt_outtab_guia_compl
      WHERE docnum = gt_outtab_guia_compl-docnum.

* Melhoria 5
*    DATA(lt_guia_compl) = gt_outtab_guia_compl[].
*    SORT lt_guia_compl BY docnum.
*    DELETE ADJACENT DUPLICATES FROM lt_guia_compl COMPARING docnum.
*
*    IF lt_guia_compl[] IS NOT INITIAL.
*
*      SELECT j_1bnfdoc~docnum,
*             j_1bnfdoc~regio,
*                 adrc~region,
*             j_1bnfstx~taxtyp,
*             j_1bnfstx~taxval,
*             j_1bnflin~nbm
*        FROM j_1bnfdoc
*    INNER JOIN j_1bnfstx
*          ON ( j_1bnfstx~docnum = j_1bnfdoc~docnum )
*    INNER JOIN j_1bnflin
*          ON ( j_1bnflin~docnum = j_1bnfdoc~docnum )
*    INNER JOIN j_1bbranch
*          ON ( j_1bbranch~bukrs  = j_1bnfdoc~bukrs
*         AND   j_1bbranch~branch = j_1bnfdoc~branch )
*    INNER JOIN adrc
*          ON ( adrc~addrnumber  = j_1bbranch~adrnr )
*        INTO TABLE @DATA(lt_doc)
*        FOR ALL ENTRIES IN @lt_guia_compl
*        WHERE j_1bnfdoc~docnum  =  @lt_guia_compl-docnum.
*      IF sy-subrc IS INITIAL.
*
*        SORT lt_doc BY docnum.
*
*        DATA(lt_doc_aux) = lt_doc[].
*        SORT lt_doc_aux BY regio region nbm.
*        DELETE ADJACENT DUPLICATES FROM lt_doc_aux COMPARING regio region nbm.
*        IF lt_doc_aux[] IS NOT INITIAL.
*          SELECT regiao_origem, regiao_destino, ncm, valor_fixo
*            FROM ztsd_gnret020
*            INTO TABLE @DATA(lt_gnret020)
*                    FOR ALL ENTRIES IN @lt_doc_aux
*            WHERE regiao_origem  = @lt_doc_aux-regio
*              AND regiao_destino = @lt_doc_aux-region
*              AND ncm            = @lt_doc_aux-nbm.
*          IF sy-subrc IS INITIAL.
*            SORT lt_gnret020 BY regiao_origem regiao_destino ncm.
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
*
    LOOP AT gt_outtab_guia_compl ASSIGNING FIELD-SYMBOL(<fs_s_guia_compl>) WHERE docnum IS NOT INITIAL.

      DATA(lv_tabix) = sy-tabix.

      IF NOT line_exists( lt_docnum[ table_line = <fs_s_guia_compl>-docnum ] ).
        lv_new   = abap_true.
        lv_compl = abap_true.
      ELSE.
        FREE: lv_new, lv_compl.
      ENDIF.
* Melhoria 5
*      DATA(lv_taxval_icms) = <fs_s_guia_compl>-taxval_icms.
*      READ TABLE lt_doc ASSIGNING FIELD-SYMBOL(<fs_doc>) WITH KEY docnum = <fs_s_guia_compl>-docnum
*                                                         BINARY SEARCH.
*      IF <fs_doc> IS ASSIGNED.
**        IF <fs_doc>-taxtyp = 'ICVA'.
**
**          READ TABLE lt_gnret020 ASSIGNING FIELD-SYMBOL(<fs_gnret020>) WITH KEY regiao_origem  = <fs_doc>-regio
**                                                                           regiao_destino = <fs_doc>-region
**                                                                           ncm            = <fs_doc>-nbm
**                                                           BINARY SEARCH.
**          IF <fs_gnret020> IS ASSIGNED.
***            lv_taxval_icms = <fs_gnret020>-valor_fixo.
**
**          ENDIF.
**        ENDIF.
*      ENDIF.
      TRY.
          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao(
            iv_docnum    = <fs_s_guia_compl>-docnum
            iv_tpprocess = zclsd_gnre_automacao=>gc_tpprocess-manual
            iv_new       = lv_new
            iv_guiacompl = lv_compl ).

          lr_gnre_automacao->add_guia_compl( iv_taxtyp_icms = <fs_s_guia_compl>-taxtyp_icms
* Melhoria 5
                                             iv_taxval_icms = <fs_s_guia_compl>-taxval_icms
*                                             iv_taxval_icms = lv_taxval_icms
                                             iv_taxtyp_fcp  = <fs_s_guia_compl>-taxtyp_fcp
                                             iv_taxval_fcp  = <fs_s_guia_compl>-taxval_fcp ).

          lr_gnre_automacao->persist( ).
          lr_gnre_automacao->free( ).

          COMMIT WORK AND WAIT.

          DELETE gt_outtab_guia_compl INDEX lv_tabix.
          CONTINUE.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          lv_error_docnum = <fs_s_guia_compl>-docnum.
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    IF lt_errors IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcxsd_gnre_automacao
        EXPORTING
          it_errors = lt_errors.
    ENDIF.

  ENDMETHOD.

  METHOD disable_guia.

    DATA: lt_errors TYPE zcxsd_gnre_automacao=>ty_t_errors,
          lv_answer.

    go_alv_grid_top->get_selected_rows(
      IMPORTING
        et_index_rows = DATA(lt_index_rows)
    ).

    DELETE lt_index_rows WHERE rowtype IS NOT INITIAL.

    IF lt_index_rows IS INITIAL.
      "Nenhuma linha válida, foi selecionada.
      MESSAGE s007 DISPLAY LIKE 'E'.
      RETURN.
    ENDIF.

    "Deseja inutilizar o(s) documento(s) selecionado(s)?
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = TEXT-003
        display_cancel_button = ''
      IMPORTING
        answer                = lv_answer
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    IF lv_answer <> '1'.
      RETURN.
    ENDIF.

    DATA(lt_outtab_top_sel) = VALUE ty_t_outtab_top( FOR <fs_s_index_row> IN lt_index_rows
                                                       LET ls_outtab_top = gt_outtab_top[ <fs_s_index_row>-index ] IN
                                                         ( ls_outtab_top ) ).
    SORT lt_outtab_top_sel BY docnum.
    DATA(lt_outtab_top_sel_aux) = lt_outtab_top_sel.
    DELETE ADJACENT DUPLICATES FROM lt_outtab_top_sel_aux COMPARING docnum.

    "Percorre os registros selecionados
    LOOP AT lt_outtab_top_sel_aux ASSIGNING FIELD-SYMBOL(<fs_s_outtab_sel_aux>).

      TRY.
          DATA(lr_gnre_automacao) = NEW zclsd_gnre_automacao( <fs_s_outtab_sel_aux>-docnum ).

          READ TABLE lt_outtab_top_sel TRANSPORTING NO FIELDS WITH KEY docnum = <fs_s_outtab_sel_aux>-docnum BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            LOOP AT lt_outtab_top_sel ASSIGNING FIELD-SYMBOL(<fs_s_outtab_sel>) FROM sy-tabix.

              IF <fs_s_outtab_sel>-docnum <> <fs_s_outtab_sel_aux>-docnum.
                EXIT.
              ENDIF.

              lr_gnre_automacao->disable_guia( <fs_s_outtab_sel>-docguia ).
              lr_gnre_automacao->persist( ).
              COMMIT WORK.

            ENDLOOP.

          ENDIF.

          lr_gnre_automacao->free( ).
          COMMIT WORK.

        CATCH zcxsd_gnre_automacao INTO DATA(lr_cx_gnre_automacao).
          APPEND lr_cx_gnre_automacao TO lt_errors.
      ENDTRY.

    ENDLOOP.

    "Exibe os erros
    IF lt_errors IS NOT INITIAL.
      NEW zcxsd_gnre_automacao( it_errors = lt_errors )->display( ).
    ENDIF.

  ENDMETHOD.
  METHOD user_command_9004.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.
        IF ( zssd_gnree011-hkont_icmsst IS INITIAL
          AND zssd_gnree011-taxval_icmsst IS NOT INITIAL )
          OR ( zssd_gnree011-hkont_icmsst IS NOT INITIAL
          AND zssd_gnree011-taxval_icmsst IS INITIAL ).
          LEAVE TO SCREEN 9005.

        ELSEIF ( zssd_gnree011-hkont_fcp IS INITIAL
         AND zssd_gnree011-taxval_fcp IS NOT INITIAL )
         OR ( zssd_gnree011-hkont_fcp IS NOT INITIAL
         AND zssd_gnree011-taxval_fcp IS INITIAL ).
          LEAVE TO SCREEN 9006.

        ELSEIF ( zssd_gnree011-hkont_multa IS INITIAL
         AND zssd_gnree011-taxval_multa IS NOT INITIAL )
         OR ( zssd_gnree011-hkont_multa IS NOT INITIAL
        AND zssd_gnree011-taxval_multa IS INITIAL ).
          LEAVE TO SCREEN 9007.

        ELSEIF ( zssd_gnree011-hkont_juros IS INITIAL
           AND zssd_gnree011-taxval_juros IS NOT INITIAL )
            OR ( zssd_gnree011-hkont_juros IS NOT INITIAL
           AND zssd_gnree011-taxval_juros IS INITIAL ).
          LEAVE TO SCREEN 9008.

        ELSE.
          LEAVE TO SCREEN 9009.
        ENDIF.


    ENDCASE.

  ENDMETHOD.

  METHOD user_command_9005.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.

        CALL SCREEN 9004.

    ENDCASE.

  ENDMETHOD.
  METHOD user_command_9006.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.

        CALL SCREEN 9004.

    ENDCASE.

  ENDMETHOD.
  METHOD user_command_9007.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.

        CALL SCREEN 9004.

    ENDCASE.

  ENDMETHOD.
  METHOD user_command_9008.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.

        CALL SCREEN 9004.

    ENDCASE.

  ENDMETHOD.
  METHOD user_command_9009.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'CANCEL'.

        LEAVE TO SCREEN 0.

      WHEN 'ENTER'.

        preenche_alv( ).

        CALL SCREEN 9010.

    ENDCASE.

  ENDMETHOD.

  METHOD set_data_9010.

    init_objects_9010( ).

    display_alv_9010( ).

  ENDMETHOD.
  METHOD user_command_9010.

    DATA(lv_ucomm) = sy-ucomm.

    CASE lv_ucomm.

      WHEN 'BACK' OR 'CANCEL'.
        go_alv_grid_popup->free( ).
        go_manual_popup->free( ).
        FREE: go_alv_grid_popup, go_manual_popup.
        LEAVE TO SCREEN 0.

      WHEN 'EXIT'.
        LEAVE PROGRAM.

    ENDCASE.

  ENDMETHOD.

  METHOD popup_confirm.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        text_question         = Text-005
        display_cancel_button = ''
      IMPORTING
        answer                = gv_ans
      EXCEPTIONS
        text_not_found        = 1
        OTHERS                = 2.

    if sy-subrc <> 0.
      MESSAGE id sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

    IF gv_ans EQ '1'.
      CALL SCREEN 9004 STARTING AT 10 08
                       ENDING AT 70 30.
    ENDIF.

  ENDMETHOD.
  METHOD preenche_alv.

    DATA ls_gnret001 TYPE ztsd_gnret001.

    FREE gt_outtab_popup.

    SELECT j_1bnfdoc~docnum,
           j_1bnfdoc~series,
           j_1bnfdoc~bukrs,
           j_1bnfdoc~branch,
           j_1bnfdoc~parid,
           j_1bnfdoc~nfenum,
            j_1bnfdoc~docstat,
           j_1bnfdoc~name1,
           j_1bnflin~refkey,
           j_1bnflin~werks,
           vbrk~fkart,
           vbrp~aubel,
           vbak~auart,
           t001w~regio,
           kna1~regio AS region
      FROM j_1bnfdoc
  INNER JOIN j_1bnflin
        ON ( j_1bnflin~docnum = j_1bnfdoc~docnum )
              INNER JOIN vbrk
        ON ( j_1bnflin~refkey = vbrk~vbeln  )
  INNER JOIN vbrp
        ON ( j_1bnflin~refkey = vbrp~vbeln  )
  INNER JOIN vbak
        ON ( vbrp~aubel  = vbak~vbeln )
  INNER JOIN t001w
        ON ( j_1bnflin~werks  = t001w~werks )
  INNER JOIN kna1
        ON ( j_1bnfdoc~parid  = kna1~kunnr )
      INTO TABLE @DATA(lt_dados)
      WHERE j_1bnfdoc~docnum  =  @zssd_gnree011-docnum.
    IF sy-subrc IS INITIAL.

      DATA(ls_dados) = lt_dados[ 1 ].

      zssd_gnree011-empresa         = ls_dados-bukrs.
      zssd_gnree011-local_negocio   = ls_dados-branch.
      zssd_gnree011-emissor         = ls_dados-regio.
      zssd_gnree011-recebedor       = ls_dados-region.
      zssd_gnree011-cod_status      = ls_dados-docstat.
      zssd_gnree011-nf9             = ls_dados-nfenum.
      zssd_gnree011-serie           = ls_dados-series.
      zssd_gnree011-id_parceiro     = ls_dados-parid.
      zssd_gnree011-nome_parceiro   = ls_dados-name1.
      zssd_gnree011-ref_doc_origem  = ls_dados-refkey.
      zssd_gnree011-tp_faturamento  = ls_dados-fkart.
      zssd_gnree011-doc_vendas      = ls_dados-aubel.
      zssd_gnree011-tipo_doc_vendas = ls_dados-auart.

      APPEND INITIAL LINE TO gt_outtab_popup ASSIGNING FIELD-SYMBOL(<fs_s_outtab_popup>).

      MOVE-CORRESPONDING zssd_gnree011 TO <fs_s_outtab_popup>.

      MOVE-CORRESPONDING zssd_gnree011 TO ls_gnret001.

      IF ls_gnret001 IS NOT INITIAL .

        MODIFY ztsd_gnret001 FROM ls_gnret001.

      ENDIF.
    ELSE.
      "Docnum não encontrado.
      MESSAGE TEXT-004 TYPE 'E' .
    ENDIF.

    MOVE-CORRESPONDING zssd_gnree011 TO <fs_s_outtab_popup>.

  ENDMETHOD.
  METHOD init_objects_9010.
    "Container do popup de popup
    IF go_manual_popup IS NOT BOUND.
      go_manual_popup  = NEW #( container_name = 'CONTAINER_9010' ).
    ENDIF.

    "Inicializa o objeto do ALV com seus respectivos containers
    IF go_alv_grid_popup IS NOT BOUND.
      go_alv_grid_popup = NEW #( i_parent = go_manual_popup ).
    ENDIF.
  ENDMETHOD.
  METHOD display_alv_9010.

    DATA: ls_layout    TYPE lvc_s_layo,
          lt_fieldcat  TYPE lvc_t_fcat,
          lt_excluding TYPE ui_functions.

    ls_layout-zebra    = abap_true.
    ls_layout-edit     = abap_true.
    ls_layout-sel_mode = 'A'.

    lt_excluding = VALUE #( ( cl_gui_alv_grid=>mc_fc_info  )
                            ( cl_gui_alv_grid=>mc_fc_graph )
                            ( cl_gui_alv_grid=>mc_fc_print )
                            ( cl_gui_alv_grid=>mc_fc_views ) ).

    CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
      EXPORTING
        i_structure_name       = 'ZSSD_GNREE011'
      CHANGING
        ct_fieldcat            = lt_fieldcat
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    go_alv_grid_popup->set_ready_for_input( ).

    go_alv_grid_popup->register_edit_event( cl_gui_alv_grid=>mc_evt_enter ).

    go_alv_grid_popup->set_table_for_first_display(
      EXPORTING
        i_save               = 'A'
        is_layout            = ls_layout
        it_toolbar_excluding = lt_excluding
      CHANGING
        it_outtab            = gt_outtab_popup
        it_fieldcatalog      = lt_fieldcat
    ).

  ENDMETHOD.
ENDCLASS.
