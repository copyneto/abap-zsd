***********************************************************************
***                           © 3corações                           ***
***********************************************************************
***                                                                   *
*** DESCRIÇÃO: Validação da quantidade disponível na fatura           *
*** AUTOR : Luís Gustavo Schepp – META                                *
*** FUNCIONAL: Sandro Seixas Schanchinski – META                      *
*** DATA : 29/06/2022                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA       | AUTOR        | DESCRIÇÃO                             *
***-------------------------------------------------------------------*
***   /  /     |              |                                       *
***********************************************************************

TYPES: BEGIN OF ty_vbfa,
         vbelv TYPE vbfa-vbelv,
         posnv TYPE vbfa-posnv,
         vbeln TYPE vbfa-vbeln,
         posnn TYPE vbfa-posnn,
         matnr TYPE vbfa-matnr,
         meins TYPE vbfa-meins,
         rfmng TYPE vbfa-rfmng,
       END OF ty_vbfa,

       BEGIN OF ty_vbfa_sum,
         vbelv TYPE vbfa-vbelv,
         posnv TYPE vbfa-posnv,
         rfmng TYPE vbfa-rfmng,
       END OF ty_vbfa_sum.

DATA: lt_vbfa     TYPE TABLE OF ty_vbfa,
      lt_vbfa_sum TYPE TABLE OF ty_vbfa_sum.

DATA: ls_vbfa_sum  TYPE ty_vbfa_sum,
      lv_qtdispfat TYPE rfmng.

DATA: lv_menge      TYPE j_1bnetqty,
      lv_quantidade TYPE bstmg.

IF ( sy-tcode     EQ 'VA01'   OR   "Criação
     sy-tcode     EQ 'VA02' ) AND  "Modificação
     vbfa-vbtyp_n EQ 'H'      AND  "Devoluções
   ( fcode        EQ 'SICH'   OR   "Salvar
     fcode        EQ 'SIBA' ).     "Encerrar

  IF NOT vvbrp[] IS INITIAL.

    DATA(lt_vbrp) = vvbrp[].
    DATA(lt_xvbap) = xvbap[].
    DELETE lt_xvbap WHERE mill_updkz EQ 'D'.
    DELETE lt_xvbap WHERE abgru NE space.
    SORT lt_xvbap BY vbeln posnr.

    LOOP AT lt_vbrp ASSIGNING FIELD-SYMBOL(<fs_vbrp>).
      DATA(lv_tabix) = sy-tabix.
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
            AND a~vbtyp_n EQ 'H'
            AND b~abgru   EQ space.
      IF sy-subrc EQ 0.

        LOOP AT lt_vbfa ASSIGNING FIELD-SYMBOL(<fs_vbfa>).
          READ TABLE lt_xvbap ASSIGNING <fs_xvbap>
          WITH KEY vbeln = <fs_vbfa>-vbeln
                   posnr = <fs_vbfa>-posnn BINARY SEARCH.
          IF sy-subrc EQ 0.


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

        READ TABLE lt_vbfa_sum ASSIGNING FIELD-SYMBOL(<fs_vbfa_sum>)
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
          MESSAGE i004(zsd) WITH |{ <fs_xvbap>-vgpos ALPHA = OUT }| lv_qtdispfat DISPLAY LIKE 'E'.
          PERFORM folge_gleichsetzen(saplv00f).
          fcode = 'ENT1'.
          SET SCREEN syst-dynnr.
          LEAVE SCREEN.
        ENDIF.

      ENDLOOP.

    ENDIF.

  ENDIF.

ENDIF.

*TYPES: BEGIN OF ty_vbfa,
*         posnv TYPE posnr_von,
*         rfmng TYPE rfmng,
*       END OF ty_vbfa,
*
*       tt_vbfa TYPE TABLE OF ty_vbfa.
*
*DATA: lt_venda     TYPE tt_vbfa,
*      lt_devol     TYPE tt_vbfa,
*      lt_devol_col TYPE tt_vbfa.
*
*CONSTANTS lc_vbtyp_v LIKE vbfa-vbtyp_v VALUE 'C'.
*
*IF sy-uname EQ 'SEIXASS'.
*
*  SELECT posnv rfmng
*    FROM vbfa
*    INTO TABLE lt_venda
*    WHERE vbtyp_v = lc_vbtyp_v
*      AND vbeln = vbfa-vbelv.
*
*  IF sy-subrc EQ 0.
*    SELECT posnv rfmng
*      FROM vbfa
*      INTO TABLE lt_devol
*      WHERE vbtyp_n = vbfa-vbtyp_n
*        AND vbelv   = vbfa-vbelv.
*    IF sy-subrc EQ 0.
*      LOOP AT lt_devol ASSIGNING FIELD-SYMBOL(<fs_devol>).
*        COLLECT <fs_devol> INTO lt_devol_col.
*      ENDLOOP.
*      LOOP AT lt_venda ASSIGNING FIELD-SYMBOL(<fs_venda>).
*        TRY.
*            DATA(lv_rfmng) = lt_devol_col[ posnv = <fs_venda>-posnv ]-rfmng.
*            TRY.
*                DATA(lv_kwmeng) = xvbap[ posnr = <fs_venda>-posnv ]-kwmeng.
*                ADD lv_kwmeng TO lv_rfmng.
*              CATCH cx_sy_itab_line_not_found.
*            ENDTRY.
*            IF lv_rfmng GE <fs_venda>-rfmng.
*              MESSAGE i000(zsd).
*              gf_exit_save_document_prepare = abap_true.
**              LEAVE TO TRANSACTION sy-tcode. "retornar p a transação atual
*            ELSE.
**              CHECK i_screen_name EQ 'RV45A-KWMENG'.
**              c_screen_input = 0.
*            ENDIF.
*          CATCH cx_sy_itab_line_not_found.
*        ENDTRY.
*      ENDLOOP.
*    ENDIF.
*  ENDIF.
*ENDIF.
