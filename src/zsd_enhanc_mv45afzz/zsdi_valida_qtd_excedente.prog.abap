***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Validação da quantidade excedente                      *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 01/03/2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************

    CONSTANTS: BEGIN OF lc_param,
                 modulo TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1 TYPE ztca_param_par-chave1 VALUE 'VALIDA_QTD_EXCEDENTE',
                 chave2 TYPE ztca_param_par-chave2 VALUE 'AUART',
               END OF lc_param.

    DATA lt_auart TYPE shp_auart_range_t.


    REFRESH: lt_vbfa,
             lt_vbfa_sum,
             lt_vbrp,
             lt_xvbap.

    CLEAR: ls_vbfa_sum,
           lv_qtdispfat,
           lv_menge,
           lv_quantidade,
           lv_tabix.

    UNASSIGN: <fs_vbrp>,
              <fs_vbfa>,
              <fs_vbfa_sum>.


    DATA(lo_param) = NEW zclca_tabela_parametros( ).
    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = lc_param-modulo
                                         iv_chave1 = lc_param-chave1
                                         iv_chave2 = lc_param-chave2
                               IMPORTING et_range  = lt_auart ).
        IF vbak-auart IN lt_auart.

          IF ( sy-tcode     EQ 'VA01'   OR   "Criação
               sy-tcode     EQ 'VA02' ) AND  "Modificação
             ( fcode        EQ 'SICH'   OR   "Salvar
               fcode        EQ 'SIBA' ).     "Encerrar

            IF NOT vvbrp[] IS INITIAL.

              lt_vbrp = vvbrp[].
              lt_xvbap = xvbap[].
              DELETE lt_xvbap WHERE mill_updkz EQ 'D'.
              DELETE lt_xvbap WHERE abgru NE space.
              SORT lt_xvbap BY vbeln posnr.

              LOOP AT lt_vbrp ASSIGNING <fs_vbrp>.
                lv_tabix = sy-tabix.
                IF NOT line_exists( lt_xvbap[ vgpos = <fs_vbrp>-posnr ] ).
                  DELETE lt_vbrp INDEX lv_tabix.
                ENDIF.
              ENDLOOP.

              SORT lt_vbrp BY vbeln posnr.

              IF NOT lt_vbrp[] IS INITIAL.

                SELECT a~vbelv a~posnv a~vbeln a~posnn a~matnr a~meins a~rfmng
                  FROM vbfa AS a
                  INNER JOIN vbap AS b ON a~vbeln = b~vbeln
                                      AND a~posnn = b~posnr
                  INTO TABLE lt_vbfa
                  FOR ALL ENTRIES IN lt_vbrp
                    WHERE a~vbelv   EQ lt_vbrp-vbeln
                      AND a~posnv   EQ lt_vbrp-posnr
                      AND b~abgru   EQ space.
                IF sy-subrc EQ 0.

                  LOOP AT lt_vbfa ASSIGNING <fs_vbfa>.
                    UNASSIGN <fs_xvbap>.
                    READ TABLE lt_xvbap ASSIGNING <fs_xvbap>
                    WITH KEY vbeln = <fs_vbfa>-vbeln
                             posnr = <fs_vbfa>-posnn BINARY SEARCH.
*** Flávia leite- 8000007739 - 23.05.2023
                    IF <fs_xvbap> IS NOT ASSIGNED AND sy-tcode EQ 'VA01'.
                      READ TABLE lt_xvbap ASSIGNING <fs_xvbap>
                      WITH KEY posnr = <fs_vbfa>-posnn BINARY SEARCH.
                    ENDIF.

                    IF <fs_xvbap> IS ASSIGNED.
*                    IF sy-subrc EQ 0.
*** Flávia leite- 8000007739 - 23.05.2023
                      IF <fs_vbfa>-meins <> <fs_xvbap>-zieme.

                        lv_quantidade = <fs_vbfa>-rfmng.

                        CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
                          EXPORTING
                            i_matnr              = <fs_xvbap>-matnr
                            i_in_me              = <fs_vbfa>-meins
                            i_out_me             = <fs_xvbap>-zieme
                            i_menge              = lv_quantidade
                          IMPORTING
                            e_menge              = lv_menge
                          EXCEPTIONS
                            error_in_application = 1
                            error                = 2
                            OTHERS               = 3.

                        IF sy-subrc EQ 0.
                          <fs_vbfa>-rfmng = lv_menge.
                        ENDIF.
                      ENDIF.

                      IF <fs_xvbap>-kwmeng > <fs_vbfa>-rfmng.
                        <fs_vbfa>-rfmng = <fs_xvbap>-kwmeng.
                      ELSEIF <fs_xvbap>-kwmeng < <fs_vbfa>-rfmng.
                        <fs_vbfa>-rfmng = <fs_vbfa>-rfmng - <fs_xvbap>-kwmeng.
                      ENDIF.
                    ENDIF.
                    MOVE-CORRESPONDING <fs_vbfa> TO ls_vbfa_sum.
                    COLLECT ls_vbfa_sum INTO lt_vbfa_sum.
                  ENDLOOP.

                  SORT lt_vbfa_sum BY vbelv posnv.

                ENDIF.

                LOOP AT lt_xvbap ASSIGNING <fs_xvbap>.
                  CLEAR lv_qtdispfat.

                  READ TABLE lt_vbrp ASSIGNING <fs_vbrp>
                  WITH KEY vbeln = <fs_xvbap>-vgbel
                           posnr = <fs_xvbap>-vgpos BINARY SEARCH.
                  IF sy-subrc NE 0.
                    MESSAGE i003(zsd) WITH |{ <fs_xvbap>-posnr ALPHA = OUT }| cvbrp-vbeln DISPLAY LIKE 'E'.
                    PERFORM folge_gleichsetzen(saplv00f).
                    fcode = 'ENT1'.
                    SET SCREEN syst-dynnr.
                    LEAVE SCREEN.
                  ENDIF.

                  READ TABLE lt_vbfa_sum ASSIGNING <fs_vbfa_sum>
                  WITH KEY vbelv = <fs_xvbap>-vgbel
                           posnv = <fs_xvbap>-vgpos BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    lv_qtdispfat = <fs_vbrp>-fkimg - <fs_vbfa_sum>-rfmng.
                  ELSE.
                    lv_qtdispfat = <fs_vbrp>-fkimg.
                  ENDIF.

                  IF sy-tcode EQ 'VA02'.
                    IF lv_qtdispfat LT 0.
                    ELSEIF lv_qtdispfat LE <fs_vbrp>-fkimg.
                      CONTINUE.
                    ENDIF.
                  ENDIF.

                  IF <fs_xvbap>-kwmeng GT lv_qtdispfat.
                    MESSAGE i010(zsd) WITH |{ <fs_xvbap>-vgpos ALPHA = OUT }| DISPLAY LIKE 'E'.
                    PERFORM folge_gleichsetzen(saplv00f).
                    fcode = 'ENT1'.
                    SET SCREEN syst-dynnr.
                    LEAVE SCREEN.
                  ENDIF.

                ENDLOOP.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      CATCH zcxca_tabela_parametros.
    ENDTRY.
