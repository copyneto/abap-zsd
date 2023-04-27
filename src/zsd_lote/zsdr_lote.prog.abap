***********************************************************************
***                           © 3corações                           ***
***********************************************************************
*** ZSDR_LOTE                                                         *
*** DESCRIÇÃO: Atualização determinação de lote no fornecimento.      *
*** AUTOR : Luiz Carlos M. Timbó Jr.                                  *
*** FUNCIONAL: Jeferson Bezerra – DKunc                               *
*** DATA : 29.03.2023                                                 *
***********************************************************************
*** HISTÓRICO DAS MODIFICAÇÕES                                        *
***-------------------------------------------------------------------*
*** DATA | AUTOR | DESCRIÇÃO                                          *
***-------------------------------------------------------------------*
*** | |                                                               *
***********************************************************************
REPORT zsdr_lote.
TABLES likp.

CLASS lcl_main DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_display_all TYPE flag,
      start_process IMPORTING ir_vbeln TYPE msr_t_insp_vbeln_vl_range,
      print_result.

  PRIVATE SECTION.
    TYPES: BEGIN OF ty_log,
             vbeln   TYPE vbeln_vl,
             messtab TYPE tab_bdcmsgcoll,
           END OF ty_log.

    DATA: gs_params TYPE ctu_params,
          gt_log    TYPE TABLE OF ty_log.

    METHODS:
      call_vl02n IMPORTING it_bdcdata TYPE tab_bdcdata
                 EXPORTING et_messtab TYPE tab_bdcmsgcoll.
ENDCLASS.

*--------------------------------------------------------------------*
* Tela de Seleção
*--------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS s_vbeln FOR likp-vbeln NO INTERVALS MODIF ID obl.
SELECTION-SCREEN END OF BLOCK b1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_visi AS CHECKBOX.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-group1 = 'OBL'.
      screen-required = '2'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

*--------------------------------------------------------------------*
* Processamento
*--------------------------------------------------------------------*
START-OF-SELECTION.
  IF s_vbeln[] IS INITIAL.
    MESSAGE s055(00) DISPLAY LIKE 'E'.
  ELSE.
    DATA(lr_main) = NEW lcl_main( p_visi ).
    lr_main->start_process( s_vbeln[] ).
    lr_main->print_result( ).
  ENDIF.

CLASS lcl_main IMPLEMENTATION.
  METHOD constructor.
    CASE iv_display_all.
      WHEN abap_true.  gs_params-dismode = 'A'. "Exibir todas as telas
      WHEN abap_false. gs_params-dismode = 'N'. "Processar em background
    ENDCASE.
    gs_params-updmode = 'A'.
    gs_params-defsize = 'X'.
  ENDMETHOD.
  METHOD start_process.
    DATA lt_bdcdata TYPE tab_bdcdata.

    SELECT lips~vbeln, lips~posnr, likp~wbstk, lips~wbsta
      FROM lips INNER JOIN likp ON likp~vbeln = lips~vbeln
      INTO TABLE @DATA(lt_lips)
      WHERE likp~vbeln IN @ir_vbeln
        AND lips~uecha EQ '000000'
        "AND lips~charg EQ @space
        "AND lips~xchar EQ @abap_true
      ORDER BY lips~vbeln, lips~posnr.

    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).
      AT NEW vbeln.
        CLEAR lt_bdcdata[].
        APPEND VALUE #( program = 'SAPMV50A' dynpro = '4004' dynbegin = 'X' ) TO lt_bdcdata.
        APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=ENT2' ) TO lt_bdcdata.
        APPEND VALUE #( fnam = 'LIKP-VBELN' fval = <fs_lips>-vbeln ) TO lt_bdcdata.
      ENDAT.

      APPEND VALUE #( program = 'SAPMV50A' dynpro = '1000' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=POPO_T' ) TO lt_bdcdata.

      APPEND VALUE #( program = 'SAPMV50A' dynpro = '0111' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE'  fval = '=WEIT' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'RV50A-POSNR' fval = <fs_lips>-posnr ) TO lt_bdcdata.

      APPEND VALUE #( program = 'SAPMV50A' dynpro = '1000' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=CHSP_T' ) TO lt_bdcdata.

      APPEND VALUE #( program = 'SAPMV50A' dynpro = '3000' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=CHFD_T' ) TO lt_bdcdata.

      APPEND VALUE #( program = 'SAPLV01F' dynpro = '0100' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=TAKE' ) TO lt_bdcdata.

      APPEND VALUE #( program = 'SAPMV50A' dynpro = '3000' dynbegin = 'X' ) TO lt_bdcdata.
      APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=BACK_T' ) TO lt_bdcdata.

      AT END OF vbeln.
        APPEND VALUE #( program = 'SAPMV50A' dynpro = '1000' dynbegin = 'X' ) TO lt_bdcdata.
        APPEND VALUE #( fnam = 'BDC_OKCODE' fval = '=SICH_T' ) TO lt_bdcdata.

        call_vl02n( EXPORTING it_bdcdata = lt_bdcdata[]
                    IMPORTING et_messtab = DATA(lt_messtab) ).

        APPEND VALUE #( vbeln = <fs_lips>-vbeln messtab = lt_messtab ) TO gt_log.
        CLEAR lt_messtab[].
      ENDAT.
    ENDLOOP.
  ENDMETHOD.
  METHOD call_vl02n.
    CHECK it_bdcdata[] IS NOT INITIAL.
    CALL TRANSACTION 'VL02N' USING it_bdcdata[]
                             OPTIONS FROM gs_params
                             MESSAGES INTO et_messtab[].
  ENDMETHOD.
  METHOD print_result.
    DATA lv_text TYPE string.
    WRITE:/ |Usuário: { sy-uname }. Data de processamento: { sy-datum DATE = USER } - { sy-uzeit TIME = USER } | ##NO_TEXT .
    ULINE.

    LOOP AT gt_log ASSIGNING FIELD-SYMBOL(<fs_return>).
      WRITE:/ |Documento: { <fs_return>-vbeln } | ##NO_TEXT .

      LOOP AT <fs_return>-messtab ASSIGNING FIELD-SYMBOL(<fs_message>). "#EC CI_NESTED
        CLEAR lv_text.
        MESSAGE ID <fs_message>-msgid TYPE <fs_message>-msgtyp NUMBER <fs_message>-msgnr
                WITH <fs_message>-msgv1 <fs_message>-msgv2 <fs_message>-msgv3 <fs_message>-msgv4
                INTO lv_text.
        WRITE AT /30 | { lv_text } |.
      ENDLOOP.
      ULINE.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
